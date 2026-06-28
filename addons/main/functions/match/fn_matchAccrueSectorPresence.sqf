if (!isServer) exitWith {};
if ((FLO_MatchState get "phase") isNotEqualTo "operation") exitWith {};

private _position = FLO_MatchState get "operationSectorPosition";
private _radius = FLO_MatchState get "operationSectorRadius";

if (!(_position isEqualType []) || {(count _position) < 2} || {_radius <= 0}) exitWith {};

private _westCount = 0;
private _eastCount = 0;

{
    if (alive _x && {(_x distance2D _position) <= _radius}) then {
        private _side = side group _x;

        if (_side isEqualTo west) then {
            _westCount = _westCount + 1;
        };

        if (_side isEqualTo east) then {
            _eastCount = _eastCount + 1;
        };
    };
} forEach allPlayers;

private _scorePerTick = FLO_MatchSectorPresenceScorePerPlayerMinute * (FLO_MatchTickInterval / 60);

FLO_MatchState set ["operationWestSectorPresenceScore", (FLO_MatchState get "operationWestSectorPresenceScore") + (_westCount * _scorePerTick)];
FLO_MatchState set ["operationEastSectorPresenceScore", (FLO_MatchState get "operationEastSectorPresenceScore") + (_eastCount * _scorePerTick)];
FLO_MatchState set ["operationWestSectorPresenceTicks", (FLO_MatchState get "operationWestSectorPresenceTicks") + _westCount];
FLO_MatchState set ["operationEastSectorPresenceTicks", (FLO_MatchState get "operationEastSectorPresenceTicks") + _eastCount];
