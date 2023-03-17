package io.kokleeko.wordclock;

import android.content.res.Configuration;
import android.graphics.Color;
import android.os.Build;
import android.os.Bundle;
import android.util.Log;
import android.view.DisplayCutout;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.graphics.RectF;
import org.qtproject.qt5.android.bindings.QtActivity;

public class MyActivity extends QtActivity
{
    private static final String TAG = "MyActivity";

    @Override
    public void onCreate(Bundle savedInstanceState) {
      super.onCreate(savedInstanceState);
      setCustomStatusAndNavBar();
    }

    void setCustomStatusAndNavBar() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) { // Lollipop: API 21
            Window window = getWindow();
            window.addFlags( WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS
                           | WindowManager.LayoutParams.FLAG_TRANSLUCENT_NAVIGATION
                           | WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS);
            window.getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN);
            //window.setStatusBarColor(Color.BLACK);
            //window.setNavigationBarColor(Color.BLACK);
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) // Pie: API 28
                window.getAttributes().layoutInDisplayCutoutMode = WindowManager.LayoutParams.LAYOUT_IN_DISPLAY_CUTOUT_MODE_SHORT_EDGES;
        }
    }

    public RectF safeAreaInsets() {
        final RectF safeAreaInsets = new RectF();
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
            DisplayCutout cutout = getWindow().getDecorView().getRootWindowInsets().getDisplayCutout();
            if (cutout != null) {
                safeAreaInsets.bottom = cutout.getSafeInsetBottom();
                safeAreaInsets.left = cutout.getSafeInsetLeft();
                safeAreaInsets.right = cutout.getSafeInsetRight();
                safeAreaInsets.top = cutout.getSafeInsetTop();
            }
        }
        Log.i(TAG, "safeAreaInsets: " + safeAreaInsets);
        return safeAreaInsets;
    }

    private static native void configurationChanged();

    @Override
    public void onConfigurationChanged(Configuration newConfig) {
        super.onConfigurationChanged(newConfig);
        configurationChanged();
    }

    public double statusBarHeight() {
        double result = 0;
        int resourceId = getResources().getIdentifier("status_bar_height", "dimen", "android");
        if (resourceId > 0) {
            result = getResources().getDimension(resourceId);
        }

        Log.i(TAG, "statusBarHeight: " + result);
        return result;
    }

    public double navigationBarHeight() {
        double result = 0;
        int resourceId = getResources().getIdentifier("navigation_bar_height", "dimen", "android");
        if (resourceId > 0) {
            result = getResources().getDimension(resourceId);
        }
        Log.i(TAG, "navigationBarHeight: " + result);
        return result;
    }
}
