params ["_factionClass"];

private _cfg = configFile >> "CfgFactionClasses" >> _factionClass;

if ([_cfg] call FLO_fnc_storeIsVanillaConfig) exitWith { true };

private _lower = toLower _factionClass;

_lower in [
    "blu_f",
    "blu_t_f",
    "blu_ctrg_f",
    "blu_gen_f",
    "blu_g_f",
    "opf_f",
    "opf_t_f",
    "opf_v_f",
    "opf_g_f",
    "ind_f",
    "ind_c_f",
    "ind_g_f",
    "civ_f"
]
