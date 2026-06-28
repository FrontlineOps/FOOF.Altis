params ["_unit"];

if (!isServer) exitWith {};
if (isNull _unit) exitWith {};
if (isNil "FLO_MatchState") exitWith {};

private _owner = owner _unit;

if ((remoteExecutedOwner > 2) && {_owner isNotEqualTo remoteExecutedOwner}) exitWith {
    diag_log format [
        "[FLO][Match] Rejected match snapshot request from owner %1 for owner %2",
        remoteExecutedOwner,
        _owner
    ];
};

[_owner] call FLO_fnc_matchSendSnapshot;
