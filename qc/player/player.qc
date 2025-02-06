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

$frame MelRun1 MelRun2 MelRun3 MelRun4 MelRun5 MelRun6
$frame Run1 Run2 Run3 Run4 Run5 Run6

$frame Stand1 Stand2 Stand3 Stand4 Stand5
$frame MelStand1 MelStand2 MelStand3 MelStand4 MelStand5 MelStand6 MelStand7 MelStand8 MelStand9 MelStand10 MelStand11 MelStand12

$frame MelPain1 MelPain2 MelPain3 MelPain4 MelPain5 MelPain6
$frame Pain1 Pain2 Pain3 Pain4 Pain5 Pain6

$frame MelDeath1 MelDeath2 MelDeath3 MelDeath4 MelDeath5 MelDeath6 MelDeath7 MelDeath8 MelDeath9
$frame DeathA1 DeathA2 DeathA3 DeathA4 DeathA5 DeathA6 DeathA7 DeathA8 DeathA9 DeathA10 DeathA11
$frame DeathB1 DeathB2 DeathB3 DeathB4 DeathB5 DeathB6 DeathB7 DeathB8 DeathB9
$frame DeathC1 DeathC2 DeathC3 DeathC4 DeathC5 DeathC6 DeathC7 DeathC8 DeathC9 DeathC10 DeathC11 DeathC12 DeathC13 DeathC14 DeathC15
$frame DeathD1 DeathD2 DeathD3 DeathD4 DeathD5 DeathD6 DeathD7 frame DeathD8 DeathD9
$frame DeathE1 DeathE2 DeathE3 DeathE4 DeathE5 DeathE6 DeathE7 frame DeathE8 DeathE9

$frame MisLoopA1 MisLoopA2
$frame MisLoopB1 MisLoopB2

$frame MissileA1 MissileA2 MissileA3 MissileA4 MissileA5 MissileA6
$frame MissileB1 MissileB2 MissileB3 MissileB4 MissileB5 MissileB6

$frame MeleeA1 MeleeA2 MeleeA3 MeleeA4 MeleeA5 MeleeA6
$frame MeleeB1 MeleeB2 MeleeB3 MeleeB4 MeleeB5 MeleeB6
$frame MeleeC1 MeleeC2 MeleeC3 MeleeC4 MeleeC5 MeleeC6
$frame MeleeD1 MeleeD2 MeleeD3 MeleeD4 MeleeD5 MeleeD6

/*
==============================================================================

STATES

==============================================================================
*/

void() S_PlayerStand1 = [ $Stand1, S_PlayerStand1 ]
{
	if (self.velocity.x || self.velocity.y)
	{
		S_PlayerRun1();
		return;
	}

	if (IsMelee(self.current_slot))
		self.anim_frame = AdvanceFrame(self.anim_frame, $MelStand1, $MelStand12);
	else
		self.anim_frame = AdvanceFrame(self.anim_frame, $Stand1, $Stand5);
	
	self.frame = self.anim_frame;
};

void() S_PlayerRun1 = [ $MelRun1, S_PlayerRun1 ]
{
	if (!self.velocity.x && !self.velocity.y)
	{
		S_PlayerStand1();
		return;
	}

	if (IsMelee(self.current_slot))
		self.anim_frame = AdvanceFrame(self.anim_frame, $MelRun1, $MelRun6);
	else
		self.anim_frame = AdvanceFrame(self.anim_frame, $Run1, $Run6);
	
	self.frame = self.anim_frame;
};

void() S_PlayerMissileLoopA1 = [ $MisLoopA1, S_PlayerMissileLoopA1 ]
{
	if (!self.button0)
	{
		S_PlayerRun1();
		return;
	}
	
	self.anim_frame = AdvanceFrame(self.anim_frame, $MisLoopA1, $MisLoopA2);
	self.frame = self.anim_frame;
}

void() S_PlayerMissileLoopB1 = [ $MisLoopB1, S_PlayerMissileLoopB1 ]
{
	if (!self.button0)
	{
		S_PlayerRun1();
		return;
	}
	
	self.anim_frame = AdvanceFrame(self.anim_frame, $MisLoopB1, $MisLoopB2);
	self.frame = self.anim_frame;
};

void() S_PlayerMissileA1 = [ $MissileA1, S_PlayerMissileA2  ] {};
void() S_PlayerMissileA2 = [ $MissileA2, S_PlayerMissileA3  ] {};
void() S_PlayerMissileA3 = [ $MissileA3, S_PlayerMissileA4  ] {};
void() S_PlayerMissileA4 = [ $MissileA4, S_PlayerMissileA5  ] {};
void() S_PlayerMissileA5 = [ $MissileA5, S_PlayerMissileA6  ] {};
void() S_PlayerMissileA6 = [ $MissileA6, S_PlayerRun1  ] {};

void() S_PlayerMissileB1 = [ $MissileB1, S_PlayerMissileB2 ] {};
void() S_PlayerMissileB2 = [ $MissileB2, S_PlayerMissileB3 ] {};
void() S_PlayerMissileB3 = [ $MissileB3, S_PlayerMissileB4 ] {};
void() S_PlayerMissileB4 = [ $MissileB4, S_PlayerMissileB5 ] {};
void() S_PlayerMissileB5 = [ $MissileB5, S_PlayerMissileB6 ] {};
void() S_PlayerMissileB6 = [ $MissileB6, S_PlayerRun1 ] {};

void() S_PlayerMeleeA1 = [ $MeleeA1, S_PlayerMeleeA2 ] {};
void() S_PlayerMeleeA2 = [ $MeleeA2, S_PlayerMeleeA3 ] {};
void() S_PlayerMeleeA3 = [ $MeleeA3, S_PlayerMeleeA4 ] {};
void() S_PlayerMeleeA4 = [ $MeleeA4, S_PlayerRun1 ] {};

void() S_PlayerMeleeB1 = [ $MeleeB1, S_PlayerMeleeB2 ] {};
void() S_PlayerMeleeB2 = [ $MeleeB2, S_PlayerMeleeB3 ] {};
void() S_PlayerMeleeB3 = [ $MeleeB3, S_PlayerMeleeB4 ] {};
void() S_PlayerMeleeB4 = [ $MeleeB4, S_PlayerRun1 ] {};

void() S_PlayerMeleeC1 = [ $MeleeC1, S_PlayerMeleeC2 ] {};
void() S_PlayerMeleeC2 = [ $MeleeC2, S_PlayerMeleeC3 ] {};
void() S_PlayerMeleeC3 = [ $MeleeC3, S_PlayerMeleeC4 ] {};
void() S_PlayerMeleeC4 = [ $MeleeC4, S_PlayerRun1 ] {};

void() S_PlayerMeleeD1 = [ $MeleeD1, S_PlayerMeleeD2 ] {};
void() S_PlayerMeleeD2 = [ $MeleeD2, S_PlayerMeleeD3 ] {};
void() S_PlayerMeleeD3 = [ $MeleeD3, S_PlayerMeleeD4 ] {};
void() S_PlayerMeleeD4 = [ $MeleeD4, S_PlayerRun1 ] {};

void() S_PlayerPain1 = [ $Pain1, S_PlayerPain2 ] {};
void() S_PlayerPain2 = [ $Pain2, S_PlayerPain3 ] {};
void() S_PlayerPain3 = [ $Pain3, S_PlayerPain4 ] {};
void() S_PlayerPain4 = [ $Pain4, S_PlayerPain5 ] {};
void() S_PlayerPain5 = [ $Pain5, S_PlayerPain6 ] {};
void() S_PlayerPain6 = [ $Pain6, S_PlayerRun1 ] {};

void() S_PlayerMeleePain1 = [ $MelPain1, S_PlayerMeleePain2 ] {};
void() S_PlayerMeleePain2 = [ $MelPain2, S_PlayerMeleePain3 ] {};
void() S_PlayerMeleePain3 = [ $MelPain3, S_PlayerMeleePain4 ] {};
void() S_PlayerMeleePain4 = [ $MelPain4, S_PlayerMeleePain5 ] {};
void() S_PlayerMeleePain5 = [ $MelPain5, S_PlayerMeleePain6 ] {};
void() S_PlayerMeleePain6 = [ $MelPain6, S_PlayerRun1 ] {};

void() S_PlayerDeathA1 = [ $DeathA1, S_PlayerDeathA2 ] {};
void() S_PlayerDeathA2 = [ $DeathA2, S_PlayerDeathA3 ] {};
void() S_PlayerDeathA3 = [ $DeathA3, S_PlayerDeathA4 ] {};
void() S_PlayerDeathA4 = [ $DeathA4, S_PlayerDeathA5 ] {};
void() S_PlayerDeathA5 = [ $DeathA5, S_PlayerDeathA6 ] {};
void() S_PlayerDeathA6 = [ $DeathA6, S_PlayerDeathA7 ] {};
void() S_PlayerDeathA7 = [ $DeathA7, S_PlayerDeathA8 ] {};
void() S_PlayerDeathA8 = [ $DeathA8, S_PlayerDeathA9 ] {};
void() S_PlayerDeathA9 = [ $DeathA9, S_PlayerDeathA10 ] {};
void() S_PlayerDeathA10 = [ $DeathA10, S_PlayerDeathA11 ] {};
void() S_PlayerDeathA11 = [ $DeathA11, __NULL__ ] { self.deadflag = DEAD_DEAD; };

void() S_PlayerDeathB1 = [ $DeathB1, S_PlayerDeathB2 ] {};
void() S_PlayerDeathB2 = [ $DeathB2, S_PlayerDeathB3 ] {};
void() S_PlayerDeathB3 = [ $DeathB3, S_PlayerDeathB4 ] {};
void() S_PlayerDeathB4 = [ $DeathB4, S_PlayerDeathB5 ] {};
void() S_PlayerDeathB5 = [ $DeathB5, S_PlayerDeathB6 ] {};
void() S_PlayerDeathB6 = [ $DeathB6, S_PlayerDeathB7 ] {};
void() S_PlayerDeathB7 = [ $DeathB7, S_PlayerDeathB8 ] {};
void() S_PlayerDeathB8 = [ $DeathB8, S_PlayerDeathB9 ] {};
void() S_PlayerDeathB9 = [ $DeathB9, __NULL__ ] { self.deadflag = DEAD_DEAD; };

void() S_PlayerDeathC1 = [ $DeathC1, S_PlayerDeathC2 ] {};
void() S_PlayerDeathC2 = [ $DeathC2, S_PlayerDeathC3 ] {};
void() S_PlayerDeathC3 = [ $DeathC3, S_PlayerDeathC4 ] {};
void() S_PlayerDeathC4 = [ $DeathC4, S_PlayerDeathC5 ] {};
void() S_PlayerDeathC5 = [ $DeathC5, S_PlayerDeathC6 ] {};
void() S_PlayerDeathC6 = [ $DeathC6, S_PlayerDeathC7 ] {};
void() S_PlayerDeathC7 = [ $DeathC7, S_PlayerDeathC8 ] {};
void() S_PlayerDeathC8 = [ $DeathC8, S_PlayerDeathC9 ] {};
void() S_PlayerDeathC9 = [ $DeathC9, S_PlayerDeathC10 ] {};
void() S_PlayerDeathC10 = [ $DeathC10, S_PlayerDeathC11 ] {};
void() S_PlayerDeathC11 = [ $DeathC11, S_PlayerDeathC12 ] {};
void() S_PlayerDeathC12 = [ $DeathC12, S_PlayerDeathC13 ] {};
void() S_PlayerDeathC13 = [ $DeathC13, S_PlayerDeathC14 ] {};
void() S_PlayerDeathC14 = [ $DeathC14, S_PlayerDeathC15 ] {};
void() S_PlayerDeathC15 = [ $DeathC15, __NULL__ ] { self.deadflag = DEAD_DEAD; };

void() S_PlayerDeathD1 = [ $DeathD1, S_PlayerDeathD2 ] {};
void() S_PlayerDeathD2 = [ $DeathD2, S_PlayerDeathD3 ] {};
void() S_PlayerDeathD3 = [ $DeathD3, S_PlayerDeathD4 ] {};
void() S_PlayerDeathD4 = [ $DeathD4, S_PlayerDeathD5 ] {};
void() S_PlayerDeathD5 = [ $DeathD5, S_PlayerDeathD6 ] {};
void() S_PlayerDeathD6 = [ $DeathD6, S_PlayerDeathD7 ] {};
void() S_PlayerDeathD7 = [ $DeathD7, S_PlayerDeathD8 ] {};
void() S_PlayerDeathD8 = [ $DeathD8, S_PlayerDeathD9 ] {};
void() S_PlayerDeathD9 = [ $DeathD9, __NULL__ ] { self.deadflag = DEAD_DEAD; };

void() S_PlayerDeathE1 = [ $DeathE1, S_PlayerDeathE2 ] {};
void() S_PlayerDeathE2 = [ $DeathE2, S_PlayerDeathE3 ] {};
void() S_PlayerDeathE3 = [ $DeathE3, S_PlayerDeathE4 ] {};
void() S_PlayerDeathE4 = [ $DeathE4, S_PlayerDeathE5 ] {};
void() S_PlayerDeathE5 = [ $DeathE5, S_PlayerDeathE6 ] {};
void() S_PlayerDeathE6 = [ $DeathE6, S_PlayerDeathE7 ] {};
void() S_PlayerDeathE7 = [ $DeathE7, S_PlayerDeathE8 ] {};
void() S_PlayerDeathE8 = [ $DeathE8, S_PlayerDeathE9 ] {};
void() S_PlayerDeathE9 = [ $DeathE9, __NULL__ ] { self.deadflag = DEAD_DEAD; };

void() S_PlayerMeleeDeath1 = [ $MelDeath1, S_PlayerMeleeDeath2 ] {};
void() S_PlayerMeleeDeath2 = [ $MelDeath2, S_PlayerMeleeDeath3 ] {};
void() S_PlayerMeleeDeath3 = [ $MelDeath3, S_PlayerMeleeDeath4 ] {};
void() S_PlayerMeleeDeath4 = [ $MelDeath4, S_PlayerMeleeDeath5 ] {};
void() S_PlayerMeleeDeath5 = [ $MelDeath5, S_PlayerMeleeDeath6 ] {};
void() S_PlayerMeleeDeath6 = [ $MelDeath6, S_PlayerMeleeDeath7 ] {};
void() S_PlayerMeleeDeath7 = [ $MelDeath7, S_PlayerMeleeDeath8 ] {};
void() S_PlayerMeleeDeath8 = [ $MelDeath8, S_PlayerMeleeDeath9 ] {};
void() S_PlayerMeleeDeath9 = [ $MelDeath9, __NULL__ ] { self.deadflag = DEAD_DEAD; };

inline bool_t IsMelee(uint_t slot)
{
	return !IsValidSlot(slot) || (weapons[slot].flags & WF_MELEE);
}

bool_t A_PlayerPain(entity inflictor, entity attacker, int_t damage)
{
	if (!TimerExpired(self.pain_finished))
	{
		self.misc_action &= ~CL_AXE_HIT;
		return FALSE;
	}

	if (self.waterlevel >= DEPTH_SUBMERGED)
	{
		// Always play gasp sound when under liquids
		if (Random() > 0.5)
			PlaySound(self, CHAN_VOICE, "player/drown1.wav", 1.0, ATTN_NORM);
		else
			PlaySound(self, CHAN_VOICE, "player/drown2.wav", 1.0, ATTN_NORM);
		
		if (self.watertype == CONTENTS_WATER)
			SpawnDamageBubbles(self, 1);
	}
	else if (inflictor && inflictor.damage_type == "burn")
	{
		// Burn pain sounds
		if (Random() > 0.5)
			PlaySound(self, CHAN_VOICE, "player/lburn1.wav", 1.0, ATTN_NORM);
		else
			PlaySound(self, CHAN_VOICE, "player/lburn2.wav", 1.0, ATTN_NORM);
	}
	else if (self.misc_action & CL_AXE_HIT)
	{
		// Axe pain sound
		PlaySound(self, CHAN_VOICE, "player/axhit1.wav", 1.0, ATTN_NORM);
	}
	else
	{
		string pain;
		switch (RandomI(5))
		{
		case 1:
			pain = "player/pain2.wav";
			break;
			
		case 2:
			pain = "player/pain3.wav";
			break;
			
		case 3:
			pain = "player/pain4.wav";
			break;
			
		case 4:
			pain = "player/pain5.wav";
			break;
			
		case 5:
			pain = "player/pain6.wav";
			break;
			
		default:
			pain = "player/pain1.wav";
			break;
		}
		
		PlaySound(self, CHAN_VOICE, pain, 1.0, ATTN_NORM);
	}
	
	if (GetItemAmount(self, IT_INVIS) < 1)
	{
		if (IsMelee(self.current_slot))
			S_PlayerMeleePain1();
		else
			S_PlayerPain1();
	}
	
	SetCoolDown(self, pain_finished, 0.5);
	self.misc_action &= ~CL_AXE_HIT;
	return FALSE;
}

void A_PlayerDie(entity inflictor, entity attacker)
{
	bool_t melee = IsMelee(self.current_slot);
	
	ClearWeapon(self);
	
	if (self.health < -40)
	{
		self.deadflag = DEAD_DEAD;
		
		string snd;
		if (inflictor && inflictor.damage_type == "telefrag")
			snd = "player/teledth1.wav";
		else if (Random() < 0.5)
			snd = "player/gib.wav";
		else
			snd = "player/udeath.wav";
		
		GibEntity(self, "progs/h_player.mdl", snd);
		return;
	}

	self.view_ofs = [0.0, 0.0, -8.0];
	self.deadflag = DEAD_DYING;
	self.flags &= ~FL_ONGROUND;
	self.angles.x = self.angles.z = 0.0;
	if (self.velocity.z < 10.0)
		self.velocity.z += RandomF(300.0);
	
	SetPhysics(self, SOLID_NOT, MOVETYPE_TOSS, TRUE);

	// water death sounds
	if (self.waterlevel >= DEPTH_SUBMERGED)
	{
		if (self.watertype == CONTENTS_WATER)
			SpawnDamageBubbles(self, 20);
		
		PlaySound(self, CHAN_VOICE, "player/h2odeath.wav", 1.0, ATTN_NORM);
	}
	else
	{
		string death;
		switch (RandomI(4))
		{
		case 1:
			death = "player/death2.wav";
			break;
			
		case 2:
			death = "player/death3.wav";
			break;
			
		case 3:
			death = "player/death4.wav";
			break;
			
		case 4:
			death = "player/death5.wav";
			break;
			
		default:
			death = "player/death1.wav";
			break;
		}

		PlaySound(self, CHAN_VOICE, death, 1.0, ATTN_NORM);
	}

	if (melee)
	{
		S_PlayerMeleeDeath1();
	}
	else
	{
		switch (RandomI(4))
		{
		case 1:
			S_PlayerDeathB1();
			break;
			
		case 2:
			S_PlayerDeathC1();
			break;
			
		case 3:
			S_PlayerDeathD1();
			break;
			
		case 4:
			S_PlayerDeathE1();
			break;
			
		default:
			S_PlayerDeathA1();
			break;
		}
	}
}

void PlayerKilled(entity client, entity attacker, entity inflictor)
{
	// Make sure the HUD stays cleaned
	client.health = Max(client.health, -99);
	
	string prefix = STR_EMPTY;
	string obit = STR_EMPTY;
	string suffix = STR_EMPTY;
	
	bool_t useFix;
	if (IsClient(attacker))
	{
		useFix = TRUE;
		if (deathmatch)
		{
			if (attacker == client)
				--attacker.frags;
			else
				++attacker.frags;
		}
		
		uint_t s = inflictor && IsValidWeapon(inflictor.current_slot) ? inflictor.current_slot : attacker.current_slot;
		if (IsValidWeapon(s))
		{
			if (attacker == client)
			{
				obit = weapons[s].self_obituary;
			}
			else
			{
				obit = weapons[s].Obituary;
				if (weapons[s].ObituaryPrefix)
					prefix = weapons[s].ObituaryPrefix;
				if (weapons[s].ObituarySuffix)
					suffix = weapons[s].ObituarySuffix;
			}
		}
		
		if (!obit)
			obit = attacker == client ? " tried to live life on the edge" : " was killed by ";
	}
	else if (inflictor && inflictor.Obituary)
	{
		obit = inflictor.Obituary;
	}
	else if (attacker && attacker.Obituary)
	{
		obit = attacker.Obituary;
	}
	
	if (obit == STR_EMPTY)
		obit = " died of cringe";
	
	if (useFix)
		BroadcastPrint(prefix);
	BroadcastPrint(client.netname, obit);
	if (useFix)
		BroadcastPrint(attacker.netname, suffix);
	BroadcastPrint("\n");
}

void PlayerJump(entity client)
{
	if (client.flags & FL_WATERJUMP)
		return;

	if (client.waterlevel >= DEPTH_WAIST)
	{
		if (client.watertype == CONTENTS_WATER)
			client.velocity.z = 100.0;
		else if (client.watertype == CONTENTS_SLIME)
			client.velocity.z = 80.0;
		else
			client.velocity.z = 50.0;

		// play swiming sound
		if (TimerExpired(client.swim_sound))
		{
			SetCoolDown(client, swim_sound, 1.0);
			PlaySound(client, CHAN_BODY, Random() < 0.5 ? "misc/water1.wav" : "misc/water2.wav", 1.0, ATTN_NORM);
		}

		return;
	}

	// don't pogo stick
	if (!(client.flags & FL_ONGROUND) || !(client.flags & FL_JUMPRELEASED))
		return;

	client.flags &= ~FL_JUMPRELEASED;
	client.button2 = FALSE;
	client.velocity.z = 270.0;
	PlaySound(client, CHAN_BODY, "player/plyrjmp8.wav", 1.0, ATTN_NORM);
}

void CheckPlayerWaterJump(entity client)
{
	SetLocalAxes([0.0, client.v_angles.y, 0.0]);
	
	vector start = client.origin;
	start.z += 8.0;
	vector end = start + v_forward * 24.0;
	
	TraceLine(start, end, MOVE_NOMONSTER, client);
	if (trace_fraction < 1.0)
	{ 
		// solid at waist
		start.z += client.maxs.z - 8.0;
		end = start + v_forward * 24.0;
		// Move inward perpendicular to the surface we hit if
		// we have a valid leap
		vector jumpDir = trace_plane_normal * -50.0;
		
		TraceLine(start, end, MOVE_NORMAL, client);
		if (trace_fraction == 1.0)
		{
			// open at eye level
			client.movedir = jumpDir;
			client.flags |= FL_WATERJUMP;
			client.flags &= ~FL_JUMPRELEASED;
			client.velocity.z = 225.0;
			SetCoolDown(client, teleport_time, 2.0);
		}
	}
}

inline void ResetAir(entity client)
{
	client.dmg = 2;
	SetCoolDown(client, air_finished, 12.0);
}

void PlayerWaterMove(entity client)
{
	// Zooming around, so keep the player topped off
	if (client.movetype == MOVETYPE_NOCLIP)
	{
		ResetAir(client);
		return;
	}

	// Check for air (make sure the suit updates it properly as well)
	bool_t hasSuit = GetItemAmount(client, IT_SUIT) >= 1;
	if (client.waterlevel < DEPTH_SUBMERGED || hasSuit)
	{
		if (TimerExpired(client.air_finished))
			PlaySound(client, CHAN_VOICE, "player/gasp2.wav", 1.0, ATTN_NORM);
		else if (TimerExpired(client.air_finished, 9.0))
			PlaySound(client, CHAN_VOICE, "player/gasp1.wav", 1.0, ATTN_NORM);
		
		ResetAir(client);
	}
	else if (TimerExpired(client.air_finished) && TimerExpired(client.pain_finished))
	{
		client.dmg += 2;
		if (client.dmg > 15)
			client.dmg = 10;
		
		DamageEntity(client, water_ent, world, client.dmg, DMG_NO_ARMOR);
		SetCoolDown(client, pain_finished, 1.0);
	}

	// Check water hop out sound
	if (client.waterlevel <= DEPTH_NONE)
	{
		if (client.flags & FL_INWATER)
		{
			// play leave water sound
			PlaySound(client, CHAN_BODY, "misc/outwater.wav", 1.0, ATTN_NORM);
			client.flags &= ~FL_INWATER;
		}
		
		return;
	}
	
	// player enter liquid sound
	if (!(client.flags & FL_INWATER))
	{
		if (client.watertype == CONTENTS_LAVA)
			PlaySound(client, CHAN_BODY, "player/inlava.wav", 1.0, ATTN_NORM);
		else if (client.watertype == CONTENTS_SLIME)
			PlaySound(client, CHAN_BODY, "player/slimbrn2.wav", 1, ATTN_NORM);
		else
			PlaySound(client, CHAN_BODY, "player/inh2o.wav", 1.0, ATTN_NORM);
		
		client.flags |= FL_INWATER;
		client.dmgtime = 0.0;
	}

	// Check for liquid hazards
	if (client.watertype == CONTENTS_LAVA)
	{
		if (TimerExpired(client.dmgtime))
		{
			SetCoolDown(client, dmgtime, hasSuit ? 1.0 : 0.2);
			DamageEntity(client, lava_ent, world, 10 * client.waterlevel);
		}
	}
	else if (client.watertype == CONTENTS_SLIME)
	{
		if (TimerExpired(client.dmgtime) && !hasSuit)
		{
			SetCoolDown(client, dmgtime, 1.0);
			DamageEntity(client, slime_ent, world, 4 * client.waterlevel);
		}
	}

	// Liquid friction
	if (!(client.flags & FL_WATERJUMP))
		client.velocity -= client.velocity * (0.8 * client.waterlevel * frametime);
}

void PlayerDeathThink(entity client)
{
	if (client.flags & FL_ONGROUND)
	{
		float spd = Length(client.velocity);
		float newSpd = spd - 20.0;
		client.velocity = newSpd <= 0.0 ? VEC_ZERO : client.velocity * (newSpd / spd);
	}

	// wait for all buttons released
	if (client.deadflag == DEAD_DEAD)
	{
		if (!client.button0 && !client.button1 && !client.button2)
			client.deadflag = DEAD_RESPAWNABLE;
		
		return;
	}

	// wait for any button down
	if (!client.button0 && !client.button1 && !client.button1)
		return;

	client.button0 = FALSE;
	client.button1 = FALSE;
	client.button2 = FALSE;
	ClientRespawn(client);
}

void PlayerPreThink()
{
	if (intermission_active)
	{
		if (intermission_active < 0 || !TimerExpired(intermission_time))
			return;
	
		if (self.button0 || self.button1 || self.button2)
			AdvanceIntermission();
		
		return;
	}
	
	if (self.deadflag >= DEAD_DEAD)
	{
		PlayerDeathThink(self);
		return;
	}
	
	// dying, so do nothing
	if (self.deadflag != DEAD_NO)
		return;
	
	PlayerWaterMove(self);
	if (self.waterlevel == DEPTH_WAIST)
		CheckPlayerWaterJump(self);

	if (self.button2)
		PlayerJump(self);
	else
		self.flags |= FL_JUMPRELEASED;

	if (!TimerExpired(self.pause_time))
		self.velocity = VEC_ZERO;
	
	// If we left the ground for any reason, apply some inertia from things like platforms
	if ((self.flags & FL_ONGROUND) && self.groundentity && self.groundentity.movetype == MOVETYPE_PUSH)
	{
		// At least get off the ground first before applying the mover's velocity
		if (self.velocity.z > 0.0)
			self.start_move = self.groundentity.velocity;
	}
}

void PlayerPostThink()
{
	if (self.start_move != VEC_ZERO)
	{
		self.velocity += self.start_move;
		self.start_move = VEC_ZERO;
	}
	
	if (intermission_active || self.deadflag != DEAD_NO)
		return;
	
	// check to see if player landed and play landing sound
	if (self.flags & FL_ONGROUND)
	{
		if (self.groundentity && self.groundentity.solid == SOLID_BSP)
			
		if (self.jump_flag < -300.0)
		{
			if (self.watertype != CONTENTS_NONE)
			{
				PlaySound(self, CHAN_BODY, "player/h2ojump.wav", 1.0, ATTN_NORM);
			}
			else if (self.jump_flag < -650.0)
			{
				DamageEntity(self, gravity_ent, world, 5);
				if (self.health >= 1)
					PlaySound(self, CHAN_VOICE, "player/land2.wav", 1.0, ATTN_NORM);
			}
			else
			{
				PlaySound(self, CHAN_VOICE, "player/land.wav", 1.0, ATTN_NORM);
			}
		}
		
		self.jump_flag = 0.0;	
	}
	else
	{
		self.jump_flag = self.velocity.z;
	}
	
	InventoryFrame(self);
}
