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

$frame Spawn1 Spawn2 Spawn3 Spawn4 Spawn5 Spawn6 Spawn7 Spawn8 Spawn9 Spawn10
$frame Spawn11 Spawn12 Spawn13 Spawn14 Spawn15 Spawn16 Spawn17

$frame Idle1 Idle2 Idle3 Idle4 Idle5 Idle6 Idle7 Idle8
$frame Idle9 Idle10 Idle11 Idle12 Idle13 Idle14 Idle15
$frame Idle16 Idle17 Idle18 Idle19 Idle20 Idle21 Idle22
$frame Idle23 Idle24 Idle25 Idle26 Idle27 Idle28 Idle29 Idle30 Idle31

$frame Death1 Death2 Death3 Death4 Death5 Death6 Death7 Death8 Death9

$frame Missile1 Missile2 Missile3 Missile4 Missile5 Missile6 Missile7 Missile8
$frame Missile9 Missile10 Missile11 Missile12 Missile13 Missile14 Missile15
$frame Missile16 Missile17 Missile18 Missile19 Missile20 Missile21 Missile22
$frame Missile23

$frame PainA1 PainA2 PainA3 PainA4 PainA5 PainA6 PainA7 PainA8
$frame PainA9 PainA10

$frame PainB1 PainB2 PainB3 PainB4 PainB5 PainB6

$frame PainC1 PainC2 PainC3 PainC4 PainC5 PainC6 PainC7 PainC8
$frame PainC9 PainC10

/*
==============================================================================

CHTHON

==============================================================================
*/

/*
============
States
============
*/

void() S_ChthonSpawn1		= [ $Spawn1,	S_ChthonSpawn2		] { PlaySound(self, CHAN_BODY, "boss1/out1.wav", 1.0, ATTN_NORM);		};
void() S_ChthonSpawn2		= [ $Spawn2, 	S_ChthonSpawn3		] { PlaySound(self, CHAN_VOICE, "boss1/sight1.wav", 1.0, ATTN_NORM);	};
void() S_ChthonSpawn3		= [ $Spawn3, 	S_ChthonSpawn4		] {};
void() S_ChthonSpawn4		= [ $Spawn4, 	S_ChthonSpawn5		] {};
void() S_ChthonSpawn5		= [ $Spawn5, 	S_ChthonSpawn6		] {};
void() S_ChthonSpawn6		= [ $Spawn6, 	S_ChthonSpawn7		] {};
void() S_ChthonSpawn7		= [ $Spawn7, 	S_ChthonSpawn8		] {};
void() S_ChthonSpawn8		= [ $Spawn8, 	S_ChthonSpawn9		] {};
void() S_ChthonSpawn9		= [ $Spawn9, 	S_ChthonSpawn10		] {};
void() S_ChthonSpawn10		= [ $Spawn10,	S_ChthonSpawn11		] {};
void() S_ChthonSpawn11		= [ $Spawn11,	S_ChthonSpawn12		] {};
void() S_ChthonSpawn12		= [ $Spawn12,	S_ChthonSpawn13		] {};
void() S_ChthonSpawn13		= [ $Spawn13,	S_ChthonSpawn14		] {};
void() S_ChthonSpawn14		= [ $Spawn14,	S_ChthonSpawn15		] {};
void() S_ChthonSpawn15		= [ $Spawn15,	S_ChthonSpawn16		] {};
void() S_ChthonSpawn16		= [ $Spawn16,	S_ChthonSpawn17		] {};
void() S_ChthonSpawn17		= [ $Spawn17,	S_ChthonMissile1	] {};

void() S_ChthonIdle1		= [ $Idle1,		S_ChthonIdle2		] { A_ChthonFace(); };
void() S_ChthonIdle2		= [ $Idle2,		S_ChthonIdle3		] { A_ChthonFace(); };
void() S_ChthonIdle3		= [ $Idle3,		S_ChthonIdle4		] { A_ChthonFace(); };
void() S_ChthonIdle4		= [ $Idle4,		S_ChthonIdle5		] { A_ChthonFace(); };
void() S_ChthonIdle5		= [ $Idle5,		S_ChthonIdle6		] { A_ChthonFace(); };
void() S_ChthonIdle6		= [ $Idle6,		S_ChthonIdle7		] { A_ChthonFace(); };
void() S_ChthonIdle7		= [ $Idle7,		S_ChthonIdle8		] { A_ChthonFace(); };
void() S_ChthonIdle8		= [ $Idle8,		S_ChthonIdle9		] { A_ChthonFace(); };
void() S_ChthonIdle9		= [ $Idle9,		S_ChthonIdle10		] { A_ChthonFace(); };
void() S_ChthonIdle10		= [ $Idle10,	S_ChthonIdle11		] { A_ChthonFace(); };
void() S_ChthonIdle11		= [ $Idle11,	S_ChthonIdle12		] { A_ChthonFace(); };
void() S_ChthonIdle12		= [ $Idle12,	S_ChthonIdle13		] { A_ChthonFace(); };
void() S_ChthonIdle13		= [ $Idle13,	S_ChthonIdle14		] { A_ChthonFace(); };
void() S_ChthonIdle14		= [ $Idle14,	S_ChthonIdle15		] { A_ChthonFace(); };
void() S_ChthonIdle15		= [ $Idle15,	S_ChthonIdle16		] { A_ChthonFace(); };
void() S_ChthonIdle16		= [ $Idle16,	S_ChthonIdle17		] { A_ChthonFace(); };
void() S_ChthonIdle17		= [ $Idle17,	S_ChthonIdle18		] { A_ChthonFace(); };
void() S_ChthonIdle18		= [ $Idle18,	S_ChthonIdle19		] { A_ChthonFace(); };
void() S_ChthonIdle19		= [ $Idle19,	S_ChthonIdle20		] { A_ChthonFace(); };
void() S_ChthonIdle20		= [ $Idle20,	S_ChthonIdle21		] { A_ChthonFace(); };
void() S_ChthonIdle21		= [ $Idle21,	S_ChthonIdle22		] { A_ChthonFace(); };
void() S_ChthonIdle22		= [ $Idle22,	S_ChthonIdle23		] { A_ChthonFace(); };
void() S_ChthonIdle23		= [ $Idle23,	S_ChthonIdle24		] { A_ChthonFace(); };
void() S_ChthonIdle24		= [ $Idle24,	S_ChthonIdle25		] { A_ChthonFace(); };
void() S_ChthonIdle25		= [ $Idle25,	S_ChthonIdle26		] { A_ChthonFace(); };
void() S_ChthonIdle26		= [ $Idle26,	S_ChthonIdle27		] { A_ChthonFace(); };
void() S_ChthonIdle27		= [ $Idle27,	S_ChthonIdle28		] { A_ChthonFace(); };
void() S_ChthonIdle28		= [ $Idle28,	S_ChthonIdle29		] { A_ChthonFace(); };
void() S_ChthonIdle29		= [ $Idle29,	S_ChthonIdle30		] { A_ChthonFace(); };
void() S_ChthonIdle30		= [ $Idle30,	S_ChthonIdle31		] { A_ChthonFace(); };
void() S_ChthonIdle31		= [ $Idle31,	S_ChthonIdle1		] { A_ChthonFace(); };

void() S_ChthonMissile1		= [ $Missile1,	S_ChthonMissile2	] { A_ChthonFace();									};
void() S_ChthonMissile2		= [ $Missile2,	S_ChthonMissile3	] { A_ChthonFace();									};
void() S_ChthonMissile3		= [ $Missile3,	S_ChthonMissile4	] { A_ChthonFace();									};
void() S_ChthonMissile4		= [ $Missile4,	S_ChthonMissile5	] { A_ChthonFace();									};
void() S_ChthonMissile5		= [ $Missile5,	S_ChthonMissile6	] { A_ChthonFace();									};
void() S_ChthonMissile6		= [ $Missile6,	S_ChthonMissile7	] { A_ChthonFace();									};
void() S_ChthonMissile7		= [ $Missile7,	S_ChthonMissile8	] { A_ChthonFace();									};
void() S_ChthonMissile8		= [ $Missile8,	S_ChthonMissile9	] { A_ChthonFace();									};
void() S_ChthonMissile9		= [ $Missile9,	S_ChthonMissile10	] { A_ChthonMissileAttack([100.0, 100.0, 200.0]);	};
void() S_ChthonMissile10	= [ $Missile10,	S_ChthonMissile11	] { A_ChthonFace();									};
void() S_ChthonMissile11	= [ $Missile11,	S_ChthonMissile12	] { A_ChthonFace();									};
void() S_ChthonMissile12	= [ $Missile12,	S_ChthonMissile13	] { A_ChthonFace();									};
void() S_ChthonMissile13	= [ $Missile13,	S_ChthonMissile14	] { A_ChthonFace();									};
void() S_ChthonMissile14	= [ $Missile14,	S_ChthonMissile15	] { A_ChthonFace();									};
void() S_ChthonMissile15	= [ $Missile15,	S_ChthonMissile16	] { A_ChthonFace();									};
void() S_ChthonMissile16	= [ $Missile16,	S_ChthonMissile17	] { A_ChthonFace();									};
void() S_ChthonMissile17	= [ $Missile17,	S_ChthonMissile18	] { A_ChthonFace();									};
void() S_ChthonMissile18	= [ $Missile18,	S_ChthonMissile19	] { A_ChthonFace();									};
void() S_ChthonMissile19	= [ $Missile19,	S_ChthonMissile20	] { A_ChthonFace();									};
void() S_ChthonMissile20	= [ $Missile20,	S_ChthonMissile21	] { A_ChthonMissileAttack([100.0, -100.0, 200.0]);	};
void() S_ChthonMissile21	= [ $Missile21,	S_ChthonMissile22	] { A_ChthonFace();									};
void() S_ChthonMissile22	= [ $Missile22,	S_ChthonMissile23	] { A_ChthonFace();									};
void() S_ChthonMissile23	= [ $Missile23,	S_ChthonMissile1	] { A_ChthonFace();									};

void() S_ChthonPainA1		= [ $PainA1,	S_ChthonPainA2		] {};
void() S_ChthonPainA2		= [ $PainA2,	S_ChthonPainA3		] {};
void() S_ChthonPainA3		= [ $PainA3,	S_ChthonPainA4		] {};
void() S_ChthonPainA4		= [ $PainA4,	S_ChthonPainA5		] {};
void() S_ChthonPainA5		= [ $PainA5,	S_ChthonPainA6		] {};
void() S_ChthonPainA6		= [ $PainA6,	S_ChthonPainA7		] {};
void() S_ChthonPainA7		= [ $PainA7,	S_ChthonPainA8		] {};
void() S_ChthonPainA8		= [ $PainA8,	S_ChthonPainA9		] {};
void() S_ChthonPainA9		= [ $PainA9,	S_ChthonPainA10		] {};
void() S_ChthonPainA10		= [ $PainA10,	S_ChthonMissile1	] {};

void() S_ChthonPainB1		= [ $PainB1,	S_ChthonPainB2		] {};
void() S_ChthonPainB2		= [ $PainB2,	S_ChthonPainB3		] {};
void() S_ChthonPainB3		= [ $PainB3,	S_ChthonPainB4		] {};
void() S_ChthonPainB4		= [ $PainB4,	S_ChthonPainB5		] {};
void() S_ChthonPainB5		= [ $PainB5,	S_ChthonPainB6		] {};
void() S_ChthonPainB6		= [ $PainB6,	S_ChthonPainB7		] {};
void() S_ChthonPainB7		= [ $PainB1,	S_ChthonPainB8		] {};
void() S_ChthonPainB8		= [ $PainB2,	S_ChthonPainB9		] {};
void() S_ChthonPainB9		= [ $PainB3,	S_ChthonPainB10		] {};
void() S_ChthonPainB10		= [ $PainB4,	S_ChthonMissile1	] {};

void() S_ChthonPainC1		= [ $PainC1,	S_ChthonPainC2		] {};
void() S_ChthonPainC2		= [ $PainC2,	S_ChthonPainC3		] {};
void() S_ChthonPainC3		= [ $PainC3,	S_ChthonPainC4		] {};
void() S_ChthonPainC4		= [ $PainC4,	S_ChthonPainC5		] {};
void() S_ChthonPainC5		= [ $PainC5,	S_ChthonPainC6		] {};
void() S_ChthonPainC6		= [ $PainC6,	S_ChthonPainC7		] {};
void() S_ChthonPainC7		= [ $PainC7,	S_ChthonPainC8		] {};
void() S_ChthonPainC8		= [ $PainC8,	S_ChthonPainC9		] {};
void() S_ChthonPainC9		= [ $PainC9,	S_ChthonPainC10		] {};
void() S_ChthonPainC10		= [ $PainC10,	S_ChthonMissile1	]
{
	// If in the boss fight, die instead after this animation
	if (self.flags & FL_BOSS)
		self.think = S_ChthonDeath1;
};

void() S_ChthonDeath1		= [ $Death1,	S_ChthonDeath2		] { PlaySound(self, CHAN_VOICE, "boss1/death.wav", 1.0, ATTN_NORM); };
void() S_ChthonDeath2		= [ $Death2,	S_ChthonDeath3		] {};
void() S_ChthonDeath3		= [ $Death3,	S_ChthonDeath4		] {};
void() S_ChthonDeath4		= [ $Death4,	S_ChthonDeath5		] {};
void() S_ChthonDeath5		= [ $Death5,	S_ChthonDeath6		] {};
void() S_ChthonDeath6		= [ $Death6,	S_ChthonDeath7		] {};
void() S_ChthonDeath7		= [ $Death7,	S_ChthonDeath8		] {};
void() S_ChthonDeath8		= [ $Death8,	S_ChthonDeath9		] {};
void() S_ChthonDeath9		= [ $Death9,	S_ChthonDeath10		]
{
	PlaySound(self, CHAN_BODY, "boss1/out1.wav", 1.0, ATTN_NORM);
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_LAVASPLASH);
	WriteCoord(MSG_BROADCAST, self.origin.x);
	WriteCoord(MSG_BROADCAST, self.origin.y);
	WriteCoord(MSG_BROADCAST, self.origin.z);
};
void() S_ChthonDeath10		= [ $Death9,	S_ChthonDeath10		]
{
	// This gets intentionally skipped in the boss fight until now
	if (self.flags & FL_BOSS)
		ActivateEntity(self, world);
	
	DestroyEntity(self);
};

/*
============
Actions
============
*/

void A_ChthonFace()
{
	// Go for another player if multiplayer
	if (!IsValidEnemy(self.enemy) || Random() < 0.02)
	{
		self.enemy = NextEntity(self.enemy);
		if (!IsClient(self.enemy))
			self.enemy = NextEntity(world);
	}
	
	A_Face();
}

void A_ChthonMissileAttack(vector offset)
{
	A_ChthonFace();
	if (!IsValidEnemy(self.enemy))
	{
		S_ChthonIdle1();
		return;
	}
	
	FixedLocalAxes(self.angles);

	vector orig = self.origin + v_forward * offset.x + v_right * offset.y + v_up * offset.z;

	// Lead the player on hard mode if in boss mode
	float speed = 300.0;
	vector dest = self.enemy.origin;
	if ((self.flags & FL_BOSS) && skill >= SK_HARD)
		dest += [self.enemy.velocity.x, self.enemy.velocity.y, 0.0] * (Length(dest - orig) / speed);

	PlaySound(self, CHAN_WEAPON, "boss1/throw.wav", 1.0, ATTN_NORM);
	SpawnMissile(self, missile_chthonrocket, orig, Normalize(dest - orig), speed, [200.0, 100.0, 300.0], 0.0);
}

void A_ChthonAwaken()
{
	SetPhysics(self, SOLID_SLIDEBOX, MOVETYPE_STEP);
	InitializeEntity(self, "progs/boss.mdl", [-128.0, -128.0, -24.0], [128.0, 128.0, 256.0]);

	// Make sure it can't rewake back up again
	self.use = A_MonsterUse;
	self.enemy = self.aiment;

	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_LAVASPLASH);
	WriteCoord(MSG_BROADCAST, self.origin.x);
	WriteCoord(MSG_BROADCAST, self.origin.y);
	WriteCoord(MSG_BROADCAST, self.origin.z);
	
	S_ChthonSpawn1();
}

/*
============
Entities
============
*/

void missile_chthonrocket()
{
	self.touch = P_MissileTouch;
	self.dmg = 100 + RandomI(20);
	self.rad_dmg = 120;
	self.distance = 160.0;
	self.damage_type = "explosive";
	self.deadflag = TE_INVALID;
	self.Obituary = OBIT_CHTHON;
	
	StartMissile(self, "progs/lavaball.mdl");
}

void monster_boss()
{
	if (!CanSpawn(self))
		return;
	
	PrecacheModel("progs/boss.mdl");
	PrecacheEntity(missile_chthonrocket);

	PrecacheSound("boss1/out1.wav");
	PrecacheSound("boss1/sight1.wav");
	PrecacheSound("boss1/throw.wav");
	PrecacheSound("boss1/pain.wav");
	PrecacheSound("boss1/death.wav");
	
	self.use = A_ChthonAwaken;
	self.th_die = S_ChthonDeath1;
	
	// Don't use the standard start function since Chthon has a completely different set of
	// properties from standard monsters
	self.yaw_speed = 20.0;
	self.flags |= FL_MONSTER | FL_COUNTMONSTER | FL_AVOID | FL_IGNORE_INFIGHT;
	// Allow shooting him like normal, too!
	if (self.health < 1)
	{
		self.health = skill < SK_NORMAL ? 1 : 3;
		self.flags |= FL_BOSS;
		self.takedamage = DAMAGE_NO;
	}
	else
	{
		self.takedamage = DAMAGE_AIM;
	}
	
	++total_monsters;
}

/*
==============================================================================

CHTHON LIGHTNING

==============================================================================
*/

/*
============
Actions
============
*/

void A_ChthonLightning()
{
	// If in the middle of spawning lightning, avoid reactivating entirely
	if (!TimerExpired(self.nextthink))
		return;
	
	entity targ1 = FindEntity(world, target, self.target3);
	entity targ2 = FindEntity(targ1, target, self.target3);
	if (!targ1 || !targ2)
	{
		DebugPrint("Missing lightning targets\n");
		return;
	}
	
	// Check if we're in the middle of zapping Chthon
	if (!TimerExpired(self.attack_finished))
	{
		vector pos1 = GetCenter(targ1);
		pos1.z = targ1.absmin.z - 16.0;

		vector pos2 = GetCenter(targ2);
		pos2.z = targ2.absmin.z - 16.0;

		// Compensate for length of bolt
		pos2 -= Normalize(pos2 - pos1) * 100.0;

		WriteByte(MSG_ALL, SVC_TEMPENTITY);
		WriteByte(MSG_ALL, TE_LIGHTNING3);
		WriteEntity(MSG_ALL, self);
		WriteCoord(MSG_ALL, pos1.x);
		WriteCoord(MSG_ALL, pos1.y);
		WriteCoord(MSG_ALL, pos1.z);
		WriteCoord(MSG_ALL, pos2.x);
		WriteCoord(MSG_ALL, pos2.y);
		WriteCoord(MSG_ALL, pos2.z);
		
		SetThink(self, 0.1, A_ChthonLightning);
		return;
	}
	else if (self.attack_finished > 0.0)
	{
		// Done here, put the terminals back up
		self.attack_finished = 0.0;
		InvokeAsSelf(targ1, F_DeactivateDoor);
		InvokeAsSelf(targ2, F_DeactivateDoor);
		return;
	}
	else if (targ1.state != FUNC_ACTIVATED || targ2.state != FUNC_ACTIVATED)
	{
		return;
	}

	// Don't let the terminals go back up until the bolt is done
	ClearThink(targ1);
	ClearThink(targ2);
	SetCoolDown(self, attack_finished, 1.0);
	PlaySound(self, CHAN_VOICE, "misc/power.wav", 1.0, ATTN_NORM);

	// Advance the boss pain
	entity boss = self.goalentity ? self.goalentity : FindEntity(world, classname, "monster_boss");
	if (!boss)
		return;
	
	boss.enemy = self.aiment;
	PlaySound(boss, CHAN_VOICE, "boss1/pain.wav", 1.0, ATTN_NORM);
	// Only use the standard mechanics if it's the real boss fight
	if (boss.flags & FL_BOSS)
	{
		--boss.health;
		if (boss.health >= 2)
			SetState(boss, S_ChthonPainA1);
		else if (boss.health >= 1)
			SetState(boss, S_ChthonPainB1);
		else
			SetState(boss, S_ChthonPainC1);
	}
	else
	{
		float r = Random();
		if (r < 0.33)
			SetState(boss, S_ChthonPainA1);
		else if (r < 0.66)
			SetState(boss, S_ChthonPainB1);
		else
			SetState(boss, S_ChthonPainC1);
	}
	
	// Spawn the lightning effect immediately
	A_ChthonLightning();
}

/*
============
Entities
============
*/

void event_lightning()
{
	if (!self.target3)
		self.target3 = "lightning";
	
	self.use = A_ChthonLightning;
	
	// Allow setting a custom boss in case someone wants multiple for...some reason
	if (self.target2)
		self.goalentity = FindEntity(world, targetname, self.target2);
}
