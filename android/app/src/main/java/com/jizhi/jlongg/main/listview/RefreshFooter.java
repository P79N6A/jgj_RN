package com.jizhi.jlongg.main.listview;

import android.content.Context;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.jizhi.jlongg.R;


/**
 * Created by Ly on 2016/10/4.
 */
public class RefreshFooter extends LinearLayout {

    private TextView tv_load_state;
    private LinearLayout ll_progress;

    public static final int PULL_TO_LOAD_MORE = 0;
    public static final int RELEASE_TO_LOAD_MORE = 3;
    public static final int LOADING_DATA = 1;
    public static final int HAS_NO_MORE = 2;

    private View mContainer;
    int mState = PULL_TO_LOAD_MORE;
    boolean isFirst = true;

    public RefreshFooter(Context context) {
        super(context);
        init(context);
    }

    public RefreshFooter(Context context, AttributeSet attrs) {
        super(context, attrs);
        init(context);
    }

    public RefreshFooter(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        init(context);
    }

    private void init(Context context) {
        mContainer = LayoutInflater.from(context).inflate(R.layout.refresh_footer, null);
        mContainer.setLayoutParams(new LayoutParams(LayoutParams.MATCH_PARENT,
                LayoutParams.WRAP_CONTENT));
        addView(mContainer);
        tv_load_state = (TextView) mContainer.findViewById(R.id.tv_load_state);
        ll_progress = (LinearLayout) mContainer.findViewById(R.id.ll_progress);

    }


    public void setFooterState(int state) {
        if (mState == state && !isFirst) {
            return;
        }
        isFirst = false;
        if (state == LOADING_DATA) {
            ll_progress.setVisibility(View.VISIBLE);
            tv_load_state.setVisibility(INVISIBLE);
        } else {
            ll_progress.setVisibility(View.INVISIBLE);
            tv_load_state.setVisibility(VISIBLE);
        }

        switch (state) {
            case PULL_TO_LOAD_MORE:
                if (mState != PULL_TO_LOAD_MORE) {
                    tv_load_state.setText("上拉加载");
                }
                break;

            case RELEASE_TO_LOAD_MORE:
                if (mState == PULL_TO_LOAD_MORE) {
                    tv_load_state.setText("松开加载");
                }
                break;

            case HAS_NO_MORE:
                tv_load_state.setText("没有更多数据");
                break;
        }

        mState = state;

    }

    /**
     * 获取footer的margin
     *
     * @return
     */
    public int getFooterMargin() {
        LayoutParams layoutParams = (LayoutParams) mContainer.getLayoutParams();
        return layoutParams.bottomMargin;
    }

    /**
     * 修改footer的bootomMargin值
     *
     * @param margin
     */
    public void setFooterMargin(int margin) {
        LayoutParams layoutParams = (LayoutParams) mContainer.getLayoutParams();
        layoutParams.bottomMargin = margin;
        mContainer.setLayoutParams(layoutParams);


    }

    /**
     * 当禁用下拉刷新时，footer隐藏
     */
    public void hide() {
        LayoutParams lp = (LayoutParams) mContainer.getLayoutParams();
        lp.height = 0;
        mContainer.setLayoutParams(lp);
    }


    /**
     * 当禁用下拉刷新时，footer显示
     */
    public void show() {
        LayoutParams lp = (LayoutParams) mContainer.getLayoutParams();
        lp.height = LayoutParams.WRAP_CONTENT;
        mContainer.setLayoutParams(lp);
    }


}
