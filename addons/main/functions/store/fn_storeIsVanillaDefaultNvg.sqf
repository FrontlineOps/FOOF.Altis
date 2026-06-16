params ["_className"];

private _cfg = configFile >> "CfgWeapons" >> _className;

if !(isClass _cfg) exitWith { false };

private _itemType = _className call BIS_fnc_itemType;
private _kind = _itemType param [1, ""];

if (_kind isNotEqualTo "NVGoggles") exitWith { false };

[_cfg] call FLO_fnc_storeIsVanillaConfig
