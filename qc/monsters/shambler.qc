/*
	Copyright (C) 1996-1997  Id Software, Inc.

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    See file, 'COPYING', for details.
*/

$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7 stand8 stand9
$frame stand10 stand11 stand12 stand13 stand14 stand15 stand16 stand17

$frame walk1 walk2 walk3 walk4 walk5 walk6 walk7
$frame walk8 walk9 walk10 walk11 walk12

$frame run1 run2 run3 run4 run5 run6

$frame smash1 smash2 smash3 smash4 smash5 smash6 smash7
$frame smash8 smash9 smash10 smash11 smash12

$frame swingr1 swingr2 swingr3 swingr4 swingr5
$frame swingr6 swingr7 swingr8 swingr9

$frame swingl1 swingl2 swingl3 swingl4 swingl5
$frame swingl6 swingl7 swingl8 swingl9

$frame magic1 magic2 magic3 magic4 magic5
$frame magic6 magic7 magic8 magic9 magic10 magic11 magic12

$frame pain1 pain2 pain3 pain4 pain5 pain6

$frame death1 death2 death3 death4 death5 death6
$frame death7 death8 death9 death10 death11

void() S_Lightning1 = [ 0, S_Lightning2 ] {};
void() S_Lightning2 = [ 1, S_Lightning3 ] {};
void() S_Lightning3 = [ 2, A_Remove ] {};

void effect_lightning()
{
	SetPhysics(SOLID_NOT, MOVETYPE_NONE);
	InitializeEntity(self, "progs/s_light.mdl");
	
	S_Lightning1();
}

void() sham_stand1 = [ $stand1, sham_stand2 ] { A_Stand(); };
void() sham_stand2 = [ $stand2, sham_stand3 ] { A_Stand(); };
void() sham_stand3 = [ $stand3, sham_stand4 ] { A_Stand(); };
void() sham_stand4 = [ $stand4, sham_stand5 ] { A_Stand(); };
void() sham_stand5 = [ $stand5, sham_stand6 ] { A_Stand(); };
void() sham_stand6 = [ $stand6, sham_stand7 ] { A_Stand(); };
void() sham_stand7 = [ $stand7, sham_stand8 ] { A_Stand(); };
void() sham_stand8 = [ $stand8, sham_stand9 ] { A_Stand(); };
void() sham_stand9 = [ $stand9, sham_stand10 ] { A_Stand(); };
void() sham_stand10 = [ $stand10, sham_stand11 ] { A_Stand(); };
void() sham_stand11 = [ $stand11, sham_stand12 ] { A_Stand(); };
void() sham_stand12 = [ $stand12, sham_stand13 ] { A_Stand(); };
void() sham_stand13 = [ $stand13, sham_stand14 ] { A_Stand(); };
void() sham_stand14 = [ $stand14, sham_stand15 ] { A_Stand(); };
void() sham_stand15 = [ $stand15, sham_stand16 ] { A_Stand(); };
void() sham_stand16 = [ $stand16, sham_stand17 ] { A_Stand(); };
void() sham_stand17 = [ $stand17, sham_stand1 ] { A_Stand(); };

void() sham_walk1 = [ $walk1, sham_walk2 ] { A_Walk(10); };
void() sham_walk2 = [ $walk2, sham_walk3 ] { A_Walk(9); };
void() sham_walk3 = [ $walk3, sham_walk4 ] { A_Walk(9); };
void() sham_walk4 = [ $walk4, sham_walk5 ] { A_Walk(5); };
void() sham_walk5 = [ $walk5, sham_walk6 ] { A_Walk(6); };
void() sham_walk6 = [ $walk6, sham_walk7 ] { A_Walk(12); };
void() sham_walk7 = [ $walk7, sham_walk8 ] { A_Walk(8); };
void() sham_walk8 = [ $walk8, sham_walk9 ] { A_Walk(3); };
void() sham_walk9 = [ $walk9, sham_walk10 ] { A_Walk(13); };
void() sham_walk10 = [ $walk10, sham_walk11 ] { A_Walk(9); };
void() sham_walk11 = [ $walk11, sham_walk12 ] { A_Walk(7); };
void() sham_walk12 = [ $walk12, sham_walk1 ]
{
	if (Random() > 0.8)
		PlaySound(self, CHAN_VOICE, "shambler/sidle.wav", 1.0, ATTN_IDLE);
	
	A_Walk(7);
};

void() sham_run1 = [ $run1, sham_run2 ] { A_Run(20); };
void() sham_run2 = [ $run2, sham_run3 ] { A_Run(24); };
void() sham_run3 = [ $run3, sham_run4 ] { A_Run(20); };
void() sham_run4 = [ $run4, sham_run5 ] { A_Run(20); };
void() sham_run5 = [ $run5, sham_run6 ] { A_Run(24); };
void() sham_run6 = [ $run6, sham_run1 ]
{
	if (Random() > 0.8)
		PlaySound(self, CHAN_VOICE, "shambler/sidle.wav", 1.0, ATTN_IDLE);
	
	A_Run(20);
};

void() sham_smash1 = [ $smash1, sham_smash2 ]
{
	PlaySound(self, CHAN_VOICE, "shambler/melee1.wav", 1.0, ATTN_NORM);
	A_Charge(2);
};
void() sham_smash2 = [ $smash2, sham_smash3 ] { A_Charge(6); };
void() sham_smash3 = [ $smash3, sham_smash4 ] { A_Charge(6); };
void() sham_smash4 = [ $smash4, sham_smash5 ] { A_Charge(5); };
void() sham_smash5 = [ $smash5, sham_smash6 ] { A_Charge(4); };
void() sham_smash6 = [ $smash6, sham_smash7 ] { A_Charge(1); };
void() sham_smash7 = [ $smash7, sham_smash8 ] { A_Charge(0); };
void() sham_smash8 = [ $smash8, sham_smash9 ] { A_Charge(0); };
void() sham_smash9 = [ $smash9, sham_smash10 ] { A_Charge(0); };
void() sham_smash10 = [ $smash10, sham_smash11 ]
{
	A_Charge(0);
	
	int_t damage = MAX(20, Round((Random() + Random() + Random()) * 40.0));
	if (A_DirectDamage(damage, 100.0) >= 0)
	{
		PlaySound(self, CHAN_WEAPON, "shambler/smack.wav", 1.0, ATTN_NORM);
		
		FixLocalAxes(self.angles);

		vector orig = self.origin + v_forward * 16.0;
		SpawnMeatSpray(orig, v_right * (100.0 * CRandom()));
		SpawnMeatSpray(orig, v_right * (100.0 * CRandom()));
	}
};
void() sham_smash11 = [ $smash11, sham_smash12 ] { A_Charge(5); };
void() sham_smash12 = [ $smash12, sham_run1    ] { A_Charge(4); };

void A_ShamblerMeleeAttack(flost dist, float sideOfs)
{
	A_Charge(dist);

	int_t damage = MAX(10, Round((Random() + Random() + Random()) * 20.0));
	if (A_DirectDamage(damage, 100.0) >= 0)
	{
		PlaySound(self, CHAN_WEAPON, "shambler/smack.wav", 1.0, ATTN_NORM);
		if (sideOfs)
		{
			FixedLocalAxes(self.angles);
			
			SpawnMeatSpray(self.origin + v_forward * 16.0, v_right * sideOfs);
		}
	}
}

void() sham_swingl1 = [ $swingl1, sham_swingl2 ]
{
	PlaySound(self, CHAN_VOICE, "shambler/melee2.wav", 1.0, ATTN_NORM);
	A_Charge(5);
};
void() sham_swingl2 = [ $swingl2, sham_swingl3 ] { A_Charge(3); };
void() sham_swingl3 = [ $swingl3, sham_swingl4 ] { A_Charge(7); };
void() sham_swingl4 = [ $swingl4, sham_swingl5 ] { A_Charge(3); };
void() sham_swingl5 = [ $swingl5, sham_swingl6 ] { A_Charge(7); };
void() sham_swingl6 = [ $swingl6, sham_swingl7 ] { A_Charge(9); };
void() sham_swingl7 = [ $swingl7, sham_swingl8 ] { A_ShamblerMeleeAttack(15.0, 250.0); };
void() sham_swingl8 = [ $swingl8, sham_swingl9 ] { A_Charge(4); };
void() sham_swingl9 = [ $swingl9, sham_run1  ]
{
	A_Charge(8);
	if (random()<0.5)
		self.think = sham_swingr1;
};

void() sham_swingr1 = [ $swingr1, sham_swingr2 ]
{
	PlaySound(self, CHAN_VOICE, "shambler/melee1.wav", 1.0, ATTN_NORM);
	A_Charge(1);
};
void() sham_swingr2 = [ $swingr2, sham_swingr3 ] { A_Charge(8); };
void() sham_swingr3 = [ $swingr3, sham_swingr4 ] { A_Charge(14); };
void() sham_swingr4 = [ $swingr4, sham_swingr5 ] { A_Charge(7); };
void() sham_swingr5 = [ $swingr5, sham_swingr6 ] { A_Charge(3); };
void() sham_swingr6 = [ $swingr6, sham_swingr7 ] { A_Charge(6); };
void() sham_swingr7 = [ $swingr7, sham_swingr8 ] { A_ShamblerMeleeAttack(16.0, -250.0); };
void() sham_swingr8 = [ $swingr8, sham_swingr9 ] { A_Charge(3); };
void() sham_swingr9 = [ $swingr9, sham_run1  ]
{
	A_Charge(11);
	if (Random() < 0.5)
		self.think = sham_swingl1;
};

void A_ShamblerMelee()
{
	float r = Random();
	if (r < 0.33 || self.health >= self.max_health)
		sham_smash1();
	else if (r < 0.66)
		sham_swingr1();
	else
		sham_swingl1();
}

// All the aiming bugs have been fixed here so the visual should no longer be
// weirdly desynched
void A_ShamblerLightningAttack()
{
	A_Face();

	FixedLocalAxes(self.angles);
	
	self.effects |= EF_MUZZLEFLASH;
	
	vector orig = self.origin + v_up * 40.0;
	vector dir = GetAimDir(self.enemy, orig, 16.0);
	vector dest = orig + dir * 600.0;

	TraceLine(orig, dest, MOVE_NOMONSTER, self);

	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_LIGHTNING1);
	WriteEntity(MSG_BROADCAST, self);
	WriteCoord(MSG_BROADCAST, orig.x);
	WriteCoord(MSG_BROADCAST, orig.y);
	WriteCoord(MSG_BROADCAST, orig.z);
	WriteCoord(MSG_BROADCAST, trace_endpos.x);
	WriteCoord(MSG_BROADCAST, trace_endpos.y);
	WriteCoord(MSG_BROADCAST, trace_endpos.z);
	
	TraceLine(orig, dest, MOVE_MISSILE, self);
	if (trace_fraction == 1.0)
		return;
	
	SpawnParticles(trace_endpos, [0.0, 0.0, 100.0], 225, 40);
	if (trace_ent.takedamage != DAMAGE_NO)
		DamageEntity(trace_ent, self, self, 10);
}

void() sham_magic1 = [ $magic1, sham_magic2 ]
{
	A_Face();
	PlaySound(self, CHAN_WEAPON, "shambler/sattck1.wav", 1.0, ATTN_NORM);
};
void() sham_magic2 = [ $magic2, sham_magic3 ] { A_Face(); };
void() sham_magic3 = [ $magic3, sham_magic4 ]
{
	A_Face();
	A_FaceIdealYaw(); // I think this was meant to emulate doubling the turn speed...
	
	self.effects |= EF_MUZZLEFLASH;
	self.nextthink += 0.2;
	
	entity effect = SpawnEntityType(effect_lightning);
	effect.angles = self.angles;
	effect.nextthink = self.nextthink;
};
void() sham_magic4 = [ $magic4, sham_magic5 ]
{
	A_Face();
	self.effects |= EF_MUZZLEFLASH;
};
void() sham_magic5 = [ $magic5, sham_magic6 ]
{
	A_Face();
	self.effects |= EF_MUZZLEFLASH;
};
void() sham_magic6 = [ $magic6, sham_magic9 ]
{
	PlaySound(self, CHAN_WEAPON, "shambler/sboom.wav", 1.0, ATTN_NORM);
	A_ShamblerLightningAttack();
};
void() sham_magic9 = [ $magic9, sham_magic10 ] { A_ShamblerLightningAttack(); };
void() sham_magic10 = [ $magic10, sham_magic11 ] { A_ShamblerLightningAttack(); };
void() sham_magic11 = [ $magic11, sham_magic12 ]
{
	if (skill >= SK_NIGHTMARE)
		A_ShamblerLightningAttack();
};
void() sham_magic12 = [ $magic12, sham_run1    ] {};

void() sham_pain1 = [ $pain1, sham_pain2 ] { PlaySound(self, CHAN_VOICE, "shambler/shurt2.wav", 1.0, ATTN_NORM); };
void() sham_pain2 = [ $pain2, sham_pain3 ] {};
void() sham_pain3 = [ $pain3, sham_pain4 ] {};
void() sham_pain4 = [ $pain4, sham_pain5 ] {};
void() sham_pain5 = [ $pain5, sham_pain6 ] {};
void() sham_pain6 = [ $pain6, sham_run1 ] {};

void() sham_death1 = [ $death1, sham_death2 ] { PlaySound(self, CHAN_VOICE, "shambler/sdeath.wav", 1.0, ATTN_NORM); };
void() sham_death2 = [ $death2, sham_death3 ] {};
void() sham_death3 = [ $death3, sham_death4 ] { SetSolid(self, SOLID_NOT); };
void() sham_death4 = [ $death4, sham_death5 ] {};
void() sham_death5 = [ $death5, sham_death6 ] {};
void() sham_death6 = [ $death6, sham_death7 ] {};
void() sham_death7 = [ $death7, sham_death8 ] {};
void() sham_death8 = [ $death8, sham_death9 ] {};
void() sham_death9 = [ $death9, sham_death10 ] {};
void() sham_death10 = [ $death10, sham_death11 ] {};
void() sham_death11 = [ $death11, sham_death11 ] {};

bool_t ShamblerPain(entity attacker, entity inflictor, int_t damage)
{
	if (!TimerExpired(self.pain_finished) || Round(400.0 * Random()) > damage)
		return FALSE;
	
	sham_pain1();
	SetCoolDown(self, pain_finished, 2.0);
	return TRUE;
}

void A_ShamblerDie()
{
	if (self.health < -60)
	{
		GibMonster(self, "progs/h_shams.mdl");
		return;
	}

	sham_death1();
}

bool_t A_CheckShamblerAttack()
{
	if (!IsVisible(self, self.enemy, VIS_CHECK_MONSTER))
		return FALSE;
	
	float range = GetRange(self, self.enemy);
	if (range <= RANGE_MELEE)
	{
		self.attack_state = AS_MELEE;
		return TRUE;
	}
	
	if (range > 600.0 || !TimerExpired(self.attack_finished))
		return FALSE;

	self.attack_state = AS_MISSILE;
	if (skill < SK_NIGHTMARE)
		SetCoolDown(self, attack_finished, 2.0 + 2.0 * Random());
	
	return TRUE;
}

void monster_shambler()
{
	if (deathmatch)
	{
		RemoveEntity(self);
		return;
	}
	
	TryPrecacheModel("progs/shambler.mdl");
	TryPrecacheModel("progs/s_light.mdl");
	TryPrecacheModel("progs/h_shams.mdl");
	TryPrecacheModel("progs/bolt.mdl");

	TryPrecacheSound("shambler/sattck1.wav");
	TryPrecacheSound("shambler/sboom.wav");
	TryPrecacheSound("shambler/sdeath.wav");
	TryPrecacheSound("shambler/shurt2.wav");
	TryPrecacheSound("shambler/sidle.wav");
	TryPrecacheSound("shambler/ssight.wav");
	TryPrecacheSound("shambler/melee1.wav");
	TryPrecacheSound("shambler/melee2.wav");
	TryPrecacheSound("shambler/smack.wav");

	self.th_stand = sham_stand1;
	self.th_walk = sham_walk1;
	self.th_run = sham_run1;
	self.th_melee = A_ShamblerMelee;
	self.th_missile = sham_magic1;
	self.th_pain = A_ShamblerPain;
	self.th_die = A_ShamblerDie;
	self.AttackCheck = A_CheckShamblerAttack;

	self.health = 600;

	StartMonster(self, "progs/shambler.mdl", TRUE);
}
