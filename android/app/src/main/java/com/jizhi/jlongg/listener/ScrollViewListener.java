package com.jizhi.jlongg.listener;

import com.jizhi.jongg.widget.ObservableScrollView;

/**
 * 作者    你的名字
 * 时间    2019-3-15 下午 3:33
 * 文件    yzg_android_s
 * 描述
 */
public interface ScrollViewListener {
    void onScrollChanged(ObservableScrollView scrollView, int x, int y, int oldx, int oldy);
}
