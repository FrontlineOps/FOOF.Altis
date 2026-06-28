params ["_side"];

private _value = 0;

{
    private _objective = FLO_Objectives get _x;

    if ((_objective get "owner") isEqualTo _side) then {
        _value = _value + (_objective get "resourceWeight");
    };
} forEach keys FLO_Objectives;

_value
