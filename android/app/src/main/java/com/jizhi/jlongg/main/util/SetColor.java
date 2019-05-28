package com.jizhi.jlongg.main.util;

import android.support.v4.widget.SwipeRefreshLayout;

import com.jizhi.jlongg.R;

/**
 * 设置Google 下拉加载对话框刷新 颜色
 * @author Xuj
 * @time 
 * @Version 1.0
 */
public class SetColor {
	
	public SetColor(SwipeRefreshLayout layout) {
		layout.setColorSchemeResources(R.color.app_color, R.color.color_red,R.color.yellow_color);
	}

}
