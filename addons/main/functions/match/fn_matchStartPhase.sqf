params ["_phase", ["_duration", -1], ["_notify", true]];

if (!isServer) exitWith {};

private _phaseNumber = switch (_phase) do {
    case "setup": { 0 };
    case "frontline": { 1 };
    case "operation": { 2 };
    default { throw format ["[FLO][Match] Unsupported match phase: %1", _phase] };
};

if (_duration < 0) then {
    _duration = switch (_phase) do {
        case "setup": { FLO_MatchSetupDuration };
        case "frontline": { FLO_MatchFrontlineDuration };
        case "operation": { FLO_MatchOperationDuration };
    };
};

private _now = diag_tickTime;

FLO_MatchState set ["phase", _phase];
FLO_MatchState set ["phaseNumber", _phaseNumber];
FLO_MatchState set ["phaseStartedAt", _now];
FLO_MatchState set ["phaseEndsAt", _now + _duration];
FLO_MatchState set ["revision", (FLO_MatchState get "revision") + 1];

if (_phase isEqualTo "frontline") then {
    [] call FLO_fnc_matchUpdateFrontlineSelection;
};

if (_notify) then {
    [_phase] call FLO_fnc_matchNotifyPhase;
};

[0] call FLO_fnc_matchSendSnapshot;
