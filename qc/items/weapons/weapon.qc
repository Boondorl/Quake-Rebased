void CreateWeapons()
{
	// Negative priorities are used for deathmatch ranking
	weapon_t weap;
	
	// Axe
	weap.Name = "Gladius";
	weap.flags = WF_SILENT | WF_MELEE; // Only alert things if we actually hit something with it
	weap.ammo_type = INVALID_AMMO;
	weap.view_model = "progs/v_axe.mdl";
	weap.Obituary = " was chopped down by ";
	weap.priority = 1;
	weap.bit = WPN_AXE;
	weap.hud_bit = IT_AXE;
	weap.Attack = A_FireAxe;
	CreateWeapon(weap, SLOT_MELEE);
	
	// Shotgun
	weap.Name = "Shotgun";
	weap.flags = 0;
	weap.ammo_type = AM_SHELLS;
	weap.ammo_use = 1;
	weap.view_model = "progs/v_shot.mdl";
	weap.Obituary = " chewed on ";
	weap.ObituarySuffix = "'s boomstick";
	weap.priority = 2;
	weap.bit = WPN_SHOTGUN;
	weap.hud_bit = IT_SHOTGUN;
	weap.Attack = A_FireShotgun;
	weap.rpm = 120.0;
	CreateWeapon(weap, SLOT_STARTER);
	
	// Super Shotgun
	weap.Name = "Double-barreled Shotgun";
	weap.ammo_use = 2;
	weap.view_model = "progs/v_shot2.mdl";
	weap.Obituary = " got turned into swiss cheese by ";
	weap.ObituarySuffix = __NULL__;
	weap.priority = 4;
	weap.bit = WPN_SUPER_SHOTGUN;
	weap.hud_bit = IT_SUPER_SHOTGUN;
	weap.Attack = A_FireSuperShotgun;
	weap.rpm = 85.71428571;
	CreateWeapon(weap, SLOT_WORKHORSE);
	
	// Nailgun
	weap.Name = "Nailgun";
	weap.ammo_type = AM_NAILS;
	weap.ammo_use = 1;
	weap.view_model = "progs/v_nail.mdl";
	weap.Obituary = " was nailed by ";
	weap.priority = 3;
	weap.bit = WPN_NAILGUN;
	weap.hud_bit = IT_NAILGUN;
	weap.Attack = A_FireNailgun;
	CreateWeapon(weap, SLOT_AUTO_LIGHT);
	
	// Super Nailgun
	weap.Name = "Super Nailgun";
	weap.view_model = "progs/v_nail2.mdl";
	weap.Obituary = " was perforated by ";
	weap.priority = 6;
	weap.bit = WPN_SUPER_NAILGUN;
	weap.hud_bit = IT_SUPER_NAILGUN;
	weap.Attack = A_FireSuperNailgun;
	CreateWeapon(weap, SLOT_AUTO_HEAVY);
	
	// Grenade Launcher
	weap.Name = "Grenade Launcher";
	weap.ammo_type = AM_ROCKETS;
	weap.view_model = "progs/v_rock.mdl";
	weap.SelfObituary = " tried to put the pin back in";
	weap.Obituary = " ate ";
	weap.ObituarySuffix = "'s pineapple";
	weap.priority = -5;
	weap.bit = WPN_GRENADE_LAUNCHER;
	weap.hud_bit = IT_GRENADE_LAUNCHER;
	weap.Attack = A_FireGrenadeLauncher;
	CreateWeapon(weap, SLOT_UTILITY);
	
	// Rocket Launcher
	weap.Name = "Rocket Launcher";
	weap.view_model = "progs/v_rock2.mdl";
	weap.SelfObituary = " caught their own rocket";
	weap.Obituary = " was blown to smithereens by ";
	weap.ObituarySuffix = "'s rocket";
	weap.priority = -7;
	weap.bit = WPN_ROCKET_LAUNCHER;
	weap.hud_bit = IT_ROCKET_LAUNCHER;
	weap.Attack = A_FireRocketLauncher;
	CreateWeapon(weap, SLOT_RANGED);
	
	// Thunderbolt
	weap.Name = "Thunderbolt";
	weap.flags = WF_AVOID_WATER;
	weap.ammo_type = AM_CELLS;
	weap.view_model = "progs/v_light.mdl";
	weap.SelfObituary = " learned the hard way";
	weap.Obituary = " was fried by ";
	weap.ObituarySuffix = __NULL__;
	weap.priority = 8;
	weap.bit = WPN_THUNDERBOLT;
	weap.hud_bit = IT_LIGHTNING;
	weap.Attack = A_FireThunderbolt;
	CreateWeapon(weap, SLOT_POWER);
}

// This system allows for weapons and ammo types to be freely expanded upon
// in the future if needed, even allowing for multiple layers of slots
enum uint_t
{
	INVALID_SLOT = -1,
	
	SLOT_MELEE,
	SLOT_STARTER,
	SLOT_WORKHORSE,
	SLOT_AUTO_LIGHT,
	SLOT_AUTO_HEAVY,
	SLOT_UTILITY,
	SLOT_RANGED,
	SLOT_POWER,
	
	MAX_SLOTS,
};

enum uint_t
{
	LAYER_DEFAULT,
	
	MAX_LAYERS
};

const uint_t MAX_TOTAL_SLOTS = MAX_SLOTS * MAX_LAYERS;

enumflags
{
	WF_AVAILABLE,		// Weapon is defined and exists
	WF_NO_WATER,		// Can't select in water
	WF_NO_LAND,			// Can't select on land
	WF_NO_SELECT,		// Can't be manually selected at all
	WF_SILENT,			// Don't alert enemies
	WF_NO_QUAD_SOUND,
	WF_MELEE,			// Use the axe player animation instead of the gun
	WF_AVOID_WATER,		// Avoid autochoosing this if underwater
};

// These get checked over the actual item bits, that way it can
// be easily expanded. The item bits more or less determine what
// slots are shown as owned weapons with .weapon determining which
// slot to highlight
enumflags
{
	WPN_AXE,
	WPN_SHOTGUN,
	WPN_SUPER_SHOTGUN,
	WPN_NAILGUN,
	WPN_SUPER_NAILGUN,
	WPN_GRENADE_LAUNCHER,
	WPN_ROCKET_LAUNCHER,
	WPN_THUNDERBOLT,
};

const int_t WPN_DEFAULT	= WPN_AXE | WPN_SHOTGUN;

typedef struct
{
	flags_t flags;
	uint_t ammo_type;
	int_t ammo_use;
	string view_model;
	string self_obituary_prefix, self_obituary_suffix;			// Before, after client name
	string obituary_prefix, obituary_middle, obituary_suffix;	// Before, between, after client names
	int_t priority;		// Selection priority when out of ammo -- bigger number = higher priority. Values of < 1 never get chosen
	int_t bit;			// Which .owned_weapons bit is given
	int_t hud_bit;
	float rpm;			// Rounds per minute for automated attack cool downs
	float framerate;	// Animation playback rate for simple modifications
	void() select;
	void() deselect;
	void() attack;
} weapon_t;

weapon_t weapons[MAX_TOTAL_SLOTS];

inline uint_t GetWeaponSlot(uint_t slot, uint_t layer)
{
	return slot + MAX_SLOTS * layer;
}

inline bool_t IsValidWeapon(uint_t slot)
{
	return slot >= 0 && slot < MAX_TOTAL_SLOTS && (weapons[slot].flags & WF_AVAILABLE);
}

inline bool_t CanUseWeapon(entity e, uint_t slot)
{
	return IsValidWeapon(slot) && (e.owned_weapons & weapons[slot].bit);
}

void CreateWeapon(weapon_t weap, uint_t slot, uint_t layer)
{
	// Only allow weapon creation at map load similar to caching
	if (!MapLoading())
	{
		DebugPrint("Weapons can only be created at map load\n");
		return;
	}
	
	uint_t i = GetWeaponSlot(slot, layer);
	weapons[i] = weap;
	weapons[i].flags |= WF_AVAILABLE;
	weapons[i].hud_bit &= IT_WEAPONS;
}

void GiveWeapon(entity e, uint_t slot)
{
	if (!IsValidWeapon(slot))
		return;
	
	e.owned_weapons |= weapons[slot].bit;
	e.items |= weapons[slot].hud_bit;
}

// These five functions are a lot pricier and should really be used
// sparingly in favor of precaching any sort of owned_weapons and item
// bits for setting purposes.
void TakeWeapon(entity e, uint_t slot)
{
	if (!CanUseWeapon(e, slot))
		return;
	
	e.owned_weapons &= ~weapons[slot].bit;
	
	// Check if it's safe to actually remove the HUD bit
	
	int_t bit = weapons[slot].hud_bit;
	int_t bitCount;
	for (uint_t i; i < MAX_TOTAL_SLOTS; ++i)
		bitCount += (weapons[i].hud_bit == bit);
	
	if (bitCount <= 1)
		e.items &= ~bit;
}

void GiveWeaponFromBit(entity e, int_t bit)
{
	uint_t slot;
	for (; slot < MAX_TOTAL_SLOTS; ++slot)
	{
		if (weapons[slot].bit == bit)
			break;
	}
	
	GiveWeapon(e, slot);
}

void GiveWeaponsFromBits(entity e, flags_t bits)
{
	for (uint_t slot; slot < MAX_TOTAL_SLOTS; ++slot)
	{
		if (weapons[slot].bit & bits)
			GiveWeapon(e, slot);
	}
}

void TakeWeaponFromBit(entity e, int_t bit)
{
	uint_t slot;
	for (; slot < MAX_TOTAL_SLOTS; ++slot)
	{
		if (weapons[slot].bit == bit)
			break;
	}
	
	TakeWeapon(e, slot);
}

void TakeWeaponsFromBits(entity e, flags_t bits)
{
	for (uint_t slot; slot < MAX_TOTAL_SLOTS; ++slot)
	{
		if (weapons[slot].bit & bits)
			TakeWeapon(e, slot);
	}
}

bool_t HasWeaponAmmo(entity e, uint_t slot)
{
	if (!CanUseWeapon(e, slot))
		return FALSE;
	
	int_t use = weapons[slot].ammo_use;
	if (use < 1)
		return TRUE;
	
	return HasAmmo(e, weapons[slot].ammo_type, use);
}

void DepleteWeaponAmmo(entity e, uint_t slot)
{
	if (!CanUseWeapon(e, slot))
		return;
	
	int_t use = weapons[slot].ammo_use;
	if (use < 1)
		return;
	
	DepleteAmmo(e, weapons[slot].Type, use);
}

bool_t SetWeapon(entity e, uint_t slot)
{
	if (!CanUseWeapon(e, slot))
		return FALSE;
	
	e.current_slot = slot;
	e.pending_weapon = INVALID_SLOT;
	e.weapon = weapons[slot].hud_bit;
	e.weaponmodel = weapons[slot].view_model;
	SetAmmoType(e, weapons[slot].ammo_type);
	
	if (weapons[slot].select)
	{
		e.weapon_state = WS_SELECTING;
		SetWeaponState(e, weapons[slot].select);
	}
	else
	{
		e.weapon_state = WS_READY;
		e.weapon_think = __NULL__;
		e.weapon_next_think = 0.0;
		e.weaponframe = 0;
	}
	
	return TRUE;
}

void P_WeaponTouch()
{
	if (!IsValidClient(other))
		return;

	int_t item = weapons[self.current_slot].bit;
	bool_t swapWeapons = !(item & other.owned_weapons) || !HasWeaponAmmo(other, other.current_slot);
	bool_t leave = (deathmatch == DM_CLASSIC || coop);
	if (other.owned_weapons & item)
	{
		if (leave || !AddAmmo(other, weapons[self.current_slot].ammo_type, self.amount))
			return;
	}
	else
	{
		other.owned_weapons |= item;
		other.items |= weapons[self.current_slot].hud_bit;
		AddAmmo(other, weapons[self.current_slot].ammo_type, self.amount);
	}
	
	"weapons/pkup.wav"
	
	Print(other, self.netname, "\n");
	PlaySound(other, CHAN_ITEM, self.noise1, 1.0, ATTN_NORM);
	RunClientCommand(other, "bf\n");
	
	if (deathmatch)
	{
		int_t curPrio = IsValidWeapon(other.current_slot) ? AbsF(weapons[other.current_slot].priority) : -1;
		int_t weapPrio = AbsF(weapons[self.current_slot].priority);
		swapWeapon = curPrio < weapPrio;
	}
	
	if (swapWeapon)
		other.pending_weapon = self.current_slot;

	ActivateEntity(self, other);
	ClearAction(self);
	if (!leave)
		A_HidePickup();
}
