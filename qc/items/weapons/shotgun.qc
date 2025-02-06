$framevalue 1
$frame Fire1 Fire2 Fire3 Fire4 Fire5 Fire6

void() W_ShotgunFire1 = [ $Fire1, W_ShotgunFire2 ] {};
void() W_ShotgunFire2 = [ $Fire2, W_ShotgunFire3 ] {};
void() W_ShotgunFire3 = [ $Fire3, W_ShotgunFire4 ] {};
void() W_ShotgunFire4 = [ $Fire4, W_ShotgunFire5 ] {};
void() W_ShotgunFire5 = [ $Fire5, W_ShotgunFire6 ] {};
void() W_ShotgunFire6 = [ $Fire6, __NULL__ ] {};

void A_FireShotgun()
{
	self.effects |= EF_MUZZLEFLASH;
	self.punchangle.x = -2.0;
	PlaySound(self, CHAN_WEAPON, "weapons/guncock.wav", 1.0, ATTN_NORM);
	SetCoolDown(self, attack_finished, 0.5);
	
	SetWeaponState(self, W_ShotgunFire1);
	S_PlayerMissileB1();
	
	vector orig = self.origin + v_forward * 10.0;
	orig.z += 16.0;
	
	FireBullets(self, orig, GetAutoaimDir(self, 20480.0), 4, 6, [0.04, 0.04, 0.0]);
}
