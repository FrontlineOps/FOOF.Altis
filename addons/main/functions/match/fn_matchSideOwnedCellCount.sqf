params ["_side"];

private _count = 0;

{
    if (((FLO_ObjectiveCells get _x) get "owner") isEqualTo _side) then {
        _count = _count + 1;
    };
} forEach FLO_ObjectiveGridCellIds;

_count
