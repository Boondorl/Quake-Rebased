// Useful global constants that all things will need access to
// __NULL__ should be used in place of the old null constants

// General

const string STR_EMPTY	= "";

const vector VEC_ZERO		= { 0.0, 0.0, 0.0 };
const vector VEC_FORWARD	= { 1.0, 0.0, 0.0 };
const vector VEC_BACK		= { -1.0, 0.0, 0.0 };
const vector VEC_LEFT		= { 0.0, 1.0, 0.0 };
const vector VEC_RIGHT		= { 0.0, -1.0, 0.0 };
const vector VEC_UP			= { 0.0, 0.0, 1.0 };
const vector VEC_DOWN		= { 0.0, 0.0, -1.0 };

// Note that uints can't exist since floats can't even properly reach the normal
// 32-bit integer limit making converting it nonsensical
const int_t FLT_ROUNDS		= 1;
const int_t FLT_RADIX		= 2;
const int_t FLT_DIG			= 6;
const int_t FLT_MANT_DIG	= 24;
const int_t FLT_MAX_EXP		= 128;
const int_t FLT_MIN_EXP		= -127;
const int_t FLT_MAX_10_EXP	= 38;
const int_t FLT_MIN_10_EXP	= -37;
const float FLT_MAX			= 340282346600000000000000000000000000000.0;
const float FLT_MIN			= 0.00000000000000000000000000000000000001175494351;
const float FLT_EPSILON		= 0.0000001192092896;
const int_t INT8_MAX		= 127;
const int_t INT8_MIN		= -128;
const int_t UINT8_MAX		= 255;
const int_t INT16_MAX		= 32767;
const int_t INT16_MIN		= -32768;
const int_t UINT16_MAX		= 65535;
const int_t INT_BIT			= FLT_MANT_DIG;		// Since it's all floats, we have to cap it to the mantissa digits
const int_t INT_MAX			= 16777216;			// 2 ^ FLT_MANT_DIG
const int_t INT_MIN			= -INT_MAX;			// Due to the weird way this works, just negate the max number
const bool_t FALSE			= 0;
const bool_t TRUE			= 1;

// Quake specific

const float ENGINE_HZ		= 72.0;				// Quake's VM updates at a max of 72Hz
const float ENGINE_HZ_TIME	= 1.0 / ENGINE_HZ;
const float SERVER_HZ		= 10.0;				// Rate at which the server sends network updates
const float SERVER_HZ_TIME	= 1.0 / SERVER_HZ;
const float TIME_EPSILON	= 0.013;			// Time differences below this don't have any meaning
const float METER			= 32.0;				// How many map units are in a meter.
const float INVERSE_METER	= 1.0 / METER;
const float MAX_STEP_HEIGHT	= 18.0;

// Pre-calculated AABB collision sizes used against map geometry
// (avoid straying far from these when setting non-brush entity sizes on things meant to collide with world geometry)
// If using custom sizes, here are the safe ones that won't break collision detection:
// 0x0x0
// 3x3x0 - 32x32x56
// 33x33x0 - 64x64x88
// The hull is essentially rounded to the next biggest hull by measuring the size.x value.
const vector AABB_MIN		= { -16.0, -16.0, -24.0 };
const vector AABB_MAX		= { 16.0, 16.0, 32.0 };
const vector AABB_LARGE_MIN	= { -32.0, -32.0, -24.0 };
const vector AABB_LARGE_MAX	= { 32.0, 32.0, 64.0 };

// Commonly used sounds
const string SND_NULL		= "misc/null.wav";
const string SND_MESSAGE	= "misc/talk.wav";
const string SND_GIB		= "player/udeath.wav";
const string SND_SECRET		= "misc/secret.wav";

// Deathmatch
const int_t DM_MODERN	= 1;
const int_t TDM_MODERN	= 1;

// Level type set on the world
enum : int_t
{
	WORLD_MEDIEVAL,
	WORLD_METAL,
	WORLD_BASE,
};

// Skill levels
enum : int_t
{
	SK_EASY,
	SK_NORMAL,
	SK_HARD,
	SK_NIGHTMARE,
};

// Entity flags
enumflags
{
	FL_FLY,					// Can fly
	FL_SWIM,				// Can swim (same as FL_FLY but won't leave liquids)
	FL_CLIENT				= 1 << 3,	// Set for all client entities
	FL_INWATER,				// Used to track when to play water splash sound
	FL_MONSTER,				// Entity is considered a monster
	FL_GODMODE,				// No damage
	FL_NOTARGET,			// Cannot be seen by monsters
	FL_ITEM,				// Entity is considered an item
	FL_ONGROUND,			// Standing on something
	FL_PARTIALGROUND,		// Not all corners of the AABB are on the ground
	FL_WATERJUMP,			// Client currently jumping out of the water
	FL_JUMPRELEASED,		// Client is able to jump
	
	// Extended flags to better generalize behavior
	
	FL_MISSILE,				// Entity is considered a missile
	FL_COUNT_MONSTER,		// Monster counts towards total
	FL_COUNT_SECRET,		// For items and triggers marked as secrets directly
	FL_AVOID,				// Monsters will avoid fighting this entity
	FL_IGNORE_INFIGHT,		// Monster won't infight with other monsters
	FL_INFIGHT_CLASS,		// Monster can infight with monsters that have the same type
	FL_MUST_GIB,			// Cannot die unless damage hits health threshold
	FL_EXPLOSIVE_RESIST,	// Take half damage from explosives, including impacts
	FL_BOSS,				// Marks the monster as a level boss
	FL_FREED,				// Used to indicate an entity was removed. Don't (un)set this manually
};

// Default spawn flags shared between all entities
enumflags
{
	SPAWNFLAG_NOT_EASY			= 1 << 8,
	SPAWNFLAG_NOT_MEDIUM,
	SPAWNFLAG_NOT_HARD,
	SPAWNFLAG_NOT_DEATHMATCH,
	
	// Extended spawn flags
	
	SPAWNFLAG_COOPONLY,
	SPAWNFLAG_NOTINCOOP,
	SPAWNFLAG_DORMANT,			// Has various effects depending on entity type
	SPAWNFLAG_GLOBAL_MESSAGE,
};

// Movement types
enum : int_t
{
	MOVETYPE_NONE,				// Doesn't move
	MOVETYPE_WALK			= 3,	// Client movement
	MOVETYPE_STEP,				// Moves in discrete steps (mostly for monsters)
	MOVETYPE_FLY,				// Flies around
	MOVETYPE_TOSS,				// Treat entity like it was thrown
	MOVETYPE_PUSH,				// Ignore map geo; push and crush entities (mostly for brush entities)
								// Only use this with SOLID_BSP
	MOVETYPE_NOCLIP,			// Don't collide with anything
	MOVETYPE_FLYMISSILE,		// Similar to MOVETYPE_FLY but gains a larger hitbox for checks against monsters only
	MOVETYPE_BOUNCE,			// Can bounce off of surfaces
};

// Solid types
enum : int_t
{
	SOLID_NOT,		// No interaction with other entities
	SOLID_TRIGGER,	// Trigger collisions but don't block. The collider's touch function isn't called
	SOLID_BBOX,		// Trigger collisions and block using AABB
	SOLID_SLIDEBOX,	// Same as SOLID_BBOX but should be used for clients and monsters
	SOLID_BSP,		// Uses BSP to collide and block instead of AABB (used with brush entities). Only use this with MOVETYPE_PUSH
};

// Clip types
enum : int_t
{
	MOVE_NORMAL,
	MOVE_NOMONSTERS,
	MOVE_MISSILE,		// Use a fake 30x30x30 size when tracing that can only hit slideboxes
};

// These are meant to be a bit more descriptive than the original
// since top/bottom don't really have much meaning to movers
enum : int_t
{
	FUNC_DEACTIVATED,
	FUNC_ACTIVATING,
	FUNC_ACTIVATED,
	FUNC_DEACTIVATING,
};

// Damage types
enum : int_t
{
	DAMAGE_NO,
	DAMAGE_YES,
	DAMAGE_AIM,				// Can be autoaimed by clients
	DAMAGE_DESTRUCT,		// Destrutible geo
	DAMAGE_DESTRUCT_BLEED,	// Destructible geo that should bleed instead
	DAMAGE_USE,				// Activate when hit instead of taking damage
};

// Entity effects
enumflags
{
	EF_BRIGHTFIELD,
	EF_MUZZLEFLASH,
	EF_BRIGHTLIGHT,
	EF_DIMLIGHT,
};

// Water levels
enum : int_t
{
	DEPTH_NONE,			// Entity not in a liquid
	DEPTH_FEET,			// Between bottom and halfway height of client
	DEPTH_WAIST,		// Between halfway and view height of client
	DEPTH_SUBMERGED,	// View height of client and above
	
	DEPTH_MONSTER_SUBMERGED = 1,	// Monsters can only have waterlevel 0 or 1
};

// Enemy ranges
enum : float
{
	RANGE_MELEE	= 120.0,
	RANGE_MID	= 500.0,
	RANGE_FAR	= 1000.0,
};

// Client death state
enum : int_t
{
	DEAD_NO,
	DEAD_DYING,
	DEAD_DEAD,
	DEAD_RESPAWNABLE,
};

// Items
enumflags
{
	// Note that these are deprecated in favor of .OwnedWeapons and only control
	// the weapon slot visuals in the HUD
	
	IT_SHOTGUN,
	IT_SUPER_SHOTGUN,
	IT_NAILGUN,
	IT_SUPER_NAILGUN,
	IT_GRENADE_LAUNCHER,
	IT_ROCKET_LAUNCHER,
	IT_LIGHTNING,
	IT_SUPER_LIGHTNING,	// Unused
	IT_AXE = 1 << 12,
	
	
	// Ammo (only used to determine which image to draw in the HUD)
	// Only one of these should be set at a time
	
	IT_SHELLS = 1 << 8,
	IT_NAILS,
	IT_ROCKETS,
	IT_CELLS,
	
	// Only used to determine what armor icon should be used
	// within the HUD (see .armortype and .armoramount for
	// actual armor setting)
	
	IT_ARMOR1 = 1 << 13,
	IT_ARMOR2,
	IT_ARMOR3,
	
	// Note that these have been deprecated in favor of level
	// inventories and only control which powerup icon is drawn
	// in the HUD + visual effect
	
	IT_SUPERHEALTH,	// Unused
	
	IT_KEY1,
	IT_KEY2,
	
	IT_INVISIBILITY,
	IT_INVULNERABILITY,
	IT_SUIT,
	IT_QUAD,
};

// Combined item flags
enum : int_t
{
	IT_DEFAULT_WEAPONS	= IT_SHOTGUN | IT_AXE,
	IT_WEAPONS			= IT_SHOTGUN | IT_SUPER_SHOTGUN | IT_NAILGUN | IT_SUPER_NAILGUN
							| IT_GRENADE_LAUNCHER | IT_ROCKET_LAUNCHER | IT_LIGHTNING | IT_SUPER_LIGHTNING | IT_AXE,
	IT_AMMO				= IT_SHELLS | IT_NAILS | IT_ROCKETS | IT_CELLS,
	IT_ARMOR			= IT_ARMOR1 | IT_ARMOR2 | IT_ARMOR3,
	IT_KEYS				= IT_KEY1 | IT_KEY2,
	IT_POWERUPS			= IT_INVISIBILITY | IT_INVULNERABILITY | IT_SUIT | IT_QUAD,
	IT_ALL				= IT_WEAPONS | IT_AMMO | IT_ARMOR | IT_SUPERHEALTH | IT_KEYS | IT_POWERUPS,
};

// Armor
// Only two decimal places of precision are used by default
const float ARMOR_NONE		= 0.0;
const float ARMOR_LIGHT		= 0.3;
const float ARMOR_MEDIUM	= 0.6;
const float ARMOR_HEAVY		= 0.8;

const int_t MAX_LIGHT_ARMOR		= 100;
const int_t MAX_MEDIUM_ARMOR	= 150;
const int_t MAX_HEAVY_ARMOR		= 200;

const int_t MAX_HEALTH = 250;

const int_t TELEFRAG_DAMAGE = INT_MAX;

// Runes tracked in serverflags system global
enumflags
{
	RUNE_EP_1,
	RUNE_EP_2,
	RUNE_EP_3,
	RUNE_EP_4,
};

const int_t RUNE_ALL = RUNE_EP_1 | RUNE_EP_2 | RUNE_EP_3 | RUNE_EP_4;

// Content types for BSP leaves
enum : int_t
{
	CONTENTS_SKY	= -6,
	CONTENTS_LAVA,
	CONTENTS_SLIME,
	CONTENTS_WATER,
	CONTENTS_SOLID,
	CONTENTS_EMPTY,
};

// Network messages
enum : int_t
{
	MSG_BROADCAST,	// Send to all clients without caring if they recieve it (use this for non-gameplay affecting elements)
	MSG_ONE,		// Send to a specific client (msg_entity)
	MSG_ALL,		// Send to all clients (use this if you need to guarantee every client recieved it)
};

// Server commands
// All commands themselves are written as a byte via WriteByte()
// [type] denotes the type of the additional arguments each command has. All argument types are provided in order
// [*_xyz] denotes that the type expects 3 arguments in x y z order
// Arguments are specified via the Write*() built-in functions
enum : uint8_t
{
	SVC_UPDATESTAT		= 3,	// [byte] stat (see STAT_* constants) [long] value
	SVC_TEMP_ENTITY		= 23,	// [byte] type (see TE_* constants) [coord_xyz] position
								// * LIGHTNING1-3 and BEAM additionally take [coord_xyz] destination
								// * EXPLOSION2 additionally takes [byte] color start index, [byte] color index range
	SVC_SETPAUSE		= 24,	// [byte] on/off
	SVC_INTERMISSION	= 30,
	SVC_FINALE			= 31,	// [string] message
	SVC_CDTRACK			= 32,	// [byte] cd track [byte] loop (unused but still needed)
	SVC_CUTSCENE		= 34,	// [string] message
	
	// Quakespasm server commands. These won't work vanilla
	
	SVC_SKYBOX			= 37,	// [string] skybox name
	SVC_FOG				= 41,	// [byte] density (0 - 255) [byte_xyz] rgb (0 - 255), [short] update time (seconds * 100)
};

// Temporary entity types
enum : uint8_t
{
	TE_INVALID = -1,
	
	TE_SPIKE,
	TE_SUPERSPIKE,
	TE_GUNSHOT,
	TE_EXPLOSION,
	TE_TAREXPLOSION,
	TE_LIGHTNING1,
	TE_LIGHTNING2,
	TE_WIZSPIKE,
	TE_KNIGHTSPIKE,
	TE_LIGHTNING3,
	TE_LAVASPLASH,
	TE_TELEPORT,
	TE_EXPLOSION2,
	TE_BEAM,
};

// Stat types
// The rest are automatically updated by modifying them directly
enum : uint8_t
{
	STAT_TOTALSECRETS	= 11,
	STAT_TOTALMONSTERS,
	STAT_SECRETS,
	STAT_MONSTERS,
};

// Sound channels
// Playing a sound on a channel overrides any sounds currently playing on it
enum : uint8_t
{
	CHAN_AUTO,		// Try not to override any channels
	CHAN_WEAPON,
	CHAN_VOICE,
	CHAN_ITEM,
	CHAN_BODY,
	
	// Extended channels
	
	CHAN_5,
	CHAN_6,
	CHAN_MAX,
};

// Sound attenuation
// These are actual floating point values and not specific types e.g. 3.7 is a valid attenuation
// Larger values = longer range
enum : float
{
	ATTN_NONE,		// No falloff
	ATTN_NORM,
	ATTN_IDLE,
	ATTN_STATIC,
	ATTN_MAX,
};

// Expansions (don't use these in vanilla)

// Hipnotic items
enumflags
{
	HIT_MJOLNIR				= 1 << 7,
	HIT_PROXIMITY_GUN		= 1 << 16,
	
	// These go in .items2 so their bits can be set correctly
	
	HIT_LASER_CANNON		= 1,
	
	HIT_WETSUIT				= 1 << 2,
	HIT_EMPATHY_SHIELDS,
};

// Rogue items
enumflags
{
	RIT_SHELLS	= 1 << 7,
	RIT_NAILS,
	RIT_ROCKETS,
	RIT_CELLS,
	
	RIT_AXE,
	RIT_LAVA_NAILGUN,
	RIT_LAVA_SUPER_NAILGUN,
	RIT_MULTI_GRENADE,
	RIT_MULTI_ROCKET,
	RIT_PLASMA_GUN,
	
	// These go in .items2 so their bits can be set correctly
	
	RIT_ARMOR1 = 1,
	RIT_ARMOR2,
	RIT_ARMOR3,
	
	RIT_LAVA_NAILS,
	RIT_PLASMA_AMMO,
	RIT_MULTI_ROCKETS,
	
	RIT_SHIELD,
	RIT_ANTIGRAV,
	RIT_SUPERHEALTH,
};
