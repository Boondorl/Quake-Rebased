
$framevalue 1
$frame Thunderbolt1 Thunderbolt2 Thunderbolt3 Thunderbolt4

void() W_Thunderbolt1 = [ $Thunderbolt1, __NULL__ ] { self.frame = AdvanceFrame(self.weaponframe, $Thunderbolt1, $Thunderbolt4); };

void A_FireThunderbolt()
{
	// Not currently in the animation loop, so start the initial sound
	if (self.think != S_PlayerMissileLoopB1())
	{
		self.timer_finished = 0.0;
		PlaySound(self, CHAN_AUTO, "weapons/lstart.wav", 1.0, ATTN_NORM);
	}
	
	if (TimerExpired(self.timer_finished))
	{
		PlaySound(self, CHAN_WEAPON, "weapons/lhit.wav", 1.0, ATTN_NORM);
		SetCoolDown(self, timer_finished, 0.6);
	}
	
	self.effects |= EF_MUZZLEFLASH;
	self.punchangle.x = -2.0;
	SetCoolDown(self, attack_finished, 0.1);
	
	SetWeaponState(self, W_Lightning1);
	S_PlayerMissileLoopB1();
	
	// Kaboom
	if (self.waterlevel >= DEPTH_WAIST)
	{
		int_t remaining = GetAmmoCount(self, e.CurrentAmmoType);
		
		// Make sure to account for the ammo we just spent as well
		int_t radDmg = 35 * (remaining + Weapons[e.CurrentSlot].AmmoUse);
		RadiusAttack(self, self, radDmg, Ceil(radDmg * 0.5), radDmg + 40.0, world);
		DepleteAmmo(self, e.CurrentAmmoType, remaining);
		return;
	}
	
	vector orig = self.origin;
	orig.z += 16.0;
	
	// Draw the visual effect
	vector aimDir = GetAutoaimDir(self, 6000.0);
	TraceLine(orig, orig + aimDir * 600.0, MOVE_NOMONSTER, self);

	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_LIGHTNING2);
	WriteEntity(MSG_BROADCAST, self);
	WriteCoord(MSG_BROADCAST, orig.x);
	WriteCoord(MSG_BROADCAST, orig.y);
	WriteCoord(MSG_BROADCAST, orig.z);
	WriteCoord(MSG_BROADCAST, trace_endpos.x);
	WriteCoord(MSG_BROADCAST, trace_endpos.y);
	WriteCoord(MSG_BROADCAST, trace_endpos.z);
	
	// Now do the actual damage
	TraceLine(orig, trace_endpos - aimDir * 4.0, MOVE_MISSILE, self);
	if (trace_fraction == 1.0)
		return;
	
	SpawnParticles(trace_endpos, [0.0, 0.0, 100.0], 225, 120);
	if (trace_ent.takedamage != DAMAGE_NO)
	{
		DamageEntity(trace_ent, self, self, 30);
		if (trace_ent.movetype == MOVETYPE_WALK)
			trace_ent.velocity.z += 400.0;
	}
}

void weapon_lightning()
{
	if (!self.wait)
		self.wait = 20.0;
	
	if (CanPrecache())
		PrecacheModel("progs/g_light.mdl");
	
	self.touch = P_WeaponTouch;
	
	self.CurrentSlot = GetWeaponSlot(SLOT_POWER, LAYER_DEFAULT);
	self.amount = 15;
	
	StartItem(self, "progs/g_light.mdl");
}
