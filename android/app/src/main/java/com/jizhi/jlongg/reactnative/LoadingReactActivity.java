package com.jizhi.jlongg.reactnative;


import android.os.Bundle;

import com.facebook.react.ReactActivity;
import com.facebook.react.ReactActivityDelegate;
import com.facebook.react.ReactInstanceManager;
import com.facebook.react.ReactRootView;
import com.jizhi.jlongg.R;
import com.swmansion.gesturehandler.react.RNGestureHandlerEnabledRootView;

public class LoadingReactActivity extends ReactActivity {

    //RN管理器
    private ReactInstanceManager mReactInstanceManager;

    @Override
    protected String getMainComponentName() {
        return "job";//此处容器名要与index.android.js里面注册的控件名一致
    }

    @Override
    protected ReactActivityDelegate createReactActivityDelegate() {
        return new ReactActivityDelegate(this, getMainComponentName()) {
            @Override
            protected ReactRootView createRootView() {
                return new RNGestureHandlerEnabledRootView(LoadingReactActivity.this);
            }
        };
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        SplashScreen.show(LoadingReactActivity.this);  // here
//        setContentView(R.layout.activity_loading);

    }

    @Override
    protected void onPause() {
        super.onPause();
        if (mReactInstanceManager != null) {
            mReactInstanceManager.onHostPause(this);
        }
    }

    @Override
    protected void onResume() {
        super.onResume();
        if (mReactInstanceManager != null) {
            mReactInstanceManager.onHostResume(this, this);
        }
    }

}