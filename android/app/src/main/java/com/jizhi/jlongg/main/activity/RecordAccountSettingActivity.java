package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.content.LocalBroadcastManager;
import android.view.View;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.AccountSwitchConfirm;
import com.jizhi.jlongg.main.dialog.DialogLeftRightBtnConfirm;
import com.jizhi.jlongg.main.util.AccountUtil;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.jizhi.jongg.widget.SwitchView;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;

/**
 * 记工设置
 *
 * @author Xuj
 * @time 2019年2月14日14:51:47
 * @Version 3.5.1
 */
public class RecordAccountSettingActivity extends BaseActivity implements View.OnClickListener {
    /**
     * 记工显示方式
     */
    private TextView recordAccountSettingText;
    /**
     * 开启我要对账的提示
     */
    private View openAccountConfirmLayout;
    /**
     * 对账开关
     */
    private SwitchView switchView;


    /**
     * 启动当前Activity
     *
     * @param context
     */
    public static void actionStart(Activity context) {
        Intent intent = new Intent(context, RecordAccountSettingActivity.class);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.record_account_setting);
        initView();
        getRecordConfirmStatus();
    }

    private void initView() {
        setTextTitle(R.string.record_setting);
        recordAccountSettingText = findViewById(R.id.record_account_setting_text);
        openAccountConfirmLayout = findViewById(R.id.open_account_confirm_layout);
        recordAccountSettingText.setText(AccountUtil.getCurrentAccountType(getApplicationContext()));
        switchView = findViewById(R.id.switch_btn);
        switchView.setOnStateChangedListener(new SwitchView.OnStateChangedListener() {
            @Override
            public void toggleToOn(SwitchView view) {
                openOrCloseConfirm(true);
            }

            @Override
            public void toggleToOff(SwitchView view) {
                if (view.isOpened()) { //开启状态
                    DialogLeftRightBtnConfirm dialogLeftRightBtnConfirm = new DialogLeftRightBtnConfirm(RecordAccountSettingActivity.this, null, "确定要关闭自动对账吗？", new DialogLeftRightBtnConfirm.LeftRightBtnListener() {
                        @Override
                        public void clickLeftBtnCallBack() {
                            switchView.toggleSwitch(true);
                        }

                        @Override
                        public void clickRightBtnCallBack() {
                            openOrCloseConfirm(false);
                        }
                    });
                    dialogLeftRightBtnConfirm.commendAttribute(false);
                    dialogLeftRightBtnConfirm.show();
                }
            }
        });
        findViewById(R.id.record_account_setting).setOnClickListener(this);
        findViewById(R.id.open_account_confirm_layout).setOnClickListener(this);
    }

    /**
     * 获取对账开关的状态
     */
    private void getRecordConfirmStatus() {
        AccountUtil.getRecordConfirmStatus(this, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                AccountSwitchConfirm accountSwitchConfirm = (AccountSwitchConfirm) object;
                int status = accountSwitchConfirm.getStatus();//1 表示关闭 ；0:表示开启
                switchView.toggleSwitch(status == 1 ? false : true);
                openAccountConfirmLayout.setVisibility(status == 1 ? View.GONE : View.VISIBLE);
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {

            }
        });
    }

    /**
     * 关闭或打开对账功能
     */
    public void openOrCloseConfirm(boolean isOpen) {
        String httpUrl = NetWorkRequest.RECORD_CONFIRM_ON_OFF;
        RequestParams requestParams = RequestParamsToken.getExpandRequestParams(getApplicationContext());
        requestParams.addBodyParameter("status", isOpen ? "0" : "1");
        CommonHttpRequest.commonRequest(this, httpUrl, AccountSwitchConfirm.class, CommonHttpRequest.OBJECT, requestParams,
                true, new CommonHttpRequest.CommonRequestCallBack() {
                    @Override
                    public void onSuccess(Object object) {
                        LocalBroadcastManager.getInstance(getApplicationContext()).sendBroadcast(new Intent(Constance.ACCOUNT_INFO_CHANGE));
                        AccountSwitchConfirm accountSwitchConfirm = (AccountSwitchConfirm) object;
                        //"status": 1//表示关闭 ；0:表示开启
                        int status = accountSwitchConfirm.getStatus();
                        switchView.toggleSwitch(status == 1 ? false : true);
                        openAccountConfirmLayout.setVisibility(status == 1 ? View.GONE : View.VISIBLE);
                        setResult(Constance.REFRESH_CONFIRM_ACCOUNT_STATUS);
                    }

                    @Override
                    public void onFailure(HttpException exception, String errormsg) {
                        finish();
                    }
                });
    }


    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == Constance.CHANGE_ACCOUNT_SHOW_TYPE) {
            recordAccountSettingText.setText(AccountUtil.getCurrentAccountType(getApplicationContext()));
        }
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.open_account_confirm_layout: //我要对账查看
                BalanceOfAccountActivity.actionStart(this);
                break;
            case R.id.record_account_setting: //记工显示方式
                AccountShowTypeActivity.actionStart(this);
                break;
        }
    }
}