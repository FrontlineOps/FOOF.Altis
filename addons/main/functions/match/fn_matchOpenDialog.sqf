if (!hasInterface) exitWith { false };

private _display = findDisplay FLO_MatchDialogIdd;

if (!isNull _display) exitWith {
    [] call FLO_fnc_matchUpdateDialog;
    true
};

createDialog "FLO_MatchDialog";
_display = findDisplay FLO_MatchDialogIdd;

if (isNull _display) exitWith { false };

FLO_MatchBrowserReady = false;

private _control = _display displayCtrl FLO_MatchBrowserIdc;
uiNamespace setVariable ["FLO_MatchControl", _control];

[_control] call FLO_fnc_matchAddWebEventHandler;
[_control, ["LoadFile", "\z\foof\addons\main\ui\match\index.html"]] call FLO_fnc_matchWebAction;

[player] remoteExecCall ["FLO_fnc_matchRequestSnapshot", 2];

true
