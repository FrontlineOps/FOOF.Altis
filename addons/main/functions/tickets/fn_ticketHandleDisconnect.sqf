params ["_unit", "_id", "_uid", "_name"];

if (!isServer) exitWith {};

if ((_uid isEqualTo "") && {!isNull _unit}) then {
    _uid = _unit getVariable ["FLO_TicketPlayerUid", ""];
};

if (_uid isEqualTo "") exitWith {};

private _alreadyMarked = _uid in FLO_TicketDisconnectedPlayers;
FLO_TicketDisconnectedPlayers set [_uid, true];

if (!isNull _unit) then {
    _unit setVariable ["FLO_TicketDisconnecting", true];
    _unit setVariable ["FLO_TicketDeathHandled", true];

    if ((_unit getVariable ["FLO_TicketPlayerUid", ""]) isEqualTo "") then {
        _unit setVariable ["FLO_TicketPlayerUid", _uid, true];
    };

    private _side = side group _unit;

    if (_side in [west, east]) then {
        private _sideKey = [_side] call FLO_fnc_resourceSideKey;
        FLO_TicketPlayerSides set [_uid, _sideKey];
        _unit setVariable ["FLO_TicketSideKey", _sideKey, true];
    };
};

if (!_alreadyMarked) then {
    diag_log format [
        "[FLO][Tickets] Marked disconnected player uid=%1 name=%2 id=%3 unit=%4",
        _uid,
        _name,
        _id,
        _unit
    ];
};
