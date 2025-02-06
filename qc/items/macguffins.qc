void P_SigilTouch()
{
	if (!IsValidClient(other) || HasFlags(serverflags, self.MacGuffinInventory))
		return;

	// Print this to everyone since it's a global pickup
	PlaySound(self, CHAN_ITEM, self.noise1, 1.0, ATTN_NONE);
	for (entity p = NextEntity(world); IsClient(p); p = NextEntity(p))
	{
		RunClientCommand(p, "bf\n");
		if (!self.message)
			CenterPrint(p, p == other ? "You" : other.netname, " got the ", self.netname, "!");
	}
	
	serverflags |= self.MacGuffinInventory;
	
	ActivateEntity(self, other, TRUE);
	DestroyEntity(self);
}

// Sigils have been heavily expanded to be used with any server flag rather than
// just the first four episodes, that way up to 24 can be supported. These are
// still the only way to have key items transfer between levels for the purposes
// of things like gates
void item_sigil()
{
	// This way of setting flags isn't supported anymore but
	// is needed for vanilla Quake support
	self.MacGuffinInventory |= (self.spawnflags & RUNE_ALL);
	
	if (!self.MacGuffinInventory)
		A_ThrowEntityException("No sigil set");
	
	self.touch = P_SigilTouch;
	
	if (!self.noise1)
		self.noise1 = "misc/runekey.wav";

	string mod = self.model;
	string name;
	if (!mod)
	{
		if (self.MacGuffinInventory & RUNE_EP_4)
		{
			mod = "progs/end4.mdl";
			name = "Rune of Elder Magic";
		}
		else if (self.MacGuffinInventory & RUNE_EP_3)
		{
			mod = "progs/end3.mdl";
			name = "Rune of Hell Magic";
		}
		else if (self.MacGuffinInventory & RUNE_EP_2)
		{
			mod = "progs/end2.mdl";
			name = "Rune of Black Magic";
		}
		else
		{
			mod = "progs/end1.mdl";
			name = "Rune of Earth Magic";
		}
	}
	
	if (!self.netname)
		self.netname = name ? name : "sigil";
	
	StartItem(self, mod);
}

void P_MacGuffinTouch()
{
	if (!IsValidClient(other))
		return;
	
	bool_t global = !(self.spawnflags & MAC_LOCAL);
	if (global)
	{
		if (HasFlags(MacGuffinItems, self.MacGuffinInventory))
			return;
		
		MacGuffinItems |= self.MacGuffinInventory;
		
		PlaySound(self, CHAN_ITEM, self.noise1, 1.0, ATTN_NONE);
		for (entity p = NextEntity(world); IsClient(p); p = NextEntity(p))
		{
			p.items |= self.items;
			RunClientCommmand(p, "bf\n");
			if (!self.message)
				CenterPrint(p, p == other ? "You" : other.netname, " picked up the ", self.netname, "!");
		}
	}
	else
	{
		if (HasFlags(other.MacGuffinInventory, self.MacGuffinInventory))
			return;
		
		other.items |= self.items;
		other.MacGuffinInventory |= self.MacGuffinInventory;
		
		PlaySound(other, CHAN_ITEM, self.noise1, 1.0, ATTN_NORM);
		RunClientCommmand(other, "bf\n");
		Print(other, "Picked up the ", self.netname, "\n");
	}
	
	ActivateEntity(self, other, global);
	if (IsOnline() && !global)
		DestroyEntity(self);
}

// Global items
enumflags
{
	// Keys were converted into their own global MacGuffins simply to make
	// handling them easier when playing online. Being able to repeatedly
	// pick up keys entirely breaks the flow of maps that have multi-keys
	MGG_KEY1,
	MGG_KEY2,
};

// Local items
enumflags
{
	
};

// The global one is mostly to make shared items easier to handle
flags_t MacGuffinItems;
.flags_t MacGuffinInventory;

enumflags
{
	MAC_LOCAL,
};

// Generic way for mappers to add more key items to maps without needing
// to modify base scripts. This helps improve overall gameplay mod
// compability since mappers won't have to go out of their way to add
// new items unless necessary
void item_macguffin()
{
	if (!self.MacGuffinInventory)
		A_ThrowEntityException("No item value provided");
	if (!self.model)
		A_ThrowEntityException("No model provided");
	
	if (!self.netname)
		self.netname = "MacGuffin";
	if (!self.noise1)
		self.noise1 = "misc/medkey.wav";
	
	self.touch = P_MacGuffinTouch;
	
	// Currently this is only supported for the keys, but if you
	// want to expand it to mappers, just modify this so that
	// it removes any unwanted bits
	self.items = 0;
	if (!(self.spawnflags & MAC_LOCAL))
	{
		if (self.MacGuffinInventory & MGG_KEY1)
			self.items |= IT_KEY1;
		if (self.MacGuffinInventory & MGG_KEY2)
			self.items |= IT_KEY2;
	}
	
	StartItem(self, self.model);
}

void item_key1()
{
	if (world.worldtype == WORLD_MEDIEVAL)
	{
		self.model = "progs/w_s_key.mdl";
		self.noise1 = "misc/medkey.wav";
		self.netname = "silver key";
	}
	else if (world.worldtype == WORLD_METAL)
	{
		self.model = "progs/m_s_key.mdl";
		self.noise1 = "misc/runekey.wav";
		self.netname = "silver runekey";
	}
	else if (world.worldtype == WORLD_BASE)
	{
		self.model = "progs/b_s_key.mdl";
		self.noise1 = "misc/basekey.wav";
		self.netname = "silver keycard";
	}
	
	self.spawnflags &= ~MAC_LOCAL;
	self.MacGuffinInventory = MGG_KEY1;
	
	item_macguffin();
}

void item_key2()
{
	if (world.worldtype == WORLD_MEDIEVAL)
	{
		self.model = "progs/w_g_key.mdl";
		self.noise1 = "misc/medkey.wav";
		self.netname = "gold key";
	}
	else if (world.worldtype == WORLD_METAL)
	{
		self.model = "progs/m_g_key.mdl";
		self.noise1 = "misc/runekey.wav";
		self.netname = "gold runekey";
	}
	else if (world.worldtype == WORLD_BASE)
	{
		self.model = "progs/b_g_key.mdl";
		self.noise1 = "misc/basekey.wav";
		self.netname = "gold keycard";
	}
	
	self.spawnflags &= ~MAC_LOCAL;
	self.MacGuffinInventory = MGG_KEY2;
	
	item_macguffin();
}
