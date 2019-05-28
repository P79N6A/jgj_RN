package com.hcs.uclient.utils;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;

import com.google.gson.Gson;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.account.NewAccountActivity;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;
import com.jizhi.jlongg.main.bean.PersonBean;
import com.jizhi.jlongg.main.bean.Repository;
import com.jizhi.jlongg.main.bean.status.CommonJson;
import com.jizhi.jlongg.main.dialog.DialogRepository;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DataUtil;
import com.jizhi.jlongg.main.util.RepositoryUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.ShareUtil;
import com.jizhi.jlongg.main.util.SingsHttpUtils;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.HttpHandler;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.callback.RequestCallBack;
import com.lidroid.xutils.http.client.HttpRequest;

import java.io.File;
import java.util.ArrayList;

/**
 * Created by Administrator on 2017/4/20 0020.
 */

public class AccountUtils {


    /**
     * 保存上次记账信息
     */
    public static void saveWorerInfo(Activity activity, String account_type, int uid, String per_name, boolean isWorker) {
        try {
            //记账对象uid跟名字保存到本地
            SPUtils.put(activity, "account_type", TextUtils.isEmpty(account_type) ? "1" : account_type, isWorker ? Constance.ACCOUNT_WORKER_HISTORT : Constance.ACCOUNT_FORMAN_HISTORT);
            if (isWorker) {
                //工人对工头记账
                SPUtils.put(activity, "uid", uid, Constance.ACCOUNT_WORKER_HISTORT);
                SPUtils.put(activity, "per_name", TextUtils.isEmpty(per_name) ? "" : per_name, Constance.ACCOUNT_WORKER_HISTORT);
            }
            LUtils.e(uid + "------accountType----11---" + account_type);
            LUtils.e(per_name + "------accountType--11-----" + isWorker);


        } catch (Exception e) {

        }


    }

    /**
     * 读取上次记账信息
     */
    public static PersonBean getWorerInfo(Activity activity, boolean isWorker) {
        if (isWorker) {
            //工人对工头记账
            int saveUid = (int) SPUtils.get(activity, "uid", 0, Constance.ACCOUNT_WORKER_HISTORT);
            String saveName = SPUtils.get(activity, "per_name", "", Constance.ACCOUNT_WORKER_HISTORT).toString();
            LUtils.e(saveUid + "------accountType--22-----" + saveName);
            if (saveUid != 0 && !TextUtils.isEmpty(saveName)) {
                PersonBean bean = new PersonBean();
                bean.setUid(saveUid);
                bean.setName(saveName);
                return bean;

            }
            return null;
        }
        return null;

    }

    /**
     * 查询工头班组长信息
     *
     * @param activity
     * @param info                  班组信息
     * @param isIntentBorrowBalance true 跳转到借支/结算   false跳转到点工，包工，包工记工天
     */
    public static void searchData(final BaseActivity activity, final GroupDiscussionInfo info, final boolean isIntentBorrowBalance) {
        LUtils.e("------------info-----" + new Gson().toJson(info));
        RequestParams params = RequestParamsToken.getExpandRequestParams(activity);
        params.addBodyParameter("uid", info.getCreater_uid());
        String httpUrl = NetWorkRequest.JLWORKDAY_NEW;
        CommonHttpRequest.commonRequest(activity, httpUrl, PersonBean.class, CommonHttpRequest.LIST, params, true, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                ArrayList<PersonBean> list = (ArrayList<PersonBean>) object;
                if (list != null && list.size() > 0) {
                    if (isIntentBorrowBalance) {
                        Intent intent = new Intent(activity, NewAccountActivity.class);
                        Bundle Bundle = new Bundle();
                        Bundle.putSerializable("person", list.get(0));
                        intent.putExtra(Constance.PRONAME, info.getAll_pro_name() + "");
                        intent.putExtra(Constance.GROUP_NAME, info.getGroup_name() + "");
                        intent.putExtra(Constance.PID, info.getPro_id());
                        intent.putExtra(Constance.ISMSGBILL, true);
                        intent.putExtra(Constance.GROUP_ID, info.getGroup_id());
                        intent.putExtra(Constance.BEAN_BOOLEAN, true);
                        intent.putExtra("create_group_uid", info.getCreater_uid());
                        Bundle.putString(Constance.enum_parameter.ROLETYPE.toString(), info.getCreater_uid().equals(UclientApplication.getUid()) ? Constance.ROLETYPE_FM : Constance.ROLETYPE_WORKER);
                        intent.putExtras(Bundle);
                        activity.startActivityForResult(intent, Constance.REQUESTCODE_START);
                    } else {
                        Intent intent = new Intent(activity, NewAccountActivity.class);
                        Bundle Bundle = new Bundle();
                        Bundle.putSerializable("person", list.get(0));
                        intent.putExtra(Constance.PRONAME, info.getAll_pro_name() + "");
                        intent.putExtra(Constance.PID, info.getPro_id());
                        intent.putExtra(Constance.ISMSGBILL, true);
                        intent.putExtra(Constance.GROUP_ID, info.getGroup_id());
                        intent.putExtra(Constance.GROUP_NAME, info.getGroup_name() + "");
                        intent.putExtra("create_group_uid", info.getCreater_uid());
                        Bundle.putString(Constance.enum_parameter.ROLETYPE.toString(), Constance.ROLETYPE_WORKER);
                        intent.putExtras(Bundle);
                        activity.startActivityForResult(intent, Constance.REQUESTCODE_START);
                    }
                }
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {

            }
        });
    }





    /**
     * 下载账单
     *
     * @param activity
     * @param downLoadPath   文件下载地址
     * @param downLoadedName 文件下载后的名称，文件保存时间 记工统计+导出时间YYYYMMDDhhmmss
     */
    public static void downLoadAccount(final BaseActivity activity, String downLoadPath, final String downLoadedName) {
        File floderFile = new File(RepositoryUtil.FILE_DOWNLOADING_FLODER); //存放下载中路径的根目录
        if (!floderFile.exists()) { //如果不存在 则创建它
            floderFile.mkdir();
        }
        final File downLoadingFile = new File(floderFile.getAbsolutePath() + File.separator + downLoadedName); //下载中的文件保存地址
        if (downLoadingFile.exists()) { //如果当前需要下载的文件已存在则直接删除掉
            downLoadingFile.delete();
        }
        final DialogRepository dialogRepository = new DialogRepository(activity, downLoadedName); //文件下载弹出框 只支持单一下载
        HttpUtils http = SingsHttpUtils.getHttp();
        final HttpHandler httpHandler = http.download(downLoadPath, downLoadingFile.getAbsolutePath(), true, false, new RequestCallBack<File>() { //下载文件
            @Override
            public void onStart() {
                dialogRepository.show();
            }

            @Override
            public void onLoading(long total, long current, boolean isUploading) { //文件下载中回调函数
                dialogRepository.updateDownLoading(((float) current) / total);
            }

            @Override
            public void onFailure(HttpException error, String msg) { //文件下载失败回调函数
                CommonMethod.makeNoticeShort(activity.getApplicationContext(), activity.getString(R.string.conn_fail), CommonMethod.ERROR);
                if (dialogRepository != null && dialogRepository.isShowing()) { //关闭下载完成后的弹出框
                    dialogRepository.dismiss();
                }
            }

            @Override
            public void onSuccess(ResponseInfo<File> responseInfo) { //文件下载成功回调函数
                File downloadFileFloader = new File(RepositoryUtil.FILE_ACCOUNT_DOWNLOADED_FLODER);
                if (!downloadFileFloader.exists()) { //下载完毕保存的文件路径
                    downloadFileFloader.mkdir();
                }
                String downLoadedPath = downloadFileFloader.getAbsolutePath() + File.separator + downLoadedName;
                FUtils.copyFile(downLoadingFile.getAbsolutePath(), downLoadedPath); //将下载好的文件拷贝到Jgj/FileDownloaded文件
                if (downLoadingFile.exists()) { //删除下载中的文件
                    downLoadingFile.delete();
                }
                if (dialogRepository != null && dialogRepository.isShowing()) { //关闭下载完成后的弹出框
                    dialogRepository.dismiss();
                }
                File downloadedFile = new File(downLoadedPath);
                if (!downloadedFile.exists()) { //下载完毕保存的文件路径
                    return;
                }
//                ShareUtil.openExcelFile(downloadedFile, activity);
                ShareUtil.shareFile(downloadedFile, activity);
            }
        });
        dialogRepository.setListener(new DialogRepository.FileDownLoadingListener() { //知识库文件下载弹出框
            @Override
            public void cancel() { //取消了文件的下载
                httpHandler.cancel();
            }
        });
    }

    /**
     * 下载账单
     *
     * @param activity
     * @param downLoadPath   文件下载地址
     * @param downLoadedName 文件下载后的名称，文件保存时间 记工统计+导出时间YYYYMMDDhhmmss
     * @param openStatus     1表示打开，2表示分享
     */
    public static void downLoadExcel(final BaseActivity activity, String downLoadPath, final String downLoadedName, final int openStatus) {
        File floderFile = new File(RepositoryUtil.FILE_DOWNLOADING_FLODER); //存放下载中路径的根目录
        if (!floderFile.exists()) { //如果不存在 则创建它
            floderFile.mkdir();
        }
        final File downLoadingFile = new File(floderFile.getAbsolutePath() + File.separator + downLoadedName); //下载中的文件保存地址
        if (downLoadingFile.exists()) { //如果当前需要下载的文件已存在则直接删除掉
            downLoadingFile.delete();
        }
        final DialogRepository dialogRepository = new DialogRepository(activity, downLoadedName); //文件下载弹出框 只支持单一下载
        HttpUtils http = SingsHttpUtils.getHttp();
        final HttpHandler httpHandler = http.download(downLoadPath, downLoadingFile.getAbsolutePath(), true, false, new RequestCallBack<File>() { //下载文件
            @Override
            public void onStart() {
                dialogRepository.show();
            }

            @Override
            public void onLoading(long total, long current, boolean isUploading) { //文件下载中回调函数
                dialogRepository.updateDownLoading(((float) current) / total);
            }

            @Override
            public void onFailure(HttpException error, String msg) { //文件下载失败回调函数
                CommonMethod.makeNoticeShort(activity.getApplicationContext(), activity.getString(R.string.conn_fail), CommonMethod.ERROR);
                if (dialogRepository != null && dialogRepository.isShowing()) { //关闭下载完成后的弹出框
                    dialogRepository.dismiss();
                }
            }

            @Override
            public void onSuccess(ResponseInfo<File> responseInfo) { //文件下载成功回调函数
                File downloadFileFloader = new File(RepositoryUtil.FILE_ACCOUNT_DOWNLOADED_FLODER);
                if (!downloadFileFloader.exists()) { //下载完毕保存的文件路径
                    downloadFileFloader.mkdir();
                }
                String downLoadedPath = downloadFileFloader.getAbsolutePath() + File.separator + downLoadedName;
                FUtils.copyFile(downLoadingFile.getAbsolutePath(), downLoadedPath); //将下载好的文件拷贝到Jgj/FileDownloaded文件
                if (downLoadingFile.exists()) { //删除下载中的文件
                    downLoadingFile.delete();
                }
                if (dialogRepository != null && dialogRepository.isShowing()) { //关闭下载完成后的弹出框
                    dialogRepository.dismiss();
                }
                File downloadedFile = new File(downLoadedPath);
                if (!downloadedFile.exists()) { //下载完毕保存的文件路径
                    return;
                }
                switch (openStatus) {
                    case 1: //打开
                        ShareUtil.openExcelFile(downloadedFile, activity);
                        break;
                    case 2://分享
                        ShareUtil.shareFile(downloadedFile, activity);
                        break;
                }
            }
        });
        dialogRepository.setListener(new DialogRepository.FileDownLoadingListener() { //知识库文件下载弹出框
            @Override
            public void cancel() { //取消了文件的下载
                httpHandler.cancel();
            }
        });
    }


}
