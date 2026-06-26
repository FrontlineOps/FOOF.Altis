params ["_control", "_button", "_xPos", "_yPos"];

if (!hasInterface) exitWith { false };
if (_button isNotEqualTo 0) exitWith { false };

private _playerSide = side group player;

if !(_playerSide in [west, east]) exitWith { false };

private _playerSideKey = [_playerSide] call FLO_fnc_resourceSideKey;
private _worldPos = _control ctrlMapScreenToWorld [_xPos, _yPos];
private _bestId = "";
private _bestDistance = 999999;

{
    _x params [
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

    if ((_ownerKey isEqualTo _playerSideKey) && {_objectiveState isEqualTo "held"}) then {
        private _distance = _worldPos distance2D _position;

        if ((_distance <= _displayRadius) && {_distance < _bestDistance}) then {
            _bestId = _objectiveId;
            _bestDistance = _distance;
        };
    };
} forEach (values FLO_ObjectiveClientObjectiveRecords);

if (_bestId isEqualTo "") exitWith { false };

FLO_ObjectiveAreaActiveId = _bestId;
FLO_ObjectiveAreaHoverId = "";

[] call FLO_fnc_objectiveUpdateAreaDialog;
[] call FLO_fnc_objectiveUpdateAreaMap;

true
