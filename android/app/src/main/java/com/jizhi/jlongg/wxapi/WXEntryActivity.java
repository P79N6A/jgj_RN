
package com.jizhi.jlongg.wxapi;


import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.content.LocalBroadcastManager;

import com.hcs.uclient.utils.LUtils;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SingsHttpUtils;
import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.callback.RequestCallBack;
import com.lidroid.xutils.http.client.HttpRequest;
import com.tencent.mm.opensdk.modelbase.BaseReq;
import com.tencent.mm.opensdk.modelbase.BaseResp;
import com.tencent.mm.opensdk.modelmsg.SendAuth;
import com.tencent.mm.opensdk.openapi.IWXAPI;
import com.tencent.mm.opensdk.openapi.IWXAPIEventHandler;
import com.tencent.mm.opensdk.openapi.WXAPIFactory;

import org.json.JSONObject;

/**
 * 微信分享 实体回调类
 *
 * @author Xuj
 * @time 2015年11月28日 11:05:29
 * @Version 1.0
 */
public class WXEntryActivity extends Activity implements IWXAPIEventHandler {

    private IWXAPI mApi;

    private static final int RETURN_MSG_TYPE_LOGIN = 1;
    private static final int RETURN_MSG_TYPE_SHARE = 2;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mApi = WXAPIFactory.createWXAPI(this, Constance.APP_ID, true);
        mApi.handleIntent(this.getIntent(), WXEntryActivity.this);
    }

    @Override
    public void onReq(BaseReq baseReq) {

    }

    // 第三方应用发送到微信的请求处理后的响应结果，会回调到该方法
    @Override
    public void onResp(BaseResp resp) {

        LUtils.e("resp.errCode" + resp.errCode + "       type:" + resp.getType());
        switch (resp.errCode) {
            case BaseResp.ErrCode.ERR_AUTH_DENIED://发送被拒绝
            case BaseResp.ErrCode.ERR_USER_CANCEL://发送取消
//                if (RETURN_MSG_TYPE_SHARE == resp.getType()) {
//                    Toast.makeText(this, "分享失败", Toast.LENGTH_SHORT).show();
//                } else {
//                    Toast.makeText(this, "登录失败", Toast.LENGTH_SHORT).show();
//                }
                finish();
                break;
            case BaseResp.ErrCode.ERR_OK://发送成功
                switch (resp.getType()) {
                    case RETURN_MSG_TYPE_LOGIN:
                        // 拿到了微信返回的code,立马再去请求access_token
                        String code = ((SendAuth.Resp) resp).code;
                        getAccess_token(code);
                        break;
                    case RETURN_MSG_TYPE_SHARE:
                        CommonMethod.makeNoticeLong(this, "微信分享成功", CommonMethod.SUCCESS);
                        finish();
                        break;
                }
                break;
        }
    }

    /**
     * 获取openid accessToken值用于后期操作
     *
     * @param code 请求码
     */
    private void getAccess_token(final String code) {
        String url = "https://api.weixin.qq.com/sns/oauth2/access_token?appid=" + Constance.APP_ID + "&secret=" + Constance.APP_SECRET + "&code=" + code + "&grant_type=authorization_code";
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.GET, url, params, new RequestCallBack<String>() {
            @Override
            public void onSuccess(ResponseInfo<String> responseInfo) {
                try {
                    JSONObject jsonObject = new JSONObject(responseInfo.result);
                    if (null != jsonObject) {
                        String openid = jsonObject.getString("openid").toString().trim();
                        String access_token = jsonObject.getString("access_token").toString().trim();
                        getUserMesg(access_token, openid);
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    finish();
                }
            }

            @Override
            public void onFailure(HttpException e, String s) {
                finish();
            }
        });
    }

    /**
     * 获取微信的个人信息
     *
     * @param access_token
     * @param openid
     */
    private void getUserMesg(final String access_token, final String openid) {
        String url = "https://api.weixin.qq.com/sns/userinfo?access_token=" + access_token + "&openid=" + openid;
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.GET, url, params, new RequestCallBack<String>() {
            @Override
            public void onSuccess(ResponseInfo<String> responseInfo) {
                try {
                    JSONObject jsonObject = new JSONObject(responseInfo.result);
                    if (null != jsonObject) {
                        String nickname = jsonObject.getString("nickname"); //用户昵称
                        String headImagePath = jsonObject.getString("headimgurl"); //用户头像
                        String unionid = jsonObject.getString("unionid");//微信唯一id
                        int sex = Integer.parseInt(jsonObject.get("sex").toString()); //用户性别
                        Intent intent = new Intent();
                        intent.putExtra(Constance.USERNAME, nickname);
                        intent.putExtra(Constance.HEAD_IMAGE, headImagePath);
                        intent.putExtra("openId", openid);
                        intent.putExtra("unionid", unionid);
                        intent.setAction(Constance.ACTION_GET_WX_USERINFO);
                        LocalBroadcastManager.getInstance(WXEntryActivity.this).sendBroadcast(intent);
                        LUtils.e("getUserMesg 拿到了用户Wx基本信息.. nickname:" + nickname + "         sex:" + sex + "        headimgurl:" + headImagePath + "  unionid:" + unionid);
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    finish();
                }
            }

            @Override
            public void onFailure(HttpException e, String s) {
                finish();
            }
        });
    }
}
