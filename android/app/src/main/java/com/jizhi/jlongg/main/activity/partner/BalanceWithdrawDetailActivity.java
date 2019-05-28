package com.jizhi.jlongg.main.activity.partner;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.content.ContextCompat;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.View;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.TextView;

import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.BalanceWithdrawAccount;
import com.jizhi.jlongg.main.bean.BaseNetBean;
import com.jizhi.jlongg.main.bean.status.CommonJson;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DataUtil;
import com.jizhi.jlongg.main.util.GetCodeUtil;
import com.jizhi.jlongg.main.util.LoginTimer;
import com.jizhi.jlongg.main.util.ProductUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SingsHttpUtils;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.client.HttpRequest;

import java.util.Timer;
import java.util.TimerTask;

/**
 * CName:合伙人 -->余额提现
 * User: xuj
 * Date: 2017年7月20日
 * Time: 14:19:10
 */
public class BalanceWithdrawDetailActivity extends BaseActivity implements View.OnClickListener {

    /**
     * 提现输入框
     */
    private EditText zfbEdit;
    /**
     * 验证码倒计时
     */
    private LoginTimer timer;
    /**
     * 获取验证码按钮
     */
    private TextView getCodeBtn;
    /**
     * 验证码输入框
     */
    private EditText codeEdit;
    /**
     * 税金金额
     */
    private TextView expensesOfTaxation;
    /**
     * 税后金额
     */
    private TextView afterTaxAmount;
    /**
     * 能提现的最大金额
     */
    private float amount;


    /**
     * 启动当前Activity
     *
     * @param context
     * @param balanceWithdrawAccount 提现账户信息
     */
    public static void actionStart(Activity context, BalanceWithdrawAccount balanceWithdrawAccount) {
        Intent intent = new Intent(context, BalanceWithdrawDetailActivity.class);
        intent.putExtra(Constance.BEAN_CONSTANCE, balanceWithdrawAccount);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.balance_withdraw_detail);
        initView();
        initCode();
    }

    private void initCode() {
        //但有时，我们确实是想让EditText自动获得焦点并弹出软键盘，在设置了EditText自动获得焦点后，
        // 软件盘不会弹出。注意：此时是由于刚跳到一个新的界面，界面未加载完全而无法弹出软键盘。
        // 此时应该适当的延迟弹出软键盘，如500毫秒（保证界面的数据加载完成，如果500毫秒仍未弹出，
        // 则延长至500毫秒）。可以在EditText后面加上一段代码，实例代码如下：
        timer = new LoginTimer(60000, 1000, getCodeBtn, getResources());
    }

    private void initView() {
        Intent intent = getIntent();
        BalanceWithdrawAccount balanceWithdrawAccount = (BalanceWithdrawAccount) intent.getSerializableExtra(Constance.BEAN_CONSTANCE);
        if (balanceWithdrawAccount == null) {
            CommonMethod.makeNoticeLong(getApplicationContext(), "获取账户信息出错", CommonMethod.ERROR);
            finish();
            return;
        }

        setTextTitle(R.string.balance_withdrawa);
        TextView useStateText = getTextView(R.id.useStateText); //使用状态
        TextView accountNameText = getTextView(R.id.accountNameText); //账户名称
        TextView telephoneText = getTextView(R.id.telephone); //手机号
        expensesOfTaxation = getTextView(R.id.expensesOfTaxation);
        afterTaxAmount = getTextView(R.id.afterTaxAmount);
        codeEdit = getEditText(R.id.codeEdit);
        getCodeBtn = getTextView(R.id.getCodeBtn);
        zfbEdit = getEditText(R.id.zfbEdit);
        ImageView payIcon = getImageView(R.id.payIcon); //支付状态图片

        amount = balanceWithdrawAccount.getAmount();
        zfbEdit.setHint(String.format(getString(R.string.balance), Utils.m2(amount)));
        accountNameText.setText(balanceWithdrawAccount.getAccount_name());
        telephoneText.setText(UclientApplication.getTelephone(this));
        if (balanceWithdrawAccount.getPay_type() == ProductUtil.WX_PAY) { //微信支付
            payIcon.setImageResource(R.drawable.wechat_big_icon);
            useStateText.setText("已绑定");
            useStateText.setTextColor(ContextCompat.getColor(this, R.color.color_999999));
        } else if (balanceWithdrawAccount.getPay_type() == ProductUtil.ALI_PAY) { //支付宝支付
            payIcon.setImageResource(R.drawable.zhifubao_big_icon);
            useStateText.setVisibility(View.GONE);
        }
        zfbEdit.addTextChangedListener(new TextWatcher() {

            private String beforeText;

            @Override
            public void beforeTextChanged(CharSequence charSequence, int i, int i1, int i2) {
                beforeText = charSequence.toString();
            }

            @Override
            public void onTextChanged(CharSequence charSequence, int i, int i1, int i2) {
                String number = charSequence.toString();
                if (!TextUtils.isEmpty(number)) {
                    if (number.contains(".")) { //只能输入两位数的小数
                        int index = number.indexOf(".");
                        if (index + 3 < number.length()) {
                            zfbEdit.setText(beforeText);
                            return;
                        }
                    }
                    if (number.startsWith("0") && number.length() > 1 && number.substring(1, 2).matches("[0-9]")) { //不能输入 00 01 02 03..09  的这种情况
                        zfbEdit.setText("0");
                        return;
                    }
                    float price = Float.parseFloat(number);
                    if (price > amount) { //如果超过了能提现的最大金额 则设置为能提取的最大金额
                        zfbEdit.setText(amount + "");
                        return;
                    }
                    zfbEdit.setSelection(zfbEdit.getText().length());
                    calculateMoney(price);
                } else {
                    calculateMoney(0);
                }
            }

            @Override
            public void afterTextChanged(Editable editable) {

            }
        });
    }

    /**
     * 计算金额
     *
     * @param price
     */
    private void calculateMoney(float price) {
        if (price <= 0) {
            expensesOfTaxation.setText("- 元");
            afterTaxAmount.setText("- 元");
        } else {
            float afterExpensesPrice = price * 0.12F;//税后金额
            expensesOfTaxation.setText(Utils.m2(afterExpensesPrice) + " 元");
            afterTaxAmount.setText(Utils.m2(price - afterExpensesPrice) + " 元");
        }
    }

    /**
     * 获取验证码
     */
    private void getCode() {
        GetCodeUtil.getCode(this, UclientApplication.getTelephone(this), Constance.CASH, new GetCodeUtil.NetRequestListener() {
            @Override
            public void onFailure() {
                getCodeBtn.setClickable(true);
            }

            @Override
            public void onSuccess() {
                if (timer != null) {
                    timer.start();
                    getCodeBtn.requestFocus();
                    new Timer().schedule(new TimerTask() {
                        public void run() {
                            showSoftKeyboard(codeEdit);
                        }
                    }, 200);
                }
            }
        });
    }

    @Override
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.otherAccount://其他账户
                finish();
                break;
            case R.id.redBtn: //确认提现
                String editValue = zfbEdit.getText().toString();
                if (TextUtils.isEmpty(editValue) || editValue.endsWith(".")) {
                    CommonMethod.makeNoticeShort(this, "仅能输入数字,正数,小数点后面允许2位", CommonMethod.ERROR);
                    return;
                }
                float balanceValue = Float.parseFloat(editValue); //提现金额
                if (balanceValue < 1) {
                    CommonMethod.makeNoticeShort(getApplicationContext(), "提现金额必须大于等于1元", CommonMethod.ERROR);
                    return;
                }
                if (balanceValue > 999999) {
                    CommonMethod.makeNoticeShort(getApplicationContext(), "最多允许输入十万级别,例如999999.00", CommonMethod.ERROR);
                    return;
                }
                String codeValue = codeEdit.getText().toString(); // 验证码
                if (TextUtils.isEmpty(codeValue)) {
                    CommonMethod.makeNoticeShort(this, getString(R.string.input_message_code), CommonMethod.ERROR);
                    return;
                }
                BalanceWithdrawAccount balanceWithdrawAccount = (BalanceWithdrawAccount) getIntent().getSerializableExtra(Constance.BEAN_CONSTANCE);
                confirmWithdraw(codeValue, zfbEdit.getText().toString(), balanceWithdrawAccount.getId() + "", balanceWithdrawAccount.getPay_type());
                break;
            case R.id.getCodeBtn:
                getCode();
                break;
        }
    }


    /**
     * 确认提现
     *
     * @param code        验证码
     * @param totalAmount 取款金额
     * @param accountId   账户id
     * @param payWay      提现方式
     */
    public void confirmWithdraw(String code, String totalAmount, String accountId, int payWay) {
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        params.addBodyParameter("total_amount", totalAmount); //税前金额
        params.addBodyParameter("account_id", accountId); //提现账户的id
        params.addBodyParameter("vcode", code); //	验证码
        params.addBodyParameter("pay_type", payWay + ""); //	1微信；2支付宝
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.GET_MONEY_FROM_BALANCE,
                params, new RequestCallBackExpand<String>() {
                    @Override
                    public void onSuccess(ResponseInfo<String> responseInfo) {
                        try {
                            CommonJson<BaseNetBean> base = CommonJson.fromJson(responseInfo.result, BaseNetBean.class);
                            if (base.getState() != 0) {
                                CommonMethod.makeNoticeShort(getApplicationContext(), "提现成功", CommonMethod.SUCCESS);
                                setResult(Constance.BALANCE_WITHDRAW_SUCCESS);
                                finish();
                            } else {
                                DataUtil.showErrOrMsg(BalanceWithdrawDetailActivity.this, base.getErrno(), base.getErrmsg());
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                            CommonMethod.makeNoticeShort(getApplicationContext(), getString(R.string.service_err), CommonMethod.ERROR);
                        } finally {
                            closeDialog();
                        }
                    }
                });
    }
}
