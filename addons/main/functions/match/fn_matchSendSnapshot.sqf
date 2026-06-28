params [["_owner", 0]];

if (!isServer) exitWith {};

FLO_MatchSnapshot = [] call FLO_fnc_matchBuildSnapshot;
FLO_MatchLastSnapshotAt = diag_tickTime;

if (_owner isEqualTo 0) exitWith {
    [FLO_MatchSnapshot] remoteExecCall ["FLO_fnc_matchReceiveSnapshot", 0];
};

[FLO_MatchSnapshot] remoteExecCall ["FLO_fnc_matchReceiveSnapshot", _owner];
