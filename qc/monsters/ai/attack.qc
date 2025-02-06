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

// Similar to GetAutoaimDir, this assumes v_forward has already been set properly
vector GetAimDir(entity targ, vector orig, vector aimOfs = VEC_ZERO, bool_t noZ = FALSE)
{
	if (!targ)
		return v_forward;
	
	vector diff = (targ.origin + aimOfs) - orig;
	if (noZ)
		diff.z = 0.0;
	
	return diff ? Normalize(diff) : v_forward;
}

// Check for a follow up attack, up to one additional time
void A_CheckRefire(void() refireState)
{
	if (skill < SK_NIGHTMARE || (self.misc_action & MON_REFIRE)
		|| !IsValidEnemy(self.enemy)
		|| GetRange(self, self.enemy) > RANGE_FAR || !IsVisibile(self, self.enemy, VIS_CHECK_MONSTERS))
	{
		self.misc_action &= ~MON_REFIRE;
		return;
	}
	
	self.misc_action |= MON_REFIRE;
	refireState();
}

// Try and face current enemy
void A_Face()
{
	if (self.enemy)
	{
		vector diff = self.enemy.origin - self.origin;
		diff.z = 0.0;
		self.ideal_yaw = diff ? Atan2(diff) : self.angles.y;
	}
	
	A_FaceIdealYaw();
}

// Blindly move towards enemy with no navigating
void A_Charge(float dist, float ofs = 0.0)
{
	A_Face();

	SetLocalAxes([0.0, self.ideal_yaw, 0.0]);
	
	vector dest;
	if (self.enemy)
		dest = self.enemy.origin;
	else
		dest = self.origin + v_forward * 80.0;

	A_TryMove(Atan2((dest + v_right * ofs) - self.origin), dist);
}

// Psychic damage used for monster melee attacks. A return value of
// -2 means the attack couldn't be dealt at all
int_t A_DirectDamage(int_t damage, float range, flags_t dmgFlags = 0)
{
	if (!self.enemy
		|| GetRange(self, self.enemy) > range
		|| !CanDamage(self, self.enemy))
	{
		return -2;
	}

	return DamageEntity(self.enemy, self, self, damage, dmgFlags);
}
