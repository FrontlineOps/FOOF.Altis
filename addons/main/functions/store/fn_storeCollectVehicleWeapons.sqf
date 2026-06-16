params ["_cfg"];

private _weapons = [];
private _magazines = [];

private _addUnique = {
    params ["_items", "_value"];

    if (_value isEqualTo "") exitWith {};
    if !(_value in _items) then {
        _items pushBack _value;
    };
};

{
    [_weapons, _x] call _addUnique;
} forEach getArray (_cfg >> "weapons");

{
    [_magazines, _x] call _addUnique;
} forEach getArray (_cfg >> "magazines");

{
    private _child = [_x] call FLO_fnc_storeCollectVehicleWeapons;

    {
        [_weapons, _x] call _addUnique;
    } forEach (_child get "weapons");

    {
        [_magazines, _x] call _addUnique;
    } forEach (_child get "magazines");
} forEach ("true" configClasses (_cfg >> "Turrets"));

createHashMapFromArray [
    ["weapons", _weapons],
    ["magazines", _magazines]
]
