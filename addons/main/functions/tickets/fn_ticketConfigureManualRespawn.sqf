params ["_display"];

if (!hasInterface) exitWith {};
if (isNull _display) exitWith {};
if (!alive player) exitWith {};

private _button = _display displayCtrl FLO_TicketManualRespawnButtonIdc;

if (isNull _button) exitWith {};
if (_button getVariable ["FLO_TicketManualRespawnConfigured", false]) exitWith {};

_button setVariable ["FLO_TicketManualRespawnConfigured", true];
_button ctrlSetTooltip "Manual respawn kills you and costs your side one ticket.";
_button buttonSetAction "[] call FLO_fnc_ticketConfirmManualRespawn";
