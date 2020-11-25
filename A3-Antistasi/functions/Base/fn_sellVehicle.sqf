private ["_veh", "_costs","_typeX"];
_veh = cursortarget;

if (isNull _veh) exitWith {[localize "STR_antistasi_customHint_sell_veh", localize "STR_antistasi_customHint_sell_veh_no_look"] call A3A_fnc_customHint;};

if (_veh distance getMarkerPos respawnTeamPlayer > 50) exitWith {[localize "STR_antistasi_customHint_sell_veh", localize "STR_antistasi_customHint_sell_veh_no_flag"] call A3A_fnc_customHint;};

if ({isPlayer _x} count crew _veh > 0) exitWith {[localize "STR_antistasi_customHint_sell_veh", localize "STR_antistasi_customHint_sell_veh_no_empty"] call A3A_fnc_customHint;};

_owner = _veh getVariable "ownerX";
_exit = false;
if (!isNil "_owner") then
	{
	if (_owner isEqualType "") then
		{
		if (getPlayerUID player != _owner) then {_exit = true};
		};
	};

if (_exit) exitWith {[localize "STR_antistasi_customHint_sell_veh", localize "STR_antistasi_customHint_sell_veh_owner"] call A3A_fnc_customHint;};

_typeX = typeOf _veh;
_costs = call {
	if (_veh isKindOf "StaticWeapon") exitWith {100};			// in case rebel static is same as enemy statics
	if (_typeX in vehFIA) exitWith { ([_typeX] call A3A_fnc_vehiclePrice) / 2 };
	if ((_typeX in arrayCivVeh) or (_typeX in civBoats) or (_typeX in [civBoat,civCar,civTruck])) exitWith {25};
	if ((_typeX in vehNormal) or (_typeX in vehBoats) or (_typeX in vehAmmoTrucks)) exitWith {100};
	if (_typeX in [vehCSATPatrolHeli, vehNATOPatrolHeli, civHeli]) exitWith {500};
	if ((_typeX in vehAPCs) || (_typeX in vehTransportAir) || (_typeX in vehUAVs)) exitWith {1000};
	if ((_typeX in vehAttackHelis) or (_typeX in vehTanks) or (_typeX in vehAA) or (_typeX in vehMRLS)) exitWith {3000};
	if (_typeX in [vehNATOPlane,vehNATOPlaneAA,vehCSATPlane,vehCSATPlaneAA]) exitWith {4000};
	0;
};

if (_costs == 0) exitWith {[localize "STR_antistasi_customHint_sell_veh", localize "STR_antistasi_customHint_sell_veh_suitable"] call A3A_fnc_customHint;};

_costs = round (_costs * (1-damage _veh));

[0,_costs] remoteExec ["A3A_fnc_resourcesFIA",2];

if (_veh in staticsToSave) then {staticsToSave = staticsToSave - [_veh]; publicVariable "staticsToSave"};
if (_veh in reportedVehs) then {reportedVehs = reportedVehs - [_veh]; publicVariable "reportedVehs"};

[_veh,true] call A3A_fnc_empty;

if (_veh isKindOf "StaticWeapon") then {deleteVehicle _veh};

[localize "STR_antistasi_customHint_sell_veh", localize "STR_antistasi_customHint_sell_veh_sold"] call A3A_fnc_customHint;
