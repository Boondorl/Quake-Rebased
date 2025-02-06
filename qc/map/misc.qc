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

void info_null()
{
	RemoveEntity(self);
}

// Hacks galore...
void info_notnull()
{
	if (self.use == train_wait)
	{
		// Pseudo sound emitter, so turn it into a proper one
		self.classname = "target_sound";
		self.wait = 0.0;
		self.noise1 = self.noise;
		self.noise = __NULL__;
		
		target_sound();
	}
	else if (self.touch == BackpackTouch)
	{
		// Probably trying to take away the player's shells, so make it
		// a map start proper (also gives multiplayer support!)
		self.classname = "info_map";
		self.touch = __NULL__;
		self.items = 0; // This really can't be supported properly anymore
		self.ammo_shells += 25;
		if (self.ammo_shells < 1)
			self.current_slot = 1; // Auto select the axe
		
		info_map();
	}
	else if (self.use)
	{
		// Check for custom trap hacks
		if (IsMonsterAttack(self.use))
			A_BecomeMonsterShooter();
		else if (IsPlayerAttack(self.use))
			A_BecomePlayerShooter();
	}
	else if (self.model)
	{
		self.classname = "misc_model";
		ClearThink(self);
		
		misc_model();
	}
}

entity start_info;

void SetClientStartingGear(entity client)
{
	if (!start_info)
		return;
	
	if (start_info.owned_weapons)
	{
		client.owned_weapons = start_info.owned_weapons;
		client.items &= ~IT_WEAPONS;
		client.items |= (start_info.items & IT_WEAPONS);
		
		if (!CanUseWeapon(client.current_slot))
		{
			InvokeAsSelf(client, A_PickNewWeapon);
			if (client.PendingSlot != INVALID_SLOT)
				SetWeapon(client, client.PendingSlot);
			else
				ClearWeapon(client);
		}
	}
	
	if (self.misc_action)
	{
		for (uint_t i; i < MAX_AMMO_TYPES; ++i)
		{
			.int_t ammo = AmmoTypes[i].Type;
			client.ammo = start_info.ammo;
			if (i == client.CurrentAmmoType)
				client.currentammo = client.ammo;
		}
	}
	
	if (CanUseWeapon(client, self.current_slot))
		SetWeapon(client, self.current_slot);
	
	if (start_info.health >= 1)
		client.health = start_info.health;
	
	if (start_info.armorvalue >= 1)
	{
		client.armorvalue = start_info.armorvalue;
		client.armortype = start_info.armortype;
		client.items &= ~IT_ARMOR;
		client.items |= (start_info.items & IT_ARMOR);
	}
}

void A_StartMap()
{
	ActivateEntity(self, world, TRUE);
}

// Allow setting map entrance settings beyond using crummy info_notnull hacks
// 	* ammo_x (sets ammo amount for that type; shells should be set to 25 if no override is desired)
// 	* OwnedWeapons (sets what weapons players have on spawn; must have at least 1 weapon to override)
// 	* CurrentSlot (if >= 1, sets the default weapon to select)
// 	* health (if >= 1, set player health to this)
// 	* armorvalue (if >= 1, set armor to this)
// 	* armortype (armor must be >= 1; if <= 0.0, uses light armor)
void info_map()
{
	if (deathmatch && !self.team)
	{
		RemoveEntity(self);
		return;
	}
	
	if (start_info)
		A_ThrowEntityException("Map starting information was already defined");
	
	if (self.noise)
		PrecacheSound(self.noise);
	
	start_info = self;
	
	// Verify if any ammo types are actually different, otherwise we can
	// skip setting that entirely
	for (uint_t i; i < MAX_AMMO_TYPES; ++i)
	{
		.int_t ammo = AmmoTypes[i].Type;
		self.ammo = Clamp(Round(self.ammo), 0, AmmoTypes[i].MaxAmount);
		if (!self.misc_action)
			self.misc_action = (ammo == ammo_shells ? self.ammo != 25 : self.ammo >= 1);
	}
	
	// Cache this info now so it simply needs to be set on the client
	if (self.owned_weapons)
	{
		self.items &= ~IT_WEAPONS;
		for (uint_t i; i < MAX_TOTAL_SLOTS; ++i)
		{
			if (self.owned_weapons & Weapons[i].Bit)
				self.items |= Weapons[i].HUDBit;
		}
	}
	
	--self.current_slot; // This is 1-based from the map editor
	self.health = Round(self.health);
	self.armorvalue = Round(self.armorvalue);
	
	// This needs to be locked to two decimal places of accuracy, otherwise weird things
	// will happen when transferring between levels
	if (self.armorvalue >= 1)
	{
		if (self.armortype > 0.0)
			self.armortype = Floor(self.armortype * 100.0) * 0.01;
		if (self.armortype <= 0.0)
			self.armortype = ARMOR_LIGHT;
		
		self.items &= ~IT_ARMOR;
		if (self.armortype <= ARMOR_LIGHT)
			self.items |= IT_ARMOR1;
		else if (self.armortype <= ARMOR_MEDIUM)
			self.items |= IT_ARMOR2;
		else
			self.items |= IT_ARMOR3;
	}
	
	SetPhysics(self, SOLID_NOT, MOVETYPE_NONE);
	InitializeEntity(self);
	
	// Allow setting up custom events/messages on map start
	SetNextThink(self, 0.2, A_StartMap);
}

// Same as above but allows specifying DM options
void info_dmmap()
{
	if (!deathmatch)
	{
		RemoveEntity(self);
		return;
	}
	
	self.team = 1;
	info_map();
}

void StartLight(entity e)
{
	if (!e.targetname && (e.spawnflags & LIGHT_OFF))
	{
		// inert light
		self = e;
		A_ThrowEntityException("Toggled off light had no specified targetname");
	}
	
	if (e.style >= 32)
	{
		if (!e.message)
			e.message = "m";
		
		e.use = A_LightUse;
		if (e.spawnflags & START_OFF)
			SetLightStyle(e.style, "a");
		else
			SetLightStyle(e.style, e.message);
	}
	
	if (e.noise1 && e.volume > 0.0)
	{
		PrecacheSound(e.noise1);
		
		e.volume = Min(e.volume, 1.0);
		e.distance = Clamp(e.distance, ATTN_NONE, ATTN_MAX);
		
		PlayAmbientSound(e.origin, e.noise1, e.volume, e.distance);
	}
}

void A_LightUse()
{
	if (self.spawnflags & START_OFF)
	{
		SetLightStyle(self.style, self.message);
		self.spawnflags &= ~START_OFF;
	}
	else
	{
		SetLightStyle(self.style, "a");
		self.spawnflags |= START_OFF;
	}
}

enumflags
{
	LIGHT_OFF,
};

void light()
{
	if (!e.volume)
		e.volume = 0.5;
	if (!e.distance)
		e.distance = ATTN_STATIC;
	
	StartLight(self, self.noise1);
}

void light_fluoro()
{
	if (!self.noise1)
		self.noise1 = "ambience/fl_hum1.wav";
	
	light();
}

void light_fluorospark()
{
	if (!self.style)
		self.style = 10;
	if (!self.noise1)
		self.noise1 = "ambience/buzz1.wav";
	
	light();
}

// Generic entity for setting sprite-based lights
void light_sprite()
{
	PrecacheModel(self.model);
	
	SetModel(self, self.model);
	
	MakeEntityStatic(self);
}

// Little glowy orbs in E4
void light_globe()
{
	self.model = "progs/s_light.spr";
	
	light_sprite();
}

void StartTorch(entity e)
{
	if (!e.volume)
		e.volume = 0.5;
	if (!e.distance)
		e.distance = ATTN_STATIC;
	if (!e.noise1)
		e.noise1 = "ambience/fire1.wav";
	
	PrecacheModel(e.model);
	
	SetModel(e, e.model);
	
	if (e.volume > 0.0)
	{
		PrecacheSound(e.noise1);
		
		e.volume = Min(e.volume, 1.0);
		e.distance = Clamp(e.distance, ATTN_NONE, ATTN_MAX);
		
		PlayAmbientSound(e.origin, e.noise1, e.volume, e.distance);
	}
	
	MakeEntityStatic(e);
}

// Generic entity for torches
void light_torch()
{
	if (!self.model)
		A_ThrowEntityException("No model defined");
	
	StartTorch(self);
}

void light_torch_small_walltorch()
{
	self.model = "progs/flame.mdl";
	
	light_torch();
}

void light_flame_large_yellow()
{
	self.frame = 1;
	self.model = "progs/flame2.mdl";
	
	light_torch();
}

void light_flame_small_yellow()
{
	self.model = "progs/flame2.mdl";
	
	light_torch();
}

void light_flame_small_white()
{
	self.model = "progs/flame2.mdl";
	
	light_torch();
}

void A_LaunchFireball()
{
	SpawnMissile(self, missile_fireball, self.origin, [50.0 * CRandom(), 50.0 * CRandom(), self.speed + 200.0 * Random()], 1.0);
	
	SetNextThink(self, 3.0 + 5.0 * Random(), A_LaunchFireball);
}

void missile_fireball()
{
	self.dmg = 20;
	self.damage_type = "burn";
	self.misc_action = TE_INVALID;
	self.obituary = " downed a fireball";
	self.count = 1; // Set it to instantly explode on first bounce
	
	StartMissile(self, "progs/lavaball.mdl", TRUE);
}

void misc_fireball()
{
	PrecacheEntity(missile_fireball);
	
	if (self.rand_value <= 0.0)
		self.rand_value = 5.0;
	if (self.wait <= 0.0)
		self.wait = RandomTime(self.rand_value);
	if (self.speed <= 0.0)
		self.speed = 1000.0;
	
	SetPhysics(self, SOLID_NOT, MOVETYPE_NONE);
	InitializeEntity(self);
	
	SetNextThink(self, self.wait, A_LaunchFireball);
}

void A_BarrelExplode()
{
	if (self.rad_dmg >= 1)
	{
		// If chaining barrel explosions, get the real entity that started the chain
		entity attacker;
		for (attacker = self; attacker.activator; attacker = attacker.activator);
		
		// Some kind of map script, so monsters should ignore its activator entirely
		if (!IsClient(attacker) || !IsMonster(attacker))
			attacker = world;
		
		RadiusAttack(self, attacker, self.rad_dmg, Ceiling(self.rad_dmg * 0.5), self.distance, self);
	}

	SpawnEntityType("effect_barrelexplosion", self.origin + [0.0, 0.0, 32.0]);
	DestroyEntity(self);
}

void A_CheckBarrelFloor()
{
	self.origin.z += 2.0;
	func_destructible();
	
	if (!A_TryDropToFloor())
		A_ThrowEntityException("Explosive box did not have a valid floor underneath it");
}

void misc_explobox()
{
	PrecacheModel("maps/b_explob.bsp");
	
	self.use = A_BarrelExplode; // Let activating it explode as well
	self.th_die = A_BarrelExplode;
	
	self.model = "maps/b_explob.bsp";
	self.health = 20;
	self.rad_dmg = 160;
	self.distance = 200.0;
	self.damage_type = "explode";
	self.obituary = " needs to pay better attention";
	
	SetNextThink(self, 0.2, A_CheckBarrelFloor);
}

void misc_explobox2()
{
	PrecacheModel("maps/b_exbox2.bsp");
	
	self.use = A_BarrelExplode;
	self.th_die = A_BarrelExplode;
	
	self.model = "maps/b_exbox2.bsp";
	self.health = 20;
	self.rad_dmg = 160;
	self.distance = 200.0;
	self.damage_type = "explode";
	self.obituary = " needs to pay better attention";
	
	SetNextThink(self, 0.2, A_CheckBarrelFloor);
}

void A_AnimateModel()
{
	self.frame = AdvanceFrame(self.frame, self.pos1.x, self.pos1.y);
	if (self.frame < self.pos1.y || !self.pos1.z)
		SetNextThink(self, 0.1, A_AnimateModel);
}

void A_ModelUse()
{
	if (self.state == FUNC_ACTIVATED)
		return;
	
	self.state = FUNC_ACTIVATED;
	A_AnimateModel();
}

enumflags
{
	MDL_OFF,
};

void misc_model()
{
	if (!self.model)
		A_ThrowEntityException("No defined model");
	
	self.use = A_ModelUse;
	
	self.state = FUNC_ACTIVATED;
	
	SetPhysics((self.mins || self.maxs) ? SOLID_BBOX : SOLID_NOT, MOVETYPE_NONE);
	InitializeEntity(self, self.model, self.mins, self.maxs);
	
	if (self.pos1)
	{
		if (!(self.spawnflags & MDL_OFF))
			SetNextThink(self, 0.1, A_AnimateModel);
		else
			self.state = FUNC_DEACTIVATED;
	}
}

// These have been split into their owner projectile entities
// so they can be balanced separately from the player/enemy
// projectile types

void missile_trapspike()
{
	self.dmg = 9;
	self.deathtype = "spike";
	self.deadflag = TE_SPIKE;
	self.Obituary = " was spiked to the wall";
	
	StartMissile(self, "");
}

void missile_trapsuperspike()
{
	self.dmg = 18;
	self.deathtype = "spike";
	self.deadflag = TE_SUPERSPIKE;
	self.Obituary = " was spiked to the wall";
	
	StartMissile(self, "");
}

void missile_traplaser()
{
	self.dmg = 18;
	self.deathtype = "plasma";
	self.deadflag = TE_GUNSHOT;
	self.Obituary = " was melted by a laser";
	self.noise2 = "enforcer/enfstop.wav";
	
	StartMissile(self, "progs/laser.mdl");
}

void F_TrapThink()
{
	self.use();
	
	SetNextThink(self, self.wait, F_TrapThink);
}

void F_TrapUse()
{
	// Update to whoever activated us last
	if (self.activator)
		self.enemy = self.activator;
	
	if (self.noise1)
		PlaySound(self, CHAN_WEAPON, self.noise1, 1.0, ATTN_NORM);
	
	vector orig = GetCenter(self);
	vector dir = self.movedir;
	if (spawnflags & TRAP_AIM_ENEMY)
	{
		vector curForward = v_forward;
		v_forward = self.movedir;
		dir = GetAimDir(self.enemy, orig);
		v_forward = curForward;
	}
	
	// Set the enemy just in case projectile logic needs to use it
	entity missile = SpawnMissile(self, self.th_missile, orig, dir, self.speed, self.pos1, self.attack_finished);
	missile.enemy = self.enemy;
}

enumflags
{
	// These have to be here for backwards compat and serve no
	// purpose on the base entity
	SPAWNFLAG_SUPERSPIKE,
	SPAWNFLAG_LASER,
	
	// New flags
	
	TRAP_AIM_ENEMY,	// Aim directly at its enemy instead of forward
	TRAP_TOGGLE,
	TRAP_ON,
};

// Generic class that allows traps to fire any missile
// entity they'd like
void trap_shooter()
{
	if (!self.th_missile)
		A_ThrowEntityException("No missile type given");
	
	if (self.speed <= 0.0)
		self.speed = 500.0;
	if (!self.attack_finished)
		self.attack_finished = 5.0;
	
	if (self.noise1)
		PrecacheSound(self.noise1);
	
	PrecacheEntity(self.th_missile);
	
	F_SetMoveDir();
	
	self.use = F_TrapUse;
	
	self.state = FUNC_DEACTIVATED;
	
	StartFunc(self);
	
	if (self.wait > 0.0)
	{
		self.state = FUNC_ACTIVATED;
		SetNextThink(self, self.wait, F_TrapThink);
	}
	else
	{
		self.spawnflags &= ~TRAP_TOGGLE;
	}
}

// Old way of doing this. Don't use this unless you specifically want
// vanilla Quake's traps
void trap_spikeshooter()
{
	if (self.spawnflags & SPAWNFLAG_LASER)
	{
		self.th_missile = missile_traplaser;
		self.noise1 = "enforcer/enfire.wav";
		self.speed = 600.0;
		self.attack_finished = -1.0;
	}
	else
	{
		self.th_missile = (self.spawnflags & SPAWNFLAG_SUPERSPIKE) ? missile_trapsuperspike : missile_trapspike;
		self.noise1 = "weapons/spike2.wav";
		self.speed = 500.0;
		self.attack_finished = 6.0;
	}
	
	trap_shooter();
}

void trap_shooter()
{
	if (!self.wait)
		self.wait = 1.0;
	
	trap_spikeshooter();
}

void F_BubblesUse()
{
	if (self.state == FUNC_ACTIVATED)
	{
		self.state = FUNC_DEACTIVATED;
		ClearThink(self);
	}
	else if (self.state == FUNC_DEACTIVATED)
	{
		self.state = FUNC_ACTIVATED;
		A_SpawnBubbles();
	}
}

void A_SpawnBubbles()
{
	do
	{
		entity bubble = SpawnEntityType(effect_bubble, self.origin);
		bubble.velocity.z = 15.0;
		
		if (self.count >= 1 && --self.count < 1)
		{
			DestroyEntity(self);
			return;
		}
	} while (self.spawnflags & BUB_BURST);
	
	SetNextThink(self, RandomTime(0.5), A_SpawnBubble);
}

enumflags
{
	BUB_BURST,
};

void air_bubbles()
{
	if (!self.wait)
		self.wait = 1.0;
	if ((self.spawnflags & BUB_BURST) && self.count < 1)
		self.count = 10;
	
	self.use = F_BubblesUse;
	
	if (self.wait > 0.0)
	{
		self.state = FUNC_ACTIVATED;
		SetNextThink(self, self.wait, A_SpawnBubbles);
	}
	else
	{
		self.state = FUNC_DEACTIVATED;
	}
}

void ambient_suck_wind()
{
	self.noise1 = "ambience/suck1.wav";
	self.volume = 1.0;
	
	ambient_sound();
}

void ambient_drone()
{
	self.noise1 = "ambience/drone6.wav";
	
	ambient_sound();
}

void ambient_flouro_buzz()
{
	self.noise1 = "ambience/buzz1.wav";
	self.volume = 1.0;
	
	ambient_sound();
}

void ambient_drip()
{
	self.noise1 = "ambience/drip1.wav";
	
	ambient_sound();
}

void ambient_comp_hum()
{
	self.noise1 = "ambience/comp1.wav";
	self.volume = 1.0;
	
	ambient_sound();
}

void ambient_thunder()
{
	self.noise1 = "ambience/thunder1.wav";
	
	ambient_sound();
}

void ambient_light_buzz()
{
	self.noise1 = "ambience/fl_hum1.wav";
	
	ambient_sound();
}

void ambient_swamp1()
{
	self.noise1 = "ambience/swamp1.wav";
	
	ambient_sound();
}

void ambient_swamp2()
{
	self.noise1 = "ambience/swamp2.wav";
	
	ambient_sound();
}

void F_AmbientUse()
{
	PlayAmbientSound(self.origin, self.noise1, self.volume, self.distance);
	
	DestroyEntity(self);
}

enumflags
{
	AMB_OFF,
};

void ambient_sound()
{
	if (!self.noise1)
		A_ThrowEntityException("No sound given");
	
	if (self.volume <= 0.0)
		self.volume = 0.5;
	if (!self.distance)
		self.distance = ATTN_STATIC;
	
	PrecacheSound(self.noise1);
	
	self.use = F_AmbientUse;
	
	self.volume = Min(self.volume, 1.0);
	self.distance = Clamp(self.distance, ATTN_NONE, ATTN_MAX);
	
	if (!(self.spawnflags & AMB_OFF))
	{
		self.use();
	}
	else
	{
		SetPhysics(self, SOLID_NOT, MOVETYPE_NONE);
		InitializeEntity(self);
	}
}
