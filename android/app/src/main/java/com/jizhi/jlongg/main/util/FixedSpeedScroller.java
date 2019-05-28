package com.jizhi.jlongg.main.util;

import android.annotation.SuppressLint;
import android.content.Context;
import android.view.animation.Interpolator;
import android.widget.Scroller;

/**
 * 滑块滑动速度
 * 
 * @author lilong
 * @time 2015-11-19 下午4:09
 * @version 1.0
 * 
 */
@SuppressLint("NewApi")
public class FixedSpeedScroller extends Scroller {
	private int mDuration = 500;

	public int getmDuration() {
		return mDuration;
	}

	public void setmDuration(int mDuration) {
		this.mDuration = mDuration;
	}

	public FixedSpeedScroller(Context context) {
		super(context);
	}

	public FixedSpeedScroller(Context context, Interpolator interpolator) {
		super(context, interpolator);
	}

	public FixedSpeedScroller(Context context, Interpolator interpolator,
			boolean flywheel) {
		super(context, interpolator, flywheel);
	}

	@Override
	public void startScroll(int startX, int startY, int dx, int dy, int duration) {
		super.startScroll(startX, startY, dx, dy, mDuration);
	}

	@Override
	public void startScroll(int startX, int startY, int dx, int dy) {
		super.startScroll(startX, startY, dx, dy, mDuration);
	}
}
