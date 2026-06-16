params ["_className", "_category"];

private _traits = [_className, _category] call FLO_fnc_storeVehicleConfigTraits;
private _transport = _traits get "transport";
private _cargo = _traits get "cargo";
private _armor = _traits get "armor";
private _slingMass = _traits get "slingMass";
private _transportAmmo = _traits get "transportAmmo";
private _transportFuel = _traits get "transportFuel";
private _transportRepair = _traits get "transportRepair";
private _aceAmmo = _traits get "aceAmmo";
private _aceFuel = _traits get "aceFuel";
private _aceRepair = _traits get "aceRepair";
private _combatWeaponCount = _traits get "combatWeaponCount";
private _weaponPower = _traits get "weaponPower";
private _antiArmorScore = _traits get "antiArmorScore";
private _antiAirScore = _traits get "antiAirScore";
private _artilleryScore = _traits get "artilleryScore";
private _threatScore = _traits get "threatScore";
private _hasWeapon = _traits get "hasWeapon";
private _hasAntiArmor = _traits get "hasAntiArmor";
private _hasAntiAir = _traits get "hasAntiAir";
private _hasArtillery = _traits get "hasArtillery";
private _hasLogistics = _traits get "hasLogistics";
private _hasSensors = _traits get "hasSensors";
private _isMbt = _traits get "isMbt";
private _isIfv = _traits get "isIfv";
private _isApc = _traits get "isApc";
private _isUav = _traits get "isUav";

private _roleBase = switch (true) do {
    case (_category isEqualTo "cars" && {_hasLogistics}): { 1200 };
    case (_category isEqualTo "cars" && {_hasWeapon && {_armor >= 140}}): { 1450 };
    case (_category isEqualTo "cars" && {_hasWeapon}): { 900 };
    case (_category isEqualTo "cars" && {_armor >= 140}): { 1000 };
    case (_category isEqualTo "cars" && {_transport >= 8}): { 750 };
    case (_category isEqualTo "cars"): { 550 };

    case (_category isEqualTo "armor" && {_hasArtillery}): { 8000 };
    case (_category isEqualTo "armor" && {_isMbt}): { 8500 };
    case (_category isEqualTo "armor" && {_hasAntiAir}): { 6500 };
    case (_category isEqualTo "armor" && {_isIfv}): { 4200 };
    case (_category isEqualTo "armor" && {_isApc}): { 2800 };
    case (_category isEqualTo "armor"): { 3500 };

    case (_category isEqualTo "helis" && {_hasAntiArmor || {_hasAntiAir}}): { 9000 };
    case (_category isEqualTo "helis" && {_hasWeapon}): { 6500 };
    case (_category isEqualTo "helis" && {_transport >= 8}): { 4200 };
    case (_category isEqualTo "helis"): { 3500 };

    case (_category isEqualTo "planes" && {_hasWeapon}): { 13000 };
    case (_category isEqualTo "planes"): { 8000 };

    case (_category isEqualTo "naval" && {_hasWeapon}): { 1400 };
    case (_category isEqualTo "naval"): { 750 };

    case (_category isEqualTo "static" && {_hasArtillery}): { 2600 };
    case (_category isEqualTo "static" && {_hasAntiArmor || {_hasAntiAir}}): { 1600 };
    case (_category isEqualTo "static" && {_hasWeapon}): { 650 };
    case (_category isEqualTo "static"): { 450 };

    default { 1000 };
};

private _armorCap = switch (_category) do {
    case "cars": { 260 };
    case "armor": { 900 };
    case "helis": { 320 };
    case "planes": { 260 };
    case "naval": { 500 };
    case "static": { 450 };
    default { 450 };
};
private _armorFactor = switch (_category) do {
    case "cars": { 3 };
    case "armor": { 3 };
    case "helis": { 2 };
    case "planes": { 2 };
    case "naval": { 2 };
    case "static": { 2 };
    default { 2 };
};
private _protectionAdd = ceil (((_armor max 0) min _armorCap) * _armorFactor);
private _transportAdd = ((_transport max 0) min 20) * 45;
private _cargoAdd = ceil (((_cargo max 0) min 8000) / 160);
private _slingAdd = ceil (((_slingMass max 0) min 12000) / 180);
private _weaponAdd = 0;

if (_hasWeapon) then {
    _weaponAdd = 300
        + (((_combatWeaponCount max 0) min 4) * 150)
        + ceil (((_weaponPower max 0) min 900) * 1.6)
        + ceil ((_threatScore max 0) min 900);
};

if (_hasAntiArmor) then {
    _weaponAdd = _weaponAdd + (500 + ceil (((_antiArmorScore max 0) min 500) * 0.7));
};

if (_hasAntiAir) then {
    _weaponAdd = _weaponAdd + (650 + ceil (((_antiAirScore max 0) min 500) * 0.8));
};

if (_hasArtillery) then {
    _weaponAdd = _weaponAdd + (1200 + ceil (((_artilleryScore max 0) min 700) * 0.6));
};

private _logisticsAdd = 0;

if (_hasLogistics) then {
    _logisticsAdd = 500
        + ceil (((_transportAmmo max _aceAmmo) min 5000) / 8)
        + ceil (((_transportFuel max _aceFuel) min 10000) / 18)
        + ceil (((_transportRepair max 0) min 1000) / 4);

    if (_aceRepair > 0) then {
        _logisticsAdd = _logisticsAdd + 350;
    };
};

private _sensorAdd = 0;

if (_hasSensors) then {
    _sensorAdd = 350;
};

if (_isUav) then {
    _sensorAdd = _sensorAdd + 600;
};

private _cap = switch (_category) do {
    case "cars": { 6500 };
    case "armor": { 16000 };
    case "helis": { 18000 };
    case "planes": { 24000 };
    case "naval": { 8500 };
    case "static": { 7000 };
    default { 12000 };
};
private _floor = switch (_category) do {
    case "cars": { 500 };
    case "armor": { 2500 };
    case "helis": { 3000 };
    case "planes": { 7000 };
    case "naval": { 600 };
    case "static": { 400 };
    default { 800 };
};
private _price = _roleBase
    + _protectionAdd
    + _transportAdd
    + _cargoAdd
    + _slingAdd
    + _weaponAdd
    + _logisticsAdd
    + _sensorAdd;
private _rounded = (ceil (((_price min _cap) max _floor) / 50)) * 50;

_rounded
