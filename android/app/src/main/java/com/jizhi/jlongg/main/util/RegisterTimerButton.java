package com.jizhi.jlongg.main.util;

import android.content.res.Resources;
import android.os.CountDownTimer;
import android.widget.Button;

import com.jizhi.jlongg.R;

/**
 * 验证码倒计时
 *
 * @author Xuj
 * @time 2015年11月28日 10:55:01
 */
public class RegisterTimerButton extends CountDownTimer {
    /**
     * 按钮
     */
    private Button btn;
    /**
     * 资源类
     */
    private Resources res;
    /**
     * 是否重新开始读秒
     */
    private boolean isSet;

    public RegisterTimerButton(long millisInFuture, long countDownInterval, Button btn, Resources res) {
        super(millisInFuture, countDownInterval);
        this.btn = btn;
        this.res = res;
    }

    public boolean isSet() {
        return isSet;
    }

    public void setSet(boolean isSet) {
        this.isSet = isSet;
    }


    @SuppressWarnings("deprecation")
    @Override
    public void onFinish() {
        btn.setClickable(true);
        btn.setText(res.getString(R.string.get_code));
        btn.setTextColor(res.getColor(R.color.app_color));
        isSet = false;
    }

    @SuppressWarnings("deprecation")
    @Override
    public void onTick(long time) {
        if (!isSet) {
            btn.setClickable(false);
            btn.setTextColor(res.getColor(R.color.color_999999));
            isSet = true;
        }
        btn.setText(time / 1000 + "秒后重发");
    }

}