params ["_control", "_isConfirmDialog", "_message"];

private _eventData = fromJSON _message;
private _event = _eventData get "event";

switch (_event) do {
    case "match::ready": {
        uiNamespace setVariable ["FLO_MatchControl", _control];
        FLO_MatchBrowserReady = true;
        [] call FLO_fnc_matchUpdateDialog;
    };
    case "match::refresh": {
        [player] remoteExecCall ["FLO_fnc_matchRequestSnapshot", 2];
    };
    case "match::close": {
        (ctrlParent _control) closeDisplay 0;
    };
    default {
        diag_log format ["[FLO][Match] Unhandled match UI event: %1", _event];
    };
};

true
