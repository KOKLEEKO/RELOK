package io.kokleeko.wordclock;

import android.content.Context;
import android.content.res.Configuration;
import android.graphics.RectF;
import android.media.AudioAttributes;
import android.media.AudioFocusRequest;
import android.media.AudioManager;
import android.os.Build;
import android.os.Bundle;
import android.util.Log;
import android.view.DisplayCutout;
import android.view.Window;
import android.view.WindowManager;
import com.google.android.play.core.review.ReviewInfo;
import com.google.android.play.core.review.ReviewManager;
import com.google.android.play.core.review.ReviewManagerFactory;
import org.qtproject.qt5.android.bindings.QtActivity;

public class MyActivity extends QtActivity
{
    private static final String TAG = "MyActivity";
    private static AudioManager audioManager;
    private static AudioFocusRequest audioFocusRequest;
    private static ReviewManager reviewManager;

    @Override
    public void onCreate(Bundle savedInstanceState) {
      super.onCreate(savedInstanceState);
      setCustomStatusAndNavBar();
      initAudioManager();
      reviewManager = ReviewManagerFactory.create(this);
    }

    void setCustomStatusAndNavBar() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) { // Kikat: API 19
            Window window = getWindow();
            window.addFlags(WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS);
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) // Pie: API 28
                window.getAttributes().layoutInDisplayCutoutMode = WindowManager.LayoutParams.LAYOUT_IN_DISPLAY_CUTOUT_MODE_SHORT_EDGES;
        }
    }

    void initAudioManager() {
        audioManager = (AudioManager) getSystemService(Context.AUDIO_SERVICE);

        AudioAttributes playbackAttributes = new AudioAttributes.Builder()
                .setUsage(AudioAttributes.USAGE_MEDIA)
                .setContentType(AudioAttributes.CONTENT_TYPE_SPEECH)
                .build();
        audioFocusRequest = new AudioFocusRequest.Builder(AudioManager.AUDIOFOCUS_GAIN_TRANSIENT_MAY_DUCK)
                .setAudioAttributes(playbackAttributes)
                .build();
        }

    public void requestAudioFocus() {
        audioManager.requestAudioFocus(audioFocusRequest);
    }

    public void abandonAudioFocus() {
        audioManager.abandonAudioFocusRequest(audioFocusRequest);
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
        Log.i(TAG, "safeAreaInsets(L,T,R,B) : " + safeAreaInsets);
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

    public void requestReview() {
        reviewManager.requestReviewFlow();
    }
}
