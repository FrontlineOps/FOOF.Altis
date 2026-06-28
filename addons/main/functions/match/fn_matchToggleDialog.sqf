if (!hasInterface) exitWith { false };

private _display = findDisplay FLO_MatchDialogIdd;

if (!isNull _display) exitWith {
    _display closeDisplay 0;
    true
};

[] call FLO_fnc_matchOpenDialog
