if (!isServer) exitWith {};
if (isNil "FLO_MatchState") exitWith {};

private _phase = FLO_MatchState get "phase";
private _objectiveId = "";

if (_phase isEqualTo "frontline") then {
    _objectiveId = FLO_MatchState get "plannedObjectiveId";
};

if (_phase isEqualTo "operation") then {
    _objectiveId = FLO_MatchState get "operationObjectiveId";
};

if (_objectiveId isEqualTo "") exitWith {};

private _selection = createHashMapFromArray [
    ["objectiveId", _objectiveId]
];
private _sector = [_selection] call FLO_fnc_matchBuildOperationSector;
private _sectorObjectiveIds = [_sector get "position", _sector get "radius"] call FLO_fnc_matchOperationSectorObjectiveIds;
private _secondaryObjectiveIds = _sectorObjectiveIds select {_x isNotEqualTo _objectiveId};

if (_phase isEqualTo "frontline") then {
    FLO_MatchState set ["plannedSectorPosition", _sector get "position"];
    FLO_MatchState set ["plannedSectorRadius", _sector get "radius"];
    FLO_MatchState set ["plannedSectorObjectiveIds", _sectorObjectiveIds];
    FLO_MatchState set ["plannedSecondaryObjectiveIds", _secondaryObjectiveIds];
};

if (_phase isEqualTo "operation") then {
    private _initialSecondaryOwners = [];

    {
        private _objective = FLO_Objectives get _x;
        _initialSecondaryOwners pushBack [_x, [_objective get "owner"] call FLO_fnc_objectiveSideKey];
    } forEach _secondaryObjectiveIds;

    FLO_MatchState set ["operationSectorPosition", _sector get "position"];
    FLO_MatchState set ["operationSectorRadius", _sector get "radius"];
    FLO_MatchState set ["operationSectorObjectiveIds", _sectorObjectiveIds];
    FLO_MatchState set ["operationSecondaryObjectiveIds", _secondaryObjectiveIds];
    FLO_MatchState set ["operationInitialSecondaryOwners", _initialSecondaryOwners];
};

FLO_MatchState set ["revision", (FLO_MatchState get "revision") + 1];
[0] call FLO_fnc_matchSendSnapshot;
