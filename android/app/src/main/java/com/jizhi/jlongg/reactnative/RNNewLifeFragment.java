package com.jizhi.jlongg.reactnative;


import android.os.Bundle;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import javax.annotation.Nullable;

public class RNNewLifeFragment extends ReactFragment {


    @Override
    public void initFragmentData() {

    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        SplashScreen.show(getActivity());  // here
        return super.onCreateView(inflater, container, savedInstanceState);
    }
    @Override
    protected String getMainPageName() {
        return "find";

    }

    /**
     *  返回键监听
     * @param keyCode
     * @param event
     * @return
     */
    public boolean onKeyUp(int keyCode, KeyEvent event) {
        if (mReactInstanceManager != null) {
            switch (keyCode) {
                //...
                case KeyEvent.KEYCODE_BACK: {
                    mReactInstanceManager.onBackPressed();
                    return true;
                }
            }
        }
        return false;
    }
}
