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

void CreateWorldEntities()
{
	slime_ent = SpawnEntityType(world_slime);
	lava_ent = SpawnEntityType(world_lava);
	water_ent = SpawnEntityType(world_water);
	gravity_ent = SpawnEntityType(world_gravity);
	
	// Rotating list of bodies for multiplayer corpses
	
	body_queue_head = SpawnEntityType(bodyqueue);
	body_queue_head.owner = SpawnEntityType(bodyqueue);
	body_queue_head.owner.owner = SpawnEntityType(bodyqueue);
	body_queue_head.owner.owner.owner = SpawnEntityType(bodyqueue);
	body_queue_head.owner.owner.owner.owner = body_queue_head;
}

// Setup light animation tables. 'a' is total darkness, 'z' is fullbright
void CreateLightStyles()
{
	// 0 normal
	SetLightStyle(0, "m");

	// 1 FLICKER (first variety)
	SetLightStyle(1, "mmnmmommommnonmmonqnmmo");

	// 2 SLOW STRONG PULSE
	SetLightStyle(2, "abcdefghijklmnopqrstuvwxyzyxwvutsrqponmlkjihgfedcba");

	// 3 CANDLE (first variety)
	SetLightStyle(3, "mmmmmaaaaammmmmaaaaaabcdefgabcdefg");

	// 4 FAST STROBE
	SetLightStyle(4, "mamamamamama");

	// 5 GENTLE PULSE 1
	SetLightStyle(5,"jklmnopqrstuvwxyzyxwvutsrqponmlkj");

	// 6 FLICKER (second variety)
	SetLightStyle(6, "nmonqnmomnmomomno");

	// 7 CANDLE (second variety)
	SetLightStyle(7, "mmmaaaabcdefgmmmmaaaammmaamm");

	// 8 CANDLE (third variety)
	SetLightStyle(8, "mmmaaammmaaammmabcdefaaaammmmabcdefmmmaaaa");

	// 9 SLOW STROBE (fourth variety)
	SetLightStyle(9, "aaaaaaaazzzzzzzz");

	// 10 FLUORESCENT FLICKER
	SetLightStyle(10, "mmamammmmammamamaaamammma");

	// 11 SLOW PULSE NOT FADE TO BLACK
	SetLightStyle(11, "abcdefghijklmnopqrrqponmlkjihgfedcba");

	// Styles 32-62 are assigned by the light program for switchable lights

	// 63 testing
	SetLightStyle(63, "a");
}

// Precache any commonly used entities here
void PrecacheEntities()
{
	PrecacheEntity(missile_nail);
	PrecacheEntity(missile_supernail);
	PrecacheEntity(missile_grenade);
	PrecacheEntity(missile_rocket);
	PrecacheEntity(item_backpack);
}

// Things that should always be here:
// 	* Anything related to the client's models
// 	* Anything related to the client's weapons (both view and projectiles)
// 	* Any kind of entity that will get spawned mid-game (e.g. backpacks)
void PrecacheModels()
{
	// Client
	PrecacheModel("progs/player.mdl");
	PrecacheModel("progs/h_player.mdl");
	PrecacheModel("progs/eyes.mdl");
	
	// View models
	PrecacheModel("progs/v_axe.mdl");
	PrecacheModel("progs/v_shot.mdl");
	PrecacheModel("progs/v_shot2.mdl");
	PrecacheModel("progs/v_nail.mdl");
	PrecacheModel("progs/v_nail2.mdl");
	PrecacheModel("progs/v_rock.mdl");
	PrecacheModel("progs/v_rock2.mdl");
	PrecacheModel("progs/v_light.mdl");
	
	// Effects
	PrecacheModel("progs/gib1.mdl");
	PrecacheModel("progs/gib2.mdl");
	PrecacheModel("progs/gib3.mdl");
	PrecacheModel("progs/zom_gib.mdl");
	PrecacheModel("progs/bolt.mdl");
	PrecacheModel("progs/bolt2.mdl");
	PrecacheModel("progs/bolt3.mdl"); // for boss shock
	//PrecacheModel("progs/beam.mdl"); // Add this in for TE_BEAM effects
	PrecacheModel("progs/s_bubble.spr");
	PrecacheModel("progs/s_explod.spr");
}

// Things that should always be here:
// 	* Anything related to the client's sounds
// 	* Anything related to the client's weapons (both attacks and projectiles)
// 	* Anything related to items that the client can cheat give themselves (like quad damage)
// 	* Any sounds that will emit from entities spawned mid-map (like explosions)
// 	* Generic sounds anything should have access to
void PrecacheSounds()
{
	// General
	PrecacheSound("misc/talk.wav"); // talk
	PrecacheSound("demon/dland2.wav"); // landing thud
	PrecacheSound("misc/h2ohit1.wav"); // landing splash
	PrecacheSound("misc/water1.wav"); // swimming
	PrecacheSound("misc/water2.wav"); // swimming
	
	// Client
	PrecacheSound("player/plyrjmp8.wav");
	PrecacheSound("player/land.wav");
	PrecacheSound("player/land2.wav");
	PrecacheSound("player/drown1.wav");
	PrecacheSound("player/drown2.wav");
	PrecacheSound("player/gasp1.wav");
	PrecacheSound("player/gasp2.wav");
	PrecacheSound("player/h2odeath.wav");
	PrecacheSound("player/h2ojump.wav"); // player jumping into water
	PrecacheSound("player/inh2o.wav"); // player enter water
	PrecacheSound("player/slimbrn2.wav"); // player enter slime
	PrecacheSound("player/inlava.wav"); // player enter lava
	PrecacheSound("misc/outwater.wav"); // leaving water sound
	
	PrecacheSound("player/pain1.wav");
	PrecacheSound("player/pain2.wav");
	PrecacheSound("player/pain3.wav");
	PrecacheSound("player/pain4.wav");
	PrecacheSound("player/pain5.wav");
	PrecacheSound("player/pain6.wav");
	PrecacheSound("player/lburn1.wav"); // lava burn
	PrecacheSound("player/lburn2.wav"); // lava burn
	PrecacheSound("player/gib.wav"); // player gib sound
	PrecacheSound("player/tornoff2.wav"); // disconnect sound
	PrecacheSound("player/axhit1.wav"); // ax hit meat
	
	PrecacheSound("player/death1.wav");
	PrecacheSound("player/death2.wav");
	PrecacheSound("player/death3.wav");
	PrecacheSound("player/death4.wav");
	PrecacheSound("player/death5.wav");
	PrecacheSound("player/teledth1.wav"); // telefrag
	
	// Weapons
	PrecacheSound("weapons/ax1.wav"); // ax swoosh
	PrecacheSound("player/axhit2.wav"); // ax hit world
	PrecacheSound("weapons/guncock.wav");
	PrecacheSound("weapons/shotgn2.wav");
	PrecacheSound("weapons/rocket1i.wav");
	PrecacheSound("weapons/spike2.wav");
	PrecacheSound("weapons/grenade.wav");
	PrecacheSound("weapons/sgun1.wav");
	PrecacheSound("weapons/lstart.wav"); //lightning start
	PrecacheSound("weapons/lhit.wav"); //lightning
	
	// Items
	PrecacheSound("items/damage2.wav");
	PrecacheSound("items/damage3.wav");
	PrecacheSound("items/protect2.wav");
	PrecacheSound("items/protect3.wav");
	PrecacheSound("items/suit2.wav");
	PrecacheSound("items/inv2.wav");
	PrecacheSound("items/inv3.wav");
	
	// Effects
	PrecacheSound("misc/r_tele1.wav"); // teleport sounds
	PrecacheSound("misc/r_tele2.wav");
	PrecacheSound("misc/r_tele3.wav");
	PrecacheSound("misc/r_tele4.wav");
	PrecacheSound("misc/r_tele5.wav");
	PrecacheSound("player/udeath.wav"); // gib sound
	PrecacheSound("misc/power.wav");
	PrecacheSound("hknight/hit.wav");
	PrecacheSound("wizard/hit.wav");
	PrecacheSound("weapons/tink1.wav"); // spikes tink(used in c code)
	PrecacheSound("weapons/ric1.wav"); // ricochet (used in c code)
	PrecacheSound("weapons/ric2.wav"); // ricochet (used in c code)
	PrecacheSound("weapons/ric3.wav"); // ricochet (used in c code)
	PrecacheSound("weapons/r_exp3.wav"); // new rocket explosion
}

// Make a body queue entry for the given client so they can be
// respawned elsewhere
void AddToBodyQueue(entity client)
{
	body_queue_head.angles = client.angles;
	body_queue_head.frame = client.frame;
	body_queue_head.colormap = client.colormap;
	body_queue_head.velocity = client.velocity;
	
	body_queue_head.origin = client.origin;
	SetPhysics(body_queue_head, SOLID_NOT, MOVETYPE_TOSS);
	InitializeEntity(body_queue_head, client.model);
	
	body_queue_head = body_queue_head.owner;
}

void CheckDeathmatchRules()
{
	// Match already ended
	if (!deathmatch || (server_state & SV_GAME_OVER))
		return;

	float timelimit = GetCVarF("timelimit") * 60.0;
	if (timelimit > 0.0 && time >= timelimit)
	{
		CycleLevel();
		return;
	}

	int_t fraglimit = GetCVarF("fraglimit");
	if (fraglimit >= 1)
	{
		for (entity p = NextEntity(world); IsClient(p); p = NextEntity(p))
		{
			if (p.frags >= fraglimit)
			{
				CycleLevel();
				return;
			}
		}
	}
}

void StartFrame()
{
	++server_frame;
	
	skill = GetCVarF("skill");
	teamplay = GetCVarF("teamplay");
	
	// These automatically get sent out on the first update
	if (!MapLoading())
	{
		if (prev_total_monsters != total_monsters)
		{
			WriteUInt8(MSG_ALL, SVC_UPDATESTAT);
			WriteUInt8(MSG_ALL, STAT_TOTALMONSTERS);
			WriteInt32(MSG_ALL, total_monsters);
		}
		
		if (prev_total_secrets != total_secrets)
		{
			WriteUInt8(MSG_ALL, SVC_UPDATESTAT);
			WriteUInt8(MSG_ALL, STAT_TOTALSECRETS);
			WriteInt32(MSG_ALL, total_secrets);
		}
	}
	
	// Try and keep network spam down in case a lot of things
	// die at once (also avoids needing to manually network in
	// the rest of the code)
	if (prev_killed_monsters != killed_monsters)
	{
		WriteUInt8(MSG_ALL, SVC_UPDATESTAT);
		WriteUInt8(MSG_ALL, STAT_MONSTERS);
		WriteInt32(MSG_ALL, killed_monsters);
	}
	
	if (prev_found_secrets != found_secrets)
	{
		WriteUInt8(MSG_ALL, SVC_UPDATESTAT);
		WriteUInt8(MSG_ALL, STAT_SECRETS);
		WriteInt32(MSG_ALL, found_secrets);
	}
	
	prev_killed_monsters = killed_monsters;
	prev_found_secrets = found_secrets;
	prev_total_monsters = total_monsters;
	prev_total_secrets = total_secrets;
	
	if (server_state & SV_LIQUID_HURTS_MONSTERS)
	{
		for (entity m = NextEntity(world); m; m = NextEntity(m))
		{
			if (m.waterlevel >= DEPTH_MONSTER_SUBMERGED && m.health >= 1 && IsMonster(m))
				DealLiquidDamage(m);
		}
	}
	
	CheckDeathmatchRules();
}

enumflags
{
	WRD_OVERRIDE_VANILLA,
	WRD_NO_FALL_DAMAGE,
	WRD_NO_DROWNING,
};

void worldspawn()
{
	starting_flags = serverflags;
	current_song = &self.sounds;
	
	// Much better method for allowing custom gravity
	if (self.gravity)
		SetCVar("sv_gravity", ToStringF(800.0 * self.gravity));
	else if (!self.misc_action && mapname == "e1m8")
		SetCVar("sv_gravity", "100");
	else
		SetCVar("sv_gravity", "800");

	// Set up for things like weapon and level item classes
	CreateWorldEntities();
	CreateWeapons();
	CreateLevelItems();
	CreateLightStyles();
	
	// Precaches shared across the game as a whole that pretty
	// much always need to be set
	PrecacheEntities();
	PrecacheModels();
	PrecacheSounds();
}
