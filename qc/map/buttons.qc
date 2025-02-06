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

void F_ButtonActivated()
{
	self.state = FUNC_ACTIVATED;
	if (self.wait > 0.0)
		SetNextThink(self, self.wait, F_DeactivateButton);
	
	ActivateEntity(self, self.goalentity);
	self.goalentity = world;
}

void F_ButtonDeactivated()
{
	self.state = FUNC_DEACTIVATED;
}

void F_DeactivateButton()
{
	self.state = FUNC_DEACTIVATING;
	self.frame = 0;
	if (self.health)
		self.takedamage = DAMAGE_USE; // can be shot again
	
	F_CalcMove(self.pos1, self.speed, F_ButtonDeactivated);
}

void F_ActivateButton()
{
	PlaySound(self, CHAN_VOICE, self.noise1, 1.0, ATTN_NORM);

	self.state = FUNC_ACTIVATING;
	self.frame = 1;
	self.takedamage = DAMAGE_NO;
	
	F_CalcMove(self.pos2, self.speed, F_ButtonActivated);
}

void F_ButtonDormant(entity activator, bool_t activate)
{
	if (activate)
	{
		self.spawnflags &= ~SPAWNFLAGS_DORMANT;
		if (self.state == FUNC_ACTIVATED || self.state == FUNC_ACTIVATING)
			F_DeactivateButton();
		
		if (self.touch)
			force_retouch = 2;
	}
	else
	{
		self.spawnflags |= SPAWNFLAG_DORMANT;
		if (self.state == FUNC_DEACTIVATED || self.state == FUNC_DEACTIVATING)
			F_ActivateButton();
	}
}

void P_ButtonTouch()
{
	if (!IsValidClient(other) || self.state == FUNC_ACTIVATING || self.state == FUNC_ACTIVATED)
		return;
	
	InvokeActivation(self, other, self.use);
}

void F_ButtonUse()
{
	if (self.state == FUNC_ACTIVATED)
	{
		F_DeactivateButton();
		return;
	}
	else if (self.state == FUNC_ACTIVATING)
	{
		return;
	}

	self.goalentity = self.aiment;
	F_ActivateButton();
}

enum int_t
{
	BSND_STEAM,
	BSND_WOOD,
	BSND_METAL,
	BSND_BASIC,
};

enumflags
{
	BUTTON_USE_OR_SHOOT,
	BUTTON_NO_LIP,
};

void func_button()
{
	if (self.speed <= 0.0)
		self.speed = 40.0;
	if (!self.wait)
		self.wait = 1.0;
	if (!self.lip && !(self.spawnflags & BUTTON_NO_LIP))
		self.lip = 4.0;
	
	if (self.sounds == BSND_STEAM)
		self.noise1 = "buttons/airbut1.wav";
	else if (self.sounds == BSND_WOOD)
		self.noise1 = "buttons/switch21.wav";
	else if (self.sounds == BSND_METAL)
		self.noise1 = "buttons/switch02.wav";
	else if (self.sounds == BSND_BASIC)
		self.noise1 = "buttons/switch04.wav";
	
	if (self.noise1)
		PrecacheSound(self.noise1);

	SetMoveDir(self);

	self.th_dormant = F_ButtonDormant;
	self.use = F_ButtonUse;

	if (self.spawnflags & BUTTON_USE_OR_SHOOT)
	{
		self.takedamage = DAMAGE_USE;
		self.touch = P_ButtonTouch;
	}
	else if (self.health)
	{
		self.takedamage = DAMAGE_USE;
	}
	else
	{
		self.touch = P_ButtonTouch;
	}

	self.pos1 = self.origin;
	self.pos2 = self.origin + self.movedir * (AbsF(self.movedir * self.size) - self.lip);
	
	if (self.spawnflags & SPAWNFLAG_DORMANT)
	{
		self.state = FUNC_ACTIVATED;
		self.frame = 1;
		self.takedamage = DAMAGE_NO;
		self.origin = self.pos2;
	}
	else
	{
		self.state = FUNC_DEACTIVATED;
	}
	
	StartFunc(self);
}
