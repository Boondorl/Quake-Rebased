// The number assigned to each function refers to the index of the function to use in the internal built-in table
// Precache* functions only work when the server is loading the map
// Models and sounds must be precached before they can be used
// Print functions can only accept a combined string size of 256 characters

void(angles_t angs) SetLocalAxes	= #1; // 'pitch yaw roll' Sets v_* system globals

// Order of operations for initializing an entity:
// 1. Set movetype and solid entity fields
// 2. Call SetModel (automatically sets the size for brush entities)
// 3. Call SetSize (skip this for brush entities)
// 4. Call SetOrigin
// When changing an entity's solid field, SetOrigin should be called to properly
// relink it into the world
void(entity e, vector orig) SetOrigin			= #2;
void(entity e, string mod) SetModel				= #3;
void(entity e, vector min, vector max) SetSize	= #4;
void() break									= #6;
float() Random									= #7; // Returns [0, 1]
void(entity e, uint8_t chan, string snd, float vol, float atten) PlaySound	= #8; // Playing an empty sound can be used to stop a sound on a given channel
vector(vector v) Normalize						= #9;
void(string msg) ThrowAbortException			= #10;
void(string msg) A_ThrowEntityException			= #11; // Only removes the self entity, doesn't VM abort
float(vector v) Length							= #12;
int_t(vector v) Atan2I							= #13; // v.z is ignored. Returns [0, 360)
entity() SpawnEntity							= #14; // SpawnEntityType can be used to automatically create a specific type
void(entity e) RemoveEntity						= #15; // Avoid using this in favor of DestroyEntity

// Sets trace_* system globals
// clipType is a MOVE_* constant
void(vector start, vector end, int_t clipType, entity ignore) TraceLine = #16;
entity() A_FindNewClientEnemy = #17;
entity(entity start, .string field, string fieldVal) FindEntity = #18;
string(string snd) PrecacheSound = #19; // Return value is unused
string(string mod) PrecacheModel = #20; // Return value is unused
void(entity client, string cmd) RunClientCommand = #21; // Execute a console command on the client's end
entity(vector pos, float rad) GetEntitiesInRadius = #22; // Uses the chain entity field to create a linked list, returning the head of the list
void(string msg1, optional string msg2, optional string msg3, optional string msg4, optional string msg5, optional string msg6, optional string msg7, optional string msg8) BroadcastPrint = #23; // Print to everyone in the server
// Print only to a specific client
void(entity client, string msg1, optional string msg2, optional string msg3, optional string msg4, optional string msg5, optional string msg6, optional string msg7, optional string msg8) Print = #24;
void(string msg1, optional string msg2, optional string msg3, optional string msg4, optional string msg5, optional string msg6, optional string msg7, optional string msg8) DebugPrint = #25; // Message only viewable if debugging mode enabled
string(float f) ToStringF = #26;
string(vector v) ToStringV = #27;
void() PrintAllEntities = #28;
void() StartStatementPrinting = #29; // Print info about each QuakeC statement to the console as they happen
void() EndStatementPrinting = #30;
void(entity e) PrintEntity = #31;
bool_t(float yaw, float dist) A_TryMove = #32;
bool_t() A_TryDropToFloor = #34; // Try to drop an entity to the floor up to 256 units down

// styleIndex ranges from [0,63] with [32,63] being preserved for toggleable lights
// lightSequence ranges from "a" to "z" or can be a sequence e.g. "abcdcba"
// If using a sequence of light levels, animates through them at 10Hz
void(uint8_t styleIndex, string lightSequence) SetLightStyle = #35; 
float(float f) Round = #36;
float(float f) Floor = #37;
float(float f) Ceiling = #38;
bool_t(entity e) IsOnGround = #40; // Entities can be up to 18 units off the ground and still be considered on it
int_t(vector pos) GetContentsAtPoint = #41; // Returns the CONTENTS_* type at the position
float(float f) AbsF = #43;
vector(entity client, float missileSpeed) GetAutoaimDir = #44; // Uses v_forward as the direction. missileSpeed is unused
float(string cvar) GetCVarF = #45;
void(string cmd) RunServerCommand = #46;

// Iterates through entities defined in the internal edict list
// world is always entity 0 and 1 - maxclients are all reserved for clients
entity(entity e) NextEntity = #47;
void(vector pos, vector vel, uint8_t colorIndex, uint8_t amt) SpawnParticles = #48;
void() A_FaceIdealYaw = #49; // Uses the yaw_speed entity field to turn towards the ideal_yaw entity field

// Returns 'pitch yaw 0'. Pitch and yaw are [0, 360)
// When combining with SetLocalAxes, pitch should be negated before being passed (due to an oversight in the calculated pitch)
vector(vector v) ToAnglesI = #51;

// Network messaging (see SVC_* constants for usage)
void(int_t type, uint8_t i) WriteUInt8 = #52;
void(int_t type, int8_t i) WriteInt8 = #53;
void(int_t type, int16_t i) WriteInt16 = #54;
void(int_t type, int_t i) WriteInt32 = #55;
void(int_t type, float f) WriteCoord = #56;
void(int_t type, float f) WriteAngle = #57;
void(int_t type, string s) WriteString = #58;
void(int_t type, entity e) WriteEntity = #59;

void(float dist) A_MoveToGoal = #67; // Move towards the goalentity field while using the enemy field to adjust height if floating/swimming
string(string file) PrecacheFile = #68; // Unused
void(entity e) MakeEntityStatic = #69; // Bake the entity into the world and remove it
void(string lvl) ChangeLevel = #70;
void(string cvar, string val) SetCVar = #72;
void(entity client, string msg1, optional string msg2, optional string msg3, optional string msg4, optional string msg5, optional string msg6, optional string msg7, optional string msg8) CenterPrint = #73; // Print text in the middle of the screen
void(vector pos, string snd, float vol, float atten) PlayAmbientSound = #74; // Must be a valid looping audio file and cannot be stopped once started

// Unused
string(string mod) PrecacheRegisteredModel = #75;
string(string snd) PrecacheRegisteredSound = #76;
string(string file) PrecacheRegisteredFile = #77;

void(entity client) SetSpawnParms = #78; // Encodes the parm* system globals into the passed client

// Quakespasm built-ins
// These only work with Quakespasm derived ports so don't use them if you want vanilla support

void(entity client, string snd) PlayLocalSound = #80; // Only play the sound for a specific client
