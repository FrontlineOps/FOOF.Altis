if (!hasInterface) exitWith {};

FLO_MatchLastAnnouncedPhaseKey = "";

[
    {!isNull player},
    {
        [
            "FOOF",
            "openMatchPanel",
            ["Open Match Flow Panel", "Open the current campaign phase, operation, and scoring panel."],
            { [] call FLO_fnc_matchToggleDialog; true },
            {},
            [50, [true, true, false]],
            false
        ] call CBA_fnc_addKeybind;

        [player] remoteExecCall ["FLO_fnc_matchRequestSnapshot", 2];
    },
    []
] call CBA_fnc_waitUntilAndExecute;
