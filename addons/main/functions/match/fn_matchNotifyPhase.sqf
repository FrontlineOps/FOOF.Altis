params ["_phase"];

if (!isServer) exitWith {};

private _message = switch (_phase) do {
    case "setup": {
        "Campaign setup started. Organize command, squads, kits, and first bases."
    };
    case "frontline": {
        private _objectiveName = FLO_MatchState get "plannedObjectiveName";
        if (_objectiveName isEqualTo "") then {
            "Frontline selection started. Expand from staging and establish the first contact line."
        } else {
            format ["Frontline selection started. Current operation line is forming around %1.", _objectiveName]
        };
    };
    case "operation": {
        private _objectiveName = FLO_MatchState get "operationObjectiveName";
        private _attackSide = FLO_MatchState get "operationAttackSide";

        if (_attackSide isEqualTo "BOTH") then {
            format ["Campaign Day %1 operation started. Both sides are ordered to seize %2.", FLO_MatchState get "campaignDay", _objectiveName]
        } else {
            format ["Campaign Day %1 operation started. %2 is ordered to attack %3.", FLO_MatchState get "campaignDay", _attackSide, _objectiveName]
        };
    };
    default { "Match flow updated." };
};

[
    createHashMapFromArray [
        ["mode", "announce"],
        ["type", "info"],
        ["title", [_phase] call FLO_fnc_matchPhaseLabel],
        ["message", _message],
        ["duration", 8]
    ]
] call FLO_fnc_notificationBroadcast;
