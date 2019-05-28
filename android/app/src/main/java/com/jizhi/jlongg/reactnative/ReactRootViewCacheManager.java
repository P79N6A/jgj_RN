package com.jizhi.jlongg.reactnative;


import android.app.Activity;
import android.view.ViewGroup;
import android.view.ViewParent;

import com.facebook.react.ReactInstanceManager;
import com.facebook.react.ReactRootView;
import com.jizhi.jlongg.main.application.UclientApplication;

import java.util.HashMap;

public class ReactRootViewCacheManager {

    private static HashMap<String, ReactRootView> rootViewHashMap = new HashMap<>();

    /**
     * 预加载RN渲染引擎
     * @param activity
     */
    public static void init(Activity activity, String moduleName){
        //包含了，立刻返回
        if(rootViewHashMap.containsKey(moduleName))return;
        //ReactRootView 直接new就可以了
        ReactRootView mReactRootView = new ReactRootView(activity);
        //在MainApplication中提前初始化ReactInstanceManager
        ReactInstanceManager reactInstanceManager = ((UclientApplication) activity.getApplication()).getReactNativeHost().getReactInstanceManager();
        //第一个参数为ReactInstanceManager
        //第二个参数建议和RN主界面中getMainComponentName返回的内容一样，也就是此函数中的第二个形参moduleName
        //第三个参数为null即可
        mReactRootView.startReactApplication(reactInstanceManager,moduleName,null);
        rootViewHashMap.put(moduleName,mReactRootView);
    }

    /**
     * 获取指定的reactrootview
     * @param moduleName
     * @return
     */
    public static ReactRootView getReactRootView(String moduleName){
        ReactRootView reactRootView = rootViewHashMap.get(moduleName);
        if(reactRootView != null){
            ViewParent parent = reactRootView.getParent();
            if(parent != null && parent instanceof ViewGroup){
                ((ViewGroup)parent).removeAllViews();
            }
        }
        return reactRootView;
    }
}

