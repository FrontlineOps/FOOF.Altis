params ["_control", "_isConfirmDialog", "_message"];

private _eventData = fromJSON _message;
private _event = _eventData get "event";
private _data = _eventData get "data";

switch (_event) do {
    case "objective::ready": {
        uiNamespace setVariable ["FLO_ObjectiveAreaControl", _control];
        FLO_ObjectiveAreaBrowserReady = true;
        [] call FLO_fnc_objectiveUpdateAreaDialog;
    };
    case "objective::select": {
        private _objectiveId = _data get "id";

        if ((_objectiveId isEqualType "") && {_objectiveId in FLO_ObjectiveClientObjectiveRecords}) then {
            FLO_ObjectiveAreaActiveId = _objectiveId;
            FLO_ObjectiveAreaHoverId = "";
            [] call FLO_fnc_objectiveUpdateAreaDialog;
            [] call FLO_fnc_objectiveUpdateAreaMap;
        };
    };
    case "objective::hover": {
        private _objectiveId = _data get "id";

        if !(_objectiveId isEqualType "") then {
            _objectiveId = "";
        };

        if ((_objectiveId isEqualTo "") || {_objectiveId in FLO_ObjectiveClientObjectiveRecords}) then {
            FLO_ObjectiveAreaHoverId = _objectiveId;
            [] call FLO_fnc_objectiveUpdateAreaMap;
        };
    };
    case "objective::upgrade": {
        private _objectiveId = _data get "id";

        if !(_objectiveId isEqualType "") then {
            _objectiveId = FLO_ObjectiveAreaActiveId;
        };

        [player, _objectiveId] remoteExecCall ["FLO_fnc_objectiveRequestUpgrade", 2];
    };
    case "objective::close": {
        (ctrlParent _control) closeDisplay 0;
    };
    default {
        diag_log format ["[FLO][Objective] Unhandled objective area UI event: %1", _event];
    };
};

true
