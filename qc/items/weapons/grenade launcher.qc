
$framevalue 1
$frame Fire1 Fire2 Fire3 Fire4 Fire5 Fire6

void() W_GrenadeLauncherFire1 = [ $Fire1, W_GrenadeLauncherFire2 ] {};
void() W_GrenadeLauncherFire2 = [ $Fire2, W_GrenadeLauncherFire3 ] {};
void() W_GrenadeLauncherFire3 = [ $Fire3, W_GrenadeLauncherFire4 ] {};
void() W_GrenadeLauncherFire4 = [ $Fire4, W_GrenadeLauncherFire5 ] {};
void() W_GrenadeLauncherFire5 = [ $Fire5, W_GrenadeLauncherFire6 ] {};
void() W_GrenadeLauncherFire6 = [ $Fire6, W_WeaponReady1 ] {};

void A_FireGrenadeLauncher()
{
	self.effects |= EF_MUZZLEFLASH;
	self.punchangle.x = -2.0;
	PlaySound(self, CHAN_WEAPON, "weapons/grenade.wav", 1.0, ATTN_NORM);
	
	SetWeaponState(self, W_GrenadeLauncherFire1);
	S_PlayerMissileA1();
	
	// These values might seem odd but they're meant to emulate the original Quake's grenade speed. Rather than adding
	// 200 to v_up it now properly rotates to arc based on the client's own aim pitch
	vector fireDir = ArcTrajectory(GetAutoaimDir(self, 632.5), 0.33);
	entity missile = SpawnMissile(self, missile_grenade, self.origin, fireDir, 632.5, [300.0, 300.0, 300.0]);
	missile.current_slot = self.current_slot;
}

void missile_grenade()
{
	self.dmg = RandomRangeI(100, 120);
	self.rad_dmg = 120;
	self.distance = 160.0;
	self.damage_type = "explosive";
	self.misc_action = TE_INVALID;
	self.noise3 = "grenade/bounce.wav";
	
	StartMissile(self, "progs/grenade.mdl", TRUE);
	
	SetNextThink(self, 2.5, A_MissileExplode);
}

void weapon_grenadelauncher()
{
	if (!self.wait)
		self.wait = 20.0;
	
	self.touch = P_WeaponTouch;
	
	self.current_slot = GetWeaponSlot(SLOT_UTILITY, LAYER_DEFAULT);
	self.amount = 5;
	
	StartItem(self, "progs/g_rock.mdl");
}
