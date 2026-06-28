if ((toLower missionName) in ["intro", "introexp"]) exitWith {};

if (isServer) then {
    [
        {
            !isNil "FLO_Objectives"
            && {!isNil "FLO_ObjectiveCells"}
            && {!isNil "FLO_ObjectiveGridCellIds"}
            && {!isNil "FLO_DeploymentZones"}
            && {!isNil "FLO_ResourceBalances"}
            && {!isNil "FLO_TicketBalances"}
        },
        {
            [] call FLO_fnc_matchInitServer;
        },
        []
    ] call CBA_fnc_waitUntilAndExecute;
};

if (hasInterface) then {
    [] call FLO_fnc_matchClientInit;
};
