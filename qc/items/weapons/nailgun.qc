
$frame Ready1
$frame Fire1 Fire2 Fire3 Fire4 Fire5 Fire6 Fire7 Fire8

void() W_NailgunFire1 = [ $Fire1, W_NailgunFire2 ] { self.frame = AdvanceFrame(self.weapon_anim_frame, $Fire1, $Fire8); };
void() W_NailgunFire2 = [ $Ready1, W_WeaponReady1 ] { self.weapon_state = WS_READY; }

void A_FireNailgun()
{
	self.effects |= EF_MUZZLEFLASH;
	self.punchangle.x = -2.0;
	PlaySound(self, CHAN_WEAPON, "weapons/rocket1i.wav", 1.0, ATTN_NORM);
	
	SetWeaponState(self, W_Nailgun1);
	S_PlayerMissileLoopA1();
	
	vector orig = self.origin;
	orig.z += 16.0;
	float ofs = 4.0;
	if (!(self.weaponframe & 1))
		ofs = -ofs;
	orig += v_right * ofs;
	
	entity missile = SpawnMissile(self, missile_nail, orig, GetAutoaimDir(self, 1000.0), 1000.0, VEC_ZERO, 6.0);
	missile.current_slot = self.current_slot;
}

void missile_nail()
{
	self.dmg = 9;
	self.misc_action = TE_SPIKE;
	self.damage_type = "spike";
	
	StartMissile(self, "progs/spike.mdl");
}

void weapon_nailgun()
{
	if (!self.wait)
		self.wait = 20.0;
	
	self.touch = P_WeaponTouch;
	
	self.current_slot = GetWeaponSlot(SLOT_AUTO, LAYER_DEFAULT);
	self.amount = 30;
	
	StartItem(self, "progs/g_nail.mdl");
}
