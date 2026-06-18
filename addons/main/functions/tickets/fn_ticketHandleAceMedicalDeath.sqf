params ["_unit", "_uid", "_sideKey"];

if (!isServer) exitWith {};
if (isNull _unit) exitWith {};
if (_uid isEqualTo "") exitWith {};

private _unitUid = getPlayerUID _unit;

if ((_unitUid isNotEqualTo "") && {_unitUid isNotEqualTo _uid}) exitWith {
    diag_log format [
        "[FLO][Tickets] Rejected ACE medical death for uid=%1 unitUid=%2 unit=%3",
        _uid,
        _unitUid,
        _unit
    ];
};

if (_sideKey in ["WEST", "EAST"]) then {
    _unit setVariable ["FLO_TicketPlayerUid", _uid, true];
    _unit setVariable ["FLO_TicketSideKey", _sideKey, true];
    FLO_TicketPlayerSides set [_uid, _sideKey];
};

if (_sideKey isEqualTo "") then {
    _sideKey = _unit getVariable ["FLO_TicketSideKey", ""];
};

if ((_sideKey isEqualTo "") && {_uid in FLO_TicketPlayerSides}) then {
    _sideKey = FLO_TicketPlayerSides get _uid;
};

private _side = switch (_sideKey) do {
    case "WEST": { west };
    case "EAST": { east };
    default { sideUnknown };
};

if !(_side in [west, east]) exitWith {
    diag_log format [
        "[FLO][Tickets] ACE medical death ignored: unresolved side uid=%1 sideKey=%2 unit=%3",
        _uid,
        _sideKey,
        _unit
    ];
};

if (_unit getVariable ["FLO_TicketDeathHandled", false]) exitWith {
    diag_log format [
        "[FLO][Tickets] ACE medical death ignored: already handled uid=%1 side=%2 unit=%3 deathState=%4",
        _uid,
        _sideKey,
        _unit,
        _uid in FLO_TicketDeathStates
    ];
};

if (_uid in FLO_TicketDeathStates) exitWith {
    _unit setVariable ["FLO_TicketDeathHandled", true];
    diag_log format [
        "[FLO][Tickets] ACE medical death ignored: death state already exists uid=%1 side=%2 unit=%3",
        _uid,
        _sideKey,
        _unit
    ];
};

_unit setVariable ["FLO_TicketDeathHandled", true];

private _state = "charged";
private _locked = false;
private _message = "";

FLO_PersistencePlayerRecords deleteAt _uid;

if !([_side, FLO_TicketRespawnCost, format ["ace medical death %1", _uid]] call FLO_fnc_ticketConsume) then {
    _state = "denied";
    _locked = true;
    _message = format ["%1 has no respawn tickets.", _sideKey];
    [_side, true, "No respawn tickets remain. Hold until command buys reinforcements."] call FLO_fnc_ticketBroadcastRespawnLock;
} else {
    private _balance = [_side] call FLO_fnc_ticketSideBalance;
    _locked = _balance <= 0;
    _message = if (_locked) then {
        "Respawn ticket consumed. No tickets remain."
    } else {
        format ["Respawn ticket consumed. %1 tickets remain.", _balance]
    };
};

FLO_TicketDeathStates set [
    _uid,
    createHashMapFromArray [
        ["sideKey", _sideKey],
        ["state", _state],
        ["locked", _locked],
        ["message", _message],
        ["unitNetId", netId _unit]
    ]
];

_unit setVariable ["FLO_TicketDeathState", _state];
_unit setVariable ["FLO_TicketDeathSideKey", _sideKey];

[_unit, _locked, _message] call FLO_fnc_ticketSyncPlayer;
["playerAceMedicalDeathTicket"] call FLO_fnc_persistenceScheduleSave;
