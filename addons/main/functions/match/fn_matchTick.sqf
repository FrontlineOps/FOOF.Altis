if (!isServer) exitWith {};

private _now = diag_tickTime;
private _phase = FLO_MatchState get "phase";

if (_now >= (FLO_MatchState get "phaseEndsAt")) exitWith {
    switch (_phase) do {
        case "setup": {
            ["frontline", FLO_MatchFrontlineDuration] call FLO_fnc_matchStartPhase;
        };
        case "frontline": {
            [] call FLO_fnc_matchStartOperation;
        };
        case "operation": {
            [] call FLO_fnc_matchFinalizeCampaignDay;
        };
        default {
            ["setup", FLO_MatchSetupDuration] call FLO_fnc_matchStartPhase;
        };
    };
};

if (_phase isEqualTo "frontline") then {
    if ((FLO_MatchState get "plannedObjectiveId") isEqualTo "") then {
        if ([] call FLO_fnc_matchUpdateFrontlineSelection) then {
            [0] call FLO_fnc_matchSendSnapshot;
        };
    };
};

if (_phase isEqualTo "operation") then {
    [] call FLO_fnc_matchAccrueSectorPresence;
};

if ((_now - FLO_MatchLastSnapshotAt) >= FLO_MatchSnapshotHeartbeat) then {
    [0] call FLO_fnc_matchSendSnapshot;
};
