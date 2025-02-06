
void P_PowerupTouch()
{
	if (!IsValidClient(other))
		return;
	
	entity item = PickupItem(other, self.CurrentSlot, self.amount);
	if (!item)
		return;

	other.effects |= self.effects;
	Print(other, "Picked up the ", self.netname, "\n");
	PlaySound(other, CHAN_ITEM, self.noise1, 1.0, ATTN_NORM);
	RunClientCommand(other, "bf\n");
	
	item.delay = 3.0;
	item.wait = 1.0;
	item.noise = self.noise3;
	item.message = self.Obituary;
	item.effects = self.effects;
	item.attack_finished = 0.0;	// In case of refreshing an existing item
	if (self.attack_finished > 0.0)
		SetNextThink(item, self.attack_finished, A_RemoveItem);

	ActivateEntity(self, other);
	A_HidePickup();
}

void item_artifact_invulnerability()
{
	self.touch = P_PowerupTouch;
	
	self.noise1 = "items/protect.wav";
	self.noise3 = "items/protect2.wav";
	self.netname = "Pentagram of Protection";
	self.Obituary = "Your pentagram's magic wears thin";
	self.wait = 300.0;
	self.amount = 1;
	self.attack_finished = 30.0;
	self.CurrentSlot = ITEM_INVULN;
	self.effects = EF_DIMLIGHT;
	
	StartItem(self, "progs/invulner.mdl");
}

void item_artifact_envirosuit()
{
	self.touch = P_PowerupTouch;
	
	self.noise1 = "items/suit.wav";
	self.noise3 = "items/suit2.wav";
	self.netname = "Biosuit";
	self.Obituary = "Your suit weathers and tears";
	self.wait = 60.0;
	self.amount = 1;
	self.attack_finished = 30.0;
	self.CurrentSlot = ITEM_SUIT;
	
	StartItem(self, "progs/suit.mdl");
}

void item_artifact_invisibility()
{
	self.touch = P_PowerupTouch;
	
	self.noise1 = "items/inv1.wav";
	self.noise3 = "items/inv2.wav";
	self.netname = "Ring of Shadows";
	self.Obituary = "You feel corporeal again";
	self.wait = 300.0;
	self.amount = 1;
	self.attack_finished = 30.0;
	self.CurrentSlot = ITEM_INVIS;
	
	StartItem(self, "progs/invisibl.mdl");
}

void item_artifact_super_damage()
{
	self.touch = P_PowerupTouch;
	
	self.noise1 = "items/damage.wav";
	self.noise3 = "items/damage2.wav";
	self.netname = "Quad Damage";
	self.Obituary = "Your damage begins to fade";
	self.wait = 60.0;
	self.amount = LevelItems[ITEM_DMG].MaxAmount;	// Keep this synched as a max damage amp
	self.attack_finished = 30.0;
	self.CurrentSlot = ITEM_DMG;
	self.effects = EF_DIMLIGHT;
	
	StartItem(self, "progs/quaddama.mdl");
}

void A_CheckPowerupTimer()
{
	if (!TimerExpired(self, self.delay))
		return;
	
	if (self.attack_finished <= 0.0)
	{
		Print(self.owner, self.message, "\n");
		PlaySound(self.owner, CHAN_AUTO, self.noise, 1.0, ATTN_NORM);
	}
	
	if (TimerExpired(self.attack_finished))
	{
		RunClientCommand(self.owner, "bf\n");
		SetCoolDown(self, attack_finished, self.wait);
	}
}

void A_ClearPowerupEffects()
{
	// Make sure not to clear our effects if any other item in its inventory
	// is currently making use of it
	flags_t allEffects;
	for (entity i = self.owner.LevelInventory; i; i = i.LevelInventory)
	{
		if (i == self)
			continue;
		
		allEffects |= i.effects;
	}
	
	self.owner.effects &= ~(self.effects & ~allEffects);
}

void A_SetInvisible()
{
	self.mdl = self.owner.model;
	vector min = self.owner.mins;
	vector max = self.owner.maxs;
	
	SetModel(self.owner, "");
	SetSize(self.owner, min, max);
}

void A_ClearInvisibility()
{
	vector min = self.owner.mins;
	vector max = self.owner.maxs;
	
	SetModel(self.owner, self.mdl);
	SetSize(self.owner, min, max);
}

void A_CheckRingTimer()
{
	if (TimerExpired(self.timer_finished))
	{
		PlaySound(self.owner, MAX_CHANNEL, "", 1.0, ATTN_NORM);
		SetCoolDown(self, timer_finished, 3.0);
	}
	
	A_CheckPowerupTimer();
}
