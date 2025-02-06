// Called when changing levels
void SetChangeParms()
{
	// Clean these up before leaving
	ClearInventory(self);
	
	if (server_state & SV_RELOADING)
	{
		SetSpawnParms(self);
		return;
	}
	else if (server_state & SV_RESET_INV)
	{
		SetNewParms();
		return;
	}

	parm1 = (self.items & ~IT_KEYS);
	parm2 = Clamp(self.health, 50, 100);
	parm3 = self.armorvalue;
	parm4 = Max(self.ammo_shells, 25);
	parm5 = self.ammo_nails;
	parm6 = self.ammo_rockets;
	parm7 = self.ammo_cells;
	parm8 = self.owned_weapons;
	parm9 = self.armortype * 100.0;
	parm10 = self.current_slot;
}

// Reset the parms to the default when starting a new game
void SetNewParms()
{
	parm1 = IT_DEFAULT_WEAPONS;
	parm2 = 100;
	parm3 = 0;
	parm4 = 25;
	parm5 = 0;
	parm6 = 0;
	parm7 = 0;
	parm8 = WPN_DEFAULT;
	parm9 = ARMOR_NONE;
	parm10 = GetWeaponSlot(SLOT_STARTER, LAYER_DEFAULT);
}

// Update the client's value with whatever is currently
// in the parms
void DecodeLevelParms()
{
	self.items = parm1;
	self.health = parm2;
	self.armorvalue = parm3;
	self.ammo_shells = parm4;
	self.ammo_nails = parm5;
	self.ammo_rockets = parm6;
	self.ammo_cells = parm7;
	self.owned_weapons = parm8;
	self.armortype = parm9 * 0.01;
	self.current_slot = parm10;
}

void RespawnClient()
{
	if (IsOnline())
	{
		AddToBodyQueue(self);
		
		if (deathmatch)
			SetNewParms();	// Generate a fresh loadout in DM
		else
			SetSpawnParms(self); // In coop, use the client's inventory on level enter
		
		PutClientInServer();
	}
	else
	{
		// Fixes a bug where dying and reloading removes all runes
		serverflags = starting_flags;
		server_state |= SV_RELOADING;
		
		RunClientCommand(self, "changelevel ");
		RunClientCommand(self, mapname);
		RunClientCommand(self, "\n");
	}
}

void ClientKill()
{
	// Don't allow it during these intermissions
	if (intermission_active)
		return;
	
	if (self.deadflag == DEAD_NO)
	{
		if (deathmatch)
			self.frags -= 2; // extra penalty
		
		BroadcastPrint(OBIT_PRE_CLIENT_KILL, self.netname, OBIT_SUF_CLIENT_KILL, "\n");
	}
	
	KillClient(self);
	RespawnClient();
}

void KillClient(entity client)
{
	if (client.deadflag != DEAD_DYING && client.deadflag != DEAD_NO)
		return;
	
	if (client.deadflag == DEAD_NO)
	{
		client.health = 0;
		KillEntity(client, world, world);
	}
	
	while (IsThinking(client))
		client.think();
}

void ClientConnect()
{
	BroadcastPrint(SERVER_PRE_CONNECT, self.netname, SERVER_SUF_CONNECT, "\n");
	newest_client = self;
	++num_players;
}

void ClientDisconnect()
{
	// if the level end trigger has been activated, just return
	// since they aren't *really* leaving
	if (server_state & SV_GAME_OVER)
		return;
	
	--num_players;
	
	// let everyone else know
	BroadcastPrint(SERVER_PRE_DISCONNECT, self.netname, SERVER_SUF_DISCONNECT, "\n");
	
	KillClient(self);
	PlaySound(self, CHAN_VOICE, "player/tornoff2.wav", 1.0, ATTN_NONE);
}

entity SelectSpawnPoint()
{
	// Look for multiplayer specific spawns first
	if (IsOnline())
	{
		string type = deathmatch ? "info_player_deathmatch" : "info_player_coop";
		last_player_spawn = FindEntity(last_player_spawn, classname, type);
		if (!last_player_spawn)
			last_player_spawn = FindEntity(world, classname, type);
		
		if (last_player_spawn)
			return last_player_spawn;
	}

	entity pos;
	if (serverflags)
	{
		// Skip the difficulty select on the start map if they're returning
		pos = FindEntity(world, classname, "info_player_start2");
		if (pos)
			return pos;
	}

	pos = FindEntity(world, classname, "info_player_start");
	if (!pos)
		ThrowAbortException("No info_player_start on current level");

	return pos;
}

void PutClientInServer()
{
	// (Re)initialize client
	
	self.classname = "player";
	self.health = self.max_health = 100;
	self.takedamage = DAMAGE_AIM;
	self.view_ofs = [0.0, 0.0, 22.0];
	self.falling_z_vel = 0.0;
	
	self.misc_action = 0;
	self.flags = FL_CLIENT;
	self.effects = 0;
	self.deadflag = DEAD_NO;
	
	self.th_pain = A_PlayerPain;
	self.th_die = A_PlayerDie;
	
	// So many timers...
	
	ResetAir(self);
	
	DecodeLevelParms(self);
	
	// If we're currently in an intermission, force the player into the intermission
	// state and send over the finale text if needed
	if (newest_client == self)
	{
		newest_client = world;
		
		if (starting_info)
			SetStartingGear(self);
		
		if (map_sky)
			UpdateClientSky(self);
		if (map_fog)
			UpdateClientFog(self);
		
		if (intermission_active)
		{
			SetIntermissionMode(self, intermission_pos);
			
			entity curMsg = msg_entity;
			msg_entity = self;
			if (intermission_text)
			{
				WriteUInt8(MSG_ONE, SVC_FINALE);
				WriteString(MSG_ONE, intermission_text);
			}
			else
			{
				WriteUInt8(MSG_ONE, SVC_INTERMISSION);
			}
			msg_entity = curMsg;
			
			return;
		}
	}
	
	entity pos = SelectSpawnPoint();
	self.angles = pos.angles;
	self.fixangle = TRUE;
	self.velocity = self.avelocity = VEC_ZERO;
	self.origin = pos.origin + [0.0, 0.0, 1.0];
	SetPhysics(self, SOLID_SLIDEBOX, MOVETYPE_WALK);
	InitializeEntity(self, "progs/player.mdl", AABB_MIN, AABB_MAX);

	A_SetWeapon(self.current_slot);
	S_PlayerStand1();
	
	if (IsOnline())
	{
		SetLocalAxes([0.0, self.angles.y, 0.0]);
		SpawnTeleportFog(self.origin + v_forward * 20.0);
	}

	SpawnTeleportDeath(self, self.origin);
}
