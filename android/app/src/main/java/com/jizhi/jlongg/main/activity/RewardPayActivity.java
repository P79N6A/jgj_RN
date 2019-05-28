package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;
import android.support.v4.content.ContextCompat;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.google.gson.Gson;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.PayBean;
import com.jizhi.jlongg.main.bean.ProductInfo;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.ProductUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.jizhi.jlongg.x5webview.jsbridge.CallBackFunction;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;

/**
 * 奖励开发者
 *
 * @author Xuj
 * @time 2018年4月26日10:24:12
 * @Version 1.0
 */
public class RewardPayActivity extends BaseActivity implements View.OnClickListener {

    /**
     * 支付方式
     * 0 代表支付宝
     * 1 代表微信
     */
    private int payWay = ProductUtil.WX_PAY;
    /**
     * 支付宝,微信选中图标
     */
    private ImageView aliPayIcon, wxIcon;

    /**
     * 启动当前Activity
     *
     * @param context
     * @param money   奖励的金额
     * @param message 留言信息
     */
    public static void actionStart(Activity context, String money, String message) {
        Intent intent = new Intent(context, RewardPayActivity.class);
        intent.putExtra("param1", money);
        intent.putExtra("param2", message);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.reward_pay);
        initView();
        registerWXCallBack();
    }

    private void initView() {
        setTextTitle(R.string.reward);

        aliPayIcon = getImageView(R.id.aliPayIcon);
        wxIcon = getImageView(R.id.wxPayIcon);
        getTextView(R.id.totalPrice).setText("￥" + getIntent().getStringExtra("param1")); //设置奖励的金额
        TextView payState = getTextView(R.id.payState);
        payState.setText("奖励方式");
        payState.setTextColor(ContextCompat.getColor(getApplicationContext(), R.color.color_333333));
    }


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.payBtn://去奖励
                String httpUrl = NetWorkRequest.REWARD_COMMIT;
                RequestParams params = RequestParamsToken.getExpandRequestParams(this);
                params.addBodyParameter("suggest_msg", getIntent().getStringExtra("param2")); //留言信息
                params.addBodyParameter("pay_type", payWay + ""); //支付类型（1 - 微信，2 - 支付宝）
                params.addBodyParameter("amount", getIntent().getStringExtra("param1")); // 奖励金额(decimal类型 保留两位小数)
                CommonHttpRequest.commonRequest(this, httpUrl, ProductInfo.class, CommonHttpRequest.OBJECT, params, true, new CommonHttpRequest.CommonRequestCallBack() {
                    @Override
                    public void onSuccess(Object object) {
                        ProductInfo productInfo = (ProductInfo) object;
                        if (payWay == ProductUtil.WX_PAY) { //微信支付
                            ProductUtil.wxPayCallBack(productInfo.getRecord_id(), RewardPayActivity.this);
                        } else { //支付宝支付
                            ProductUtil.aliPayCallBack(productInfo.getRecord_id(), RewardPayActivity.this, new CallBackFunction() {
                                @Override
                                public void onCallBack(String data) {
                                    PayBean payBean = new Gson().fromJson(data, PayBean.class);
                                    if (payBean.getState() == 1) {
                                        CommonMethod.makeNoticeLong(getApplicationContext(), "奖励成功", CommonMethod.SUCCESS);
                                        finish();
                                    }
                                }
                            });
                        }
                    }

                    @Override
                    public void onFailure(HttpException exception, String errormsg) {

                    }
                });
                break;
            case R.id.wxPayLayout: //选择微信支付
                if (payWay == ProductUtil.WX_PAY) {
                    return;
                }
                aliPayIcon.setImageResource(R.drawable.checkbox_normal);
                wxIcon.setImageResource(R.drawable.checkbox_pressed);
                payWay = ProductUtil.WX_PAY;
                break;
            case R.id.aliPayLayout: //选择支付宝支付
                if (payWay == ProductUtil.ALI_PAY) {
                    return;
                }
                aliPayIcon.setImageResource(R.drawable.checkbox_pressed);
                wxIcon.setImageResource(R.drawable.checkbox_normal);
                payWay = ProductUtil.ALI_PAY;
                break;
        }
    }

    /**
     * 广播回调
     */
    class MessageBroadcast extends BroadcastReceiver {
        @Override
        public void onReceive(Context context, Intent intent) {
            String action = intent.getAction();
            if (action.equals(Constance.ACTION_MESSAGE_WXPAY_SUCCESS)) { //微信支付成功
                CommonMethod.makeNoticeLong(getApplicationContext(), "奖励成功", CommonMethod.SUCCESS);
                finish();
            }
        }
    }

    public void registerWXCallBack() {
        IntentFilter filter = new IntentFilter();
        filter.addAction(Constance.ACTION_MESSAGE_WXPAY_SUCCESS);
        receiver = new MessageBroadcast();
        registerLocal(receiver, filter);
    }
}