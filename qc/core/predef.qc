
// Note that no actual code should go in here, only macros and typedefs needed
// for the rest of the files

// Macros should only be used for simple inlines that can't be done normally by FTEQCC since
// it can't take conditionals into account
#define SET_CLASSNAME(e, cls)		e.classname = #cls
#define GET_TIME(e)					(e.movetype == MOVETYPE_PUSH ? e.ltime : time)


// These are useful for making boundaries more clear on what kind of real type is expected for a given value

typedef float bool_t;
typedef float int8_t;
typedef float uint8_t;
typedef float int16_t;
typedef float uint16_t;
typedef float int_t;
typedef float uint_t;

typedef float flags_t;
typedef vector angles_t;
