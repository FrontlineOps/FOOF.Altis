if (!hasInterface) exitWith { false };

private _display = findDisplay FLO_ObjectiveAreaDialogIdd;

if (!isNull _display) exitWith {
    _display closeDisplay 0;
    true
};

private _objectiveId = [] call FLO_fnc_objectiveNearestAreaId;

[_objectiveId] call FLO_fnc_objectiveOpenAreaDialog
