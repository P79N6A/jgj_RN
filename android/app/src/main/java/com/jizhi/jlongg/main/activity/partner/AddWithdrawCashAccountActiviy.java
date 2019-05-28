package com.jizhi.jlongg.main.activity.partner;

import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.bean.BalanceWithdrawAccount;
import com.jizhi.jlongg.main.bean.status.CommonJson;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.ProductUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SingsHttpUtils;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.jizhi.jlongg.wxapi.WXUtil;
import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.client.HttpRequest;
import com.nineoldandroids.animation.AnimatorSet;
import com.nineoldandroids.animation.ObjectAnimator;

/**
 * CName:合伙人 -->添加提现账户
 * User: hcs
 * Date: 2017年7月20日
 * Time: 9:51:45
 */
public class AddWithdrawCashAccountActiviy extends BaseActivity implements View.OnClickListener {

    /**
     * 当前选择支付的方式
     */
    private int selectePayWay = ProductUtil.ALI_PAY;
    /**
     * 支付宝、微信图标
     */
    private ImageView aliPayIcon, wxPayIcon;
    /**
     * 红色提交按钮
     */
    private Button redBtn;
    /**
     * 支付宝账户输入框
     */
    private EditText zfbEdit;

    /**
     * 启动当前Activity
     *
     * @param context
     */
    public static void actionStart(Activity context) {
        Intent intent = new Intent(context, AddWithdrawCashAccountActiviy.class);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.add_withdraw_cash_account);
        initView();
        registerWXCallBack();
    }

    public void registerWXCallBack() {
        IntentFilter filter = new IntentFilter();
        filter.addAction(Constance.ACTION_GET_WX_USERINFO);
        receiver = new MessageBroadcast();
        registerLocal(receiver, filter);
    }

    /**
     * 广播回调
     */
    class MessageBroadcast extends BroadcastReceiver {
        @Override
        public void onReceive(Context context, Intent intent) {
            String action = intent.getAction();
            if (action.equals(Constance.ACTION_GET_WX_USERINFO)) { //微信绑定成功
                String userName = intent.getStringExtra(Constance.USERNAME);
                String openId = intent.getStringExtra("openId"); //微信openId
                if (!TextUtils.isEmpty(userName)) {
                    bingAccount(userName, openId);
                }
            }
        }
    }

    private void initView() {
        setTextTitle(R.string.add_withdraw_cash_account);
        redBtn = getButton(R.id.redBtn);
        aliPayIcon = getImageView(R.id.aliPayIcon);
        wxPayIcon = getImageView(R.id.wxPayIcon);
        zfbEdit = getEditText(R.id.zfbEdit);
        findViewById(R.id.aliPayLayout).setOnClickListener(this);
        findViewById(R.id.wxPayLayout).setOnClickListener(this);
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.aliPayLayout:
                if (selectePayWay == ProductUtil.ALI_PAY) {
                    return;
                }
                setAliPay(true);
                break;
            case R.id.wxPayLayout:
                if (selectePayWay == ProductUtil.WX_PAY) {
                    return;
                }
                setWxPay(true);
                break;
            case R.id.redBtn:
                switch (selectePayWay) {
                    case ProductUtil.ALI_PAY: //支付宝支付
                        String accountName = zfbEdit.getText().toString();
                        if (TextUtils.isEmpty(accountName)) {
                            CommonMethod.makeNoticeShort(getApplicationContext(), "请输入支付宝账号", CommonMethod.ERROR);
                            return;
                        }
                        bingAccount(accountName, null);
                        break;
                    case ProductUtil.WX_PAY: //微信支付
                        new WXUtil().sendWXLogin(this);
                        break;
                }
                break;
        }
    }


    /**
     * 绑定账户
     *
     * @param accountName 账户名称
     * @param openId      openId
     */
    public void bingAccount(String accountName, String openId) {
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        params.addBodyParameter("pay_type", selectePayWay + ""); //支付类型1：微信；2：支付宝
        params.addBodyParameter("account_name", accountName); //账户
        if (selectePayWay == ProductUtil.WX_PAY) {
            params.addBodyParameter("open_id", openId); //微信openId
        }
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.ADDPARTNERWITHDRAWTELE,
                    params, new RequestCallBackExpand<String>() {
                        @Override
                        public void onSuccess(ResponseInfo<String> responseInfo) {
                            try {
                                CommonJson<BalanceWithdrawAccount> base = CommonJson.fromJson(responseInfo.result, BalanceWithdrawAccount.class);
                                if (base.getState() != 0) {
                                    Intent intent = getIntent();
                                    intent.putExtra(Constance.BEAN_CONSTANCE, base.getValues());
                                    setResult(Constance.BIND_ACCOUNT_SUCCESS, intent);
                                    finish();
                                } else {
                                    CommonMethod.makeNoticeShort(getApplicationContext(), base.getErrmsg(), CommonMethod.ERROR);
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


    /**
     * 设置微信支付方式
     *
     * @param isSelecte 是否选中
     */
    private void setWxPay(boolean isSelecte) {
        float start = isSelecte ? 0.7F : 1.0F;
        float end = isSelecte ? 1.0F : 0.7F;
        AnimatorSet animSet = new AnimatorSet();
        // 将一个TextView沿垂直方向先从原大小（1f）放大到5倍大小（5f），然后再变回原大小。
        ObjectAnimator view1AnimX = ObjectAnimator.ofFloat(wxPayIcon, "scaleX", start, end);
        ObjectAnimator view1AnimY = ObjectAnimator.ofFloat(wxPayIcon, "scaleY", start, end);
        animSet.play(view1AnimX).with(view1AnimY); //按顺序执行动画1、2、3
        animSet.setDuration(500);
        animSet.start();
        if (isSelecte) {
            selectePayWay = ProductUtil.WX_PAY;
            zfbEdit.setVisibility(View.GONE);
            redBtn.setText("立即绑定微信");
            setAliPay(false);
        }
    }

    /**
     * 设置支付宝支付方式
     *
     * @param isSelecte 是否选中
     */
    private void setAliPay(boolean isSelecte) {
        float start = isSelecte ? 0.7F : 1.0F;
        float end = isSelecte ? 1.0F : 0.7F;
        AnimatorSet animSet = new AnimatorSet();
        // 将一个TextView沿垂直方向先从原大小（1f）放大到5倍大小（5f），然后再变回原大小。
        ObjectAnimator view1AnimX = ObjectAnimator.ofFloat(aliPayIcon, "scaleX", start, end);
        ObjectAnimator view1AnimY = ObjectAnimator.ofFloat(aliPayIcon, "scaleY", start, end);
        animSet.play(view1AnimX).with(view1AnimY); //按顺序执行动画1、2、3
        animSet.setDuration(500);
        animSet.start();
        if (isSelecte) {
            selectePayWay = ProductUtil.ALI_PAY;
            redBtn.setText(getString(R.string.save));
            zfbEdit.setVisibility(View.VISIBLE);
            setWxPay(false);
        }
    }
}
