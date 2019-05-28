package com.jizhi.jlongg.wxapi;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Intent;
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
import com.umeng.socialize.UMAuthListener;
import com.umeng.socialize.UMShareAPI;
import com.umeng.socialize.bean.SHARE_MEDIA;
import com.umeng.socialize.utils.SocializeUtils;

import org.json.JSONObject;

import java.util.Map;

/**
 * Created by Administrator on 2018-3-14.
 */

public class WXUtil {
    private Activity context;
    private ProgressDialog dialog;

    /**
     * 发起微信的登录，获取一些账户信息如名称、头像等
     */
    public void sendWXLogin(final Activity context) {
        dialog = new ProgressDialog(context);
        this.context = context;
        if (!UMShareAPI.get(context).isInstall(context, SHARE_MEDIA.WEIXIN)) {
            CommonMethod.makeNoticeShort(context, "未检测到“微信”应用，请通过手机号登录", CommonMethod.ERROR);
            return;
        }

        UMShareAPI.get(context).doOauthVerify(context, SHARE_MEDIA.WEIXIN, new UMAuthListener() {
            @Override
            public void onStart(SHARE_MEDIA platform) {
                SocializeUtils.safeShowDialog(dialog);
            }

            @Override
            public void onComplete(SHARE_MEDIA platform, int action, Map<String, String> data) {
                SocializeUtils.safeCloseDialog(dialog);
//                LUtils.e(new Gson().toJson(data) + ",,,,,,,,微信成功了,,,,,,,");
                String openid = data.get("openid");//openid
                String access_token = data.get("access_token");//access_token
//                LUtils.e(new Gson().toJson(data) + ",,,,,,,,微信成功了,,,,,,," + openid + ",,,," + access_token);
                getUserMesg(access_token, openid);

            }

            @Override
            public void onError(SHARE_MEDIA platform, int action, Throwable t) {
                SocializeUtils.safeCloseDialog(dialog);
                LUtils.e("失败：" + t.getMessage());
            }

            @Override
            public void onCancel(SHARE_MEDIA platform, int action) {
                SocializeUtils.safeCloseDialog(dialog);
                LUtils.e("取消了");
            }
        });
    }

    /**
     * 获取openid accessToken值用于后期操作
     *
     * @param code 请求码
     */
    private void getAccess_token(final String code) {
        String url = "https://api.weixin.qq.com/sns/oauth2/access_token?appid=" + Constance.APP_ID + "&secret=" + Constance.APP_SECRET + "&code=" + code + "&grant_type=authorization_code";
        RequestParams params = RequestParamsToken.getExpandRequestParams(context);
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
                    context.finish();
                }
            }

            @Override
            public void onFailure(HttpException e, String s) {
                context.finish();
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
        RequestParams params = RequestParamsToken.getExpandRequestParams(context);
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
                        LocalBroadcastManager.getInstance(context).sendBroadcast(intent);
                        LUtils.e("getUserMesg 拿到了用户Wx基本信息.. nickname:" + nickname + "         sex:" + sex + "        headimgurl:" + headImagePath + "  unionid:" + unionid);
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
//                finally {
//                    context.finish();
//                }
            }

            @Override
            public void onFailure(HttpException e, String s) {
//                context.finish();
            }
        });
    }
}
