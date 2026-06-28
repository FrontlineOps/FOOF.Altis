if (!hasInterface) exitWith {};

private _control = uiNamespace getVariable ["FLO_MatchControl", controlNull];

if (isNull _control) exitWith {};
if (!FLO_MatchBrowserReady) exitWith {};

private _playerSideKey = "NONE";
private _playerSide = side group player;

if (_playerSide in [west, east]) then {
    _playerSideKey = [_playerSide] call FLO_fnc_resourceSideKey;
};

private _payload = createHashMapFromArray [
    ["playerSide", _playerSideKey],
    ["snapshot", FLO_MatchSnapshot],
    ["clientTime", diag_tickTime]
];

private _script = format [
    "if (window.FOOFMatch) { window.FOOFMatch.receive(%1); }",
    toJSON _payload
];

[_control, ["ExecJS", _script]] call FLO_fnc_matchWebAction;
