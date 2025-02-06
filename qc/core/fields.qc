
// Globals

// Track if the game was reloaded for certain operations
nosave bool_t game_loaded;

// Server info
entity latest_client;
int_t num_players;
int_t server_frame;
entity last_player_spawn;
entity body_queue_head;
flags_t starting_flags;
int_t prev_killed_monsters, prev_found_secrets;
int_t prev_total_monsters, prev_total_secrets;

// Pass along information about the sources dealing these damage types. Since the client
// doesn't store the actual liquid brush it's in, this is an easy way to pass that
// info along that's customizable, albeit only from the scripting side
entity slime_ent, lava_ent, water_ent, gravity_ent;

// Map state
enumflags
{
	SV_GAME_OVER,	// Going to the next level
	SV_RESET_INV,	// Force reset inventory to defaults
	SV_RELOADING,	// Singleplayer game is reloading
	SV_LIQUID_HURTS_MONSTERS,
	SV_NO_FALL_DMG,
	SV_NO_DROWN,
};

flags_t server_state;
int_t skill;
string next_map;
int_t intermission_active;
float intermission_exit_time;
entity intermission_pos;
string intermission_text, next_intermission_text;
int_t next_intermission_track;
// These have to be tracked so they can be restored on load
vector map_fog_color;
float map_fog_density;
string map_sky;

// Special case to allow modifying the cd track in a map in a way that saves
// to savegame files. The current track can be checked directly via world.sounds
// but can't through this pointer since vanilla QC supports writing only from pointers
uint8_t* current_song;

// Monsters
// These are the only globals for them and don't greatly
// affect logic like they used to since A_FindEnemy got
// rewritten, so they stay for efficiency reasons

entity hostile_monster;
float hostile_monster_time;

// Artificial system fields
// These are fields QuakeSpasm supports and is explicitly checked for in the engine. They'll
// do nothing in vanilla

.float alpha;
.float scale;	// Note: This only affects model size, not the actual bounding box
.float gravity;	// 1.0 = normal gravity, 0.0 = engine default

// Expansion pack support; only define these if you're going to use them. They'll
// require .items2 to be defined if you're going to use the HUD proper

// Overrides runes in the HUD if defined. Only supports first 9 bits since
// it gets packed into .items instead of the runes giving it a base offset
// of 1 << 23
//.flags_t items2;

//.int_t ammo_shells1, ammo_nails1, ammo_rockets1, ammo_cells1;	// Hipnotic
//.int_t ammo_lava_nails, ammo_multi_rockets, ammo_plasma;		// Rogue

// World

.int_t worldtype;	// See WORLD_* constants

// General

.float misc_action;					// For various actions/flags on different entities
.float timer_finished;				// For random timers that don't fit with the other timers
.void(bool_t activate) th_dormant;	// Controls how an entity acts when dormancy is triggered
.string killtarget;					// Entities to remove when activated
.string target2, target3, target4;	// Expanded activate functionality for less relay trigger spam
.float rand_val;					// For randomized mapsetting parameters
.entity activator;					// Thing currently activating this entity
.angles_t mangle;					// Spawn angle of entity
.vector morigin;					// Spawn location of entity
.entity inventory;					// List containing picked up level items e.g. powerups
.float fly_sound;					// Cool down for pusher noise on specific entities
.float damage_finished;
.float heal_finished;
.entity destructible;				// This entity is automatically cleaned up via DestroyEntity

// Client

enum : int_t
{
	WS_READY,
	WS_LOWERING,
	WS_RAISING,
};

.uint8_t anim_frame;			// For looping states to keep track of the current animation frame
.float alert_finished;			// Used to check if the client recently alerted nearby monsters
.float water_damage_finished;	// Cool down for controlling liquid damage
.float air_finished;			// When diminished, start drowning
.float swim_sound;				// Cool down for swimming sounds
.flags_t owned_weapons;
.uint_t current_slot;
.uint_t pending_slot;			// This is meant to handle weapon switching much more gracefully than banking on impulses
.uint_t current_ammo_type;
.uint8_t weapon_anim_frame;
.float weapon_next_think;		// Controls view model logic
.void() weapon_think;
.int_t weapon_state;

// Monsters

enum : int_t
{
	AS_STRAIGHT,
	AS_SLIDING,
	AS_MELEE,
	AS_MISSILE,
};

enumflags
{
	MON_REFIRE,
	MON_LEFT_STRAFE,
};

.entity old_enemy; // Last player a monster was attacking
.float search_time; // Cool down between searching for new enemies in coop
.float pause_time; // How long monsters should stand still at path corners before walking again
.float attack_finished; // Cool down between attacks
.float pain_finished; // Cool down between pain instances
.void() th_stand; // Called when spawning and after enemy dies
.void() th_walk; // Called when pathing between nodes
.void() th_run; // Called when finding a new enemy
.void() th_missile; // Missile attack
.void() th_melee; // Melee attack
.bool_t(entity inflictor, entity attacker, int_t damage) th_pain; // Called when damaged
.void() th_die; // Called when killed
.bool_t() th_check; // Called when checking for attacking enemy

// Projectiles

.string obituary_prefix, obituary_suffix;	// Before, after client name
.int_t rad_dmg;
.string damage_type;

// Items

.string mdl;	// Stores current model on items
.int_t amount;
.float invincible_sound;
.float super_sound;

// Triggers

.int_t count;
.string map;	// Used to track which map to go to via changelevel triggers

// Movers

.entity trigger_ent;		// Keeps track of the trigger entity that activates it
.float speed, speed2;		// Used by various movers to control movement speed
.int_t dmg;
.vector move_start, move_dest;	// Tracks destination on movers when moving
.void() th_movedest;			// Function to play for movers when reaching their destination
.vector move_interp1, move_interp2;	// For Bezier curves
.float move_start_time, move_end_time;
.int_t state;				// Activation state for movers
.vector pos1, pos2, pos3;	// Stores various goal positions for movers
.float lip;					// How far out certain movers should jut out
.float height;				// How tall platforms should be
.float wait;				// Wait time in seconds for various movers
.float delay;				// Delay in seconds before an activated entity will fire
.string noise4;				// Extended noise field for movers

// Lights

.float light_lev; // Corresponds to the "light" key in editors; unused but kept to suppress warnings with old maps
.uint8_t style;	// Layer that a light affects

// Sounds

.float distance;
.float volume;
