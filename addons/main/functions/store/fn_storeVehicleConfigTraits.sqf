params ["_className", "_category"];

private _cfg = configFile >> "CfgVehicles" >> _className;

if !(isClass _cfg) then {
    throw format ["[FLO][Store] Cannot price missing vehicle class %1", _className];
};

private _collected = [_cfg] call FLO_fnc_storeCollectVehicleWeapons;
private _weapons = +(_collected get "weapons");
private _magazines = +(_collected get "magazines");

private _addUnique = {
    params ["_items", "_value"];

    if (_value isEqualTo "") exitWith {};
    if !(_value in _items) then {
        _items pushBack _value;
    };
};

{
    private _weaponCfg = configFile >> "CfgWeapons" >> _x;

    if (isClass _weaponCfg) then {
        {
            [_magazines, _x] call _addUnique;
        } forEach getArray (_weaponCfg >> "magazines");
    };
} forEach _weapons;

private _transport = getNumber (_cfg >> "transportSoldier");
private _cargo = getNumber (_cfg >> "maximumLoad");
private _armor = getNumber (_cfg >> "armor");
private _slingMass = getNumber (_cfg >> "slingLoadMaxCargoMass");
private _transportAmmo = getNumber (_cfg >> "transportAmmo");
private _transportFuel = getNumber (_cfg >> "transportFuel");
private _transportRepair = getNumber (_cfg >> "transportRepair");
private _aceAmmo = getNumber (_cfg >> "ace_rearm_defaultSupply");
private _aceFuel = getNumber (_cfg >> "ace_refuel_fuelCapacity");
private _aceRepair = getNumber (_cfg >> "ace_repair_canRepair");
private _radar = getNumber (_cfg >> "radarType");
private _irScan = getNumber (_cfg >> "irScanRange");
private _laserScanner = getNumber (_cfg >> "laserScanner");
private _lockDetection = getNumber (_cfg >> "lockDetectionSystem");
private _incomingMissileDetection = getNumber (_cfg >> "incomingMissileDetectionSystem");
private _artilleryScanner = getNumber (_cfg >> "artilleryScanner");
private _isUav = getNumber (_cfg >> "isUav");
private _threat = getArray (_cfg >> "threat");
private _softThreat = _threat param [0, 0];
private _armorThreat = _threat param [1, 0];
private _airThreat = _threat param [2, 0];
private _searchText = toLower format ["%1 %2 %3", _className, getText (_cfg >> "displayName"), getText (_cfg >> "editorSubcategory")];
private _combatWeaponCount = 0;
private _weaponPower = 0;
private _antiArmorScore = 0;
private _antiAirScore = 0;
private _artilleryScore = 0;
private _cannonScore = 0;
private _machineGunScore = 0;
private _directHitMax = 0;
private _indirectPowerMax = 0;

{
    private _weaponCfg = configFile >> "CfgWeapons" >> _x;
    private _weaponText = toLower format ["%1 %2", _x, getText (_weaponCfg >> "displayName")];
    private _isUtilityWeapon = false;

    {
        if ((_weaponText find _x) >= 0) exitWith {
            _isUtilityWeapon = true;
        };
    } forEach [
        "horn",
        "smoke",
        "flare",
        "chaff",
        "countermeasure",
        "laserdesignator",
        "fakeweapon",
        "weaponempty"
    ];

    if (!_isUtilityWeapon) then {
        _combatWeaponCount = _combatWeaponCount + 1;
    };
} forEach _weapons;

{
    private _magCfg = configFile >> "CfgMagazines" >> _x;

    if !(isClass _magCfg) then { continue };

    private _ammoClass = getText (_magCfg >> "ammo");
    private _ammoCfg = configFile >> "CfgAmmo" >> _ammoClass;

    if !(isClass _ammoCfg) then { continue };

    private _ammoText = toLower format ["%1 %2 %3", _ammoClass, configName _magCfg, getText (_magCfg >> "displayName")];
    private _simulation = toLower getText (_ammoCfg >> "simulation");
    private _isUtilityAmmo = false;

    {
        if ((_ammoText find _x) >= 0) exitWith {
            _isUtilityAmmo = true;
        };
    } forEach ["smoke", "flare", "chaff", "countermeasure", "laser"];

    if (_isUtilityAmmo || {_simulation isEqualTo "shotsmoke"}) then { continue };

    private _hit = getNumber (_ammoCfg >> "hit");
    private _indirectHit = getNumber (_ammoCfg >> "indirectHit");
    private _indirectRange = getNumber (_ammoCfg >> "indirectHitRange");
    private _airLock = getNumber (_ammoCfg >> "airLock");
    private _irLock = getNumber (_ammoCfg >> "irLock");
    private _laserLock = getNumber (_ammoCfg >> "laserLock");
    private _manualControl = getNumber (_ammoCfg >> "manualControl");
    private _maxControlRange = getNumber (_ammoCfg >> "maxControlRange");
    private _indirectPower = _indirectHit * (_indirectRange max 1);
    private _roundPower = (_hit min 220) + (_indirectPower min 420);

    _directHitMax = _directHitMax max _hit;
    _indirectPowerMax = _indirectPowerMax max _indirectPower;
    _weaponPower = _weaponPower + (_roundPower min 260);

    if (_hit >= 45 && {_hit < 120}) then {
        _cannonScore = _cannonScore + (_hit min 90);
    };

    if (_hit > 0 && {_hit < 45}) then {
        _machineGunScore = _machineGunScore + (_hit min 35);
    };

    if (
        _hit >= 120
        || {_manualControl > 0}
        || {_maxControlRange > 0}
        || {(_ammoText find "atgm") >= 0}
        || {(_ammoText find "at_") >= 0}
        || {(_ammoText find "heat") >= 0}
        || {(_ammoText find "apfsds") >= 0}
    ) then {
        _antiArmorScore = _antiArmorScore + ((_hit min 220) max 80);
    };

    if (
        _airLock > 0
        || {_irLock > 0}
        || {_laserLock > 0}
        || {(_ammoText find "aa") >= 0}
        || {(_ammoText find "sam") >= 0}
    ) then {
        _antiAirScore = _antiAirScore + 120;
    };

    if (
        _artilleryScanner > 0
        || {_indirectRange >= 12 && {_indirectHit >= 20}}
        || {(_ammoText find "mortar") >= 0}
        || {(_ammoText find "artillery") >= 0}
        || {(_ammoText find "howitzer") >= 0}
    ) then {
        _artilleryScore = _artilleryScore + ((_indirectPower min 500) max 150);
    };
} forEach _magazines;

private _threatScore = ((_softThreat min 1) * 350) + ((_armorThreat min 1) * 750) + ((_airThreat min 1) * 850);

if (_combatWeaponCount > 0 && {_weaponPower <= 0}) then {
    _weaponPower = 120 + _threatScore;
};

private _maxThreat = (_softThreat max _armorThreat) max _airThreat;
private _hasWeapon = _combatWeaponCount > 0 || {_weaponPower > 0} || {
    _category isNotEqualTo "cars"
    && {_maxThreat >= 0.75}
};
private _hasAntiArmor = _antiArmorScore > 0 || {_hasWeapon && {_armorThreat >= 0.55}};
private _hasAntiAir = _antiAirScore > 0 || {_hasWeapon && {_airThreat >= 0.55}};
private _hasArtillery = _artilleryScanner > 0 || {_artilleryScore > 0} || {(_searchText find "mortar") >= 0} || {(_searchText find "artillery") >= 0} || {(_searchText find "howitzer") >= 0};
private _hasLogistics = _transportAmmo > 0 || {_transportFuel > 0} || {_transportRepair > 0} || {_aceAmmo > 0} || {_aceFuel > 0} || {_aceRepair > 0};
private _hasSensors = _radar > 0 || {_irScan > 0} || {_laserScanner > 0} || {_lockDetection > 0} || {_incomingMissileDetection > 0};
private _isMbt = _category isEqualTo "armor" && {
    _armor >= 650
    || {(_searchText find "mbt") >= 0}
    || {(_searchText find "tank") >= 0}
};
private _isIfv = _category isEqualTo "armor" && {
    !_isMbt
    && {_hasWeapon}
    && {(_cannonScore > 0) || {_hasAntiArmor}}
};
private _isApc = _category isEqualTo "armor" && {
    !_isMbt
    && {!_isIfv}
    && {_transport >= 4}
};

createHashMapFromArray [
    ["transport", _transport],
    ["cargo", _cargo],
    ["armor", _armor],
    ["slingMass", _slingMass],
    ["transportAmmo", _transportAmmo],
    ["transportFuel", _transportFuel],
    ["transportRepair", _transportRepair],
    ["aceAmmo", _aceAmmo],
    ["aceFuel", _aceFuel],
    ["aceRepair", _aceRepair],
    ["combatWeaponCount", _combatWeaponCount],
    ["weaponPower", _weaponPower],
    ["antiArmorScore", _antiArmorScore],
    ["antiAirScore", _antiAirScore],
    ["artilleryScore", _artilleryScore],
    ["cannonScore", _cannonScore],
    ["machineGunScore", _machineGunScore],
    ["directHitMax", _directHitMax],
    ["indirectPowerMax", _indirectPowerMax],
    ["threatScore", _threatScore],
    ["hasWeapon", _hasWeapon],
    ["hasAntiArmor", _hasAntiArmor],
    ["hasAntiAir", _hasAntiAir],
    ["hasArtillery", _hasArtillery],
    ["hasLogistics", _hasLogistics],
    ["hasSensors", _hasSensors],
    ["isMbt", _isMbt],
    ["isIfv", _isIfv],
    ["isApc", _isApc],
    ["isUav", _isUav > 0]
]
