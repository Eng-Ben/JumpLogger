import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Sensor;
import Toybox.Math;

class JumpLoggerView extends WatchUi.View {

    var accelX = 0.0;
    var accelY = 0.0;
    var accelZ = 0.0;
    var accelMag = 0.0;

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

            WatchUi.requestUpdate();
        }
    }
    

    function onUpdate(dc as Dc) as Void {
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();

        dc.drawText(dc.getWidth() / 2, 40, Graphics.FONT_MEDIUM, "Jump Logger", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(20, 100, Graphics.FONT_SMALL, "X: " + accelX, Graphics.TEXT_JUSTIFY_LEFT);
        dc.drawText(20, 140, Graphics.FONT_SMALL, "Y: " + accelY, Graphics.TEXT_JUSTIFY_LEFT);
        dc.drawText(20, 180, Graphics.FONT_SMALL, "Z: " + accelZ, Graphics.TEXT_JUSTIFY_LEFT);
        dc.drawText(20, 220, Graphics.FONT_SMALL, "MAG: " + accelMag, Graphics.TEXT_JUSTIFY_LEFT);
    }


}