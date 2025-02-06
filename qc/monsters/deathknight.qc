/*
	Copyright (C) 1996-1997  Id Software, Inc.

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

// This was without a doubt the buggiest enemy in the game. Enjoy it actually working
// as intended

$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7 stand8 stand9

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8 walk9
$frame walk10 walk11 walk12 walk13 walk14 walk15 walk16 walk17
$frame walk18 walk19 walk20

$frame run1 run2 run3 run4 run5 run6 run7 run8

$frame pain1 pain2 pain3 pain4 pain5

$frame death1 death2 death3 death4 death5 death6 death7 death8
$frame death9 death10 death11 death12

$frame deathb1 deathb2 deathb3 deathb4 deathb5 deathb6 deathb7 deathb8
$frame deathb9

$frame char_a1 char_a2 char_a3 char_a4 char_a5 char_a6 char_a7 char_a8
$frame char_a9 char_a10 char_a11 char_a12 char_a13 char_a14 char_a15 char_a16

$frame magica1 magica2 magica3 magica4 magica5 magica6 magica7 magica8
$frame magica9 magica10 magica11 magica12 magica13 magica14

$frame magicb1 magicb2 magicb3 magicb4 magicb5 magicb6 magicb7 magicb8
$frame magicb9 magicb10 magicb11 magicb12 magicb13

$frame char_b1 char_b2 char_b3 char_b4 char_b5 char_b6

$frame slice1 slice2 slice3 slice4 slice5 slice6 slice7 slice8 slice9 slice10

$frame smash1 smash2 smash3 smash4 smash5 smash6 smash7 smash8 smash9 smash10
$frame smash11

$frame w_attack1 w_attack2 w_attack3 w_attack4 w_attack5 w_attack6 w_attack7
$frame w_attack8 w_attack9 w_attack10 w_attack11 w_attack12 w_attack13 w_attack14
$frame w_attack15 w_attack16 w_attack17 w_attack18 w_attack19 w_attack20
$frame w_attack21 w_attack22

$frame magicc1 magicc2 magicc3 magicc4 magicc5 magicc6 magicc7 magicc8
$frame magicc9 magicc10 magicc11

// This function was profoundly awful before, not taking the correct aim direction into
// account nor even offsetting its angles correctly. All of its issues have now
// been fixed and it instead takes tangent angle offsets like other functions
void A_DeathknightMissileAttack(float yawOfs, float maxPitchOfs = 0.05)
{
	A_Face();
	
	FixedLocalAxes(self.angles);
	
	vector orig = GetCenter(self) + v_forward * 20.0;
	vector aimDir = GetAimDir(self.enemy, orig);
	
	PlaySound(self, CHAN_WEAPON, "hknight/attack1.wav", 1.0, ATTN_NORM);
	
	VecToAxes(aimDir);
	
	aimDir = Normalize(v_forward + v_right * offset + v_up * (maxPitchOfs * Random()));
	SpawnMissile(self, missile_deathknightmagic, orig, aimDir, 300.0, VEC_ZERO, 6.0);
}

enum int_t
{
	DTHK_MELEE_A,
	DTHK_MELEE_B,
	DTHK_MELEE_C,
	
	MAX_DTHK_MELEE_ATTACKS,
};

// This should make Death Knights charge much more consistently as they run into range
// of their enemies now
void A_DeathKnightMelee()
{
	// This uses a different timer so that missile attacks
	// won't interfere with it
	if (TimerExpired(self.timer_finished)
		&& AbsF(self.origin.z - self.enemy.origin.z) <= 20.0
		&& GetRange(self, self.enemy) >= 80.0)
	{
		SetCoolDown(self, timer_finished, 2.0);
		hknight_char_a1();
		return;
	}
	
	PlaySound(self, CHAN_WEAPON, "hknight/slash1.wav", 1.0, ATTN_NORM);
	
	switch (self.count)
	{
	case DTHK_MELEE_B:
		hknight_smash1();
		break;
		
	case DTHK_MELEE_C:
		hknight_watk1();
		break;
		
	default:
		hknight_slice1();
		break;
	}
	
	self.count = (self.count + 1) % MAX_DTHK_MELEE_ATTACKS;
}

bool_t A_CheckDeathKnightCharge()
{
	if (!IsValidEnemy(self.enemy)
		|| TimerExpired(self.timer_finished) || AbsF(self.origin.z - self.enemy.origin.z) > 20.0
		|| GetRange(self, self.enemy) > RANGE_MELEE || !IsVisible(self, self.enemy, VIS_CHECK_MONSTERS))
	{
		return FALSE;
	}
	
	return TRUE;
}

void A_DeathKnightMeleeAttack(float dist)
{
	A_Charge(dist);
	
	int_t damage = MAX(1, Round(Random() + Random() + Random()));
	A_DirectDamage(damage, 80.0);
}

//===========================================================================

void() hknight_stand1 = [ $stand1, hknight_stand2 ] { A_Stand(); };
void() hknight_stand2 = [ $stand2, hknight_stand3 ] { A_Stand(); };
void() hknight_stand3 = [ $stand3, hknight_stand4 ] { A_Stand(); };
void() hknight_stand4 = [ $stand4, hknight_stand5 ] { A_Stand(); };
void() hknight_stand5 = [ $stand5, hknight_stand6 ] { A_Stand(); };
void() hknight_stand6 = [ $stand6, hknight_stand7 ] { A_Stand(); };
void() hknight_stand7 = [ $stand7, hknight_stand8 ] { A_Stand(); };
void() hknight_stand8 = [ $stand8, hknight_stand9 ] { A_Stand(); };
void() hknight_stand9 = [ $stand9, hknight_stand1 ] { A_Stand(); };

//===========================================================================

void() hknight_walk1 = [ $walk1, hknight_walk2 ] { A_Walk(2); };
void() hknight_walk2 = [ $walk2, hknight_walk3 ] { A_Walk(5); };
void() hknight_walk3 = [ $walk3, hknight_walk4 ] { A_Walk(5); };
void() hknight_walk4 = [ $walk4, hknight_walk5 ] { A_Walk(4); };
void() hknight_walk5 = [ $walk5, hknight_walk6 ] { A_Walk(4); };
void() hknight_walk6 = [ $walk6, hknight_walk7 ] { A_Walk(2); };
void() hknight_walk7 = [ $walk7, hknight_walk8 ] { A_Walk(2); };
void() hknight_walk8 = [ $walk8, hknight_walk9 ] { A_Walk(3); };
void() hknight_walk9 = [ $walk9, hknight_walk10 ] { A_Walk(3); };
void() hknight_walk10 = [ $walk10, hknight_walk11 ] { A_Walk(4); };
void() hknight_walk11 = [ $walk11, hknight_walk12 ] { A_Walk(3); };
void() hknight_walk12 = [ $walk12, hknight_walk13 ] { A_Walk(4); };
void() hknight_walk13 = [ $walk13, hknight_walk14 ] { A_Walk(6); };
void() hknight_walk14 = [ $walk14, hknight_walk15 ] { A_Walk(2); };
void() hknight_walk15 = [ $walk15, hknight_walk16 ] { A_Walk(2); };
void() hknight_walk16 = [ $walk16, hknight_walk17 ] { A_Walk(4); };
void() hknight_walk17 = [ $walk17, hknight_walk18 ] { A_Walk(3); };
void() hknight_walk18 = [ $walk18, hknight_walk19 ] { A_Walk(3); };
void() hknight_walk19 = [ $walk19, hknight_walk20 ] { A_Walk(3); };
void() hknight_walk20 = [ $walk20, hknight_walk1 ]
{
	if (Random() < 0.2)
		PlaySound(self, CHAN_VOICE, "hknight/idle.wav", 1.0, ATTN_IDLE);
	
	A_Walk(2);
};

void() hknight_run1 = [ $run1, hknight_run2 ] { A_Run(20); };
void() hknight_run2 = [ $run2, hknight_run3 ] { A_Run(25); };
void() hknight_run3 = [ $run3, hknight_run4 ] { A_Run(18); };
void() hknight_run4 = [ $run4, hknight_run5 ] { A_Run(16); };
void() hknight_run5 = [ $run5, hknight_run6 ] { A_Run(14); };
void() hknight_run6 = [ $run6, hknight_run7 ] { A_Run(25); };
void() hknight_run7 = [ $run7, hknight_run8 ] { A_Run(21); };
void() hknight_run8 = [ $run8, hknight_run1 ]
{
	if (Random() < 0.2)
		PlaySound(self, CHAN_VOICE, "hknight/idle.wav", 1.0, ATTN_IDLE);
	
	A_Run(13);
};

void() hknight_pain1 = [ $pain1, hknight_pain2 ] {};
void() hknight_pain2 = [ $pain2, hknight_pain3 ] {};
void() hknight_pain3 = [ $pain3, hknight_pain4 ] {};
void() hknight_pain4 = [ $pain4, hknight_pain5 ] {};
void() hknight_pain5 = [ $pain5, hknight_run1 ] {};

void() hknight_die1 = [ $death1, hknight_die2 ] { A_Move(10.0); };
void() hknight_die2 = [ $death2, hknight_die3 ] { A_Move(8.0); };
void() hknight_die3 = [ $death3, hknight_die4 ]
{
	SetSolid(self, SOLID_NOT);
	A_Move(7.0);
};
void() hknight_die4 = [ $death4, hknight_die5 ] {};
void() hknight_die5 = [ $death5, hknight_die6 ] {};
void() hknight_die6 = [ $death6, hknight_die7 ] {};
void() hknight_die7 = [ $death7, hknight_die8 ] {};
void() hknight_die8 = [ $death8, hknight_die9 ] { A_Move(10.0); };
void() hknight_die9 = [ $death9, hknight_die10 ] { A_Move(11.0); };
void() hknight_die10 = [ $death10, hknight_die11 ] {};
void() hknight_die11 = [ $death11, hknight_die12 ] {};
void() hknight_die12 = [ $death12, hknight_die12 ] {};

void() hknight_dieb1 = [ $deathb1, hknight_dieb2 ] {};
void() hknight_dieb2 = [ $deathb2, hknight_dieb3 ] {};
void() hknight_dieb3 = [ $deathb3, hknight_dieb4 ] { SetSolid(self, SOLID_NOT); };
void() hknight_dieb4 = [ $deathb4, hknight_dieb5 ] {};
void() hknight_dieb5 = [ $deathb5, hknight_dieb6 ] {};
void() hknight_dieb6 = [ $deathb6, hknight_dieb7 ] {};
void() hknight_dieb7 = [ $deathb7, hknight_dieb8 ] {};
void() hknight_dieb8 = [ $deathb8, hknight_dieb9 ] {};
void() hknight_dieb9 = [ $deathb9, hknight_dieb9 ] {};

void hknight_die()
{
	if (self.health < -40)
	{
		GibEntity(self, "");
		return;
	}
	
	PlaySound(self, CHAN_VOICE, "hknight/death1.wav", 1.0, ATTN_NORM);
	if (Random() > 0.5)
		hknight_die1();
	else
		hknight_dieb1();
}


//============================================================================

void() hknight_magica1 = [ $magica1, hknight_magica2 ] { A_Face(); };
void() hknight_magica2 = [ $magica2, hknight_magica3 ] { A_Face(); };
void() hknight_magica3 = [ $magica3, hknight_magica4 ] { A_Face(); };
void() hknight_magica4 = [ $magica4, hknight_magica5 ] { A_Face(); };
void() hknight_magica5 = [ $magica5, hknight_magica6 ] { A_Face(); };
void() hknight_magica6 = [ $magica6, hknight_magica7 ] { A_Face(); };
void() hknight_magica7 = [ $magica7, hknight_magica8 ] { A_DeathKnightMissileAttack(-0.035); };
void() hknight_magica8 = [ $magica8, hknight_magica9 ] { A_DeathKnightMissileAttack(-0.017); };
void() hknight_magica9 = [ $magica9, hknight_magica10 ] { A_DeathKnightMissileAttack(0.0); };
void() hknight_magica10 = [ $magica10, hknight_magica11 ] { A_DeathKnightMissileAttack(0.017); };
void() hknight_magica11 = [ $magica11, hknight_magica12 ] { A_DeathKnightMissileAttack(0.035); };
void() hknight_magica12 = [ $magica12, hknight_magica13 ] { A_DeathKnightMissileAttack(0.052); };
void() hknight_magica13 = [ $magica13, hknight_magica14 ] { A_Face(); };
void() hknight_magica14 = [ $magica14, hknight_run1 ] { A_Face(); };

//============================================================================

void() hknight_magicb1 = [ $magicb1, hknight_magicb2 ] { A_Face(); };
void() hknight_magicb2 = [ $magicb2, hknight_magicb3 ] { A_Face(); };
void() hknight_magicb3 = [ $magicb3, hknight_magicb4 ] { A_Face(); };
void() hknight_magicb4 = [ $magicb4, hknight_magicb5 ] { A_Face(); };
void() hknight_magicb5 = [ $magicb5, hknight_magicb6 ] { A_Face(); };
void() hknight_magicb6 = [ $magicb6, hknight_magicb7 ] { A_Face(); };
void() hknight_magicb7 = [ $magicb7, hknight_magicb8 ] { A_DeathKnightMissileAttack(-0.035); };
void() hknight_magicb8 = [ $magicb8, hknight_magicb9 ] { A_DeathKnightMissileAttack(-0.017); };
void() hknight_magicb9 = [ $magicb9, hknight_magicb10 ] { A_DeathKnightMissileAttack(0.0); };
void() hknight_magicb10 = [ $magicb10, hknight_magicb11 ] { A_DeathKnightMissileAttack(0.017); };
void() hknight_magicb11 = [ $magicb11, hknight_magicb12 ] { A_DeathKnightMissileAttack(0.035); };
void() hknight_magicb12 = [ $magicb12, hknight_magicb13 ] { A_DeathKnightMissileAttack(0.052); };
void() hknight_magicb13 = [ $magicb13, hknight_run1 ] { A_Face(); };

//============================================================================

void() hknight_magicc1 = [ $magicc1, hknight_magicc2 ] { A_Face(); };
void() hknight_magicc2 = [ $magicc2, hknight_magicc3 ] { A_Face(); };
void() hknight_magicc3 = [ $magicc3, hknight_magicc4 ] { A_Face(); };
void() hknight_magicc4 = [ $magicc4, hknight_magicc5 ] { A_Face(); };
void() hknight_magicc5 = [ $magicc5, hknight_magicc6 ] { A_Face(); };
void() hknight_magicc6 = [ $magicc6, hknight_magicc7 ] { A_DeathKnightMissileAttack(-0.035); };
void() hknight_magicc7 = [ $magicc7, hknight_magicc8 ] { A_DeathKnightMissileAttack(-0.017); };
void() hknight_magicc8 = [ $magicc8, hknight_magicc9 ] { A_DeathKnightMissileAttack(0.0); };
void() hknight_magicc9 = [ $magicc9, hknight_magicc10 ] { A_DeathKnightMissileAttack(0.017); };
void() hknight_magicc10 = [ $magicc10, hknight_magicc11 ] { A_DeathKnightMissileAttack(0.035); };
void() hknight_magicc11 = [ $magicc11, hknight_run1 ] { A_DeathKnightMissileAttack(0.052); };

//===========================================================================

void() hknight_char_a1 = [ $char_a1, hknight_char_a2 ] { A_Charge(20); };
void() hknight_char_a2 = [ $char_a2, hknight_char_a3 ] { A_Charge(25); };
void() hknight_char_a3 = [ $char_a3, hknight_char_a4 ] { A_Charge(18); };
void() hknight_char_a4 = [ $char_a4, hknight_char_a5 ] { A_Charge(16); };
void() hknight_char_a5 = [ $char_a5, hknight_char_a6 ] { A_Charge(14); };
void() hknight_char_a6 = [ $char_a6, hknight_char_a7 ] { A_Charge(20); A_DeathKnightMeleeAttack(); };
void() hknight_char_a7 = [ $char_a7, hknight_char_a8 ] { A_Charge(21); A_DeathKnightMeleeAttack(); };
void() hknight_char_a8 = [ $char_a8, hknight_char_a9 ] { A_Charge(13); A_DeathKnightMeleeAttack(); };
void() hknight_char_a9 = [ $char_a9, hknight_char_a10 ] { A_Charge(20); A_DeathKnightMeleeAttack(); };
void() hknight_char_a10 = [ $char_a10, hknight_char_a11 ] { A_Charge(20); A_DeathKnightMeleeAttack(); };
void() hknight_char_a11 = [ $char_a11, hknight_char_a12 ] { A_Charge(18); A_DeathKnightMeleeAttack(); };
void() hknight_char_a12 = [ $char_a12, hknight_char_a13 ] { A_Charge(16); };
void() hknight_char_a13 = [ $char_a13, hknight_char_a14 ] { A_Charge(14); };
void() hknight_char_a14 = [ $char_a14, hknight_char_a15 ] { A_Charge(25); };
void() hknight_char_a15 = [ $char_a15, hknight_char_a16 ] { A_Charge(21); };
void() hknight_char_a16 = [ $char_a16, hknight_run1 ]
{
	A_Charge(13);
	if ((self.misc_action & MON_SPECIAL_ATK) && A_CheckDeathKnightCharge())
	{
		SetCoolDown(self, timer_finished, 2.0);
		self.think = hknight_char_b1;
	}
};

//===========================================================================

void() hknight_char_b1 = [ $char_b1, hknight_char_b2 ]
{
	if (Random() > 0.5)
		PlaySound(self, CHAN_WEAPON, "knight/sword2.wav", 1.0, ATTN_NORM);
	else
		PlaySound(self, CHAN_WEAPON, "knight/sword1.wav", 1.0, ATTN_NORM);
	
	A_DeathKnightMeleeAttack(23.0);
};
void() hknight_char_b2 = [ $char_b2, hknight_char_b3 ] { A_DeathKnightMeleeAttack(17.0); };
void() hknight_char_b3 = [ $char_b3, hknight_char_b4 ] { A_DeathKnightMeleeAttack(12.0); };
void() hknight_char_b4 = [ $char_b4, hknight_char_b5 ] { A_DeathKnightMeleeAttack(22.0); };
void() hknight_char_b5 = [ $char_b5, hknight_char_b6 ] { A_DeathKnightMeleeAttack(18.0); };
void() hknight_char_b6 = [ $char_b6, hknight_char_b1 ]
{
	A_DeathKnightMeleeAttack(8.0);
	
	if (!A_CheckDeathKnightCharge())
	{
		if (skill < SK_NIGHTMARE)
			SetCoolDown(self, timer_finished, 3.0);
		else
			self.timer_finished = 0.0;
		
		self.think = hknight_run1;
		return;
	}
};

//===========================================================================

void() hknight_slice1 = [ $slice1, hknight_slice2 ] { A_Charge(9); };
void() hknight_slice2 = [ $slice2, hknight_slice3 ] { A_Charge(6); };
void() hknight_slice3 = [ $slice3, hknight_slice4 ] { A_Charge(13); };
void() hknight_slice4 = [ $slice4, hknight_slice5 ] { A_Charge(4); };
void() hknight_slice5 = [ $slice5, hknight_slice6 ] { A_Charge(7); A_DeathKnightMeleeAttack(); };
void() hknight_slice6 = [ $slice6, hknight_slice7 ] { A_Charge(15); A_DeathKnightMeleeAttack(); };
void() hknight_slice7 = [ $slice7, hknight_slice8 ] { A_Charge(8); A_DeathKnightMeleeAttack(); };
void() hknight_slice8 = [ $slice8, hknight_slice9 ] { A_Charge(2); A_DeathKnightMeleeAttack(); };
void() hknight_slice9 = [ $slice9, hknight_slice10 ] { A_DeathKnightMeleeAttack(); };
void() hknight_slice10 = [ $slice10, hknight_run1 ] { A_Charge(3); };

//===========================================================================

void() hknight_smash1 = [ $smash1, hknight_smash2 ] { A_Charge(1); };
void() hknight_smash2 = [ $smash2, hknight_smash3 ] { A_Charge(13); };
void() hknight_smash3 = [ $smash3, hknight_smash4 ] { A_Charge(9); };
void() hknight_smash4 = [ $smash4, hknight_smash5 ] { A_Charge(11); };
void() hknight_smash5 = [ $smash5, hknight_smash6 ] { A_Charge(10); A_DeathKnightMeleeAttack(); };
void() hknight_smash6 = [ $smash6, hknight_smash7 ] { A_Charge(7); A_DeathKnightMeleeAttack(); };
void() hknight_smash7 = [ $smash7, hknight_smash8 ] { A_Charge(12); A_DeathKnightMeleeAttack(); };
void() hknight_smash8 = [ $smash8, hknight_smash9 ] { A_Charge(2); A_DeathKnightMeleeAttack(); };
void() hknight_smash9 = [ $smash9, hknight_smash10 ] { A_Charge(3); A_DeathKnightMeleeAttack(); };
void() hknight_smash10 = [ $smash10, hknight_smash11 ] { A_Charge(0); };
void() hknight_smash11 = [ $smash11, hknight_run1 ] { A_Charge(0); };

//============================================================================

void() hknight_watk1 = [ $w_attack1, hknight_watk2 ] { A_Charge(2); };
void() hknight_watk2 = [ $w_attack2, hknight_watk3 ] { A_Charge(0); };
void() hknight_watk3 = [ $w_attack3, hknight_watk4 ] { A_Charge(0); };
void() hknight_watk4 = [ $w_attack4, hknight_watk5 ] { A_DeathKnightMeleeAttack(); };
void() hknight_watk5 = [ $w_attack5, hknight_watk6 ] { A_DeathKnightMeleeAttack(); };
void() hknight_watk6 = [ $w_attack6, hknight_watk7 ] { A_DeathKnightMeleeAttack(); };
void() hknight_watk7 = [ $w_attack7, hknight_watk8 ] { A_Charge(1); };
void() hknight_watk8 = [ $w_attack8, hknight_watk9 ] { A_Charge(4); };
void() hknight_watk9 = [ $w_attack9, hknight_watk10 ] { A_Charge(5); };
void() hknight_watk10 = [ $w_attack10, hknight_watk11 ] { A_Charge(3); A_DeathKnightMeleeAttack(); };
void() hknight_watk11 = [ $w_attack11, hknight_watk12 ] { A_Charge(2); A_DeathKnightMeleeAttack(); };
void() hknight_watk12 = [ $w_attack12, hknight_watk13 ] { A_Charge(2); A_DeathKnightMeleeAttack(); };
void() hknight_watk13 = [ $w_attack13, hknight_watk14 ] { A_Charge(0); };
void() hknight_watk14 = [ $w_attack14, hknight_watk15 ] { A_Charge(0); };
void() hknight_watk15 = [ $w_attack15, hknight_watk16 ] { A_Charge(0); };
void() hknight_watk16 = [ $w_attack16, hknight_watk17 ] { A_Charge(1); };
void() hknight_watk17 = [ $w_attack17, hknight_watk18 ] { A_Charge(1); A_DeathKnightMeleeAttack(); };
void() hknight_watk18 = [ $w_attack18, hknight_watk19 ] { A_Charge(3); A_DeathKnightMeleeAttack(); };
void() hknight_watk19 = [ $w_attack19, hknight_watk20 ] { A_Charge(4); A_DeathKnightMeleeAttack(); };
void() hknight_watk20 = [ $w_attack20, hknight_watk21 ] { A_Charge(6); };
void() hknight_watk21 = [ $w_attack21, hknight_watk22 ] { A_Charge(7); };
void() hknight_watk22 = [ $w_attack22, hknight_run1 ] { A_Charge(3); };

bool_t hknight_pain(entity attacker, entity inflictor, int_t damage)
{
	if (!TimerExpired(self.pain_finished))
		return FALSE;

	// Only randomize the chance if it's been a bit since it last flinched
	if (!TimerExpired(self.pain_finished + 5.0) && Round(30 * Random()) > damage)
	{
		if (Random() > 0.7)
			PlaySound(self, CHAN_VOICE, "hknight/grunt.wav", 1.0, ATTN_NORM);
		
		return FALSE;
	}

	PlaySound(self, CHAN_VOICE, "hknight/pain1.wav", 1.0, ATTN_NORM);
	hknight_pain1();
	SetCoolDown(self, pain_finished, 1.0);
	return TRUE;
}

void A_DeathKnightRun()
{
	PlaySound(self, CHAN_VOICE, "hknight/sight1.wav", 1.0, ATTN_NORM);
	hknight_run1();
}

void missile_deathknightmagic()
{
	self.dmg = 9;
	self.damage_type = "magic";
	self.misc_action = TE_KNIGHTSPIKE;
	self.obituary = OBIT_DTHK_MIS;
	
	StartMissile(self, "progs/k_spike.mdl");
}

void monster_hell_knight()
{
	if (!CanSpawn(self))
		return;
	
	if (MapLoading())
	{
		PrecacheEntity(missile_deathknightmagic);
		
		PrecacheSound("hknight/attack1.wav");
		PrecacheSound("hknight/death1.wav");
		PrecacheSound("hknight/pain1.wav");
		PrecacheSound("hknight/grunt.wav");
		PrecacheSound("hknight/sight1.wav");
		PrecacheSound("hknight/slash1.wav");
		PrecacheSound("hknight/idle.wav");
		PrecacheSound("knight/sword1.wav");
		PrecacheSound("knight/sword2.wav");
	}

	self.th_stand = hknight_stand1;
	self.th_walk = hknight_walk1;
	self.th_run = A_DeathKnightRun;
	self.th_melee = hknight_melee;
	self.th_missile = hknight_magicc1;
	self.th_pain = A_DeathKnightPain;
	self.th_die = A_DeathKnightDie;
	
	self.health = 250;
	self.deathtype = "melee";
	self.Obituary = OBIT_DTHK_MEL;

	StartMonster(self, "progs/hknight.mdl", "progs/h_hellkn.mdl");
}

// Enable special charge and missile attacks
void monster_hell_knight_boss()
{
	self.misc_action |= MON_SPECIAL_ATK;
	
	monster_hell_knight();
}
