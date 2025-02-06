inline bool_t IsFacingIdealYaw(entity e, float range = 45.0)
{
	return AbsF(NormalizeAngle180(e.ideal_yaw - e.angles.y)) <= range;
}

inline float GetRange(entity e, entity targ)
{
	return Length(GetViewPos(targ) - GetViewPos(e));
}

enumflags
{
	VIS_CHECK_MONSTERS,
	VIS_IGNORE_LIQUID,
	VIS_CHECK_INVIS,
};

bool_t IsVisible(entity e, entity targ, flags_t visFlags = 0)
{
	if ((visFlags & VIS_CHECK_INVIS) && !IsTargettable(e))
		return FALSE;
		
	int_t clipType = (visFlags & VIS_CHECK_MONSTERS) ? MOVE_NORMAL : MOVE_NOMONSTERS;
	TraceLine(GetViewPos(e), GetViewPos(targ), clipType, e);
	if (!(visFlags & VIS_IGNORE_LIQUID) && trace_inopen && trace_inwater)
		return FALSE;

	return trace_fraction == 1.0 || trace_ent == targ;
}

// Generic function for determining attack chance. Should only be
// replaced if special checks have to be accounted for
bool_t A_CheckAttack()
{
	if (!IsVisible(self, self.enemy, VIS_CHECK_MONSTERS))
		return FALSE;

	float range = GetRange(self, self.enemy);
	// Melee attack
	if (range <= RANGE_MELEE && self.th_melee)
	{
		self.attack_state = AS_MELEE;
		return TRUE;
	}

	// Missile attack
	if (range > RANGE_FAR || !self.th_missile || !TimerExpired(self.attack_finished))
		return FALSE;

	float chance;
	if (range <= RANGE_MELEE)
		chance = 0.9;
	else if (range <= RANGE_MID)
		chance = self.th_melee ? 0.2 : 0.4;
	else
		chance = self.th_melee ? 0.05 : 0.1;

	if (Random() < chance)
	{
		if (skill < SK_NIGHTMARE)
			SetCoolDown(self, attack_finished, 2.0 * Random());
		
		self.attack_state = AS_MISSILE;
		return TRUE;
	}

	return FALSE;
}

void A_Run(float dist)
{
	if (!IsValidEnemy(self.enemy))
	{
		entity old = self.old_enemy;
		ClearEnemy(self);
		if (IsValidEnemy(old))
		{
			SetEnemy(old);
		}
		else
		{
			if (self.goalentity || (self.spawnflags & MONSTER_WANDER))
				self.th_walk();
			else
				self.th_stand();
			
			return;
		}
	}

	bool_t visible = IsVisible(self, self.enemy);
	if (visible)
		SetCoolDown(self, search_time, 5.0);
	else if (coop && TimerExpired(self.search_time) && A_FindEnemy())
		return;
	
	// Already started an attack, so try and 
	if (self.attack_state == AS_MISSILE || self.attack_state == MS_MELEE
		|| (visible && self.th_atkcheck()))
	{
		A_AttackTurn();
		return;
	}

	if (self.attack_state == AS_SLIDING)
		A_Strafe(dist);
	else
		MoveMonsterToGoal(self, dist);
}

void A_AttackTurn()
{
	A_Face();
	if (!IsFacingIdealYaw(self))
		return;
	
	if (self.attack_state == AS_MELEE)
		self.th_melee();
	else
		self.th_missile();
	
	self.attack_state = AS_STRAIGHT;
}

void A_Strafe(float dist)
{
	A_Face();
	
	bool_t lefty = (self.misc_action & MON_STRAFE_LEFT);
	float ofs = -90.0;
	if (lefty)
		ofs = -ofs;

	entity curEnemy = self.enemy;
	if (self.spawnflags & MONSTER_PATH_3D)
		self.enemy = self.goalentity;
	if (!A_TryMove(self.ideal_yaw + ofs, dist))
	{
		if (lefty)
			self.misc_action &= ~MON_STRAFE_LEFT;
		else
			self.misc_action |= MON_STRAFE_LEFT;
		
		A_TryMove(self.ideal_yaw - ofs, dist);
	}
	self.enemy = curEnemy;
}
