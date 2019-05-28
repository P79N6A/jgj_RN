package com.jizhi.jlongg.main.activity.welcome;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.graphics.Point;
import android.os.Bundle;
import android.support.v4.view.PagerAdapter;
import android.support.v4.view.ViewPager;
import android.support.v4.view.ViewPager.OnPageChangeListener;
import android.text.TextUtils;
import android.view.MotionEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.Window;
import android.view.WindowManager;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;

import com.hcs.uclient.utils.DensityUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.AppMainActivity;
import com.jizhi.jlongg.main.activity.LoginActivity;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.util.Constance;
import com.liaoinstan.springview.utils.DensityUtil;
import com.umeng.analytics.MobclickAgent;

import java.util.ArrayList;
import java.util.List;

public class FirstInActivity extends Activity implements OnClickListener {
    /**
     * viewPager
     */
    private ViewPager viewPager;
    /**
     * 底部小圆点
     */
    private ImageView[] dots;
    /**
     * 立即体验按钮
     */
    private ImageView btnNext;
    /**
     * 引导图
     */
    public final int[] pics = {R.drawable.page_three, R.drawable.page_four, R.drawable.page_two};
    /**
     * viewPager 滑动下标
     */
    private int mCurrentPosition;


    /**
     * Called when the activity is first created.
     */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE); // 隐藏应用程序的标题栏，即当前activity的label
        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN); // 隐藏
        setContentView(R.layout.first_in_layout);
        initView();
    }

    private void initView() {
        final List<View> views = new ArrayList<>();
        LinearLayout dotsLayout = findViewById(R.id.dotsLayout);
        int size = pics.length;
        for (int i = 0; i < size; i++) {
            views.add(generateGuideMap(i));
            dotsLayout.addView(createDotsView());
        }
        viewPager = findViewById(R.id.view_pager);
        viewPager.setAdapter(new FirstInAdapter(views));
        // 绑定回调
        viewPager.setOnPageChangeListener(new OnPageChangeListener() {
            @Override
            public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {   // 当页面滑动的时候调用

            }

            @Override
            public void onPageSelected(int position) {   // 当页面选中的时候调用
                setDots(position);
                mCurrentPosition = position;
                btnNext.setImageResource(position == pics.length - 1 ? R.drawable.guide_start_now_icon : R.drawable.guide_next_icon);
            }

            @Override
            public void onPageScrollStateChanged(int state) {// 当页面滑动状态改变调用

            }
        });
        btnNext = findViewById(R.id.btn_next);
        btnNext.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                if (viewPager.getCurrentItem() == pics.length - 1) { //立即开启
//                    Intent intent = new Intent();
//                    intent.setClass(FirstInActivity.this, LoginActivity.class);
//                    startActivity(intent);
//                    finish();
                    toLogin();
                } else { //下一步
                    viewPager.setCurrentItem(viewPager.getCurrentItem() + 1);
                }
//                Intent intent = new Intent();
//                intent.setClass(FirstInActivity.this, LoginActivity.class);
//                startActivity(intent);
//                finish();
            }
        });

        View nextLayout = findViewById(R.id.nextLayout);
        dots = new ImageView[pics.length];
        for (int i = 0; i < pics.length; i++) {
            dots[i] = (ImageView) dotsLayout.getChildAt(i);// 索引
            dots[i].setEnabled(i == 0 ? true : false); // 都设置灰色
            dots[i].setTag(i); // 设置标签
        }
        RelativeLayout.LayoutParams nextLayoutParams = (RelativeLayout.LayoutParams) nextLayout.getLayoutParams();
        LinearLayout.LayoutParams dotsLayoutparams = (LinearLayout.LayoutParams) dotsLayout.getLayoutParams();
        if (DensityUtils.hasNavBar(getApplicationContext())) { //有虚拟键的设备
            dotsLayoutparams.topMargin = DensityUtils.dp2px(getApplicationContext(), 25);
            dotsLayout.setLayoutParams(dotsLayoutparams);

            nextLayoutParams.bottomMargin = DensityUtils.dp2px(getApplicationContext(), 20);
            nextLayout.setLayoutParams(nextLayoutParams);
        } else {
            dotsLayoutparams.topMargin = DensityUtils.dp2px(getApplicationContext(), 25);
            dotsLayout.setLayoutParams(dotsLayoutparams);

            nextLayoutParams.bottomMargin = DensityUtils.dp2px(getApplicationContext(), 20);
            nextLayout.setLayoutParams(nextLayoutParams);
        }
        viewPager.setOnTouchListener(new View.OnTouchListener() {
            float startX;
            float endX;

            @Override
            public boolean onTouch(View v, MotionEvent event) {
                switch (event.getAction()) {
                    case MotionEvent.ACTION_DOWN:
                        startX = event.getX();
                        break;
                    case MotionEvent.ACTION_UP:
                        endX = event.getX();
                        WindowManager windowManager = (WindowManager) getApplicationContext().getSystemService(Context.WINDOW_SERVICE);
                        //获取屏幕的宽度
                        Point size = new Point();
                        windowManager.getDefaultDisplay().getSize(size);
                        int width = size.x;
                        //首先要确定的是，是否到了最后一页，然后判断是否向左滑动，并且滑动距离是否符合，我这里的判断距离是屏幕宽度的4分之一（这里可以适当控制）
                        if (viewPager.getCurrentItem() == (pics.length - 1) && startX - endX >= (width / 4)) {
//                            Intent intent = new Intent();
//                            intent.setClass(FirstInActivity.this, LoginActivity.class);
//                            startActivity(intent);
//                            finish();
                            toLogin();
                        }
                        break;
                }
                return false;
            }
        });
    }

    public void toLogin() {
        boolean isLogin = UclientApplication.isLogin(FirstInActivity.this);
        Intent intent = new Intent();
        String url = getIntent().getStringExtra(Constance.COMPLETE_SCHEME);
        if (isLogin) {
            intent.setClass(FirstInActivity.this, AppMainActivity.class);
        } else {
            intent.setClass(FirstInActivity.this, LoginActivity.class);
        }
        if (!TextUtils.isEmpty(url)) {
            intent.putExtra(Constance.COMPLETE_SCHEME, url);
        }
        startActivity(intent);
        finish();
    }

    private View createDotsView() {
        ImageView imageView = new ImageView(this);
        int widthHeight = DensityUtil.dp2px(8);
        int margin = DensityUtil.dp2px(10);
        LinearLayout.LayoutParams layoutParams = new LinearLayout.LayoutParams(widthHeight, widthHeight);
        layoutParams.leftMargin = 8;
        layoutParams.rightMargin = 8;
        layoutParams.topMargin = margin;
        layoutParams.bottomMargin = margin;
        imageView.setLayoutParams(layoutParams);
        imageView.setImageResource(R.drawable.selector_firstlogin_dot);
        return imageView;
    }

    /**
     * 生成引导图
     *
     * @param position
     * @return
     */
    private View generateGuideMap(int position) {
        View guideMapView = getLayoutInflater().inflate(R.layout.first_in_layout_item, null); // 通讯录头部
        ImageView backgroundImage = (ImageView) guideMapView.findViewById(R.id.backgroundImage);
        backgroundImage.setScaleType(ImageView.ScaleType.CENTER_CROP);
        backgroundImage.setImageResource(pics[position]);
        return guideMapView;
    }

    @Override
    protected void onPause() {
        super.onPause();
        MobclickAgent.onPause(this);
    }


    // 设置当前的引导页
    private void setViews(int position) {
        if (position < 0 || position >= pics.length) {
            return;
        }
        viewPager.setCurrentItem(position);
    }

    // 设置当前小点
    private void setDots(int position) {
        if (position < 0 || position > pics.length - 1 || mCurrentPosition == position) {
            return;
        }
        dots[position].setEnabled(true);
        dots[mCurrentPosition].setEnabled(false);
    }


    @Override
    public void onClick(View v) {
        int position = (Integer) v.getTag();
        setViews(position);
        setDots(position);
    }

    public class FirstInAdapter extends PagerAdapter {
        private List<View> views;

        public FirstInAdapter(List<View> views) {
            this.views = views;
        }

        @Override
        public void destroyItem(View container, int position, Object object) {
            ((ViewPager) container).removeView(views.get(position));
        }

        @Override
        public Object instantiateItem(View container, int position) {
            ((ViewPager) container).addView(views.get(position));
            return views.get(position);
        }

        @Override
        public int getCount() {
            if (views != null) {
                return views.size();
            }
            return 0;
        }

        @Override
        public boolean isViewFromObject(View arg0, Object arg1) {
            return (arg0 == arg1);
        }
    }


}
