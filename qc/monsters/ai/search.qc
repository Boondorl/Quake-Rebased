
inline bool_t IsTargetable(entity e)
{
	return !(e.flags & FL_NOTARGET) && GetItemAmount(e, IT_INVIS) < 1;
}

bool_t IsInFront(entity e, entity targ, float range = 60.0)
{
	vector diff = Diff2D(e.origin, targ.origin);
	if (!diff)
		return TRUE;
	
	return AbsF(NormalizeAngle180(Atan2(diff) - self.angles.y)) <= range;
}

// Do all of these checks now so it doesn't interrupt searching for
// a regular player if the hostile monster isn't valid
entity GetEnemyFromMonster(entity e, entity monst)
{
	if (!IsClient(monst.enemy) || !IsTargetable(monst.enemy))
		return world;
	
	float dist = GetRange(e, monst);
	if (dist > RANGE_FAR || !IsInFront(e, monst) || !IsVisible(e, monst))
		return world;
	
	return monst.enemy;
}

const int_t MONSTER_AMBUSH = 3; // For some reason this is a combined flag

bool_t A_FindEnemy()
{
	entity client;
	if (!TimerExpired(hostile_monster_time) && !(self.spawnflags & MONSTER_AMBUSH))
		client = GetEnemyFromMonster(self, hostile_monster);
	
	if (!client)
		client = A_FindNewClientEnemy();
	
	if (client == self.enemy || !IsValidEnemy(client) || !IsTargettable(client))
		return FALSE;

	float dist = GetRange(self, client);
	if (dist > RANGE_FAR)
	{
		return FALSE;
	}
	else if (dist > RANGE_MID)
	{
		if (TimerExpired(client.show_hostile) || !IsInFront(self, client))
			return FALSE;
	}
	else if (dist > RANGE_MELEE && !IsInFront(self, client))
	{
		return FALSE;
	}
	
	if (!IsVisible(self, client))
		return FALSE;
	
	entity curEnemy = self.enemy;
	SetEnemy(client);
	if (!curEnemy)
		A_WakeUp();
	
	return TRUE;
}

void A_WakeUp()
{
	// Unlike the original, only update this if the time
	// has expired to prevent weird chaining issues
	if (TimerExpired(hostile_monster_time))
	{
		hostile_monster = self;
		hostile_monster_time = time + 0.1;
	}
	
	SetCoolDown(self, attack_finished, 1.0); // wait a while before first attack
	self.th_run();
}
