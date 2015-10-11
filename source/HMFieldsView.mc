using Toybox.WatchUi as Ui;
using Toybox.Graphics;
using Toybox.System as Sys;

class HMFieldsView extends Ui.DataField {
    hidden var fields;

    function initialize() {
        fields = new HMFields();
    }

    function onLayout(dc) {
    }

    function onShow() {
    }

    function onHide() {
    }

    function drawLayout(dc) {
        dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_WHITE);
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

        textL(dc, 36, 45, Graphics.FONT_NUMBER_MEDIUM,  fields.half);
        if (fields.halfSecs != null) {
            var length = dc.getTextWidthInPixels(fields.half, Graphics.FONT_NUMBER_MEDIUM);
            textL(dc, 36 + length + 1, 55, Graphics.FONT_NUMBER_MILD, fields.halfSecs);
        }
        textL(dc, 55, 18, Graphics.FONT_XTINY, "HALF");

        textL(dc, 112, 45, Graphics.FONT_NUMBER_MEDIUM,  fields.timer);
        if (fields.timerSecs != null) {
            var length = dc.getTextWidthInPixels(fields.timer, Graphics.FONT_NUMBER_MEDIUM);
            textL(dc, 112 + length + 1, 55, Graphics.FONT_NUMBER_MILD, fields.timerSecs);
        }

        textL(dc, 120, 18, Graphics.FONT_XTINY,  "TIMER");

        doCadenceBackground(dc, fields.cadenceN);
        textC(dc, 30, 107, Graphics.FONT_NUMBER_MEDIUM, fields.cadence);
        textC(dc, 30, 79, Graphics.FONT_XTINY,  "CAD");

        textC(dc, 110, 107, Graphics.FONT_NUMBER_MEDIUM, fields.pace10s);
        textL(dc, 78, 79, Graphics.FONT_XTINY,  "PACE 10s");

        doHrBackground(dc, fields.hrN);
        textC(dc, 180, 107, Graphics.FONT_NUMBER_MEDIUM, fields.hr);
        textC(dc, 180, 79, Graphics.FONT_XTINY,  "HR");


        textC(dc, 66, 154, Graphics.FONT_NUMBER_MEDIUM, fields.dist);
        textL(dc, 54, 186, Graphics.FONT_XTINY, "DIST");

        textC(dc, 150, 154, Graphics.FONT_NUMBER_MEDIUM, fields.paceAvg);
        textL(dc, 124, 186, Graphics.FONT_XTINY, "A PACE");

        textL(dc, 75, 206, Graphics.FONT_TINY, fields.time);
        drawBattery(dc);
        drawLayout(dc);
        return true;
    }

    function doHrBackground(dc, hr) {
        if (hr == null) {
            return;
        }

        var color;
        if (hr >= 186) {
            color = Graphics.COLOR_PURPLE;
        } else if (hr > 177) {
            color = Graphics.COLOR_RED;
        } else if (hr > 165) {
            color = Graphics.COLOR_ORANGE;
        } else if (hr > 149) {
            color = Graphics.COLOR_YELLOW;
        } else if (hr > 116) {
            color = Graphics.COLOR_GREEN;
        } else {
            color = Graphics.COLOR_BLUE;
        }

        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        dc.fillRectangle(154, 72, 65, 16);
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
    }

    function doCadenceBackground(dc, cadence) {
        if (cadence == null) {
            return;
        }

        var color;
        if (cadence > 183) {
            color = Graphics.COLOR_PURPLE;
        } else if (cadence >= 174) {
            color = Graphics.COLOR_BLUE;
        } else if (cadence >= 164) {
            color = Graphics.COLOR_GREEN;
        } else if (cadence >= 153) {
            color = Graphics.COLOR_ORANGE;
        } else {
            color = Graphics.COLOR_RED;
        }
        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        dc.fillRectangle(00, 72, 65, 16);
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
    }

    function drawBattery(dc) {
        var pct = Sys.getSystemStats().battery;
        dc.drawRectangle(120, 202, 18, 11);
        dc.fillRectangle(138, 205, 2, 5);

        var color = Graphics.COLOR_GREEN;
        if (pct < 25) {
            color = Graphics.COLOR_RED;
        } else if (pct < 40) {
            color = Graphics.COLOR_YELLOW;
        }
        dc.setColor(color, Graphics.COLOR_TRANSPARENT);

        var width = (pct * 16.0 / 100 + 0.5).toLong();
        if (width > 0) {
            //Sys.println("" + pct + "=" + width);
            if (width > 16) {
                width = 16;
            }
            dc.fillRectangle(121, 203, width, 9);
        }
    }

    function compute(info) {
        fields.compute(info);
        return 1;
    }

    function textL(dc, x, y, font, s) {
        if (s != null) {
            dc.drawText(x, y, font, s, Graphics.TEXT_JUSTIFY_LEFT|Graphics.TEXT_JUSTIFY_VCENTER);
        }
    }

    function textC(dc, x, y, font, s) {
        if (s != null) {
            dc.drawText(x, y, font, s, Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
        }
    }

    function textR(dc, x, y, font, s) {
        if (s != null) {
            dc.drawText(x, y, font, s, Graphics.TEXT_JUSTIFY_RIGHT|Graphics.TEXT_JUSTIFY_VCENTER);
        }
    }
}
