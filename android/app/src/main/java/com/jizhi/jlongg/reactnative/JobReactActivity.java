package com.jizhi.jlongg.reactnative;


import android.os.Bundle;

import com.facebook.react.ReactActivity;
import com.facebook.react.ReactActivityDelegate;
import com.facebook.react.ReactInstanceManager;
import com.facebook.react.ReactRootView;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.swmansion.gesturehandler.react.RNGestureHandlerEnabledRootView;

public class JobReactActivity extends ReactActivity {

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
                return new RNGestureHandlerEnabledRootView(JobReactActivity.this);
            }
        };
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mReactInstanceManager = ((UclientApplication)getApplication()).getReactNativeHost().getReactInstanceManager();

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

    //
//    @Override
//    public void onBackPressed() {
////        LUtils.e("-------------------onBackPressed--------------------");
//        mReactInstanceManager =
//                ((UclientApplication) MyReactActivity.this.getApplication()).getReactNativeHost().getReactInstanceManager();
//        mReactInstanceManager.showDevOptionsDialog();
//
//    }
}