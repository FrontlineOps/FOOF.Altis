params ["_phase"];

switch (_phase) do {
    case "setup": { "Setup" };
    case "frontline": { "Frontline Selection" };
    case "operation": { "Operation" };
    default { "Unknown" };
}
