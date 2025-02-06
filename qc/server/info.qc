
void info_player_start() {}

// Start after the player has collected a rune
void info_player_start2() {}

void info_player_deathmatch() {}

void info_player_coop() {}

void info_intermission() {}

void noclass()
{
	A_ThrowEntityException("No class specified");
}

void bodyqueue() {}

// Damage types for events that happen to clients that have no real
// inflictor

void world_slime()
{
	self.damage_type = "burn";
	self.obituary_prefix = OBIT_PRE_SLIME;
	self.obituary_suffix = OBIT_SUF_SLIME;
}

void world_lava()
{
	self.damage_type = "burn";
	self.obituary_prefix = OBIT_PRE_LAVA;
	self.obituary_suffix = OBIT_SUF_LAVA;
}

void world_gravity()
{
	self.damage_type = "falling";
	self.obituary_prefix = OBIT_PRE_GRAVITY;
	self.obituary_suffix = OBIT_SUF_GRAVITY;
}

void world_water()
{
	self.damage_type = "drown";
	self.obituary_prefix = OBIT_PRE_WATER;
	self.obituary_suffix = OBIT_SUF_WATER;
}
