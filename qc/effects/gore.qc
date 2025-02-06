
vector GetBloodSprayDir(vector vel, float speed = 1.0)
{
	vector curForward = v_forward;
	vector curRight = v_right;
	vector curUp = v_up;
	
	// Always spray blood upward
	angles_t angs = ToAngles(vel);
	angs.x = -AbsF(angs.x);
	SetLocalAxes(angs);
	
	vector dir = Normalize(v_forward + v_right * (CRandom() * 0.5) + v_up * (CRandom() * 0.5)) * speed;
	
	v_forward = curForward;
	v_right = curRight;
	v_up = curUp;
	
	return dir;
}

inline void SpawnBlood(vector orig, vector vel, int_t damage)
{
	SpawnParticles(orig, vel * 0.1, 73, MIN(damage * 2, UINT8_MAX - 1));
}

inline void SpawnBloodChunk(vector orig, vector vel)
{
	SpawnParticles(orig, vel * 0.02, 0, 10);
}

void SpawnBloodSpray(vector orig, vector vel, int_t damage)
{
	vector dir = GetBloodSprayDir(vel, 40.0);
	SpawnBlood(orig + dir * 0.01, dir, damage);
}

void SpawnMeatSpray(entity e, vector orig, vector vel)
{
	vel.z += 250.0 + 50.0 * Random();
	SpawnMissile(e, gore_meatspray, orig, vel, 1.0, [3000.0, 1000.0, 2000.0], 1.0);
}

vector VelFromDamage(int_t damage)
{
	vector vel = [100.0 * CRandom(), 100.0 * CRandom(), 200.0 + 100.0 * Random()];
	if (damage > -50)
		vel *= 0.7;
	else if (damage > -200)
		vel *= 2.0;
	else
		vel *= 10.0;

	return vel;
}

void GibEntity(entity e, string gibMod, string snd = SND_GIB)
{
	if (snd)
		PlaySound(e, CHAN_VOICE, snd, 1.0, ATTN_NORM);
	
	BecomeGib(e, gibMod, e.health);
	ThrowGib("progs/gib1.mdl", e, e.origin, e.health);
	ThrowGib("progs/gib2.mdl", e, e.origin, e.health);
	ThrowGib("progs/gib3.mdl", e, e.origin, e.health);
}

void ThrowGib(string gibMod, entity e, vector orig, int_t damage)
{
	entity gib = SpawnMissile(e, gore_gib, orig, VelFromDamage(damage), 1.0, [600.0*Random(), 600.0*Random(), 600.0*Random()], 10.0 + Random()*10.0);
	InitializeEntity(gib, gibMod);
}

void BecomeGib(entity e, string gibMod, int_t damage)
{
	e.frame = 0;
	e.takedamage = DAMAGE_NO;
	e.view_ofs = [0.0, 0.0, 8.0];
	e.flags &= ~FL_ONGROUND;
	ClearThink(e);
	
	e.velocity = VelFromDamage(damage);
	e.avelocity = [0.0, 600.0 * CRandom(), 0.0];
	
	e.origin.z = e.absmin.z;
	SetPhysics(e, SOLID_NOT, MOVETYPE_BOUNCE);
	InitializeEntity(e, gibMod);
}

void gore_gib()
{
	SetPhysics(SOLID_NOT, MOVETYPE_BOUNCE);
}

void gore_meatspray()
{
	SetPhysics(self, SOLID_BBOX, MOVETYPE_BOUNCE);
	InitializeEntity(self, "progs/zom_gib.mdl");
}
