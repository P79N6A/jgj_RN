package com.jizhi.jlongg.main.listener;

import com.facebook.react.bridge.Callback;

public interface ShareListener {
    /**
     * 分享
     *
     * @param callback
     */
    void showShareMenu(String data, Callback callback);

}
