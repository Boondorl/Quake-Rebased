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

$frame Idle1 Idle2 Idle3 Idle4 Idle5 Idle6 Idle7 Idle8
$frame Idle9 Idle10 Idle11 Idle12 Idle13 Idle14 Idle15

$frame Walk1 Walk2 Walk3 Walk4 Walk5 Walk6 Walk7 Walk8 Walk9 Walk10 Walk11
$frame Walk12 Walk13 Walk14 Walk15 Walk16 Walk17 Walk18 Walk19

$frame Run1 Run2 Run3 Run4 Run5 Run6 Run7 Run8 Run9 Run10 Run11 Run12
$frame Run13 Run14 Run15 Run16 Run17 Run18

$frame MissileA1 MissileA2 MissileA3 MissileA4 MissileA5 MissileA6 MissileA7 MissileA8 MissileA9 MissileA10 MissileA11
$frame MissileA12 MissileA13

$frame MissileB1 MissileB2 MissileB3 MissileB4 MissileB5 MissileB6 MissileB7 MissileB8 MissileB9 MissileB10 MissileB11
$frame MissileB12 MissileB13 MissileB14

$frame MissileC1 MissileC2 MissileC3 MissileC4 MissileC5 MissileC6 MissileC7 MissileC8 MissileC9 MissileC10 MissileC11
$frame MissileC12

$frame PainA1 PainA2 PainA3 PainA4 PainA5 PainA6 PainA7 PainA8 PainA9 PainA10
$frame PainA11 PainA12

$frame PainB1 PainB2 PainB3 PainB4 PainB5 PainB6 PainB7 PainB8 PainB9 PainB10
$frame PainB11 PainB12 PainB13 PainB14 PainB15 PainB16 PainB17 PainB18 PainB19
$frame PainB20 PainB21 PainB22 PainB23 PainB24 PainB25 PainB26 PainB27 PainB28

$frame PainC1 PainC2 PainC3 PainC4 PainC5 PainC6 PainC7 PainC8 PainC9 PainC10
$frame PainC11 PainC12 PainC13 PainC14 PainC15 PainC16 PainC17 PainC18

$frame PainD1 PainD2 PainD3 PainD4 PainD5 PainD6 PainD7 PainD8 PainD9 PainD10
$frame PainD11 PainD12 PainD13

$frame PainE1 PainE2 PainE3 PainE4 PainE5 PainE6 PainE7 PainE8 PainE9 PainE10
$frame PainE11 PainE12 PainE13 PainE14 PainE15 PainE16 PainE17 PainE18 PainE19
$frame PainE20 PainE21 PainE22 PainE23 PainE24 PainE25 PainE26 PainE27 PainE28
$frame PainE29 PainE30

$frame Crucifix1 Crucifix2 Crucifix3 Crucifix4 Crucifix5 Crucifix6

void() S_ZombieCrucifix1 = [ $Crucifix1, S_ZombieCrucifix2 ] { self.nextthink += Random()*0.1; };
void() S_ZombieCrucifix2 = [ $Crucifix2, S_ZombieCrucifix3 ] { self.nextthink += Random()*0.1; };
void() S_ZombieCrucifix3 = [ $Crucifix3, S_ZombieCrucifix4 ] { self.nextthink += Random()*0.1; };
void() S_ZombieCrucifix4 = [ $Crucifix4, S_ZombieCrucifix5 ] { self.nextthink += Random()*0.1; };
void() S_ZombieCrucifix5 = [ $Crucifix5, S_ZombieCrucifix6 ] { self.nextthink += Random()*0.1; };
void() S_ZombieCrucifix6 = [ $Crucifix6, S_ZombieCrucifix1 ]
{
	if (Random() < 0.1)
		PlaySound(self, CHAN_VOICE, "zombie/idle_w2.wav", 1.0, ATTN_STATIC);
	
	self.nextthink += Random()*0.1;
};

void() S_ZombieIdle1 = [ $Idle1, S_ZombieIdle1 ]
{
	self.walkframe = AdvanceFrame(self.walkframe, $Idle1, $Idle15);
	self.frame = self.walkframe;
	
	A_Stand();
};

void() S_ZombieWalk1 = [ $Walk1, S_ZombieWalk2 ] { A_Walk(0.0); };
void() S_ZombieWalk2 = [ $Walk2, S_ZombieWalk3 ] { A_Walk(2.0); };
void() S_ZombieWalk3 = [ $Walk3, S_ZombieWalk4 ] { A_Walk(3.0); };
void() S_ZombieWalk4 = [ $Walk4, S_ZombieWalk5 ] { A_Walk(2.0); };
void() S_ZombieWalk5 = [ $Walk5, S_ZombieWalk6 ] { A_Walk(1.0); };
void() S_ZombieWalk6 = [ $Walk6, S_ZombieWalk7 ] { A_Walk(0.0); };
void() S_ZombieWalk7 = [ $Walk7, S_ZombieWalk8 ] { A_Walk(0.0); };
void() S_ZombieWalk8 = [ $Walk8, S_ZombieWalk9 ] { A_Walk(0.0); };
void() S_ZombieWalk9 = [ $Walk9, S_ZombieWalk10 ] { A_Walk(0.0); };
void() S_ZombieWalk10 = [ $Walk10, S_ZombieWalk11 ] { A_Walk(0.0); };
void() S_ZombieWalk11 = [ $Walk11, S_ZombieWalk12 ] { A_Walk(2.0); };
void() S_ZombieWalk12 = [ $Walk12, S_ZombieWalk13 ] { A_Walk(2.0); };
void() S_ZombieWalk13 = [ $Walk13, S_ZombieWalk14 ] { A_Walk(1.0); };
void() S_ZombieWalk14 = [ $Walk14, S_ZombieWalk15 ] { A_Walk(0.0); };
void() S_ZombieWalk15 = [ $Walk15, S_ZombieWalk16 ] { A_Walk(0.0); };
void() S_ZombieWalk16 = [ $Walk16, S_ZombieWalk17 ] { A_Walk(0.0); };
void() S_ZombieWalk17 = [ $Walk17, S_ZombieWalk18 ] { A_Walk(0.0); };
void() S_ZombieWalk18 = [ $Walk18, S_ZombieWalk19 ] { A_Walk(0.0); };
void() S_ZombieWalk19 = [ $Walk19, S_ZombieWalk1 ]
{
	if (Random() < 0.2)
		PlaySound(self, CHAN_VOICE, "zombie/z_idle.wav", 1.0, ATTN_IDLE);
	
	A_Walk(0.0);
};

void() S_ZombieRun1 = [ $Run1, S_ZombieRun2 ]
{
	self.count = PAIN_NONE;
	A_Run(1.0);
};
void() S_ZombieRun2 = [ $Run2, S_ZombieRun3 ] { A_Run(1.0); };
void() S_ZombieRun3 = [ $Run3, S_ZombieRun4 ] { A_Run(0.0); };
void() S_ZombieRun4 = [ $Run4, S_ZombieRun5 ] { A_Run(1.0); };
void() S_ZombieRun5 = [ $Run5, S_ZombieRun6 ] { A_Run(2.0); };
void() S_ZombieRun6 = [ $Run6, S_ZombieRun7 ] { A_Run(3.0); };
void() S_ZombieRun7 = [ $Run7, S_ZombieRun8 ] { A_Run(4.0); };
void() S_ZombieRun8 = [ $Run8, S_ZombieRun9 ] { A_Run(4.0); };
void() S_ZombieRun9 = [ $Run9, S_ZombieRun10 ] { A_Run(2.0); };
void() S_ZombieRun10 = [ $Run10, S_ZombieRun11 ] { A_Run(0.0); };
void() S_ZombieRun11 = [ $Run11, S_ZombieRun12 ] { A_Run(0.0); };
void() S_ZombieRun12 = [ $Run12, S_ZombieRun13 ] { A_Run(0.0); };
void() S_ZombieRun13 = [ $Run13, S_ZombieRun14 ] { A_Run(2.0); };
void() S_ZombieRun14 = [ $Run14, S_ZombieRun15 ] { A_Run(4.0); };
void() S_ZombieRun15 = [ $Run15, S_ZombieRun16 ] { A_Run(6.0); };
void() S_ZombieRun16 = [ $Run16, S_ZombieRun17 ] { A_Run(7.0); };
void() S_ZombieRun17 = [ $Run17, S_ZombieRun18 ] { A_Run(3.0); };
void() S_ZombieRun18 = [ $Run18, S_ZombieRun1 ]
{
	float r = Random();
	if (r < 0.2)
		PlaySound(self, CHAN_VOICE, "zombie/z_idle.wav", 1.0, ATTN_IDLE);
	else if (r > 0.8)
		PlaySound(self, CHAN_VOICE, "zombie/z_idle1.wav", 1.0, ATTN_IDLE);
	
	A_Run(8.0);
};

void()S_ZombieMissileA1 = [ $MissileA1,S_ZombieMissileA2 ] { A_Face(); };
void()S_ZombieMissileA2 = [ $MissileA2,S_ZombieMissileA3 ] { A_Face(); };
void()S_ZombieMissileA3 = [ $MissileA3,S_ZombieMissileA4 ] { A_Face(); };
void()S_ZombieMissileA4 = [ $MissileA4,S_ZombieMissileA5 ] { A_Face(); };
void()S_ZombieMissileA5 = [ $MissileA5,S_ZombieMissileA6 ] { A_Face(); };
void()S_ZombieMissileA6 = [ $MissileA6,S_ZombieMissileA7 ] { A_Face(); };
void()S_ZombieMissileA7 = [ $MissileA7,S_ZombieMissileA8 ] { A_Face(); };
void()S_ZombieMissileA8 = [ $MissileA8,S_ZombieMissileA9 ] { A_Face(); };
void()S_ZombieMissileA9 = [ $MissileA9,S_ZombieMissileA10 ] { A_Face(); };
void()S_ZombieMissileA10 = [ $MissileA10,S_ZombieMissileA11 ] { A_Face(); };
void()S_ZombieMissileA11 = [ $MissileA11,S_ZombieMissileA12 ] { A_Face(); };
void()S_ZombieMissileA12 = [ $MissileA12,S_ZombieMissileA13 ] { A_Face(); };
void()S_ZombieMissileA13 = [ $MissileA13, S_ZombieRun1 ] { A_ZombieMissileAttack([-10.0, -22.0, 30.0]); };

void()S_ZombieMissileB1 = [ $MissileB1,S_ZombieMissileB2 ] { A_Face(); };
void()S_ZombieMissileB2 = [ $MissileB2,S_ZombieMissileB3 ] { A_Face(); };
void()S_ZombieMissileB3 = [ $MissileB3,S_ZombieMissileB4 ] { A_Face(); };
void()S_ZombieMissileB4 = [ $MissileB4,S_ZombieMissileB5 ] { A_Face(); };
void()S_ZombieMissileB5 = [ $MissileB5,S_ZombieMissileB6 ] { A_Face(); };
void()S_ZombieMissileB6 = [ $MissileB6,S_ZombieMissileB7 ] { A_Face(); };
void()S_ZombieMissileB7 = [ $MissileB7,S_ZombieMissileB8 ] { A_Face(); };
void()S_ZombieMissileB8 = [ $MissileB8,S_ZombieMissileB9 ] { A_Face(); };
void()S_ZombieMissileB9 = [ $MissileB9,S_ZombieMissileB10 ] { A_Face(); };
void()S_ZombieMissileB10 = [ $MissileB10,S_ZombieMissileB11 ] { A_Face(); };
void()S_ZombieMissileB11 = [ $MissileB11,S_ZombieMissileB12 ] { A_Face(); };
void()S_ZombieMissileB12 = [ $MissileB12,S_ZombieMissileB13 ] { A_Face(); };
void()S_ZombieMissileB13 = [ $MissileB13,S_ZombieMissileB14 ] { A_Face(); };
void()S_ZombieMissileB14 = [ $MissileB13, S_ZombieRun1 ] { A_ZombieMissileAttack([-10.0, -24.0, 29.0]); };

void()S_ZombieMissileC1 = [ $MissileC1,S_ZombieMissileC2 ] { A_Face(); };
void()S_ZombieMissileC2 = [ $MissileC2,S_ZombieMissileC3 ] { A_Face(); };
void()S_ZombieMissileC3 = [ $MissileC3,S_ZombieMissileC4 ] { A_Face(); };
void()S_ZombieMissileC4 = [ $MissileC4,S_ZombieMissileC5 ] { A_Face(); };
void()S_ZombieMissileC5 = [ $MissileC5,S_ZombieMissileC6 ] { A_Face(); };
void()S_ZombieMissileC6 = [ $MissileC6,S_ZombieMissileC7 ] { A_Face(); };
void()S_ZombieMissileC7 = [ $MissileC7,S_ZombieMissileC8 ] { A_Face(); };
void()S_ZombieMissileC8 = [ $MissileC8,S_ZombieMissileC9 ] { A_Face(); };
void()S_ZombieMissileC9 = [ $MissileC9,S_ZombieMissileC10 ] { A_Face(); };
void()S_ZombieMissileC10 = [ $MissileC10,S_ZombieMissileC11 ] { A_Face(); };
void()S_ZombieMissileC11 = [ $MissileC11,S_ZombieMissileC12 ] { A_Face(); };
void()S_ZombieMissileC12 = [ $MissileC12, S_ZombieRun1 ] { A_ZombieMissileAttack([-12.0, -19.0, 29.0]); };

void() S_ZombiePainA1 = [ $PainA1, S_ZombiePainA2 ] { PlaySound(self, CHAN_VOICE, "zombie/z_pain.wav", 1.0, ATTN_NORM); };
void() S_ZombiePainA2 = [ $PainA2, S_ZombiePainA3 ] { A_Move(3.0); };
void() S_ZombiePainA3 = [ $PainA3, S_ZombiePainA4 ] { A_Move(1.0); };
void() S_ZombiePainA4 = [ $PainA4, S_ZombiePainA5 ] { A_Move(self.angles.y + 180.0, 1.0); };
void() S_ZombiePainA5 = [ $PainA5, S_ZombiePainA6 ] { A_Move(self.angles.y + 180.0, 3.0); };
void() S_ZombiePainA6 = [ $PainA6, S_ZombiePainA7 ] { A_Move(self.angles.y + 180.0, 1.0); };
void() S_ZombiePainA7 = [ $PainA7, S_ZombiePainA8 ] {};
void() S_ZombiePainA8 = [ $PainA8, S_ZombiePainA9 ] {};
void() S_ZombiePainA9 = [ $PainA9, S_ZombiePainA10 ] {};
void() S_ZombiePainA10 = [ $PainA10, S_ZombiePainA11 ] {};
void() S_ZombiePainA11 = [ $PainA11, S_ZombiePainA12 ] {};
void() S_ZombiePainA12 = [ $PainA12, S_ZombieRun1 ] {};

void() S_ZombiePainB1 = [ $PainB1, S_ZombiePainB2 ] { PlaySound(self, CHAN_VOICE, "zombie/z_pain1.wav", 1.0, ATTN_NORM); };
void() S_ZombiePainB2 = [ $PainB2, S_ZombiePainB3 ] { A_Move(self.angles.y + 180.0, 2.0); };
void() S_ZombiePainB3 = [ $PainB3, S_ZombiePainB4 ] { A_Move(self.angles.y + 180.0, 8.0); };
void() S_ZombiePainB4 = [ $PainB4, S_ZombiePainB5 ] { A_Move(self.angles.y + 180.0, 6.0); };
void() S_ZombiePainB5 = [ $PainB5, S_ZombiePainB6 ] { A_Move(self.angles.y + 180.0, 2.0); };
void() S_ZombiePainB6 = [ $PainB6, S_ZombiePainB7 ] {};
void() S_ZombiePainB7 = [ $PainB7, S_ZombiePainB8 ] {};
void() S_ZombiePainB8 = [ $PainB8, S_ZombiePainB9 ] {};
void() S_ZombiePainB9 = [ $PainB9, S_ZombiePainB10 ] { PlaySound(self, CHAN_BODY, "zombie/z_fall.wav", 1.0, ATTN_NORM); };
void() S_ZombiePainB10 = [ $PainB10, S_ZombiePainB11 ] {};
void() S_ZombiePainB11 = [ $PainB11, S_ZombiePainB12 ] {};
void() S_ZombiePainB12 = [ $PainB12, S_ZombiePainB13 ] {};
void() S_ZombiePainB13 = [ $PainB13, S_ZombiePainB14 ] {};
void() S_ZombiePainB14 = [ $PainB14, S_ZombiePainB15 ] {};
void() S_ZombiePainB15 = [ $PainB15, S_ZombiePainB16 ] {};
void() S_ZombiePainB16 = [ $PainB16, S_ZombiePainB17 ] {};
void() S_ZombiePainB17 = [ $PainB17, S_ZombiePainB18 ] {};
void() S_ZombiePainB18 = [ $PainB18, S_ZombiePainB19 ] {};
void() S_ZombiePainB19 = [ $PainB19, S_ZombiePainB20 ] {};
void() S_ZombiePainB20 = [ $PainB20, S_ZombiePainB21 ] {};
void() S_ZombiePainB21 = [ $PainB21, S_ZombiePainB22 ] {};
void() S_ZombiePainB22 = [ $PainB22, S_ZombiePainB23 ] {};
void() S_ZombiePainB23 = [ $PainB23, S_ZombiePainB24 ] {};
void() S_ZombiePainB24 = [ $PainB24, S_ZombiePainB25 ] {};
void() S_ZombiePainB25 = [ $PainB25, S_ZombiePainB26 ] { A_Move(1.0); };
void() S_ZombiePainB26 = [ $PainB26, S_ZombiePainB27 ] {};
void() S_ZombiePainB27 = [ $PainB27, S_ZombiePainB28 ] {};
void() S_ZombiePainB28 = [ $PainB28, S_ZombieRun1 ] {};

void() S_ZombiePainC1 = [ $PainC1, S_ZombiePainC2 ] { PlaySound(self, CHAN_VOICE, "zombie/z_pain1.wav", 1.0, ATTN_NORM); };
void() S_ZombiePainC2 = [ $PainC2, S_ZombiePainC3 ] {};
void() S_ZombiePainC3 = [ $PainC3, S_ZombiePainC4 ] { A_Move(self.angles.y + 180.0, 3.0); };
void() S_ZombiePainC4 = [ $PainC4, S_ZombiePainC5 ] { A_Move(self.angles.y + 180.0, 1.0); };
void() S_ZombiePainC5 = [ $PainC5, S_ZombiePainC6 ] {};
void() S_ZombiePainC6 = [ $PainC6, S_ZombiePainC7 ] {};
void() S_ZombiePainC7 = [ $PainC7, S_ZombiePainC8 ] {};
void() S_ZombiePainC8 = [ $PainC8, S_ZombiePainC9 ] {};
void() S_ZombiePainC9 = [ $PainC9, S_ZombiePainC10 ] {};
void() S_ZombiePainC10 = [ $PainC10, S_ZombiePainC11 ] {};
void() S_ZombiePainC11 = [ $PainC11, S_ZombiePainC12 ] { A_Move(1.0); };
void() S_ZombiePainC12 = [ $PainC12, S_ZombiePainC13 ] { A_Move(1.0); };
void() S_ZombiePainC13 = [ $PainC13, S_ZombiePainC14 ] {};
void() S_ZombiePainC14 = [ $PainC14, S_ZombiePainC15 ] {};
void() S_ZombiePainC15 = [ $PainC15, S_ZombiePainC16 ] {};
void() S_ZombiePainC16 = [ $PainC16, S_ZombiePainC17 ] {};
void() S_ZombiePainC17 = [ $PainC17, S_ZombiePainC18 ] {};
void() S_ZombiePainC18 = [ $PainC18, S_ZombieRun1 ] {};

void() S_ZombiePainD1 = [ $PainD1, S_ZombiePainD2 ] { PlaySound(self, CHAN_VOICE, "zombie/z_pain.wav", 1,0, ATTN_NORM); };
void() S_ZombiePainD2 = [ $PainD2, S_ZombiePainD3 ] {};
void() S_ZombiePainD3 = [ $PainD3, S_ZombiePainD4 ] {};
void() S_ZombiePainD4 = [ $PainD4, S_ZombiePainD5 ] {};
void() S_ZombiePainD5 = [ $PainD5, S_ZombiePainD6 ] {};
void() S_ZombiePainD6 = [ $PainD6, S_ZombiePainD7 ] {};
void() S_ZombiePainD7 = [ $PainD7, S_ZombiePainD8 ] {};
void() S_ZombiePainD8 = [ $PainD8, S_ZombiePainD9 ] {};
void() S_ZombiePainD9 = [ $PainD9, S_ZombiePainD10 ] { A_Move(self.angles.y + 180.0, 1.0); };
void() S_ZombiePainD10 = [ $PainD10, S_ZombiePainD11 ] {};
void() S_ZombiePainD11 = [ $PainD11, S_ZombiePainD12 ] {};
void() S_ZombiePainD12 = [ $PainD12, S_ZombiePainD13 ] {};
void() S_ZombiePainD13 = [ $PainD13, S_ZombieRun1 ] {};

void() S_ZombiePainE1 = [ $PainE1, S_ZombiePainE2 ] { PlaySound(self, CHAN_VOICE, "zombie/z_pain.wav", 1.0, ATTN_NORM); };
void() S_ZombiePainE2 = [ $PainE2, S_ZombiePainE3 ] { A_Move(self.angles.y + 180.0, 8.0); };
void() S_ZombiePainE3 = [ $PainE3, S_ZombiePainE4 ] { A_Move(self.angles.y + 180.0, 5.0); };
void() S_ZombiePainE4 = [ $PainE4, S_ZombiePainE5 ] { A_Move(self.angles.y + 180.0, 3.0); };
void() S_ZombiePainE5 = [ $PainE5, S_ZombiePainE6 ] { A_Move(self.angles.y + 180.0, 1.0); };
void() S_ZombiePainE6 = [ $PainE6, S_ZombiePainE7 ] { A_Move(self.angles.y + 180.0, 2.0); };
void() S_ZombiePainE7 = [ $PainE7, S_ZombiePainE8 ] { A_Move(self.angles.y + 180.0, 1.0); };
void() S_ZombiePainE8 = [ $PainE8, S_ZombiePainE9 ] { A_Move(self.angles.y + 180.0, 1.0); };
void() S_ZombiePainE9 = [ $PainE9, S_ZombiePainE10 ] { A_Move(self.angles.y + 180.0, 2.0); };
void() S_ZombiePainE10 = [ $PainE10, S_ZombiePainE11 ]
{
	PlaySound(self, CHAN_BODY, "zombie/z_fall.wav", 1.0, ATTN_NORM);
	SetSolid(self, SOLID_NOT);
};
void() S_ZombiePainE11 = [ $PainE11, S_ZombiePainE12 ] { SetNextThinkTime(self, 5.0); };
void() S_ZombiePainE12 = [ $PainE12, S_ZombiePainE13 ]
{
	// see if ok to stand up
	SetSolid(self, SOLID_SLIDEBOX);
	if (!A_TryMove(0.0, 0.0))
	{
		SetSolid(self, SOLID_NOT);
		S_ZombiePainE11();
		return;
	}
	
	PlaySound(self, CHAN_VOICE, "zombie/z_idle.wav", 1.0, ATTN_IDLE);
};
void() S_ZombiePainE13 = [ $PainE13, S_ZombiePainE14 ] {};
void() S_ZombiePainE14 = [ $PainE14, S_ZombiePainE15 ] {};
void() S_ZombiePainE15 = [ $PainE15, S_ZombiePainE16 ] {};
void() S_ZombiePainE16 = [ $PainE16, S_ZombiePainE17 ] {};
void() S_ZombiePainE17 = [ $PainE17, S_ZombiePainE18 ] {};
void() S_ZombiePainE18 = [ $PainE18, S_ZombiePainE19 ] {};
void() S_ZombiePainE19 = [ $PainE19, S_ZombiePainE20 ] {};
void() S_ZombiePainE20 = [ $PainE20, S_ZombiePainE21 ] {};
void() S_ZombiePainE21 = [ $PainE21, S_ZombiePainE22 ] {};
void() S_ZombiePainE22 = [ $PainE22, S_ZombiePainE23 ] {};
void() S_ZombiePainE23 = [ $PainE23, S_ZombiePainE24 ] {};
void() S_ZombiePainE24 = [ $PainE24, S_ZombiePainE25 ] {};
void() S_ZombiePainE25 = [ $PainE25, S_ZombiePainE26 ] { A_Move(5.0); };
void() S_ZombiePainE26 = [ $PainE26, S_ZombiePainE27 ] { A_Move(3.0); };
void() S_ZombiePainE27 = [ $PainE27, S_ZombiePainE28 ] { A_Move(1.0); };
void() S_ZombiePainE28 = [ $PainE28, S_ZombiePainE29 ] { A_Move(1.0); };
void() S_ZombiePainE29 = [ $PainE29, S_ZombiePainE30 ] {};
void() S_ZombiePainE30 = [ $PainE30, S_ZombieRun1 ] {};

void A_ZombieMissile()
{
	float r = Random();
	if (r < 0.33)
		ZombieMissileA1();
	else if (r < 0.66)
		ZombieMissileB1();
	else
		ZombieMissileC1();
}

// Special handling for blood chunks since they act a bit more organic
// than a standard projectile
void P_ZombieBloodChunkTouch()
{
	if (!other && GetContentsAtPoint(self.origin) == CONTENTS_SKY)
	{
		DestroyEntity(self);
		return;
	}
	
	// Add a little extra gore flare on impact
	SpawnBloodSpray(self.origin, self.velocity, self.dmg);
	
	int_t type = other.takedamage;
	if (type != DAMAGE_NO)
	{
		int_t damage = self.dmg;
		if (self.rad_dmg >= 1 && (other.flags & FL_EXPLOSIVE_RESIST))
			damage *= 0.5;
		
		DamageEntity(other, self, self.owner, damage);
		if (type != DAMAGE_USE)
		{
			self.old_enemy = other;
			A_ExplodeMissile();
			return;
		}
	}
	
	PlaySound(self, CHAN_BODY, self.noise3, 1.0, ATTN_NORM);
	self.velocity *= 0.1; // Add a little bit of bounce back
	self.avelocity *= 0.1
	self.touch = A_Remove;
}

void missile_zombiebloodchunk()
{
	self.dmg = 10;
	self.deathtype = "gore";
	self.noise2 = "";
	self.noise3 = "";
	self.deathflag = TE_INVALID;
	self.Obituary = OBIT_ZOMBIE;
	
	StartMissile(self, "progs/zom_gib.mdl", TRUE);
}

void A_ZombieMissileAttack(vector offset)
{
	A_Face();
	
	FixedLocalAxes(self.angles);
	
	PlaySound(self, CHAN_WEAPON, "zombie/z_shot1.wav", 1.0, ATTN_NORM);
	
	vector orig = self.origin + v_forward * offset.x + v_right * offset.y + v_up * offset.z;
	// Since the aiming is buggy, only check this on the 2D plane to keep proper missile speed
	vector dir = GetAimDir(self.enemy, orig, VEC_ZERO, TRUE);
	entity missile = SpawnMissile(self, missile_zombiebloodchunk, orig, dir, 600.0, [3000.0, 1000.0, 2000.0], 2.5);
	missile.velocity.z = 200.0;
}

enum int_t
{
	PAIN_NONE,
	PAIN_STAGGERED,
	PAIN_KNOCKED_DOWN,
};

bool_t A_ZombiePain(entity attacker, entity inflictor, int_t damage)
{
	if (damage < 9 || self.count >= PAIN_KNOCKED_DOWN)
		return FALSE;

	// go down immediately if a big enough hit or if already staggered
	if (damage >= 25 || (self.count == PAIN_STAGGERED && !TimerExpired(self.pain_finished))
	{
		self.count = PAIN_KNOCKED_DOWN;
		S_ZombiePainE1();
		return FALSE;
	}

	// go into one of the fast pain animations
	self.count = PAIN_STAGGERED;
	SetCoolDown(self, pain_finished, 3.0);

	float r = Random();
	if (r < 0.25)
		S_ZombiePainA1();
	else if (r < 0.5)
		S_ZombiePainB1();
	else if (r < 0.75)
		S_ZombiePainC1();
	else
		S_ZombiePainD1();
	
	return FALSE;
}

// No death state since it's always gibbed
void A_ZombieDie()
{
	GibEntity(self, "progs/h_zombie.mdl", "zombie/z_gib.wav");
}

enumflags
{
	SPAWN_CRUCIFIED,
}

void monster_zombie()
{
	if (self.spawnflags & SPAWN_CRUCIFIED)
	{
		PrecacheModel("progs/zombie.mdl");
		PrecacheSound("zombie/idle_w2.wav");

		SetPhysics(self, SOLID_NOT, MOVETYPE_NONE);
		InitializeEntity(self, "progs/zombie.mdl");
		S_ZombieCrucifix1();
		return;
	}
	
	if (WorldLoading())
	{
		PrecacheEntity(missile_zombiebloodchunk);
		
		PrecacheSound("zombie/z_idle.wav");
		PrecacheSound("zombie/z_idle1.wav");
		PrecacheSound("zombie/z_shot1.wav");
		PrecacheSound("zombie/z_pain.wav");
		PrecacheSound("zombie/z_pain1.wav");
		PrecacheSound("zombie/z_fall.wav");
		PrecacheSound("zombie/z_gib.wav");
		PrecacheSound("zombie/z_miss.wav");
		PrecacheSound("zombie/z_hit.wav");
	}
	
	self.th_stand = S_ZombieIdle1;
	self.th_walk = S_ZombieWalk1;
	self.th_run = S_ZombieRun1;
	self.th_missile = A_ZombieMissile;
	self.th_pain = A_ZombiePain;
	self.th_die = A_ZombieDie;
	
	self.health = 60;
	self.flags |= FL_MUST_GIB;
	
	StartMonster(self, "progs/zombie.mdl", "progs/h_zombie.mdl");
}
