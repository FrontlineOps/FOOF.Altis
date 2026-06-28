#define FLO_MATCH_CT_WEBBROWSER 106

class FLO_MatchDialog {
    idd = 9400;
    movingEnable = 0;
    enableSimulation = 1;
    onUnload = "uiNamespace setVariable ['FLO_MatchControl', controlNull]; FLO_MatchBrowserReady = false";

    class Controls {
        class Browser: RscText {
            idc = 9401;
            type = FLO_MATCH_CT_WEBBROWSER;
            style = 0;
            x = "safeZoneX + (safeZoneW * 0.12)";
            y = "safeZoneY + (safeZoneH * 0.10)";
            w = "safeZoneW * 0.76";
            h = "safeZoneH * 0.78";
            colorBackground[] = {0, 0, 0, 0};
        };
    };
};
