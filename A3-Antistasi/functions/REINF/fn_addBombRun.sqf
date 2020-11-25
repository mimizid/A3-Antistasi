_veh = cursortarget;

if (isNull _veh) exitWith {[localize "STR_antistasi_customHint_airstrike", localize "STR_antistasi_customHint_airstrike_noLook"] call A3A_fnc_customHint;};

if (_veh distance getMarkerPos respawnTeamPlayer > 50) exitWith {[localize "STR_antistasi_customHint_airstrike", localize "STR_antistasi_customHint_airstrike_noFlag"] call A3A_fnc_customHint;};

if ({isPlayer _x} count crew _veh > 0) exitWith {[localize "STR_antistasi_customHint_airstrike", localize "STR_antistasi_customHint_airstrike_empty"] call A3A_fnc_customHint;};

_owner = _veh getVariable "ownerX";
_exit = false;
if (!isNil "_owner") then
	{
	if (_owner isEqualType "") then
		{
		if (getPlayerUID player != _owner) then {_exit = true};
		};
	};

if (_exit) exitWith {[localize "STR_antistasi_customHint_airstrike", localize "STR_antistasi_customHint_airstrike_owner"] call A3A_fnc_customHint;};

if (not(_veh isKindOf "Air")) exitWith {[localize "STR_antistasi_customHint_airstrike", localize "STR_antistasi_customHint_airstrike_onlyAir"] call A3A_fnc_customHint;};

_typeX = typeOf _veh;

if (isClass (configfile >> "CfgVehicles" >> _typeX >> "assembleInfo")) then {
	if (count getArray (configfile >> "CfgVehicles" >> _typeX >> "assembleInfo" >> "dissasembleTo") > 0) then {
		_exit = true;
	};
};
if (_exit) exitWith {[localize "STR_antistasi_customHint_airstrike", localize "STR_antistasi_customHint_airstrike_drone"] call A3A_fnc_customHint;};


//if (_typeX == vehSDKHeli) exitWith {hint "Syndikat Helicopters cannot be used to increase Airstrike points"};

_pointsX = 2;

if (_typeX in vehAttackHelis) then {_pointsX = 5};
if ((_typeX == vehCSATPlane) or (_typeX == vehNATOPlane)) then {_pointsX = 10};
deleteVehicle _veh;
[localize "STR_antistasi_customHint_airstrike", format [localize "STR_antistasi_customHint_airstrike_add",_pointsX]] call A3A_fnc_customHint;
bombRuns = bombRuns + _pointsX;
publicVariable "bombRuns";
[] remoteExec ["A3A_fnc_statistics",theBoss];