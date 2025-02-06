/*
	A_MoveToGoal notes:
		-If enemy is non-null, doesn't do anything if in range of goalentity
		-Updates ideal_yaw and calls changeyaw
		-If successful, doesn't move if not turned enough towards ideal_yaw
		-If failed, tries to change move direction towards goalentity
			-If successful, does the same behavior with ideal_yaw as above
			
	A_TryMove notes:
		-Raises and lowers flying/swimming monsters towards enemy
*/

void P_PathCornerTouch()
{
	if (!IsMonster(other) || other.goalentity != self)
		return;

	if (other.th_dest)
		InvokeAsSelf(other, other.th_dest);

	// Dormant path nodes will be ignored, allowing path switching
	// if needed
	entity next;
	do
	{
		next = FindEntity(next, targetname, self.target);
	} while (next && IsDormant(next));
	
	other.goalentity = next;
	if (!other.goalentity)
	{
		// TODO: WHY IS THIS LOGIC SO HARD
		// Just in case someone wants to explicitly set the yaw still
		if (self.misc)
		{
			other.ideal_yaw = self.angles.y;
			if (!(other.spawnflags & MONSTER_WANDER))
				other.pausetime = FLT_MAX;
		}
		
		// Go free, my children!
		if (other.pausetime != FLT_MAX)
			SetState(other, other.th_stand);
	}
	else if (self.pausetime >= 0.0)
	{
		// Let them admire the scenary for a bit before moving on
		SetCoolDown(other, pausetime, self.pausetime);
		if (self.misc_action)
			other.ideal_yaw = self.angles.y;
		else
			SetState(other, th_stand);
	}
	
	// Let monsters reaching destinations set off events
	ActivateEntity(self, other, TRUE);
}

void path_corner()
{
	if (!self.targetname)
		A_ThrowEntityException("No targetname given");

	self.touch = P_PathCornerTouch;
	
	SetPhysics(self, SOLID_TRIGGER, MOVETYPE_NONE);
	InitializeEntity(self, __NULL__, [-8.0, -8.0, -8.0], [8.0, 8.0, 8.0]);
}

// Accounts for desynched enemy/goal navigation as well as 3D movement
// in those cases if desired
bool_t MoveMonsterToGoal(entity e, float dist)
{
	bool_t desynched = e.goalentity != e.enemy;
	entity curEnemy = e.enemy;
	if (desynched)
		e.enemy = world;
	
	// Since this function doesn't have a valid return value, this
	// check will have to do
	vector curOrig = e.origin;
	float curYaw = e.angles.y;
	
	A_MoveToGoal(dist);
	bool_t res = curOrig != self.origin || curYaw != e.angles.y;
	
	if (desynched && e.goalentity
		&& (e.flags & (FL_FLY | FL_SWIM)) && (e.spawnflags & MONSTER_PATH_3D))
	{
		e.enemy = e.goalentity;
		A_TryMove(0.0, 0.0);
	}
	
	e.enemy = curEnemy;
	return res;
}

// Tries to stay level with its goalentity if needed. Also allows
// forcing 2D only movement
bool_t A_Move(float dist, float yawOfs = 0.0, bool_t noZ = FALSE)
{
	entity curEnemy = self.enemy;
	if (noZ)
		self.enemy = world;
	else if (self.spawnflags & MONSTER_PATH_3D)
		self.enemy = self.goalentity;
	
	bool_t res = A_TryMove(self.angles.y + yawOfs, dist);
	
	self.enemy = curEnemy;
	return res;
}

void A_Walk(float dist)
{
	if (self.pausetime >= 0.0)
	{
		A_FaceIdealYaw();
		if (self.angles.y == self.ideal_yaw)
			self.th_stand();
		else
			A_FindEnemy();
		
		return;
	}
	
	if (A_FindEnemy())
		return;

	MoveMonsterToGoal(self, dist);
}

void A_Stand()
{
	if (self.pausetime >= 0.0 && (!self.pausetime || TimerExpired(self.pausetime)))
	{
		self.pausetime = -1.0;
		self.th_walk();
		return;
	}
	
	A_FindEnemy();
}
