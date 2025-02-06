// Connect
const string SERVER_PRE_CONNECT = STR_EMPTY;
const string SERVER_SUF_CONNECT = " entered the game";
//Disconnect
const string SERVER_PRE_DISCONNECT = STR_EMPTY;
const string SERVER_SUF_DISCONNECT = " left the game";
// Level exit
const string LVL_PRE_EXIT = STR_EMPTY;
const string LVL_SUF_EXIT = " exited the level";

// Pickups
const string AMMO_BACKPACK = "Picked up a backpack";
const string AMMO_SHELLS_PICKUP = "Picked up some shells";
const string AMMO_NAILS_PICKUP = "Picked up some nails";
const string AMMO_ROCKETS_PICKUP = "Picked up some rockets";
const string AMMO_CELLS_PICKUP = "Picked up some cells";

const string WEAP_AXE = "Picked up Gladius";
const string WEAP_SHOT = "Picked up a Shotgun";
const string WEAP_SSG = "Picked up a Double-barreled Shotgun";
const string WEAP_NAIL = "Picked up a Nailgun";
const string WEAP_SNG = "Picked up a Perforator";
const string WEAP_GL = "Picked up a Grenade Launcher";
const string WEAP_RL = "Picked up a Rocket Launcher";
const string WEAP_LIGHT = "Picked up a Thunderbolt";

const string ARM_LIGHT = "Picked up some light armor";
const string ARM_MED = "Picked up some armor";
const string ARM_HEAVY = "Picked up some heavy armor";
const string ARM_SHARD = "Picked up an armor shard";

const string HTH_ROTTED = "Picked up a rotted health pack";
const string HTH_NORM = "Picked up a health pack";
const string HTH_MEGA = "Picked up a Megahealth";
const string HTH_BONUS = "Picked up a health bonus";

const string POW_QUAD = "Picked up a Quad Damage";
const string POW_INVULN = "Picked up a Pentagram of Protection";
const string POW_INVIS = "Picked up a Ring of Shadows";
const string POW_SUIT = "Picked up a Biosuit";

// Generic obituaries
const string OBIT_PRE_GENERIC = STR_EMPTY;
const string OBIT_SUF_GENERIC = " died";
const string OBIT_PRE_SELF_GENERIC = STR_EMPTY;
const string OBIT_SUF_SELF_GENERIC = " was killed by their own hubris";
const string OBIT_PRE_CLIENT_GENERIC = STR_EMPTY;
const string OBIT_CLIENT_GENERIC = " was killed by ";
const string OBIT_SUF_CLIENT_GENERIC = STR_EMPTY;
const string OBIT_PRE_TELE = STR_EMPTY;
const string OBIT_TELE = " was telefragged by ";
const string OBIT_SUF_TELE = STR_EMPTY;
const string OBIT_PRE_REV_TELE = STR_EMPTY;
const string OBIT_SUF_REV_TELE = " had their own telefrag reflected back at them";

// Controls the order of names displayed in obituaries in deathmatch. Normally the
// client comes first with the killer second, but these can be used to reverse that.
// Individual weapons can also be flagged to reverse them if finer control is needed
// via WF_REVERSE_NAMES
const bool_t REVERSE_DEF_OBIT_CLIENTS = FALSE;	// Default obituaries only
const bool_t REVERSE_OBIT_CLIENTS = FALSE;		// Force all of them to reverse

// Default environment obituaries
const string OBIT_PRE_CRUSH = STR_EMPTY;
const string OBIT_SUF_CRUSH = " was crushed";
const string OBIT_PRE_WATER = STR_EMPTY;
const string OBIT_SUF_WATER = " is swimming with the fishes";
const string OBIT_PRE_SLIME = STR_EMPTY;
const string OBIT_SUF_SLIME = " took a dive into slime";
const string OBIT_PRE_LAVA = STR_EMPTY;
const string OBIT_SUF_LAVA = " tried to swim in lava";
const string OBIT_PRE_GRAVITY = STR_EMPTY;
const string OBIT_SUF_GRAVITY = " fell victim to gravity";
const string OBIT_PRE_EXIT = STR_EMPTY;
const string OBIT_SUF_EXIT = " tried to escape the chaos";

// Monster obituaries
const string OBIT_PRE_FISH = STR_EMPTY;
const string OBIT_SUF_FISH = " was turned into Rotfish chum";
const string OBIT_PRE_ROTT = STR_EMPTY;
const string OBIT_SUF_ROTT = " had their ankles chewed off by a Rottweiler";
const string OBIT_PRE_GRUNT = STR_EMPTY;
const string OBIT_SUF_GRUNT = " couldn't outrun a Grunt's pellets";
const string OBIT_PRE_ENFORC = STR_EMPTY;
const string OBIT_SUF_ENFORC = " was blasted by an Enforcer";
const string OBIT_PRE_ZOMBIE = STR_EMPTY;
const string OBIT_SUF_ZOMBIE = " became one with the Zombies";
const string OBIT_PRE_KNIGHT = STR_EMPTY;
const string OBIT_SUF_KNIGHT = " was cut asunder by a Knight";
const string OBIT_PRE_SCRAG = STR_EMPTY;
const string OBIT_SUF_SCRAG = " was grounded by a Scrag";
const string OBIT_PRE_SPAWN = STR_EMPTY;
const string OBIT_SUF_SPAWN = " couldn't keep up with a Spawn";
const string OBIT_PRE_SPAWN_EXP = STR_EMPTY;
const string OBIT_SUF_SPAWN_EXP = " tried to hug a Spawn";
const string OBIT_PRE_OGRE_MIS = STR_EMPTY;
const string OBIT_SUF_OGRE_MIS = " caught an Ogre's grenade";
const string OBIT_PRE_OGRE_MEL = STR_EMPTY;
const string OBIT_SUF_OGRE_MEL = " was chopped down by an Ogre";
const string OBIT_PRE_DTHK_MIS = STR_EMPTY;
const string OBIT_SUF_DTHK_MIS = " was smote by a Death Knight";
const string OBIT_PRE_DTHK_MEL = STR_EMPTY;
const string OBIT_SUF_DTHK_MEL = " got too chivalrous with a Death Knight";
const string OBIT_PRE_FIEND = STR_EMPTY;
const string OBIT_SUF_FIEND = " was eviscerated by a Fiend";
const string OBIT_PRE_VORE = STR_EMPTY;
const string OBIT_SUF_VORE = " couldn't hide from a Vore";
const string OBIT_PRE_SHAM_MIS = STR_EMPTY;
const string OBIT_SUF_SHAM_MIS = " was fried by a Shambler";
const string OBIT_PRE_SHAM_MEL = STR_EMPTY;
const string OBIT_SUF_SHAM_MEL = " was clobbered by a Shambler";
const string OBIT_PRE_CHTHON = STR_EMPTY;
const string OBIT_SUF_CHTHON = " was crushed by the forces of Chthon";

// Finale messages
const string FIN_EP1 = "As the corpse of the monstrous entity\nChthon sinks back into the lava whence\nit rose, you grip the Rune of Earth\nMagic tightly. Now that you have\nconquered the Dimension of the Doomed,\nrealm of Earth Magic, you are ready to\ncomplete your task. A Rune of magic\npower lies at the end of each haunted\nland of Quake. Go forth, seek the\ntotality of the four Runes!";
const string FIN_EP2 = "The Rune of Black Magic throbs evilly in\nyour hand and whispers dark thoughts\ninto your brain. You learn the inmost\nlore of the Hell-Mother; Shub-Niggurath!\nYou now know that she is behind all the\nterrible plotting which has led to so\nmuch death and horror. But she is not\ninviolate! Armed with this Rune, you\nrealize that once all four Runes are\ncombined, the gate to Shub-Niggurath's\nPit will open, and you can face the\nWitch-Goddess herself in her frightful\notherworld cathedral.";
const string FIN_EP3 = "The charred viscera of diabolic horrors\nbubble viscously as you seize the Rune\nof Hell Magic. Its heat scorches your\nhand, and its terrible secrets blight\nyour mind. Gathering the shreds of your\ncourage, you shake the devil's shackles\nfrom your soul, and become ever more\nhard and determined to destroy the\nhideous creatures whose mere existence\nthreatens the souls and psyches of all\nthe population of Earth.";
const string FIN_EP4 = "Despite the awful might of the Elder\nWorld, you have achieved the Rune of\nElder Magic, capstone of all types of\narcane wisdom. Beyond good and evil,\nbeyond life and death, the Rune\npulsates, heavy with import. Patient and\npotent, the Elder Being Shub-Niggurath\nweaves her dire plans to clear off all\nlife from the Earth, and bring her own\nfoul offspring to our world! For all the\ndwellers in these nightmare dimensions\nare her descendants! Once all Runes of\nmagic power are united, the energy\nbehind them will blast open the Gateway\nto Shub-Niggurath, and you can travel\nthere to foil the Hell-Mother's plots\nin person.";
const string FIN_RUNES = "Now, you have all four Runes. You sense\ntremendous invisible forces moving to\nunseal ancient barriers. Shub-Niggurath\nhad hoped to use the Runes Herself to\nclear off the Earth, but now instead,\nyou will use them to enter her home and\nconfront her as an avatar of avenging\nEarth-life. If you defeat her, you will\nbe remembered forever as the savior of\nthe planet. If she conquers, it will be\nas if you had never been born.";
const string FIN_END = "Congratulations and well done! You have\nbeaten the hideous Shub-Niggurath, and\nher hundreds of ugly changelings and\nmonsters. You have proven that your\nskill and your cunning are greater than\nall the powers of Quake. You are the\nmaster now. Id Software salutes you.";
