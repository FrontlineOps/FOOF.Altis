params ["_data"];

if (!isServer) exitWith { false };

private _record = createHashMapFromArray _data;
private _now = diag_tickTime;
private _phaseRemaining = (_record get "phaseRemaining") max 0;

FLO_MatchState set ["revision", _record get "revision"];
FLO_MatchState set ["campaignDay", _record get "campaignDay"];
FLO_MatchState set ["phase", _record get "phase"];
FLO_MatchState set ["phaseNumber", _record get "phaseNumber"];
FLO_MatchState set ["phaseStartedAt", _now];
FLO_MatchState set ["phaseEndsAt", _now + _phaseRemaining];
FLO_MatchState set ["operationId", _record get "operationId"];
FLO_MatchState set ["operationObjectiveId", _record get "operationObjectiveId"];
FLO_MatchState set ["operationObjectiveName", _record get "operationObjectiveName"];
FLO_MatchState set ["operationObjectivePosition", _record get "operationObjectivePosition"];
FLO_MatchState set ["operationObjectiveRadius", _record get "operationObjectiveRadius"];
FLO_MatchState set ["operationSectorPosition", _record get "operationSectorPosition"];
FLO_MatchState set ["operationSectorRadius", _record get "operationSectorRadius"];
FLO_MatchState set ["operationSectorObjectiveIds", _record get "operationSectorObjectiveIds"];
FLO_MatchState set ["operationSecondaryObjectiveIds", _record get "operationSecondaryObjectiveIds"];
FLO_MatchState set ["operationInitialSecondaryOwners", _record get "operationInitialSecondaryOwners"];
FLO_MatchState set ["operationInitialOwner", _record get "operationInitialOwner"];
FLO_MatchState set ["operationAttackSide", _record get "operationAttackSide"];
FLO_MatchState set ["operationDefendSide", _record get "operationDefendSide"];
FLO_MatchState set ["operationInitialWestCells", _record get "operationInitialWestCells"];
FLO_MatchState set ["operationInitialEastCells", _record get "operationInitialEastCells"];
FLO_MatchState set ["operationInitialWestTickets", _record get "operationInitialWestTickets"];
FLO_MatchState set ["operationInitialEastTickets", _record get "operationInitialEastTickets"];
FLO_MatchState set ["operationWestSectorPresenceScore", _record get "operationWestSectorPresenceScore"];
FLO_MatchState set ["operationEastSectorPresenceScore", _record get "operationEastSectorPresenceScore"];
FLO_MatchState set ["operationWestSectorPresenceTicks", _record get "operationWestSectorPresenceTicks"];
FLO_MatchState set ["operationEastSectorPresenceTicks", _record get "operationEastSectorPresenceTicks"];
FLO_MatchState set ["plannedObjectiveId", _record get "plannedObjectiveId"];
FLO_MatchState set ["plannedObjectiveName", _record get "plannedObjectiveName"];
FLO_MatchState set ["plannedObjectivePosition", _record get "plannedObjectivePosition"];
FLO_MatchState set ["plannedObjectiveRadius", _record get "plannedObjectiveRadius"];
FLO_MatchState set ["plannedSectorPosition", _record get "plannedSectorPosition"];
FLO_MatchState set ["plannedSectorRadius", _record get "plannedSectorRadius"];
FLO_MatchState set ["plannedSectorObjectiveIds", _record get "plannedSectorObjectiveIds"];
FLO_MatchState set ["plannedSecondaryObjectiveIds", _record get "plannedSecondaryObjectiveIds"];
FLO_MatchState set ["plannedAttackSide", _record get "plannedAttackSide"];
FLO_MatchState set ["plannedDefendSide", _record get "plannedDefendSide"];
FLO_MatchState set ["campaignScoreWest", _record get "campaignScoreWest"];
FLO_MatchState set ["campaignScoreEast", _record get "campaignScoreEast"];

FLO_MatchDayResults = [];
{
    FLO_MatchDayResults pushBack createHashMapFromArray _x;
} forEach (_record get "dayResults");

diag_log format [
    "[FLO][Match] Loaded match flow phase=%1 day=%2 operation=%3 remaining=%4",
    FLO_MatchState get "phase",
    FLO_MatchState get "campaignDay",
    FLO_MatchState get "operationId",
    _phaseRemaining
];

true
