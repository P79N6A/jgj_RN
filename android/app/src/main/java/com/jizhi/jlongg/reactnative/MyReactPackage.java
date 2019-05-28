package com.jizhi.jlongg.reactnative;

import com.baidu.platform.comapi.map.G;
import com.facebook.react.ReactPackage;
import com.facebook.react.bridge.NativeModule;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.uimanager.ViewManager;
import com.growingio.android.plugin.rn.GrowingIOPackage;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * CName:3.4.2RN包管理器类
 * User: hcs
 * Date: 2019-4-22
 * Time: 下午 17:07
 */
public class MyReactPackage implements ReactPackage {

//    public MyNativeModule myNativeModule;

    @Override
    public List<NativeModule> createNativeModules(ReactApplicationContext reactContext) {
        List<NativeModule> modules = new ArrayList<>();
        //将我们创建NativeModule添加进原生模块列表中
        modules.add(new MyNativeModule(reactContext));
        return modules;
    }

    @Override
    public List<ViewManager> createViewManagers(ReactApplicationContext reactContext) {
        //该处后期RN调用原生控件或自定义组件时可用到
        return Collections.emptyList();
    }

}
