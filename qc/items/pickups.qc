
/*
=========================================================================

HEALTH

=========================================================================
*/

enumflags
{
	H_ROTTEN,
	H_MEGA,
};

void P_HealthTouch()
{
	if (!IsValidClient(other)
		|| !HealEntity(other, self.amount, self.max_health >= 1 ? self.max_health : other.max_health))
	{
		return;
	}

	PickupItem(self, other);
}

void item_health()
{
	if (!self.wait)
		self.wait = 20.0;
	
	self.touch = P_HealthTouch;

	string mod;
	if (self.spawnflags & H_ROTTEN)
	{
		mod = "maps/b_bh10.bsp";
		self.noise1 = "items/r_item1.wav";
		self.netname = HTH_ROTTED;
		self.amount = 15;
	}
	else if (self.spawnflags & H_MEGA)
	{
		mod = "maps/b_bh100.bsp";
		self.noise1 = "items/r_item2.wav";
		self.netname = HTH_MEGA;
		self.amount = 100;
		self.max_health = MAX_HEALTH;
	}
	else
	{
		mod = "maps/b_bh25.bsp";
		self.noise1 = "items/health1.wav";
		self.netname = HTH_NORMAL;
		self.amount = 25;
	}
	
	StartItem(self, mod);
}

// Works similar to the Megahealth but comes in much smaller quantities and
// is treated as a normal health pickup
void item_healthbonus()
{
	if (!self.wait)
		self.wait = 20.0;
	
	self.touch = P_HealthTouch;
	
	self.noise1 = "items/r_item1.wav";
	self.max_health = MAX_HEALTH;
	self.netname = HTH_BONUS;
	self.amount = 5;
	
	StartItem(self, "maps/b_bh5.bsp");
}

/*
===============================================================================

ARMOR

===============================================================================
*/

void P_ArmorTouch()
{
	// TODO: Fix / 0 error
	if (!IsValidClient(other)
		|| other.armorvalue / (1.0 - other.armortype) >= self.armorvalue / (1.0 - self.armortype))
	{
		return;
	}

	other.armortype = self.armortype;
	other.armorvalue = self.armorvalue;
	other.items &= ~IT_ARMOR;
	other.items |= (self.items & IT_ARMOR);
	
	PickupItem(self, other);
}

// Green armor
void item_armor1()
{
	if (!self.wait)
		self.wait = 20.0;
	
	self.touch = P_ArmorTouch;
	
	self.noise1 = "items/armor1.wav";
	self.netname = ARM_LIGHT;
	self.skin = 0;
	self.armorvalue = MAX_LIGHT_ARMOR;
	self.armortype = ARMOR_LIGHT;
	self.items = IT_ARMOR1;
	
	StartItem(self, "progs/armor.mdl");
}

// Yellow armor
void item_armor2()
{
	if (!self.wait)
		self.wait = 20.0;
	
	self.touch = P_ArmorTouch;
	
	self.noise1 = "items/armor1.wav";
	self.netname = ARM_MED;
	self.skin = 1;
	self.armorvalue = MAX_MEDIUM_ARMOR;
	self.armortype = ARMOR_MEDIUM;
	self.items = IT_ARMOR2;
	
	StartItem(self, "progs/armor.mdl");
}

// Red armor
void item_armorInv()
{
	if (!self.wait)
		self.wait = 20.0;
	
	self.touch = P_ArmorTouch;
	
	self.noise1 = "items/armor1.wav";
	self.netname = ARM_HEAVY;
	self.skin = 2;
	self.armorvalue = MAX_HEAVY_ARMOR;
	self.armortype = ARMOR_HEAVY;
	self.items = IT_ARMOR3;
	
	StartItem(self, "progs/armor.mdl");
}

bool_t AddArmor(entity e, int_t amt, int_t maxAmt)
{
	if (e.armorvalue >= maxAmt)
		return FALSE;
	
	e.armorvalue = MIN(e.armorvalue + amt, maxAmt);
	return TRUE;
}

int_t DepleteArmor(entity e, int_t amt)
{
	if (amt < 1)
		return 0;
	
	amt = MIN(amt, e.armorvalue);
	e.armorvalue -= amt;
	if (e.armorvalue < 1)
	{
		e.armortype = ARMOR_NONE;
		e.items &= ~IT_ARMOR;
	}
	
	return amt;
}

// This is more like the health pickup equivalent for armor, but will add onto
// whatever current armor type the client has
void P_ArmorShardTouch()
{
	if (!IsValidClient(other)
		|| !AddArmor(other, self.armorvalue, self.max_health))
	{
		return;
	}
	
	if (other.armortype < self.armortype)
	{
		other.armortype = self.armortype;
		other.items &= ~IT_ARMOR;
		other.items |= (self.items & IT_ARMOR);
	}
	
	PickupItem(self, other);
}

// TODO: Add custom model
void item_armorshard()
{
	if (!self.wait)
		self.wait = 20.0;
	
	self.touch = P_ArmorShardTouch;
	
	self.noise1 = "weapons/lock4.wav";
	self.max_health = MAX_HEAVY_ARMOR;
	self.armorvalue = 5;
	self.armortype = ARMOR_LIGHT;
	self.items = IT_ARMOR1;
	
	StartItem(self, STR_EMPTY);
}

/*
===============================================================================

BACKPACK

===============================================================================
*/

// The long pickup message here was removed in favor of being much easier to localize
// since concatenating numbers randomly is utter chaos for this
void P_BackpackTouch()
{
	if (!IsValidClient(other))
		return;
	
	for (uint i; i < MAX_AMMO_TYPES; ++i)
	{
		.int_t ammo = AmmoTypes[i].Type;
		if (self.ammo < 1)
			continue;
		
		AddAmmo(other, i, self.ammo);
	}

	other.items |= self.items;
	other.OwnedWeapons |= self.OwnedWeapons;
	
	// This is always hardcoded to give whatever armor the player is currently wearing
	// unlike armor shards, otherwise setting this up from the editor would get too messy
	if (self.armorvalue >= 1)
	{
		AddArmor(other, self.armorvalue, MAX_HEAVY_ARMOR);
		if (other.armortype < ARMOR_LIGHT)
		{
			other.armortype = ARMOR_LIGHT;
			other.items &= ~IT_ARMOR;
			other.items |= IT_ARMOR1;
		}
	}

	PickupItem(self, other);
}

void item_backpack()
{
	if (!self.wait)
		self.wait = 30.0;
	
	self.touch = P_BackpackTouch;
	
	self.netname = ;
	self.items &= IT_WEAPONS;
	self.noise1 = "weapons/lock4.wav";
	
	StartItem(self, "progs/backpack.mdl");
}

// Only ammo and weapons are dropped by default
void SpawnBackpack(entity e, bool_t takeItems = 0)
{
	uint_t i;
	for (; i < MAX_AMMO_TYPES; ++i)
	{
		if (e.(AmmoTypes[i].Type) >= 1)
			break;
	}
	
	if (i >= MAX_AMMO_TYPES)
		return;

	vector orig = e.origin;
	orig.z += e.mins.z;
	
	entity item = SpawnEntityType(item_backpack, orig, ITEM_IN_PLACE);
	item.wait = -1.0;
	item.items = (e.items & IT_WEAPONS);
	item.OwnedWeapons = e.OwnedWeapons;
	
	if (takeItems)
	{
		e.OwnedWeapons = 0;
		e.item &= ~IT_WEAPON;
	}

	for (; i < MAX_AMMO_TYPES; ++i)
	{
		.int_t ammo = AmmoTypes[i].Type;
		item.ammo = e.ammo;
		if (takeItems)
			e.ammo = 0;
	}
	
	item.velocity = [100.0 * CRandom(), 100.0 * CRandom(), 300.0];
	
	SetNextThink(item, 120.0, A_Remove);
}
