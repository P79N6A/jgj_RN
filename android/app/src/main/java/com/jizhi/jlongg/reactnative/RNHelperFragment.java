package com.jizhi.jlongg.reactnative;


import android.os.Bundle;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.hcs.uclient.utils.LUtils;
import com.jizhi.jlongg.main.AppMainActivity;
import com.jizhi.jlongg.main.application.UclientApplication;

import javax.annotation.Nullable;


public class RNHelperFragment extends ReactFragment {

    @Override
    public void initFragmentData() {

    }

    @Override
    protected String getMainPageName() {
        return "job";

    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        SplashScreen.show(getActivity());  // here
        return super.onCreateView(inflater, container, savedInstanceState);
    }

    /**
     * 返回键监听
     *
     * @param keyCode
     * @param event
     * @return
     */
    public boolean onKeyUp(int keyCode, KeyEvent event) {
        if (mReactInstanceManager != null) {
            switch (keyCode) {
                case KeyEvent.KEYCODE_BACK: {
                    mReactInstanceManager.onBackPressed();
                    return true;
                }
            }
        }
        return false;
    }


    @Override
    public void onHiddenChanged(boolean hidden) {
        LUtils.e("--------onHiddenChanged---------onHiddenChanged----");
        super.onHiddenChanged(hidden);
        mReactInstanceManager.getCurrentReactContext().getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit("offSelect", "");
    }
}
