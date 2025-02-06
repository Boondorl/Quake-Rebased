$framevalue 1
$frame FireA1 FireA2 FireA3 FireA4
$frame FireB1 FireB2 FireB3 FireB4

void() W_AxeFireA1 = [ $FireA1, W_AxeFireA2 ] {};
void() W_AxeFireA2 = [ $FireA2, W_AxeFireA3 ] {};
void() W_AxeFireA3 = [ $FireA3, W_AxeFireA3 ] { PlayerAxeAttack(); };
void() W_AxeFireA4 = [ $FireA4, __NULL__ ] {};

void() W_AxeFireB1 = [ $FireB1, W_AxeFireB2 ] {};
void() W_AxeFireB2 = [ $FireB2, W_AxeFireB3 ] {};
void() W_AxeFireB3 = [ $FireB3, W_AxeFireB4 ] { PlayerAxeAttack(); };
void() W_AxeFireB4 = [ $FireB4, __NULL__ ] {};

void PlayerAxeAttack()
{
	SetLocalAxes(self.v_angles);
	
	vector orig = self.origin + [0.0, 0.0, 16.0];
	if (!MeleeAttack(self, orig, GetAutoaimDir(self, 640.0), 20))
		return;
	
	SetCoolDown(self, alert_finished, 1.0);
	if (trace_ent)
	{
		if (trace_ent.health >= 1 && IsClient(trace_ent))
			trace_ent.misc_action |= CL_AXE_HIT;
	}
	else
	{
		PlaySound(self, CHAN_WEAPON, "player/axhit2.wav", 1.0, ATTN_NORM);
	}
}

// The actual melee attack is done within the animation to time it with the swing
void A_FireAxe()
{
	PlaySound(self, CHAN_WEAPON, "weapons/ax1.wav", 1.0, ATTN_NORM);
	
	float r = Random();
	if (r < 0.5)
	{
		SetWeaponState(self, W_AxeFireA1);
		if (r < 0.25)
			S_PlayerMeleeA1();
		else
			S_PlayerMeleeC1();
	}
	else
	{
		SetWeaponState(self, W_AxeFireB2);
		if (r < 0.75)
			S_PlayerMeleeB1();
		else
			S_PlayerMeleeD1();
	}
}
