if (!isServer) exitWith {};

FLO_MatchDayResults = [];
FLO_MatchLastSnapshotAt = -9999;
FLO_MatchSystemRunning = false;
FLO_MatchLoopHandle = -1;

FLO_MatchState = createHashMapFromArray [
    ["revision", 0],
    ["campaignDay", 1],
    ["phase", "setup"],
    ["phaseNumber", 0],
    ["phaseStartedAt", diag_tickTime],
    ["phaseEndsAt", diag_tickTime + FLO_MatchSetupDuration],
    ["operationId", 0],
    ["operationObjectiveId", ""],
    ["operationObjectiveName", ""],
    ["operationObjectivePosition", [0, 0, 0]],
    ["operationObjectiveRadius", 0],
    ["operationSectorPosition", [0, 0, 0]],
    ["operationSectorRadius", 0],
    ["operationSectorObjectiveIds", []],
    ["operationSecondaryObjectiveIds", []],
    ["operationInitialSecondaryOwners", []],
    ["operationInitialOwner", "NONE"],
    ["operationOffensiveSide", "BOTH"],
    ["operationAttackSide", "BOTH"],
    ["operationDefendSide", "NONE"],
    ["operationInitialWestCells", [west] call FLO_fnc_matchSideOwnedCellCount],
    ["operationInitialEastCells", [east] call FLO_fnc_matchSideOwnedCellCount],
    ["operationInitialWestTickets", FLO_TicketBalances get "WEST"],
    ["operationInitialEastTickets", FLO_TicketBalances get "EAST"],
    ["operationWestSectorPresenceScore", 0],
    ["operationEastSectorPresenceScore", 0],
    ["operationWestSectorPresenceTicks", 0],
    ["operationEastSectorPresenceTicks", 0],
    ["plannedObjectiveId", ""],
    ["plannedObjectiveName", ""],
    ["plannedObjectivePosition", [0, 0, 0]],
    ["plannedObjectiveRadius", 0],
    ["plannedSectorPosition", [0, 0, 0]],
    ["plannedSectorRadius", 0],
    ["plannedSectorObjectiveIds", []],
    ["plannedSecondaryObjectiveIds", []],
    ["plannedOffensiveSide", "BOTH"],
    ["plannedAttackSide", "BOTH"],
    ["plannedDefendSide", "NONE"],
    ["nextOffensiveSide", "BOTH"],
    ["campaignScoreWest", 0],
    ["campaignScoreEast", 0]
];

["setup", FLO_MatchSetupDuration, false] call FLO_fnc_matchStartPhase;

FLO_MatchPlayerConnectedEh = [
    "FLO_eventPlayerConnected",
    {
        params ["_id", "_uid", "_name", "_jip", "_owner"];

        [
            {
                params ["_owner"];

                if (isServer) then {
                    [_owner] call FLO_fnc_matchSendSnapshot;
                };
            },
            [_owner],
            3
        ] call CBA_fnc_waitAndExecute;
    }
] call CBA_fnc_addEventHandler;

[] call FLO_fnc_matchStartLoop;

diag_log format [
    "[FLO][Match] Match flow initialized setup=%1 frontline=%2 operation=%3",
    FLO_MatchSetupDuration,
    FLO_MatchFrontlineDuration,
    FLO_MatchOperationDuration
];
