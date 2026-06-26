if (!hasInterface) exitWith {};
if (FLO_TicketManualRespawnPfh >= 0) exitWith {};

FLO_TicketManualRespawnPfh = [
    {
        private _display = findDisplay 49;

        if (isNull _display) exitWith {
            FLO_TicketManualRespawnDisplay = displayNull;
        };

        if (_display isEqualTo FLO_TicketManualRespawnDisplay) exitWith {};

        FLO_TicketManualRespawnDisplay = _display;
        [_display] call FLO_fnc_ticketConfigureManualRespawn;
    },
    0.25,
    []
] call CBA_fnc_addPerFrameHandler;
