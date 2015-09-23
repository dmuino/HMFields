using Toybox.WatchUi as Ui;
using Toybox.Graphics;
using Toybox.System as Sys;

class HMFieldsView extends Ui.DataField {
    var fields;
    var model;
       function initialize() {
        fields = new HMFields();
        model = { "battery" => "0%" };
    }
        
    function onLayout(dc) {
    }

    function onShow() {
    }

    function onHide() {
    }

    function drawLayout(dc) {
        dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_WHITE);
        // horizontal lines
        dc.drawLine(0, 71, 218, 71);
        dc.drawLine(0, 132, 218, 132);
        dc.drawLine(0, 198, 218, 198);
        // vertical lines
        dc.drawLine(109, 0, 109, 71);
        dc.drawLine(65, 71, 65, 132);
        dc.drawLine(153, 71, 153, 132);
        dc.drawLine(109, 132, 109, 198);
    }

    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
        dc.clear();

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        text(dc, 36, 45, Graphics.FONT_NUMBER_MEDIUM,  model["half"]);
        if (model["halfSecs"] != null) {
            var length = dc.getTextWidthInPixels(model["half"], Graphics.FONT_NUMBER_MEDIUM);
            text(dc, 36 + length + 1, 55, Graphics.FONT_NUMBER_MILD, model["halfSecs"]);
        }
        text(dc, 55, 18, Graphics.FONT_XTINY, "HALF");
        
        text(dc, 112, 45, Graphics.FONT_NUMBER_MEDIUM,  model["timer"]);        
        if (model["timerSecs"] != null) {
            var length = dc.getTextWidthInPixels(model["timer"], Graphics.FONT_NUMBER_MEDIUM);
            text(dc, 112 + length + 1, 55, Graphics.FONT_NUMBER_MILD, model["timerSecs"]);
        }
        
        text(dc, 120, 18, Graphics.FONT_XTINY,  "TIMER");
        
        text(dc, 6, 107, Graphics.FONT_NUMBER_MEDIUM, model["cadence"]);
        text(dc, 16, 79, Graphics.FONT_XTINY,  "CAD");
        
        textC(dc, 110, 107, Graphics.FONT_NUMBER_MEDIUM, model["pace10s"]);
        text(dc, 78, 79, Graphics.FONT_XTINY,  "PACE 10s");
        
        text(dc, 159, 107, Graphics.FONT_NUMBER_MEDIUM, model["hr"]);
        text(dc, 174, 79, Graphics.FONT_XTINY,  "HR");
        
        textC(dc, 66, 154, Graphics.FONT_NUMBER_MEDIUM, model["dist"]);
        text(dc, 54, 186, Graphics.FONT_XTINY, "DIST");
        
        textC(dc, 150, 154, Graphics.FONT_NUMBER_MEDIUM, model["paceAvg"]);
        text(dc, 124, 186, Graphics.FONT_XTINY, "A PACE");
        
        text(dc, 100, 206, Graphics.FONT_XTINY, model["battery"]);

        drawLayout(dc);
        return true;
    }

    function compute(info) {
        model = fields.compute(info);     
        return 1;
    }

    function text(dc, x, y, font, s) {
        if (s != null) {
            dc.drawText(x, y, font, s, Graphics.TEXT_JUSTIFY_LEFT|Graphics.TEXT_JUSTIFY_VCENTER);
        }
    }

    function textC(dc, x, y, font, s) {
        if (s != null) {
            dc.drawText(x, y, font, s, Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
        }
    }

}
