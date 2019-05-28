package com.jizhi.jlongg.account;

import android.animation.Animator;
import android.animation.AnimatorListenerAdapter;
import android.app.Activity;
import android.os.Build;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.annotation.RequiresApi;
import android.support.v4.content.ContextCompat;
import android.view.View;
import android.view.ViewAnimationUtils;
import android.view.animation.AccelerateDecelerateInterpolator;
import android.view.animation.AlphaAnimation;
import android.view.animation.Animation;
import android.view.animation.AnimationSet;
import android.view.animation.ScaleAnimation;
import android.view.animation.TranslateAnimation;
import android.widget.ImageView;
import android.widget.RelativeLayout;

import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.ScreenUtils;
import com.jizhi.jlongg.R;

public class TestActivity extends Activity implements View.OnClickListener {
    private ImageView ima_worker, ima_forman;
    private RelativeLayout img_reveal;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.layout_test);
        ima_worker = findViewById(R.id.ima_worker);
        ima_forman = findViewById(R.id.ima_forman);
        img_reveal = findViewById(R.id.img_reveal);
        ima_worker.setOnClickListener(this);
        ima_forman.setOnClickListener(this);


    }


    //得到视图中心
    public static int[] getViewCenter(View view) {

        int top = view.getTop();
        int left = view.getLeft();
        int bottom = view.getBottom();
        int right = view.getRight();
        int x1 = (right - left) / 2;
        int y1 = (bottom - top) / 2;

        int[] location = new int[2];
        view.getLocationOnScreen(location);
        int x2 = location[0];
        int y2 = location[1];
        int x = x2 + x1;
        int y = y2;
        int[] center = {x, y};
        return center;
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.ima_worker:
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                    LUtils.e("---------1111------------");
                    createCircularReveal(ima_worker, 2000);
                    img_reveal.setBackgroundResource(R.color.color_5b9aff);
//                    Combo(ima_forman, 4500);

                }
                break;
            case R.id.ima_forman:
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                    createCircularReveal(ima_forman, 2000);
                    img_reveal.setBackgroundResource(R.color.color_8e86ff);
//                    Combo(ima_worker, 4500);


                }
                break;
        }
    }

    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
    public void createCircularReveal(final View view, final int duration) {
        img_reveal.setVisibility(View.VISIBLE);
        int centerX = getViewCenter(view)[0];
        int centerY = getViewCenter(view)[1];
        LUtils.e(centerX + "---------2222------------" + centerY);

        Animator animation = ViewAnimationUtils.createCircularReveal(img_reveal, centerX,
                centerY, 0, ScreenUtils.getScreenHeight(TestActivity.this));
        animation.setInterpolator(new AccelerateDecelerateInterpolator());
        animation.setDuration(duration);
        animation.addListener(new Animator.AnimatorListener() {
            @Override
            public void onAnimationStart(Animator animation) {
                LUtils.e("---------onAnimationStart------------");
                img_reveal.setVisibility(View.VISIBLE);
                Combo(view.getId() == ima_worker.getId() ? ima_forman : ima_worker, duration - 1000);
            }

            @Override
            public void onAnimationEnd(Animator animation) {
                LUtils.e("---------onAnimationEnd------------");
                img_reveal.setVisibility(View.GONE);
            }

            @Override
            public void onAnimationCancel(Animator animation) {
                LUtils.e("---------onAnimationCancel------------");

            }

            @Override
            public void onAnimationRepeat(Animator animation) {
                LUtils.e("---------onAnimationRepeat------------");

            }
        });
        animation.start();
    }


    /**
     * 动画平移
     */
    public void Translate(View ivPic) {
        /*
         * TranslateAnimation translateAni = new TranslateAnimation(fromXType,
         * fromXValue, toXType, toXValue, fromYType, fromYValue, toYType,
         * toYValue);
         */
        //参数1～2：x轴的开始位置
        //参数3～4：y轴的开始位置
        //参数5～6：x轴的结束位置
        //参数7～8：x轴的结束位置
        TranslateAnimation translateAni = new TranslateAnimation(
                Animation.RELATIVE_TO_PARENT, 0, Animation.RELATIVE_TO_PARENT,
                0.3f, Animation.RELATIVE_TO_PARENT, 0,
                Animation.RELATIVE_TO_PARENT, 0.3f);

        //设置动画执行的时间，单位是毫秒
        translateAni.setDuration(1000);

        // 设置动画重复次数
        // -1或者Animation.INFINITE表示无限重复，正数表示重复次数，0表示不重复只播放一次
        translateAni.setRepeatCount(10);

        // 设置动画模式（Animation.REVERSE设置循环反转播放动画,Animation.RESTART每次都从头开始）
        translateAni.setRepeatMode(Animation.REVERSE);

        // 启动动画
        ivPic.startAnimation(translateAni);
    }

    /**
     * 组合动画（缩放和旋转组合）
     */
    public void Combo(View ivPic, int duration) {


        // 创建透明度动画，第一个参数是开始的透明度，第二个参数是要转换到的透明度
        AlphaAnimation alphaAni = new AlphaAnimation(0.2f, 1);
        //设置动画执行的时间，单位是毫秒
        alphaAni.setDuration(duration);
        // 设置动画重复次数
        // -1或者Animation.INFINITE表示无限重复，正数表示重复次数，0表示不重复只播放一次
        alphaAni.setRepeatCount(0);
        // 设置动画模式（Animation.REVERSE设置循环反转播放动画,Animation.RESTART每次都从头开始）
        alphaAni.setRepeatMode(Animation.REVERSE);
        //参数1：x轴的初始值
        //参数2：x轴收缩后的值
        //参数3：y轴的初始值
        //参数4：y轴收缩后的值
        //参数5：确定x轴坐标的类型
        //参数6：x轴的值，0.5f表明是以自身这个控件的一半长度为x轴
        //参数7：确定y轴坐标的类型
        //参数8：y轴的值，0.5f表明是以自身这个控件的一半长度为x轴
        // Animation.RELATIVE_TO_SELF, 0.5f表示绕着自己的中心点进行动画
        ScaleAnimation scaleAni = new ScaleAnimation(1f, 0.0f, 1f, 0.0f,
                Animation.RELATIVE_TO_SELF, 0.5f, Animation.RELATIVE_TO_SELF,
                0.5f);

        //设置动画执行的时间，单位是毫秒
        scaleAni.setDuration(duration);
        // 设置动画重复次数
        // -1或者Animation.INFINITE表示无限重复，正数表示重复次数，0表示不重复只播放一次
        scaleAni.setRepeatCount(0);
        // 设置动画模式（Animation.REVERSE设置循环反转播放动画,Animation.RESTART每次都从头开始）
        scaleAni.setRepeatMode(Animation.REVERSE);

        TranslateAnimation translateAni = new TranslateAnimation(
                Animation.RELATIVE_TO_PARENT, 0, Animation.RELATIVE_TO_PARENT,
                ivPic.getId() == ima_worker.getId() ? 1f : -1f, Animation.RELATIVE_TO_PARENT, 0,
                Animation.RELATIVE_TO_PARENT, 0);
        //设置动画执行的时间，单位是毫秒
        translateAni.setDuration(duration);
        // 设置动画重复次数
        // -1或者Animation.INFINITE表示无限重复，正数表示重复次数，0表示不重复只播放一次
        translateAni.setRepeatCount(0);
        // 设置动画模式（Animation.REVERSE设置循环反转播放动画,Animation.RESTART每次都从头开始）
        translateAni.setRepeatMode(Animation.REVERSE);


        // 将缩放动画和旋转动画放到动画插值器
        AnimationSet as = new AnimationSet(false);
        as.addAnimation(alphaAni);
        as.addAnimation(scaleAni);
        as.addAnimation(translateAni);
        as.setFillBefore(true);
//        as.setFillAfter(true);
        // 启动动画
        ivPic.startAnimation(as);
    }

}
