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

$frame Idle1 Idle2 Idle3 Idle4 Idle5 Idle6 Idle7 Idle8 Idle9
$frame Idle10 Idle11 Idle12 Idle13

$frame Walk1 Walk2 Walk3 Walk4 Walk5 Walk6 Walk7 Walk8

$frame Run1 Run2 Run3 Run4 Run5 Run6

$frame LeapAtk1 LeapAtk2 LeapAtk3 LeapAtk4 LeapAtk5 LeapAtk6 LeapAtk7 LeapAtk8 LeapAtk9 LeapAtk10
$frame LeapAtk11 LeapAtk12

$frame Pain1 Pain2 Pain3 Pain4 Pain5 Pain6

$frame Death1 Death2 Death3 Death4 Death5 Death6 Death7 Death8 Death9

$frame Melee1 Melee2 Melee3 Melee4 Melee5 Melee6 Melee7 Melee8
$frame Melee9 Melee10 Melee11 Melee12 Melee13 Melee14 Melee15

void() S_FiendIdle1 = [ $Idle1, S_FiendIdle1 ]
{
	self.walkframe = AdvanceFrame(self.walkframe, $Idle1, $Idle13);
	self.frame = self.walkframe;
	
	A_Stand();
};

void() S_FiendWalk1 = [ $Walk1, S_FiendWalk2 ] { A_Walk(8.0); };
void() S_FiendWalk2 = [ $Walk2, S_FiendWalk3 ] { A_Walk(6.0); };
void() S_FiendWalk3 = [ $Walk3, S_FiendWalk4 ] { A_Walk(6.0); };
void() S_FiendWalk4 = [ $Walk4, S_FiendWalk5 ] { A_Walk(7.0); };
void() S_FiendWalk5 = [ $Walk5, S_FiendWalk6 ] { A_Walk(4.0); };
void() S_FiendWalk6 = [ $Walk6, S_FiendWalk7 ] { A_Walk(6.0); };
void() S_FiendWalk7 = [ $Walk7, S_FiendWalk8 ] { A_Walk(10.0); };
void() S_FiendWalk8 = [ $Walk8, S_FiendWalk1 ]
{
	if (Random() < 0.2)
		PlaySound(self, CHAN_VOICE, "demon/idle1.wav", 1.0, ATTN_IDLE);
	
	A_Walk(10.0);
};

void() S_FiendRun1 = [ $Run1, S_FiendRun2 ] { A_Run(20.0); };
void() S_FiendRun2 = [ $Run2, S_FiendRun3 ] { A_Run(15.0); };
void() S_FiendRun3 = [ $Run3, S_FiendRun4 ] { A_Run(36.0); };
void() S_FiendRun4 = [ $Run4, S_FiendRun5 ] { A_Run(20.0); };
void() S_FiendRun5 = [ $Run5, S_FiendRun6 ] { A_Run(15.0); };
void() S_FiendRun6 = [ $Run6, S_FiendRun1 ]
{
	if (Random() < 0.2)
		PlaySound(self, CHAN_VOICE, "demon/idle1.wav", 1.0, ATTN_NORM);
	
	A_Run(36.0);
};

void() S_FiendLeapAttack1 = [ $LeapAtk1, S_FiendLeapAttack2 ]
{
	PlaySound(self, CHAN_VOICE, "demon/djump.wav", 1.0, ATTN_NORM);
	A_Face();
};
void() S_FiendLeapAttack2 = [ $LeapAtk2, S_FiendLeapAttack3 ] { A_Face(); };
void() S_FiendLeapAttack3 = [ $LeapAtk3, S_FiendLeapAttack4 ] { A_Face(); };
void() S_FiendLeapAttack4 = [ $LeapAtk4, S_FiendLeapAttack5 ]
{
	A_Face();
	
	FixedLocalAxes(self.angles);

	self.touch = P_FiendTouch;
	self.velocity = v_forward * 600.0 + [0.0, 0.0, 250.0];
	self.flags &= ~FL_ONGROUND;
	SetOrigin(self, self.origin + [0.0, 0.0, 1.0]);
};
void() S_FiendLeapAttack5 = [ $LeapAtk5, S_FiendLeapAttack6 ] {};
void() S_FiendLeapAttack6 = [ $LeapAtk6, S_FiendLeapAttack7 ] {};
void() S_FiendLeapAttack7 = [ $LeapAtk7, S_FiendLeapAttack8 ] {};
void() S_FiendLeapAttack8 = [ $LeapAtk8, S_FiendLeapAttack9 ] {};
void() S_FiendLeapAttack9 = [ $LeapAtk9, S_FiendLeapAttack10 ] { self.oldorigin = self.origin; };
void() S_FiendLeapAttack10 = [ $LeapAtk10, S_FiendLeapAttack10 ]
{
	// Improved stuck checker that doesn't cause Fiends in freefall to try
	// jumping again after 3 seconds
	if (self.origin == self.oldorigin)
	{
		S_FiendLeapAttack11();
		return;
	}
	
	self.oldorigin = self.origin;
};
void() S_FiendLeapAttack11 = [ $LeapAtk11, S_FiendLeapAttack12 ] {};
void() S_FiendLeapAttack12 = [ $LeapAtk12, S_FiendRun1 ] {};

void() S_FiendMelee1 = [ $Melee1, S_FiendMelee2 ] { A_Charge(4.0); };
void() S_FiendMelee2 = [ $Melee2, S_FiendMelee3 ] { A_Charge(0.0); };
void() S_FiendMelee3 = [ $Melee3, S_FiendMelee4 ] { A_Charge(0.0); };
void() S_FiendMelee4 = [ $Melee4, S_FiendMelee5 ] { A_Charge(1.0); };
void() S_FiendMelee5 = [ $Melee5, S_FiendMelee6 ] { A_FiendMeleeAttack(14.0, 200.0); };
void() S_FiendMelee6 = [ $Melee6, S_FiendMelee7 ] { A_Charge(1.0); };
void() S_FiendMelee7 = [ $Melee7, S_FiendMelee8 ] { A_Charge(6.0); };
void() S_FiendMelee8 = [ $Melee8, S_FiendMelee9 ] { A_Charge(8.0); };
void() S_FiendMelee9 = [ $Melee9, S_FiendMelee10 ] { A_Charge(4.0); };
void() S_FiendMelee10 = [ $Melee10, S_FiendMelee11 ] { A_Charge(2.0); };
void() S_FiendMelee11 = [ $Melee11, S_FiendMelee12 ] { A_FiendMeleeAttack(12.0, -200.0); };
void() S_FiendMelee12 = [ $Melee12, S_FiendMelee13 ] { A_Charge(5.0); };
void() S_FiendMelee13 = [ $Melee13, S_FiendMelee14 ] { A_Charge(8.0); };
void() S_FiendMelee14 = [ $Melee14, S_FiendMelee15 ] { A_Charge(4.0); };
void() S_FiendMelee15 = [ $Melee15, S_FiendRun1 ] { A_Charge(4.0); };

void() S_FiendPain1 = [ $Pain1, S_FiendPain2 ] {};
void() S_FiendPain2 = [ $Pain2, S_FiendPain3 ] {};
void() S_FiendPain3 = [ $Pain3, S_FiendPain4 ] {};
void() S_FiendPain4 = [ $Pain4, S_FiendPain5 ] {};
void() S_FiendPain5 = [ $Pain5, S_FiendPain6 ] {};
void() S_FiendPain6 = [ $Pain6, S_FiendRun1 ] {};

void() S_FiendDeath1 = [ $Death1, S_FiendDeath2 ] { PlaySound(self, CHAN_VOICE, "demon/ddeath.wav", 1.0, ATTN_NORM); };
void() S_FiendDeath2 = [ $Death2, S_FiendDeath3 ] {};
void() S_FiendDeath3 = [ $Death3, S_FiendDeath4 ] {};
void() S_FiendDeath4 = [ $Death4, S_FiendDeath5 ] {};
void() S_FiendDeath5 = [ $Death5, S_FiendDeath6 ] {};
void() S_FiendDeath6 = [ $Death6, S_FiendDeath7 ] { SetSolid(self, SOLID_NOT); };
void() S_FiendDeath7 = [ $Death7, S_FiendDeath8 ] {};
void() S_FiendDeath8 = [ $Death8, S_FiendDeath9 ] {};
void() S_FiendDeath9 = [ $Death9, S_FiendDeath9 ] {};

bool_t A_FiendPain(entity attacker, entity inflictor, int_t damage)
{
	if (self.touch || !TimerExpired(self.pain_finished))
		return FALSE;

	SetCoolDown(self, pain_finished, 1.0);
	PlaySound(self, CHAN_VOICE, "demon/dpain1.wav", 1.0, ATTN_NORM);

	if (Round(200.0 * Random()) > damage)
		return FALSE;

	S_FiendPain1();
	return TRUE;
}

void A_FiendDie()
{
	if (self.health < -80)
	{
		GibMonster(self, "progs/h_demon.mdl");
		return;
	}

	S_FiendDeath1();
}

void monster_demon1()
{
	if (deathmatch)
	{
		RemoveEntity(self);
		return;
	}
	
	TryPrecacheModel("progs/demon.mdl");
	TryPrecacheModel("progs/h_demon.mdl");

	TryPrecacheSound("demon/ddeath.wav");
	TryPrecacheSound("demon/dhit2.wav");
	TryPrecacheSound("demon/djump.wav");
	TryPrecacheSound("demon/dpain1.wav");
	TryPrecacheSound("demon/idle1.wav");
	TryPrecacheSound("demon/sight2.wav");
	
	self.th_idle = S_FiendIdle1;
	self.th_walk = S_FiendWalk1;
	self.th_run = S_FiendRun1;
	self.th_melee = S_FiendMelee1;
	self.th_missile = S_FiendLeapAttack1;
	self.th_pain = A_FiendPain;
	self.th_die = A_FiendDie;
	self.AttackCheck = A_CheckFiendAttack;
	
	self.health = 300;
	self.Obituary = OBIT_FIEND;
	self.deathtype = "melee";
	
	StartMonster(self, "progs/demon.mdl", TRUE);
}

/*
==============================================================================

DEMON

==============================================================================
*/

bool_t A_CheckFiendAttack()
{
	if (!IsVisible(self, self.enemy, VIS_CHECK_MONSTERS))
		return FALSE;

	float range = GetRange(self, self.enemy);
	if (range <= RANGE_MELEE)
	{
		self.attack_state = AS_MELEE;
		return TRUE;
	}
	
	// Leap attack. This doesn't use a 2D check anymore but did that ever really make sense?
	if (range < 100.0
		|| self.absmin.z > self.enemy.absmin.z + self.enemy.size.z * 0.75
		|| self.absmax.z < self.enemy.absmin.z + self.enemy.size.z * 0.25
		|| (range > 200.0 && Random() < 0.9))
	{
		return FALSE;
	}

	self.attack_state = AS_MISSILE;
	return TRUE;
}

void A_FiendMeleeAttack(float dist, float sideSpeed)
{
	A_Charge(dist);
	
	int_t damage = A_DirectDamage(10 + Round(5.0 * Random()), 100.0);
	if (damage >= 0)
	{
		PlaySound(self, CHAN_WEAPON, "demon/dhit2.wav", 1.0, ATTN_NORM);
		
		FixedLocalAxes(self.angles);
		SpawnMeatSpray(self.origin + v_forward * 16.0, v_right * sideSpeed);
	}
}

void P_FiendTouch()
{
	// Try and only attack actually living entities
	if (other.takedamage == DAMAGE_NO || other.solid != SOLID_SLIDEBOX)
		return;
	
	if (Length(self.velocity) > 400.0)
		DamageEntity(other, self, self, 40 + Round(10 * Random()));
	
	// Removed the silly ground check as this caused the infamous Goomba
	// stomping bug
	
	S_FiendLeapAttack11();
}
