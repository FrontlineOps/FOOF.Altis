params ["_snapshot"];

if (!hasInterface) exitWith {};

private _phase = _snapshot get "phase";
private _campaignDay = _snapshot get "campaignDay";
private _operationId = _snapshot get "operationId";
private _key = format ["%1:%2:%3", _campaignDay, _operationId, _phase];

if (FLO_MatchLastAnnouncedPhaseKey isEqualTo _key) exitWith {};

FLO_MatchLastAnnouncedPhaseKey = _key;

private _seconds = _snapshot get "secondsRemaining";
private _minutes = ceil (_seconds / 60);
private _phaseLabel = _snapshot get "phaseLabel";
private _message = switch (_phase) do {
    case "setup": {
        format ["Phase 0 setup is active. Organize command, squads, kits, and first bases. %1 minutes remaining.", _minutes]
    };
    case "frontline": {
        private _objectiveName = _snapshot get "plannedObjectiveName";

        if (_objectiveName isEqualTo "") then {
            format ["Phase 1 frontline selection is active. Establish the first contact line. %1 minutes remaining.", _minutes]
        } else {
            format ["Phase 1 frontline selection is active near %1. %2 minutes remaining.", _objectiveName, _minutes]
        };
    };
    case "operation": {
        private _objectiveName = _snapshot get "operationObjectiveName";
        private _attackSide = _snapshot get "operationAttackSide";

        if (_attackSide isEqualTo "BOTH") then {
            format ["Phase 2 operation is active. Both sides are ordered to seize %1. %2 minutes remaining.", _objectiveName, _minutes]
        } else {
            format ["Phase 2 operation is active. %1 is ordered to attack %2. %3 minutes remaining.", _attackSide, _objectiveName, _minutes]
        };
    };
    default {
        format ["Match phase updated. %1 minutes remaining.", _minutes]
    };
};

[_phaseLabel, _message, "info", 8] call FLO_fnc_announce;
