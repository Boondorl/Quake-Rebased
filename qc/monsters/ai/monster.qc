/*  Copyright (C) 1996-1997  Id Software, Inc.

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

inline bool_t IsValidEnemy(entity e)
{
	return e && e.health >= 1 && e.takedamage != DAMAGE_NO;
}

void SetEnemy(entity e, entity targ)
{
	if (targ == e.enemy)
		return;
	
	// Switching back to our old enemy
	if (targ == e.old_enemy)
		e.old_enemy = world;
	else if (IsClient(e.enemy))
		e.old_enemy = e.enemy;
	
	e.enemy = targ;
	if (!(e.spawnflags & MONSTER_STAY_PATH))
		e.goalentity = targ;
}

void ClearEnemy(entity e)
{
	if (e.goalentity == e.enemy)
		e.goalentity = world;
	
	e.enemy = e.old_enemy = world;
}

void A_MonsterDormant(entity activator, bool_t activate)
{
	if (self.health < 1)
		return;
	
	if (activate)
	{
		self.spawnflags &= ~SPAWNFLAG_DORMANT;
		if (!(self.spawnflags & MONSTER_SPAWNER))
		{
			bool_t hadEnemy = self.enemy != world;
			self.takedamage = DAMAGE_AIM;
			if (activator)
				SetEnemy(self, activator);
			
			if (!hadEnemy && self.enemy)
				self.think = A_WakeUp;
		}
		else if (activator)
		{
			self.enemy = activator;
		}
		
		if (self.think)
			self.think();
	}
	else
	{
		self.spawnflags |= SPAWNFLAG_DORMANT;
		self.takedamage = DAMAGE_NO;
		ClearThink(self);
	}
}

void A_SpawnMonster()
{
	bool_t check = (self.spawnflags & MONSTER_CHECK_SPAWN);
	if (check)
	{
		flags_t curFlags = self.flags;
		
		self.flags |= (FL_FLY | FL_ONGROUND | FL_PARTIALGROUND);
		SetPhysics(self, SOLID_SLIDEBOX, MOVETYPE_STEP, TRUE);
		bool_t res = A_TryMove(0.0, 0.0);
		SetPhysics(self, SOLID_NOT, MOTYPE_NONE, TRUE);
		self.flags = curFlags;
		
		// Obstructed, so try again in a second
		if (!res)
		{
			SetNextThink(self, 1.0, A_SpawnMonster);
			return;
		}
	}
	
	// Unfortunately there's no easy way to convert the classname to a function,
	// so this will have to do for now
	entity mon = SpawnEntity();
	mon.classname = self.classname;
	mon.owner = self;
	mon.origin = self.morigin;
	mon.angles = self.mangle;
	mon.misc_action = self.misc_action;
	
	mon.th_stand = self.th_stand;
	mon.th_walk = self.th_walk;
	mon.th_run = self.th_run;
	mon.th_melee = self.th_melee;
	mon.th_missile = self.th_missile;
	mon.th_pain = self.th_pain;
	mon.th_die = self.th_die;
	mon.th_check = self.th_check;
	
	mon.health = self.health;
	mon.armorvalue = self.armorvalue;
	mon.armortype = self.armortype;
	mon.flags = self.flags;
	mon.yaw_speed = self.yaw_speed;
	mon.view_ofs = self.view_ofs;
	mon.damage_type = self.damage_type;
	mon.obituary_prefix = self.obituary_prefix;
	mon.obituary_suffix = self.obituary_suffix;
	
	// For infinite spawners, probably a good idea to disallow backpacks
	// from dropping
	if (!(self.spawnflags & MONSTER_NO_AMMO))
	{
		for (uint_t i; i < MAX_AMMO_TYPES; ++i)
		{
			.int_t ammo = ammo_types[i].type;
			mon.ammo = self.ammo;
		}
	}
	
	StartMonster(mon, self.mdl, __NULL__, self.maxs.x > AABB_MAX.x);
	if (self.spawnflags & MONSTER_COUNT_TOTAL)
	{
		// Already accounted for, so don't count it
		--total_monsters;
		mon.flags &= ~FL_COUNT_MONSTER;
	}
	
	mon.message = self.message;
	mon.noise = self.noise;
	mon.targetname = self.targetname;
	mon.killtarget = self.killtarget;
	mon.target = self.target;
	mon.target2 = self.target2;
	mon.target3 = self.target3;
	mon.target4 = self.target4;
	
	SetEnemy(mon, self.enemy);
	InvokeAsSelf(mon, A_WakeUp);
	if (!check)
		SpawnTeleportDeath(mon, mon.origin);
	
	if (self.count >= 1 && --self.count < 1)
	{
		DestroyEntity(self);
		return;
	}
	
	if (self.wait > 0.0 || self.rand_value > 0.0)
		SetNextThinkTime(self, Max(TIME_EPSILON, self.wait + rand_value * Random()));
}

void A_MonsterUse()
{
	if (self.spawnflags & SPAWNFLAG_DORMANT)
		return;
		
	if (self.flags & MONSTER_SPAWNER)
	{
		self.enemy = self.activator;
		self.think();
		return;
	}
	
	if (self.enemy || self.health < 1 || !IsClient(self.activator) || !IsTargetable(self.activator))
		return;

	// Delay reaction so if the monster is teleported its sound is still heard
	SetEnemy(self, self.activator);
	SetNextThink(self, 0.1, A_WakeUp);
}

void MonsterKilled(entity e, entity inflictor, entity attacker)
{
	// fall to ground
	e.flags &= ~(FL_FLY | FL_SWIM);
	e.state = AS_STRAIGHT;
	if (e.flags & FL_COUNT_MONSTER)
	{
		e.flags &= ~FL_COUNT_MONSTER;
		++killed_monsters;
	}
	
	e.enemy = e.old_enemy = e.goalentity = world;
}

void StartMonster(entity e, string mod, string gibMod = __NULL__, bool_t large = FALSE)
{
	if (!(e.spawnflags & MONSTER_SPAWNER))
	{
		e.model = mod;
		e.takedamage = DAMAGE_AIM;
		e.flags |= (FL_MONSTER | FL_COUNT_MONSTER);
		++total_monsters;
	}
	else
	{
		e.think = A_SpawnMonster;
		
		e.takedamage = DAMAGE_NO;
		e.mdl = mod;
		if ((e.spawnflags & MONSTER_COUNT_TOTAL) && count >= 1)
			total_monsters += count;
	}
	
	e.use = A_MonsterUse;
	e.th_dormant = A_MonsterDormant;
	if (!e.th_check)
		e.th_check = A_CheckMonsterAttack;
	
	e.ideal_yaw = e.angles.y;
	e.max_health = e.health;
	e.mangle = e.angles;
	e.morigin = e.origin;
	if (!e.view_ofs)
		e.view_ofs = [0.0, 0.0, 25.0];
	if (e.yaw_speed <= 0.0)
		e.yaw_speed = 20.0;
	
	// Since spawners have to actively spawn new monsters, this has
	// to be checked for
	if (MapLoading())
	{
		PrecacheModel(mod);
		if (gibMod)
			PrecacheModel(gibMod);
	}

	// These will get set properly when it wakes up for real
	if (large)
	{
		e.mins = AABB_LARGE_MIN;
		e.maxs = AABB_LARGE_MAX;
	}
	else
	{
		e.mins = AABB_MIN;
		e.maxs = AABB_MAX;
	}
	
	if (!(e.spawnflags & MONSTER_SPAWNER))
	{
		if (MapLoading())
		{
			// Randomize when they actually show up to vary things
			SetNextThink(e, RandomRangeF(0.2, 0.5), A_MonsterWalk);
		}
		else
		{
			e.pause_time = -1.0;
			SetPhysics(e, SOLID_SLIDEBOX, MOVETYPE_STEP);
			InitializeEntity(e, e.model, e.mins, e.maxs);
		}
	}
	else
	{
		// Still set this for bounds checking on spawn if needed
		SetPhysics(e, SOLID_NOT, MOVETYPE_NONE);
		SetSize(e, e.mins, e.maxs);
	}
}

void A_MonsterWalk()
{
	bool_t hover = (self.flags & (FL_FLY | FL_SWIM));
	
	if (!hover)
		self.origin.z += 1.0;
	
	SetPhysics(self, SOLID_SLIDEBOX, MOVETYPE_STEP);
	InitializeEntity(self, self.model, self.mins, self.maxs);
	
	if (!hover)
		A_TryDropToFloor();
	
	if (!A_TryMove(0.0, 0.0))
		DebugPrint("Monster stuck in wall at: ", ToStringV(self.origin), "\n");

	if (self.target)
	{
		entity path = FindEntity(world, targetname, self.target);
		if (path && path.classname == "path_corner") // Gross hardcoded name
		{
			self.goalentity = path;
			SetCoolDown(self, pause_time, path.wait);
			if (self.pause_time >= 0.0)
				self.th_stand();
			else
				self.th_walk();
			
			return;
		}
	}
	
	self.pause_time = -1.0;
	if (self.spawnflags & MONSTER_WANDER)
		self.th_walk();
	else
		self.th_stand();
	
	if (self.spawnflags & SPAWNFLAG_DORMANT)
		self.th_dormant(world, FALSE);
}
