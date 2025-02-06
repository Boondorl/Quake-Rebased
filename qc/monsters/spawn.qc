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

$frame Walk1 Walk2 Walk3 Walk4  Walk5 Walk6 Walk7 Walk8 Walk9 Walk10
$frame Walk11 Walk12 Walk13 Walk14 Walk15 Walk16 Walk17 Walk18 Walk19
$frame Walk20 Walk21 Walk22 Walk23 Walk24 Walk25

$frame Run1 Run2 Run3 Run4 Run5 Run6  Run7 Run8 Run9 Run10 Run11 Run12 Run13
$frame Run14 Run15 Run16 Run17 Run18 Run19 Run20 Run21 Run22 Run23
$frame Run24 Run25

$frame Attack1 Attack2 Attack3 Attack4 Attack5 Attack6
$frame Attack7 Attack8 Attack9 Attack10

$frame Death1

void() S_SpawnIdle1 = [ $Walk1, S_SpawnIdle1 ] { A_Stand(); };

void() S_SpawnWalk1 = [ $Walk1, S_SpawnWalk2 ] { A_Walk(0.0); };
void() S_SpawnWalk2 = [ $Walk2, S_SpawnWalk3 ] { A_Walk(0.0); };
void() S_SpawnWalk3 = [ $Walk3, S_SpawnWalk4 ] { A_Walk(0.0); };
void() S_SpawnWalk4 = [ $Walk4, S_SpawnWalk5 ] { A_Walk(0.0); };
void() S_SpawnWalk5 = [ $Walk5, S_SpawnWalk6 ] { A_Walk(0.0); };
void() S_SpawnWalk6 = [ $Walk6, S_SpawnWalk7 ] { A_Walk(0.0); };
void() S_SpawnWalk7 = [ $Walk7, S_SpawnWalk8 ] { A_Walk(0.0); };
void() S_SpawnWalk8 = [ $Walk8, S_SpawnWalk9 ] { A_Walk(0.0); };
void() S_SpawnWalk9 = [ $Walk9, S_SpawnWalk10 ] { A_Walk(0.0); };
void() S_SpawnWalk10 = [ $Walk10, S_SpawnWalk11 ] { A_Walk(0.0); };
void() S_SpawnWalk11 = [ $Walk11, S_SpawnWalk12 ] { A_Walk(2.0); };
void() S_SpawnWalk12 = [ $Walk12, S_SpawnWalk13 ] { A_Walk(2.0); };
void() S_SpawnWalk13 = [ $Walk13, S_SpawnWalk14 ] { A_Walk(2.0); };
void() S_SpawnWalk14 = [ $Walk14, S_SpawnWalk15 ] { A_Walk(2.0); };
void() S_SpawnWalk15 = [ $Walk15, S_SpawnWalk16 ] { A_Walk(2.0); };
void() S_SpawnWalk16 = [ $Walk16, S_SpawnWalk17 ] { A_Walk(2.0); };
void() S_SpawnWalk17 = [ $Walk17, S_SpawnWalk18 ] { A_Walk(2.0); };
void() S_SpawnWalk18 = [ $Walk18, S_SpawnWalk19 ] { A_Walk(2.0); };
void() S_SpawnWalk19 = [ $Walk19, S_SpawnWalk20 ] { A_Walk(2.0); };
void() S_SpawnWalk20 = [ $Walk20, S_SpawnWalk21 ] { A_Walk(2.0); };
void() S_SpawnWalk21 = [ $Walk21, S_SpawnWalk22 ] { A_Walk(2.0); };
void() S_SpawnWalk22 = [ $Walk22, S_SpawnWalk23 ] { A_Walk(2.0); };
void() S_SpawnWalk23 = [ $Walk23, S_SpawnWalk24 ] { A_Walk(2.0); };
void() S_SpawnWalk24 = [ $Walk24, S_SpawnWalk25 ] { A_Walk(2.0); };
void() S_SpawnWalk25 = [ $Walk25, S_SpawnWalk1 ] { A_Walk(2.0); };

void() S_SpawnRun1 = [ $Run1, S_SpawnRun2 ] { A_Run(0.0); };
void() S_SpawnRun2 = [ $Run2, S_SpawnRun3 ] { A_Run(0.0); };
void() S_SpawnRun3 = [ $Run3, S_SpawnRun4 ] { A_Run(0.0); };
void() S_SpawnRun4 = [ $Run4, S_SpawnRun5 ] { A_Run(0.0); };
void() S_SpawnRun5 = [ $Run5, S_SpawnRun6 ] { A_Run(0.0); };
void() S_SpawnRun6 = [ $Run6, S_SpawnRun7 ] { A_Run(0.0); };
void() S_SpawnRun7 = [ $Run7, S_SpawnRun8 ] { A_Run(0.0); };
void() S_SpawnRun8 = [ $Run8, S_SpawnRun9 ] { A_Run(0.0); };
void() S_SpawnRun9 = [ $Run9, S_SpawnRun10 ] { A_Run(0.0); };
void() S_SpawnRun10 = [ $Run10, S_SpawnRun11 ] { A_Run(0.0); };
void() S_SpawnRun11 = [ $Run11, S_SpawnRun12 ] { A_Run(2.0); };
void() S_SpawnRun12 = [ $Run12, S_SpawnRun13 ] { A_Run(2.0); };
void() S_SpawnRun13 = [ $Run13, S_SpawnRun14 ] { A_Run(2.0); };
void() S_SpawnRun14 = [ $Run14, S_SpawnRun15 ] { A_Run(2.0); };
void() S_SpawnRun15 = [ $Run15, S_SpawnRun16 ] { A_Run(2.0); };
void() S_SpawnRun16 = [ $Run16, S_SpawnRun17 ] { A_Run(2.0); };
void() S_SpawnRun17 = [ $Run17, S_SpawnRun18 ] { A_Run(2.0); };
void() S_SpawnRun18 = [ $Run18, S_SpawnRun19 ] { A_Run(2.0); };
void() S_SpawnRun19 = [ $Run19, S_SpawnRun20 ] { A_Run(2.0); };
void() S_SpawnRun20 = [ $Run20, S_SpawnRun21 ] { A_Run(2.0); };
void() S_SpawnRun21 = [ $Run21, S_SpawnRun22 ] { A_Run(2.0); };
void() S_SpawnRun22 = [ $Run22, S_SpawnRun23 ] { A_Run(2.0); };
void() S_SpawnRun23 = [ $Run23, S_SpawnRun24 ] { A_Run(2.0); };
void() S_SpawnRun24 = [ $Run24, S_SpawnRun25 ] { A_Run(2.0); };
void() S_SpawnRun25 = [ $Run25, S_SpawnRun1 ] { A_Run(2.0); };

void() S_SpawnAttack1 = [ $Attack1, S_SpawnAttack2 ] { A_Face(); };
void() S_SpawnAttack2 = [ $Attack2, S_SpawnAttack3 ] { A_Face(); };
void() S_SpawnAttack3 = [ $Attack3, S_SpawnAttack4 ] { A_Face(); };
void() S_SpawnAttack4 = [ $Attack4, S_SpawnAttack5 ] { A_Face(); };
void() S_SpawnAttack5 = [ $Attack5, S_SpawnAttack6 ]
{
	A_Face();
	
	FixedLocalAxes(self.angles);
	
	self.touch = P_SpawnTouch;
	self.flags &= ~FL_ONGROUND;
	self.velocity = v_forward * 600.0 + [0.0, 0.0, 200.0 + 150.0 * Random()];
	SetMoveType(self, MOVETYPE_BOUNCE);
	SetOrigin(self, self.origin + [0.0, 0.0, 1.0]);
	SetCoolDown(self, timer_finished, 1.5);
}
void() S_SpawnAttack6 = [ $Attack6, S_SpawnAttack1 ] {};
void() S_SpawnAttack7 = [ $Attack7, S_SpawnAttack2 ] {};
void() S_SpawnAttack8 = [ $Attack8, S_SpawnAttack3 ] {};
void() S_SpawnAttack9 = [ $Attack9, S_SpawnAttack4 ] {};
void() S_SpawnAttack10 = [ $Attack10, S_SpawnAttack7 ]
{
	if (TimerExpired(self.timer_finished))
		S_SpawnAttack5();
};

void() S_SpawnDeath1 = [ $Death1, S_SpawnDeath2 ] { self.takedamage = DAMAGE_NO; };
void() S_SpawnDeath2 = [ $Death1, A_Remove ]
{
	RadiusAttack(self, self, 120, 60, 160.0, self);
	
	PlaySound(self, CHAN_BODY, "blob/death1.wav", 1.0, ATTN_NORM);
	
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_TAREXPLOSION);
	WriteCoord(MSG_BROADCAST, self.origin.x);
	WriteCoord(MSG_BROADCAST, self.origin.y);
	WriteCoord(MSG_BROADCAST, self.origin.z);
	
	SetModel(self, "");
	S_Explosion1();
};

void P_SpawnTouch()
{
	if (other.takedamage != DAMAGE_NO
		&& ((self.flags & FL_INFIGHT_CLASS) || other.classname != self.classname)
		&& Length(self.velocity) > 400.0)
	{
		DamageEntity(other, self, self, 10 + Round(10 * Random()));
		PlaySound(self, CHAN_WEAPON, "blob/hit1.wav", 1.0, ATTN_NORM);
	}
	else
	{
		PlaySound(self, CHAN_WEAPON, "blob/land1.wav", 1.0, ATTN_NORM);
	}

	self.touch = __NULL__;
	S_SpawnAttack1();
}

void monster_tarbaby()
{
	if (!CanSpawn(self))
		return;
	
	if (CanPrecache())
	{
		PrecacheSound("blob/sight1.wav");
		PrecacheSound("blob/hit1.wav");
		PrecacheSound("blob/land1.wav");
		PrecacheSound("blob/death1.wav");
	}
	
	self.th_stand = S_SpawnIdle1;
	self.th_walk = S_SpawnWalk1;
	self.th_run = S_SpawnRun1;
	self.th_melee = S_SpawnAttack1;
	self.th_missile = S_SpawnAttack1;
	self.th_die = S_SpawnDeath1;
	
	self.health = 80;

	StartMonster(self, "progs/tarbaby.mdl");
}
