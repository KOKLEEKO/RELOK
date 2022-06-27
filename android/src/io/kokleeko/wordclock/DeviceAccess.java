package io.kokleeko.wordclock;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.database.ContentObserver;
import android.net.Uri;
import android.os.BatteryManager;
import android.provider.Settings;

public class DeviceAccess {
  public DeviceAccess() {}

  static Context context;
  static ContentObserver brightnessContentObserver = new ContentObserver(null)
  {
      @Override
      public void onChange(boolean selfChange)
      {
           getBrightness();
      }
  };
static BroadcastReceiver batteryReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive( Context context, Intent intent )
        {
          int status = intent.getIntExtra(BatteryManager.EXTRA_STATUS, -1);
          boolean isCharging = status == BatteryManager.BATTERY_STATUS_CHARGING ||
                               status == BatteryManager.BATTERY_STATUS_FULL;
          updateIsPlugged(isCharging);
          int level = intent.getIntExtra(BatteryManager.EXTRA_LEVEL, -1);
          int scale = intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1);
          float batteryLevel = level / (float)scale;
          updateBatteryLevel(batteryLevel);
        }
    };

  private static native void updateIsPlugged(boolean isPlugged);

  private static native void updateBatteryLevel(float batteryLevel);

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
                                      brightnessContentObserver);
      context.registerReceiver(batteryReceiver,  new IntentFilter(Intent.ACTION_BATTERY_CHANGED));
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










