params ["_cfg"];

if !(isClass _cfg) exitWith { false };

private _sourceMod = toLower configSourceMod _cfg;

if (_sourceMod in ["a3", "arma3", "arma 3"]) exitWith { true };

(configSourceAddonList _cfg findIf {
    ((toLower _x) find "a3_") isEqualTo 0
}) >= 0
