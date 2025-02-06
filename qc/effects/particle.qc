
void F_EmitParticles()
{
	uint8_t index;
	if (self.pos1.x >= self.pos1.y)
		index = self.pos1.x;
	else
		index = Round(RandomRange(self.pos1.x, self.pos1.y));
	
	SpawnParticles(self.origin, self.movedir * RandomRangeF(self.speed * 0.6, self.speed), index, self.count);
	
	SetNextThink(self, self.wait, F_EmitParticles);
}

void effect_particlefountain()
{
	if (speed <= 0.0)
		speed = 100.0;
	if (self.count <= 0)
		self.count = 3;
	if (self.wait <= 0.1)
		self.wait = 0.1;
	
	// 255 is a special case that has to be avoided
	count = MIN(count, 254);
	
	F_SetMoveDir();
	
	SetPhysics(self, SOLID_NOT, MOVETYPE_NONE);
	InitializeEntity(self);
	
	F_EmitParticles();
}
