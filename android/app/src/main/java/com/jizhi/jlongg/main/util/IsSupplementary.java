package com.jizhi.jlongg.main.util;

import android.annotation.TargetApi;
import android.app.Activity;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Build;
import android.support.v4.content.LocalBroadcastManager;

import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.LoginStatu;
import com.jizhi.jlongg.main.bean.status.CommonJson;
import com.jizhi.jlongg.main.dialog.DiaLogCheckVersion;
import com.jizhi.jlongg.main.dialog.DiaLogRegister;
import com.jizhi.jlongg.main.dialog.DiaLogSupplementInfo;
import com.jizhi.jlongg.main.dialog.DiaLogSupplementName;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.client.HttpRequest;

/**
 * 是否需要 补充详细 注册信息
 *
 * @author Xuj
 * @time 2015年12月19日 18:48:29
 * @Version 1.0
 */
@TargetApi(Build.VERSION_CODES.HONEYCOMB)
public class IsSupplementary {
    /**
     * Dialog 是否正在显示
     */
    private static boolean isShowDialog;


    /**
     * 验证是否登录 是否弹出登录框
     */
    public static boolean accessLogin(final Activity context) {
        if (!UclientApplication.isLogin(context)) {
            if (!isShowDialog) {
                isShowDialog = true;
                DiaLogRegister dialog = new DiaLogRegister(context, new DiaLogRegister.IsCloseRegisterDialogListener() {
                    @Override
                    public void callBack() {
                        isShowDialog = false;
                    }
                });
                dialog.show();
            }
            return false;
        }
        return true;
    }


    /**
     * 下载新版本Dialog
     *
     * @param context
     * @param downloadpath 下载路径
     * @return
     */
    @TargetApi(Build.VERSION_CODES.HONEYCOMB)
    public static void downNewVersions(final Activity context, final String downloadpath, String vername, String updateContent, DialogInterface.OnDismissListener onDismissListener) {
        DiaLogCheckVersion dialog = new DiaLogCheckVersion(context, downloadpath, vername, updateContent);
        if (onDismissListener != null) {
            dialog.setOnDismissListener(onDismissListener);
        }
        dialog.show();
    }

    /**
     * 是否需要补充工友注册信息
     */
    public static boolean SupplementaryRegistrationWorker(final Activity context, String showTitle) {
        int is_info = UclientApplication.getIsInfo(context);
        if (is_info == Constance.IS_INFO_NO) { // 是否有当前角色 1.代表有 0.代表没有
            showTitle = "完成资料，即可进行项目操作";
            DiaLogSupplementInfo isSupplementDialog = new DiaLogSupplementInfo(context, showTitle);
            isSupplementDialog.show();
            return true;
        }
        return false;
    }


    /**
     * 是否完成了姓名的补充并且完善了姓名后跳转到新的Activity
     * 这种跳转方式适用于没有参数的Acitvity 跳转
     *
     * @param fromActivity           原Activity
     * @param isCancelFinishActivity 点击取消按钮是否关闭Activity
     * @param toActivity             补充姓名成功后的回调
     * @return
     */
    public static boolean isFillRealNameIntentActivity(final Activity fromActivity, boolean isCancelFinishActivity, final Class toActivity) {
        if (!accessLogin(fromActivity)) { //是否已登录
            return false;
        }
        //是否已填写真实姓名
        if (!UclientApplication.isHasRealName(fromActivity)) {
            final DiaLogSupplementName writeDialog = new DiaLogSupplementName(fromActivity, isCancelFinishActivity);
            writeDialog.setListener(new SupplementNameListener() {
                @Override
                public void clickSupplementName(String realName) {
                    requestSupplementName(realName, (BaseActivity) fromActivity, writeDialog, new CallSupplementNameSuccess() {
                        @Override
                        public void onSuccess() {
                            Intent intent = new Intent(fromActivity, toActivity);
                            fromActivity.startActivityForResult(intent, Constance.REQUEST);
                        }
                    });
                }
            });
            writeDialog.show();
            return false;
        } else { //如果有完善姓名直接跳转到指定页面
            Intent intent = new Intent(fromActivity, toActivity);
            fromActivity.startActivityForResult(intent, Constance.REQUEST);
        }
        return true;
    }


    /**
     * 是否已完善了姓名
     *
     * @param activity
     * @param isCancelFinishActivity    true表示当请求成功时自动关闭 当前Activity
     * @param callSupplementNameSuccess 回调方法
     * @return
     */
    public static boolean isFillRealNameCallBackListener(final Activity activity, boolean isCancelFinishActivity, final CallSupplementNameSuccess callSupplementNameSuccess) {
        if (!accessLogin(activity)) { //是否已登录
            return false;
        }
        //是否已填写真实姓名
        if (!UclientApplication.isHasRealName(activity)) {
            final DiaLogSupplementName writeDialog = new DiaLogSupplementName(activity, isCancelFinishActivity);
            writeDialog.setListener(new SupplementNameListener() {
                @Override
                public void clickSupplementName(String name) {
                    requestSupplementName(name, (BaseActivity) activity, writeDialog, callSupplementNameSuccess);
                }
            });
            writeDialog.show();
            return false;
        } else {
            if (callSupplementNameSuccess != null) {
                callSupplementNameSuccess.onSuccess();
            }
        }
        return true;
    }

    private static void requestSupplementName(final String name, final BaseActivity activity, final DiaLogSupplementName writeDialog, final CallSupplementNameSuccess callSupplementNameSuccess) { //补充姓名
        HttpUtils http = SingsHttpUtils.getHttp();
        RequestParams params = RequestParamsToken.getExpandRequestParams(activity);
        params.addBodyParameter("realname", name);
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.COMPLETE_REALNAME, params, activity.new RequestCallBackExpand<String>() {
            @Override
            public void onSuccess(ResponseInfo<String> responseInfo) {
                try {
                    CommonJson<LoginStatu> base = CommonJson.fromJson(responseInfo.result, LoginStatu.class);
                    if (base.getState() != 0) {
                        DataUtil.putName(activity, name);
//                        Intent intent = new Intent(Constance.SUPPLEMENT_NAME);
                        Utils.sendBroadCastToUpdateInfo(activity);

//                        LocalBroadcastManager.getInstance(activity).sendBroadcast(intent);
                        if (callSupplementNameSuccess != null) {
                            callSupplementNameSuccess.onSuccess();
                        }
                        if (null != writeDialog && writeDialog.isShowing()) {
                            writeDialog.dismiss();
                        }



                    } else {
                        DataUtil.showErrOrMsg(activity, base.getErrno(), base.getErrmsg());
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
     * 功能:补充姓名成功后的回调
     * 作者：Xuj
     * 时间: 2017年11月30日11:31:35
     */
    public interface CallSupplementNameSuccess {
        public void onSuccess();
    }

    /**
     * 功能: 补充姓名接口回调
     * 作者：Xuj
     * 时间: 2017年11月30日11:31:35
     */
    public interface SupplementNameListener {
        /**
         * 补充姓名
         *
         * @param name 姓名
         */
        public void clickSupplementName(final String name);

    }

}
