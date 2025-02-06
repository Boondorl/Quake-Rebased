/*
	Copyright (C) 1996-1997  Id Software, Inc.

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    See file, 'COPYING', for details.
*/

const vector TL_OFS	= { AABB_MIN.x + 1.0, AABB_MAX.y - 1.0, 0.0 };
const vector TR_OFS	= { AABB_MAX.x - 1.0, AABB_MAX.y - 1.0, 0.0 };
const vector BR_OFS	= { AABB_MAX.x - 1.0, AABB_MIN.y + 1.0, 0.0 };
const vector BL_OFS	= { AABB_MIN.x + 1.0, AABB_MIN.y + 1.0, 0.0 };

// General line of sight checking function to see if there's a valid path
// to the thing being attacked
bool_t CanDamage(entity e, entity targ)
{
	// bmodels need special checking because their origin is 0,0,0
	vector orig = e.solid == SOLID_BSP ? GetCenter(e) : e.origin;
	if (targ.solid == SOLID_BSP)
	{
		TraceLineEx(orig, GetCenter(targ), MOVE_NOMONSTERS, e);
		return trace_fraction == 1.0 || trace_ent == targ;
	}
	
	TraceLineEx(orig, targ.origin, MOVE_NOMONSTERS, e);
	if (trace_fraction == 1.0)
		return TRUE;

	// Check all corners of the AABB this time for more precise results
	for (int_t i; i < 3; ++i)
	{
		float zOfs;
		if (i == 1)
			zOfs = AABB_MIN.z + 1.0;
		else if (i == 2)
			zOfs = AABB_MAX.z - 1.0;
		
		TraceLineEx(orig, targ.origin + [TL_OFS.x, TL_OFS.y, zOfs], MOVE_NOMONSTERS, e);
		if (trace_fraction == 1.0)
			return TRUE;
		
		TraceLineEx(orig, targ.origin + [TR_OFS.x, TR_OFS.y, zOfs], MOVE_NOMONSTERS, e);
		if (trace_fraction == 1.0)
			return TRUE;
		
		TraceLineEx(orig, targ.origin + [BR_OFS.x, BR_OFS.y, zOfs], MOVE_NOMONSTERS, e);
		if (trace_fraction == 1.0)
			return TRUE;
		
		TraceLineEx(orig, targ.origin + [BL_OFS.x, BL_OFS.y, zOfs], MOVE_NOMONSTERS, e);
		if (trace_fraction == 1.0)
			return TRUE;
	}

	return FALSE;
}

void Killed(entity e, entity inflictor, entity attacker)
{
	if (e.takedamage == DAMAGE_NO || e.takedamage == DAMAGE_USE || e.health >= 1)
		return;

	ClearInventory(e);
	
	e.touch = __NULL__;
	e.takedamage = DAMAGE_NO;
	
	if (IsClient(e))
		PlayerKilled(e, inflictor, attacker);
	else if (IsMonster(e))
		MonsterKilled(e, inflictor, attacker);
	
	ActivateEntity(e, attacker);
	if (e.th_die)
		InvokeActivation(e, attacker, e.th_die);
	else
		DestroyEntity(e);
}

bool_t TryPain(entity e, entity inflictor, entity attacker, int_t damage)
{
	if (!e.th_pain)
		return FALSE;
	
	entity curSelf = self;
	self = e;
	bool_t res = self.th_pain(inflictor, attacker, damage);
	self = curSelf;
	
	if (res && IsMonster(e))
		e.state = AS_STRAIGHT;
	
	return res;
}

enumflags
{
	DMG_NO_ARMOR,
	DMG_NO_PAIN,
	DMG_NO_QUAD,
	DMG_NO_THRUST,
	DMG_NO_INVULN,
};

const int_t DMG_FORCE = DMG_NO_ARMOR | DMG_NO_QUAD | DMG_NO_INVULN;

// Return value of -1 means that no damage was taken at all
int_t DamageEntity(entity e, entity inflictor, entity attacker, int_t damage, flags_t dmgFlags = 0)
{
	// Team play damage avoidance
	if (damage < 0 || e.takedamage == DAMAGE_NO
		|| (teamplay == TDM_MODERN && e.team > 0 && attacker && attacker != e && e.team == attacker.team))
	{
		return -1;
	}
	
	// Check for quad damage powerup on the attacker
	if (attacker && !(dmgFlags & DMG_NO_QUAD))
	{
		int_t multi = GetItemAmount(attacker, ITEM_DMG);
		if (multi > 1)
			damage *= multi;
	}
	
	// New damage types specifically for level geometry since the old method is...questionable
	// Also stops things like doors and buttons from bleeding.
	if (e.takedamage == DAMAGE_USE)
	{
		if (!(e.flags & FL_MUST_GIB) || damage >= e.health)
			e.health -= damage;
		
		if (e.health < 1)
		{
			if (e.use)
				InvokeActivation(e, attacker, e.use);
			
			e.health = e.max_health;
		}
		
		return -1;
	}
	else if (e.takedamage == DAMAGE_DESTRUCT || e.takedamage == DAMAGE_DESTRUCT_BLEED)
	{
		if (!(e.flags & FL_MUST_GIB) || damage >= e.health)
			e.health -= damage;
		
		if (e.health < 1)
		{
			Killed(e, inflictor, attacker);
		}
		else
		{
			// Generic pain noise playback
			if (e.noise1 && e.rand_val > 0.0 && (e.rand_val >= 1.0 || Random() < e.rand_val))
				PlaySound(e, CHAN_VOICE, e.noise1, 1.0, ATTN_NORM);
			
			TryPain(e, inflictor, attacker, damage);
		}
		
		return (e.takedamage == DAMAGE_DESTRUCT_BLEED) - 1;
	}
	
	// Knockback for clients needs to be done before any sort of damage reduction
	// to preserve the original velocity behavior
	if (inflictor && e.movetype == MOVETYPE_WALK && !(dmgFlags & DMG_NO_THRUST))
		e.velocity += Normalize(e.origin - GetCenter(inflictor)) * (damage * 8.0);
	
	// Nothing can ever damage something with god mode
	if (e.flags & FL_GODMODE)
		return -1;
	
	if (!(dmgFlags & DMG_NO_INVULN))
	{
		entity invuln = FindItem(e, ITEM_INVULN);
		if (invuln && invuln.amount >= 1)
		{
			if (TimerExpired(invuln.invincible_sound))
			{
				PlaySound(e, CHAN_ITEM, "items/protect3.wav", 1.0, ATTN_NORM);
				SetCoolDown(invuln, invincible_sound, 2.0);
			}
			
			return -1;
		}
	}
	
	int_t save;
	if (!(dmgFlags & DMG_NO_ARMOR))
		save = DepleteArmor(e, Ceil(damage * e.armortype));
	
	int_t take = Ceil(damage - save);
	if (take < 1 && save < 1)
		return -1;

	// Add to the damage total for clients, which will be sent as a single
	// message at the end of the frame
	if (IsClient(e))
	{
		e.dmg_take += take;
		e.dmg_save += save;
		e.dmg_inflictor = inflictor;
	}

	// Do the damage
	if (!(e.flags & FL_MUST_GIB) || take >= e.health)
	{
		e.health -= take;
		if (e.health < 1)
		{
			Killed(e, attacker, inflictor);
			return take;
		}
	}

	// React to the damage
	if ((e.flags & FL_MONSTER) && attacker && e != attacker && attacker != e.enemy
		&& (!(e.flags & FL_IGNORE_INFIGHT) || IsClient(attacker))
		&& ((e.flags & FL_INFIGHT_CLASS) || e.classname != attacker.classname)
		&& !(attacker.flags & FL_AVOID))
	{
		SetMonsterEnemy(e, attacker);
	}

	// Nightmare mode monsters don't get staggered as often
	if (!(dmgFlags & DMG_NO_PAIN) && TryPain(e, inflictor, attacker, take) && skill >= SK_NIGHTMARE && (e.flags & FL_MONSTER))
		SetCoolDown(e, pain_finished, 5.0);

	return take;
}

bool_t HealEntity(entity e, int_t heal, int_t maxHealth)
{
	if (heal < 0 || e.health < 1 || e.health >= maxHealth)
		return FALSE;

	e.health = Min(e.health + Ceil(heal), maxHealth);
	if (e.health > e.max_health)
		GiveItem(e, IT_ROT);
	
	return TRUE;
}

void RadiusAttack(entity inflictor, entity attacker, int_t maxDmg, int_t minDmg, float range, entity ignore)
{
	minDmg = Clamp(minDmg, 0, maxDmg);
	
	// Using a chain field is silly for this since recursive calls can break it, so spawn temporary entities instead to
	// store the data
	entity head;
	for (entity temp = GetEntitiesInRadius(inflictor.origin, range), prev; temp; temp = temp.chain)
	{
		if (temp == ignore || temp.takedamage == DAMAGE_NO)
			continue;
		
		float points = minDmg + ((maxDmg - minDmg) * (1.0 - Length(GetCenter(temp) - GetCenter(inflictor)) / range));
		// Entities do half damage to themselves
		if (temp == attacker)
			points *= 0.5;
		if (temp.flags & FL_EXPLOSIVE_RESIST)
			points *= 0.5;
		
		if (points < 1 || !CanDamage(inflictor, temp))
			continue;
		
		entity e = SpawnEntity();
		if (!head)
			head = e;
		
		e.enemy = temp;
		e.dmg = points;
		if (prev)
			prev.chain = e;
		prev = e;
	}
	
	// Do the actual radius damage
	while (head)
	{
		entity next = head.chain;
		
		DamageEntity(head.enemy, inflictor, attacker, head.dmg);
		
		RemoveEntity(head);
		head = next;
	}
}

entity SpawnMissile(entity e, void() type, vector pos, vector dir, float speed, vector aVel = VEC_ZERO, float lifeTime = 5.0)
{
	entity missile = SpawnEntityType(type, pos);
	missile.owner = e;
	missile.velocity = dir * speed;
	missile.angles = ToAngles(dir);
	missile.avelocity = aVel;
	missile.timer_finished = lifeTime;
	
	if (missile.noise1)
		PlaySound(missile, CHAN_VOICE, missile.noise1, 1.0, ATTN_NORM);
	
	return missile;
}

enumflags
{
	MISSILE_FLY,	// No gravity
	MISSILE_BOUNCE,	// Bounce off surfaces
	MISSILE_RIPPER,	// Tear through monsters instead of exploding
};

void StartMissile(entity e, string mod, bool_t bounce = FALSE)
{
	if (!e.touch)
		e.touch = P_MissileTouch;
	
	if (MapLoading())
	{
		PrecacheModel(mod);
		
		if (e.noise1)
			PrecacheSound(e.noise1);
		if (e.noise2)
			PrecacheSound(e.noise2);
		if (e.noise3)
			PrecacheSound(e.noise3);
	}
	
	e.flags |= FL_MISSILE;
	e.misc_action |= (bounce ? MISSILE_BOUNCE : MISSILE_FLY);
	
	SetPhysics(e, SOLID_BBOX, MOVETYPE_NONE);
	InitializeEntity(e, mod);
	
	SetNextThink(e, TIME_EPSILON, A_MissileThink);
}

// Generic touch function for missiles
void P_MissileTouch()
{
	if (!other && GetContentsAtPoint(self.origin) == CONTENTS_SKY)
	{
		DestroyEntity(self);
		return;
	}

	bool_t doRip = (self.misc_action & MISSILE_RIPPER) && CanRip(other);
	if (other.takedamage != DAMAGE_NO)
	{
		int_t damage = self.dmg;
		// Generalized Vore missile behavior
		if (self.max_health >= 1 && (other.flags & FL_MUST_GIB) && self.max_health >= other.health)
			damage = other.health;
		else if (self.rad_dmg >= 1 && (other.flags & FL_EXPLOSIVE_RESIST))
			damage *= 0.5;
		
		// Now explosive missiles will also bleed on impact!
		// For rippers, only count a hit if some kind of damage
		// was applied
		if (DamageEntity(other, self, self.owner, damage) >= 0)
		{
			SpawnBloodSpray(self.origin, self.velocity, self.dmg);
			if (!doRip)
			{
				self.deadflag = TE_INVALID;
			}
			else
			{
				entity e = SpawnEntity();
				e.owner = other;
				
				entity last = self;
				for (;last.destructible; last = last.destructible);
				last.destructible = e;
			}
		}
	}
	
	if (doRip)
		return;
	
	if (other.takedamage == DAMAGE_YES || other.takedamage == DAMAGE_AIM
		|| !(self.misc_action & MISSILE_BOUNCE) || (self.count >= 1 && --self.count < 1))
	{
		self.old_enemy = other;
		if (self.th_die)
			self.th_die();
		else
			A_ExplodeMissile();
		
		return;
	}
	
	// Bounce sound
	if (self.noise3)
		PlaySound(self, CHAN_BODY, self.noise3, 1.0, ATTN_NORM);
}

inline bool_t CanRip(entity e)
{
	return e && e.solid != SOLID_BSP;
}

// More or less a reimplementation of SV_Physics_Toss(). Includes a couple of oversight
// fixes for projectiles including:
// * Not bouncing off ramps correctly
// * Bouncing grenades missing pseudo hitboxes
// * Removal of max velocity check
// * Allows for ripper projectiles a la Heretic
// Note that this disables the use of real sizes. For that this function should
// be avoided entirely by setting .nextthink to 0 after calling StartMissile and
// manually setting the movetype to MOVETYPE_FLY/BOUNCE
void A_MissileThink()
{
	if (self.timer_finished > 0.0 && TimerExpired(self.timer_finished))
	{
		if (self.th_die)
			self.th_die();
		else
			DestroyEntity(self);
		
		return;
	}
	
	if (self.flags & FL_ONGROUND)
	{
		SetNextThink(self, TIME_EPSILON, A_MissileThink);
		return;
	}
	
	if (!(self.misc_action & MISSILE_FLY))
	{
		float g = self.gravity ? self.gravity : 1.0;
		self.velocity.z -= g * sv_gravity * frametime;
	}
	
	self.angles += self.avelocity * frametime;
	
	int_t type = MOVE_NORMAL;
	if (self.misc_action & (MISSILE_FLY | MISSILE_BOUNCE))
		type = MOVE_MISSILE;
	else if (self.solid == SOLID_TRIGGER || self.solid == SOLID_NOT)
		type = MOVE_NOMONSTERS;
	
	entity curSelf = self;
	entity curOther = other;
	
	vector end = self.origin + self.velocity * frametime;
	TraceLineEx(self.origin, end, type, self.owner);
	if ((self.misc_action & MISSILE_RIPPER) && CanRip(trace_ent))
	{
		for (entity curIgnore;;)
		{
			if (trace_ent != self.owner)
			{
				// Check to see if we already damaged it. If so, just
				// ignore it from now on for more consisten behavior
				entity it = self.destructible;
				for (; it; it = it.destructible)
				{
					if (it.owner == trace_ent)
						break;
				}
				
				if (!it)
				{
					SetOrigin(self, trace_endpos);
					if (self.touch && self.solid != SOLID_NOT)
					{
						other = trace_ent;
						self.touch();
					}

					if (trace_ent.touch && trace_ent.solid != SOLID_NOT)
					{
						self = trace_ent;
						other = self;
						self.touch();
					}
					
					self = curSelf;
					other = curOther;
					
					if (IsDestroyed(self))
						return;
				}
				
				curIgnore = trace_ent;
			}
			
			if (DistanceSq(trace_endpos, end) <= 1.0)
			{
				trace_ent = world;
				trace_fraction = 1.0;
				trace_endpos = end;
				break;
			}
			
			// In this case we have to store some extra information so that
			// rippers don't bounce off walls incorrectly or damage random
			// entities they shouldn't be
			entity prevEnt = trace_ent;
			vector prevNorm = trace_plane_normal;
			float prevFrac = trace_fraction;
			vector prevPos = trace_endpos;
			
			TraceLineEx(trace_endpos + dir, end, type, curIgnore);
			if (trace_startsolid)
			{
				trace_ent = prevEnt;
				trace_plane_normal = prevNorm;
				trace_fraction = prevFrac;
				trace_endpos = prevPos;
				break;
			}
			
			if (trace_fraction == 1.0 || !CanRip(trace_ent))
				break;
		}
	}
	
	SetOrigin(self, trace_endpos);
	if (trace_fraction == 1.0)
	{
		SetNextThink(self, TIME_EPSILON, A_MissileThink);
		return;
	}
	
	if (self.touch && self.solid != SOLID_NOT)
	{
		other = trace_ent;
		self.touch();
	}

	if (trace_ent.touch && trace_ent.solid != SOLID_NOT)
	{
		self = trace_ent;
		other = self;
		self.touch();
	}
	
	self = curSelf;
	other = curOther;
	
	if (IsDestroyed(self))
		return;
	
	float backoff = (self.misc_action & MISSILE_BOUNCE) ? 1.5 : 1.0;
	self.velocity -= trace_plane_normal * ((self.velocity * trace_plane_normal) * backoff);
	if (AbsF(self.velocity.x) < 0.1)
		self.velocity.x = 0.0;
	if (AbsF(self.velocity.y) < 0.1)
		self.velocity.y = 0.0;
	if (AbsF(self.velocity.z) < 0.1)
		self.velocity.z = 0.0;
	
	if (trace_plane_normal.z > 0.7
		&& (!(self.misc_action & MISSILE_BOUNCE) || self.velocity * trace_plane_normal < 60.0))
	{
		self.flags |= FL_ONGROUND;
		self.groundentity = trace_ent;
		self.velocity = self.avelocity = VEC_ZERO;
	}
	
	int_t contents = GetContentsAtPoint(self.origin);
	if (!self.watertype)
	{
		self.watertype = contents <= CONTENTS_WATER ? contents : CONTENTS_EMPTY;
		self.waterlevel = contents <= CONTENTS_WATER;
	}
	else if (contents <= CONTENTS_WATER)
	{
		if (self.watertype == CONTENTS_EMPTY)
			PlaySound(self, CHAN_AUTO, "misc/h2ohit1.wav", 1.0, ATTN_NORM);
		self.watertype = contents;
		self.waterlevel = 1;
	}
	else
	{
		if (self.watertype != CONTENTS_EMPTY)
			PlaySound(self, CHAN_AUTO, "misc/h2ohit1.wav", 1.0, ATTN_NORM);
		self.watertype = CONTENTS_EMPTY;
		self.waterlevel = 0;
	}
	
	SetNextThink(self, TIME_EPSILON, A_MissileThink);
}

// Death function for missiles
void A_MissileExplode()
{
	self.touch = __NULL__;
	self.velocity = self.avelocity = VEC_ZERO;
	if (self.noise2)
		PlaySound(self, CHAN_VOICE, self.noise2, 1.0, ATTN_NORM);
	
	if (self.rad_dmg >= 1)
	{
		RadiusAttack(self, self.owner, self.rad_dmg, Ceil(self.rad_dmg * 0.5), self.distance, self.old_enemy);
		SpawnEntityType(effect_explosion, self.origin);
	}
	
	if (self.old_enemy && self.deadflag != TE_INVALID)
	{
		WriteUInt8(MSG_BROADCAST, SVC_TEMPENTITY);
		WriteUInt8(MSG_BROADCAST, self.deadflag);
		WriteCoord(MSG_BROADCAST, self.origin.x);
		WriteCoord(MSG_BROADCAST, self.origin.y);
		WriteCoord(MSG_BROADCAST, self.origin.z);
	}
	
	DestroyEntity(self);
}

inline bool_t ShouldClipThrough(entity e)
{
	return e && e.solid == SOLID_BSP && e.takedamage == DAMAGE_NO && (e.spawnflags & FUNC_NO_TRACE);
}

// Extended version of the line tracer designed to ignore clip entities while keeping all
// the global values updated accurately
void TraceLineEx(vector start, vector end, int_t clipType, entity ignore)
{
	// Do a quick initial check. If it didn't hit anything we can skip then there's no point in doing any
	// followup iterations. All the globals will already be set to their correct values.
	TraceLine(start, end, clipType, ignore);
	if (trace_fraction == 1.0 || !ShouldClipThrough(trace_ent))
		return;
	
	// If we did hit something we can clip through, now the trace has to be broken down into
	// segments and the info combined at the end to properly set up the globals so it can
	// be treated like a single trace
	float dist = Distance(start, end);
	vector dir = Diff(start, end) / dist;
	
	bool_t startSolid = trace_startsolid;
	int_t allSolid = 1;
	int_t air, water;
	for (entity curIgnore = trace_ent;;)
	{
		trace_ent = world;
		air += trace_inopen;
		water += trace_inwater;
		allSolid -= !trace_allsolid;
		if (DistanceSq(trace_endpos, end) <= 1.0)
		{
			trace_endpos = end;
			break;
		}
		
		vector prevEnd = trace_endpos;
		TraceLine(trace_endpos + dir, end, clipType, curIgnore);
		// If we ended up inside a solid, the last trace should be considered
		// the last valid hit position. Don't use any data from the current one
		if (trace_startsolid)
		{
			trace_endpos = prevEnd;
			trace_ent = world;
			break;
		}
		
		if (trace_ent != ignore)
		{
			// If we hit the end of the trace, update the iterative info and then cancel out
			if (trace_fraction == 1.0 || !ShouldClipThrough(trace_ent))
			{
				air += trace_inopen;
				water += trace_inwater;
				allSolid -= !trace_allsolid;
				break;
			}
			
			curIgnore = trace_ent;
		}
	}
	
	trace_fraction = Distance(start, trace_endpos) / dist;
	trace_startsolid = startSolid;
	trace_allsolid = allSolid >= 1;
	trace_inopen = air >= 1;
	trace_inwater = water >= 1;
}

bool_t MeleeAttack(entity e, vector orig, vector dir, int_t damage, float range = 64.0)
{
	TraceLineEx(orig, orig + dir * range, MOVE_MISSILE, e);
	if (trace_fraction == 1.0)
		return FALSE;

	entity hit = trace_ent;
	vector hitPos = trace_endpos - dir * 4.0;
	bool_t bled = hit.takedamage != DAMAGE_NO && DamageEntity(hit, e, e, damage) >= 0;
	if (bled)
	{
		// Make sure this doesn't get overridden
		trace_ent = hit;
		SpawnBlood(hitPos, VEC_ZERO, damage);
	}
	else
	{
		trace_ent = world;
		WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte(MSG_BROADCAST, TE_GUNSHOT);
		WriteCoord(MSG_BROADCAST, hitPos.x);
		WriteCoord(MSG_BROADCAST, hitPos.y);
		WriteCoord(MSG_BROADCAST, hitPos.z);
	}
	
	return TRUE;
}

void FireBullets(entity e, vector orig, vector dir, int_t damage, int_t amount = 1, vector spread = [0.0, 0.0, 0.0])
{
	VecToAxes(dir);

	// Use a linked list system for stacking damage up across instances of an entity
	// instead of error prone globals. Also means stray traces hitting a different
	// entity will no longer interrupt damage stacking.
	entity head;
	for (int_t i; i < amount; ++i)
	{
		vector fireDir = Normalize(v_forward + v_right * (spread.x * CRandom()) + v_up * (spread.y * CRandom()));
		TraceLineEx(orig, orig + fireDir * 2048.0, MOVE_NORMAL, e);
		if (trace_fraction == 1.0)
			continue;
		
		vector hitPos = trace_endpos - fireDir * 4.0;
		if (trace_ent.takedamage == DAMAGE_NO)
		{
			WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
			WriteByte(MSG_BROADCAST, TE_GUNSHOT);
			WriteCoord(MSG_BROADCAST, hitPos.x);
			WriteCoord(MSG_BROADCAST, hitPos.y);
			WriteCoord(MSG_BROADCAST, hitPos.z);
			continue;
		}
		
		entity last = head;
		for (; last; last = last.chain)
		{
			if (last.enemy == trace_ent)
			{
				last.dmg += damage;
				break;
			}
		}
		
		if (last.enemy != trace_ent)
		{
			entity link = SpawnEntity();
			link.enemy = trace_ent;
			link.dmg = damage;
			
			if (!head)
				head = link;
			else
				last.chain = link;
			
			last = link;
		}
		
		// Also store the hit information in case it can't bleed
		entity pos = SpawnEntity();
		pos.origin = hitPos;
		pos.velocity = fireDir;
		
		if (!last.goalentity)
		{
			last.goalentity = pos;
		}
		else
		{
			entity lastPos = last.goalentity;
			for (entity temp = lastPos.chain; temp; temp = temp.chain)
				lastPos = temp;
			
			lastPos.chain = pos;
		}
	}
	
	while (head)
	{
		entity next = head.chain;
		
		bool_t bled = DamageEntity(head.enemy, e, e, head.dmg) >= 0;
		while (head.goalentity)
		{
			entity posNext = head.goalentity.chain;
			if (bled)
			{
				SpawnBloodSpray(head.goalentity.origin, head.goalentity.velocity, damage);
			}
			else
			{
				WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
				WriteByte(MSG_BROADCAST, TE_GUNSHOT);
				WriteCoord(MSG_BROADCAST, head.goalentity.origin.x);
				WriteCoord(MSG_BROADCAST, head.goalentity.origin.y);
				WriteCoord(MSG_BROADCAST, head.goalentity.origin.z);
			}
			RemoveEntity(head.goalentity);
			head.goalentity = posNext;
		}
		
		RemoveEntity(head);
		head = next;
	}
}

void RailAttack(entity e, vector orig, vector dir, int_t damage)
{
	// Do an initial trace to see if it even hit anything. If not, don't
	// bother with the looping since we know it's not needed
	vector end = orig + dir * 2048.0;
	TraceLineEx(orig, end, MOVE_NORMAL, e);
	if (trace_fraction == 1.0)
		return;
	
	// In this case we actually did hit something it could potentially damage and
	// penetrate through, so start the segmented traces
	if (trace_ent)
	{
		for (entity curIgnore;;)
		{
			if (trace_ent != e)
			{
				if (trace_ent.takedamage != DAMAGE_NO && DamageEntity(trace_ent, e, e, damage) >= 0)
				{
					SpawnBloodSpray(trace_endpos, dir, damage);
				}
				else
				{
					WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
					WriteByte(MSG_BROADCAST, TE_GUNSHOT);
					WriteCoord(MSG_BROADCAST, trace_endpos.x);
					WriteCoord(MSG_BROADCAST, trace_endpos.y);
					WriteCoord(MSG_BROADCAST, trace_endpos.z);
				}
				
				if (trace_ent.solid == SOLID_BSP)
					break;
				
				curIgnore = trace_ent;
			}
			
			if (DistanceSq(trace_endpos, end) <= 1.0)
			{
				trace_ent = world;
				trace_endpos = end;
				trace_fraction = 1.0;
				break;
			}
			
			entity prevEnt = trace_entity;
			float prevFrac = trace_fraction;
			vector prevPos = trace_endpos;
			
			TraceLineEx(trace_endpos + dir, end, MOVE_NORMAL, curIgnore);
			if (trace_startsolid)
			{
				trace_entity = prevEnt;
				trace_fraction = prevFrac;
				trace_endpos = prevPos;
				break;
			}
			
			if (trace_fraction == 1.0 || !trace_ent)
				break;
		}
	}
	
	if (trace_fraction != 1.0 && !trace_ent)
	{
		WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
		WriteByte(MSG_BROADCAST, TE_GUNSHOT);
		WriteCoord(MSG_BROADCAST, trace_endpos.x);
		WriteCoord(MSG_BROADCAST, trace_endpos.y);
		WriteCoord(MSG_BROADCAST, trace_endpos.z);
	}
}
