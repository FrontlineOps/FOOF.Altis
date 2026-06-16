params ["_uid", "_sideKey", "_cellId", ["_resetApplied", false, [false]]];

if (!isServer) exitWith {};
if (_uid isEqualTo "") exitWith {};

private _player = objNull;

{
    if ((getPlayerUID _x) isEqualTo _uid) exitWith {
        _player = _x;
    };
} forEach allPlayers;

if (isNull _player) exitWith {};

private _owner = owner _player;
private _requestOwner = remoteExecutedOwner;

if ((_requestOwner > 2) && {_owner isNotEqualTo _requestOwner}) exitWith {
    diag_log format [
        "[FLO][Spawn] Rejected spoofed assignment confirmation uid=%1 requestOwner=%2 actualOwner=%3",
        _uid,
        _requestOwner,
        _owner
    ];
};

private _playerSide = side group _player;
private _playerSideKey = [_playerSide] call FLO_fnc_objectiveSideKey;

if (_playerSideKey isNotEqualTo _sideKey) exitWith {
    diag_log format [
        "[FLO][Spawn] Ignored assignment confirmation uid=%1 side=%2 currentSide=%3",
        _uid,
        _sideKey,
        _playerSideKey
    ];
};

if ((_player getVariable ["FLO_Spawn_AssignedCellId", ""]) isNotEqualTo _cellId) exitWith {
    diag_log format [
        "[FLO][Spawn] Ignored assignment confirmation uid=%1 cell=%2 currentCell=%3",
        _uid,
        _cellId,
        _player getVariable ["FLO_Spawn_AssignedCellId", ""]
    ];
};

if (_resetApplied) then {
    _player setVariable ["FLO_Spawn_ResetBeforeAssignment", false];
};
