package com.jizhi.jlongg.main.util;

import android.view.View;
import android.widget.TextView;
/**
 * 设置顶部标题文字
 * @author Xuj
 * @time 
 * @Version 1.0
 */
public class SetTitleName {

	public static void setTitle(View text, String title) {
		if (text instanceof TextView) {
			((TextView) text).setText(title);
		}
	}
}
