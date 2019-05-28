package com.jizhi.jlongg.main.util;

import android.content.Context;
import android.util.AttributeSet;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;

import com.hcs.uclient.utils.DensityUtils;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;

/**
 * 功能: ViewPager 小圆点滚动器
 * 作者：Administrator
 * 时间: 2016-8-18 18:32
 */
public class DotViewGroup extends LinearLayout {

    /**
     * view集合
     */
    private View[] views;
    /**
     * 当前ViewPager选中的小圆点
     */
    private int currentIndex;

    public DotViewGroup(Context context) {
        super(context);
        setGravity(Gravity.CENTER);
    }

    public DotViewGroup(Context context, AttributeSet attrs) {
        super(context, attrs);
        setGravity(Gravity.CENTER);

    }

    /**
     * 创建小圆点
     */
    public void createDot(int size, Context context) {
        views = new View[size];
        int margin = DensityUtils.dp2px(context, 5);
        for (int i = 0; i < size; i++) {
            View dots = new View(context);
            LayoutParams params = new LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT);
            params.rightMargin = i == size - 1 ? 0 : margin;
            dots.setLayoutParams(params);
            if (i == 0) {
                setSelectedViewAttribute(dots);
            } else {
                setUnSelectedViewAttribute(dots);
            }
            addView(dots);
            views[i] = dots;
        }
    }

    /**
     * 设置选中View的属性
     *
     * @param selectedViewAttribute
     */
    private void setSelectedViewAttribute(View selectedViewAttribute) {
        int width = DensityUtils.dp2px(getContext(), 15);
        int height = DensityUtils.dp2px(getContext(), 3);
        ViewGroup.LayoutParams params = selectedViewAttribute.getLayoutParams();
        params.width = width;
        params.height = height;
        selectedViewAttribute.setLayoutParams(params);
        Utils.setBackGround(selectedViewAttribute, getResources().getDrawable(R.color.white));
        selectedViewAttribute.setAlpha(1.0f);
    }

    /**
     * 设置未选中View的属性
     *
     * @param unselectedViewAttribute
     */
    private void setUnSelectedViewAttribute(View unselectedViewAttribute) {
        int width = DensityUtils.dp2px(getContext(), 8);
        int height = DensityUtils.dp2px(getContext(), 3);
        ViewGroup.LayoutParams params = unselectedViewAttribute.getLayoutParams();
        params.width = width;
        params.height = height;
        unselectedViewAttribute.setLayoutParams(params);
        Utils.setBackGround(unselectedViewAttribute, getResources().getDrawable(R.color.white));
        unselectedViewAttribute.setAlpha(0.5f);
    }


    public void setPager(int position) {
        if (views != null) {
            setUnSelectedViewAttribute(views[currentIndex]);
            setSelectedViewAttribute(views[position]);
            currentIndex = position;
        }
    }
}
