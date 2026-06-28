params ["_selection"];

private _objectiveId = _selection get "objectiveId";
private _objective = FLO_Objectives get _objectiveId;
private _objectivePosition = _objective get "position";
private _objectiveRadius = _objective get "displayRadius";
private _cellIds = _objective get "cellIds";
private _sectorCellIds = createHashMap;
private _points = [_objectivePosition, _objectivePosition, _objectivePosition];

{
    private _cell = FLO_ObjectiveCells get _x;
    _sectorCellIds set [_x, true];
    _points pushBack (_cell get "position");

    {
        _sectorCellIds set [_x, true];
    } forEach (_cell get "cardinalNeighborIds");
} forEach _cellIds;

{
    private _cell = FLO_ObjectiveCells get _x;
    private _cellOwner = _cell get "owner";

    _points pushBack (_cell get "position");

    {
        private _neighbor = FLO_ObjectiveCells get _x;
        private _neighborOwner = _neighbor get "owner";

        if (
            ((_cellOwner isEqualTo west) && {_neighborOwner isEqualTo east}) ||
            {(_cellOwner isEqualTo east) && {_neighborOwner isEqualTo west}}
        ) then {
            _points pushBack (_cell get "position");
            _points pushBack (_neighbor get "position");
        };
    } forEach (_cell get "cardinalNeighborIds");
} forEach (keys _sectorCellIds);

private _sumX = 0;
private _sumY = 0;

{
    _sumX = _sumX + (_x # 0);
    _sumY = _sumY + (_x # 1);
} forEach _points;

private _sectorPosition = [_sumX / (count _points), _sumY / (count _points), 0];
private _sectorRadius = _objectiveRadius;

{
    _sectorRadius = _sectorRadius max (_sectorPosition distance2D _x);
} forEach _points;

private _minRadius = FLO_MatchOperationSectorMinRadius min FLO_MatchOperationSectorMaxRadius;
private _maxRadius = FLO_MatchOperationSectorMinRadius max FLO_MatchOperationSectorMaxRadius;
_sectorRadius = ((_sectorRadius + FLO_MatchOperationSectorBuffer) max _minRadius) min _maxRadius;

createHashMapFromArray [
    ["position", _sectorPosition],
    ["radius", _sectorRadius],
    ["cellCount", count (keys _sectorCellIds)]
]
