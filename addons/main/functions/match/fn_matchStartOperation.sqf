if (!isServer) exitWith {};

private _selection = [FLO_MatchState get "plannedObjectiveId", FLO_MatchState get "nextOffensiveSide"] call FLO_fnc_matchSelectOperationObjective;

if ((count _selection) isEqualTo 0) then {
    _selection = ["", FLO_MatchState get "nextOffensiveSide"] call FLO_fnc_matchSelectOperationObjective;
};

if ((count _selection) isEqualTo 0) exitWith {
    diag_log "[FLO][Match] Cannot start operation; no valid operation objective exists";
    ["frontline", FLO_MatchFrontlineDuration] call FLO_fnc_matchStartPhase;
};

private _now = diag_tickTime;
private _secondaryObjectiveIds = _selection get "secondaryObjectiveIds";
private _initialSecondaryOwners = [];

{
    private _objective = FLO_Objectives get _x;
    _initialSecondaryOwners pushBack [_x, [_objective get "owner"] call FLO_fnc_objectiveSideKey];
} forEach _secondaryObjectiveIds;

FLO_MatchState set ["phase", "operation"];
FLO_MatchState set ["phaseNumber", 2];
FLO_MatchState set ["phaseStartedAt", _now];
FLO_MatchState set ["phaseEndsAt", _now + FLO_MatchOperationDuration];
FLO_MatchState set ["operationId", (FLO_MatchState get "operationId") + 1];
FLO_MatchState set ["operationObjectiveId", _selection get "objectiveId"];
FLO_MatchState set ["operationObjectiveName", _selection get "objectiveName"];
FLO_MatchState set ["operationObjectivePosition", _selection get "objectivePosition"];
FLO_MatchState set ["operationObjectiveRadius", _selection get "objectiveRadius"];
FLO_MatchState set ["operationSectorPosition", _selection get "sectorPosition"];
FLO_MatchState set ["operationSectorRadius", _selection get "sectorRadius"];
FLO_MatchState set ["operationSectorObjectiveIds", _selection get "sectorObjectiveIds"];
FLO_MatchState set ["operationSecondaryObjectiveIds", _secondaryObjectiveIds];
FLO_MatchState set ["operationInitialSecondaryOwners", _initialSecondaryOwners];
FLO_MatchState set ["operationInitialOwner", _selection get "owner"];
FLO_MatchState set ["operationOffensiveSide", _selection get "offensiveSide"];
FLO_MatchState set ["operationAttackSide", _selection get "attackSide"];
FLO_MatchState set ["operationDefendSide", _selection get "defendSide"];
FLO_MatchState set ["operationInitialWestCells", [west] call FLO_fnc_matchSideOwnedCellCount];
FLO_MatchState set ["operationInitialEastCells", [east] call FLO_fnc_matchSideOwnedCellCount];
FLO_MatchState set ["operationInitialWestTickets", FLO_TicketBalances get "WEST"];
FLO_MatchState set ["operationInitialEastTickets", FLO_TicketBalances get "EAST"];
FLO_MatchState set ["operationWestSectorPresenceScore", 0];
FLO_MatchState set ["operationEastSectorPresenceScore", 0];
FLO_MatchState set ["operationWestSectorPresenceTicks", 0];
FLO_MatchState set ["operationEastSectorPresenceTicks", 0];
FLO_MatchState set ["plannedObjectiveId", ""];
FLO_MatchState set ["plannedObjectiveName", ""];
FLO_MatchState set ["plannedObjectivePosition", [0, 0, 0]];
FLO_MatchState set ["plannedObjectiveRadius", 0];
FLO_MatchState set ["plannedSectorPosition", [0, 0, 0]];
FLO_MatchState set ["plannedSectorRadius", 0];
FLO_MatchState set ["plannedSectorObjectiveIds", []];
FLO_MatchState set ["plannedSecondaryObjectiveIds", []];
FLO_MatchState set ["plannedOffensiveSide", FLO_MatchState get "nextOffensiveSide"];
FLO_MatchState set ["plannedAttackSide", "BOTH"];
FLO_MatchState set ["plannedDefendSide", "NONE"];
FLO_MatchState set ["revision", (FLO_MatchState get "revision") + 1];

diag_log format [
    "[FLO][Match] Day %1 operation %2 started objective=%3 offensive=%4 attack=%5 defend=%6 duration=%7 sectorRadius=%8 secondaries=%9",
    FLO_MatchState get "campaignDay",
    FLO_MatchState get "operationId",
    _selection get "objectiveName",
    _selection get "offensiveSide",
    _selection get "attackSide",
    _selection get "defendSide",
    FLO_MatchOperationDuration,
    _selection get "sectorRadius",
    count _secondaryObjectiveIds
];

["operation"] call FLO_fnc_matchNotifyPhase;
[0] call FLO_fnc_matchSendSnapshot;
["matchOperationStart"] call FLO_fnc_persistenceScheduleSave;
