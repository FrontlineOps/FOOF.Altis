params ["_snapshot"];

if (!hasInterface) exitWith {};

if (!isServer && {remoteExecutedOwner isNotEqualTo 2}) exitWith {
    diag_log format ["[FLO][Match] Rejected match snapshot from owner %1", remoteExecutedOwner];
};

FLO_MatchSnapshot = _snapshot;

[_snapshot] call FLO_fnc_matchUpdateSectorMarker;
[_snapshot] call FLO_fnc_matchAnnounceSnapshotPhase;
[] call FLO_fnc_matchUpdateDialog;
