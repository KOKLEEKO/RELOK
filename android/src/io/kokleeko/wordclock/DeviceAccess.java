package io.kokleeko.wordclock;

import android.provider.Settings;
import android.content.Context;

public class DeviceAccess {
  public DeviceAccess() {}

  public static void setBrightness(Context context, int brightness)
      {
          System.out.println("This is printed from JAVA, message is: " + brightness);
          Settings.System.putInt(context.getContentResolver(),
                Settings.System.SCREEN_BRIGHTNESS, brightness);
      }
}










