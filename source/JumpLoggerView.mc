import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Sensor;
import Toybox.Math;
import Toybox.System;

class JumpLoggerView extends WatchUi.View {

    var accelX = 0.0;
    var accelY = 0.0;
    var accelZ = 0.0;
    var accelMag = 0.0;

    var jumpThreshold = 1180.0;
    var restThreshold = 1080.0;
    var jumpCooldown = 1700;

    var jumpDetected = false;
    var isArmed = true;
    var lastJumpTime = 0;
    var jumpCount = 0;
    var maxMag = 0.0;

    function initialize() {
        View.initialize();
    }

    function onShow() as Void {
        Sensor.registerSensorDataListener(
            method(:onSensorData),
            {
                :period => 1,
                :accelerometer => {
                    :enabled => true,
                    :sampleRate => 25
                }
            }
        );
    }

    function onSensorData(data as Sensor.SensorData) as Void {
        var accel = data.accelerometerData;

        if (accel != null) {
            accelX = accel.x[0].toFloat();
            accelY = accel.y[0].toFloat();
            accelZ = accel.z[0].toFloat();

            var sum = (accelX * accelX) + (accelY * accelY) + (accelZ * accelZ);
            accelMag = Math.sqrt(sum);

            var currentTime = System.getTimer();

            if (accelMag < restThreshold) {
                isArmed = true;
            }

            if (isArmed && accelMag > jumpThreshold && (currentTime - lastJumpTime) > jumpCooldown) {
                jumpDetected = true;
                lastJumpTime = currentTime;
                jumpCount += 1;
                maxMag = accelMag;
                isArmed = false;
            } else {
                jumpDetected = false;
            }

            WatchUi.requestUpdate();
        }
    }

    function onUpdate(dc as Dc) as Void {
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();

        dc.drawText(dc.getWidth() / 2, 40, Graphics.FONT_SMALL, "Jump Logger", Graphics.TEXT_JUSTIFY_CENTER);

        dc.drawText(35, 95, Graphics.FONT_TINY, "MAG", Graphics.TEXT_JUSTIFY_LEFT);
        dc.drawText(135, 95, Graphics.FONT_TINY, accelMag.format("%.0f"), Graphics.TEXT_JUSTIFY_LEFT);

        dc.drawText(35, 145, Graphics.FONT_TINY, "JUMPS", Graphics.TEXT_JUSTIFY_LEFT);
        dc.drawText(135, 145, Graphics.FONT_TINY, jumpCount.toString(), Graphics.TEXT_JUSTIFY_LEFT);

        dc.drawText(35, 195, Graphics.FONT_TINY, "STATUS", Graphics.TEXT_JUSTIFY_LEFT);
        dc.drawText(135, 195, Graphics.FONT_TINY, jumpDetected ? "YES" : "NO", Graphics.TEXT_JUSTIFY_LEFT);
    }
}