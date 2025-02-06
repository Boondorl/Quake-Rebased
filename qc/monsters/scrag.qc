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

$frame hover1 hover2 hover3 hover4 hover5 hover6 hover7 hover8
$frame hover9 hover10 hover11 hover12 hover13 hover14 hover15

$frame fly1 fly2 fly3 fly4 fly5 fly6 fly7 fly8 fly9 fly10
$frame fly11 fly12 fly13 fly14

$frame magatt1 magatt2 magatt3 magatt4 magatt5 magatt6 magatt7
$frame magatt8 magatt9 magatt10 magatt11 magatt12 magatt13

$frame pain1 pain2 pain3 pain4

$frame death1 death2 death3 death4 death5 death6 death7 death8

// Strafing stuff was moved out of here since it makes way more
// sense to put that in a running function
bool_t CheckScragAttack()
{
	if (!TimerExpired(self.attack_finished))
		return FALSE;
	
	float range = GetRange(self, self.enemy);
	if (range > RANGE_FAR || !IsVisible(self, self.enemy, VIS_CHECK_MONSTERS))
		return FALSE;

	float chance = 0.2;
	if (enemy_range <= RANGE_MELEE)
		chance = 0.9;
	else if (enemy_range <= RANGE_NEAR)
		chance = 0.6;

	if (Random() < chance)
	{
		if (skill < SK_NIGHTMARE)
			SetCoolDown(self, attack_finished, 2.0);
		
		self.attack_state = AS_MISSILE;
		return TRUE;
	}

	return FALSE;
}

void missile_scragmagic()
{
	self.dmg = 9;
	self.damage_type = "magic";
	self.misc_action = TE_WIZSPIKE;
	self.obituary = OBIT_SCRAG;
	
	StartMissile(self, "progs/w_spike.mdl");
}

void A_ScragAttack(vector offset, float sideOfs)
{
	A_Face();
	
	FixedLocalAxes(self.angles);
	
	self.effects |= EF_MUZZLEFLASH;
	
	vector orig = self.origin + v_forward * offset.x + v_right * offset.y + v_up * offset.z;
	vector dir = GetAimDir(self.enemy, orig, v_right * sideOfs);
	
	SpawnMissile(self, missile_scragmagic, orig, dir, 600.0, VEC_ZERO, 6.0);
}

void A_ScragRun(float dist)
{
	if (self.enemy && self.attack_state == AS_STRAIGHT
		&& GetRange(self, self.enemy) <= RANGE_NEAR)
	{
		self.attack_state = AS_SLIDE;
		S_ScragStrafe1();
		return;
	}
	
	A_Run(dist);
}

void A_ScragStrafe(float dist)
{
	if (self.enemy && self.attack_state == AS_SLIDE
		&& GetRange(self, self.enemy) > RANGE_NEAR)
	{
		self.attack_state = AS_STRAIGHT;
		S_ScragRun1();
		return;
	}
	
	A_Run(dist);
}

void A_PlayScragIdleSound()
{
	if (!TimerExpired(self.timer_finished))
		return;
	
	SetCoolDown(self, timer_finished, 2.0);
	
	float r = Random();
	if (r > 0.9)
		PlaySound(self, CHAN_VOICE, "wizard/widle1.wav", 1.0, ATTN_IDLE);
	else if (r < 0.3)
		PlaySound(self, CHAN_VOICE, "wizard/widle2.wav", 1.0, ATTN_IDLE);
}

void() S_ScragStand1 = [ $hover1, S_ScragStand2 ] { A_Stand(); };
void() S_ScragStand2 = [ $hover2, S_ScragStand3 ] { A_Stand(); };
void() S_ScragStand3 = [ $hover3, S_ScragStand4 ] { A_Stand(); };
void() S_ScragStand4 = [ $hover4, S_ScragStand5 ] { A_Stand(); };
void() S_ScragStand5 = [ $hover5, S_ScragStand6 ] { A_Stand(); };
void() S_ScragStand6 = [ $hover6, S_ScragStand7 ] { A_Stand(); };
void() S_ScragStand7 = [ $hover7, S_ScragStand8 ] { A_Stand(); };
void() S_ScragStand8 = [ $hover8, S_ScragStand1 ] { A_Stand(); };

void() S_ScragWalk1 = [ $hover1, S_ScragWalk2 ]
{
	A_Walk(8);
	Wiz_idlesound();
};
void() S_ScragWalk2 = [ $hover2, S_ScragWalk3 ] { A_Walk(8); };
void() S_ScragWalk3 = [ $hover3, S_ScragWalk4 ] { A_Walk(8); };
void() S_ScragWalk4 = [ $hover4, S_ScragWalk5 ] { A_Walk(8); };
void() S_ScragWalk5 = [ $hover5, S_ScragWalk6 ] { A_Walk(8); };
void() S_ScragWalk6 = [ $hover6, S_ScragWalk7 ] { A_Walk(8); };
void() S_ScragWalk7 = [ $hover7, S_ScragWalk8 ] { A_Walk(8); };
void() S_ScragWalk8 = [ $hover8, S_ScragWalk1 ] { A_Walk(8); };

void() S_ScragStrafe1 = [ $hover1, S_ScragStrafe2 ]
{
	PlayScragIdleSound();
	A_ScragStrafe(8.0);
};
void() S_ScragStrafe2 = [ $hover2, S_ScragStrafe3 ] { A_ScragStrafe(8); };
void() S_ScragStrafe3 = [ $hover3, S_ScragStrafe4 ] { A_ScragStrafe(8); };
void() S_ScragStrafe4 = [ $hover4, S_ScragStrafe5 ] { A_ScragStrafe(8); };
void() S_ScragStrafe5 = [ $hover5, S_ScragStrafe6 ] { A_ScragStrafe(8); };
void() S_ScragStrafe6 = [ $hover6, S_ScragStrafe7 ] { A_ScragStrafe(8); };
void() S_ScragStrafe7 = [ $hover7, S_ScragStrafe8 ] { A_ScragStrafe(8); };
void() S_ScragStrafe8 = [ $hover8, S_ScragStrafe1 ] { A_ScragStrafe(8); };

void() S_ScragRun1 = [ $fly1, S_ScragRun2 ] { A_ScragRun(16); };
void() S_ScragRun2 = [ $fly2, S_ScragRun3 ] { A_ScragRun(16); };
void() S_ScragRun3 = [ $fly3, S_ScragRun4 ] { A_ScragRun(16); };
void() S_ScragRun4 = [ $fly4, S_ScragRun5 ] { A_ScragRun(16); };
void() S_ScragRun5 = [ $fly5, S_ScragRun6 ] { A_ScragRun(16); };
void() S_ScragRun6 = [ $fly6, S_ScragRun7 ] { A_ScragRun(16); };
void() S_ScragRun7 = [ $fly7, S_ScragRun8 ] { A_ScragRun(16); };
void() S_ScragRun8 = [ $fly8, S_ScragRun9 ] { A_ScragRun(16); };
void() S_ScragRun9 = [ $fly9, S_ScragRun10 ] { A_ScragRun(16); };
void() S_ScragRun10 = [ $fly10, S_ScragRun11 ] { A_ScragRun(16); };
void() S_ScragRun11 = [ $fly11, S_ScragRun12 ] { A_ScragRun(16); };
void() S_ScragRun12 = [ $fly12, S_ScragRun13 ] { A_ScragRun(16); };
void() S_ScragRun13 = [ $fly13, S_ScragRun14 ] { A_ScragRun(16); };
void() S_ScragRun14 = [ $fly14, S_ScragRun1 ] { A_ScragRun(16); };

void() S_ScragAttack1 = [ $magatt1, S_ScragAttack2 ]
{
	A_Face();
	PlaySound(self, CHAN_WEAPON, "wizard/wattack.wav", 1.0, ATTN_NORM);
};
void() S_ScragAttack2 = [ $magatt2, S_ScragAttack3 ] { A_Face(); };
void() S_ScragAttack3 = [ $magatt3, S_ScragAttack4 ] { A_Face(); };
void() S_ScragAttack4 = [ $magatt4, S_ScragAttack5 ] { A_ScragAttack([14.0, 14.0, 30.0], 13.0); };
void() S_ScragAttack5 = [ $magatt5, S_ScragAttack6 ] { A_Face(); };
void() S_ScragAttack6 = [ $magatt6, S_ScragAttack7 ] { A_Face(); };
void() S_ScragAttack7 = [ $magatt5, S_ScragAttack8 ] { A_Face(); };
void() S_ScragAttack8 = [ $magatt4, S_ScragAttack9 ] { A_Face(); };
void() S_ScragAttack9 = [ $magatt3, S_ScragAttack10 ] { A_ScragAttack([14.0, -14.0, 30.0], -13.0); };
void() S_ScragAttack10 = [ $magatt2, S_ScragRun1 ] { A_Face(); };

void() S_ScragPain1 = [ $pain1, S_ScragPain2 ] {};
void() S_ScragPain2 = [ $pain2, S_ScragPain3 ] {};
void() S_ScragPain3 = [ $pain3, S_ScragPain4 ] {};
void() S_ScragPain4 = [ $pain4, S_ScragRun1 ] {};

void() S_ScragDeath1 = [ $death1, S_ScragDeath2 ] {};
void() S_ScragDeath2 = [ $death2, S_ScragDeath3 ] {};
void() S_ScragDeath3 = [ $death3, S_ScragDeath4 ] { SetSolid(self, SOLID_NOT); };
void() S_ScragDeath4 = [ $death4, S_ScragDeath5 ] {};
void() S_ScragDeath5 = [ $death5, S_ScragDeath6 ] {};
void() S_ScragDeath6 = [ $death6, S_ScragDeath7 ] {};
void() S_ScragDeath7 = [ $death7, S_ScragDeath8 ] {};
void() S_ScragDeath8 = [ $death8, S_ScragDeath8 ] {};

void A_ScragDie()
{
	if (self.health < -40)
	{
		GibEntity(self, "progs/h_wizard.mdl");
		return;
	}
	
	self.velocity = [200.0 * CRandom(), 200.0 * CRandom(), 100.0 + 100.0 * Random()];
	self.flags &= ~FL_ONGROUND;
	PlaySound(self, CHAN_VOICE, "wizard/wdeath.wav", 1.0, ATTN_NORM);

	S_ScragDeath1();
}

bool_t A_ScragPain(entity attacker, entity inflictor, int_t damage)
{
	if (!TimerExpired(self.pain_finished) || Round(70 * Random()) > damage)
		return FALSE;

	PlaySound(self, CHAN_VOICE, "wizard/wpain.wav", 1.0, ATTN_NORM);
	S_ScragPain1();
	
	// The original Scrag didn't have a pain cool down, but this is mainly just
	// to prevent the Nailgun from having weird interactions with it
	SetCoolDown(self, pain_finished, 0.4);
	return TRUE;
}

void monster_wizard()
{
	if (!CanSpawn(self))
		return;
	
	if (CanPrecache())
	{
		PrecacheSound("wizard/widle1.wav");
		PrecacheSound("wizard/widle2.wav");
		PrecacheSound("wizard/wsight.wav");
		PrecacheSound("wizard/wattack.wav");
		PrecacheSound("wizard/wpain.wav");
		PrecacheSound("wizard/wdeath.wav");
	}

	self.th_stand = S_ScragStand1;
	self.th_walk = S_ScragWalk1;
	self.th_run = S_ScragRun1;
	self.th_missile = S_ScragAttack1;
	self.th_pain = A_ScragPain;
	self.th_die = A_ScragDie;
	self.th_atkcheck = A_CheckScragAttack;
	
	self.health = 80;
	self.flags |= FL_FLY;

	StartMonster(self, "progs/wizard.mdl", "progs/h_wizard.mdl");
}
