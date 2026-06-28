if (!isServer) exitWith {};

FLO_MatchSystemRunning = true;

FLO_MatchLoopHandle = [
    {
        params ["_args", "_handle"];

        if (!FLO_MatchSystemRunning) exitWith {
            [_handle] call CBA_fnc_removePerFrameHandler;
            FLO_MatchLoopHandle = -1;
        };

        [] call FLO_fnc_matchTick;
    },
    FLO_MatchTickInterval,
    []
] call CBA_fnc_addPerFrameHandler;

diag_log format ["[FLO][Match] Match flow handler started interval=%1", FLO_MatchTickInterval];
