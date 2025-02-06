
$framevalue 1
$frame RocketLauncher1 RocketLauncher2 RocketLauncher3 RocketLauncher4 RocketLauncher5 RocketLauncher6

void() W_RocketLauncher1 = [ $RocketLauncher1, W_RocketLauncher2 ] {};
void() W_RocketLauncher2 = [ $RocketLauncher2, W_RocketLauncher3 ] {};
void() W_RocketLauncher3 = [ $RocketLauncher3, W_RocketLauncher4 ] {};
void() W_RocketLauncher4 = [ $RocketLauncher4, W_RocketLauncher5 ] {};
void() W_RocketLauncher5 = [ $RocketLauncher5, W_RocketLauncher6 ] {};
void() W_RocketLauncher6 = [ $RocketLauncher6, __NULL__ ] {};

void A_FireRocketLauncher()
{
	self.effects |= EF_MUZZLEFLASH;
	self.punchangle.x = -2.0;
	PlaySound(self, CHAN_WEAPON, "weapons/sgun1.wav", 1.0, ATTN_NORM);
	SetCoolDown(self, attack_finished, 0.8);
	
	SetWeaponState(self, W_RocketLauncher1);
	S_PlayerRocketLauncher1();
	
	vector orig = self.origin + v_forward * 8.0;
	orig.z += 16.0;
	
	entity missile = SpawnMissile(self, missile_rocket, orig, GetAutoaimDir(self, 1000.0), 1000.0);
	missile.CurrentSlot = self.CurrentSlot;
}

void missile_rocket()
{
	if (CanPrecache())
		PrecacheModel("progs/missile.mdl");
	
	self.touch = P_MissileTouch;
	
	self.dmg = 100 + Round(20 * Random());
	self.RadDmg = 120;
	self.distance = 160.0;
	self.deathtype = "explosive";
	self.deathflag = TE_INVALID;
	
	StartMissile(self, "progs/missile.mdl");
}

void weapon_rocketlauncher()
{
	if (!self.wait)
		self.wait = 20.0;
	
	if (CanPrecache())
		PrecacheModel("progs/g_rock2.mdl");
	
	self.touch = P_WeaponTouch;
	
	self.CurrentSlot = GetWeaponSlot(SLOT_RANGED, LAYER_DEFAULT);
	self.amount = 5;
	
	StartItem(self, "progs/g_rock2.mdl");
}