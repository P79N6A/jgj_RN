package com.jizhi.jlongg.wxapi;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.content.LocalBroadcastManager;
import android.text.TextUtils;

import com.google.gson.Gson;
import com.hcs.uclient.utils.LUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.PayBean;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.reactnative.MyNativeModule;
import com.tencent.mm.opensdk.constants.ConstantsAPI;
import com.tencent.mm.opensdk.modelbase.BaseReq;
import com.tencent.mm.opensdk.modelbase.BaseResp;
import com.tencent.mm.opensdk.openapi.IWXAPI;
import com.tencent.mm.opensdk.openapi.IWXAPIEventHandler;
import com.tencent.mm.opensdk.openapi.WXAPIFactory;

public class WXPayEntryActivity extends Activity implements IWXAPIEventHandler {

    private IWXAPI api;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.pay_result);
        api = WXAPIFactory.createWXAPI(this, Constance.APP_ID);
        api.handleIntent(getIntent(), this);
    }

    @Override
    protected void onNewIntent(Intent intent) {
        super.onNewIntent(intent);
        setIntent(intent);
        api.handleIntent(intent, this);
    }

    @Override
    public void onReq(BaseReq req) {

    }

    @Override
    public void onResp(BaseResp resp) {
        //回调中errCode值列表：
        // 0 支付成功
        // -1 发生错误 可能的原因：签名错误、未注册APPID、项目设置APPID不正确、注册的APPID与设置的不匹配、其他异常等。
        // -2 用户取消 发生场景：用户不支付了，点击取消，返回APP。
        if (resp.getType() == ConstantsAPI.COMMAND_PAY_BY_WX) {
            if (resp.errCode == 0) { //支付成功
                LUtils.e("-------支付成功------");
                Intent intent = new Intent(Constance.ACTION_MESSAGE_WXPAY_SUCCESS);
                intent.putExtra("code", 1);
                LocalBroadcastManager.getInstance(this).sendBroadcast(intent);
                payCallbackRN(true);
            } else { //支付失败
                LUtils.e("-------支付失败------");
                Intent intent = new Intent(Constance.ACTION_MESSAGE_WXPAY_FAIL);
                intent.putExtra("code", 0);
                LocalBroadcastManager.getInstance(this).sendBroadcast(intent);
                payCallbackRN(false);
            }
            finish();
        }
    }

    /**
     * 支付成功回调rn
     *
     * @param isSuccess
     */
    public void payCallbackRN(boolean isSuccess) {
        if (null != MyNativeModule.payCallback) {
            PayBean payBean = new PayBean();
            payBean.setState(isSuccess ? 1 : 0);
            payBean.setPay_type(1);
            MyNativeModule.payCallback.invoke(new Gson().toJson(payBean));
            MyNativeModule.payCallback=null;
        }
    }
}