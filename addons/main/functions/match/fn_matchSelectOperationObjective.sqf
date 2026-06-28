params [["_preferredObjectiveId", ""]];

private _candidateIds = keys FLO_Objectives;

if (_preferredObjectiveId isNotEqualTo "") then {
    if (_preferredObjectiveId in FLO_Objectives) then {
        _candidateIds = [_preferredObjectiveId];
    };
};

if (_candidateIds isEqualTo []) exitWith { createHashMap };

private _westDeployPos = (FLO_DeploymentZones get "WEST") get "position";
private _eastDeployPos = (FLO_DeploymentZones get "EAST") get "position";
private _bestScore = -999999;
private _best = createHashMap;

{
    private _objective = FLO_Objectives get _x;
    private _position = _objective get "position";
    private _owner = _objective get "owner";
    private _cellIds = _objective get "cellIds";
    private _westLinked = 0;
    private _eastLinked = 0;
    private _westNear = false;
    private _eastNear = false;
    private _touching = false;

    {
        private _cell = FLO_ObjectiveCells get _x;
        private _cellOwner = _cell get "owner";

        if (_cellOwner isEqualTo west) then {
            _westLinked = _westLinked + 1;
            _westNear = true;
        };

        if (_cellOwner isEqualTo east) then {
            _eastLinked = _eastLinked + 1;
            _eastNear = true;
        };

        {
            private _neighbor = FLO_ObjectiveCells get _x;
            private _neighborOwner = _neighbor get "owner";

            if (_neighborOwner isEqualTo west) then {
                _westNear = true;
            };

            if (_neighborOwner isEqualTo east) then {
                _eastNear = true;
            };

            if (
                ((_cellOwner isEqualTo west) && {_neighborOwner isEqualTo east}) ||
                {(_cellOwner isEqualTo east) && {_neighborOwner isEqualTo west}}
            ) then {
                _touching = true;
            };
        } forEach (_cell get "cardinalNeighborIds");
    } forEach _cellIds;

    private _westDistance = _position distance2D _westDeployPos;
    private _eastDistance = _position distance2D _eastDeployPos;
    private _distanceBalance = abs (_westDistance - _eastDistance);
    private _averageDistance = (_westDistance + _eastDistance) / 2;
    private _score = (_objective get "resourceWeight") * 25;

    if (_touching) then {
        _score = _score + 600;
    };

    if (_objective get "frontline") then {
        _score = _score + 300;
    };

    if (_westNear && {_eastNear}) then {
        _score = _score + 250;
    };

    if (_owner isEqualTo sideUnknown) then {
        _score = _score + 120;
    };

    _score = _score + (1000 - ((_distanceBalance min 10000) / 10));
    _score = _score + (500 - ((_averageDistance min 5000) / 10));

    if (_score > _bestScore) then {
        private _ownerKey = [_owner] call FLO_fnc_objectiveSideKey;
        private _attackSide = "BOTH";
        private _defendSide = "NONE";

        if (_owner isEqualTo west) then {
            _attackSide = "EAST";
            _defendSide = "WEST";
        };

        if (_owner isEqualTo east) then {
            _attackSide = "WEST";
            _defendSide = "EAST";
        };

        _bestScore = _score;
        _best = createHashMapFromArray [
            ["objectiveId", _objective get "id"],
            ["objectiveName", _objective get "name"],
            ["objectivePosition", _position],
            ["objectiveRadius", _objective get "displayRadius"],
            ["owner", _ownerKey],
            ["attackSide", _attackSide],
            ["defendSide", _defendSide],
            ["score", _score],
            ["westLinkedCells", _westLinked],
            ["eastLinkedCells", _eastLinked],
            ["touchingFrontline", _touching]
        ];
    };
} forEach _candidateIds;

if ((count _best) > 0) then {
    private _sector = [_best] call FLO_fnc_matchBuildOperationSector;
    private _sectorObjectiveIds = [_sector get "position", _sector get "radius"] call FLO_fnc_matchOperationSectorObjectiveIds;
    private _secondaryObjectiveIds = _sectorObjectiveIds select {_x isNotEqualTo (_best get "objectiveId")};

    _best set ["sectorPosition", _sector get "position"];
    _best set ["sectorRadius", _sector get "radius"];
    _best set ["sectorCellCount", _sector get "cellCount"];
    _best set ["sectorObjectiveIds", _sectorObjectiveIds];
    _best set ["secondaryObjectiveIds", _secondaryObjectiveIds];
};

_best
