private _shortRangeChannel = [] call FLO_fnc_clientAcreGroupShortRangeChannel;
private _applied = false;

{
    private _radio = [_x] call acre_api_fnc_getRadioByType;
    if (!isNil "_radio" && {_radio isEqualType ""} && {_radio isNotEqualTo ""}) then {
        [_radio, _shortRangeChannel] call acre_api_fnc_setRadioChannel;
        _applied = true;
    };
} forEach ["ACRE_PRC343", "ACRE_BF888S"];

{
    private _radio = [_x] call acre_api_fnc_getRadioByType;
    if (!isNil "_radio" && {_radio isEqualType ""} && {_radio isNotEqualTo ""}) then {
        [_radio, 2] call acre_api_fnc_setRadioChannel;
        _applied = true;
    };
} forEach ["ACRE_PRC148", "ACRE_PRC152", "ACRE_PRC77", "ACRE_PRC117F", "ACRE_SEM52SL", "ACRE_SEM70"];

if (_applied) then {
    FLO_AcreLastGroup = group player;
    FLO_AcreLastShortRangeChannel = _shortRangeChannel;
};

_applied
