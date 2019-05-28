package com.jizhi.jlongg.main.listview;

import android.content.Context;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.view.View;
import android.view.animation.Animation;
import android.view.animation.RotateAnimation;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.jizhi.jlongg.R;


/**
 * Created by Ly on 2016/10/4.
 */
public class RefreshHeader extends LinearLayout {

    private TextView tv_pull_state;
    private ImageView iv_arrow;
    private ProgressBar progressBar;
    private RelativeLayout rl_my_content;

    public static final int PULL_TO_REFRESH = 0;    //下拉刷新
    public static final int RELEASE_TO_REFRESH = 1; //松开刷新
    public static final int REFRESHING = 2;         //正在刷新

    private RotateAnimation rotateUpAnimation;
    private RotateAnimation rotateDownAnimation;
    private View mContainer;

    int mState = PULL_TO_REFRESH;

    boolean isFirst = true;

    public RefreshHeader(Context context) {
        super(context);
        init(context);
    }

    public RefreshHeader(Context context, AttributeSet attrs) {
        super(context, attrs);
        init(context);

    }

    public RefreshHeader(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        init(context);
    }

    private void init(Context context) {
        LayoutParams lp = new LayoutParams(LayoutParams.MATCH_PARENT, 0);
        mContainer = LayoutInflater.from(context).inflate(R.layout.refresh_header, null);
        addView(mContainer, lp);

        rl_my_content = (RelativeLayout) findViewById(R.id.header_content);
        tv_pull_state = (TextView) findViewById(R.id.tv_pull_state);
        iv_arrow = (ImageView) findViewById(R.id.iv_arrow);
        progressBar = (ProgressBar) findViewById(R.id.progressBar);


        rotateUpAnimation = new RotateAnimation(0, -180, Animation.RELATIVE_TO_SELF, 0.5f, Animation.RELATIVE_TO_SELF, 0.5f);
        rotateUpAnimation.setDuration(180);
        rotateUpAnimation.setFillAfter(true);

        rotateDownAnimation = new RotateAnimation(-180, 0, Animation.RELATIVE_TO_SELF, 0.5f, Animation.RELATIVE_TO_SELF, 0.5f);
        rotateDownAnimation.setDuration(180);
        rotateDownAnimation.setFillAfter(true);


    }

    /**
     * 根据状态设置相应的布局
     *
     * @param state
     */
    public void setHeaderState(int state) {
        if (state == mState && !isFirst) {
            return;
        }
        isFirst = false;
        if (state == REFRESHING) {
            iv_arrow.clearAnimation();
            progressBar.setVisibility(View.VISIBLE);
            iv_arrow.setVisibility(View.INVISIBLE);
            tv_pull_state.setText("正在加载");
        } else {
            progressBar.setVisibility(View.INVISIBLE);
            iv_arrow.setVisibility(View.VISIBLE);
        }

        switch (state) {
            case PULL_TO_REFRESH:
                if (mState == RELEASE_TO_REFRESH) {
                    iv_arrow.clearAnimation();
                    iv_arrow.startAnimation(rotateDownAnimation);
                }

                tv_pull_state.setText("下拉加载");


                break;
            case RELEASE_TO_REFRESH:
                if (mState == PULL_TO_REFRESH) {
                    iv_arrow.clearAnimation();
                    iv_arrow.startAnimation(rotateUpAnimation);
                }
                tv_pull_state.setText("松开加载");
                break;

        }
        mState = state;
    }

    /**
     * 获取头部的高度
     *
     * @return
     */
    public int getHeaderHeight() {
        return mContainer.getHeight();
    }

    /**
     * 修改header的高度
     *
     * @param height
     */
    public void setHeaderHeight(int height) {
        if (height < 0) height = 0;
        LayoutParams layoutParams = (LayoutParams) mContainer.getLayoutParams();
        layoutParams.height = height;
        mContainer.setLayoutParams(layoutParams);
    }


}
