package io.kokleeko.wordclock;

import android.content.Context;
import android.content.Intent;
import android.database.ContentObserver;
import android.net.Uri;
import android.provider.Settings;

public class DeviceAccess {
  public DeviceAccess() {}

  static Context context;
  static ContentObserver contentObserver = new ContentObserver(null)
  {
      @Override
      public void onChange(boolean selfChange)
      {
           getBrightness();
      }
  };

  public static void getBrightness()
  {
      int brightnessLevel = Settings.System.getInt(context.getContentResolver(),
                                                   Settings.System.SCREEN_BRIGHTNESS,0);
      updateBrightness(brightnessLevel);
  }

  private static native void updateBrightness(int value);
  public static void registerListeners(Context appContext)
  {
      context = appContext;
      context.getContentResolver().registerContentObserver(
                                      Settings.System.getUriFor(Settings.System.SCREEN_BRIGHTNESS),
                                      false,
                                      contentObserver);
  }

  public static void setBrightness(int brightness)
  {
      if (Settings.System.canWrite(context)) {
          Settings.System.putInt(
              context.getContentResolver(),
              Settings.System.SCREEN_BRIGHTNESS_MODE,
              Settings.System.SCREEN_BRIGHTNESS_MODE_MANUAL);
          Settings.System.putInt(context.getContentResolver(),
                                 Settings.System.SCREEN_BRIGHTNESS,
                                 brightness);
      } else {
          openAndroidPermissionsMenu();
      }
  }

  private static void openAndroidPermissionsMenu()
  {
      Intent intent = new Intent(Settings.ACTION_MANAGE_WRITE_SETTINGS);
      intent.setData(Uri.parse("package:" + context.getPackageName()));
      context.startActivity(intent);
  }
}










