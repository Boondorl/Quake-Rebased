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

/*
==============================================================================

OLD ONE

==============================================================================
*/

$frame Idle1 Idle2 Idle3 Idle4 Idle5 Idle6 Idle7 Idle8 Idle9
$frame Idle10 Idle11 Idle12 Idle13 Idle14 Idle15 Idle16 Idle17 Idle18 Idle19
$frame Idle20 Idle21 Idle22 Idle23 Idle24 Idle25 Idle26 Idle27 Idle28 Idle29
$frame Idle30 Idle31 Idle32 Idle33 Idle34 Idle35 Idle36 Idle37 Idle38 Idle39
$frame Idle40 Idle41 Idle42 Idle43 Idle44 Idle45 Idle46

$frame Death1 Death2 Death3 Death4 Death5 Death6 Death7 Death8
$frame Death9 Death10 Death11 Death12 Death12_2 Death13 Death14
$frame Death15 Death16 Death17 Death18 Death19 Death20

void() S_ShubIdle1 = [ $Idle1,  S_ShubIdle2 ] {};
void() S_ShubIdle2 = [ $Idle2,  S_ShubIdle3 ] {};
void() S_ShubIdle3 = [ $Idle3,  S_ShubIdle4 ] {};
void() S_ShubIdle4 = [ $Idle4,  S_ShubIdle5 ] {};
void() S_ShubIdle5 = [ $Idle5,  S_ShubIdle6 ] {};
void() S_ShubIdle6 = [ $Idle6,  S_ShubIdle7 ] {};
void() S_ShubIdle7 = [ $Idle7,  S_ShubIdle8 ] {};
void() S_ShubIdle8 = [ $Idle8,  S_ShubIdle9 ] {};
void() S_ShubIdle9 = [ $Idle9,  S_ShubIdle10 ] {};
void() S_ShubIdle10 = [ $Idle10, S_ShubIdle11 ] {};
void() S_ShubIdle11 = [ $Idle11, S_ShubIdle12 ] {};
void() S_ShubIdle12 = [ $Idle12, S_ShubIdle13 ] {};
void() S_ShubIdle13 = [ $Idle13, S_ShubIdle14 ] {};
void() S_ShubIdle14 = [ $Idle14, S_ShubIdle15 ] {};
void() S_ShubIdle15 = [ $Idle15, S_ShubIdle16 ] {};
void() S_ShubIdle16 = [ $Idle16, S_ShubIdle17 ] {};
void() S_ShubIdle17 = [ $Idle17, S_ShubIdle18 ] {};
void() S_ShubIdle18 = [ $Idle18, S_ShubIdle19 ] {};
void() S_ShubIdle19 = [ $Idle19, S_ShubIdle20 ] {};
void() S_ShubIdle20 = [ $Idle20, S_ShubIdle21 ] {};
void() S_ShubIdle21 = [ $Idle21, S_ShubIdle22 ] {};
void() S_ShubIdle22 = [ $Idle22, S_ShubIdle23 ] {};
void() S_ShubIdle23 = [ $Idle23, S_ShubIdle24 ] {};
void() S_ShubIdle24 = [ $Idle24, S_ShubIdle25 ] {};
void() S_ShubIdle25 = [ $Idle25, S_ShubIdle26 ] {};
void() S_ShubIdle26 = [ $Idle26, S_ShubIdle27 ] {};
void() S_ShubIdle27 = [ $Idle27, S_ShubIdle28 ] {};
void() S_ShubIdle28 = [ $Idle28, S_ShubIdle29 ] {};
void() S_ShubIdle29 = [ $Idle29, S_ShubIdle30 ] {};
void() S_ShubIdle30 = [ $Idle30, S_ShubIdle31 ] {};
void() S_ShubIdle31 = [ $Idle31, S_ShubIdle32 ] {};
void() S_ShubIdle32 = [ $Idle32, S_ShubIdle33 ] {};
void() S_ShubIdle33 = [ $Idle33, S_ShubIdle34 ] {};
void() S_ShubIdle34 = [ $Idle34, S_ShubIdle35 ] {};
void() S_ShubIdle35 = [ $Idle35, S_ShubIdle36 ] {};
void() S_ShubIdle36 = [ $Idle36, S_ShubIdle37 ] {};
void() S_ShubIdle37 = [ $Idle37, S_ShubIdle38 ] {};
void() S_ShubIdle38 = [ $Idle38, S_ShubIdle39 ] {};
void() S_ShubIdle39 = [ $Idle39, S_ShubIdle40 ] {};
void() S_ShubIdle40 = [ $Idle40, S_ShubIdle41 ] {};
void() S_ShubIdle41 = [ $Idle41, S_ShubIdle42 ] {};
void() S_ShubIdle42 = [ $Idle42, S_ShubIdle43 ] {};
void() S_ShubIdle43 = [ $Idle43, S_ShubIdle44 ] {};
void() S_ShubIdle44 = [ $Idle44, S_ShubIdle45 ] {};
void() S_ShubIdle45 = [ $Idle45, S_ShubIdle46 ] {};
void() S_ShubIdle46 = [ $Idle46, S_ShubIdle1 ] {};

void() S_ShubDeath1 = [ $Death1,  S_ShubDeath2 ] {};
void() S_ShubDeath2 = [ $Death2,  S_ShubDeath3 ] { A_SetShubLightStyle("k"); };
void() S_ShubDeath3 = [ $Death3,  S_ShubDeath4 ] {};
void() S_ShubDeath4 = [ $Death4,  S_ShubDeath5 ] { A_SetShubLightStyle("i"); };
void() S_ShubDeath5 = [ $Death5,  S_ShubDeath6 ] { A_SetShubLightStyle("g"); };
void() S_ShubDeath6 = [ $Death6,  S_ShubDeath7 ] { A_SetShubLightStyle("e"); };
void() S_ShubDeath7 = [ $Death7,  S_ShubDeath8 ] { A_SetShubLightStyle("c"); };
void() S_ShubDeath8 = [ $Death8,  S_ShubDeath9 ] { A_SetShubLightStyle("a"); };
void() S_ShubDeath9 = [ $Death9,  S_ShubDeath10 ] { A_SetShubLightStyle("c"); };
void() S_ShubDeath10 = [ $Death10, S_ShubDeath11 ] { A_SetShubLightStyle("e"); };
void() S_ShubDeath11 = [ $Death11, S_ShubDeath12 ] { A_SetShubLightStyle("g"); };
void() S_ShubDeath12 = [ $Death12, S_ShubDeath13 ] { A_SetShubLightStyle("i"); };
void() S_ShubDeath13 = [ $Death13, S_ShubDeath14 ] { A_SetShubLightStyle("k"); };
void() S_ShubDeath14 = [ $Death14, S_ShubDeath15 ] { A_SetShubLightStyle("m"); };
void() S_ShubDeath15 = [ $Death15, S_ShubDeath16 ]
{
	if (++self.count < 3)
		self.think = S_ShubDeath1;
};
void() S_ShubDeath16 = [ $Death16, S_ShubDeath17 ] { A_SetShubLightStyle("g"); };
void() S_ShubDeath17 = [ $Death17, S_ShubDeath18 ] { A_SetShubLightStyle("c"); };
void() S_ShubDeath18 = [ $Death18, S_ShubDeath19 ] { A_SetShubLightStyle("b"); };
void() S_ShubDeath19 = [ $Death19, S_ShubDeath20 ] { A_SetShubLightStyle("a"); };
void() S_ShubDeath20 = [ $Death20, S_ShubDeath20 ]
{
	A_SetShubLightStyle("m");
	A_FinaleEnd();
};

void A_SetShubLightStyle(string lvl)
{
	if (self.flags & FL_BOSS)
		SetLightStyle(0, lvl);
}

void A_FinaleStart()
{
	if (!(self.flags & FL_BOSS))
	{
		// Normal setpiece monster, so no finale needed
		PlaySound(self, CHAN_VOICE, "boss2/death.wav", 1.0, ATTN_NORM);
		S_ShubDeath1();
	}
	
	// Find the intermission spot
	entity pos = FindEntity(world, classname, "info_intermission");
	if (!pos)
		ThrowAbortException("No end-of-game info_intermission found");
	
	entity train = FindEntity(world, classname, "misc_teleporttrain");
	if (train)
		DestroyEntity(train);
	
	// Negative values are treated as infinite
	IntermissionActive = -1;
	IntermissionText = STR_EMPTY;

	WriteByte(MSG_ALL, SVC_FINALE);
	WriteString(MSG_ALL, STR_EMPTY);

	for (entity e = NextEntity(world); e; e = NextEntity(e))
		SetIntermissionMode(e, pos);

	entity timer = SpawnEntity();
	timer.owner = self;
	timer.origin = self.origin - [0.0, 100.0, 0.0];
	SetNextThink(timer, 1.0, A_FinaleTeleport);
}

void A_FinaleTeleport()
{
	// Start a teleport splash inside Shub
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_TELEPORT);
	WriteCoord(MSG_BROADCAST, self.origin.x);
	WriteCoord(MSG_BROADCAST, self.origin.y);
	WriteCoord(MSG_BROADCAST, self.origin.z);

	PlaySound(self.owner, CHAN_VOICE, "misc/r_tele1.wav", 1.0, ATTN_NORM);

	SetNextThink(self, 2.0, A_FinaleDeathStart);
}

void A_FinaleDeathStart()
{
	// Start Shub thrashing wildly
	PlaySound(self.owner, CHAN_VOICE, "boss2/death.wav", 1.0, ATTN_NORM);
	SetState(self.owner, S_ShubDeath1);
}

void A_FinaleEnd()
{
	PlaySound(self, CHAN_VOICE, "boss2/pop2.wav", 1.0, ATTN_NORM);

	// Throw tons of meat chunks
	for (float zOfs = 16.0; zOfs <= 144.0; zOfs += 96.0)
	{
		for (float xOfs = -64.0; xOfs <= 64.0; xOfs += 32.0)
		{
			for (float yOfs = -64.0; yOfs <= 64.0; yOfs += 32.0)
			{
				vector orig = self.origin + [xOfs, yOfs, zOfs];
				float r = Random();
				if (r < 0.33)
					ThrowGib("progs/gib1.mdl", self, orig, -999);
				else if (r < 0.66)
					ThrowGib("progs/gib2.mdl", self, orig, -999);
				else
					ThrowGib("progs/gib3.mdl", self, orig, -999);
			}
		}
	}
	
	vector dollPos = self.origin - [32.0, 264.0, 0.0];
	DestroyEntity(self);
	
	// Not actually in the finale, so just spray gibs and then dip
	if (!(self.flags & FL_BOSS))
		return;
	
	// Put a player model down
	entity doll = SpawnEntityType(player_doll, dollPos);
	doll.angles = [0.0, 290.0, 0.0];
	
	// Start the end text
	IntermissionText = ;
	IntermissionTrack = 3;
	WriteByte(MSG_ALL, SVC_FINALE);
	WriteString(MSG_ALL, FIN_END);

	// Switch cd track
	WriteByte(MSG_ALL, SVC_CDTRACK);
	WriteByte(MSG_ALL, 3);
	WriteByte(MSG_ALL, 3);
}

// This one will actually animate unlike the original which should be
// a bit less awkward looking...
void player_doll()
{
	self.current_slot = self.pending_slot = INVALID_SLOT;
	
	SetPhysics(SOLID_NOT, MOVETYPE_NONE);
	InitializeEntity(self, "progs/player.mdl");
	
	S_PlayerIdle1();
}

void monster_oldone()
{
	if (!CanSpawn(self))
		return;

	PrecacheModel("progs/oldone.mdl");

	PrecacheSound("boss2/death.wav");
	PrecacheSound("boss2/pop2.wav");
	
	self.th_die = A_FinaleStart;
	
	self.flags |= FL_MONSTER | FL_COUNT_MONSTER | FL_AVOID | FL_IGNORE_INFIGHT;
	if (self.health < 1)
	{
		self.health = TELEFRAG_DAMAGE;	// Killed by telefrag only
		self.takedamage = DAMAGE_YES;
		self.flags |= FL_BOSS | FL_MUST_GIB;
	}
	else
	{
		self.takedamage = DAMAGE_AIM;
	}
	
	SetNextThink(self, S_ShubIdle1, 0.1);
	
	SetPhysics(SOLID_SLIDEBOX, MOVETYPE_STEP);
	InitializeEntity(self, "progs/oldone.mdl", [-160.0, -128.0, -24.0], [160.0, 128.0, 256.0]);

	++total_monsters;
}
