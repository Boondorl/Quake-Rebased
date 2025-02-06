// For common global behaviors needed for gameplay

// General

// Mainly for projectiles
void PrecacheEntity(void() type)
{
	entity e = SpawnEntity();
	SET_CLASSNAME(e, type);
	InvokeAsSelf(e, type);
	DestroyEntity(e);
}

inline bool_t MapLoading()
{
	return time < 0.2;
}

inline float MetersToUnits(float m)
{
	return m * METER;
}

inline float UnitsToMeters(float u)
{
	return u * INVERSE_METER;
}

inline bool_t TimerExpired(float checkTime, float ofs = 0.0)
{
	return checkTime <= time + ofs + TIME_EPSILON;
}

inline bool_t HasFlags(flags_t flags, int_t flagBits)
{
	return (flags & flagBits) == flagBits;
}

inline bool_t IsOnline()
{
	return deathmatch || coop;
}

inline void FixedLocalAxes(angles_t angs)
{
	SetLocalAxes([-angs.x, angs.y, angs.z]);
}

inline void AxesFromVec(vector dir)
{
	angles_t angs = ToAngles(dir);
	SetLocalAxes([-angs.x, angs.y, angs.z]);
}

void InvokeAsSelf(entity e, void() func)
{
	entity curSelf = self;
	self = e;
	func();
	self = curSelf;
}

float InvokeWithResult(entity e, float() func)
{
	entity curSelf = self;
	self = e;
	float res = func();
	self = curSelf;
	return res;
}

void InvokeActivation(entity e, entity act, void() func)
{
	entity curAct = e.activator;
	e.activator = act;
	InvokeAsSelf(e, func);
	e.activator = curAct;
}

// Since this modifies world.sounds directly it'll automatically get sent
// over the network by the server so no need to target specific clients
void ChangeMusic(uint8_t track)
{
	if (track == world.sounds || track < 2)
		return;
	
	*current_song = track;
	
	WriteUInt8(MSG_ALL, SVC_CDTRACK);
	WriteUInt8(MSG_ALL, track);
	WriteUInt8(MSG_ALL, TRUE);
}

// For storing trace data locally instead of relying on the globals
enumflags
{
	TR_ALL_SOLID,
	TR_START_SOLID,
	TR_AIR,
	TR_WATER,
};

typedef struct
{
	flags_t Info;
	float Fraction;
	entity HitEnt;
	float HitPlaneDist;
	vector HitPlaneNormal;
	vector HitPos;
} trace_t;

void GetTraceResults(vector orig, vector dest, int_t clipType, entity ignore, __out trace_t res)
{
	TraceLine(orig, dest, clipType, ignore);
	
	res.Fraction = trace_fraction;
	res.HitEnt = trace_ent;
	res.HitPos = trace_endpos;
	res.HitPlaneNormal = trace_plane_normal;
	res.HitPlaneDist = trace_plane_dist;
	
	res.Info = (TR_ALL_SOLID * trace_allsolid)
				| (TR_START_SOLID * trace_startsolid)
				| (TR_AIR * trace_inopen)
				| (TR_WATER * trace_inwater);
}

// Simple way to send a center print to every player in the game (useful for puzzles and story bits)
void BroadcastCenterPrint(string msg1, optional string msg2, optional string msg3, optional string msg4, optional string msg5, optional string msg6, optional string msg7, optional string msg8)
{
	for (entity p = NextEntity(world); IsClient(p); p = NextEntity(p))
		CenterPrint(p, msg1, msg2, msg3, msg4, msg5, msg6, msg7, msg8);
}

// Entity

entity SpawnEntityType(void() type, vector orig = [0.0, 0.0, 0.0], flags_t spawnFlags = 0)
{
	entity e = SpawnEntity();
	e.origin = orig; // This will get linked in its spawn function if it needs to be
	e.spawnflags = spawnFlags;
	SET_CLASSNAME(e, type);
	InvokeAsSelf(e, type);
	
	return e;
}

inline bool_t IsDestroyed(entity e)
{
	return (e.flags & FL_FREED);
}

// Use this instead of RemoveEntity() directly. Unsets whatever pointer is passed
// in so it gets correctly nulled after being removed. Note that this only
// unsets it locally as the VM has no garbage collection phase, so be sure to
// unset it elsewhere where necessary
void DestroyEntity(__inout entity e)
{
	if (IsDestroyed(e))
		return;
	
	e.flags |= FL_FREED;
	e.touch = e.blocked = __NULL__;
	e.use = __NULL__;
	if (e.destructible)
		DestroyEntity(e.destructible);
	
	if (e.flags & FL_MONSTER)
	{
		if (e.flags & FL_COUNT_MONSTER)
			--total_monsters;
		else if (HasFlags(e.spawnflags, MONSTER_SPAWNER | MONSTER_COUNT_TOTAL) && count >= 1)
			total_monsters -= count;
	}
	else if (e.solid == SOLID_TRIGGER && (e.flags & FL_COUNT_SECRET))
	{
		--total_secrets;
	}
	
	RemoveEntity(e);
	e = world;
}

void InitializeEntity(entity e, string mod = __NULL__, vector min = [0.0, 0.0, 0.0], vector max = [0.0, 0.0, 0.0])
{
	if (e.solid == SOLID_BSP)
	{
		SetModel(e, e.model);
	}
	else
	{
		if (!mod)
			ClearModel(e);
		else
			SetModel(e, mod);
		
		SetSize(e, min, max);
	}
}

// Allows for looping animations to properly loop their frames. If starting outside
// of the bounds of the animation, it'll always loop back to the start.
uint8_t AdvanceFrame(uint8_t curFrame, uint8_t start, uint8_t end)
{
	curFrame = Clamp(curFrame, start - 1, end) + 1;
	if (curFrame > end)
		curFrame = start;
	
	return curFrame;
}

void A_ActivateDelayedUse()
{
	ActivateEntity(self, self.enemy);
	DestroyEntity(self);
}

void DelayedUse() {}

inline void CopyActionData(entity e, entity from)
{
	e.noise = from.noise;
	e.message = from.message;
	e.killtarget = from.killtarget;
	e.target = from.target;
	e.target2 = from.target2;
	e.target3 = from.target3;
	e.target4 = from.target4;
}

void ActivateEntity(entity e, entity activator)
{
	// check for a delay
	if (e.delay > 0.0)
	{
		// create a temp object to fire at a later time
		entity timer = SpawnEntityType(DelayedUse, VEC_ZERO, (e.spawnflags & SPAWNFLAGS_GLOBAL_MESSAGE));
		timer.owner = e;
		timer.enemy = activator;
		CopyActionData(timer, e);
		SetNextThink(timer, e.delay, A_ActivateDelayedUse);
		
		return;
	}
	
	if (e.message)
	{
		// Allow messages to be printed globally if desired
		if (e.spawnflags & SPAWNFLAGS_GLOBAL_MESSAGE)
		{
			BroadcastCenterPrint(e.message);
			if (!e.noise)
				PlaySound(activator, CHAN_AUTO, SND_MESSAGE, 1.0, ATTN_NONE);
		}
		else if (IsClient(activator))
		{
			CenterPrint(activator, e.message);
			if (!e.noise)
				PlaySound(activator, CHAN_AUTO, SND_MESSAGE, 1.0, ATTN_NORM);
		}
	}

	// Remove the killtargets
	if (e.killtarget)
	{
		for (entity temp = FindEntity(world, targetname, e.killtarget); temp;)
		{
			entity next = FindEntity(temp, targetname, e.killtarget);
			DestroyEntity(temp);
			temp = next;
		}
	}

	// Activate targets
	if (e.target || e.target2 || e.target3 || e.target4)
	{
		// Do this in one big loop instead of 4 individual ones
		for (entity temp = NextEntity(world); temp;)
		{
			entity next = NextEntity(temp);
			if (temp.use && CheckTargetName(temp, e))
				InvokeActivation(temp, activator, temp.use);
			
			temp = next;
		}
	}
}

// These enforce physics correctness within the engine to prevent possible
// breakage from occurring due to mismatched move and solid types
void SetSolid(entity e, int_t type)
{
	if (type == SOLID_BSP)
		e.movetype = MOVETYPE_PUSH;
	else if (e.movetype == MOVETYPE_PUSH)
		e.movetype = MOVETYPE_NOCLIP;
	
	e.solid = type;
	SetOrigin(e, e.origin);
}

void SetMoveType(entity e, int_t type)
{
	e.movetype = type;
	if (e.movetype == MOVETYPE_PUSH)
	{
		if (e.solid != SOLID_BSP)
		{
			e.solid = SOLID_BSP;
			SetOrigin(e, e.origin);
		}
	}
	else if (e.solid == SOLID_BSP)
	{
		e.solid = SOLID_NOT;
		SetOrigin(e, e.origin);
	}
}

void SetPhysics(entity e, int_t solidType, int_t moveType, bool_t relink = 0)
{
	if (solidType == SOLID_BSP)
		moveType = MOVETYPE_PUSH;
	else if (moveType == MOVETYPE_PUSH)
		solidType = SOLID_BSP;
	
	e.solid = solidType;
	e.movetype = moveType;
	if (relink)
		SetOrigin(e, e.origin);
}

inline bool_t CheckTargetName(entity e, entity caller)
{
	return e.targetname == caller.target || e.targetname == caller.target2
			|| e.targetname == caller.target3 || e.targetname == caller.target4;
}

inline void SetState(entity e, void() state)
{
	InvokeAsSelf(e, state);
}

inline bool_t IsClient(entity e)
{
	return (e.flags & FL_CLIENT);
}

inline bool_t IsMonster(entity e)
{
	return (e.flags & FL_MONSTER);
}

inline bool_t IsItem(entity e)
{
	return (e.flags & FL_ITEM);
}

inline bool_t IsMissile(entity e)
{
	return (e.flags & FL_MISSILE);
}

inline bool_t IsThinking(entity e)
{
	return e.nextthink > 0.0;
}

inline void SetNextThinkTime(entity e, float addTime)
{
	e.nextthink = GET_TIME(e) + addTime;
}

inline void SetNextThink(entity e, float addTime, void() func)
{
	e.think = func;
	e.nextthink = GET_TIME(e) + addTime;
}

inline vector GetViewPos(entity e)
{
	return e.origin + e.view_ofs;
}

inline vector GetCenter(entity e)
{
	return (e.absmin + e.absmax) * 0.5;
}

inline bool_t HasObituary(entity e)
{
	return e.obituary_prefix || e.obituary_suffix;
}

inline void SetCoolDown(entity e, .float timer, float addTime)
{
	e.timer = time + addTime;
}

inline void ClearModel(entity e)
{
	e.model = __NULL__;
	e.modelindex = 0;
}

inline bool_t IsDormant(entity e)
{
	return (e.spawnflags & SPAWNFLAG_DORMANT);
}

inline void ClearActivationData(entity e)
{
	e.target = e.target2 = e.target3 = e.target4 = __NULL__;
	e.killtarget = __NULL__;
	e.message = __NULL__;
	e.delay = 0.0;
}

void PrintObituary(entity killer, entity client)
{
	if (!HasObituary(killer))
	{
		BroadcastPrint(OBIT_PRE_GENERIC, client.netname, OBIT_SUF_GENERIC, "\n");
		return;
	}
	
	BroadcastPrint(killer.obituary_prefix, client.netname, killer.obituary_suffix, "\n");
}

void PrintPlayerObituary(entity killer, entity client, uint_t weap)
{
	if (!IsValidWeapon(weap))
	{
		if (killer == client)
			BroadcastPrint(OBIT_PRE_SELF_GENERIC, client.netname, OBIT_SUF_SELF_GENERIC, "\n");
		else if (REVERSE_OBIT_CLIENTS || ALWAYS_REVERSE_OBIT_CLIENTS)
			BroadcastPrint(OBIT_PRE_CLIENT_GENERIC, killer.netname, OBIT_CLIENT_GENERIC, client.netname, OBIT_SUF_CLIENT_GENERIC, "\n");
		else
			BroadcastPrint(OBIT_PRE_CLIENT_GENERIC, client.netname, OBIT_CLIENT_GENERIC, killer.netname, OBIT_SUF_CLIENT_GENERIC, "\n");
		
		return;
	}
	
	if (killer == client)
	{
		string prefix = Weapons[weap].self_obituary_prefix;
		string suffix = Weapons[weap].self_obituary_suffix;
		
		if (!prefix && !suffix)
		{
			BroadcastPrint(OBIT_PRE_SELF_GENERIC, client.netname, OBIT_SUF_SELF_GENERIC, "\n");
			return;
		}
		
		BroadcastPrint(prefix, client.netname, suffix, "\n");
	}
	else
	{
		string prefix = Weapons[weap].obituary_prefix;
		string middle = Weapons[weap].obituary_middle;
		string suffix = Weapons[weap].obituary_suffix;
		
		if (!prefix && !middle && !suffix)
		{
			if (REVERSE_OBIT_CLIENTS || ALWAYS_REVERSE_OBIT_CLIENTS)
				BroadcastPrint(OBIT_PRE_CLIENT_GENERIC, killer.netname, OBIT_CLIENT_GENERIC, client.netname, OBIT_SUF_CLIENT_GENERIC, "\n");
			else
				BroadcastPrint(OBIT_PRE_CLIENT_GENERIC, client.netname, OBIT_CLIENT_GENERIC, killer.netname, OBIT_SUF_CLIENT_GENERIC, "\n");
			
			return;
		}
		
		if (ALWAYS_REVERSE_OBIT_CLIENTS || (Weapons[weap].flags & WP_REVERSE_NAMES))
			BroadcastPrint(prefix, killer.netname, middle, client.netname, suffix, "\n");
		else
			BroadcastPrint(prefix, client.netname, middle, killer.netname, suffix, "\n");
	}
}

void ClearThink(entity e)
{
	e.nextthink = 0.0;
	if (e.movetype == MOVETYPE_PUSH)
		e.velocity = VEC_ZERO;
}

bool_t CanSpawn(entity e)
{
	if ((deathmatch && IsMonster(e))
		|| (coop && (e.spawnflags & SPAWNFLAG_NOTINCOOP))
		|| (!coop && (e.spawnflags & SPAWNFLAG_COOPONLY)))
	{
		RemoveEntity(e);
		return FALSE;
	}
	
	return TRUE;
}

// Actions
void A_Remove()
{
	DestroyEntity(self);
}

void A_Null() {} // Intentionally does nothing; made to be set from the map editor for specific events

// Quakespasm helpers

void ChangeSky(string sky)
{
	if (sky == map_sky)
		return;
	
	map_sky = sky;
	WriteUInt8(MSG_ALL, SVC_SKY);
	WriteString(MSG_ALL, sky);
}

void UpdateClientSky(entity client)
{
	entity curMsg = msg_entity;
	msg_entity = client;
	
	WriteUInt8(MSG_ONE, SVC_SKY);
	WriteString(MSG_ONE, map_sky);
	
	msg_entity = curMsg;
}

void ChangeFog(vector color, float density, float fadeDur)
{
	if (color == map_fog && density == map_fog_density)
		return;
	
	map_fog = color;
	map_fog_density = density;
	
	WriteUInt8(MSG_ALL, SVC_FOG);
	WriteUInt8(MSG_ALL, Round(density * 255));
	WriteUInt8(MSG_ALL, Round(color.x * 255));
	WriteUInt8(MSG_ALL, Round(color.y * 255));
	WriteUInt8(MSG_ALL, Round(color.z * 255));
	
	fadeDur = Max(fadeDur, 0.0);
	WriteInt16(MSG_ALL, fadeDur * 100.0);
}

void UpdateClientFog(entity client)
{
	entity curMsg = msg_entity;
	msg_entity = client;
	
	WriteUInt8(MSG_ONE, SVC_FOG);
	WriteUInt8(MSG_ONE, Round(map_fog_density * 255));
	WriteUInt8(MSG_ONE, Round(map_fog.x * 255));
	WriteUInt8(MSG_ONE, Round(map_fog.y * 255));
	WriteUInt8(MSG_ONE, Round(map_fog.z * 255));
	WriteInt16(MSG_ONE, 0.0); // Since they just joined switch it over immediately
	
	msg_entity = curMsg;
}
