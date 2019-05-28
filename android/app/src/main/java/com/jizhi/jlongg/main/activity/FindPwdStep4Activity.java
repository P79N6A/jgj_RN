package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.text.Html;
import android.view.View;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.TextView;

import com.hcs.uclient.utils.CallPhoneUtil;
import com.hcs.uclient.utils.StrUtil;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.FindPwdQuestion;
import com.jizhi.jlongg.main.dialog.DiaLogRedLongProgress;
import com.jizhi.jlongg.main.dialog.DialogLeftRightBtnConfirm;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;

/**
 * 找回密码 步骤4
 *
 * @author Xuj
 * @time 2018年6月11日10:30:09
 */

public class FindPwdStep4Activity extends BaseActivity implements View.OnClickListener {


    /**
     * 记账对象电话号码输入框
     */
    private EditText telEdit;


    /**
     * 启动当前Activity
     *
     * @param context
     * @param telphone 原电话号码
     * @param token    问题3 返回的token,验证的时候需要传递给服务器
     * @param userName 记账人名称
     * @param cids     已选的问题选项
     */
    public static void actionStart(Activity context, String telphone, String userName, String token, String cids) {
        Intent intent = new Intent(context, FindPwdStep4Activity.class);
        intent.putExtra(Constance.TELEPHONE, telphone);
        intent.putExtra(Constance.USERNAME, userName);
        intent.putExtra("token", token);
        intent.putExtra(Constance.SELECTED_IDS, cids);
        context.startActivityForResult(intent, Constance.REQUEST);
    }


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setRestartWebSocketService(false);
        setContentView(R.layout.listview_bottom_red_btn);
        initView();
    }

    private void initView() {
        setTextTitle(R.string.find_pwd);
        Intent intent = getIntent();
        View headView = getLayoutInflater().inflate(R.layout.find_pwd_title, null);
        TextView telephoneText = (TextView) headView.findViewById(R.id.telephoneText);
        getButton(R.id.red_btn).setText(R.string.start_validation);
        telEdit = (EditText) headView.findViewById(R.id.telEdit);
        telEdit.setVisibility(View.VISIBLE);
        TextView questionTitleText = (TextView) headView.findViewById(R.id.questionTitleText);
        questionTitleText.setText(Html.fromHtml("<font color='#000000'>4.请输入</font><font color='#eb4e4e'>[" + intent.getStringExtra(Constance.USERNAME) + "]</font><font color='#000000'>的电话号码</font>"));
        ListView listView = (ListView) findViewById(R.id.listView);
        Utils.setBackGround(listView, getResources().getDrawable(R.color.white)); //设置背景色
        telephoneText.setText(intent.getStringExtra(Constance.TELEPHONE)); //设置原手机号码
        listView.addHeaderView(headView, null, false); // 加载对话框);
        listView.setAdapter(null);
    }


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.red_btn: //下一步
                String telephone = telEdit.getText().toString().trim();
                if (StrUtil.isNull(telephone)) {
                    CommonMethod.makeNoticeShort(this, getString(R.string.input_mobile), CommonMethod.ERROR);
                    return;
                }
                if (!StrUtil.isMobileNum(telephone)) {
                    CommonMethod.makeNoticeShort(this, getString(R.string.input_sure_mobile), CommonMethod.ERROR);
                    return;
                }
                startValidate(getIntent().getStringExtra(Constance.SELECTED_IDS), getIntent().getStringExtra("token"), telephone);
        }
    }


    /**
     * 开始验证
     *
     * @param cids
     */
    private void startValidate(String cids, final String token, String telephone) {
        String httpUrl = NetWorkRequest.FIND_ACCOUNT_VALIDATION;
        RequestParams params = RequestParamsToken.getExpandRequestParams(getApplicationContext());
        params.addBodyParameter("token", token); //	v2/signup/findaccount返回的token
        params.addBodyParameter("cid", cids); //用户选择的cid
        params.addBodyParameter("telephone", telephone); //用户输入记工对象的电话号码
        final DiaLogRedLongProgress diaLogRedLongProgress = new DiaLogRedLongProgress(this, "正在验证...");
        diaLogRedLongProgress.show();
        CommonHttpRequest.commonRequest(this, httpUrl, FindPwdQuestion.class, CommonHttpRequest.OBJECT, params, false, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                diaLogRedLongProgress.dismissDialog();
                FindPwdQuestion question = (FindPwdQuestion) object;
                if (question.getIs_pass() == 1) { //验证通过
                    UpdateTelSecondActivity.actionStart(FindPwdStep4Activity.this, getIntent().getStringExtra(Constance.TELEPHONE), token);
                    setResult(1);
                    finish();
                } else { //验证未通过
                    DialogLeftRightBtnConfirm dialogLeftRightBtnConfirm = new DialogLeftRightBtnConfirm(
                            FindPwdStep4Activity.this, "验证失败", "如有疑问，请联系吉工家客服!", new DialogLeftRightBtnConfirm.LeftRightBtnListener() {
                        @Override
                        public void clickLeftBtnCallBack() { //重新验证
                            setResult(2);
                            finish();
                        }

                        @Override
                        public void clickRightBtnCallBack() { //联系客服
                            CallPhoneUtil.callPhone(FindPwdStep4Activity.this, "4008623818");
                        }
                    });
                    dialogLeftRightBtnConfirm.setLeftBtnText("重新验证");
                    dialogLeftRightBtnConfirm.setRightBtnText("联系客服");
                    dialogLeftRightBtnConfirm.show();
                }
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
                diaLogRedLongProgress.dismissDialog();
            }
        });
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
