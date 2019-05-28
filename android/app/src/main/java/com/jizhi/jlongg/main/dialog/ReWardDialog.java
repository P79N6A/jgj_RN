package com.jizhi.jlongg.main.dialog;

import android.app.Activity;
import android.app.Dialog;
import android.text.TextUtils;
import android.view.View;
import android.widget.EditText;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.RewardPayActivity;
import com.jizhi.jlongg.main.util.CommonMethod;

import java.util.Random;

/**
 * 奖励开发者弹出框
 *
 * @author 徐杰
 * @version 1.0
 * @time 2018年4月26日10:35:06
 */
public class ReWardDialog extends Dialog implements View.OnClickListener {


    /**
     * 奖励留言
     */
    private EditText messageEdit;
    /**
     * 换个金额按钮
     */
    private TextView changeMoneyText;
    /**
     * 显示金额文本
     */
    private TextView moneyText;
    /**
     * 上下文
     */
    private Activity activity;


    public void createLayout(final Activity context) {
        setContentView(R.layout.reward_dialog);
        moneyText = (TextView) findViewById(R.id.moneyText);
        changeMoneyText = (TextView) findViewById(R.id.changeMoneyText);
        messageEdit = (EditText) findViewById(R.id.messageEdit);
        changeMoneyText.setOnClickListener(this);
        findViewById(R.id.closedIcon).setOnClickListener(this);
        findViewById(R.id.submitBtn).setOnClickListener(this);
        moneyText.setText(randomMakeMoney());
    }

    public ReWardDialog(Activity context) {
        super(context, R.style.Custom_Progress);
        this.activity = context;
        createLayout(context);
        commendAttribute(false);
    }

    /**
     * 设置弹出框公共属性
     */
    public void commendAttribute(boolean isCancelDialog) {
        setCanceledOnTouchOutside(isCancelDialog);
        setCancelable(isCancelDialog);
    }

    private void getNewMoney() {
        String newMoney = randomMakeMoney();
        if (newMoney.equals(moneyText.getText().toString())) {
            getNewMoney();
            return;
        }
        moneyText.setText(newMoney);
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.changeMoneyText: //切换金额
                getNewMoney();
                break;
            case R.id.submitBtn: //提交数据按钮
                if (TextUtils.isEmpty(moneyText.getText().toString())) {
                    CommonMethod.makeNoticeLong(activity.getApplicationContext(), "请填写奖励的金额", CommonMethod.ERROR);
                }
                RewardPayActivity.actionStart(activity, moneyText.getText().toString(), messageEdit.getText().toString().trim());
                dismiss();
                break;
            case R.id.closedIcon:
                dismiss();
                break;
        }
    }

    /**
     * （1）默认为随机金额（70%概率随机选择1.88、2.88、3.88中的一个值；30%概率随机选择6.88、8.88中的一个值）；
     */
    private static String randomMakeMoney() {
        int number = new Random().nextInt(9);
        if (number < 6) {
            int randomMoney = new Random().nextInt(2);
            switch (randomMoney) {
                case 0:
                    return "1.88";
                case 1:
                    return "2.88";
                case 2:
                    return "3.88";
                default:
                    return "3.88";
            }
        } else {
            int randomMoney = new Random().nextInt(1);
            switch (randomMoney) {
                case 0:
                    return "6.88";
                case 1:
                    return "8.88";
                default:
                    return "8.88";
            }
        }
    }
}
