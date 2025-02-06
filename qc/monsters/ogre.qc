/*  Copyright (C) 1996-1997  Id Software, Inc.

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    See file, 'COPYING', for details.
*/

$frame Stand1 Stand2 Stand3 Stand4 Stand5 Stand6 Stand7 Stand8 Stand9

$frame Walk1 Walk2 Walk3 Walk4 Walk5 Walk6 Walk7
$frame Walk8 Walk9 Walk10 Walk11 Walk12 Walk13 Walk14 Walk15 Walk16

$frame Run1 Run2 Run3 Run4 Run5 Run6 Run7 Run8

$frame MeleeA1 MeleeA2 MeleeA3 MeleeA4 MeleeA5 MeleeA6 MeleeA7
$frame MeleeA8 MeleeA9 MeleeA10 MeleeA11 MeleeA12 MeleeA13 MeleeA14

$frame MeleeB1 MeleeB2 MeleeB3 MeleeB4 MeleeB5 MeleeB6 MeleeB7
$frame MeleeB8 MeleeB9 MeleeB10 MeleeB11 MeleeB12 MeleeB13 MeleeB14

$frame Missile1 Missile2 Missile3 Missile4 Missile5 Missile6

$frame PainA1 PainA2 PainA3 PainA4 PainA5

$frame PainB1 PainB2 PainB3

$frame PainC1 PainC2 PainC3 PainC4 PainC5 PainC6

$frame PainD1 PainD2 PainD3 PainD4 PainD5 PainD6 PainD7 PainD8 PainD9 PainD10
$frame PainD11 PainD12 PainD13 PainD14 PainD15 PainD16

$frame PainE1 PainE2 PainE3 PainE4 PainE5 PainE6 PainE7 PainE8 PainE9 PainE10
$frame PainE11 PainE12 PainE13 PainE14 PainE15

$frame DeathA1 DeathA2 DeathA3 DeathA4 DeathA5 DeathA6
$frame DeathA7 DeathA8 DeathA9 DeathA10 DeathA11 DeathA12
$frame DeathA13 DeathA14

$frame DeathB1 DeathB2 DeathB3 DeathB4 DeathB5 DeathB6
$frame DeathB7 DeathB8 DeathB9 DeathB10

$frame Unused1 Unused2 Unused3 Unused4 Unused5 Unused6 Unused7 Unused8 Unused9 Unused10 Unused11

/*
==============================================================================

OGRE

==============================================================================
*/

void() S_OgreStand1 = [ $Stand1, S_OgreStand2 ] { A_Stand(); };
void() S_OgreStand1 = [ $Stand2, S_OgreStand3 ] { A_Stand(); };
void() S_OgreStand1 = [ $Stand3, S_OgreStand4 ] { A_Stand(); };
void() S_OgreStand1 = [ $Stand4, S_OgreStand5 ] { A_Stand(); };
void() S_OgreStand1 = [ $Stand5, S_OgreStand6 ] { A_Stand(); };
void() S_OgreStand1 = [ $Stand6, S_OgreStand7 ] { A_Stand(); };
void() S_OgreStand1 = [ $Stand7, S_OgreStand8 ] { A_Stand(); };
void() S_OgreStand1 = [ $Stand8, S_OgreStand9 ] { A_Stand(); };
void() S_OgreStand1 = [ $Stand9, S_OgreStand1 ]
{
	if (Random() < 0.2)
		PlaySound(self, CHAN_VOICE, "ogre/ogidle.wav", 1.0, ATTN_IDLE);
	
	A_Stand();
};

void() S_OgreWalk1 = [ $Walk1, S_OgreWalk2 ] { A_Walk(3.0); };
void() S_OgreWalk2 = [ $Walk2, S_OgreWalk3 ] { A_Walk(2.0); };
void() S_OgreWalk3 = [ $Walk3, S_OgreWalk4 ]
{
	if (Random() < 0.2)
		PlaySound(self, CHAN_VOICE, "ogre/ogidle.wav", 1.0, ATTN_IDLE);
	
	A_Walk(2.0);
};
void() S_OgreWalk4 = [ $Walk4, S_OgreWalk5 ] { A_Walk(2.0); };
void() S_OgreWalk5 = [ $Walk5, S_OgreWalk6 ] { A_Walk(2.0); };
void() S_OgreWalk6 = [ $Walk6, S_OgreWalk7 ]
{
	if (Random() < 0.1)
		PlaySound(self, CHAN_VOICE, "ogre/ogdrag.wav", 1.0, ATTN_IDLE);
	
	A_Walk(5.0);
};
void() S_OgreWalk7 = [ $Walk7, S_OgreWalk8 ] { A_Walk(3.0); };
void() S_OgreWalk8 = [ $Walk8, S_OgreWalk9 ] { A_Walk(2.0); };
void() S_OgreWalk9 = [ $Walk9, S_OgreWalk10 ] { A_Walk(3.0); };
void() S_OgreWalk10 = [ $Walk10, S_OgreWalk11 ] { A_Walk(1.0); };
void() S_OgreWalk11 = [ $Walk11, S_OgreWalk12 ] { A_Walk(2.0); };
void() S_OgreWalk12 = [ $Walk12, S_OgreWalk13 ] { A_Walk(3.0); };
void() S_OgreWalk13 = [ $Walk13, S_OgreWalk14 ] { A_Walk(3.0); };
void() S_OgreWalk14 = [ $Walk14, S_OgreWalk15 ] { A_Walk(3.0); };
void() S_OgreWalk15 = [ $Walk15, S_OgreWalk16 ] { A_Walk(3.0); };
void() S_OgreWalk16 = [ $Walk16, S_OgreWalk1 ] { A_Walk(4.0); };

void() S_OgreRun1 = [ $Run1, S_OgreRun2 ] { A_Run(9.0); };
void() S_OgreRun2 = [ $Run2, S_OgreRun3 ] { A_Run(12.0); };
void() S_OgreRun3 = [ $Run3, S_OgreRun4 ] { A_Run(8.0); };
void() S_OgreRun4 = [ $Run4, S_OgreRun5 ] { A_Run(22.0); };
void() S_OgreRun5 = [ $Run5, S_OgreRun6 ] { A_Run(16.0); };
void() S_OgreRun6 = [ $Run6, S_OgreRun7 ] { A_Run(4.0); };
void() S_OgreRun7 = [ $Run7, S_OgreRun8 ] { A_Run(13.0); };
void() S_OgreRun8 = [ $Run8, S_OgreRun1 ]
{
	if (Random() < 0.2)
		PlaySound(self, CHAN_VOICE, "ogre/ogidle2.wav", 1.0, ATTN_IDLE);
		
	A_Run(24.0);
};

void() S_OgreMeleeA1 = [ $MeleeA1, S_OgreMeleeA2 ] { A_Charge(11.0); };
void() S_OgreMeleeA2 = [ $MeleeA2, S_OgreMeleeA3 ] { A_Charge(1.0); };
void() S_OgreMeleeA3 = [ $MeleeA3, S_OgreMeleeA4 ] { A_Charge(4.0); };
void() S_OgreMeleeA4 = [ $MeleeA4, S_OgreMeleeA5 ] { A_Charge(13.0); };
void() S_OgreMeleeA5 = [ $MeleeA5, S_OgreMeleeA6 ]
{
	A_OgreMeleeAttack(19.0);
	self.angles.y += 25.0 * Random();
};
void() S_OgreMeleeA6 = [ $MeleeA6, S_OgreMeleeA7 ]
{
	A_OgreMeleeAttack(10.0, 200.0);
	self.angles.y += 25.0 * Random();
};
void() S_OgreMeleeA7 = [ $MeleeA7, S_OgreMeleeA8 ]
{
	A_OgreMeleeAttack(10.0);
	self.angles.y += 25.0 * Random();
};
void() S_OgreMeleeA8 = [ $MeleeA8, S_OgreMeleeA9 ]
{
	A_OgreMeleeAttack(10.0);
	self.angles.y += 25.0 * Random();
};
void() S_OgreMeleeA9 = [ $MeleeA9, S_OgreMeleeA10 ]
{
	A_OgreMeleeAttack(10.0);
	self.angles.y += 25.0 * Random();
};
void() S_OgreMeleeA10 = [ $MeleeA10, S_OgreMeleeA11 ]
{
	A_OgreMeleeAttack(10.0, -200.0);
	self.angles.y += 25.0 * Random();
};
void() S_OgreMeleeA11 = [ $MeleeA11, S_OgreMeleeA12 ]
{
	A_OgreMeleeAttack(10.0);
	self.angles.y += 25.0 * Random();
};
void() S_OgreMeleeA12 = [ $MeleeA12, S_OgreMeleeA13 ] { A_Charge(3.0); };
void() S_OgreMeleeA13 = [ $MeleeA13, S_OgreMeleeA14 ] { A_Charge(8.0); };
void() S_OgreMeleeA14 = [ $MeleeA14, S_OgreRun1 ] { A_Charge(9.0); };

void() S_OgreMeleeB1 = [ $MeleeB1, S_OgreMeleeB2 ] { A_Charge(6.0); };
void() S_OgreMeleeB2 = [ $MeleeB2, S_OgreMeleeB3 ] { A_Charge(0.0); };
void() S_OgreMeleeB3 = [ $MeleeB3, S_OgreMeleeB4 ] { A_Charge(0.0); };
void() S_OgreMeleeB4 = [ $MeleeB4, S_OgreMeleeB5 ] { A_Charge(1.0); };
void() S_OgreMeleeB5 = [ $MeleeB5, S_OgreMeleeB6 ] { A_Charge(4.0); };
void() S_OgreMeleeB6 = [ $MeleeB6, S_OgreMeleeB7 ] { A_OgreMeleeAttack(14.0); };
void() S_OgreMeleeB7 = [ $MeleeB7, S_OgreMeleeB8 ] { A_OgreMeleeAttack(14.0); };
void() S_OgreMeleeB8 = [ $MeleeB8, S_OgreMeleeB9 ] { A_OgreMeleeAttack(20.0); };
void() S_OgreMeleeB9 = [ $MeleeB9, S_OgreMeleeB10 ] { A_OgreMeleeAttack(23.0); };
void() S_OgreMeleeB10 = [ $MeleeB10, S_OgreMeleeB11 ] { A_OgreMeleeAttack(0.0, FLT_MAX); };
void() S_OgreMeleeB11 = [ $MeleeB11, S_OgreMeleeB12 ]
{
	A_OgreMeleeAttack(12.0);
	// Slight variation
	self.nextthink += Random() * 0.2;
};
void() S_OgreMeleeB12 = [ $MeleeB12, S_OgreMeleeB13 ] { A_Charge(0.0); };
void() S_OgreMeleeB13 = [ $MeleeB13, S_OgreMeleeB14 ] { A_Charge(4.0); };
void() S_OgreMeleeB14 = [ $MeleeB14, S_OgreRun1 ] { A_Charge(12.0); };

void() S_OgreMissile1 = [ $Missile1, S_OgreMissile2 ] { A_Face(); };
void() S_OgreMissile2 = [ $Missile2, S_OgreMissile3 ] { A_Face(); };
void() S_OgreMissile3 = [ $Missile2, S_OgreMissile4 ] { A_Face(); };
void() S_OgreMissile4 = [ $Missile3, S_OgreMissile5 ] { A_OgreMissileAttack(); };
void() S_OgreMissile5 = [ $Missile4, S_OgreMissile6 ] { A_Face(); };
void() S_OgreMissile6 = [ $Missile5, S_OgreMissile7 ] { A_Face(); };
void() S_OgreMissile7 = [ $Missile6, S_OgreRun1 ] { A_Face(); };

void() S_OgrePainA1 = [ $PainA1, S_OgrePainA2 ] {};
void() S_OgrePainA2 = [ $PainA2, S_OgrePainA3 ] {};
void() S_OgrePainA3 = [ $PainA3, S_OgrePainA4 ] {};
void() S_OgrePainA4 = [ $PainA4, S_OgrePainA5 ] {};
void() S_OgrePainA5 = [ $PainA5, S_OgreRun1 ] {};

void() S_OgrePainB1 = [ $PainB1, S_OgrePainB2 ] {};
void() S_OgrePainB2 = [ $PainB2, S_OgrePainB3 ] {};
void() S_OgrePainB3 = [ $PainB3, S_OgreRun1 ] {};

void() S_OgrePainC1 = [ $PainC1, S_OgrePainC2 ] {};
void() S_OgrePainC2 = [ $PainC2, S_OgrePainC3 ] {};
void() S_OgrePainC3 = [ $PainC3, S_OgrePainC4 ] {};
void() S_OgrePainC4 = [ $PainC4, S_OgrePainC5 ] {};
void() S_OgrePainC5 = [ $PainC5, S_OgrePainC6 ] {};
void() S_OgrePainC6 = [ $PainC6, S_OgreRun1 ] {};

void() S_OgrePainD1 = [ $PainD1, S_OgrePainD2 ] {};
void() S_OgrePainD2 = [ $PainD2, S_OgrePainD3 ] { A_Move(10.0, 180.0); };
void() S_OgrePainD3 = [ $PainD3, S_OgrePainD4 ] { A_Move(9.0, 180.0); };
void() S_OgrePainD4 = [ $PainD4, S_OgrePainD5 ] { A_Move(4.0, 180.0); };
void() S_OgrePainD5 = [ $PainD5, S_OgrePainD6 ] {};
void() S_OgrePainD6 = [ $PainD6, S_OgrePainD7 ] {};
void() S_OgrePainD7 = [ $PainD7, S_OgrePainD8 ] {};
void() S_OgrePainD8 = [ $PainD8, S_OgrePainD9 ] {};
void() S_OgrePainD9 = [ $PainD9, S_OgrePainD10 ] {};
void() S_OgrePainD10 = [ $PainD10, S_OgrePainD11 ] {};
void() S_OgrePainD11 = [ $PainD11, S_OgrePainD12 ] {};
void() S_OgrePainD12 = [ $PainD12, S_OgrePainD13 ] {};
void() S_OgrePainD13 = [ $PainD13, S_OgrePainD14 ] {};
void() S_OgrePainD14 = [ $PainD14, S_OgrePainD15 ] {};
void() S_OgrePainD15 = [ $PainD15, S_OgrePainD16 ] {};
void() S_OgrePainD16 = [ $PainD16, S_OgreRun1 ] {};

void() S_OgrePainE1 = [ $PainE1, S_OgrePainE2 ] {};
void() S_OgrePainE2 = [ $PainE2, S_OgrePainE3 ] { A_Move(10.0, 180.0); };
void() S_OgrePainE3 = [ $PainE3, S_OgrePainE4 ] { A_Move(9.0, 180.0); };
void() S_OgrePainE4 = [ $PainE4, S_OgrePainE5 ] { A_Move(4.0, 180.0); };
void() S_OgrePainE5 = [ $PainE5, S_OgrePainE6 ] {};
void() S_OgrePainE6 = [ $PainE6, S_OgrePainE7 ] {};
void() S_OgrePainE7 = [ $PainE7, S_OgrePainE8 ] {};
void() S_OgrePainE8 = [ $PainE8, S_OgrePainE9 ] {};
void() S_OgrePainE9 = [ $PainE9, S_OgrePainE10 ] {};
void() S_OgrePainE10 = [ $PainE10, S_OgrePainE11 ] {};
void() S_OgrePainE11 = [ $PainE11, S_OgrePainE12 ] {};
void() S_OgrePainE12 = [ $PainE12, S_OgrePainE13 ] {};
void() S_OgrePainE13 = [ $PainE13, S_OgrePainE14 ] {};
void() S_OgrePainE14 = [ $PainE14, S_OgrePainE15 ] {};
void() S_OgrePainE15 = [ $PainE15, S_OgreRun1 ] {};

void() S_OgreDeathA1 = [ $DeathA1, S_OgreDeathA2 ] {};
void() S_OgreDeathA2 = [ $DeathA2, S_OgreDeathA3 ] {};
void() S_OgreDeathA3 = [ $DeathA3, S_OgreDeathA4 ] { SetSolid(self, SOLID_NOT); };
void() S_OgreDeathA4 = [ $DeathA4, S_OgreDeathA5 ] {};
void() S_OgreDeathA5 = [ $DeathA5, S_OgreDeathA6 ] {};
void() S_OgreDeathA6 = [ $DeathA6, S_OgreDeathA7 ] {};
void() S_OgreDeathA7 = [ $DeathA7, S_OgreDeathA8 ] {};
void() S_OgreDeathA8 = [ $DeathA8, S_OgreDeathA9 ] {};
void() S_OgreDeathA9 = [ $DeathA9, S_OgreDeathA10 ] {};
void() S_OgreDeathA10 = [ $DeathA10, S_OgreDeathA11 ] {};
void() S_OgreDeathA11 = [ $DeathA11, S_OgreDeathA12 ] {};
void() S_OgreDeathA12 = [ $DeathA12, S_OgreDeathA13 ] {};
void() S_OgreDeathA13 = [ $DeathA13, S_OgreDeathA14 ] {};
void() S_OgreDeathA14 = [ $DeathA14, S_OgreDeathA14 ] {};

void() S_OgreDeathB1 = [ $DeathB1, S_OgreDeathB2 ] {};
void() S_OgreDeathB2 = [ $DeathB2, S_OgreDeathB3 ] { A_Move(5.0); };
void() S_OgreDeathB3 = [ $DeathB3, S_OgreDeathB4 ] { SetSolid(self, SOLID_NOT); };
void() S_OgreDeathB4 = [ $DeathB4, S_OgreDeathB5 ] { A_Move(1.0); };
void() S_OgreDeathB5 = [ $DeathB5, S_OgreDeathB6 ] { A_Move(3.0); };
void() S_OgreDeathB6 = [ $DeathB6, S_OgreDeathB7 ] { A_Move(7.0); };
void() S_OgreDeathB7 = [ $DeathB7, S_OgreDeathB8 ] { A_Move(25.0); };
void() S_OgreDeathB8 = [ $DeathB8, S_OgreDeathB9 ] {};
void() S_OgreDeathB9 = [ $DeathB9, S_OgreDeathB10 ] {};
void() S_OgreDeathB10 = [ $DeathB10, S_OgreDeathB10 ] {};

bool_t A_CheckOgreAttack()
{
	if (!IsVisible(self, self.enemy, VIS_CHECK_MONSTERS))
		return FALSE;

	float range = GetRange(self, self.enemy);
	if (range <= RANGE_MELEE)
	{
		self.attack_state = AS_MELEE;
		return TRUE;
	}

	if (range > RANGE_FAR || !TimerExpired(self.attack_finished))
		return FALSE;

	// Ogres have a much lower chance to attack overall
	float chance = range <= RANGE_MID ? 0.1 : 0.05;
	if (Random() < chance)
	{
		if (skill < SK_NIGHTMARE)
			SetCoolDown(self, attack_finished, 2.0 * Random());
		
		self.attack_state = AS_MISSILE;
		return TRUE;
	}

	return FALSE;
}

void A_PlayOgreChainsawSound()
{
	PlaySound(self, CHAN_AUTO, "ogre/ogdrag.wav", 1.0, ATTN_IDLE);
}

void A_OgreRun()
{
	PlaySound(self, CHAN_VOICE, "ogre/ogwake.wav", 1.0, ATTN_NORM);
	S_OgreRun1();
}

void A_OgreMelee()
{
	PlaySound(self, CHAN_WEAPON, "ogre/ogsawatk.wav", 1.0, ATTN_NORM);
	if (Random() > 0.5)
		S_OgreMeleeB1();
	else
		S_OgreMeleeA1();
}

void A_OgreMeleeAttack(float dist, float rightOfs = 0.0)
{
	A_Charge(dist);
	
	int_t realDmg = A_DirectDamage(MAX(2, Round((Random() + Random() + Random()) * 4)), 100.0);
	if (realDmg < 0 || !rightOfs)
		return;

	FixedLocalAxes(self.angles);
	
	vector vel = v_right * (rightOfs == FLT_MAX ? 100.0 * CRandom() : rightOfs);
	SpawnMeatSpray(self, self.origin + v_forward * 16.0, vel);
}

void A_OgreMissileAttack()
{
	A_Face();
	
	FixedLocalAxes(self.angles);

	PlaySound(self, CHAN_WEAPON, "weapons/grenade.wav", 1.0, ATTN_NORM);
	self.effects |= EF_MUZZLEFLASH;
	
	if (self.misc_action & MON_SPECIAL_ATTACK)
	{
		vector dir = GetAimDir(self.enemy, self.origin);
		angles_t angs = ToAngles(dir);
		FixedLocalAxes(angs);
		dir = v_forward + v_up * (0.33 * AbsF(NormalizeAngle180(angs.x) / 90.0));
		
		SpawnMissile(self, missile_ogregrenade, self.origin, dir, 632.5, [300.0, 300.0, 300.0]);
	}
	else
	{
		// Since the aiming is buggy, only check this on the 2D plane to keep proper missile speed
		vector dir = GetAimDir(self.enemy, self.origin, VEC_ZERO, TRUE);
		entity missile = SpawnMissile(self, missile_ogregrenade, self.origin, dir, 600.0, [300.0, 300.0, 300.0]);
		missile.z = 200.0;
	}
}

void A_OgrePain(entity attacker, entity inflictor, int_t damage)
{
	if (!TimerExpired(self.pain_finished))
		return FALSE;

	PlaySound(self, CHAN_VOICE, "ogre/ogpain1.wav", 1.0, ATTN_NORM);

	float r = Random();
	if (r < 0.75)
	{
		if (r < 0.25)
			S_OgrePainA1();
		else if (r < 0.5)
			S_OgrePainB1();
		else
			S_OgrePainC1();
		
		SetCoolDown(self, pain_finished, 1.0);
	}
	else
	{
		if (r < 0.875)
			S_OgrePainD1();
		else
			S_OgrePainE1();
		
		SetCoolDown(self, pain_finished, 2.0);
	}
	
	return TRUE;
}

void A_OgreDie()
{
	A_DropBackpack(TRUE);
	
	// check for gib
	if (self.health < -80)
	{
		GibEntity(self, "progs/h_ogre.mdl");
		return;
	}

	PlaySound(self, CHAN_VOICE, "ogre/ogdth.wav", 1.0, ATTN_NORM);
	if (Random() < 0.5)
		S_OgreDeathA1();
	else
		S_OgreDeathB1();
}

void missile_ogregrenade()
{
	self.dmg = 35 + Round(5 * Random());
	self.rad_dmg = 40;
	self.distance = 80.0;
	self.noise3 = "weapon/bounce.wav";
	self.damage_type = "explosive";
	self.misc_action = TE_INVALID;
	self.obituary = OBIT_OGRE_MIS;
	
	StartMissile(self, "progs/grenade.mdl", TRUE);
	
	SetNextThink(self, 2.5, A_MissileExplode);
}

void monster_ogre()
{
	if (!CanSpawn(self))
		return;
	
	if (!WorldLoading())
	{
		PrecacheEntity(missile_ogregrenade);

		PrecacheSound("ogre/ogdrag.wav");
		PrecacheSound("ogre/ogwake.wav");
		PrecacheSound("ogre/ogidle.wav");
		PrecacheSound("ogre/ogidle2.wav");
		PrecacheSound("ogre/ogsawatk.wav");
		PrecacheSound("ogre/ogpain1.wav");
		PrecacheSound("ogre/ogdth.wav");
	}

	self.th_idle = S_OgreStand1;
	self.th_walk = S_OgreWalk1;
	self.th_run = A_OgreRun;
	self.th_melee = A_OgreMelee;
	self.th_missile = S_OgreMissile1;
	self.th_pain = A_OgrePain;
	self.th_die = A_OgreDie;
	self.th_dest = A_PlayOgreChainsawSound;
	self.th_check = A_CheckOgreAttack;
	
	self.health = 200;
	self.ammo_rockets += 2; // Support backpackless map hack
	self.obituary = OBIT_OGRE_MEL;

	StartMonster(self, "progs/ogre.mdl", "progs/h_ogre.mdl", TRUE);
}

// Allow direct aiming at enemy
void monster_ogre_marksman()
{
	self.misc_action |= MON_SPECIAL_ATTACK;
	self.classname = "monster_ogre"; // Prevent infighting
	
	monster_ogre();
}
