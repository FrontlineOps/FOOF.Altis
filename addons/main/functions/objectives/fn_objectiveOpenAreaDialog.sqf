params [["_objectiveId", "", [""]]];

if (!hasInterface) exitWith { false };

if (_objectiveId isNotEqualTo "") then {
    FLO_ObjectiveAreaActiveId = _objectiveId;
};

private _display = findDisplay FLO_ObjectiveAreaDialogIdd;

if (!isNull _display) exitWith {
    [] call FLO_fnc_objectiveUpdateAreaDialog;
    [] call FLO_fnc_objectiveUpdateAreaMap;
    true
};

createDialog "FLO_ObjectiveAreaDialog";
_display = findDisplay FLO_ObjectiveAreaDialogIdd;

if (isNull _display) exitWith { false };

FLO_ObjectiveAreaBrowserReady = false;

private _control = _display displayCtrl FLO_ObjectiveAreaBrowserIdc;
uiNamespace setVariable ["FLO_ObjectiveAreaControl", _control];

private _mapControl = _display displayCtrl FLO_ObjectiveAreaMapIdc;
uiNamespace setVariable ["FLO_ObjectiveAreaMapControl", _mapControl];

_mapControl ctrlAddEventHandler ["Draw", {
    _this call FLO_fnc_objectiveDrawAreaMap;
}];
_mapControl ctrlAddEventHandler ["MouseButtonClick", {
    _this call FLO_fnc_objectiveSelectAreaFromMap;
}];

[_control] call FLO_fnc_objectiveAddAreaWebEventHandler;
[_control, ["LoadFile", "\z\foof\addons\main\ui\objective\index.html"]] call FLO_fnc_objectiveAreaWebAction;
[] call FLO_fnc_objectiveUpdateAreaMap;

true
