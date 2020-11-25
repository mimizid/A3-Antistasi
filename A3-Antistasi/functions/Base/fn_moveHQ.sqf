if (player != theBoss) exitWith {[localize "STR_antistasi_customHint_move_hq", localize "STR_antistasi_customHint_only_comander"] call A3A_fnc_customHint;};

if ((count weaponCargo boxX >0) or (count magazineCargo boxX >0) or (count itemCargo boxX >0) or (count backpackCargo boxX >0)) exitWith {[localize "STR_antistasi_customHint_move_hq", localize "STR_antistasi_customHint_moveHQ_ammobox"] call A3A_fnc_customHint;};

if !(isNull attachedTo petros) exitWith {[localize "STR_antistasi_customHint_move_hq", localize "STR_antistasi_customHint_moveHQ_petros"] call A3A_fnc_customHint;};


[petros,"remove"] remoteExec ["A3A_fnc_flagaction",0];
//removeAllActions petros;
private _groupPetros = group petros;
[petros] join theBoss;
deleteGroup _groupPetros;

petros setBehaviour "AWARE";
petros enableAI "MOVE";
petros enableAI "AUTOTARGET";

/*
if (isMultiplayer) then
	{
	// these would need to be remoteExec'd on the server
	boxX hideObjectGlobal true;
	vehicleBox hideObjectGlobal true;
	mapX hideObjectGlobal true;
	fireX hideObjectGlobal true;
	flagX hideObjectGlobal true;
	}
else
	{
	boxX hideObject true;
	vehicleBox hideObject true;
	mapX hideObject true;
	fireX hideObject true;
	flagX hideObject true;
	};
*/

fireX inflame false;

[respawnTeamPlayer, 0, teamPlayer] call A3A_fnc_setMarkerAlphaForSide;
[respawnTeamPlayer, 0, civilian] call A3A_fnc_setMarkerAlphaForSide;

_garrison = garrison getVariable ["Synd_HQ", []];
_positionX = getMarkerPos "Synd_HQ";
if (count _garrison > 0) then
	{
	_costs = 0;
	_hr = 0;
	if ({(alive _x) and (!captive _x) and ((side _x == Occupants) or (side _x == Invaders)) and (_x distance _positionX < 500)} count allUnits > 0) then
		{
		[localize "STR_antistasi_customHint_garrisons", localize "STR_antistasi_customHint_moveHQ_garrison"] call A3A_fnc_customHint;
		}
	else
		{
		_size = ["Synd_HQ"] call A3A_fnc_sizeMarker;
		{
		if ((side group _x == teamPlayer) and (not(_x getVariable ["spawner",false])) and (_x distance _positionX < _size) and (_x != petros)) then
			{
			if (!alive _x) then
				{
				if (typeOf _x in soldiersSDK) then
					{
					if (typeOf _x == staticCrewTeamPlayer) then {_costs = _costs - ([SDKMortar] call A3A_fnc_vehiclePrice)};
					_hr = _hr - 1;
					_costs = _costs - (server getVariable (typeOf _x));
					};
				};
			if (typeOf (vehicle _x) == SDKMortar) then {deleteVehicle vehicle _x};
			deleteVehicle _x;
			};
		} forEach allUnits;
		};
	{
	if (_x == staticCrewTeamPlayer) then {_costs = _costs + ([SDKMortar] call A3A_fnc_vehiclePrice)};
	_hr = _hr + 1;
	_costs = _costs + (server getVariable _x);
	} forEach _garrison;
	[_hr,_costs] remoteExec ["A3A_fnc_resourcesFIA",2];
	garrison setVariable ["Synd_HQ",[],true];
	[localize "STR_antistasi_customHint_garrisons", format [localize "STR_antistasi_customHint_moveHQ_garrison_remove",_costs,_hr]] call A3A_fnc_customHint;
	};

sleep 5;

petros addAction [localize "STR_antistasi_addAction_buildHQ", A3A_fnc_buildHQ,nil,0,false,true];