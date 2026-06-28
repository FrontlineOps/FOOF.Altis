private _secondsRemaining = round (((FLO_MatchState get "phaseEndsAt") - diag_tickTime) max 0);
private _results = +FLO_MatchDayResults;

if ((count _results) > 6) then {
    _results = _results select [(count _results) - 6, 6];
};

createHashMapFromArray [
    ["revision", FLO_MatchState get "revision"],
    ["campaignDay", FLO_MatchState get "campaignDay"],
    ["phase", FLO_MatchState get "phase"],
    ["phaseNumber", FLO_MatchState get "phaseNumber"],
    ["phaseLabel", [FLO_MatchState get "phase"] call FLO_fnc_matchPhaseLabel],
    ["secondsRemaining", _secondsRemaining],
    ["operationId", FLO_MatchState get "operationId"],
    ["operationObjectiveId", FLO_MatchState get "operationObjectiveId"],
    ["operationObjectiveName", FLO_MatchState get "operationObjectiveName"],
    ["operationObjectivePosition", FLO_MatchState get "operationObjectivePosition"],
    ["operationObjectiveRadius", FLO_MatchState get "operationObjectiveRadius"],
    ["operationSectorPosition", FLO_MatchState get "operationSectorPosition"],
    ["operationSectorRadius", FLO_MatchState get "operationSectorRadius"],
    ["operationSectorObjectiveIds", FLO_MatchState get "operationSectorObjectiveIds"],
    ["operationSecondaryObjectiveIds", FLO_MatchState get "operationSecondaryObjectiveIds"],
    ["operationInitialOwner", FLO_MatchState get "operationInitialOwner"],
    ["operationAttackSide", FLO_MatchState get "operationAttackSide"],
    ["operationDefendSide", FLO_MatchState get "operationDefendSide"],
    ["operationWestSectorPresenceScore", FLO_MatchState get "operationWestSectorPresenceScore"],
    ["operationEastSectorPresenceScore", FLO_MatchState get "operationEastSectorPresenceScore"],
    ["operationWestSectorPresenceTicks", FLO_MatchState get "operationWestSectorPresenceTicks"],
    ["operationEastSectorPresenceTicks", FLO_MatchState get "operationEastSectorPresenceTicks"],
    ["plannedObjectiveId", FLO_MatchState get "plannedObjectiveId"],
    ["plannedObjectiveName", FLO_MatchState get "plannedObjectiveName"],
    ["plannedObjectivePosition", FLO_MatchState get "plannedObjectivePosition"],
    ["plannedObjectiveRadius", FLO_MatchState get "plannedObjectiveRadius"],
    ["plannedSectorPosition", FLO_MatchState get "plannedSectorPosition"],
    ["plannedSectorRadius", FLO_MatchState get "plannedSectorRadius"],
    ["plannedSectorObjectiveIds", FLO_MatchState get "plannedSectorObjectiveIds"],
    ["plannedSecondaryObjectiveIds", FLO_MatchState get "plannedSecondaryObjectiveIds"],
    ["plannedAttackSide", FLO_MatchState get "plannedAttackSide"],
    ["plannedDefendSide", FLO_MatchState get "plannedDefendSide"],
    ["campaignScoreWest", FLO_MatchState get "campaignScoreWest"],
    ["campaignScoreEast", FLO_MatchState get "campaignScoreEast"],
    ["dayResults", _results]
]
