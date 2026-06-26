#define FLO_OBJECTIVE_AREA_CT_WEBBROWSER 106

class RscMapControl;

class FLO_ObjectiveAreaDialog {
    idd = 9500;
    movingEnable = 0;
    enableSimulation = 1;
    onUnload = "uiNamespace setVariable ['FLO_ObjectiveAreaControl', controlNull]; uiNamespace setVariable ['FLO_ObjectiveAreaMapControl', controlNull]; FLO_ObjectiveAreaBrowserReady = false; FLO_ObjectiveAreaHoverId = ''";

    class Controls {
        class Map: RscMapControl {
            idc = 9502;
            x = "safeZoneX + (safeZoneW * 0.47)";
            y = "safeZoneY + (safeZoneH * 0.14)";
            w = "safeZoneW * 0.45";
            h = "safeZoneH * 0.62";
            colorBackground[] = {0.01, 0.02, 0.03, 0.92};
        };

        class Browser: RscText {
            idc = 9501;
            type = FLO_OBJECTIVE_AREA_CT_WEBBROWSER;
            style = 0;
            x = "safeZoneX + (safeZoneW * 0.08)";
            y = "safeZoneY + (safeZoneH * 0.14)";
            w = "safeZoneW * 0.38";
            h = "safeZoneH * 0.62";
            colorBackground[] = {0, 0, 0, 0};
        };
    };
};
