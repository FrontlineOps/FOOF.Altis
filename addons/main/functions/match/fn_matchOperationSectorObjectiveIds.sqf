params ["_position", "_radius"];

private _ids = [];

if (!(_position isEqualType []) || {(count _position) < 2} || {_radius <= 0}) exitWith { _ids };

{
    private _objective = FLO_Objectives get _x;

    if (((_objective get "position") distance2D _position) <= _radius) then {
        _ids pushBack _x;
    };
} forEach (keys FLO_Objectives);

_ids sort true;
_ids
