package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.GridView;
import android.widget.TextView;

import com.google.gson.Gson;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.adpter.NumberKeyBoardAdapter;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.BaseNetBean;
import com.jizhi.jlongg.main.dialog.DiaLogContactsUs;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.GetCodeUtil;
import com.jizhi.jlongg.main.util.RegisterTimerButton;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SingsHttpUtils;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.client.HttpRequest;

import java.util.ArrayList;
import java.util.List;

import static com.jizhi.jlongg.main.util.Constance.REQUEST;


/**
 * 修改手机号码第一步
 *
 * @author Xuj
 * @time 2017年3月24日16:17:28
 * @Version 1.0
 */
public class UpdateTelFirstActivity extends BaseActivity implements View.OnClickListener {

    /**
     * 键盘GridView
     */
    private GridView numberGridView;
    /**
     * 验证码第1、2、3、4个文本
     */
    private TextView firstNumber, secondNumber, threeNumber, fourNumber;
    /**
     * 下一步按钮
     */
    private Button nextBtn;
    /**
     * 获取验证码按钮
     */
    private Button getCodeBtn;
    /**
     * 原手机号码已不是我在使用 弹出框
     */
    private DiaLogContactsUs dialog;
    /**
     * 验证码倒计时
     */
    private RegisterTimerButton timer;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.update_telphone_first);
        initView();
    }


    /**
     * 启动当前Activity
     *
     * @param context
     */
    public static void actionStart(Activity context) {
        Intent intent = new Intent(context, UpdateTelFirstActivity.class);
        context.startActivityForResult(intent, REQUEST);
    }


    private void initView() {
        String telphone = UclientApplication.getTelephone(getApplicationContext()); //获取当前登录对象的电话号码
        if (TextUtils.isEmpty(telphone) || telphone.length() != 11) { //如果为空或者不等于11位则不让进入当前页面
            CommonMethod.makeNoticeShort(getApplicationContext(), "获取电话号码出错", CommonMethod.ERROR);
            finish();
            return;
        }
        TextView telephoneText = getTextView(R.id.telephoneText);
        telephoneText.setText(telphone);

        setTextTitle(R.string.update_telphone);
        nextBtn = getButton(R.id.nextBtn);
        getCodeBtn = getButton(R.id.getCodeBtn);
        firstNumber = getTextView(R.id.firstNumber);
        secondNumber = getTextView(R.id.secondNumber);
        threeNumber = getTextView(R.id.threeNumber);
        fourNumber = getTextView(R.id.fourNumber);
        numberGridView = (GridView) findViewById(R.id.gridView);
        final List<String> keyboardList = getKeyBoardData();
        NumberKeyBoardAdapter adapter = new NumberKeyBoardAdapter(this, keyboardList);
        adapter.setUpdateTelphone(true);

        numberGridView.setAdapter(adapter);
        numberGridView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                String keyboard = keyboardList.get(position);
                if (TextUtils.isEmpty(keyboard)) {
                    return;
                }
                if (keyboard.equals("删除")) {
                    if (!TextUtils.isEmpty(fourNumber.getText().toString())) {
                        fourNumber.setText("");
                        btnUnClick();
                        return;
                    }
                    if (!TextUtils.isEmpty(threeNumber.getText().toString())) {
                        threeNumber.setText("");
                        return;
                    }
                    if (!TextUtils.isEmpty(secondNumber.getText().toString())) {
                        secondNumber.setText("");
                        return;
                    }
                    if (!TextUtils.isEmpty(firstNumber.getText().toString())) {
                        firstNumber.setText("");
                        return;
                    }
                } else {
                    if (TextUtils.isEmpty(firstNumber.getText().toString())) {
                        firstNumber.setText(keyboard);
                        return;
                    }
                    if (TextUtils.isEmpty(secondNumber.getText().toString())) {
                        secondNumber.setText(keyboard);
                        return;
                    }
                    if (TextUtils.isEmpty(threeNumber.getText().toString())) {
                        threeNumber.setText(keyboard);
                        return;
                    }
                    if (TextUtils.isEmpty(fourNumber.getText().toString())) {
                        fourNumber.setText(keyboard);
                        btnCanClick();
                    }
                }
            }
        });
        timer = new RegisterTimerButton(60000, 1000, getCodeBtn, getResources());
    }

    /**
     * 设置下一步按钮不可点击 并且置灰
     */
    private void btnUnClick() {
        nextBtn.setClickable(false);
        Utils.setBackGround(nextBtn, getResources().getDrawable(R.drawable.draw_dis_app_btncolor_5radius));
    }

    /**
     * 设置下一步按钮可点击 并且置红
     */
    private void btnCanClick() {
        nextBtn.setClickable(true);
        Utils.setBackGround(nextBtn, getResources().getDrawable(R.drawable.draw_app_btncolor_5radius));
    }

    /**
     * 获取键盘数据
     *
     * @return
     */
    private List<String> getKeyBoardData() {
        List<String> number = new ArrayList<>();
        number.add("1");
        number.add("2");
        number.add("3");
        number.add("4");
        number.add("5");
        number.add("6");
        number.add("7");
        number.add("8");
        number.add("9");
        number.add("");
        number.add("0");
        number.add("删除");
        return number;
    }


    @Override
    public void onClick(View v) {
        //确定下一步
        switch (v.getId()) {
            case R.id.isMyTelphone: // 原手机号码已不是我在使用
                if (dialog == null) {
                    dialog = new DiaLogContactsUs(this);
                }
                dialog.show();
                break;
            case R.id.nextBtn: //下一步按钮
                String first = firstNumber.getText().toString().trim();
                String second = secondNumber.getText().toString().trim();
                String three = threeNumber.getText().toString().trim();
                String four = fourNumber.getText().toString().trim();
                if (TextUtils.isEmpty(first) || TextUtils.isEmpty(second) || TextUtils.isEmpty(three) || TextUtils.isEmpty(four)) {
                    CommonMethod.makeNoticeShort(this, getString(R.string.please_input_code_first), CommonMethod.ERROR);
                    return;
                }
                checkOldTelphone(first + second + three + four, UclientApplication.getTelephone(getApplicationContext()));
                break;
            case R.id.getCodeBtn: //获取验证码
                getCodeBtn.setClickable(false); //设置获取验证码按钮不可点击
                String telephone = UclientApplication.getTelephone(getApplicationContext());
                GetCodeUtil.getCode(this, telephone, Constance.UPDATE_TELPHONE_CODE, new GetCodeUtil.NetRequestListener() {
                    @Override
                    public void onFailure() {
                        getCodeBtn.setClickable(true);
                    }

                    @Override
                    public void onSuccess() {
                        if (timer != null) {
                            timer.start();
                        }
                    }
                });
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


    /**
     * 验证原手机号码
     *
     * @param vcode 验证码
     */
    public void checkOldTelphone(String vcode, String telphone) {
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        params.addBodyParameter("vcode", vcode);
        params.addBodyParameter("telph", telphone);
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.MODIFY_TELPHONE, params, new RequestCallBackExpand<String>() {
            @SuppressWarnings("deprecation")
            @Override
            public void onSuccess(ResponseInfo<String> responseInfo) {
                closeDialog();
                Gson gson = new Gson();
                try {
                    BaseNetBean base = gson.fromJson(responseInfo.result, BaseNetBean.class);
                    if (base.getState() == 0) {
                        CommonMethod.makeNoticeShort(getApplicationContext(), base.getErrmsg(), CommonMethod.ERROR);
                    } else {
                        UpdateTelSecondActivity.actionStart(UpdateTelFirstActivity.this, UclientApplication.getTelephone(getApplicationContext()), null);
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    CommonMethod.makeNoticeShort(getApplicationContext(), getString(R.string.service_err), CommonMethod.ERROR);
                }
            }
        });
    }
}