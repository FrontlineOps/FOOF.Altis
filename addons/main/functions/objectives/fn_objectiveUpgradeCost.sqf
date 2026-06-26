params ["_objective", ["_inPerson", false, [false]]];

private _level = floor (_objective get "level");

if (_level >= FLO_ObjectiveMaxLevel) exitWith { 0 };

private _nextLevel = _level + 1;
private _weight = _objective get "resourceWeight";
private _cost = _nextLevel * _weight * FLO_ObjectiveUpgradeCostPerWeightLevel;

if (_inPerson) then {
    _cost = _cost * FLO_ObjectiveInPersonUpgradeCostMultiplier;
};

ceil (_cost / 100) * 100
