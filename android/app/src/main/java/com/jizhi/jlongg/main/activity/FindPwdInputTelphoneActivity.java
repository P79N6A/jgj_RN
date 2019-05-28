package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.EditText;

import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.StrUtil;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;

/**
 * 找回密码
 *
 * @author Xuj
 * @time 2018年6月11日10:30:09
 */

public class FindPwdInputTelphoneActivity extends BaseActivity implements View.OnClickListener {
    /**
     * 原电话号码
     */
    private EditText telEdit;

    /**
     * 启动当前Activity
     *
     * @param context
     */
    public static void actionStart(Activity context) {
        Intent intent = new Intent(context, FindPwdInputTelphoneActivity.class);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setRestartWebSocketService(false);
        setContentView(R.layout.find_pwd_step1);
        setTextTitle(R.string.find_pwd);
        telEdit = getEditText(R.id.telEdit);
        getButton(R.id.red_btn).setText(R.string.next);
    }


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.red_btn: //下一步
                String telephone = telEdit.getText().toString().trim();
                if (StrUtil.isNull(telephone)) {
                    CommonMethod.makeNoticeShort(this, "请输入原手机号码", CommonMethod.ERROR);
                    return;
                }
                if (!StrUtil.isMobileNum(telephone)) {
                    CommonMethod.makeNoticeShort(this, getString(R.string.input_sure_mobile), CommonMethod.ERROR);
                    return;
                }
                FindPwdStep123Activity.actionStart(this, telephone, 1);
                break;
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == 1) { //验证成功
            setResult(1);
            finish();
        }
    }
}
