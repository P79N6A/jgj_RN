package com.jizhi.jlongg.main.activity.partner;

import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;
import android.text.Html;
import android.text.TextUtils;
import android.view.View;
import android.widget.ImageView;

import com.alipay.sdk.app.PayTask;
import com.google.gson.Gson;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.activity.X5WebViewActivity;
import com.jizhi.jlongg.main.bean.ProductInfo;
import com.jizhi.jlongg.main.bean.WxCallBack;
import com.jizhi.jlongg.main.bean.status.CommonJson;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DataUtil;
import com.jizhi.jlongg.main.util.ProductUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SingsHttpUtils;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.client.HttpRequest;
import com.tencent.mm.opensdk.modelpay.PayReq;
import com.tencent.mm.opensdk.openapi.IWXAPI;
import com.tencent.mm.opensdk.openapi.WXAPIFactory;

import util.PayResult;

/**
 * 功能:缴纳保证金
 * 时间:2017年7月18日14:33:41
 * 作者:xuj
 */
public class BailCashActivity extends BaseActivity implements View.OnClickListener {

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
     */
    public static void actionStart(Activity context) {
        Intent intent = new Intent(context, BailCashActivity.class);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.bail_cash);
        initView();
        registerWXCallBack();
    }

    public void registerWXCallBack() {
        IntentFilter filter = new IntentFilter();
        filter.addAction(Constance.ACTION_MESSAGE_WXPAY_SUCCESS);
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
            if (action.equals(Constance.ACTION_MESSAGE_WXPAY_SUCCESS)) { //微信支付成功
                paySuccess();
            }
        }
    }

    private void initView() {
        setTextTitle(R.string.bail_cash);
        aliPayIcon = getImageView(R.id.aliPayIcon);
        wxIcon = getImageView(R.id.wxPayIcon);
        getTextView(R.id.protcolText).setText(Html.fromHtml("<font color='#999999'>同意</font><font color='#333333'>" + "《城市合伙人协议》</font>"));
    }


    @Override
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.protcolText: //城市合伙人协议
                X5WebViewActivity.actionStart(this, NetWorkRequest.WEBURLS + "partner/agreement");
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
            case R.id.redBtn: //去支付按钮
                commitBail();
                break;
        }
    }

    /**
     * 提交保证金
     */
    public void commitBail() {
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        params.addBodyParameter("pay_type", payWay + "");
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.PAY_DEPOSIT,
                params, new RequestCallBackExpand<String>() {
                    @Override
                    public void onSuccess(ResponseInfo<String> responseInfo) {
                        try {
                            CommonJson<ProductInfo> base = CommonJson.fromJson(responseInfo.result, ProductInfo.class);
                            if (base.getState() != 0) {
                                if (payWay == ProductUtil.WX_PAY) { //微信支付
                                    wxPayCallBack(base.getValues().getRecord_id());
                                } else if (payWay == ProductUtil.ALI_PAY) { //支付宝支付
                                    aliPayCallBack(base.getValues().getRecord_id());
                                }
                            } else {
                                DataUtil.showErrOrMsg(BailCashActivity.this, base.getErrno(), base.getErrmsg());
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
     * 支付宝回调
     *
     * @param orderInfo
     */
    public void aliPayCallBack(final String orderInfo) {
        if (TextUtils.isEmpty(orderInfo)) {
            CommonMethod.makeNoticeShort(this, "获取订单信息失败", CommonMethod.ERROR);
            return;
        }
        Runnable payRunnable = new Runnable() {
            @Override
            public void run() {
                final PayResult payResult = new PayResult(new PayTask(BailCashActivity.this).payV2(Html.fromHtml(orderInfo).toString(), true));
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        /**
                         对于支付结果，请商户依赖服务端的异步通知结果。同步通知结果，仅作为支付结束的通知。
                         */
                        // 判断resultStatus 为9000则代表支付成功
                        if (TextUtils.equals(payResult.getResultStatus(), "9000")) {
                            paySuccess();
                        } else {
                            // 该笔订单真实的支付结果，需要依赖服务端的异步通知。
                        }
                    }
                });
            }
        };
        Thread payThread = new Thread(payRunnable);
        payThread.start();
    }

    public void wxPayCallBack(final String orderInfo) {
        if (TextUtils.isEmpty(orderInfo)) {
            CommonMethod.makeNoticeShort(this, "获取订单信息失败", CommonMethod.ERROR);
            return;
        }
        try {
            Gson gson = new Gson();
            WxCallBack wxCallBack = gson.fromJson(orderInfo, WxCallBack.class);
            IWXAPI api = WXAPIFactory.createWXAPI(this, wxCallBack.getAppid());
            api.registerApp(wxCallBack.getAppid());
            PayReq req = new PayReq();
            req.appId = wxCallBack.getAppid();// 微信开放平台审核通过的应用APPID
            req.partnerId = wxCallBack.getPartnerid();// 微信支付分配的商户号
            req.prepayId = wxCallBack.getPrepayid();// 预支付订单号，app服务器调用“统一下单”接口获取
            req.nonceStr = wxCallBack.getNoncestr();// 随机字符串，不长于32位，服务器小哥会给咱生成
            req.timeStamp = wxCallBack.getTimestamp();// 时间戳，app服务器小哥给出
            req.packageValue = wxCallBack.getPackage_name();// 固定值Sign=WXPay，可以直接写死，服务器返回的也是这个固定值
            req.sign = wxCallBack.getSign();// 签名，服务器小哥给出，他会根据：https://pay.weixin.qq.com/wiki/doc/api/app/app.php?chapter=4_3指导得到这个
//				req.extData = "app data"; // optional
            // 在支付之前，如果应用没有注册到微信，应该先调用IWXMsg.registerApp将应用注册到微信
            api.sendReq(req);
        } catch (Exception e) {
            e.printStackTrace();
            CommonMethod.makeNoticeShort(this, e.getMessage(), CommonMethod.ERROR);
        }
    }

    /**
     * 支付成功的回调
     */
    private void paySuccess() {
        setResult(ProductUtil.PAID_BAILCACH);
        finish();
    }
}
