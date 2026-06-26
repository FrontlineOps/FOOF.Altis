if (!hasInterface) exitWith {};

private _control = uiNamespace getVariable ["FLO_ObjectiveAreaMapControl", controlNull];

if (isNull _control) exitWith {};

private _focusId = FLO_ObjectiveAreaHoverId;

if (_focusId isEqualTo "") then {
    _focusId = FLO_ObjectiveAreaActiveId;
};

if !(_focusId in FLO_ObjectiveClientObjectiveRecords) exitWith {};

private _record = FLO_ObjectiveClientObjectiveRecords get _focusId;

_record params [
    "_objectiveId",
    "_name",
    "_position",
    "_ownerKey",
    "_objectiveState",
    "_eastWeight",
    "_westWeight",
    "_totalWeight",
    "_cells",
    "_resourceWeight",
    "_locationType",
    "_displayRadius"
];

private _scale = ((_displayRadius max 300) / 5500) max 0.045;
_scale = _scale min 0.18;

_control ctrlMapAnimAdd [0.25, _scale, _position];
ctrlMapAnimCommit _control;
