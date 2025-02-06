// All weapon states are called from the entity holding the weapon since
// no actual entity exists for the weapon view model itself
void SetWeaponState(entity e, void() state)
{
	void() curThink = e.think;
	float curNext = e.nextthink;
	uint8_t curFrame = e.frame;
	
	InvokeAsSelf(e, state);
	
	float fps = weapons[e.current_slot].framerate;
	
	e.weapon_think = e.think;
	e.weapon_next_think = fps > 0.0 ? 1.0 / fps : e.nextthink;
	e.weaponframe = e.frame;
	
	e.think = curThink;
	e.nextthink = curNext;
	e.frame = curFrame;
}

void UpdateWeaponThink(entity e)
{
	if (e.weapon_next_think <= 0.0 || !TimerExpired(e.weapon_next_think))
		return;
	
	e.weapon_next_think = 0.0;
	if (!e.weapon_think)
	{
		if (e.weapon_state == WS_DESELECTING)
		{
			if (!SetWeapon(e, e.pending_slot))
				ClearWeapon(e);
		}
		else
		{
			e.weaponframe = 0;
		}
	}
	else
	{
		SetWeaponState(e, e.weapon_think);
	}
}

inline bool_t CheckWeaponLandState(entity e, flags_t wFlags)
{
	return (e.waterlevel >= DEPTH_SUBMERGED && !(wFlags & WF_NO_WATER))
			|| (e.waterlevel < DEPTH_SUBMERGED && !(wFlags & WF_NO_LAND));
}

inline bool_t CheckWeaponLandAvoidance(entity e, flags_t wFlags)
{
	return e.waterlevel < DEPTH_WAIST || !(wFlags & WF_AVOID_WATER);
}

inline bool_t CheckValidWeapon(entity e)
{
	return HasWeaponAmmo(e, e.current_slot)
			&& CheckWeaponLandState(e, weapons[e.current_slot].flags);
}

bool_t CanSelectWeapon(entity e, uint_t slot)
{
	if (!HasWeaponAmmo(e, slot))
		return FALSE;
	
	flags_t wFlags = weapons[slot].flags;
	return !(wFlags & WF_NO_SELECT) && CheckWeaponLandState(e, wFlags);
}

void ClearWeapon(entity e)
{
	e.weapon = 0;
	e.items &= ~IT_AMMO;
	e.weapon_think = __NULL__;
	e.weapon_next_think = 0.0;
	e.weaponframe = 0;
	e.weaponmodel = __NULL__;
	e.weapon_state = WS_READY;
	
	e.current_slot = e.pending_slot = INVALID_SLOT;
	SetAmmoType(e, INVALID_AMMO);
}

void PickNewWeapon(entity e)
{
	uint_t highestSlot = INVALID_SLOT;
	int_t highestPrio;
	for (uint_t s; s < MAX_TOTAL_SLOTS; ++s)
	{
		int_t prio = weapons[s].priority;
		if (prio >= 1 && prio > highestPrio
			&& CheckWeaponLandAvoidance(e, weapons[s].flags)
			&& CanSelectWeapon(e, s))
		{
			highestPrio = prio;
			highestSlot = s;
		}
	}
	
	e.pending_slot = highestSlot;
}

void CycleWeaponSlot(entity e, uint_t slot)
{
	uint_t slotOfs = slot % MAX_SLOTS;
	uint_t startLayer = slot == e.current_slot ? Floor(slot / MAX_SLOTS) : -1;
	uint_t curLayer = startLayer + 1;
	if (curLayer >= MAX_LAYERS)
		curLayer = 0;
		
	while (curLayer != startLayer)
	{
		uint_t s = slotOfs + curLayer * MAX_SLOTS;
		if (CanSelectWeapon(self, s))
		{
			self.pending_slot = s;
			break;
		}
		
		if (++curLayer >= MAX_LAYERS)
			curLayer = 0;
	}
}

void NextWeapon(entity e)
{
	uint_t startSlot, startLayer;
	if (self.current_slot >= 0)
	{
		startSlot = self.current_slot % MAX_SLOTS;
		startLayer = Floor(self.current_slot / MAX_SLOTS);
	}
	else
	{
		startLayer = -1;
	}
	
	uint_t curSlot = startSlot;
	uint_t curLayer = startLayer + 1;
	if (curLayer >= MAX_LAYERS)
	{
		curLayer = 0;
		if (++curSlot >= MAX_SLOTS)
			curSlot = 0;
	}
	
	while (curSlot != startSlot || curLayer != startLayer)
	{
		uint_t s = curSlot + curLayer * MAX_WEAPONS;
		if (CanSelectWeapon(self, s))
		{
			self.pending_weapon = s;
			break;
		}
		
		if (++curLayer >= MAX_LAYERS)
		{
			curLayer = 0;
			if (++curSlot >= MAX_SLOTS)
				curSlot = 0;
		}
	}
}

void PreviousWeapon(entity e)
{
	uint_t startSlot, startLayer;
	if (self.current_slot >= 0)
	{
		startSlot = self.current_slot % MAX_SLOTS;
		startLayer = Floor(self.current_slot / MAX_SLOTS);
	}
	else
	{
		startSlot = MAX_SLOTS - 1;
		startLayer = MAX_LAYERS;
	}
	
	int_t curSlot = startSlot;
	int_t curLayer = startLayer - 1;
	if (curLayer < 0)
	{
		curLayer = MAX_LAYERS - 1;
		if (--curSlot < 0)
			curSlot = MAX_SLOTS - 1;
	}
	
	while (curSlot != startSlot || curLayer != startLayer)
	{
		uint_t s = curSlot + curLayer * MAX_SLOTS;
		if (CanSelectWeapon(self, s))
		{
			self.pending_weapon = s;
			break;
		}
		
		if (--curLayer < 0)
		{
			curLayer = MAX_LAYERS - 1;
			if (--curSlot < 0)
				curSlot = MAX_SLOTS - 1;
		}
	}
}

void CheckPendingWeapon(entity e)
{
	if (!IsValidWeapon(e.pending_slot))
		return;
	
	if (HasWeaponAmmo(e, e.pending_slot)
		&& CheckWeaponLandState(e, weapons[e.pending_slot].flags))
	{
		if (e.weapon_state == WS_READY)
		{
			if (weapons[e.pending_slot].th_deselect)
			{
				e.weapon_state = WS_DESELECTING;
				weapons[e.pending_slot].th_deselect();
			}
			
			// If still ready after running the deselect animation, it was probably just
			// doing some cleaning up
			if (e.weapon_state == WS_READY)
				SetWeapon(e, e.pending_slot);
		}
	}
	else if (e.weapon_state == WS_DESELECTING)
	{
		PickNewWeapon(e); // If in the middle of picking a new weapon, try and get a valid one
	}
	else
	{
		e.pending_slot = SLOT_INVALID;
	}
}

void FireWeapon(entity e)
{
	if (e.weapon_state != WS_READY
		|| !IsValidSlot(e.current_slot)
		|| !weapons[e.current_slot].th_attack)
	{
		return;
	}

	e.weapon_state = WS_FIRING;
	SetLocalAxes(e.v_angles); // Make sure we can autoaim correctly
	
	float firerate = weapons[e.current_slot].rpm;
	if (firerate > 0.0)
		SetCoolDown(e, attack_finished, 60.0 / firerate);
	
	flags_t wFlags = weapons[e.current_slot].flags;
	if (!(wFlags & WF_SILENT))
		SetCoolDown(e, alert_finished, 1.0); // wake monsters up
	if (!(wFlags & WF_NO_QUAD_SOUND))
		A_PlayQuadDamageSound();
	DepleteWeaponAmmo(e, e.current_slot);
	weapons[e.current_slot].th_attack();
}

void InventoryFrame(entity e)
{
	if (e.impulse)
		CheckImpulse(e);
	
	if (TimerExpired(e.attack_finished))
	{
		if (e.weapon_state == WS_FIRING)
			e.weapon_state = WS_READY;
		
		if (!CheckValidWeapon(e))
			PickNewWeapon(e);
		
		CheckPendingWeapon(e);
	}
	
	if (e.button0)
		A_FireWeapon();
	
	ItemFrame(e);
	UpdateWeaponThink(e);
}

void PlayQuadDamageSound(entity e)
{
	if (TimerExpired(e.super_sound) && GetItemAmount(e, IT_DMG) > 1)
	{
		SetCoolDown(e, super_sound, 1.0);
		PlaySound(e, CHAN_AUTO, "items/damage3.wav", 1.0, ATTN_NORM);
	}
}
