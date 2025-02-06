void CreateAmmoTypes()
{
	ammo_t am;
	
	am = {
		ammo_shells,
		100,
		IT_SHELLS
	};
	CreateAmmoType(am, AMMO_SHELLS);
	
	am.type = ammo_nails;
	am.max_amount = 200;
	am.hud_bit = IT_NAILS;
	CreateAmmoType(am, AMMO_NAILS);
	
	am.type = ammo_rockets;
	am.max_amount = 100;
	am.hud_bit = IT_ROCKETS;
	CreateAmmoType(am, AMMO_ROCKETS);
	
	am.type = ammo_cells;
	am.max_amount = 100;
	am.hud_bit = IT_CELLS;
	CreateAmmoType(am, AMMO_CELLS);
}

enum uint_t
{
	INVALID_AMMO = -1,
	
	AMMO_SHELLS,
	AMMO_NAILS,
	AMMO_ROCKETS,
	AMMO_CELLS,
	
	MAX_AMMO_TYPES,
};

typedef struct
{
	.int_t type;
	int_t max_amount;
	int_t HUD_bit;
} ammo_t;

ammo_t ammo_types[MAX_AMMO_TYPES];

inline bool_t IsValidAmmo(uint_t type)
{
	return type >= 0 && type < MAX_AMMO_TYPES;
}

void CreateAmmoType(ammo_t type, uint_t index)
{
	if (!MapLoading())
	{
		DebugPrint("Ammo types can only be created at map load\n");
		return;
	}
	
	ammo_types[index] = type;
	ammo_types[index].hud_bit &= IT_AMMO;
}

inline int_t GetAmmoCount(entity e, uint_t type)
{
	return IsValidAmmo(type) ? e.(ammo_types[type].Type) : 0;
}

inline bool_t HasAmmo(entity e, uint_t type, int_t minAmt)
{
	return GetAmmoCount(e, type) >= minAmt;
}

void DepleteAmmo(entity e, uint_t type, int_t amt)
{
	if (!IsValidAmmo(type))
		return;
	
	.int_t ammo = ammo_types[type].Type;
	e.ammo = MAX(e.ammo - amt, 0);
	if (e.current_ammo_type == type)
		e.currentammo = e.ammo;
}

bool_t AddAmmo(entity e, uint_t type, int_t amt)
{
	if (!IsValidAmmo(type))
		return TRUE;
	
	.int_t ammo = ammo_types[type].Type;
	int_t maxAmt = ammo_types[type].max_amount;
	
	if (e.ammo >= maxAmt)
		return FALSE;
	
	e.ammo = MIN(e.ammo + amt, maxAmt);
	if (e.current_ammo_type == type)
		e.currentammo = e.ammo;
	
	return TRUE;
}

void SetAmmoType(entity e, uint_t type)
{
	e.current_ammo_type = type;
	e.currentammo = GetAmmoCount(e, type);
	e.items &= ~IT_AMMO;
	if (IsValidAmmo(type))
		e.items |= ammo_types[type].hud_bit;
}

void P_AmmoTouch()
{
	if (!IsValidClient(other)
		|| !AddType(other, e.current_ammo_type, self.amount))
	{
		return;
	}

	if (self.amount == 1)
		Print(other, "Pick up a ", ammo_types[e.current_ammo_type].Name, "\n");
	else
		Print(other, "Picked up some ", ammo_types[e.current_ammo_type].Name, "s\n");
	
	PlaySound(other, CHAN_ITEM, self.noise1, 1.0, ATTN_NORM);
	RunClientCommand(other, "bf\n");

	ActivateEntity(self, other);
	ClearAction(self);
	A_HidePickup();
}

void item_shells()
{
	if (!self.wait)
		self.wait = 30.0;
	
	self.touch = P_AmmoTouch;
	
	self.current_ammo_type = AM_SHELLS;
	self.noise1 = "weapons/lock4.wav";

	string mod;
	if (self.spawnflags & WEAPON_BIG2)
	{
		mod = "maps/b_shell1.bsp";
		self.amount = 40;
	}
	else
	{
		mod = "maps/b_shell0.bsp";
		self.amount = 20;
	}
	
	StartItem(self, mod);
}

void item_spikes()
{
	if (!self.wait)
		self.wait = 30.0;
	
	self.touch = P_AmmoTouch;
	
	self.current_ammo_type = AM_NAILS;
	self.noise1 = "weapons/lock4.wav";

	string mod;
	if (self.spawnflags & WEAPON_BIG2)
	{
		mod = "maps/b_nail1.bsp";
		self.amount = 50;
	}
	else
	{
		mod = "maps/b_nail0.bsp";
		self.amount = 25;
	}
	
	StartItem(self, mod);
}

void item_rockets()
{
	if (!self.wait)
		self.wait = 30.0;
	
	self.touch = P_AmmoTouch;
	
	self.current_ammo_type = AM_ROCKETS;
	self.noise1 = "weapons/lock4.wav";

	string mod;
	if (self.spawnflags & WEAPON_BIG2)
	{
		mod = "maps/b_rock1.bsp";
		self.amount = 10;
	}
	else
	{
		mod = "maps/b_rock0.bsp";
		self.amount = 5;
	}
	
	StartItem(self, mod);
}

void item_cells()
{
	if (!self.wait)
		self.wait = 30.0;
	
	self.touch = P_AmmoTouch;
	
	self.current_ammo_type = AM_CELLS;
	self.noise1 = "weapons/lock4.wav";

	string mod;
	if (self.spawnflags & WEAPON_BIG2)
	{
		mod = "maps/b_batt1.bsp";
		self.amount = 12;
	}
	else
	{
		mod = "maps/b_batt0.bsp";
		self.amount = 6;
	}
	
	StartItem(self, mod);
}
