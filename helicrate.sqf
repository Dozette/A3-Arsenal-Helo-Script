// Define the player and the helicopter type
private _player = player;
private _heliType = "B_Heli_Light_01_F";

// Spawn the helicopter at a position above the player, ensuring it's above ground level
private _spawnHeight = 300; // Increased height above the player
private _groundHeight = getTerrainHeight getPos _player; // Get the ground height at the player's position
private _heliPos = getPos _player vectorAdd [0, 0, _spawnHeight + _groundHeight + 50]; // Calculate spawn position with additional height

// Create the helicopter and its crew
private _heli = createVehicle [_heliType, _heliPos, [], 0, "FLY"]; // Changed to "FLY" instead of "NONE"
createVehicleCrew _heli; // This creates the default crew for the helicopter

// Get the helicopter's group
private _heliGroup = group driver _heli;

// Set the helicopter to fly
driver _heli action ["EngineOn", _heli];
_heli engineOn true;

// Calculate landing position (20 meters away from player)
private _landingPos = getPos _player vectorAdd [20, 20, 0];

// Command the helicopter to move to landing position
_heliGroup move _landingPos;

// Wait until the helicopter is near the landing position
waitUntil { (_heli distance _landingPos) < 100 };

// Command the helicopter to land
_heli land "LAND";
_heliGroup move _landingPos;

// Wait until landed
waitUntil { isTouchingGround _heli || { (getPos _heli select 2) < 1 } };

// Get the final position of the helicopter
private _finalPos = getPos _heli;

// Create explosion effects for first transformation
_heli say3D "SmallExplosion";
createVehicle ["SmallSecondary", _finalPos, [], 0, "NONE"];

// Delete the helicopter and its crew
{deleteVehicle _x} forEach (crew _heli);
deleteVehicle _heli;
deleteGroup _heliGroup;

// Create the cargo net
private _crate = createVehicle ["B_CargoNet_01_ammo_F", _finalPos, [], 0, "NONE"];

// Make it a virtual arsenal
["AmmoboxInit", [_crate, true]] call BIS_fnc_arsenal;

// Add ACE Arsenal if ACE is present
if (isClass(configFile >> "CfgPatches" >> "ace_main")) then {
    [_crate, true] call ace_arsenal_fnc_initBox;
};

// Add a hint to let the player know the arsenal is ready
hint "Supply crate deployed with Virtual Arsenal! Available for 90 seconds.";

// Wait 90 seconds
sleep 90;

// Get the crate's position for the new helicopter
private _cratePos = getPos _crate;

// Create explosion effects for second transformation
_crate say3D "SmallExplosion";
createVehicle ["SmallSecondary", _cratePos, [], 0, "NONE"];

// Delete the crate
deleteVehicle _crate;

// Create the new transport helicopter
private _transportHeli = createVehicle ["B_Heli_Transport_01_F", _cratePos, [], 0, "NONE"];
createVehicleCrew _transportHeli;

// Get the helicopter's group
private _transportGroup = group driver _transportHeli;

// Start the engine
driver _transportHeli action ["EngineOn", _transportHeli];
_transportHeli engineOn true;

// Calculate takeoff position (50m up)
private _takeoffPos = _cratePos vectorAdd [0, 0, 50];

// Move helicopter up first
_transportGroup move _takeoffPos;

// Wait until helicopter reaches altitude
waitUntil { ((getPos _transportHeli) select 2) > 45 };

// Calculate exit position (1000m away from player in a random direction)
private _dir = random 360;
private _exitPos = (getPos _player) vectorAdd [sin _dir * 1000, cos _dir * 1000, 100];

// Command helicopter to move to exit position
_transportGroup move _exitPos;

// Wait until helicopter is far enough away
waitUntil { (_transportHeli distance _player) > 800 };

// Delete the helicopter and crew
{deleteVehicle _x} forEach (crew _transportHeli);
deleteVehicle _transportHeli;
deleteGroup _transportGroup; 