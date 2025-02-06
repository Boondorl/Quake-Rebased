
$framevalue 1
$frame SuperNailgun1 SuperNailgun2 SuperNailgun3 SuperNailgun4 SuperNailgun5 SuperNailgun6 SuperNailgun7 SuperNailgun8

void() W_SuperNailgun1 = [ $SuperNailgun1, __NULL__ ] { self.frame = AdvanceFrame(self.weaponframe, $SuperNailgun1, $SuperNailgun8); };

void A_FireSuperNailgun()
{
	self.effects |= EF_MUZZLEFLASH;
	self.punchangle.x = -2.0;
	PlaySound(self, CHAN_WEAPON, "weapons/spike2.wav", 1.0, ATTN_NORM);
	SetCoolDown(self, attack_finished, 0.1);
	
	SetWeaponState(self, W_SuperNailgun1);
	S_PlayerMissileLoopA1();
	
	vector orig = self.origin;
	orig.z += 16.0;
	
	entity missile = SpawnMissile(self, missile_supernail, orig, GetAutoaimDir(self, 1000.0), 1000.0, VEC_ZERO, 6.0);
	missile.CurrentSlot = self.CurrentSlot;
}

void missile_supernail()
{
	if (CanPrecache())
		PrecacheModel("progs/spike2.mdl");
	
	self.touch = P_MissileTouch;
	
	self.dmg = 18;
	self.damageflag = TE_SUPERSPIKE;
	self.deathtype = "spike";
	
	StartMissile(self, "progs/spike2.mdl");
}

void weapon_supernailgun()
{
	if (!self.wait)
		self.wait = 20.0;
	
	if (CanPrecache())
		PrecacheModel("progs/g_nail2.mdl");
	
	self.touch = P_WeaponTouch;
	
	self.CurrentSlot = GetWeaponSlot(SLOT_AUTO_HEAVY, LAYER_DEFAULT);
	self.amount = 30;
	
	StartItem(self, "progs/g_nail2.mdl");
}
