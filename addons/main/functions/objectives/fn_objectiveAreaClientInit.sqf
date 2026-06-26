if (!hasInterface) exitWith {};

FLO_ObjectiveAreaNearbyId = "";

FLO_ObjectiveAreaClientHandle = [
    {
        if ((isNull player) || {!alive player}) exitWith {
            FLO_ObjectiveAreaActiveId = "";
            FLO_ObjectiveAreaNearbyId = "";

            private _display = findDisplay FLO_ObjectiveAreaDialogIdd;
            if (!isNull _display) then {
                _display closeDisplay 0;
            };
        };

        private _playerSide = side group player;

        if !(_playerSide in [west, east]) exitWith {
            FLO_ObjectiveAreaActiveId = "";
            FLO_ObjectiveAreaNearbyId = "";

            private _display = findDisplay FLO_ObjectiveAreaDialogIdd;
            if (!isNull _display) then {
                _display closeDisplay 0;
            };
        };

        private _nearestId = [] call FLO_fnc_objectiveNearestAreaId;
        FLO_ObjectiveAreaNearbyId = _nearestId;

        if ((FLO_ObjectiveAreaActiveId isEqualTo "") && {_nearestId isNotEqualTo ""}) then {
            FLO_ObjectiveAreaActiveId = _nearestId;
        };

        if (!isNull (findDisplay FLO_ObjectiveAreaDialogIdd)) then {
            [] call FLO_fnc_objectiveUpdateAreaDialog;
        };
    },
    2,
    []
] call CBA_fnc_addPerFrameHandler;
