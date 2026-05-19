import Toybox.Lang;
import Toybox.WatchUi;

class JumpLoggerDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenu() as Boolean {
        WatchUi.pushView(new Rez.Menus.MainMenu(), new JumpLoggerMenuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }

}