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

$frame attack1 attack2 attack3 attack4 attack5 attack6
$frame attack7 attack8 attack9 attack10 attack11 attack12 attack13
$frame attack14 attack15 attack16 attack17 attack18

$frame death1 death2 death3 death4 death5 death6 death7
$frame death8 death9 death10 death11 death12 death13 death14 death15
$frame death16 death17 death18 death19 death20 death21

$frame swim1 swim2 swim3 swim4 swim5 swim6 swim7 swim8
$frame swim9 swim10 swim11 swim12 swim13 swim14 swim15 swim16 swim17
$frame swim18

$frame pain1 pain2 pain3 pain4 pain5 pain6 pain7 pain8
$frame pain9

void() f_stand1  = [ $swim1, f_stand2 ] { A_Stand(); };
void() f_stand2  = [ $swim2, f_stand3 ] { A_Stand(); };
void() f_stand3  = [ $swim3, f_stand4 ] { A_Stand(); };
void() f_stand4  = [ $swim4, f_stand5 ] { A_Stand(); };
void() f_stand5  = [ $swim5, f_stand6 ] { A_Stand(); };
void() f_stand6  = [ $swim6, f_stand7 ] { A_Stand(); };
void() f_stand7  = [ $swim7, f_stand8 ] { A_Stand(); };
void() f_stand8  = [ $swim8, f_stand9 ] { A_Stand(); };
void() f_stand9  = [ $swim9, f_stand10  ] { A_Stand(); };
void() f_stand10 = [ $swim10, f_stand11 ] { A_Stand(); };
void() f_stand11 = [ $swim11, f_stand12 ] { A_Stand(); };
void() f_stand12 = [ $swim12, f_stand13 ] { A_Stand(); };
void() f_stand13 = [ $swim13, f_stand14 ] { A_Stand(); };
void() f_stand14 = [ $swim14, f_stand15 ] { A_Stand(); };
void() f_stand15 = [ $swim15, f_stand16 ] { A_Stand(); };
void() f_stand16 = [ $swim16, f_stand17 ] { A_Stand(); };
void() f_stand17 = [ $swim17, f_stand18 ] { A_Stand(); };
void() f_stand18 = [ $swim18, f_stand1 ] { A_Stand(); };

void() f_walk1  = [ $swim1, f_walk2 ] { A_Walk(8); };
void() f_walk2  = [ $swim2, f_walk3 ] { A_Walk(8); };
void() f_walk3  = [ $swim3, f_walk4 ] { A_Walk(8); };
void() f_walk4  = [ $swim4, f_walk5 ] { A_Walk(8); };
void() f_walk5  = [ $swim5, f_walk6 ] { A_Walk(8); };
void() f_walk6  = [ $swim6, f_walk7 ] { A_Walk(8); };
void() f_walk7  = [ $swim7, f_walk8 ] { A_Walk(8); };
void() f_walk8  = [ $swim8, f_walk9 ] { A_Walk(8); };
void() f_walk9  = [ $swim9, f_walk10  ] { A_Walk(8); };
void() f_walk10 = [ $swim10, f_walk11 ] { A_Walk(8); };
void() f_walk11 = [ $swim11, f_walk12 ] { A_Walk(8); };
void() f_walk12 = [ $swim12, f_walk13 ] { A_Walk(8); };
void() f_walk13 = [ $swim13, f_walk14 ] { A_Walk(8); };
void() f_walk14 = [ $swim14, f_walk15 ] { A_Walk(8); };
void() f_walk15 = [ $swim15, f_walk16 ] { A_Walk(8); };
void() f_walk16 = [ $swim16, f_walk17 ] { A_Walk(8); };
void() f_walk17 = [ $swim17, f_walk18 ] { A_Walk(8); };
void() f_walk18 = [ $swim18, f_walk1 ] { A_Walk(8); };

void() f_run1  = [ $swim1, f_run2 ]
{
	A_Run(12);
	if (random() < 0.5)
		sound(self, CHAN_VOICE, "fish/idle.wav", 1.0, ATTN_IDLE);
};
void() f_run2  = [ $swim3, f_run3 ] { A_Run(12); };
void() f_run3  = [ $swim5, f_run4 ] { A_Run(12); };
void() f_run4  = [ $swim7, f_run5 ] { A_Run(12); };
void() f_run5  = [ $swim9, f_run6 ] { A_Run(12); };
void() f_run6  = [ $swim11, f_run7 ] { A_Run(12); };
void() f_run7  = [ $swim13, f_run8 ] { A_Run(12); };
void() f_run8  = [ $swim15, f_run9 ] { A_Run(12); };
void() f_run9  = [ $swim17, f_run1 ] { A_Run(12); };

void A_RotfishMeleeAttack(float dist)
{
	A_Charge(dist);
	
	PlaySound(self, CHAN_VOICE, "fish/bite.wav", 1.0, ATTN_NORM);
	A_DirectDamage(MAX(1, Round(Random() + Random() * 3)), 60.0);
}

void() f_attack1 = [ $attack1, f_attack2 ] { A_Charge(10); };
void() f_attack2 = [ $attack2, f_attack3 ] { A_Charge(10); };
void() f_attack3 = [ $attack3, f_attack4 ] { A_RotfishMeleeAttack(); };
void() f_attack4 = [ $attack4, f_attack5 ] { A_Charge(10); };
void() f_attack5 = [ $attack5, f_attack6 ] { A_Charge(10); };
void() f_attack6 = [ $attack6, f_attack7 ] { A_Charge(10); };
void() f_attack7 = [ $attack7, f_attack8 ] { A_Charge(10); };
void() f_attack8 = [ $attack8, f_attack9 ] { A_Charge(10); };
void() f_attack9 = [ $attack9, f_attack10 ] { A_RotfishMeleeAttack(10.0); };
void() f_attack10 = [ $attack10, f_attack11 ] { A_Charge(10); };
void() f_attack11 = [ $attack11, f_attack12 ] { A_Charge(10); };
void() f_attack12 = [ $attack12, f_attack13 ] { A_Charge(10); };
void() f_attack13 = [ $attack13, f_attack14 ] { A_Charge(10); };
void() f_attack14 = [ $attack14, f_attack15 ] { A_Charge(10); };
void() f_attack15 = [ $attack15, f_attack16 ] { A_RotfishMeleeAttack(10.0); };
void() f_attack16 = [ $attack16, f_attack17 ] { A_Charge(10); };
void() f_attack17 = [ $attack17, f_attack18 ] { A_Charge(10); };
void() f_attack18 = [ $attack18, f_run1 ] { A_Charge(10); };

void() f_death1 = [ $death1, f_death2 ]
{
	PlaySound(self, CHAN_VOICE, "fish/death.wav", 1.0, ATTN_NORM);
};
void() f_death2 = [ $death2, f_death3 ] {};
void() f_death3 = [ $death3, f_death4 ] { SetSolid(self, SOLID_NOT); };
void() f_death4 = [ $death4, f_death5 ] {};
void() f_death5 = [ $death5, f_death6 ] {};
void() f_death6 = [ $death6, f_death7 ] {};
void() f_death7 = [ $death7, f_death8 ] {};
void() f_death8 = [ $death8, f_death9 ] {};
void() f_death9 = [ $death9, f_death10 ] {};
void() f_death10 = [ $death10, f_death11 ] {};
void() f_death11 = [ $death11, f_death12 ] {};
void() f_death12 = [ $death12, f_death13 ] {};
void() f_death13 = [ $death13, f_death14 ] {};
void() f_death14 = [ $death14, f_death15 ] {};
void() f_death15 = [ $death15, f_death16 ] {};
void() f_death16 = [ $death16, f_death17 ] {};
void() f_death17 = [ $death17, f_death18 ] {};
void() f_death18 = [ $death18, f_death19 ] {};
void() f_death19 = [ $death19, f_death20 ] {};
void() f_death20 = [ $death20, f_death21 ] {};
void() f_death21 = [ $death21, f_death21 ] {};

void() f_pain1  = [ $pain1, f_pain2 ] {};
void() f_pain2  = [ $pain2, f_pain3 ] { ai_pain(6); };
void() f_pain3  = [ $pain3, f_pain4 ] { ai_pain(6); };
void() f_pain4  = [ $pain4, f_pain5 ] { ai_pain(6); };
void() f_pain5  = [ $pain5, f_pain6 ] { ai_pain(6); };
void() f_pain6  = [ $pain6, f_pain7 ] { ai_pain(6); };
void() f_pain7  = [ $pain7, f_pain8 ] { ai_pain(6); };
void() f_pain8  = [ $pain8, f_pain9 ] { ai_pain(6); };
void() f_pain9  = [ $pain9, f_run1 ] { ai_pain(6); };

bool_t A_RotfishPain(entity attacker, entity inflictor, int_t damage)
{
	f_pain1();
	return FALSE;
}

void A_RotfishDie()
{
	if (self.health < -35)
	{
		GibMonster(self, __NULL__);
		return;
	}
	
	f_death1();
}

void monster_fish()
{
	if (deathmatch)
	{
		RemoveEntity(self);
		return;
	}
	
	precache_model2 ("progs/fish.mdl");

	precache_sound2 ("fish/death.wav");
	precache_sound2 ("fish/bite.wav");
	precache_sound2 ("fish/idle.wav");

	self.th_stand = f_stand1;
	self.th_walk = f_walk1;
	self.th_run = f_run1;
	self.th_melee = f_attack1;
	self.th_pain = A_RotfishPain;
	self.th_die = A_RotfishDie;
	
	self.health = 25;
	self.deathtype = "melee";
	self.Obituary = OBIT_ROTF;

	StartMonster(self, "progs/fish.mdl");
}
