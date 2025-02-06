// This file should always be loaded before any other fields and functions are read. Quake
// uses simple memory offsets to link these so not loading this data first will cause the
// VM to get corrupted. These fields should always be defined in the exact order shown here
// for that reason. It's best not to touch this file at all and only use it for reference.

entity self;		// Current caller during this physics frame
entity other;		// Entity that self is currently colliding with during physics calculations
entity world;		// Server entity (also acts as a null entity)
float time;			// Current game time in seconds
float frametime;	// Time in seconds between current frame and previous (generally caps at 72Hz, or ~0.0139s)

// Force all entities to touch triggers next physics frame. This is needed because
// non-moving things don't normally scan for triggers, and when a trigger is
// created (like a teleport death trigger), it needs to catch everything. Decremented
// at the end of each physics frame, so set to 2 instead of 1
int_t force_retouch;

string mapname;	// Current map

// Game mode information
int_t deathmatch;
int_t coop;
int_t teamplay;

// Keeps track of current runes. Persistent across entire game (see RUNE_* constants)
flags_t serverflags; 

// Stats for current map
int_t total_secrets;
int_t total_monsters;
int_t found_secrets;
int_t killed_monsters;

// Spawn parameters are used to encode information about clients when switching
// between maps. These are encoded as integers so fractional numbers should be multiplied
// by the degree of accuracy desired and then divided back when decoding
// Only 1-10 are used by default
// parm1: item bits
// parm2: health (capped between 50 and 100)
// parm3: armor amount
// parm4: shells (minimum of 25)
// parm5: nails
// parm6: rockets
// parm7: cells
// parm8: owned weapons (shotgun and axe are given by default)
// parm9: armor damage fraction * 100
// parm10: currently selected weapon
int_t parm1, parm2, parm3, parm4, parm5, parm6, parm7, parm8, parm9, parm10, parm11, parm12, parm13, parm14, parm15, parm16;

// SetLocalAxes system globals
vector v_forward, v_up, v_right;

// TraceLine system globals
bool_t trace_allsolid;		// Trace was entirely within solid BSP leaves
bool_t trace_startsolid;	// Trace started within a solid BSP leaf
float trace_fraction;		// Fraction of the total distance between start and end the trace traveled
vector trace_endpos;		// Map position where the trace stopped
vector trace_plane_normal;	// Normal of the plane the trace hit
float trace_plane_dist;		// Distance from world origin of the plane the trace hit
entity trace_ent;			// Entity the trace hit, if any
bool_t trace_inopen;		// Trace traversed through air
bool_t trace_inwater;		// Trace traversed through water

entity msg_entity;	// Entity to send a message to when using MSG_ONE networking

// Required system global functions
// These need to be defined within QuakeC itself
void() main;				// Unused
void() StartFrame;			// Called by the server at the start of every physics frame
void() PlayerPreThink;		// Called before client physics are ran
void() PlayerPostThink;		// Called after client physics are ran
void() ClientKill;			// Forcefully kill and respawn the client
void() ClientConnect;		// Called when a client joins the game, either from switching maps or connecting
void() PutClientInServer;	// Called when the client is spawned or respawned
void() ClientDisconnect;	// Called when a client leaves the game, either from switching maps or disconnecting
void() SetNewParms;			// Resets the parm* system globals to the default ones when spawning for the first time (or when respawning in deathmatch)
void() SetChangeParms;		// Called on each client to encode their parm* fields before switching maps

void end_sys_globals;

// *[built-in] = should be set with the given built-in function

// *[SetModel] Current index of the entity's model from the cache
// Entites with a modelindex of 0 aren't rendered nor networked
.uint8_t modelindex;

// *[SetSize/SetOrigin] origin + mins, origin + maxs
// SetModel also sets this, but only for brush entities
.vector absmin, absmax;

// Local time for the entity. This is only used with MOVETYPE_PUSH entities and should be used in place of the time system global for them
// since it won't advance if the entity is being blocked
.float ltime;

.int_t movetype;
.int_t solid;	// Make sure to relink to the world via SetOrigin when changing this

.vector origin;			// *[SetOrigin]
.vector oldorigin;		// *[internal only] Only used with MOVETYPE_WALK to check if the entity is stuck
.vector velocity;		// Measured in map units/second
.angles_t angles;		// 'pitch yaw roll' (only use with non-brush entities). Use v_angle to get the direction a client is looking
.angles_t avelocity;	// Angular velocity (only use with non-brush entities)

.angles_t punchangle;	// 'pitch yaw roll' Client's camera angle offsets from recoil (negative pitch values point upward)

.string classname;	// Determines the spawn function to initialize an entity with on map load

// *[SetModel] Name of the entity's current model.
// For brush entities, this automatically contains the appropriate BSP model name to use
// Entities with an empty model aren't rendered nor networked
.string model;

.uint8_t frame;		// Frame index to use for the entity's current model
.uint8_t skin;		// Skin index to use for the entity's current model
.flags_t effects;	// See EF_* constants

// For brush entities, SetModel will set these
.vector mins, maxs;	// *[SetSize] Bounding box extents relative to entity's origin
.vector size;		// *[SetSize] maxs - mins

// Called on both the collider and collidee during a collision. The collider's touch function
// is called first. When colliding with an entity with SOLID_TRIGGER only the trigger's touch function is called
.void() touch;

.void() use;
.void() think;		// Function to call when nextthink is reached
.void() blocked;	// Called by MOVETYPE_PUSH entities when they can't push an entity out of the way

// Time stamp for when to call the think function (in seconds)
// If <= 0, this entity's think is ignored
// If a positive value <= time system global (or ltime for MOVETYPE_PUSH entities), call think as soon as possible
.float nextthink;
.entity groundentity;	// Entity (usually a BSP entity) that is currently being stood on top of

.int_t health;
.int_t frags;			// Client's current score in deathmatch
.flags_t weapon;		// Client's currently selected weapon (uses the weapon IT_* constants)
.string weaponmodel;	// Name of the model for the currently selected weapon
.uint8_t weaponframe;	// Frame index of the currently selected weapon's model
.int_t currentammo;		// Current ammo amount to display in the HUD
.int_t ammo_shells, ammo_nails, ammo_rockets, ammo_cells;	// Also used to display ammo info in the HUD

.flags_t items;	// See IT_* constants

.int_t takedamage;	// See DAMAGE_* constants
.entity chain;		// *[GetEntitiesInRadius] The next entity in the radius linked list
.int_t deadflag;	// See DEAD_* constants (used to check respawning)

.vector view_ofs;	// Add to origin to get the entity's eye point

.bool_t button0;	// Fire
.bool_t button1;	// Unused
.bool_t button2;	// Jump

// Command the client wants to run (e.g. weapon switching)
// Only one impulse can exist at a time
.uint8_t impulse;

.bool_t fixangle;	// If true, tells the server to update the client's angles immediately (often used when teleporting)
.angles_t v_angle;	// 'pitch yaw roll' Current view angles for the client (negative pitch values point upward) 
.float idealpitch;	// Calculated pitch angle when a client is walking on a slope (disabled when using the mouse)

.string netname;	// Network name for the entity

.entity enemy;		// Entity the monster is currently trying to attack

.flags_t flags;		// See FL_* constants

.uint8_t colormap;	// Current color map index for the client's model skin
.int_t team;		// Current team the client is on

.int_t max_health;	// Don't heal over this amount of health

.float teleport_time;	// Temporarily ignore the client's movement input until this time stamp

.float armortype;	// Fraction of damage to reduce for incoming damage. Supports two decimal places of accuracy by default
.int_t armorvalue;	// How much armor the entity currently has

.int_t waterlevel;	// Depth of liquid (see DEPTH_* constants)
.int_t watertype;	// The CONTENTS_* type of the liquid the entity is standing in

.float ideal_yaw;	// The yaw a monster wants to be facing
.float yaw_speed;	// The monster's max yaw angle they can turn per A_FaceIdealYaw call

.entity aiment;	// Unused

.entity goalentity;	// The entity the monster is trying to move towards (only tracks horizontal movement)

.flags_t spawnflags;	// Flags set within the map editor for the entity

.string target;		// The id of the entity to use when triggered
.string targetname;	// The entity's id

// Determines the type and strength of the damage flash to use on the client's screen
// Damage is accumulated through a frame and sent as one single message to prevent
// flooding the network. Usually set within DamageEntity
.int_t dmg_take;		// Total amount of damage dealt after applying armor
.int_t dmg_save;		// Total amount of damage prevented from armor
.entity dmg_inflictor;	// The last entity to inflict damage

.entity owner;		// Owner of the missile entity (ignore this entity when collision checking)
.vector movedir;	// Normalized direction for doors to move (also used when a client jumps out of water)

.string message;	// Message to display when triggered

.int_t sounds;	// Sound type argument (often set in the editor)
.string noise;	// Message sound when activating
.string noise1, noise2, noise3;	// Misc sounds, mostly for brush entities

void end_sys_fields;
