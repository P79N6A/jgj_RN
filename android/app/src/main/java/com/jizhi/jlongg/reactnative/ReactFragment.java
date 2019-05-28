package com.jizhi.jlongg.reactnative;

import android.content.Context;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.facebook.react.ReactInstanceManager;
import com.facebook.react.ReactRootView;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.fragment.BaseFragment;

import javax.annotation.Nullable;

public abstract class ReactFragment extends BaseFragment {

    private ReactRootView mReactRootView;
    protected ReactInstanceManager mReactInstanceManager;

    @Override
    public void onAttach(Context context) {
        super.onAttach(context);
        mReactRootView = new ReactRootView(context);
        mReactInstanceManager = ((UclientApplication) getActivity().getApplication()).getReactNativeHost().getReactInstanceManager();
    }

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        super.onCreateView(inflater, container, savedInstanceState);
        return mReactRootView;
    }

    @Override
    public void onViewCreated(View view, Bundle savedInstanceState) {
    }

    @Override
    public void onActivityCreated(@Nullable Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        mReactRootView.startReactApplication(mReactInstanceManager, getMainPageName(), null);
    }

    protected abstract String getMainPageName();

    //sendEvent 方法用于原生调用 js 的接口，需要获取到 ReactContext 对象，通过 ReactInstanceManager#getCurrentReactContext 获取到的 ReactContext 为空，这里从 Application 中获取。
    protected void sendEvent(String eventName,
                             @Nullable WritableMap params) {
        if (((UclientApplication) getActivity().getApplication()).getReactContext() != null) {
            ((UclientApplication) getActivity().getApplication()).getReactContext()
                    .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                    .emit(eventName, params);
        }
    }
}
