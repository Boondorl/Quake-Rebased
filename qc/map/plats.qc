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

void SpawnPlatformTrigger(entity e, bool_t atBase)
{
	entity trigger = SpawnEntityType(trigger_platform, e.origin);
	trigger.goalentity = e;

	vector min = e.mins + [25.0, 25.0, 0.0];
	vector max = e.maxs - [25.0, 25.0, -8.0];
	min.z = max.z - ((e.pos1.z - e.pos2.z) + 8.0);
	if (atBase)
		max.z = min.z + 8.0;

	if (e.size.x <= 50.0)
	{
		min.x = (e.mins.x + e.maxs.x) * 0.5;
		max.x = min.x + 1.0;
	}
	if (e.size.y <= 50.0)
	{
		min.y = (e.mins.y + e.maxs.y) * 0.5;
		max.y = min.y + 1.0;
	}

	SetSize(trigger, min, max);
}

void P_PlatformTriggerTouch()
{
	if (!IsValidClient(other) || IsDormant(self.goalentity))
		return;

	if (self.goalentity.state == FUNC_DEACTIVATED)
		InvokeAsSelf(self.goalentity, F_ActivatePlatform);
	else if (self.goalentity.state == FUNC_ACTIVATED)
		SetNextThinkTime(self.goalentity, 1.0);
}

void trigger_platform()
{
	self.touch = P_PlatformTriggerTouch;
	
	SetPhysics(self, SOLID_TRIGGER, MOVETYPE_NONE);
}

// .......

void F_ActivatePlatform()
{
	PlaySound(self, CHAN_VOICE, self.noise1, 1.0, ATTN_NORM);
	
	self.state = FUNC_ACTIVATING;
	F_CalcMove(self.pos2, self.speed, F_PlatformReachedEnd);
}

void F_PlatformReachedEnd()
{
	PlaySound(self, CHAN_VOICE, self.noise2, 1.0, ATTN_NORM);
	
	self.state = FUNC_ACTIVATED;
	if (self.wait > 0.0 && !IsDormant(self))
		SetNextThink(self, self.wait, F_DeactivatePlatform);
}

void F_DeactivatePlatform()
{
	PlaySound(self, CHAN_VOICE, self.noise1, 1.0, ATTN_NORM);
	
	self.state = FUNC_DEACTIVATING;
	F_CalcMove(self.pos1, self.speed2, F_PlatformReachedStart);
}

void F_PlatformReachedStart()
{
	PlaySound(self, CHAN_VOICE, self.noise2, 1.0, ATTN_NORM);
	
	self.state = FUNC_DEACTIVATED;
}

// TODO: ??????????????
void() plat_outside_touch =
{
	if (other.classname != "player")
		return;

	if (other.health <= 0)
		return;

	self = self.enemy;
	if (self.state == STATE_TOP)
		plat_go_down();
};

void F_PlatformTriggerUse()
{
	if (IsThinking(self))
		return; // allready activated
	
	F_DeactivatePlatform();
}

void P_PlatformBlocked()
{
	DamageEntity(other, self, world, self.dmg);

	if (self.state == FUNC_ACTIVATING)
		F_DeactivatePlatform();
	else if (self.state == FUNC_DEACTIVATING)
		F_ActivatePlatform();
}

void F_PlatformUse()
{
	if (IsDormant(self))
		return;
	
	if (self.state == FUNC_ACTIVATED)
	{
		if (!(self.spawnflags & PLAT_USE_ONLY))
		{
			self.use = __NULL__;
			F_DeactivatePlatform();
		}
		else if (!IsThinking(self))
		{
			F_DeactivatePlatform();
		}
	}
	else if (self.state == FUNC_DEACTIVATED)
	{
		F_ActivatePlatform();
	}
}

void F_FindPlatformDest()
{
	entity pos = FindEntity(world, targetname, self.target);
	if (!pos)
		ThrowEntityException("Platform destination could not be found");
	
	self.pos2 = pos.origin - GetCenter(self);
}

enum int_t
{
	PSND_BASE = 1,
	PSND_MEDIEVAL,
}

enumflags
{
	PLAT_LOW_TRIGGER,
	PLAT_USE_ONLY,
}

void func_plat()
{
	if (!self.dmg)
		self.dmg = 1;
	if (self.speed <= 0.0)
		self.speed = 150.0;
	if (self.speed2 <= 0.0)
		self.speed2 = self.speed;
	if (!self.sounds)
		self.sounds = PSND_MEDIEVAL;
	if (!self.wait)
		self.wait = 3.0;

	if (self.sounds == PSND_BASE)
	{
		self.noise1 = "plats/plat1.wav";
		self.noise2 = "plats/plat2.wav";
	}
	else if (self.sounds == PSND_MEDIEVAL)
	{
		self.noise1 = "plats/medplat1.wav";
		self.noise2 = "plats/medplat2.wav";
	}
	
	if (self.noise1)
		PrecacheSound(self.noise1);
	if (self.noise2)
		PrecacheSound(self.noise2);
	
	bool_t useOnly = (self.spawnflags & PLAT_USE_ONLY);
	
	self.use = useOnly ? F_PlatformUse : F_PlatformTriggerUse;
	self.blocked = P_PlatformBlocked;

	self.pos2 = self.origin;
	if (!self.target)
		self.pos1 = self.origin - [0.0, 0.0, (self.height ? self.height : self.size.z - 8.0)];

	if (!useOnly)
		SpawnPlatformTrigger(self, (self.spawnflags & PLAT_LOW_TRIGGER));

	if (self.targetname && !useOnly)
	{
		self.state = STATE_ACTIVATED;
		self.use = F_PlatformUse;
	}
	else
	{
		self.state = STATE_DEACTIVATED;
		self.origin = self.pos1;
	}
	
	StartFunc(self);
	
	if (self.target)
		SetNextThink(self, 0.2, F_FindPlatformDest);
}
