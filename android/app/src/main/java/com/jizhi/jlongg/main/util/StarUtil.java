package com.jizhi.jlongg.main.util;

import android.content.Context;
import android.widget.TextView;

import com.jizhi.jlongg.R;

public class StarUtil {

	public static String getStarText(int evaluat,Context context){
		String str = null;
		switch (evaluat) {
		case 1:
			str = context.getString(R.string.one_star);
			break;
		case 2:
			str = context.getString(R.string.two_star);
			break;
		case 3:
			str = context.getString(R.string.three_star);
			break;
		case 4:
			str = context.getString(R.string.four_star);
			break;
		case 5:
			str = context.getString(R.string.five_star);
			break;
		default:
			str = context.getString(R.string.one_star);
			break;
		}
		return str;
	}
	
}
