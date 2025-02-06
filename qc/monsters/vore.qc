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

$frame attack1 attack2 attack3 attack4 attack5 attack6 attack7 attack8
$frame attack9 attack10 attack11

$frame pain1 pain2 pain3 pain4 pain5

$frame death1 death2 death3 death4 death5 death6 death7

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7 walk8 walk9 walk10
$frame walk11 walk12

// Lol
void() shal_stand = [ $walk1, shal_stand ] { A_Stand(); };

void() shal_walk1 = [ $walk2, shal_walk2 ]
{
	if (random() < 0.2)
		sound(self, CHAN_VOICE, "shalrath/idle.wav", 1, ATTN_IDLE);
	A_Walk(6);
};
void() shal_walk2 = [ $walk3, shal_walk3 ] { A_Walk(4); };
void() shal_walk3 = [ $walk4, shal_walk4 ] { A_Walk(0); };
void() shal_walk4 = [ $walk5, shal_walk5 ] { A_Walk(0); };
void() shal_walk5 = [ $walk6, shal_walk6 ] { A_Walk(0); };
void() shal_walk6 = [ $walk7, shal_walk7 ] { A_Walk(0); };
void() shal_walk7 = [ $walk8, shal_walk8 ] { A_Walk(5); };
void() shal_walk8 = [ $walk9, shal_walk9 ] { A_Walk(6); };
void() shal_walk9 = [ $walk10, shal_walk10 ] { A_Walk(5); };
void() shal_walk10 = [ $walk11, shal_walk11 ] { A_Walk(0); };
void() shal_walk11 = [ $walk12, shal_walk12 ] { A_Walk(4); };
void() shal_walk12 = [ $walk1, shal_walk1 ] { A_Walk(5); };

void() shal_run1 = [ $walk2, shal_run2 ]
{
	if (random() < 0.2)
		sound(self, CHAN_VOICE, "shalrath/idle.wav", 1, ATTN_IDLE);
	A_Run(6);
};
void() shal_run2 = [ $walk3, shal_run3 ] { A_Run(4); };
void() shal_run3 = [ $walk4, shal_run4 ] { A_Run(0); };
void() shal_run4 = [ $walk5, shal_run5 ] { A_Run(0); };
void() shal_run5 = [ $walk6, shal_run6 ] { A_Run(0); };
void() shal_run6 = [ $walk7, shal_run7 ] { A_Run(0); };
void() shal_run7 = [ $walk8, shal_run8 ] { A_Run(5); };
void() shal_run8 = [ $walk9, shal_run9 ] { A_Run(6); };
void() shal_run9 = [ $walk10, shal_run10 ] { A_Run(5); };
void() shal_run10 = [ $walk11, shal_run11 ] { A_Run(0); };
void() shal_run11 = [ $walk12, shal_run12 ] { A_Run(4); };
void() shal_run12 = [ $walk1, shal_run1 ] { A_Run(5); };

void() shal_attack1 = [ $attack1, shal_attack2 ]
{
	PlaySound(self, CHAN_VOICE, "shalrath/attack.wav", 1.0, ATTN_NORM);
	A_Face();
};
void() shal_attack2 = [ $attack2, shal_attack3 ] { A_Face(); };
void() shal_attack3 = [ $attack3, shal_attack4 ] { A_Face(); };
void() shal_attack4 = [ $attack4, shal_attack5 ] { A_Face(); };
void() shal_attack5 = [ $attack5, shal_attack6 ] { A_Face(); };
void() shal_attack6 = [ $attack6, shal_attack7 ] { A_Face(); };
void() shal_attack7 = [ $attack7, shal_attack8 ] { A_Face(); };
void() shal_attack8 = [ $attack8, shal_attack9 ] { A_Face(); };
void() shal_attack9 = [ $attack9, shal_attack10 ] { A_VoreMissileAttack(); };
void() shal_attack10 = [ $attack10, shal_attack11 ] { A_Face(); };
void() shal_attack11 = [ $attack11, shal_run1 ] {};

void() shal_pain1 = [ $pain1, shal_pain2 ] {};
void() shal_pain2 = [ $pain2, shal_pain3 ] {};
void() shal_pain3 = [ $pain3, shal_pain4 ] {};
void() shal_pain4 = [ $pain4, shal_pain5 ] {};
void() shal_pain5 = [ $pain5, shal_run1 ] {};

void() shal_death1 = [ $death1, shal_death2 ] {};
void() shal_death2 = [ $death2, shal_death3 ] {};
void() shal_death3 = [ $death3, shal_death4 ] {};
void() shal_death4 = [ $death4, shal_death5 ] {};
void() shal_death5 = [ $death5, shal_death6 ] {};
void() shal_death6 = [ $death6, shal_death7 ] {};
void() shal_death7 = [ $death7, shal_death7 ] {};

bool_t A_VorePain(entity attacker, entity inflictor, int_t damage)
{
	if (!TimerExpired(self.pain_finished))
		return FALSE;

	PlaySound(self, CHAN_VOICE, "shalrath/pain.wav", 1.0, ATTN_NORM);
	
	shal_pain1();
	SetCoolDown(self, pain_finished, 3.0);
	return TRUE;
}

void A_VoreDie()
{
	if (self.health < -90)
	{
		GibMonster(self, "progs/h_shal.mdl");
		return;
	}

	PlaySound(self, CHAN_VOICE, "shalrath/death.wav", 1.0, ATTN_NORM);
	shal_death1();
	SetSolid(self, SOLID_NOT);
}

void A_VoreMissileAttack()
{
	A_Face();
	
	FixedLocalAxes(self.angles);
	
	vector orig = self.origin + v_up * 10.0;
	vector dir = GetAimDir(self.enemy, orig, [0.0, 0.0, 10.0]);

	self.effects |= EF_MUZZLEFLASH;
	PlaySound(self, CHAN_WEAPON, "shalrath/attack2.wav", 1.0, ATTN_NORM);

	entity missile = SpawnMissile(self, missile_vorerocket, orig, dir, 400.0, [300.0, 300.0, 300.0]);
	missile.enemy = self.enemy;
	
	// Add a bit of a delay based on distance to enemy, that way it can get closer
	// before locking on
	float homingDelay = MAX(Length((self.enemy.origin + [0.0, 0.0, 10.0]) - orig) * 0.002, 0.1);
	SetNextThinkTime(missile, homingDelay);
}

// Support for killing zombies in a single hit, otherwise this is the same
// thing as the standard missile touch function
void P_VoreMissileTouch()
{
	if (other.flags & FL_MUST_GIB)
		self.dmg = other.health;

	P_MissileTouch();
}

void A_VoreRocketHome()
{
	// Keep flying off for a bit
	if (!self.enemy || self.enemy.health < 1)
	{
		self.enemy = world;
		SetNextThink(self, 6.0, A_Remove);
		return;
	}
	
	vector dir = Normalize((self.enemy.origin + [0.0, 0.0, 10.0]) - self.origin);
	self.velocity = dir * (skill >= SK_NIGHTMARE ? 350.0 : 250.0);
	
	SetNextThink(self, 0.2, A_VoreRocketHome);
}

void missile_vorerocket()
{
	self.touch = P_VoreMissileTouch;
	
	self.dmg = 35 + Round(5.0 * Random());
	self.RadDmg = 40;
	self.distance = 80.0;
	self.deathtype = "magic";
	self.noise2 = "weapons/r_exp3.wav";
	self.deadflag = TE_INVALID;
	self.Obituary = OBIT_VORE;
	
	SetNextThink(self, A_VoreRocketHome, 0.2);
	
	StartMissile(self, "progs/v_spike.mdl");
}

void monster_shalrath()
{
	if (deathmatch)
	{
		RemoveEntity(self);
		return;
	}
	
	TryPrecacheModel("progs/shalrath.mdl");
	TryPrecacheModel("progs/h_shal.mdl");
	TryPrecacheModel("progs/v_spike.mdl");

	TryPrecacheSound("shalrath/attack.wav");
	TryPrecacheSound("shalrath/attack2.wav");
	TryPrecacheSound("shalrath/death.wav");
	TryPrecacheSound("shalrath/idle.wav");
	TryPrecacheSound("shalrath/pain.wav");
	TryPrecacheSound("shalrath/sight.wav");

	self.th_stand = shal_stand;
	self.th_walk = shal_walk1;
	self.th_run = shal_run1;
	self.th_missile = shal_attack1;
	self.th_pain = A_VorePain;
	self.th_die = A_VoreDie;
	
	self.health = 400;

	StartMonster(self, "progs/shalrath.mdl", TRUE);
}
