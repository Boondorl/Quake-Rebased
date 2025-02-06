$framevalue 1
$frame Fire1 Fire2 Fire3 Fire4 Fire5 Fire6

void() W_SuperShotgunFire1 = [ $Fire1, W_SuperShotgunFire2 ] {};
void() W_SuperShotgunFire2 = [ $Fire2, W_SuperShotgunFire3 ] {};
void() W_SuperShotgunFire3 = [ $Fire3, W_SuperShotgunFire4 ] {};
void() W_SuperShotgunFire4 = [ $Fire4, W_SuperShotgunFire5 ] {};
void() W_SuperShotgunFire5 = [ $Fire5, W_SuperShotgunFire6 ] {};
void() W_SuperShotgunFire6 = [ $Fire6, __NULL__ ] {};

void A_FireSuperShotgun()
{
	self.effects |= EF_MUZZLEFLASH;
	self.punchangle.x = -4.0;
	PlaySound(self, CHAN_WEAPON, "weapons/shotgn2.wav", 1.0, ATTN_NORM);
	
	SetWeaponState(self, W_SuperShotgunFire1);
	S_PlayerMissileB1();
	
	vector orig = self.origin + v_forward * 10.0;
	orig.z += 16.0;
	
	FireBullets(self, orig, GetAutoaimDir(self, 20480.0), 4, 14, [0.14, 0.08, 0.0]);
}

void weapon_supershotgun()
{
	if (!self.wait)
		self.wait = 20.0;
	
	self.touch = P_WeaponTouch;
	
	self.current_slot = GetWeaponSlot(SLOT_WORKHORSE, LAYER_DEFAULT);
	self.amount = 5;
	
	StartItem(self, "progs/g_shot.mdl");
}
