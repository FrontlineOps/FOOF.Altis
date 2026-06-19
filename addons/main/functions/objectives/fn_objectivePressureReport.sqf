params [
    "_objective",
    "_event",
    ["_attackerSide", sideUnknown, [sideUnknown]]
];

private _name = _objective get "name";
private _owner = _objective get "owner";
private _windowMinutes = ceil (FLO_ObjectivePressureVulnerableDuration / 60);
private _defenderPayload = createHashMap;
private _attackerPayload = createHashMap;

switch (_event) do {
    case "frontline": {
        if (_owner in [west, east]) then {
            _defenderPayload = createHashMapFromArray [
                ["mode", "notify"],
                ["title", "AO"],
                ["message", format ["%1 is now a Frontline AO. Enemy pressure can make it Vulnerable.", _name]],
                ["type", "info"],
                ["duration", 8]
            ];
            [_owner, _defenderPayload] call FLO_fnc_notificationSendSide;

            private _enemySide = [east, west] select (_owner isEqualTo east);
            _attackerPayload = createHashMapFromArray [
                ["mode", "notify"],
                ["title", "AO"],
                ["message", format ["%1 is now a Frontline AO. Build pressure there to make it Vulnerable.", _name]],
                ["type", "info"],
                ["duration", 8]
            ];
            [_enemySide, _attackerPayload] call FLO_fnc_notificationSendSide;
        };
    };
    case "vulnerable": {
        if ((_owner in [west, east]) && {_attackerSide in [west, east]}) then {
            _defenderPayload = createHashMapFromArray [
                ["mode", "announce"],
                ["title", "Command"],
                ["message", format ["%1 is Vulnerable for %2 minutes. Enemy assault window is open; reinforce immediately.", _name, _windowMinutes]],
                ["type", "warning"],
                ["duration", 8]
            ];
            [_owner, _defenderPayload] call FLO_fnc_notificationSendSide;

            _attackerPayload = createHashMapFromArray [
                ["mode", "announce"],
                ["title", "Command"],
                ["message", format ["%1 is Vulnerable for %2 minutes. Assault window is open.", _name, _windowMinutes]],
                ["type", "announcement"],
                ["duration", 8]
            ];
            [_attackerSide, _attackerPayload] call FLO_fnc_notificationSendSide;
        };
    };
    case "windowClosed": {
        if ((_owner in [west, east]) && {_attackerSide in [west, east]}) then {
            _defenderPayload = createHashMapFromArray [
                ["mode", "notify"],
                ["title", "AO"],
                ["message", format ["%1 is no longer Vulnerable. Assault window closed.", _name]],
                ["type", "success"],
                ["duration", 6]
            ];
            [_owner, _defenderPayload] call FLO_fnc_notificationSendSide;

            _attackerPayload = createHashMapFromArray [
                ["mode", "notify"],
                ["title", "Command"],
                ["message", format ["%1 is no longer Vulnerable. Assault window closed.", _name]],
                ["type", "warning"],
                ["duration", 6]
            ];
            [_attackerSide, _attackerPayload] call FLO_fnc_notificationSendSide;
        };
    };
};
