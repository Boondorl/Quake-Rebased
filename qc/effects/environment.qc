
$frame Explode1 Explode2 Explode3 Explode4 Explode5 Explode6

void() S_Explode1 = [ $Explode1, S_Explode2 ] {};
void() S_Explode2 = [ $Explode2, S_Explode3 ] {};
void() S_Explode3 = [ $Explode3, S_Explode4 ] {};
void() S_Explode4 = [ $Explode4, S_Explode5 ] {};
void() S_Explode5 = [ $Explode5, S_Explode6 ] {};
void() S_Explode6 = [ $Explode6, A_Remove   ] {};

void effect_explosion()
{
	SetPhysics(self, SOLID_NOT, MOVETYPE_NONE);
	InitializeEntity(self, "progs/explode.spr");
	
	S_Explode1();
	
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord(MSG_BROADCAST, self.origin.x);
	WriteCoord(MSG_BROADCAST, self.origin.y);
	WriteCoord(MSG_BROADCAST, self.origin.z);
}

void effect_barrelexplosion()
{
	SetPhysics(self, SOLID_NOT, MOVETYPE_NONE);
	InitializeEntity(self, "progs/explode.spr");
	
	S_Explode1();
	
	PlaySound(self, CHAN_AUTO, "weapons/r_exp3.wav", 1.0, ATTN_NORM);
	SpawnParticles(self.origin, VEC_ZERO, 75, 255);
}

void A_ColorfulExplosion()
{
	InitializeEntity(self, "progs/explode.spr");
	
	S_Explode1();
	
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_EXPLOSION2);
	WriteCoord(MSG_BROADCAST, self.origin.x);
	WriteCoord(MSG_BROADCAST, self.origin.y);
	WriteCoord(MSG_BROADCAST, self.origin.z);
	WriteByte(MSG_BROADCAST, self.pos1.x);
	WriteByte(MSG_BROADCAST, self.pos1.y);
}

void effect_explosion2()
{
	SetPhysics(self, SOLID_NOT, MOVETYPE_NONE, TRUE);
	
	// This needs a delay so the color range can be set on it after creation
	SetNextThink(self, TIME_EPSILON, A_ColorfulExplosion);
}

void effect_spawnexplosion()
{
	SetPhysics(self, SOLID_NOT, MOVETYPE_NONE);
	InitializeEntity(self, "progs/explode.spr");
	
	S_Explode1();
	
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_TAREXPLOSION);
	WriteCoord(MSG_BROADCAST, self.origin.x);
	WriteCoord(MSG_BROADCAST, self.origin.y);
	WriteCoord(MSG_BROADCAST, self.origin.z);
}

void effect_lavasplash()
{
	SetPhysics(self, SOLID_NOT, MOVETYPE_NONE, TRUE);
	
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_LAVASPLASH);
	WriteCoord(MSG_BROADCAST, self.origin.x);
	WriteCoord(MSG_BROADCAST, self.origin.y);
	WriteCoord(MSG_BROADCAST, self.origin.z);
	
	RemoveEntity(self);
}

void A_PlayTeleportSound()
{
	string snd;
	switch (RandomI(4))
	{
	case 1:
		snd = "misc/r_tele2.wav";
		break;
	
	case 2:
		snd = "misc/r_tele3.wav";
		break;
	
	case 3:
		snd = "misc/r_tele4.wav";
		break;
	
	case 4:
		snd = "misc/r_tele5.wav";
		break;
	
	default:
		snd = "misc/r_tele1.wav";
		break;
	}

	PlaySound(self, CHAN_BODY, snd, 1.0, ATTN_NORM);
	DestroyEntity(self);
}

void effect_telefog()
{
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_TELEPORT);
	WriteCoord(MSG_BROADCAST, self.origin.x);
	WriteCoord(MSG_BROADCAST, self.origin.y);
	WriteCoord(MSG_BROADCAST, self.origin.z);
	
	SetNextThink(self, A_PlayTeleportSound, 0.2);
}

void P_BubbleTouch()
{
	if (other.classname != self.classname)
		DestroyEntity(self);
}

void A_BubbleBob()
{
	if (self.waterlevel < DEPTH_SUBMERGED)
	{
		DestroyEntity(self);
		return;
	}
	
	++self.count;
	if (self.count == 4)
	{
		// Spawn another bubble
		self.frame = 1;
		self.count = 10;
		
		entity bubble = SpawnEntityType(effect_bubble, self.origin);
		bubble.frame = 1;
		bubble.count = 10;
	}
	else if (self.count == 20)
	{
		DestroyEntity(self);
		return;
	}

	float xVel = self.velocity.x + 10.0 * CRandom();
	if (xVel > 10.0)
		xVel = 5.0;
	else if (xVel < -10.0)
		xVel = -5.0;
	
	float yVel = self.velocity.y + 10.0 * CRandom();
	if (yVel > 10.0)
		yVel = 5.0;
	else if (yVel < -10.0)
		yVel = -5.0;
	
	float zVel = self.velocity.z + 10.0 + 10.0 * Random();
	if (zVel < 10.0)
		zVel = 15.0;
	if (zVel > 30.0)
		zVel = 25.0;
	
	self.velocity = [xVel, yVel, zVel];
	
	SetNextThink(self, 0.5, A_BubbleBob);
}

void effect_bubble()
{
	self.touch = P_BubbleTouch;
	
	SetPhysics(self, SOLID_NOT, MOVETYPE_NOCLIP);
	InitializeEntity(self, "progs/s_bubble.spr");
	
	SetNextThink(self, 0.5, A_BubbleBob);
}

void CreateDamageBubbles(entity e, int_t bubbles)
{
	entity spawner = SpawnEntityType(effect_damagebubbles, e.origin);
	spawner.owner = e;
	spawner.count = bubbles;
}

void A_SpawnDamageBubbles()
{
	if (self.owner.waterlevel < DEPTH_SUBMERGED)
	{
		DestroyEntity(self);
		return;
	}
	
	entity bubble = SpawnEntityType(effect_bubble, self.owner.origin + [0.0, 0.0, 24.0]);
	bubble.velocity.z = 15.0;
	
	if (--self.count < 1)
	{
		DestroyEntity(self);
		return;
	}
	
	SetNextThink(self, 0.1, A_SpawnDamageBubbles);
}

void effect_damagebubbles()
{
	SetPhysics(self, SOLID_NOT, MOVETYPE_NONE);
	
	SetNextThink(self, 0.1, A_SpawnDamageBubbles);
}
