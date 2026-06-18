params ["_side"];

if (!isServer) exitWith {};
if !(_side in [west, east]) exitWith {};

private _sideKey = [_side] call FLO_fnc_resourceSideKey;
private _uniformClass = [_sideKey] call FLO_fnc_spawnSideStoreUniform;

if (_uniformClass isEqualTo "") exitWith {};

private _equipped = 0;

{
    if ((side group _x) isNotEqualTo _side) then { continue };
    if (_x getVariable ["FLO_Persistence_Loaded", false]) then { continue };

    [_x, _uniformClass] remoteExecCall ["FLO_fnc_spawnEnsureFreshUniform", owner _x];
    _equipped = _equipped + 1;
} forEach allPlayers;

diag_log format [
    "[FLO][Spawn] Equipped %1 fresh %2 players with faction uniform %3",
    _equipped,
    _sideKey,
    _uniformClass
];
