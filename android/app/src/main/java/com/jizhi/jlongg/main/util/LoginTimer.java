package com.jizhi.jlongg.main.util;

import android.content.res.Resources;
import android.os.CountDownTimer;
import android.widget.TextView;

import com.jizhi.jlongg.R;


/**
 * 验证码倒计时
 *
 * @author Xuj
 * @time 2017年4月6日15:12:12
 */
public class LoginTimer extends CountDownTimer {

    /**
     * 倒计时的按钮
     */
    private TextView btn;
    /**
     * 资源
     */
    private Resources res;
    /**
     * 是否已经设置了背景色 防止重新设置
     */
    private boolean isSetBackground;

    public LoginTimer(long millisInFuture, long countDownInterval, TextView btn, Resources res) {
        super(millisInFuture, countDownInterval);
        this.btn = btn;
        this.res = res;
    }

    @SuppressWarnings("deprecation")
    @Override
    public void onFinish() {
        btn.setClickable(true);
        btn.setText(res.getString(R.string.get_code));
        isSetBackground = false;
        btn.setTextColor(res.getColor(R.color.app_color));
    }

    @SuppressWarnings("deprecation")
    @Override
    public void onTick(long time) {
        if (!isSetBackground) {
            btn.setClickable(false);
            btn.setTextColor(res.getColor(R.color.color_999999));
            isSetBackground = true;
        }
        btn.setText(time / 1000 + "秒后重发");
    }
}