/*
=============================================================================

SECRET DOORS

=============================================================================
*/

void F_SecretDoorUse()
{
	if (self.state != FUNC_DEACTIVED || IsDormant(self))
		return;

	self.message = __NULL__;
	self.state = FUNC_ACTIVATING;
	self.takedamage = DAMAGE_NO;

	PlaySound(self, CHAN_BODY, self.noise1, 1.0, ATTN_NORM);
	
	ActivateEntity(self, self.activator);
	
	SetNextThink(self, 1.0, F_ActivateSecretDoor);
}

void F_ActivateSecretDoor()
{
	PlaySound(self, CHAN_BODY, self.noise2, 1.0, ATTN_NORM);
	
	F_CalcMove(self.pos2, self.speed, F_SecretDoorOpenDest);
}

// Wait after first movement...
void F_SecretDoorOpenDest()
{
	PlaySound(self, CHAN_BODY, self.noise3, 1.0, ATTN_NORM);
	
	SetNextThink(self, 1.0, F_SecretDoorReveal);
}

// Start moving sideways w/sound...
void F_SecretDoorReveal()
{
	PlaySound(self, CHAN_BODY, self.noise2, 1.0, ATTN_NORM);
	
	F_CalcMove(self.pos3, self.speed, F_SecretDoorReachedEnd);
}

// Wait here until time to go back...
void F_SecretDoorReachedEnd()
{
	PlaySound(self, CHAN_BODY, self.noise3, 1.0, ATTN_NORM);
	self.state = FUNC_ACTIVATED;
	
	if (self.wait > 0.0)
		SetNextThink(self, self.wait, F_DeactivateSecretDoor);
}

// Move backward...
void F_DeactivateSecretDoor()
{
	PlaySound(self, CHAN_BODY, self.noise2, 1.0, ATTN_NORM);
	
	self.state = FUNC_DEACTIVATING;
	
	F_CalcMove(self.pos2, self.speed, F_SecretDoorRetractDest);
}

// Wait 1 second...
void F_SecretDoorRetractDest()
{
	PlaySound(self, CHAN_BODY, self.noise3, 1.0, ATTN_NORM);
	
	SetNextThink(self, 1.0, F_SecretDoorClose);
}

void F_SecretDoorClose()
{
	PlaySound(self, CHAN_BODY, self.noise2, 1.0, ATTN_NORM);
	
	F_CalcMove(self.pos1, self.speed, F_SecretDoorReachedStart);
}

void F_SecretDoorReachedStart()
{
	PlaySound(self, CHAN_BODY, self.noise3, 1.0, ATTN_NORM);
	
	self.state = FUNC_DEACTIVATED;
	if (self.health)
		self.takedamage = DAMAGE_USE;
}

void P_SecretDoorBlocked()
{
	if (!TimerExpired(self.attack_finished))
		return;
	
	SetCoolDown(self, attack_finished, 0.5);
	DealDamageType(damage_crush, other, self.dmg);
}

void P_SecretDoorTouch()
{
	if (!IsValidClient(other) || !TimerExpired(self.attack_finished))
		return;

	SetCoolDown(self, attack_finished, 2.0);
	
	CenterPrint(other, self.message);
	PlaySound(other, CHAN_VOICE, SND_TALK, 1.0, ATTN_NORM);
}

enum int_t
{
	SSND_MEDIEVAL = 1,
	SSND_METAL,
	SSND_BASE,
}

enumflags
{
	SECRET_OPEN_ONCE, // stays open
	SECRET_1ST_LEFT, // 1st move is left of arrow
	SECRET_1ST_DOWN, // 1st move is down from arrow
	SECRET_YES_SHOOT = 1 << 4, // shootable even if targeted
}

void func_door_secret()
{
	if (!self.dmg)
		self.dmg = 2;
	if (!self.wait)
		self.wait = 5.0;
	if (self.speed <= 0.0)
		self.speed = 50.0;
	if (!self.sounds)
		self.sounds = SSND_BASE;
	
	if (self.sounds == SSND_MEDIEVAL)
	{
		self.noise1 = "doors/latch2.wav";
		self.noise2 = "doors/winch2.wav";
		self.noise3 = "doors/drclos4.wav";
	}
	else if (self.sounds == SSND_METAL)
	{
		self.noise2 = "doors/airdoor1.wav";
		self.noise1 = "doors/airdoor2.wav";
		self.noise3 = "doors/airdoor2.wav";
	}
	else if (self.sounds == SSND_BASE)
	{
		self.noise2 = "doors/basesec1.wav";
		self.noise1 = "doors/basesec2.wav";
		self.noise3 = "doors/basesec2.wav";
	}
	
	PrecacheSound(self.noise1);
	PrecacheSound(self.noise2);
	PrecacheSound(self.noise3);
	
	self.blocked = P_SecretDoorBlocked;
	self.use = F_SecretDoorUse;
	if (self.message)
		self.touch = P_SecretDoorTouch;

	self.state = FUNC_DEACTIVATED;
	if (!self.targetname || (self.spawnflags & SECRET_YES_SHOOT))
	{
		self.health = 1;
		self.takedamage = DAMAGE_USE;
	}
	
	// All of this got moved into here because there's really no need to
	// recalculate this every time it's used...
	
	SetLocalAxes(self.angles);
	
	if (self.spawnflags & SECRET_OPEN_ONCE)
		self.wait = -1.0;

	// Allow manual movement as well
	float length = self.distance ? self.distance : AbsF(v_forward * self.size);
	float width = self.lip;
	if (!width)
	{
		if (self.spawnflags & SECRET_1ST_DOWN)
			width = AbsF(v_up * self.size);
		else
			width = AbsF(v_right * self.size) * (1 - !!(self.spawnflags & SECRET_1ST_LEFT) * 2);
	}

	self.pos1 = self.origin;
	if (self.spawnflags & SECRET_1ST_DOWN)
		self.pos2 = self.origin - v_up * width;
	else
		self.pos2 = self.origin + v_right * width;

	self.pos3 = self.pos2 + v_forward * length;
	
	StartFunc(self);
}
