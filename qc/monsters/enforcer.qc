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

$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8 walk9 walk10
$frame walk11 walk12 walk13 walk14 walk15 walk16

$frame run1 run2 run3 run4 run5 run6 run7 run8

$frame attack1 attack2 attack3 attack4 attack5 attack6
$frame attack7 attack8 attack9 attack10

$frame death1 death2 death3 death4 death5 death6 death7 death8
$frame death9 death10 death11 death12 death13 death14

$frame fdeath1 fdeath2 fdeath3 fdeath4 fdeath5 fdeath6 fdeath7 fdeath8
$frame fdeath9 fdeath10 fdeath11

$frame paina1 paina2 paina3 paina4

$frame painb1 painb2 painb3 painb4 painb5

$frame painc1 painc2 painc3 painc4 painc5 painc6 painc7 painc8

$frame paind1 paind2 paind3 paind4 paind5 paind6 paind7 paind8
$frame paind9 paind10 paind11 paind12 paind13 paind14 paind15 paind16
$frame paind17 paind18 paind19

void A_EnforcerMissileAttack()
{
	A_Face();
	
	FixedLocalAxes(self.angles);
	
	self.effects |= EF_MUZZLEFLASH;
	PlaySound(self, CHAN_WEAPON, "enforcer/enfire.wav", 1.0, ATTN_NORM);

	vector orig = self.origin + v_forward * 30.0 + v_right * 8.5 + v_up * 16.0;
	SpawnMissile(self, missile_enforcerlaser, orig, GetAimDir(self.enemy, orig), 600.0);
}

void() enf_stand1 = [ $stand1, enf_stand2 ] { A_Stand(); };
void() enf_stand2 = [ $stand2, enf_stand3 ] { A_Stand(); };
void() enf_stand3 = [ $stand3, enf_stand4 ] { A_Stand(); };
void() enf_stand4 = [ $stand4, enf_stand5 ] { A_Stand(); };
void() enf_stand5 = [ $stand5, enf_stand6 ] { A_Stand(); };
void() enf_stand6 = [ $stand6, enf_stand7 ] { A_Stand(); };
void() enf_stand7 = [ $stand7, enf_stand1 ] { A_Stand(); };

void() enf_walk1 = [ $walk1 , enf_walk2 ]
{
	if (Random() < 0.2)
		sound(self, CHAN_VOICE, "enforcer/idle1.wav", 1, ATTN_IDLE);
	A_Walk(2);
};
void() enf_walk2 = [ $walk2 , enf_walk3 ] { A_Walk(4); };
void() enf_walk3 = [ $walk3 , enf_walk4 ] { A_Walk(4); };
void() enf_walk4 = [ $walk4 , enf_walk5 ] { A_Walk(3); };
void() enf_walk5 = [ $walk5 , enf_walk6 ] { A_Walk(1); };
void() enf_walk6 = [ $walk6 , enf_walk7 ] { A_Walk(2); };
void() enf_walk7 = [ $walk7 , enf_walk8 ] { A_Walk(2); };
void() enf_walk8 = [ $walk8 , enf_walk9 ] { A_Walk(1); };
void() enf_walk9 = [ $walk9 , enf_walk10 ] { A_Walk(2); };
void() enf_walk10 = [ $walk10, enf_walk11 ] { A_Walk(4); };
void() enf_walk11 = [ $walk11, enf_walk12 ] { A_Walk(4); };
void() enf_walk12 = [ $walk12, enf_walk13 ] { A_Walk(1); };
void() enf_walk13 = [ $walk13, enf_walk14 ] { A_Walk(2); };
void() enf_walk14 = [ $walk14, enf_walk15 ] { A_Walk(3); };
void() enf_walk15 = [ $walk15, enf_walk16 ] { A_Walk(4); };
void() enf_walk16 = [ $walk16, enf_walk1 ] { A_Walk(2); };

void() enf_run1 = [ $run1  , enf_run2 ]
{
	if (Random() < 0.2)
		sound(self, CHAN_VOICE, "enforcer/idle1.wav", 1, ATTN_IDLE);
	A_Run(18);
};
void() enf_run2 = [ $run2  , enf_run3 ] { A_Run(14); };
void() enf_run3 = [ $run3  , enf_run4 ] { A_Run(7); };
void() enf_run4 = [ $run4  , enf_run5 ] { A_Run(12); };
void() enf_run5 = [ $run5  , enf_run6 ] { A_Run(14); };
void() enf_run6 = [ $run6  , enf_run7 ] { A_Run(14); };
void() enf_run7 = [ $run7  , enf_run8 ] { A_Run(7); };
void() enf_run8 = [ $run8  , enf_run1 ] { A_Run(11); };

void() enf_atk1 = [ $attack1, enf_atk2 ] { A_Face(); };
void() enf_atk2 = [ $attack2, enf_atk3 ] { A_Face(); };
void() enf_atk3 = [ $attack3, enf_atk4 ] { A_Face(); };
void() enf_atk4 = [ $attack4, enf_atk5 ] { A_Face(); };
void() enf_atk5 = [ $attack5, enf_atk6 ] { A_Face(); };
void() enf_atk6 = [ $attack6, enf_atk7 ] { A_EnforcerMissileAttack(); };
void() enf_atk7 = [ $attack7, enf_atk8 ] { A_Face(); };
void() enf_atk8 = [ $attack8, enf_atk9 ] { A_Face(); };
void() enf_atk9 = [ $attack5, enf_atk10 ] { A_Face(); };
void() enf_atk10 = [ $attack6, enf_atk11 ] { A_EnforcerMissileAttack(); };
void() enf_atk11 = [ $attack7, enf_atk12 ] { A_Face(); };
void() enf_atk12 = [ $attack8, enf_atk13 ] { A_Face(); };
void() enf_atk13 = [ $attack9, enf_atk14 ] { A_Face(); };
void() enf_atk14 = [ $attack10, enf_run1 ]
{
	A_Face();
	A_CheckRefire(enf_atk6);
};

void() enf_paina1 = [ $paina1, enf_paina2 ] {};
void() enf_paina2 = [ $paina2, enf_paina3 ] {};
void() enf_paina3 = [ $paina3, enf_paina4 ] {};
void() enf_paina4 = [ $paina4, enf_run1 ] {};

void() enf_painb1 = [ $painb1, enf_painb2 ] {};
void() enf_painb2 = [ $painb2, enf_painb3 ] {};
void() enf_painb3 = [ $painb3, enf_painb4 ] {};
void() enf_painb4 = [ $painb4, enf_painb5 ] {};
void() enf_painb5 = [ $painb5, enf_run1 ] {};

void() enf_painc1 = [ $painc1, enf_painc2 ] {};
void() enf_painc2 = [ $painc2, enf_painc3 ] {};
void() enf_painc3 = [ $painc3, enf_painc4 ] {};
void() enf_painc4 = [ $painc4, enf_painc5 ] {};
void() enf_painc5 = [ $painc5, enf_painc6 ] {};
void() enf_painc6 = [ $painc6, enf_painc7 ] {};
void() enf_painc7 = [ $painc7, enf_painc8 ] {};
void() enf_painc8 = [ $painc8, enf_run1 ] {};

void() enf_paind1 = [ $paind1, enf_paind2 ] {};
void() enf_paind2 = [ $paind2, enf_paind3 ] {};
void() enf_paind3 = [ $paind3, enf_paind4 ] {};
void() enf_paind4 = [ $paind4, enf_paind5 ] { A_Move(2); };
void() enf_paind5 = [ $paind5, enf_paind6 ] { A_Move(1); };
void() enf_paind6 = [ $paind6, enf_paind7 ] {};
void() enf_paind7 = [ $paind7, enf_paind8 ] {};
void() enf_paind8 = [ $paind8, enf_paind9 ] {};
void() enf_paind9 = [ $paind9, enf_paind10 ] {};
void() enf_paind10 = [ $paind10, enf_paind11 ] {};
void() enf_paind11 = [ $paind11, enf_paind12 ] { A_Move(1); };
void() enf_paind12 = [ $paind12, enf_paind13 ] { A_Move(1); };
void() enf_paind13 = [ $paind13, enf_paind14 ] { A_Move(1); };
void() enf_paind14 = [ $paind14, enf_paind15 ] {};
void() enf_paind15 = [ $paind15, enf_paind16 ] {};
void() enf_paind16 = [ $paind16, enf_paind17 ] { A_Move(1, 180.0); };
void() enf_paind17 = [ $paind17, enf_paind18 ] { A_Move(1, 180.0); };
void() enf_paind18 = [ $paind18, enf_paind19 ] {};
void() enf_paind19 = [ $paind19, enf_run1 ] {};

bool_t A_EnforcerPain(entity attacker, entity inflictor, int_t damage)
{
	if (!TimerExpired(self.pain_finished))
		return FALSE;

	float r = Random();
	if (r < 0.5)
		PlaySound(self, CHAN_VOICE, "enforcer/pain1.wav", 1.0, ATTN_NORM);
	else
		PlaySound(self, CHAN_VOICE, "enforcer/pain2.wav", 1.0, ATTN_NORM);

	if (r < 0.7)
	{
		if (r < 0.2)
			enf_paina1();
		else if (r < 0.4)
			enf_painb1();
		else
			enf_painc1();
		
		SetCoolDown(self, pain_finished, 1.0);
	}
	else
	{
		enf_paind1();
		SetCoolDown(self, pain_finished, 2.0);
	}
	
	return TRUE;
}

void() enf_die1 = [ $death1, enf_die2 ] {};
void() enf_die2 = [ $death2, enf_die3 ] {};
void() enf_die3 = [ $death3, enf_die4 ] { SetSolid(self, SOLID_NOT); };
void() enf_die4 = [ $death4, enf_die5 ] { A_Move(14); };
void() enf_die5 = [ $death5, enf_die6 ] { A_Move(2); };
void() enf_die6 = [ $death6, enf_die7 ] {};
void() enf_die7 = [ $death7, enf_die8 ] {};
void() enf_die8 = [ $death8, enf_die9 ] {};
void() enf_die9 = [ $death9, enf_die10 ] { A_Move(3); };
void() enf_die10 = [ $death10, enf_die11 ] { A_Move(5); };
void() enf_die11 = [ $death11, enf_die12 ] { A_Move(5); };
void() enf_die12 = [ $death12, enf_die13 ] { A_Move(5); };
void() enf_die13 = [ $death13, enf_die14 ] {};
void() enf_die14 = [ $death14, enf_die14 ] {};

void() enf_fdie1 = [ $fdeath1, enf_fdie2 ] {};
void() enf_fdie2 = [ $fdeath2, enf_fdie3 ] {};
void() enf_fdie3 = [ $fdeath3, enf_fdie4 ] { SetSolid(self, SOLID_NOT); };
void() enf_fdie4 = [ $fdeath4, enf_fdie5 ] {};
void() enf_fdie5 = [ $fdeath5, enf_fdie6 ] {};
void() enf_fdie6 = [ $fdeath6, enf_fdie7 ] {};
void() enf_fdie7 = [ $fdeath7, enf_fdie8 ] {};
void() enf_fdie8 = [ $fdeath8, enf_fdie9 ] {};
void() enf_fdie9 = [ $fdeath9, enf_fdie10 ] {};
void() enf_fdie10 = [ $fdeath10, enf_fdie11 ] {};
void() enf_fdie11 = [ $fdeath11, enf_fdie11 ] {};

void A_EnforcerDie()
{
	A_DropBackpack(TRUE);
	
	if (self.health < -35)
	{
		GibMonster(self, "progs/h_mega.mdl");
		return;
	}

	PlaySound(self, CHAN_VOICE, "enforcer/death1.wav", 1.0, ATTN_NORM);
	if (Random() > 0.5)
		enf_die1();
	else
		enf_fdie1();
}

void A_EnforcerRun()
{
	float r = Random();
	if (r < 0.25)
		PlaySound(self, CHAN_VOICE, "enforcer/sight1.wav", 1.0, ATTN_NORM);
	else if (r < 0.5)
		PlaySound(self, CHAN_VOICE, "enforcer/sight2.wav", 1.0, ATTN_NORM);
	else if (r < 0.75)
		PlaySound(self, CHAN_VOICE, "enforcer/sight3.wav", 1.0, ATTN_NORM);
	else
		PlaySound(self, CHAN_VOICE, "enforcer/sight4.wav", 1.0, ATTN_NORM);
	
	enf_run1();
}

void missile_enforcerlaser()
{
	self.touch = P_MissileTouch;
	
	self.dmg = 15;
	self.damage_type = "plasma";
	self.misc_action = TE_GUNSHOT;
	self.noise2 = "enforcer/enfstop.wav";
	self.obituary = OBIT_ENFORC;
	self.effects |= EF_DIMLIGHT;
	
	StartMissile(self, "progs/laser.mdl");
}

void monster_enforcer()
{
	if (!CanSpawn(self))
		return;
	
	if (CanPrecache())
	{
		PrecacheEntity(missile_enforcerlaser);

		PrecacheSound("enforcer/idle1.wav");
		PrecacheSound("enforcer/sight1.wav");
		PrecacheSound("enforcer/sight2.wav");
		PrecacheSound("enforcer/sight3.wav");
		PrecacheSound("enforcer/sight4.wav");
		PrecacheSound("enforcer/enfire.wav");
		PrecacheSound("enforcer/pain1.wav");
		PrecacheSound("enforcer/pain2.wav");
		PrecacheSound("enforcer/death1.wav");
	}

	self.th_stand = enf_stand1;
	self.th_walk = enf_walk1;
	self.th_run = A_EnforcerRun;
	self.th_missile = enf_atk1;
	self.th_pain = A_EnforcerPain;
	self.th_die = A_EnforcerDie;
	
	self.health = 80;
	self.ammo_cells += 5; // Support backpackless map hack

	StartMonster(self, "progs/enforcer.mdl", "progs/h_mega.mdl");
}
