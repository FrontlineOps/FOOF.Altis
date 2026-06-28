params ["_phase", "_duration"];

if (!isServer) exitWith {};
if (isNil "FLO_MatchState") exitWith {};
if ((FLO_MatchState get "phase") isNotEqualTo _phase) exitWith {};

private _now = diag_tickTime;
private _phaseEndsAt = (FLO_MatchState get "phaseStartedAt") + _duration;

if (_phaseEndsAt <= _now) then {
    _phaseEndsAt = _now + 1;
};

FLO_MatchState set ["phaseEndsAt", _phaseEndsAt];
FLO_MatchState set ["revision", (FLO_MatchState get "revision") + 1];

[0] call FLO_fnc_matchSendSnapshot;
