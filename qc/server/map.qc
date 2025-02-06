void NextLevel()
{
	// Always reset the inv when going back to and leaving the hub. This gets around
	// needing to give the player a rune to emulate this behavior and players should
	// always get a fresh start when entering a new episode
	if (deathmatch || (!(server_state & SV_OVERRIDE_VANILLA) && (next_map == "start" || mapname == "start")))
		server_state |= ST_RESET_INV;
	
	// if samelevel is set, stay on same level
	if (deathmatch && GetCVarF("samelevel"))
		ChangeLevel(mapname);
	else if (next_map)
		ChangeLevel(next_map);
}

void CycleLevel()
{
	// find a trigger changelevel
	entity cl = mapname == "start" ? world : FindEntity(world, classname, "trigger_changelevel");
	if (!cl)
	{
		// go back to same map if no trigger_changelevel
		cl = SpawnEntity();
		cl.map = mapname;
	}

	next_map = cl.map;
	SetNextThink(cl, 0.1, StartIntermission);
}

entity FindIntermission()
{
	// look for info_intermission first
	entity pos = FindEntity(world, classname, "info_intermission");
	if (pos)
	{
		// pick a random one
		for (int_t r = RandomI(4); r >= 1; --r)
		{
			pos = FindEntity(pos, classname, "info_intermission");
			if (!pos)
				pos = FindEntity(world, classname, "info_intermission");
		}
		
		return pos;
	}

	// Then look for the start position
	pos = FindEntity(world, classname, "info_player_start");
	if (!pos)
		ThrowAbortException("No end-of-level info_intermission entity found");
	
	return pos;
}

void SetIntermissionMode(entity client, vector orig, angles_t angs)
{
	ClearInventory(client);
	ClearThink(client);
	ClearWeapon(client);
	
	client.view_ofs = VEC_ZERO;
	client.angles = angs;
	client.fixangle = TRUE;
	client.takedamage = DAMAGE_NO;
	client.velocity = client.avelocity = VEC_ZERO;
	
	client.origin = orig;
	SetPhysics(client, SOLID_NOT, MOVETYPE_NONE);
	InitializeEntity(client);
}

void StartIntermission(uint8_t track = 3, string nextText = __NULL__, uint8_t nextTrack = 0)
{
	// Enforce a wait time before allowing changelevel
	intermission_active = 1;
	intermission_time = time + (deathmatch ? 5.0 : 2.0);
	intermission_text = __NULL__;
	
	next_intermission_text = nextText;
	next_intermission_track = nextTrack;

	intermission_pos = FindIntermission();
	for (entity p = NextEntity(world); IsClient(p); p = NextEntity(p))
		SetIntermissionMode(p, intermission_pos.morigin, intermission_pos.mangles);
	
	WriteUInt8(MSG_ALL, SVC_INTERMISSION);
	ChangeMusic(track);
}

void AdvanceIntermission()
{
	// Skip any text in deathmatch
	if (deathmatch)
	{
		NextLevel();
		return;
	}

	// Wait at least a second before allowing skip to the next level
	intermission_time = time + 1.0;
	++intermission_active;
	
	// Check for vanilla texts, but only if the map isn't currently overriding it
	if (!(server_state & SV_OVERRIDE_VANILLA) && !next_intermission_text)
	{
		if (intermission_active == 2)
		{
			if (world.model == "maps/e1m7.bsp")
				next_intermission_text = FIN_EP1;
			else if (world.model == "maps/e2m6.bsp")
				next_intermission_text = FIN_EP2;
			else if (world.model == "maps/e3m6.bsp")
				next_intermission_text = FIN_EP3;
			else if (world.model == "maps/e4m7.bsp")
				next_intermission_text = FIN_EP4;
		
			if (next_intermission_text)
				next_intermission_track = 2;
		}
		else if (intermission_active == 3 && (serverflags & RUNE_ALL))
		{
			next_intermission_text = FIN_RUNES;
			next_intermission_track = 2;
		}
	}
	
	intermission_text = next_intermission_text;
	uint8_t nextSong = next_intermission_track;
	
	// Check for a "got 'em all" secondary message
	if (intermission_active == 2 && world.MacGuffinInventory && (serverflags & world.MacGuffinInventory))
	{
		next_intermission_text = world.obituary;
		next_intermission_track = world.count;
	}
	else
	{
		next_intermission_text = __NULL__;
		next_intermission_track = 0;
	}
	
	// Still have text we need to print, so don't change just yet
	if (intermission_text)
	{
		WriteUInt8(MSG_ALL, SVC_FINALE);
		WriteString(MSG_ALL, intermission_text);
		ChangeMusic(nextSong);
		
		return;
	}

	NextLevel();
}

void P_ChangeLevelTouch()
{
	// Don't allow death exits in multiplayer
	if (!IsClient(other) || (IsOnline() && other.health < 1))
		return;

	if (deathmatch && GetCVarF("noexit"))
	{
		DamageEntity(other, self, world, TELEFRAG_DAMAGE, DMG_FORCE);
		return;
	}
	
	BroadcastPrint(LVL_PRE_EXIT, other.netname, LVL_SUF_EXIT, "\n");
	
	next_map = self.map;
	self.touch = __NULL__;
	ActivateEntity(self, other);

	if ((self.spawnflags & LVL_NO_INTERMISSION) && !deathmatch)
	{
		NextLevel();
		return;
	}

	SetNextThink(self, 0.1, F_StartIntermission);
}

void F_StartIntermission()
{
	if (self.spawnflags & LVL_RESET_INV)
		server_state |= SV_RESET_INV;
	
	StartIntermission(self.sounds, self.obituary, self.count);
}

enumflags
{
	LVL_NO_INTERMISSION,
	LVL_RESET_INV,
};

void trigger_changelevel()
{
	if (!self.map)
		A_ThrowEntityError("No map set");
	
	if (!HasObituary(self))
	{
		self.obituary_prefix = OBIT_PRE_EXIT;
		self.obituary_suffix = OBIT_SUF_EXIT;
	}
	if (!self.damage_type)
		self.damage_type = "telefrag";
	if (!self.sounds)
		self.sounds = 3;
	
	self.touch = P_ChangeLevelTouch;
	
	StartTrigger(self);
}
