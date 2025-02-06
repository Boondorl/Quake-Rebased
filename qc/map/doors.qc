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

/*

Doors are similar to buttons, but can spawn a fat trigger field around them
to open without a touch, and they link together to form simultanious
double/quad doors.

Door.owner is the master door.  If there is only one door, it points to itself.
If multiple doors, all will point to a single one.

Door.enemy chains from the master door through all doors linked in the chain.

*/

/*
=============================================================================

THINK FUNCTIONS

=============================================================================
*/

void F_DoorReachedEnd()
{
	PlaySound(self, CHAN_BODY, self.noise1, 1.0, ATTN_NORM);
	
	self.state = FUNC_ACTIVATED;
	if (self.wait > 0.0)
		SetNextThink(self, self.wait, F_DeactivateDoor);
}

void F_DoorReachedStart()
{
	PlaySound(self, CHAN_BODY, self.noise1, 1.0, ATTN_NORM);
	
	self.state = FUNC_DEACTIVATED;
}

void F_DeactivateDoor()
{
	PlaySound(self, CHAN_BODY, self.noise2, 1.0, ATTN_NORM);
	
	self.state = FUNC_DEACTIVATING;
	if (self.health)
		self.takedamage = DAMAGE_USE;

	F_CalcMove(self.pos1, self.speed, F_DoorReachedStart);
}

// Activate all linked doors. From there the doors will handle themselves
void F_ActivateDoor()
{
	if (self.owner)
	{
		InvokeAsSelf(self.owner, F_ActivateDoor);
		return;
	}

	self.message = __NULL__;
	for (entity door = self; door; door = door.enemy)
	{
		if (door.state == FUNC_ACTIVATED)
		{
			// Reset top wait time
			if (door.wait > 0.0)
				SetNextThinkTime(door, door.wait);
			
			continue;
		}
		else if (door.state == FUNC_ACTIVATING)
		{
			continue;
		}

		PlaySound(door, CHAN_BODY, door.noise2, 1.0, ATTN_NORM);
		
		door.state = FUNC_ACTIVATING;
		door.takedamage = DAMAGE_NO;
		
		F_CalcMove(door.pos2, door.speed, F_DoorReachedEnd);
		
		ActivateEntity(door, self.goalentity);
	}
	
	self.goalentity = world;
}

void P_DoorBlocked()
{
	DealDamageType(damage_crush, other, self.dmg);
	if (self.wait <= 0.0)
		return;

	// If a door has a negative wait, it would never come back if blocked,
	// so let it just squash the object to death real fast
	
	if (self.state == FUNC_DEACTIVATING)
		F_ActivateDoor();
	else if (self.state == FUNC_ACTIVATING)
		F_DeactivateDoor();
}

void P_DoorTriggerTouch()
{
	if (other.health < 1 || !TimerExpired(self.attack_finished))
		return;
	
	SetCoolDown(self, attack_finished, 1.0);
	InvokeActivation(self.owner, other, self.owner.use);
}

// This is mostly for locked doors of multiple varieties to either give the player
// a hint or tell them what item they need
void P_DoorTouch()
{
	// Always call this from the parent door so it can be centrally tracked
	if (self.owner)
	{
		InvokeAsSelf(self.owner, P_DoorTouch);
		return;
	}
	
	if (!IsValidClient(other) || !TimerExpired(self.attack_finished))
		return;

	SetCoolDown(self, attack_finished, 2.0);
	
	if (!self.MacGuffinInventory)
	{
		// This only makes sense if a locked message isn't going to play
		if (self.message)
		{
			CenterPrint(other, self.message);
			PlaySound(other, CHAN_AUTO, self.noise, 1.0, ATTN_NORM);
		}
		
		return;
	}

	// key door stuff
	bool_t local = (self.spawnflags & DOOR_LOCAL_KEYS);
	if (!HasFlags(local ? other.MacGuffinInventory : MacGuffinItems, self.MacGuffinInventory))
	{
		PlaySound(other, CHAN_AUTO, self.noise3, 1.0, ATTN_NORM);
		if (self.message)
			CenterPrint(other, self.message);
		
		return;
	}
	
	// Local doors have special logic in that they won't actually take away the item nor
	// will they remain closed indefinitely. This is to allow only players with x item
	// to get through doors and encourage other players to hunt for it as well

	PlaySound(other, CHAN_AUTO, self.noise4, 1.0, ATTN_NORM);
	if (!local)
	{
		MacGuffinItems &= ~self.MacGuffinInventory;
		self.MacGuffinInventory = 0;
		for (entity temp = self; temp; temp = temp.enemy)
			temp.touch = __NULL__;
		
		for (entity p = NextEntity(world); p; p = NextEntity(p))
		{
			if (!IsClient(p))
				break;
			
			p.items &= ~self.items;
		}
	}
	
	InvokeActivation(self, other, self.use);
}

void F_DoorUse()
{
	if (self.owner)
	{
		InvokeActivation(self.owner, self.aiment, F_DoorUse);
		return;
	}
	
	self.message = __NULL__;
	self.goalentity = self.aiment;
	F_ActivateDoor();
}

/*
=============================================================================

SPAWNING FUNCTIONS

=============================================================================
*/

void trigger_door()
{
	self.touch = P_DoorTriggerTouch;
	
	SetPhysics(SOLID_TRIGGER, MOVETYPE_NONE);
}

void SpawnDoorTrigger(entity e)
{
	entity trigger = SpawnEntityType(trigger_door, e.origin);
	trigger.owner = e;
	
	// TODO: This is probably wrong
	vector min = e.mins;
	vector max = e.maxs;
	for (entity temp = e.enemy; temp; temp = temp.enemy)
	{
		if (temp.mins.x < min.x)
			min.x = temp.mins.x;
		if (temp.mins.y < min.y)
			min.y = temp.mins.y;
		if (temp.mins.z < min.z)
			min.z = temp.mins.z;
		if (temp.maxs.x > max.x)
			max.x = temp.maxs.x;
		if (temp.maxs.y > max.y)
			max.y = temp.maxs.y;
		if (temp.maxs.z > max.z)
			max.z = temp.maxs.z;
	}

	SetSize(trigger, min - [60.0, 60.0, 8.0], max + [60.0, 60.0, 8.0]);
}

// TODO: This can be trivially inlined
bool_t EntitiesColliding(entity e1, entity e2)
{
	if (e1.mins_x > e2.maxs_x)
		return FALSE;
	if (e1.mins_y > e2.maxs_y)
		return FALSE;
	if (e1.mins_z > e2.maxs_z)
		return FALSE;
	if (e1.maxs_x < e2.mins_x)
		return FALSE;
	if (e1.maxs_y < e2.mins_y)
		return FALSE;
	if (e1.maxs_z < e2.mins_z)
		return FALSE;
	return TRUE;
}

// This logic differs heavily from the original which was prone to breakage and had very confusing
// linked list rules. Now the head door will no longer set its owner to itself and the enemy list
// is no longer circular since all logic should be called from the head of the list anyway. Linkage
// also now spreads outward from the first door touched, fixing any possible gaps from wonky order of
// operations errors alongside problems with intersecting doors overlapping. Now any intersections
// will be forcibly resolved by considering all of those doors linked. Which door is chosen first is
// still order of operation heavy, so treat it as essentially random
void F_LinkDoors()
{
	entity head = self.owner ? self.owner : self;
	entity curEnd = self;
	for (entity door = FindEntity(world, classname, self.classname); door; door = FindEntity(door, classname, self.classname))
	{
		if (door == self || door == self.owner || door.owner || door.team
			|| (door.spawnflags & DOOR_DONT_LINK) || !EntitiesColliding(door, self))
		{
			continue;
		}
		
		door.owner = head;
		
		// Door is already being linked so don't bother trying to link again
		if (door.think == F_LinkDoors)
			ClearThink(door);
		
		// Descend recursively
		InvokeAsSelf(door, F_LinkDoors);
		
		// After linking we have no idea how deep the list will be, so always try and
		// iterate to the end of it
		for (entity cur = curEnd; cur.enemy; cur = cur.enemy)
			curEnd = cur.enemy;
		
		curEnd.enemy = door;
	}
	
	// Only doors with no other way of activating get a trigger
	if (self.owner || self.health || self.targetname || IsValidItem(self.CurrentSlot))
		return;
	
	SpawnDoorTrigger(self);
}

// This function is much simpler. Find any door on the same team, ignore the rest. Allows for linked
// doors to sit directly next to each other without force linking
void F_LinkTeamDoors()
{
	entity curEnd = self;
	for (entity door = FindEntity(world, classname, self.classname); door; door = FindEntity(door, classname, self.classname))
	{
		if (door == self || door.team != self.team)
			continue;
		
		door.owner = self;
		if (door.think == F_LinkTeamDoors)
			ClearThink(door);
		
		curEnd.enemy = door;
		curEnd = door;
	}
	
	// Only doors with no other way of activating get a trigger
	if (self.health || self.targetname || IsValidItem(self.CurrentSlot))
		return;
	
	SpawnDoorTrigger(self);
}

enum int_t
{
	DSND_STONE = 1,
	DSND_BASE,
	DSND_CHAIN,
	DSND_METAL,
}

enumflags
{
	DOOR_START_OPEN,
	DOOR_DONT_LINK,
	DOOR_GOLD_KEY,	// Key flags are deprecated in favor of setting MacGuffins directly
	DOOR_SILVER_KEY,
	DOOR_TOGGLE,
	DOOR_NO_LIP,
	DOOR_LOCAL_KEYS,
};

void func_door()
{
	if (self.speed <= 0.0)
		self.speed = 100.0;
	if (!self.wait)
		self.wait = 3.0;
	if (!self.lip && !(self.spawnflags & DOOR_NO_LIP))
		self.lip = 8.0;
	if (!self.dmg)
		self.dmg = 2;
	if (!self.noise)
		self.noise = SND_TALK;
	
	if (world.worldtype == WORLD_MEDIEVAL)
	{
		self.noise3 = "doors/medtry.wav";
		self.noise4 = "doors/meduse.wav";
	}
	else if (world.worldtype == WORLD_METAL)
	{
		self.noise3 = "doors/runetry.wav";
		self.noise4 = "doors/runeuse.wav";
	}
	else if (world.worldtype == WORLD_BASE)
	{
		self.noise3 = "doors/basetry.wav";
		self.noise4 = "doors/baseuse.wav";
	}
	
	if (self.sounds == DSND_STONE)
	{
		self.noise1 = "doors/drclos4.wav";
		self.noise2 = "doors/doormv1.wav";
	}
	else if (self.sounds == DSND_BASE)
	{
		self.noise2 = "doors/hydro1.wav";
		self.noise1 = "doors/hydro2.wav";
	}
	else if (self.sounds == DSND_CHAIN)
	{
		self.noise1 = "doors/stndr2.wav";
		self.noise2 = "doors/stndr1.wav";
	}
	else if (self.sounds == DSND_METAL)
	{
		self.noise1 = "doors/ddoor2.wav";
		self.noise2 = "doors/ddoor1.wav";
	}
	
	F_SetMoveDir();
	
	self.blocked = P_DoorBlocked;
	self.touch = P_DoorTouch;
	self.use = F_DoorUse;
	
	self.items = 0;
	if (!(self.spawnflags & DOOR_LOCAL_KEYS))
	{
		if (self.spawnflags & DOOR_SILVER_KEY)
			self.MacGuffinInventory |= MGG_KEY1;
		if (self.spawnflags & DOOR_GOLD_KEY)
			self.MacGuffinInventory |= MGG_KEY2;

		if (self.MacGuffinInventory)
		{
			self.wait = -1.0;
			if (self.MacGuffinInventory & MGG_KEY1)
				self.items |= IT_KEY1;
			if (self.MacGuffinInventory & MGG_KEY2)
				self.items |= IT_KEY2;
		}
		
		// Default key messages for vanilla Quake support. This will support
		// dual keys unlike vanilla
		if (!self.message && (self.MacGuffinInventory & (MGG_KEY1 | MGG_KEY2)))
		{
			if (world.worldtype == WORLD_MEDIEVAL)
			{
				if (HasFlags(self.MacGuffinInventory, MGG_KEY1 | MGG_KEY2))
					self.message = "You need the gold and silver keys";
				else if (self.MacGuffinInventory & MGG_KEY1)
					self.message = "You need the silver key";
				else
					self.message = "You need the gold key";
			}
			else if (world.worldtype == WORLD_METAL)
			{
				if (HasFlags(self.MacGuffinInventory, MGG_KEY1 | MGG_KEY2))
					self.message = "You need the gold and silver runekeys";
				else if (self.MacGuffinInventory & MGG_KEY1)
					self.message = "You need the silver runekey";
				else
					self.message = "You need the gold runekey";
			}
			else if (world.worldtype == WORLD_BASE)
			{
				if (HasFlags(self.MacGuffinInventory, MGG_KEY1 | MGG_KEY2))
					self.message = "You need the gold and silver keycards";
				else if (self.MacGuffinInventory & MGG_KEY1)
					self.message = "You need the silver keycard";
				else
					self.message = "You need the gold keycard";
			}
		}
	}
	
	self.state = FUNC_DEACTIVATED;
	if (self.health)
	{
		self.health = 1;
		self.takedamage = DAMAGE_USE;
	}

	self.pos1 = self.origin;
	self.pos2 = self.pos1 + self.movedir * (AbsF(self.movedir * self.size) - self.lip);

	// DOOR_START_OPEN is to allow an entity to be lighted in the closed position
	// but spawn in the open position
	if (self.spawnflags & DOOR_START_OPEN)
	{
		self.origin = self.pos2;
		self.pos2 = self.pos1;
		self.pos1 = self.origin;
	}
	
	StartFunc(self);
	
	// Linking doors can't be done until all of the doors have been spawned, so
	// the sizes can be detected properly.
	SetNextThink(self, 0.1, self.team ? F_LinkTeamDoors : F_LinkDoors);
}
