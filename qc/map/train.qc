void P_TrainBlocked()
{
	if (self.dmg < 1 || !TimerExpired(self.attack_finished))
		return;
	
	SetCoolDown(self, attack_finished, 0.5);
	DamageEntity(other, self, world, self.dmg);
}

void F_TrainUse()
{
	if (self.think == F_TrainFind)
		F_TrainNext();
}

void F_TrainWait()
{
	float dur = 0.1;
	if (self.wait > 0.0 || self.wait < 0.0)
	{
		PlaySound(self, CHAN_VOICE, self.noise2, 1.0, ATTN_NORM);
		if (self.wait < 0.0)
		{
			self.state = FUNC_DEACTIVATED;
			return;
		}
		
		dur = self.wait;
	}

	self.state = FUNC_ACTIVATING;
	SetNextThink(self, dur, F_TrainNext);
};

void F_TrainNext()
{
	entity path = FindEntity(world, targetname, self.target);
	if (!path.target)
		A_ThrowEntityException("No valid next path");
	
	self.target = path.target;
	self.wait = path.wait;
	self.state = FUNC_ACTIVATED;
	PlaySound(self, CHAN_VOICE, self.noise1, 1.0, ATTN_NORM);
	
	if (path.spawnflags & PATH_BEZIER_QUAD)
		F_CalcQuadBezier(path, self.speed, F_TrainWait);
	else if (path.spawnflags & PATH_BEZIER_CUBIC)
		F_CalcCubicBezier(path, self.speed, F_TrainWait);
	else
		F_CalcMove(path.origin - self.mins, self.speed, F_TrainWait);
}

void F_TrainStart()
{
	entity path = FindEntity(world, targetname, self.target);
	self.target = path.target;
	SetOrigin(self, path.origin - self.mins);
	
	// not triggered, so start immediately
	if (!self.targetname && !(self.spawnflags & SPAWNFLAGS_DORMANT))
	{
		self.state = FUNC_ACTIVATING;
		SetNextThink(self, 0.1, F_TrainNext);
	}
}

enum int_t
{
	TSND_METAL = 1
};

void func_train()
{
	if (!self.target)
		A_ThrowEntityException("No starting target given");
	
	if (self.speed <= 0.0)
		self.speed = 100.0;
	if (!self.dmg)
		self.dmg = 2;

	if (self.sounds == TSND_METAL)
	{
		self.noise1 = "plats/train1.wav";
		self.noise2 = "plats/train2.wav";
	}
	
	// Allow setting these from the editor
	PrecacheSound(self.noise1);
	PrecacheSound(self.noise2);
	
	self.blocked = P_TrainBlocked;
	self.use = F_TrainUse;
	
	self.state = FUNC_DEACTIVATED;

	StartFunc(self);
	
	// start trains on the second frame, to make sure their targets have had
	// a chance to spawn
	SetNextThink(self, 0.1, F_TrainStart);
}

// This is the teleporter used for the final boss and it has some really jank
// properties. It's considered a train just because it follows path nodes...
void misc_teleporttrain()
{
	if (!self.target)
		A_ThrowEntityException("misc_teleporttrain without a target");
	
	PrecacheModel("progs/teleport.mdl");
	
	if (!self.speed)
		self.speed = 100.0;

	self.use = F_TrainUse;
	self.avelocity = [100.0 200.0 300.0]; // Does this even do anything?
	
	SetSolid(self, SOLID_NONE, MOVETYPE_NOCLIP);
	InitializeEntity(self, "progs/teleport.mdl");
	
	// start trains on the second frame, to make sure their targets have had
	// a chance to spawn
	SetNextThink(self, F_TrainFind, 0.1);
}
