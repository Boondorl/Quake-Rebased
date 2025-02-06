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

$frame attack1 attack2 attack3 attack4 attack5 attack6 attack7 attack8

$frame death1 death2 death3 death4 death5 death6 death7 death8 death9

$frame deathb1 deathb2 deathb3 deathb4 deathb5 deathb6 deathb7 deathb8
$frame deathb9

$frame pain1 pain2 pain3 pain4 pain5 pain6

$frame painb1 painb2 painb3 painb4 painb5 painb6 painb7 painb8 painb9 painb10
$frame painb11 painb12 painb13 painb14 painb15 painb16

$frame run1 run2 run3 run4 run5 run6 run7 run8 run9 run10 run11 run12

$frame leap1 leap2 leap3 leap4 leap5 leap6 leap7 leap8 leap9

$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7 stand8 stand9

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8

void A_RottweilerMeleeAttack(float dist)
{
	A_Charge(dist);

	int_t damage = MAX(2, Round(Random() + Random() + Random()) * 8);
	A_DirectDamage(damage, 100.0);
}

void P_RottweilerTouch()
{
	if (other.takedamage != DAMAGE_NO && Length(self.velocity) > 300.0)
		DamageEntity(other, self, self, 10 + Round(10 * Random()));

	self.touch = __NULL__;
	dog_run1();
}

void() dog_stand1 = [ $stand1, dog_stand2 ] { A_Stand(); };
void() dog_stand2 = [ $stand2, dog_stand3 ] { A_Stand(); };
void() dog_stand3 = [ $stand3, dog_stand4 ] { A_Stand(); };
void() dog_stand4 = [ $stand4, dog_stand5 ] { A_Stand(); };
void() dog_stand5 = [ $stand5, dog_stand6 ] { A_Stand(); };
void() dog_stand6 = [ $stand6, dog_stand7 ] { A_Stand(); };
void() dog_stand7 = [ $stand7, dog_stand8 ] { A_Stand(); };
void() dog_stand8 = [ $stand8, dog_stand9 ] { A_Stand(); };
void() dog_stand9 = [ $stand9, dog_stand1 ] { A_Stand(); };

void() dog_walk1 = [ $walk1 , dog_walk2 ]
{
	if (random() < 0.2)
		sound(self, CHAN_VOICE, "dog/idle.wav", 1, ATTN_IDLE);
	A_Walk(8);
};
void() dog_walk2 = [ $walk2 , dog_walk3 ] { A_Walk(8); };
void() dog_walk3 = [ $walk3 , dog_walk4 ] { A_Walk(8); };
void() dog_walk4 = [ $walk4 , dog_walk5 ] { A_Walk(8); };
void() dog_walk5 = [ $walk5 , dog_walk6 ] { A_Walk(8); };
void() dog_walk6 = [ $walk6 , dog_walk7 ] { A_Walk(8); };
void() dog_walk7 = [ $walk7 , dog_walk8 ] { A_Walk(8); };
void() dog_walk8 = [ $walk8 , dog_walk1 ] { A_Walk(8); };

void() dog_run1 = [ $run1  , dog_run2 ]
{
	if (random() < 0.2)
		sound(self, CHAN_VOICE, "dog/idle.wav", 1, ATTN_IDLE);
	A_Run(16);
};
void() dog_run2 = [ $run2  , dog_run3 ] { A_Run(32); };
void() dog_run3 = [ $run3  , dog_run4 ] { A_Run(32); };
void() dog_run4 = [ $run4  , dog_run5 ] { A_Run(20); };
void() dog_run5 = [ $run5  , dog_run6 ] { A_Run(64); };
void() dog_run6 = [ $run6  , dog_run7 ] { A_Run(32); };
void() dog_run7 = [ $run7  , dog_run8 ] { A_Run(16); };
void() dog_run8 = [ $run8  , dog_run9 ] { A_Run(32); };
void() dog_run9 = [ $run9  , dog_run10 ] { A_Run(32); };
void() dog_run10 = [ $run10  , dog_run11 ] { A_Run(20); };
void() dog_run11 = [ $run11  , dog_run12 ] { A_Run(64); };
void() dog_run12 = [ $run12  , dog_run1 ] { A_Run(32); };

void() dog_atta1 = [ $attack1, dog_atta2 ] { A_Charge(10); };
void() dog_atta2 = [ $attack2, dog_atta3 ] { A_Charge(10); };
void() dog_atta3 = [ $attack3, dog_atta4 ] { A_Charge(10); };
void() dog_atta4 = [ $attack4, dog_atta5 ]
{
	sound(self, CHAN_VOICE, "dog/dattack1.wav", 1, ATTN_NORM);
	dog_bite();
};
void() dog_atta5 = [ $attack5, dog_atta6 ] { A_Charge(10); };
void() dog_atta6 = [ $attack6, dog_atta7 ] { A_Charge(10); };
void() dog_atta7 = [ $attack7, dog_atta8 ] { A_Charge(10); };
void() dog_atta8 = [ $attack8, dog_run1 ] { A_Charge(10); };

void() dog_leap1 = [ $leap1, dog_leap2 ] { A_Face(); };
void() dog_leap2 = [ $leap2, dog_leap3 ]
{
	A_Face();
	
	FixedLocalAxes(self.angles);

	self.touch = P_RottweilerTouch;
	self.flags &= ~FL_ONGROUND;
	self.velocity = v_forward * 300.0 + [0.0, 0.0, 200.0];
	SetOrigin(self, self.origin + [0.0, 0.0, 1.0]);
};

void() dog_leap3 = [ $leap3, dog_leap4 ] {};
void() dog_leap4 = [ $leap4, dog_leap5 ] {};
void() dog_leap5 = [ $leap5, dog_leap6 ] {};
void() dog_leap6 = [ $leap6, dog_leap7 ] {};
void() dog_leap7 = [ $leap7, dog_leap8 ] {};
void() dog_leap8 = [ $leap8, dog_leap9 ] {};
void() dog_leap9 = [ $leap9, dog_leap9 ] {};

void() dog_pain1 = [ $pain1 , dog_pain2 ] { PlaySound(self, CHAN_VOICE, "dog/dpain1.wav", 1.0, ATTN_NORM); };
void() dog_pain2 = [ $pain2 , dog_pain3 ] {};
void() dog_pain3 = [ $pain3 , dog_pain4 ] {};
void() dog_pain4 = [ $pain4 , dog_pain5 ] {};
void() dog_pain5 = [ $pain5 , dog_pain6 ] {};
void() dog_pain6 = [ $pain6 , dog_run1 ] {};

void() dog_painb1 = [ $painb1 , dog_painb2 ] { PlaySound(self, CHAN_VOICE, "dog/dpain1.wav", 1.0, ATTN_NORM); };
void() dog_painb2 = [ $painb2 , dog_painb3 ] {};
void() dog_painb3 = [ $painb3 , dog_painb4 ] { ai_pain(4); };
void() dog_painb4 = [ $painb4 , dog_painb5 ] { ai_pain(12); };
void() dog_painb5 = [ $painb5 , dog_painb6 ] { ai_pain(12); };
void() dog_painb6 = [ $painb6 , dog_painb7 ] { ai_pain(2); };
void() dog_painb7 = [ $painb7 , dog_painb8 ] {};
void() dog_painb8 = [ $painb8 , dog_painb9 ] { ai_pain(4); };
void() dog_painb9 = [ $painb9 , dog_painb10 ] {};
void() dog_painb10 = [ $painb10 , dog_painb11 ] { ai_pain(10); };
void() dog_painb11 = [ $painb11 , dog_painb12 ] {};
void() dog_painb12 = [ $painb12 , dog_painb13 ] {};
void() dog_painb13 = [ $painb13 , dog_painb14 ] {};
void() dog_painb14 = [ $painb14 , dog_painb15 ] {};
void() dog_painb15 = [ $painb15 , dog_painb16 ] {};
void() dog_painb16 = [ $painb16 , dog_run1 ] {};

bool_t A_RottweilerPain(entity attacker, entity inflictor, int_t damage)
{
	if (Random() > 0.5)
		dog_pain1();
	else
		dog_painb1();
}

void() dog_die1 = [ $death1, dog_die2 ]
{
	PlaySound(self, CHAN_VOICE, "dog/ddeath.wav", 1.0, ATTN_NORM);
	SetSolid(self, SOLID_NOT);
};
void() dog_die2 = [ $death2, dog_die3 ] {};
void() dog_die3 = [ $death3, dog_die4 ] {};
void() dog_die4 = [ $death4, dog_die5 ] {};
void() dog_die5 = [ $death5, dog_die6 ] {};
void() dog_die6 = [ $death6, dog_die7 ] {};
void() dog_die7 = [ $death7, dog_die8 ] {};
void() dog_die8 = [ $death8, dog_die9 ] {};
void() dog_die9 = [ $death9, dog_die9 ] {};

void() dog_dieb1 = [ $deathb1, dog_dieb2 ]
{
	PlaySound(self, CHAN_VOICE, "dog/ddeath.wav", 1.0, ATTN_NORM);
	SetSolid(self, SOLID_NOT);
};
void() dog_dieb2 = [ $deathb2, dog_dieb3 ] {};
void() dog_dieb3 = [ $deathb3, dog_dieb4 ] {};
void() dog_dieb4 = [ $deathb4, dog_dieb5 ] {};
void() dog_dieb5 = [ $deathb5, dog_dieb6 ] {};
void() dog_dieb6 = [ $deathb6, dog_dieb7 ] {};
void() dog_dieb7 = [ $deathb7, dog_dieb8 ] {};
void() dog_dieb8 = [ $deathb8, dog_dieb9 ] {};
void() dog_dieb9 = [ $deathb9, dog_dieb9 ] {};


void A_RottwilerDie()
{
	if (self.health < -35)
	{
		GibMonster(self, "progs/h_dog.mdl");
		return;
	}
	
	if (Random() > 0.5)
		dog_die1();
	else
		dog_dieb1();
}

bool_t A_CheckRottweilerAttack()
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
	if (range < 80.0 || range > 150.0
		|| self.absmin.z > self.enemy.absmin.z + self.enemy.size.z * 0.75
		|| self.absmax.z < self.enemy.absmin.z + self.enemy.size.z * 0.25)
	{
		return FALSE;
	}

	self.attack_state = AS_MISSILE;
	return TRUE;
}

void monster_dog()
{
	if (!CanSpawn(self))
		return;

	PrecacheSound("dog/idle.wav");
	PrecacheSound("dog/dattack1.wav");
	PrecacheSound("dog/dpain1.wav");
	PrecacheSound("dog/ddeath.wav");

	self.th_stand = dog_stand1;
	self.th_walk = dog_walk1;
	self.th_run = dog_run1;
	self.th_melee = dog_atta1;
	self.th_missile = dog_leap1;
	self.th_pain = A_RottweilerPain;
	self.th_die = A_RottwilerDie;
	self.AttackCheck = A_RottweilerAttackCheck;
	
	self.health = 25;
	self.noise1 = "dog/dsight.wav";

	// Dog intentionally made smaller so it can better fit
	// in maps
	StartMonster(self, "progs/dog.mdl", "progs/h_dog.mdl");
}
