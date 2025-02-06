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

void StartTrigger(entity e)
{
	if (!CanSpawn(e))
		return;
	
	if (e.noise)
		PrecacheSound(e.noise);
	
	e.th_dormant = F_TriggerDormant;
	
	e.morigin = e.origin;
	e.mangle = e.angles;
	e.max_health = e.health;
	
	// trigger angles are used for one-way touches.  An angle of 0 is assumed
	// to mean no restrictions, so use a yaw of 360 instead.
	if (e.angles != VEC_ZERO)
	{
		SetMoveDir(e);
		e.angles = VEC_ZERO;
	}
	
	SetPhysics(e, SOLID_TRIGGER, MOVETYPE_NONE);
	
	// In this case since it's a BSP model we can use SetModel to set
	// its exact bounds then hide it
	SetModel(e, e.model);
	ClearModel(e);
}

void F_TriggerDormant(entity activator, bool_t activate)
{
	if (activate)
	{
		self.spawnflags &= ~SPAWNFLAGS_DORMANT;
		if (self.think && self.state == FUNC_ACTIVATED)
			self.think();
	}
	else
	{
		self.spawnflags |= SPAWNFLAGS_DORMANT;
		ClearThink(self);
		if (self.state == FUNC_DEACTIVATED)
		{
			self.takedamage = DAMAGE_NO;
			SetSolid(self, SOLID_NOT);
		}
	}
}

// the wait time has passed, so set back up for another activation
void F_ResetMultiTrigger()
{
	self.state = FUNC_DEACTIVATED;
	if (self.health)
	{
		self.takedamage = DAMAGE_USE;
		SetSolid(self, SOLID_BBOX);
	}
	else if (self.touch)
	{
		// Don't wait for any entities still in it to move again
		force_retouch = 2;
	}
}

// the trigger was just touched/used
// wait for the delay time before firing
void F_MultiTriggerUse()
{
	if (self.state == FUNC_ACTIVATED || IsDormant(self))
		return;
	
	if (self.flags & FL_COUNT_SECRET)
	{
		// Secrets can only be activated by players
		if (!IsClient(self.activator))
			return;
		
		self.flags &= ~FL_COUNT_SECRET;
		++found_secrets;
	}
	
	self.state = FUNC_ACTIVATED;
	self.takedamage = DAMAGE_NO;
	
	if (self.noise)
		PlaySound(self, CHAN_BODY, self.noise, 1.0, ATTN_NORM);
	
	ActivateEntity(self, self.activator);

	// don't trigger again until reset
	if (self.wait > 0.0)
	{
		SetSolid(self, SOLID_NOT);
		SetNextThink(self, self.wait, F_ResetMultiTrigger);
	}
	else
	{
		DestroyEntity(self);
	}
}

void P_MultiTriggerTouch()
{
	if (!IsValidClient(other))
		return;

	// if the trigger has an angles field, check player's facing direction
	if (self.movedir != VEC_ZERO)
	{
		FixedLocalAxes(other.angles);
		
		if (v_forward * self.movedir < 0.0)
			return;
	}

	InvokeActivation(self, other, self.use);
}

enum int_t
{
	MSND_SECRET,
	MSND_TALK,
	MSND_SWITCH,
};

enumflags
{
	TRIGGER_NO_TOUCH,
	TRIGGER_SECRET,
};

void trigger_multiple()
{
	if (!self.wait)
		self.wait = 0.2;
	
	if (self.sounds == MSND_SECRET)
		self.noise = SND_SECRET;
	else if (self.sounds == MSND_TALK)
		self.noise = SND_MESSAGE;
	else if (self.sounds == MSND_SWITCH)
		self.noise = "misc/trigger1.wav";
	
	self.use = F_MultiTriggerUse;
	
	self.state = FUNC_DEACTIVATED;
	if (self.spawnflags & TRIGGER_SECRET)
	{
		self.flags |= FL_COUNT_SECRET;
		++total_secrets;
	}
	
	if (self.health)
		self.takedamage = DAMAGE_USE;
	else if (!(self.spawnflags & TRIGGER_NO_TOUCH))
		self.touch = P_MultiTriggerTouch;
	
	StartTrigger(self);

	if (self.takedamage == DAMAGE_USE)
		SetSolid(self, SOLID_BBOX);
}

void trigger_once()
{
	self.wait = -1.0;
	
	trigger_multiple();
}

// This is more or less just a convenient wrapper now
void trigger_secret()
{
	if (!self.message)
		self.message = "You found a secret area!";
	if (!self.sounds)
		self.sounds = MSND_SECRET;
	
	self.spawnflags |= TRIGGER_SECRET;

	trigger_once();
}

void F_ActivateUse()
{
	if (!IsDormant(self))
		ActivateEntity(self, self.activator);
}

void trigger_relay()
{
	if (!CanSpawn(self))
		return;
	
	self.use = F_ActivateUse;
	
	SetPhysics(self, SOLID_NONE, MOVETYPE_NONE);
	InitializeEntity(e);
}

void F_CounterTriggerUse()
{
	if (IsDormant(self))
		return;
	
	--self.count;
	if (!(self.spawnflags & COUNTER_NO_MESSAGE))
	{
		// Print this information to everyone since it's often needed to understand
		// the current state of a puzzle
		if (self.count >= 4)
			BroadcastCenterPrint("There are ", ToStringF(self.count), " more to go...");
		else if (self.count >= 1)
			BroadcastCenterPrint("Only ", ToStringF(self.count), " more to go...");
		else
			BroadcastCenterPrint("Sequence completed!");
	}
	
	if (self.count < 1)
		F_MultiTriggerUse();
}

enumflags
{
	COUNTER_NO_MESSAGE,
}

void trigger_counter()
{
	self.wait = -1.0;
	if (self.count <= 0)
		self.count = 2;

	self.use = F_CounterTriggerUse;
	
	self.state = FUNC_DEACTIVATED;
	
	SetPhysics(self, SOLID_NOT, MOVETYPE_NONE);
	InitializeEntity(self);
}

inline void SpawnTeleportFog(vector orig)
{
	SpawnEntityType(effect_telefog, orig);
}

void P_TeleportDamageTouch()
{
	if (self.owner.health < 1)
	{
		DestroyEntity(self);
		return;
	}
	
	if ((other.flags & FL_GODMODE) || GetItemCount(other, IT_INVULN) >= 1 || (IsClient(other) && !IsClient(self.owner)))
	{
		self.obituary = " had their own telefrag deflected back at them";
		DamageEntity(self.owner, other, self, TELEFRAG_DAMAGE, DMG_FORCE);
		return;
	}

	if (other.takedamage == DAMAGE_YES || other.takedamage == DAMAGE_AIM)
		DamageEntity(other, self.owner, self, TELEFRAG_DAMAGE, DMG_NO_QUAD | DMG_NO_ARMOR);
}

void teleport_damage()
{
	self.touch = P_TeleportDamageTouch;
	
	self.deathtype = "telefrag";
	self.obituary = " was turned into a red mist by ";
	
	SetNextThink(self, A_Remove, 0.2);
	
	// This should be relinked after being spawned
	SetPhysics(self, SOLID_TRIGGER, MOVETYPE_NONE);
}

void SpawnTeleportDeath(entity e, vector orig)
{
	entity death = SpawnEntityType(teleport_damage, orig);
	death.owner = e;
	SetSize(death, e.mins - [1.0, 1.0, 1.0], e.maxs + [1.0, 1.0, 1.0]);

	force_retouch = 2; // make sure even still objects get hit
}

void TeleportEntity(entity e, vector orig, vector angs)
{
	SpawnTeleportDeath(e, orig);

	e.angles = angs;
	SetOrigin(e, orig);
	if (IsClient(e))
	{
		e.fixangle = TRUE;
		SetCoolDown(e, teleport_time, 0.7);
	}
}

void P_TeleportTouch()
{
	if (other.health < 1 || other.solid != SOLID_SLIDEBOX || self.state != FUNC_ACTIVATED
		|| ((self.spawnflags & PLAYER_ONLY) && !IsClient(other))
		|| ((self.spawnflags & MONSTER_ONLY) && !(other.flags & FL_MONSTER)))
	{
		return;
	}
	
	ActivateEntity(self, other);

	SpawnTeleportFog(other.origin);
	SpawnTeleportFog(self.pos2);
	
	TeleportEntity(other, self.goalentity.origin, self.goalentity.angles);
	other.flags &= ~FL_ONGROUND;
	if (IsClient(other))
		other.velocity = self.movedir * 300.0;
}

void info_teleport_destination()
{
	if (!self.targetname)
		A_ThrowEntityException("No targetname given");
	
	self.origin.z += 27.0;
	SetPhysics(self, SOLID_NOT, MOVETYPE_NONE);
	InitializeEntity(self);
}

void F_TeleportUse()
{
	if (self.spawnflags & SPAWNFLAGS_DORMANT)
		return;
	
	self.state = FUNC_ACTIVATED;
	force_retouch = 2; // make sure even still objects get hit
}

enumflags
{
	PLAYER_ONLY,
	SILENT,
	MONSTER_ONLY,
};

void trigger_teleport()
{
	if (!self.target)
		A_ThrowEntityException("No valid target given");
	
	self.goalentity = FindEntity(world, targetname, self.target);
	if (!self.goalentity)
		A_ThrowEntityException("No valid destination found");

	self.touch = P_TeleportTouch;
	self.use = P_TeleportUse;
	
	self.state = self.targetname ? FUNC_DEACTIVATED : FUNC_ACTIVATED;
	
	SetLocalAxes(self.goalentity.angles);
	self.movedir = v_forward;
	self.pos2 = self.goalentity.origin + v_forward * 32.0;
	
	StartTrigger(self);
	
	if (!(self.spawnflags & SILENT))
	{
		if (!self.noise)
			self.noise = "ambience/hum1.wav";
		
		PrecacheSound(self.noise);
		
		PlayAmbientSound(GetCenter(self), self.noise, 0.5, ATTN_STATIC);
	}
}

void P_SkillTriggerTouch()
{
	if (IsValidClient(other) && !IsDormant(self))
		SetCVar("skill", self.message);
}

void trigger_setskill()
{
	self.touch = P_SkillTriggerTouch;
	
	StartTrigger(self);
}

// This isn't needed anymore
void trigger_onlyregistered()
{
	DestroyEntity(self);
}

.float DamageCoolDown;

void P_HurtTriggerTouch()
{
	if (other.takedamage == DAMAGE_NO || other.takedamage == DAMAGE_USE
		|| !TimerExpired(other.DamageCoolDown) || IsDormant(self))
	{
		return;
	}
	
	if (self.wait > 0.0)
		SetCoolDown(other, DamageCoolDown, self.wait);
	
	if (self.noise)
		PlaySound(other, CHAN_AUTO, self.noise, 1.0, ATTN_NORM);
	
	DamageEntity(other, world, self, self.dmg);
}

// Custom properties:
// 	* dmg (must be >= 1)
//	* wait (< 0.0 means no cool down)
//	* noise (damage sound)
void trigger_hurt()
{
	// Doesn't make sense to have one with zero damage...
	if (!self.wait)
		self.wait = 1.0;
	if (self.dmg < 1)
		self.dmg = 5;
	if (!self.deathtype)
		self.deathtype = "void";
	if (!self.Obituary)
		self.Obituary = " went for a swim in the abyss";
	
	if (self.noise)
		PrecacheSound(self.noise);
	
	self.touch = P_HurtTriggerTouch;
	
	StartTrigger(self);
}

.float HealCoolDown;

void P_HealTriggerTouch()
{
	if (other.health < 1 || other.max_health < 1 || !TimerExpired(other.HealCoolDown)
		|| (!(self.spawnflags & HT_HEAL_MONSTERS) && (other.flags & FL_MONSTER))
		|| ((self.spawnflags & HT_IGNORE_PLAYERS) && IsClient(other))
		|| !HealEntity(other, self.healamount, self.max_health >= 1 ? self.max_health : other.max_health))
	{
		return;
	}
	
	if (self.noise)
		PlaySound(other, CHAN_AUTO, self.noise, 1.0, ATTN_NORM);
	
	if (self.wait > 0.0)
		SetCoolDown(other, HealCoolDown, self.wait);
	
	if (self.spawnflags & HT_ONCE)
		DestroyEntity(self);
}

enumflags
{
	HT_ONCE,
	HT_HEAL_MONSTERS,
	HT_IGNORE_PLAYERS,
}

void trigger_heal()
{
	if (self.healamount < 1)
		self.healamount = 1;
	if (!self.wait)
		self.wait = 1.0;
	
	if (self.noise)
		PrecacheSound(self.noise);
	
	self.touch = P_HealTriggerTouch;
	
	StartTrigger(self);
}

enumflags
{
	PUSH_ONCE,
	PUSH_MONSTER_SND,
}

void() trigger_push_touch =
{
	if ((other.flags & FL_MISSILE) && other.movetype == MOVETYPE_BOUNCE)
	{
		other.velocity = self.speed * self.movedir * 10;
	}
	else if (other.health >= 1)
	{
		other.velocity = self.speed * self.movedir * 10;
		if (other.classname == "player")
		{
			if (other.fly_sound < time)
			{
				other.fly_sound = time + 1.5;
				sound(other, CHAN_AUTO, "ambience/windfly.wav", 1, ATTN_NORM);
			}
		}
	}
	
	if (self.spawnflags & PUSH_ONCE)
		DestroyEntity(self);
}

void() trigger_push =
{
	InitTrigger();
	precache_sound("ambience/windfly.wav");
	self.touch = trigger_push_touch;
	if (!self.speed)
		self.speed = 1000;
};

//============================================================================

void() trigger_monsterjump_touch =
{
	if (other.flags & (FL_MONSTER | FL_FLY | FL_SWIM) != FL_MONSTER)
		return;

// set XY even if not on ground, so the jump will clear lips
	other.velocity_x = self.movedir_x * self.speed;
	other.velocity_y = self.movedir_y * self.speed;

	if (!(other.flags & FL_ONGROUND))
		return;

	other.flags = other.flags - FL_ONGROUND;

	other.velocity_z = self.height;
};

/*QUAKED trigger_monsterjump (.5 .5 .5) ?
Walking monsters that touch this will jump in the direction of the trigger's angle
"speed" default to 200, the speed thrown forward
"height" default to 200, the speed thrown upwards
*/
void() trigger_monsterjump =
{
	if (!self.speed)
		self.speed = 200;
	if (!self.height)
		self.height = 200;
	if (self.angles == '0 0 0')
		self.angles = '0 360 0';
	InitTrigger();
	self.touch = trigger_monsterjump_touch;
};

