package com.jizhi.jlongg.main.util.request;

import android.content.Context;
import android.content.Intent;
import android.support.v4.content.LocalBroadcastManager;
import android.text.TextUtils;

import com.google.gson.Gson;
import com.hcs.uclient.utils.AppUtils;
import com.hcs.uclient.utils.LUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.Banner;
import com.jizhi.jlongg.main.bean.BaseNetBean;
import com.jizhi.jlongg.main.bean.BaseNetNewBean;
import com.jizhi.jlongg.main.bean.LoginStatu;
import com.jizhi.jlongg.main.bean.PersonBean;
import com.jizhi.jlongg.main.bean.status.CommonJson;
import com.jizhi.jlongg.main.bean.status.CommonListJson;
import com.jizhi.jlongg.main.bean.status.CommonNewJson;
import com.jizhi.jlongg.main.bean.status.CommonNewListJson;
import com.jizhi.jlongg.main.dialog.CustomProgress;
import com.jizhi.jlongg.main.util.CheckListHttpUtils;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DataUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SingsHttpUtils;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.HttpHandler;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.callback.RequestCallBack;
import com.lidroid.xutils.http.client.HttpRequest;

import static com.hcs.uclient.utils.SPUtils.put;

/**
 * Created by Administrator on 2017/9/26 0026.
 */

public class CommonHttpRequest {


    public static boolean LIST = true;
    public static boolean OBJECT = false;

    /**
     * 获取Banner或者广告位
     * Banner图
     *
     * @param activity
     * @param ad_id    6、表示个人端Banner 7、表示企业banner   8、表示企业广告位  9、表示个人广告位
     * @param callBack 数据加载成功后的回调
     */
    public static void getAppBanner(final BaseActivity activity, int ad_id, final CheckListHttpUtils.CommonRequestCallBack callBack) {
        String URL = NetWorkRequest.BANNER;
        RequestParams params = RequestParamsToken.getExpandRequestParams(activity);
        params.addBodyParameter("ad_id", ad_id + "");// 广告位ID
        params.addBodyParameter("os", "A");// 系统代码
        params.addBodyParameter("client", AppUtils.getImei(activity));
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, URL, params, new RequestCallBack<String>() {
            @Override
            public void onSuccess(ResponseInfo<String> responseInfo) {
                try {
                    CommonJson<Banner> base = CommonJson.fromJson(responseInfo.result, Banner.class);
                    if (base.getState() != 0) {
                        if (callBack != null) {
                            callBack.onSuccess(base.getValues());
                        }
                    } else {
                        if (callBack != null) {
                            callBack.onFailure(null, null);
                        }
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }

            @Override
            public void onFailure(HttpException e, String s) {
                if (callBack != null) {
                    callBack.onFailure(null, null);
                }
            }
        });
    }


    /**
     * 添加记账成员
     *
     * @param activity
     * @param userName     用户名称
     * @param telphone     用户电话
     * @param isContractor true表示添加承包对象
     * @param listener     回调
     */
    public static void addAccountPerson(final BaseActivity activity, String userName, String telphone, boolean isContractor, final CommonRequestCallBack listener) {
        RequestParams params = RequestParamsToken.getExpandRequestParams(activity);
        params.addBodyParameter("name", userName); //姓名
        params.addBodyParameter("telph", telphone); //电话号码
        if (isContractor) { //承包对象
            params.addBodyParameter("contractor_type", "1");
        }
        String httpUrl = NetWorkRequest.ADD_PERSON;
        CommonHttpRequest.commonRequest(activity, httpUrl, PersonBean.class, CommonHttpRequest.OBJECT, params, true, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                if (listener != null) {
                    listener.onSuccess(object);
                }
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {

            }
        });
    }


    /**
     * 普通登录验证
     *
     * @param activity
     * @param telPhone 电话号码
     * @param vcode    验证码
     * @param callBack 登录成功后的回调函数
     */
    public static void login(final BaseActivity activity, String telPhone, String vcode, final CheckListHttpUtils.CommonRequestCallBack callBack) {
        RequestParams params = RequestParamsToken.getExpandRequestParams(activity);
        params.addBodyParameter("os", "A");// 密码
        params.addBodyParameter("role", UclientApplication.getRoler(activity.getApplicationContext()));// 角色
        params.addBodyParameter("telph", telPhone);// 用户名
        params.addBodyParameter("vcode", vcode);// 验证码
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.LOGIN, params, activity.new RequestCallBackExpand<String>() {
            @Override
            public void onSuccess(ResponseInfo<String> responseInfo) {
                try {
                    CommonJson<LoginStatu> base = CommonJson.fromJson(responseInfo.result, LoginStatu.class);
                    if (base.getState() != 0) {
                        LoginStatu loginStatu = base.getValues();
                        //放置一些基本信息 如头像、姓名、是否已经完善姓名等资料
                        DataUtil.putUserLoginInfo(activity.getApplicationContext(), loginStatu);
                        if (callBack != null) {
                            callBack.onSuccess(loginStatu);
                        }
                    } else {
                        CommonMethod.makeNoticeShort(activity, base.getErrmsg(), CommonMethod.ERROR);
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    CommonMethod.makeNoticeShort(activity, activity.getString(R.string.service_err), CommonMethod.ERROR);
                } finally {
                    activity.closeDialog();
                }
            }
        });
    }

    /**
     * 普通登录验证
     *
     * @param activity
     * @param wechatid 微信唯一编码
     * @param callBack 登录成功后的回调函数
     */
    public static void wxLogin(final BaseActivity activity, String wechatid, final CheckListHttpUtils.CommonRequestCallBack callBack) {
        RequestParams params = RequestParamsToken.getExpandRequestParams(activity);
        params.addBodyParameter("os", "A");// 密码
        params.addBodyParameter("role", UclientApplication.getRoler(activity.getApplicationContext()));// 角色
        params.addBodyParameter("wechatid", wechatid);//微信唯一id
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.WX_LOGIN, params, activity.new RequestCallBackExpand<String>() {
            @Override
            public void onSuccess(ResponseInfo<String> responseInfo) {
                try {
                    CommonJson<LoginStatu> base = CommonJson.fromJson(responseInfo.result, LoginStatu.class);
                    if (base.getState() != 0) {
                        LoginStatu loginStatu = base.getValues();
                        int isBind = loginStatu.getIs_bind();
                        if (isBind == 1) { //如果已经绑定了微信号 则放置登录信息
                            DataUtil.putUserLoginInfo(activity.getApplicationContext(), loginStatu);
                        }
                        if (callBack != null) {
                            callBack.onSuccess(base.getValues());
                        }
                    } else {
                        CommonMethod.makeNoticeShort(activity, base.getErrmsg(), CommonMethod.ERROR);
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    CommonMethod.makeNoticeShort(activity, activity.getString(R.string.service_err), CommonMethod.ERROR);
                } finally {
                    activity.closeDialog();
                }
            }
        });
    }

    /**
     * 微信在线登录验证(这种登录不需要使用手机的验证码)
     *
     * @param activity
     * @param wechatid 微信唯一编码
     * @param telphone 是否是在线登录(这种只会出现在已经登录了在设置里面绑定微信账户时 需要将本地已存储的手机号码做绑定)
     * @param callBack 登录成功后的回调函数
     */
    public static void wxOnlineLogin(final BaseActivity activity, String wechatid, String telphone, final CheckListHttpUtils.CommonRequestCallBack callBack) {
        RequestParams params = RequestParamsToken.getExpandRequestParams(activity);
        params.addBodyParameter("os", "A");// 密码
        params.addBodyParameter("role", UclientApplication.getRoler(activity));// 角色
        params.addBodyParameter("telph", telphone);
        params.addBodyParameter("online", "1");//1表示在线绑定
        params.addBodyParameter("wechatid", wechatid);//微信唯一id
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.LOGIN, params, activity.new RequestCallBackExpand<String>() {
            @Override
            public void onSuccess(ResponseInfo<String> responseInfo) {
                try {
                    CommonJson<LoginStatu> base = CommonJson.fromJson(responseInfo.result, LoginStatu.class);
                    if (base.getState() != 0) {
                        LoginStatu loginStatu = base.getValues();
                        int isBind = loginStatu.getIs_bind();
                        if (isBind == 1) { //如果已经绑定了微信号 则放置登录信息
                            DataUtil.putUserLoginInfo(activity.getApplicationContext(), loginStatu);
                        }
                        if (callBack != null) {
                            callBack.onSuccess(base.getValues());
                        }
                    } else {
                        CommonMethod.makeNoticeShort(activity, base.getErrmsg(), CommonMethod.ERROR);
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    CommonMethod.makeNoticeShort(activity, activity.getString(R.string.service_err), CommonMethod.ERROR);
                } finally {
                    activity.closeDialog();
                }
            }
        });
    }

    /**
     * 公共请求
     *
     * @param activity
     * @param httpUrl               htpp请求地址
     * @param t                     泛型类型
     * @param isList                true表示服务端返回是集合 false表示是对象
     * @param params                参数
     * @param needLoadingDialog     是否需要加载对话框
     * @param commonRequestCallBack 加载成功后的回调
     */
    public static HttpHandler commonRequest(final Context activity, final String httpUrl, final Class t, final boolean isList,
                                            RequestParams params, final boolean needLoadingDialog, final CommonRequestCallBack commonRequestCallBack) {
        if (TextUtils.isEmpty(httpUrl) || commonRequestCallBack == null) {
            return null;
        }
        if (t == null) {
            throw new NullPointerException("class 类型不能为空");
        }
        CustomProgress loadingDialog = null;
        if (needLoadingDialog) {
            loadingDialog = new CustomProgress(activity);
            loadingDialog.show(activity, null, false);
        }
        final CustomProgress finalLoadingDialog = loadingDialog;
        HttpHandler httpHandler = SingsHttpUtils.getHttp().send(HttpRequest.HttpMethod.POST, httpUrl, params, new RequestCallBack<String>() {
            @Override
            public void onSuccess(ResponseInfo<String> responseInfo) {
                try {
                    if (httpUrl.contains(NetWorkRequest.IP_ADDRESS)) { //老的Http地址
                        BaseNetBean baseNetNewBean = new Gson().fromJson(responseInfo.result, BaseNetBean.class);
                        //确认消息是否已报错
                        if (baseNetNewBean != null && !TextUtils.isEmpty(baseNetNewBean.getErrmsg())) {
                            DataUtil.showErrOrMsg(activity, baseNetNewBean.getErrno() + "", baseNetNewBean.getErrmsg());
                            commonRequestCallBack.onFailure(null, baseNetNewBean.getErrmsg());
                            return;
                        }
                        if (isList) { //处理服务器返回的集合数据
                            CommonListJson base = CommonListJson.fromJson(responseInfo.result, t);
                            if (base.getState() != 0) {
                                commonRequestCallBack.onSuccess(base.getValues());
                            } else {
                                DataUtil.showErrOrMsg(activity, base.getErrno() + "", base.getErrmsg());
                                commonRequestCallBack.onFailure(null, "");
                            }
                        } else { //处理服务器返回的对象数据
                            CommonJson base = CommonJson.fromJson(responseInfo.result, t);
                            if (base.getState() != 0) {
                                commonRequestCallBack.onSuccess(base.getValues());
                            } else {
                                commonRequestCallBack.onFailure(null, "");
                                DataUtil.showErrOrMsg(activity, base.getErrno() + "", base.getErrmsg());
                            }
                        }
                    } else if (httpUrl.contains(NetWorkRequest.IP_ADDRESS_NEW)) { //新的http地址
                        BaseNetNewBean baseNetNewBean = new Gson().fromJson(responseInfo.result, BaseNetNewBean.class);
                        //确认消息是否已报错
                        if (baseNetNewBean != null && !baseNetNewBean.getMsg().equals("success")) {
                            DataUtil.showErrOrMsg(activity, baseNetNewBean.getCode() + "", baseNetNewBean.getMsg());
                            commonRequestCallBack.onFailure(null, baseNetNewBean.getMsg());
                            return;
                        }
                        if (isList) { //处理服务器返回的集合数据
                            CommonNewListJson base = CommonNewListJson.fromJson(responseInfo.result, t);
                            String msg = base.getMsg();
                            if (!TextUtils.isEmpty(msg) && msg.equals("success")) {
                                commonRequestCallBack.onSuccess(base.getResult());
                            } else {
                                commonRequestCallBack.onFailure(null, base.getCode() + "");
                                DataUtil.showErrOrMsg(activity, base.getCode() + "", base.getMsg());
                            }
                        } else { //处理服务器返回的对象数据
                            CommonNewJson base = CommonNewJson.fromJson(responseInfo.result, t);
                            String msg = base.getMsg();
                            if (!TextUtils.isEmpty(msg) && msg.equals("success")) {
                                commonRequestCallBack.onSuccess(base.getResult());
                            } else {
                                commonRequestCallBack.onFailure(null, "");
                                DataUtil.showErrOrMsg(activity, base.getCode() + "", base.getMsg());
                            }
                        }
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    if (!httpUrl.equals(NetWorkRequest.GET_OFFLINE_MESSAGE_LIST)) { //不打印离线请求的消息
                        CommonMethod.makeNoticeShort(activity, activity.getString(R.string.service_err), CommonMethod.ERROR);
                    }
                    if (commonRequestCallBack != null) {
                        commonRequestCallBack.onFailure(null, "");
                    }
                } finally {
                    if (needLoadingDialog && finalLoadingDialog != null) {
                        finalLoadingDialog.dismiss();
                    }
                }
            }

            @Override
            public void onFailure(HttpException e, String s) {
                isPrintNetErrorMessage(activity, httpUrl);
                commonRequestCallBack.onFailure(e, s);
                if (needLoadingDialog && finalLoadingDialog != null) {
                    finalLoadingDialog.dismiss();
                }
            }
        });
        return httpHandler;
    }


    /**
     * 切换角色
     *
     * @param context
     * @param isFirstSelecte true 表示首次登陆时的切换角色
     * @param roler          需要切换的角色
     * @param callBack       回调函数
     */
    public static void changeRoler(final Context context, final boolean isFirstSelecte, final String roler, final CommonRequestCallBack callBack) {
        RequestParams params = RequestParamsToken.getExpandRequestParams(context.getApplicationContext());
        params.addBodyParameter("role", roler);
        CommonHttpRequest.commonRequest(context, NetWorkRequest.CHANGERROLE, LoginStatu.class, CommonHttpRequest.OBJECT, params, true, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                LoginStatu loginStatu = (LoginStatu) object;
                put(context.getApplicationContext(), Constance.enum_parameter.ROLETYPE.toString(), roler, Constance.JLONGG);
                put(context.getApplicationContext(), Constance.enum_parameter.IS_INFO.toString(), loginStatu.getIs_info(), Constance.JLONGG);
//                CommonMethod.makeNoticeShort(context, roler.equals(Constance.ROLETYPE_FM) ? "你已切换到班组长/工头身份" : "你已切换到工人身份", CommonMethod.SUCCESS);
                CommonMethod.makeNoticeShort(context, "切换身份成功!", CommonMethod.SUCCESS);
                if (!isFirstSelecte) {
                    LocalBroadcastManager.getInstance(context).sendBroadcast(new Intent(Constance.ACCOUNT_INFO_CHANGE));
                    LocalBroadcastManager.getInstance(context).sendBroadcast(new Intent(Constance.SWITCH_ROLER_BROADCAST)); //我们这里发送一条广播通知一下
                }
                if (callBack != null) {
                    callBack.onSuccess(loginStatu);
                }
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
                if (callBack != null) {
                    callBack.onFailure(exception, errormsg);
                }
            }
        });
    }

    /**
     * 上传单条图片
     *
     * @param context
     * @param params
     * @param filePath
     */
    public static void uploadSinglePic(Context context, RequestParams params, String filePath, final CommonRequestCallBack commonRequestCallBack) {
        LUtils.e("-----------uploadPic----------" + filePath.toString());
        CommonHttpRequest.commonRequest(context, NetWorkRequest.UPLOAD, String.class, CommonHttpRequest.LIST, params, false, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                commonRequestCallBack.onSuccess(object);
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
                commonRequestCallBack.onFailure(exception, errormsg);
            }
        });
    }


    public static void isPrintNetErrorMessage(Context activity, String httpUrl) {
        switch (httpUrl) {
            case NetWorkRequest.GET_OFFLINE_MESSAGE_LIST://离线消息
            case NetWorkRequest.GET_CHAT_LIST: //聊聊信息
            case NetWorkRequest.GET_CHAT_MAIN_INFO://首页信息
            case NetWorkRequest.BANNER: //Banner图
            case NetWorkRequest.DISCOVER_NEW_MSG_COUNT://发现小红点
            case NetWorkRequest.GET_SERVER_TIME:
            case NetWorkRequest.POST_CHANNCELID://百度推送
            case NetWorkRequest.CHECK_VERSION:
            case NetWorkRequest.UPLOC://上传
            case NetWorkRequest.WORKER_MONTH_TOTAL://日历接口
                return;
            default:
                CommonMethod.makeNoticeShort(activity, activity.getApplicationContext().getString(R.string.conn_fail), CommonMethod.ERROR);
                break;
        }
    }

    public interface CommonRequestCallBack {
        public void onSuccess(Object object);

        public void onFailure(HttpException exception, String errormsg);
    }

}
