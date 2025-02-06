// Note that these cannot transfer between levels since there's no way
// to serialize them, so automatically assume they're lost. This is
// meant to be an easily extendable way to add new temporary items
// like powerups and keys since the item flag bits are too limited
// to handle this. It also avoids excessive custom fields needed
// to add new timers.

void Createlevel_items()
{
	levelitem_t item;
	
	// Invulnerability
	item = {
		1,
		IF_ALWAYS_PICKUP,
		IT_INVULN,
		__NULL__,
		A_CheckPowerupTimer,
		A_ClearEffects
	};
	CreateItem(item, ITEM_INVULN);
	
	// Damage amp
	item = {
		4,						// Strength multiplier for damage
		IF_ALWAYS_PICKUP,
		IT_QUAD,
		__NULL__,
		A_CheckPowerupTimer,
		A_ClearEffects
	};
	CreateItem(item, ITEM_DMG);
	
	// Invisibility
	item = {
		1,
		IF_ALWAYS_PICKUP | IF_AUTO_USE,
		IT_INVIS,
		A_SetInvisible,
		A_CheckRingTimer,
		A_ClearInvisibility
	};
	CreateItem(item, ITEM_INVIS);
	
	// Suit
	item = {
		1,
		IF_ALWAYS_PICKUP,
		IT_SUIT,
		__NULL__,
		A_CheckPowerupTimer,
		__NULL__
	};
	CreateItem(item, ITEM_SUIT);
	
	// Health drain
	item = {
		1,
		IF_ALWAYS_PICKUP | IF_AUTO_USE,
		IT_SUPERHEALTH,
		A_StartHealthDrain,
		A_DrainHealth,
		__NULL__
	};
	CreateItem(item, ITEM_ROT);
}

enum uint_t
{
	INVALID_ITEM = -1,
	
	ITEM_INVIS,
	ITEM_SUIT,
	ITEM_INVULN,
	ITEM_DMG,
	ITEM_ROT,
	
	MAX_ITEMS,
};

enumflags
{
	IF_ALWAYS_PICKUP,
	IF_KEEP_DEPLETE,	// Even if reaching 0, keep it in the inventory
	IF_AUTO_USE,		// Call use immediately instead of idling
};

typedef struct
{
	int_t max_amount;
	flags_t flags;
	int_t hud_bit;
	void() th_use;
	void() th_think;
	void() th_destroy;
} levelitem_t;

levelitem_t level_items[MAX_ITEMS];

// Just here so it can be properly typed + set up any other needed defaults
void inventory_item() {}

inline bool_t IsValidItem(uint_t item)
{
	return item >= 0 && item < MAX_ITEMS;
}

entity FindItem(entity e, uint_t item)
{
	for (entity it = e.inventory; it; it = it.inventory)
	{
		if (it.current_slot == item)
			return it;
	}
	
	return world;
}

int_t GetItemAmount(entity e, uint_t item)
{
	entity it = FindItem(e, item);
	return it ? it.amount : 0;
}

void ItemFrame(entity e)
{
	for (entity it = e.inventory; it;)
	{
		entity next = it.inventory;
		if (it.think)
			InvokeAsSelf(it, it.think);
		
		it = next;
	}
}

void CreateItem(levelitem_t item, uint_t index)
{
	if (!MapLoading())
	{
		DebugPrint("Items can only be initialized at map load\n");
		return;
	}
	
	level_items[index] = item;
	level_items[index].hud_bit &= (IT_POWERUPS | IT_SUPERHEALTH);
}

bool_t AddItemAmount(entity item, int_t amt, int_t maxAmt)
{
	if (item.amount >= maxAmt)
		return FALSE;
	
	item.amount = Min(item.amount + amt, maxAmt);
	return TRUE;
}

bool_t DepleteItemAmount(entity item, int_t amt)
{
	item.amount = Max(item.amount - amt, 0);
	return item.amount >= 1;
}

entity SpawnItem(entity e, uint_t item, int_t amt = 1)
{
	entity it = SpawnEntityType(inventory_item);
	it.owner = e;
	it.current_slot = item;
	it.use = level_items[item].th_use;
	it.think = level_items[item].th_think;
	it.th_die = level_items[item].th_destroy;
	e.items |= level_items[item].hud_bit;
	AddItemAmount(it, amt, level_items[item].max_amount);
		
	entity last = e;
	for (entity i = e.inventory; i; i = i.inventory)
		last = i;
	
	last.inventory = it;
	return it;
}

entity GiveItem(entity e, uint_t item, int_t amt = 1)
{
	flags_t iFlags = level_items[item].flags;
	entity owned = FindItem(e, item);
	if (owned)
	{
		bool_t res = TRUE;
		if (!AddItemAmount(owned, amt, level_items[item].max_amount))
			res = (iFlags & IF_ALWAYS_PICKUP);
		
		if ((iFlags & IF_AUTO_USE) && res)
			UseItem(owned);
		
		return res ? owned : world;
	}
	
	owned = SpawnItem(e, item, amt);
	if (iFlags & IF_AUTO_USE)
		UseItem(owned);
	
	return owned;
}

void RemoveItem(entity item)
{
	int_t bit = level_items[item.current_slot].hud_bit;
	int_t bitCount;
	
	entity prev = item.owner;
	for (entity it = item.owner.inventory, bool_t noSet; it; it = it.inventory)
	{
		if (it == item)
		{
			noSet = TRUE;
			continue;
		}
		
		bitCount += (level_items[it.current_slot].hud_bit == bit);
		if (!noSet)
			prev = it;
	}
	
	prev.inventory = item.inventory;
	if (item.th_die)
		InvokeAsSelf(item, item.th_die);
	
	// Nothing else is using this bit, so clear it
	if (!bitCount)
		e.items &= ~bit;
	
	DestroyEntity(item);
}

bool_t UseItem(entity item, int_t amt = 0)
{
	if (item.amount < 1)
		return FALSE;
	
	if (item.use)
		InvokeAsSelf(item, item.use);
	
	if (amt >= 1)
	{
		if (!DepleteItemAmount(item, amt) && !(level_items[item.current_slot].flags & IF_KEEP_DEPLETE))
			RemoveItem(item);
	}
	
	return TRUE;
}

void TransferInventory(entity old, entity new)
{
	if (new.inventory || !old.inventory)
		return;
	
	new.inventory = old.inventory;
	old.inventory = world;
	for (entity item = new.inventory; item; item = item.inventory)
		item.owner = new;
}

void ClearInventory(entity e)
{
	for (entity item = e.inventory; item;)
	{
		entity next = item.inventory;
		RemoveItem(item);
		item = next;
	}
}

// Health rot stuff since it doesn't really go anywhere else
void A_StartHealthDrain()
{
	SetCoolDown(self, attack_finished, 5.0);
}

void A_DrainHealth()
{
	if (self.owner.health <= self.owner.max_health)
	{
		RemoveItem(self);
		return;
	}
	
	if (TimerExpired(self.attack_finished))
	{
		--self.owner.health;
		SetCoolDown(self, attack_finished, 1.0);
	}
}

// Pickups

const vector MIN_PICKUP_SIZE	= [-16.0, -16.0, 0.0];
const vector MAX_PICKUP_SIZE	= [16.0, 16.0, 56.0];

enumflags
{
	ITEM_SPAWNER = 1 << 5,	// Respawns like in deathmatch
	ITEM_USE_ONLY,			// Only respawn if the item is used
	ITEM_IN_PLACE,			// Don't do any sort of floor validating
};

inline bool_t IsValidClient(entity e)
{
	return e.health >= 1 && IsClient(e);
}

// All items now allow a custom .noise to be specified in case some kind of alternative
// sound on pick up message is wanted
void StartItem(entity e, string mod)
{
	e.flags |= FL_ITEM;
	e.mdl = mod;
	if (!e.noise1)
		e.noise1 = "weapons/lock4.wav";
	if (!e.noise2)
		e.noise2 = "items/itembk2.wav";
	
	// Since backpacks can spawn at any time we need to make sure
	// nothing is cached after map load
	if (MapLoading())
	{
		PrecacheModel(mod);
		PrecacheSound(e.noise1);
		PrecacheSound(e.noise2);
		if (e.noise)
			PrecacheSound(e.noise);
	}
	
	// Turn it into a spawner proper if using the old vanilla hacks
	if (e.use == SUB_regen)
	{
		if (e.target == e.targetname)
		{
			e.wait = e.delay;
			e.spawnflags |= ITEM_SPAWNER;
		}
		else
		{
			e.spawnflags |= ITEM_USE_ONLY;
		}
	}
	
	e.use = A_ItemUse;
	e.th_dormant = A_ItemDormant;
	
	e.state = FUNC_ACTIVATED;
	e.mangle = e.angles;
	e.morigin = e.origin;
	if (!e.noise)
		e.noise = STR_EMPTY; // Intentionally stop the talk sound from playing
	
	// Don't become a pickup until unfrozen
	if (e.spawnflags & SPAWNFLAGS_DORMANT)
	{
		SetPhysics(e, SOLID_NOT, MOVETYPE_NONE);
		InitializeEntity(e, e.mdl, MIN_PICKUP_SIZE, MAX_PICKUP_SIZE);
		e.model = __NULL__;
		e.state = FUNC_DEACTIVATED;
		return;
	}
	
	// Ignore any ground checks
	if (e.spawnflags & ITEM_IN_PLACE)
	{
		SetPhysics(e, SOLID_TRIGGER, MOVETYPE_TOSS);
		InitializeEntity(e, e.mdl, MIN_PICKUP_SIZE, MAX_PICKUP_SIZE);
		return;
	}
	
	// Add a delay so the rest of the map has time to properly load in
	// before checking the ground
	SetNextThink(e, 0.2, A_PlaceItem);
}

void PickupItem(entity e, entity client, bool_t hide = 1)
{
	Print(client, e.netname);
	PlaySound(client, CHAN_ITEM, e.noise1, 1.0, ATTN_NORM);
	RunClientCommand(client, "bf\n");
	
	ActivateEntity(e, client);
	
	if (!hide)
		return;
	
	if (e.count >= 1 && --e.count < 1)
	{
		DestroyEntity(e);
		return;
	}
	
	if (!(e.spawnflags & ITEM_USE_ONLY))
	{
		if (e.wait <= 0.0 || (!deathmatch && !(e.spawnflags & ITEM_SPAWNER)))
		{
			DestroyEntity(e);
			return;
		}
		
		SetNextThink(e, e.wait, A_RespawnPickup);
	}
	
	e.model = __NULL__;
	e.state = FUNC_DEACTIVATED;
	SetPhysics(e, SOLID_NOT, MOVETYPE_NONE, TRUE);
}

void A_PlaceItem()
{
	origin.z += 6.0;
	SetPhysics(self, SOLID_TRIGGER, MOVETYPE_TOSS);
	InitializeEntity(self, self.mdl, MIN_PICKUP_SIZE, MAX_PICKUP_SIZE);
	if (!A_TryDropToFloor())
		A_ThrowEntityException("Item was not near a valid floor");
}

void A_ItemDormant(entity activator, bool_t activate)
{
	if (activate)
	{
		self.spawnflags &= ~SPAWNFLAG_DORMANT;
		self.use();
	}
	else
	{
		self.spawnflags |= SPAWNFLAG_DORMANT;
		if (self.state == FUNC_ACTIVATED)
		{
			e.model = __NULL__;
			e.state = FUNC_DEACTIVATED;
			SetPhysics(e, SOLID_NOT, MOVETYPE_NONE, TRUE);
		}
		else
		{
			ClearThink(self);
		}
	}
}

void A_ItemUse()
{
	if ((self.spawnflags & SPAWNFLAGS_DORMANT) || self.state != FUNC_DEACTIVATED)
		return;
	
	ClearThink(self);
	A_RespawnPickup();
}

void A_RespawnPickup()
{
	PlaySound(self, CHAN_BODY, self.noise2, 1.0, ATTN_NORM);
	self.model = self.mdl;
	self.state = FUNC_ACTIVATED;
	SetPhysics(self, SOLID_TRIGGER, MOVETYPE_TOSS, TRUE);
}
