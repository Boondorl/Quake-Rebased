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

void StartFunc(entity e)
{
	if (!CanSpawn(self))
		return;
	
	if (self.noise)
		PrecacheSound(self.noise);
	if (self.noise1)
		PrecacheSound(self.noise1);
	if (self.noise2)
		PrecacheSound(self.noise2);
	if (self.noise3)
		PrecacheSound(self.noise3);
	if (self.noise4)
		PrecacheSound(self.noise4);
	
	self.morigin = self.origin;
	self.mangle = self.angles;
	self.max_health = self.health;
	if (!HasObituary(e))
		self.obituary = " was crushed";
	if (!self.damage_type)
		self.damage_type = "crush";
	
	self.angles = VEC_ZERO;
	
	SetPhysics(e, SOLID_BSP, MOVETYPE_PUSH);
	InitializeEntity(e);
}

void SetMoveDir(entity e, angles_t angs)
{
	if (angs == [0.0, -1.0, 0.0])
	{
		e.movedir = VEC_UP;
	}
	else if (angs == [0.0, -2.0, 0.0])
	{
		e.movedir = VEC_DOWN;
	}
	else
	{
		SetLocalAxes(angs);
		e.movedir = v_forward;
	}
}

void F_Move(vector pos, float spd, void() onDest)
{
	self.move_start = self.origin;
	self.move_dest = pos;
	self.th_movedest = onDest;
	self.move_start_time = GET_TIME(self);

	vector diff = Diff(self.origin, pos);
	float travelTime = Length(diff) / spd;
	if (travelTime < 0.1)
	{
		self.move_end_time = self.move_start_time + 0.1;
		self.velocity = VEC_ZERO;
		SetNextThink(self, 0.1, F_MoveDone);
		return;
	}

	self.move_end_time = self.move_start_time + travelTime;
	self.velocity = diff / travelTime;
	SetNextThink(self, travelTime, F_MoveDone);
}

void F_QuadraticBezierMove(entity node, float spd, void() onDest)
{
	entity dest = FindEntity(world, targetname, node.target);
	if (!dest)
		return;
	
	self.move_start = self.origin;
	self.move_interp1 = node.origin - GetCenter(self);
	self.move_dest = dest.origin - GetCenter(self);
	self.th_movedest = onDest;
	self.move_start_time = GET_TIME(self);
	
	float travelTime = QuadraticBezierLength(self.move_start, self.move_interp1, self.move_dest) / spd;
	if (travelTime < 0.1)
	{
		self.move_end_time = self.move_start_time + 0.1;
		self.velocity = VEC_ZERO;
		SetNextThink(self, 0.1, F_MoveDone);
		return;
	}
	
	self.move_end_time = self.move_start_time + travelTime;
	F_UpdateQuadraticBezierMove();
}

void F_UpdateQuadraticBezierMove()
{
	float remaining = self.move_end_time - GET_TIME(self);
	if (remaining <= 0.1)
	{
		self.velocity = Diff(self.origin, self.move_dest) / remaining;
		SetNextThink(self, remaining, F_MoveDone);
	}
	else
	{
		float t = (GET_TIME(self) - self.move_start_time) / (self.move_end_time - self.move_start_time);
		vector nextPos = QuadraticBezierCurve(self.move_start, self.move_interp1, self.move_dest, t);
		
		self.velocity = Diff(self.origin, nextPos) * 10.0;
		SetNextThink(self, 0.1, F_UpdateQuadraticBezierMove);
	}
}

void F_CubicBezierMove(entity node, float spd, void() onDest)
{
	entity node2 = FindEntity(world, targetname, node.target);
	if (!node2)
		return;
	entity dest = FindEntity(world, targetname, node2.target);
	if (!dest)
		return;
	
	self.move_start = self.origin;
	self.move_interp1 = node.origin - GetCenter(self);
	self.move_interp2 = node2.origin - GetCenter(self);
	self.move_dest = dest.origin - GetCenter(self);
	self.th_movedest = onDest;
	self.move_start_time = GET_TIME(self);
	
	float travelTime = CubicBezierLength(self.move_start, self.move_interp1, self.move_interp2, self.move_dest) / spd;
	if (travelTime < 0.1)
	{
		self.move_end_time = self.move_start_time + 0.1;
		self.velocity = VEC_ZERO;
		SetNextThink(self, 0.1, F_MoveDone);
		return;
	}
	
	self.move_end_time = self.move_start_time + travelTime;
	F_UpdateCubicBezierMove();
}

void F_UpdateCubicBezierMove()
{
	float remaining = self.move_end_time - GET_TIME(self);
	if (remaining <= 0.1)
	{
		self.velocity = Diff(self.origin, self.move_dest) / remaining;
		SetNextThink(self, remaining, F_MoveDone);
	}
	else
	{
		float t = (GET_TIME(self) - self.move_start_time) / (self.move_end_time - self.move_start_time);
		vector nextPos = CubicBezierCurve(self.move_start, self.move_interp1, self.move_interp2, self.move_dest, t);
		
		self.velocity = Diff(self.origin, nextPos) * 10.0;
		SetNextThink(self, 0.1, F_UpdateCubicBezierMove);
	}
}

void F_SineMove(vector pos, float spd, void() onDest)
{
	self.move_start = self.origin;
	self.move_dest = pos;
	self.th_movedest = onDest;

	// This uses distance-based movement instead of time so track that instead
	self.move_start_time = spd;
	self.move_end_time = Distance(self.origin, pos);
	if (self.move_end_time < spd * 0.1)
	{
		self.velocity = VEC_ZERO;
		SetNextThink(self, 0.1, F_MoveDone);
		return;
	}
	
	self.velocity = Diff(self.origin, pos);
	F_UpdateSineMove();
}

// Uses Bhaskara I's sine approximation since we only need the range from
// [90, 180] in degrees
void F_UpdateSineMove()
{
	float traveled = Distance(self.move_start, self.origin);
	float t = 90.0 + traveled / self.move_end_time * 90.0;
	// If the movement step becomes too small, just finish the move
	if (t > 179.4)
	{
		F_MoveDone();
		return;
	}
	
	float x = t * (180.0 - t);
	float s = 4.0 * x / (40500.0 - x);
	
	float newSpd = s * self.move_start_time;
	float remaining = self.move_end_time - traveled;
	if (remaining <= newSpd * 0.1)
	{
		self.velocity = Unit(self.velocity, remaining * 10.0);
		SetNextThink(self, 0.1, F_MoveDone);
	}
	else
	{
		self.velocity = Unit(self.velocity, newSpd);
		SetNextThink(self, 0.1, F_UpdateSineMove);
	}
}

void F_MoveDone()
{
	SetOrigin(self, self.move_dest);
	self.velocity = VEC_ZERO;
	if (self.th_movedest)
		self.th_movedest();
}
