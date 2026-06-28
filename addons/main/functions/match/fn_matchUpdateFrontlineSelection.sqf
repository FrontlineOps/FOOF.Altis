if (!isServer) exitWith { false };

private _selection = [] call FLO_fnc_matchSelectOperationObjective;

if ((count _selection) isEqualTo 0) exitWith { false };

private _oldObjectiveId = FLO_MatchState get "plannedObjectiveId";
private _newObjectiveId = _selection get "objectiveId";

FLO_MatchState set ["plannedObjectiveId", _newObjectiveId];
FLO_MatchState set ["plannedObjectiveName", _selection get "objectiveName"];
FLO_MatchState set ["plannedObjectivePosition", _selection get "objectivePosition"];
FLO_MatchState set ["plannedObjectiveRadius", _selection get "objectiveRadius"];
FLO_MatchState set ["plannedSectorPosition", _selection get "sectorPosition"];
FLO_MatchState set ["plannedSectorRadius", _selection get "sectorRadius"];
FLO_MatchState set ["plannedSectorObjectiveIds", _selection get "sectorObjectiveIds"];
FLO_MatchState set ["plannedSecondaryObjectiveIds", _selection get "secondaryObjectiveIds"];
FLO_MatchState set ["plannedAttackSide", _selection get "attackSide"];
FLO_MatchState set ["plannedDefendSide", _selection get "defendSide"];

if (_oldObjectiveId isNotEqualTo _newObjectiveId) then {
    FLO_MatchState set ["revision", (FLO_MatchState get "revision") + 1];

    diag_log format [
        "[FLO][Match] Frontline operation line selected objective=%1 attack=%2 defend=%3 score=%4 sectorRadius=%5",
        _selection get "objectiveName",
        _selection get "attackSide",
        _selection get "defendSide",
        _selection get "score",
        _selection get "sectorRadius"
    ];

    true
} else {
    false
}
