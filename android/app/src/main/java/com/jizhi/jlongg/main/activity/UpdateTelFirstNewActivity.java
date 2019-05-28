package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.shadow.ShadowUtil;

import static com.jizhi.jlongg.main.util.Constance.REQUEST;


/**
 * 修改手机号码第一步
 *
 * @author Xuj
 * @time 2017年3月24日16:17:28
 * @Version 1.0
 */
public class UpdateTelFirstNewActivity extends BaseActivity implements View.OnClickListener {


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.update_telphone_first_new);
        initView();
    }


    /**
     * 启动当前Activity
     *
     * @param context
     */
    public static void actionStart(Activity context) {
        Intent intent = new Intent(context, UpdateTelFirstNewActivity.class);
        context.startActivityForResult(intent, REQUEST);
    }


    private void initView() {
        String telphone = UclientApplication.getTelephone(getApplicationContext()); //获取当前登录对象的电话号码
        if (TextUtils.isEmpty(telphone) || telphone.length() != 11) { //如果为空或者不等于11位则不让进入当前页面
            CommonMethod.makeNoticeShort(getApplicationContext(), "获取电话号码出错", CommonMethod.ERROR);
            finish();
            return;
        }
        TextView telephoneText = getTextView(R.id.telephone_text);
        telephoneText.setText("你的手机号：" + telphone);
        setTextTitle(R.string.update_telphone);
        ShadowUtil.setShadowAndUserOriginalBackground(this, findViewById(R.id.nextBtn), Color.parseColor("#fb4e4e")); //登录按钮设置阴影
    }


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.nextBtn: //下一步按钮
                UpdateTelSecondNewActivity.actionStart(this, UclientApplication.getTelephone(getApplicationContext()));
                break;
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == Constance.UPDATE_TEL_SUCCESS) {
            setResult(Constance.UPDATE_TEL_SUCCESS);
            finish();
        }
    }

}