
// This is a new set of trigger types modeled after Copper's target_ triggers
// that are set to do specific things e.g. damage a specify entity. These can
// only specifically be activated and aren't designed to be done via map events
// as proper buttons/triggers are better for that. These can be seen as more or
// less equivalent to Doom's specials

enumflags
{
	TARGET_ALL_CLIENTS = 1 << 6,
	TARGET_NAME,
};

void StartTarget(entity e)
{
	if (!e.targetname)
		A_ThrowEntityException("No targetname given");
	if ((e.spawnflags & TARGET_NAME)
		&& !e.target && !e.target2 && !e.target3 && !e.target4)
	{
		A_ThrowEntityException("No targets given when expecting to activate them");
	}
	if (!e.think)
		A_ThrowEntityException("No valid action was speciied");
	
	if (!e.count)
		e.count = 1;
	
	e.use = F_TargetUse;
	
	SetPhysics(e, SOLID_NOT, MOVETYPE_NONE);
	InitializeEntity(e);
}

void F_TargetUse()
{
	if (IsDormant(self))
		return;
	
	// Catch this early in case of any nested calls
	bool_t destroy;
	if (self.count >= 1 && --self.count < 1)
	{
		self.use = __NULL__;
		destroy = TRUE;
	}
	
	if (!(self.spawnflags & TARGET_NAME))
	{
		if (IsClient(self.activator) && (self.spawnflags & TARGET_ALL_CLIENTS))
		{
			for (entity p = NextEntity(world); IsClient(p); p = NextEntity(p))
			{
				self.goalentity = p;
				self.think();
			}
		}
		else
		{
			self.goalentity = self.activator;
			self.think();
		}
	}
	else
	{
		for (entity e = NextEntity(world); e; e = NextEntity(e))
		{
			if (!CheckTargetName(e, self))
				continue;
			
			self.goalentity = e;
			self.think();
		}
	}
	self.goalentity = world;
	
	if (destroy)
		DestroyEntity(self);
}

void F_TargetDormant(entity activator, bool_t activate)
{
	if (activate)
		self.spawnflags &= ~SPAWNFLAGS_DORMANT;
	else
		self.spawnflags |= SPAWNFLAGS_DORMANT;
}

// ............

void F_TargetDormantUse()
{
	if (!self.goalentity.th_dormant)
		return;
	
	if (self.spawnflags & DORM_ALWAYS_SLEEP)
		self.goalentity.th_dormant(self.activator, FALSE);
	else if (self.spawnflags & DORM_ALWAYS_WAKE)
		self.goalentity.th_dormant(self.activator, TRUE);
	else
		self.goalentity.th_dormant(self.activator, (self.goalentity.spawnflags & SPAWNFLAG_DORMANT));
}

enumflags
{
	DORM_ALWAYS_SLEEP,
	DORM_ALWAYS_WAKE,
};

void target_dormant()
{
	self.think = F_TargetDormantUse;
	
	StartTarget(self);
}

void F_TargetDamageUse()
{
	int_t damage = self.dmg;
	if (self.health >= 1)
		damage = Min(damage, self.goalentity.health - self.health);
	
	if (damage < 1)
		return;
	
	DamageEntity(self.goalentity, self, world, damage);
	if (self.noise1)
		PlaySound(self.goalentity, CHAN_AUTO, self.noise1, 1.0, ATTN_NORM);
	if (self.message && IsClient(self.goalentity))
		CenterPrint(self.goalentity, self.message);
}

// Deals direct damage to its targets
// 	* dmg - Amount of damage to deal
// 	* noise1 - Sound to play if the target was damaged
// 	* health - If >= 1, don't damage targets to below this threshold
// 	* damage_type - Set a custom damage type
// 	* obituary - Set a custom death message if it kills
// 	* message - Center print a message to all affected clients
void target_damage()
{
	if (self.dmg < 1)
		self.dmg = 10;
	if (!self.damage_type)
		self.damage_type = "void";
	if (!self.obituary)
		self.obituary = " was taken by the void";
	
	if (self.noise1)
		PrecacheSound(self.noise1);
	
	self.think = F_TargetDamageUse;
	
	StartTarget(self);
}

void F_TargetHealUse()
{
	if (e.health < 1 || e.max_health < 1)
		continue;
	
	HealEntity(e, self.healamount, self.max_health >= 1 ? self.max_health : e.max_health);
	if (self.noise1)
		PlaySound(e, CHAN_AUTO, self.noise1, 1.0, ATTN_NORM);
	if (self.message && IsClient(e))
		CenterPrint(e, self.message);
}

void target_heal()
{
	if (self.amount < 1)
		self.amount = 10;
	
	if (self.noise1)
		PrecacheSound(self.noise1);
	
	self.think = F_TargetHealUse;
	
	StartTarget(self);
}

void F_TargetTeleportUse()
{
	TeleportEntity(e, self.goalentity.origin, self.goalentity.angles);
}

// Clears whatever thinking the entity is currently in
void target_teleport()
{
	if (!self.target)
		A_ThrowEntityExcept("No target for teleport destination defined");
	
	self.goalentity = FindEntity(world, targetname, self.target);
	if (!self.goalentity)
		A_ThrowEntityException("No valid teleport destination found");
	
	self.think = F_TargetTeleportUse;
	
	F_SetMoveDir(self.goalentity.angles);
	
	StartTarget(self);
}

void F_TargetRemoveUse()
{
	DestroyEntity(e);
}

void target_remove()
{
	self.think = F_TargetRemoveUse;
	
	StartTarget(self);
}

// Force infighting
void target_setenemy()
{
	
}

// Check global server flags
void target_sigil()
{
	
}

// Check global or local item flags
void target_macguffin()
{
	
}

// Play a sound
void target_sound()
{
	
}
