
// These are only here to support common map hacks in vanilla. They should not be used for anything else

// Common hack for vanilla items that respawn in singleplayer
void SUB_regen()
{
	A_RespawnPickup();
}

// Used to force infighting by spawning a fake missile on top of an enemy
void spike_touch()
{
	self.dmg = 1;
	self.misc_action = TE_INVALID;
	
	P_MissileTouch();
}

// Marker that signals an info_notnull should be replaced with an info_map
// for proper starting gear management
void BackpackTouch() {}

// Marker for backpack spawners
void DropBackpack() {}

// Marker used for pseudo sound triggers
void train_wait() {}

// Hack for forcing something to be non-solid and touchable
void InitTrigger()
{
	StartTrigger(self);
}

// Can be used to spawn explosions at points via activating
void OgreGrenadeExplode()
{
	self.rad_dmg = 40;
	self.damage_type = "explosion";
	self.misc_action = TE_INVALID;
	self.obituary = " spontaneously combusted"; // We can even give it a custom death message!
	
	A_ExplodeMissile();
}

// Used in a few map hacks. Just give the monsters permanent powerup effects
// in these cases
.float super_damage_finished, invincible_finished;

void CheckInfinitePowerUp(entity e)
{
	if (e.super_damage_finished > 0.0)
	{
		entity item = GiveItem(e, IT_DMG, LevelItems[IT_DMG].MaxAmount);
		if (item)
			ClearThink(item);
	}
	
	if (e.invincible_finished > 0.0)
	{
		entity item = GiveItem(e, IT_INVULN, LevelItems[IT_INVULN].MaxAmount);
		if (item)
			ClearThink(item);
	}
}

// Some info_notnulls get used as custom traps more or less, so add proper
// conversions for those (should also help make them more stable + give
// proper multiplayer support)
inline bool_t IsMonsterAttack(void() func)
{
	return FALSE;
}

void W_FireAxe() {}
void W_FireShotgun() {}
void W_FireSuperShotgun() {}
void W_FireSuperNailgun() {}
void W_FireGrenadeLauncher() {}
void W_FireRocketLauncher() {}
void W_FireLightning() {}

inline bool_t IsPlayerAttack(void() func)
{
	return func == W_FireAxe
			|| func == W_FireShotgun || func == W_FireSuperShotgun
			|| func == W_FireSuperNailgun
			|| func == W_FireGrenadeLauncher || func == W_FireRocketLauncher
			|| func == W_FireLightning;
}

void A_BecomeMonsterShooter()
{
	self.class = "trap_shooter";
	self.wait = -1.0;
	if (self.enemy)
	{
		self.enemy = world;
		self.spawnflags |= TRAP_AIM_ENEMY;
	}
	
	switch (self.use)
	{
	
	}
	
	trap_shooter();
}

void A_BecomePlayerShooter()
{
	self.class = "trap_shooter";
	self.enemy = world;
	self.angles = self.v_angles;
	self.wait = -1.0;
	
	switch (self.use)
	{
	case W_FireAxe:
		self.spawnflags |= TRAP_MELEE;
		self.noise1 = "";
		self.distance = 64.0;
		self.dmg = 20;
		self.damage_type = "melee";
		self.obituary = " was chopped down";
		break;
		
	case W_FireShotgun:
		self.spawnflags |= TRAP_BULLET;
		self.noise1 = "";
		self.dmg = 4;
		self.amount = 6;
		self.pos1 = [0.04, 0.04, 0.0];
		self.damage_type = "bullet";
		self.obituary = " was on the wrong end of a boomstick";
		break;
		
	case W_FireSuperShotgun:
		self.spawnflags |= TRAP_BULLET;
		self.noise1 = "";
		self.dmg = 4;
		self.amount = 14;
		self.pos1 = [0.11, 0.08, 0.0];
		self.damage_type = "bullet";
		self.obituary = " was turned into swiss cheese";
		break;
		
	case W_FireSuperNailgun:
		self.th_missile = missile_trapsuperspike;
		self.noise1 = "";
		break;
		
	case W_FireGrenadeLauncher:
		self.th_missile = missile_trapgrenade;
		self.noise1 = "";
		break;
		
	case W_FireRocketLauncher:
		self.th_missile = missile_traprocket;
		self.noise1 = "";
		break;
		
	case W_FireLightning:
		self.spawnflags |= TRAP_LIGHTNING;
		self.noise1 = "";
		self.distance = 600.0;
		self.dmg = 30;
		self.damage_type = "electric";
		self.obituary = " was turned into charcoal";
		break;
	}
	
	trap_shooter();
}
