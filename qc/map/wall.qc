void F_WallUse()
{
	if (self.state == FUNC_ACTIVATED)
	{
		self.state = FUNC_DEACTIVATED;
		if (spawnflags & WALL_TOGGLE)
		{
			self.model = __NULL__;
			SetPhysics(self, SOLID_NOT, MOVETYPE_NONE, TRUE);
		}
		else
		{
			self.frame = 1;
		}
	}
	else if (self.state == FUNC_DEACTIVATED)
	{
		self.state = FUNC_ACTIVATED;
		if (spawnflags & WALL_TOGGLE)
		{
			self.model = self.mdl;
			SetPhysics(self, SOLID_BSP, MOVETYPE_PUSH, TRUE);
		}
		else
		{
			self.frame = 0;
		}
	}
}

enumflags
{
	WALL_TOGGLE,
	WALL_OFF,
};

void func_wall()
{
	self.use = F_WallUse;
	
	self.mdl = self.model;
	self.frame = 0;
	self.state = FUNC_ACTIVATED;
	
	// Instant grenade explosion hack. Don't actually
	// use this for modern maps
	if (self.th_die)
	{
		self.th_die = __NULL__;
		self.takedamage = DAMAGE_DESTRUCT;
		self.health = INT_MAX;
		self.flags |= FL_MUST_GIB;
	}
	
	StartFunc(self);
	
	if (self.spawnflags & WALL_OFF)
		self.use();
}

// For walls meant to hide secrets
void func_illusionary()
{
	self.morigin = self.origin;
	self.mangle = self.angles;
	
	self.angles = VEC_ZERO;
	
	SetPhysics(self, SOLID_NOT, MOVETYPE_NONE);
	InitializeEntity(self, self.model);
}

// These have been split off from the spawnflags so that every bit
// can properly be used instead of some being off limits (see the
// general SPAWNFLAG_* flags)

// Blocks off a location if the runes were already gotten
void func_episodegate()
{
	// Make sure to grab the original MacGuffins, even if you're not
	// supposed to set them here anymore
	self.MacGuffinInventory |= (self.spawnflags & RUNE_ALL);
	if (!self.MacGuffinInventory)
		A_ThrowEntityException("Gate has no defined runes to check");
	
	if (!HasFlags(serverflags, self.MacGuffinInventory))
	{
		RemoveEntity(self);
		return;
	}

	StartFunc(self);
}

// Does the opposite of episodegate, only disappearing if all runes
// have been gathered
void func_bossgate()
{
	if (!self.MacGuffinInventory)
		self.MacGuffinInventory = RUNE_ALL;
	
	if (HasFlags(serverflags, self.MacGuffinInventory))
	{
		RemoveEntity(self);
		return;
	}
	
	StartFunc(self);
}

// Generic breakable walls. Cool for setpieces like gore nests, but also a good basis
// for any kind of breakable map object like crates
enumflags
{
	BREAK_BLEED, // Spawn blood on impact
};

void func_breakable()
{
	if (!self.rand_value)
		self.rand_value = 0.2;
	
	// Chance for pain sound to play
	self.rand_value = Clamp(self.rand_value, 0.0, 1.0);
	self.takedamage = (self.spawnflags & BREAK_BLEED) ? DAMAGE_DESTRUCT_BLEED : DAMAGE_DESTRUCT;
	
	if (self.noise)
		PrecacheSound(self.noise);
	if (self.noise1)
		PrecacheSound(self.noise1); // Pain sound
	
	StartFunc(self);
}
