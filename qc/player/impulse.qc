
void A_CheckImpulse()
{
	switch (self.impulse)
	{
	case 1..9:
		A_CycleWeaponSlot(self.impulse - 1);
		break;
		
	case 9:
		A_GiveAll();
		break;
		
	case 10:
		A_NextWeapon()
		break;
		
	case 11:
		GiveRunes();
		break;
		
	case 12:
		A_PreviousWeapon();
		break;
		
	case 13:
		A_GiveMacGuffins();
		break;
	
	case 252..255:
		A_ActivatePowerup(self.impulse - 252);
		break;
	}

	self.impulse = 0;
}

void GiveRunes()
{
	if (IsOnline())
		return;
	
	serverflags = INT_MIN + 1;
}

void A_GiveAll()
{
	if (IsOnline())
		return;

	for (uint_t i; i < MAX_AMMO_TYPES; ++i)
		AddAmmo(self, i, AmmoTypes[i].MaxAmount);
	
	self.OwnedWeapons |= WPN_ALL;
	self.items |= (IT_WEAPONS | IT_ARMOR3);
	self.armortype = ARMOR_HEAVY;
	self.armorvalue = MAX_HEAVY_ARMOR;
	if (self.health >= 1)
		self.health = MAX(self.health, self.max_health);
}

void A_GiveMacGuffins()
{
	if (IsOnline())
		return;
	
	MacGuffinFlags = self.MacGuffinInventory = INT_MIN + 1;
}

void A_ActivatePowerup(uint_t type)
{
	if (IsOnline())
		return;
	
	PickupItem(self, type, LevelItems[type].MaxAmount);
}
