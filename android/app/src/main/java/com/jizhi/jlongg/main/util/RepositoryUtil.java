package com.jizhi.jlongg.main.util;

import android.app.Activity;
import android.os.Environment;
import android.text.TextUtils;
import android.view.Gravity;

import com.hcs.uclient.utils.FUtils;
import com.hcs.uclient.utils.NetWorkUtil;
import com.hcs.uclient.utils.SPUtils;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.activity.FileReadActivity;
import com.jizhi.jlongg.main.activity.PdfActivity;
import com.jizhi.jlongg.main.bean.BaseNetBean;
import com.jizhi.jlongg.main.bean.Repository;
import com.jizhi.jlongg.main.bean.Share;
import com.jizhi.jlongg.main.bean.status.CommonJson;
import com.jizhi.jlongg.main.bean.status.CommonListJson;
import com.jizhi.jlongg.main.dialog.CustomShareDialog;
import com.jizhi.jlongg.main.dialog.DialogOnlyTitle;
import com.jizhi.jlongg.main.dialog.DialogRepository;
import com.jizhi.jlongg.main.dialog.DialogRepositoryNotEnoughtCount;
import com.jizhi.jlongg.main.listener.DiaLogTitleListener;
import com.jizhi.jlongg.main.util.cloud.CloudUtil;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.HttpHandler;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.callback.RequestCallBack;
import com.lidroid.xutils.http.client.HttpRequest;
import com.umeng.analytics.MobclickAgent;

import java.io.File;
import java.util.List;

import noman.weekcalendar.eventbus.BusProvider;

/**
 * Created by Administrator on 2017/4/13 0013.
 */

public class RepositoryUtil {


    public final static int FILE_PREPARE_DOWNLOAD = 1; //准备下载标识
    public final static int FILE_DOWNLOADING = 2; //下载中的标识
    public final static int FILE_DOWNLOADED_SUCCESS = 3; //下载完毕的标识
    public final static int FILE_DOWNLOAD_FAIL = 4; //下载失败的标识


    /**
     * 页面条数 ，默认为10
     */
    public final static int DEFAULT_PAGE_SIZE = 20;
    /**
     * 读取文件的回调
     */
    public final static int READ_DOC_RETURN = 0X01;
    /**
     * 资料库搜索完成
     */
    public final static int SEARCH_OVER = 0X02;


    /**
     * 文件下载中存放地址
     */
    public static final String FILE_DOWNLOADING_FLODER = Environment.getExternalStorageDirectory().getAbsolutePath() + "/Jgj/FileDownloading/";
    /**
     * 文件下载完毕存放地址
     */
    public static final String FILE_DOWNLOADED_FLODER = Environment.getExternalStorageDirectory().getAbsolutePath() + "/Jgj/FileDownloaded/";
    /**
     * 文件下载完毕存放地址
     */
    public static final String FILE_ACCOUNT_DOWNLOADED_FLODER = Environment.getExternalStorageDirectory().getAbsolutePath() + "/Jgj/AccountFileDownloaded/";
    /**
     * 文件解析的路径
     */
    public static final String FILE_RESOLUTION_FLODER = Environment.getExternalStorageDirectory().getAbsolutePath() + "/Jgj/";
    /**
     * 文件夹下标
     */
    public static final int DIR_INDEX = 0;
    /**
     * 文件下标
     */
    public static final int FILE_INDEX = 1;
    /**
     * 根目录下标id
     */
    public static final String ROOT_DIR_INDEX = "0";
    /**
     * 文件夹
     */
    public static final String DIR = "dir";
    /**
     * 文件
     */
    public static final String FILE = "file";
    /**
     * 下载的次数
     */
    public static final String DOWNLOADED_SIZE = "DOWNLOADED_SIZE";


    /**
     * 下载文件
     *
     * @param bean 文件属性
     */
    public static void download(final BaseActivity activity, final Repository bean) {
        if (!NetWorkUtil.isWifi(activity)) { //只有wifi 才能下载文件
            DialogOnlyTitle dialogOnlyTitle = new DialogOnlyTitle(activity, new DiaLogTitleListener() {
                @Override
                public void clickAccess(int position) {
                    agreeDownLoadFile(activity, bean);
                }
            }, 0, "你现在没有连接WiFi，查看文档会消耗较多流量。\n你确定要继续查看文档吗？");
            dialogOnlyTitle.show();
            return;
        }
        agreeDownLoadFile(activity, bean);
    }

    /**
     * 同意下载文件
     *
     * @param activity
     * @param bean
     */
    private static void agreeDownLoadFile(final BaseActivity activity, final Repository bean) {
        // 每台手机初始获得5次免分享下载资格；5次后，再下载资料需要先进行一次品牌分享，分享一次允许下载5次资料（分享不影响查看已下载的资料）
        // 分享渠道包括：QQ好友、QQ空间、微信好友、微信朋友圈
        // 分享文案：
        // 标题：资料名称.doc
        // 文案：我在吉工宝资料库下载了该资料，更有大量专项施工资料任你免费获取！
        // 落款：吉工宝
        // 分享链接：对应App宣传下载页面
        // 分享完成后，返回吉工宝/吉工家应用，在当前页面中央显示气泡提示“分享成功，你可以继续查看资料了”，再次点击资料时才进行资料下载
        final int downloadedSize = (Integer) (SPUtils.get(activity, DOWNLOADED_SIZE, 0, Constance.JLONGG));
        if (downloadedSize >= 5) {
            DialogRepositoryNotEnoughtCount repositoryNotEnoughtCount = new DialogRepositoryNotEnoughtCount(activity, new DiaLogTitleListener() {
                @Override
                public void clickAccess(int position) { //确认分享
                    SPUtils.put(activity, DOWNLOADED_SIZE, 0, Constance.JLONGG);
                    Share shareBean = new Share();
                    shareBean.setTitle(bean.getFile_name());
                    shareBean.setDescribe("我在吉工家资料库下载了该资料，更有大量专项施工资料任你免费获取！");
                    shareBean.setImgUrl(NetWorkRequest.CDNURL + "media/default_imgs/logo.jpg");
                    shareBean.setUrl((NetWorkRequest.WEBURLS_SHARE));
                    new CustomShareDialog(activity, true, shareBean).showAtLocation(activity.getWindow().getDecorView(), Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0); //设置layout在PopupWindow中显示的位置
                    BackGroundUtil.backgroundAlpha(activity, 0.5F);
                }
            });
            repositoryNotEnoughtCount.show();
            return;
        }
        getDownLoadPath(bean.getId(), activity, new GetDownLoadPathListener() { //获取下载的路径
            @Override
            public void getDownLoadPath(String filePath, String fileType) {
                MobclickAgent.onEvent(activity, "downloading_repository"); //U盟下载知识库统计数量
                bean.setFile_path(filePath);
                if (TextUtils.isEmpty(bean.getFile_path())) {
                    CommonMethod.makeNoticeShort(activity, "获取文件下载路径出错", CommonMethod.ERROR);
                    return;
                }
                if (!FUtils.existSDCard()) { //SD卡是否可用
                    CommonMethod.makeNoticeShort(activity, "请检查SD卡是否可用", CommonMethod.ERROR);
                    return;
                }
                File floderFile = new File(FILE_DOWNLOADING_FLODER); //存放下载中路径的根目录
                if (!floderFile.exists()) { //如果不存在 则创建它
                    floderFile.mkdir();
                }
                final String saveName = bean.getFile_name() + bean.getId() + "." + fileType; //使用文件名加id的方式存储以免不同目录下有相同的名称的文件
                final File saveFile = new File(floderFile.getAbsolutePath() + File.separator + saveName);
                if (saveFile.exists()) { //如果当前需要下载的文件已存在则直接删除掉
                    saveFile.delete();
                }
                final DialogRepository dialogRepository = new DialogRepository(activity, bean.getFile_name() + "." + bean.getFile_type()); //文件下载弹出框 只支持单一下载
                HttpUtils http = SingsHttpUtils.getHttp();
                final HttpHandler httpHandler = http.download(bean.getFile_path(), saveFile.getAbsolutePath(), true, false, new RequestCallBack<File>() { //下载文件
                    @Override
                    public void onStart() {
                        bean.setIs_downloading(true); //设置当前文件处于下载状态 让处于下载文件中的状态不可点击
                        dialogRepository.show();
//                        BusProvider.getInstance().post(bean);
                    }

                    @Override
                    public void onLoading(long total, long current, boolean isUploading) { //文件下载中回调函数
                        bean.setIs_downloading(true); //设置当前文件处于下载状态 让处于下载文件中的状态不可点击
                        bean.setDownloadPercentage(((float) current) / total); //设置当前文件已经下载的百分比
                        bean.setFileDownLoadDesc((Utils.m1(current / 1024 / 1024f) + "MB"));
                        dialogRepository.updateDownLoading(bean.getDownloadPercentage());
//                        BusProvider.getInstance().post(bean);
                    }

                    @Override
                    public void onFailure(HttpException error, String msg) { //文件下载失败回调函数
                        bean.setIs_downloading(false);//设置当前文件未处于下载状态
                        CommonMethod.makeNoticeShort(activity, activity.getString(R.string.conn_fail), CommonMethod.ERROR);
                        BusProvider.getInstance().post(bean);
                    }

                    @Override
                    public void onSuccess(ResponseInfo<File> responseInfo) { //文件下载成功回调函数
                        bean.setIs_downloading(false); //设置当前文件未处于下载状态
                        bean.setDownloadFile(true); //设置文件已经下载完毕了
                        CommonMethod.makeNoticeShort(activity, bean.getFile_name() + "文件下载完毕", CommonMethod.SUCCESS);
                        File downloadFileFloader = new File(FILE_DOWNLOADED_FLODER);
                        if (!downloadFileFloader.exists()) { //下载完毕保存的文件路径
                            downloadFileFloader.mkdir();
                        }
                        FUtils.copyFile(saveFile.getAbsolutePath(), FILE_DOWNLOADED_FLODER + saveName); //将下载好的文件拷贝到Jgj/FileDownloaded文件
                        if (saveFile.exists()) { //删除下载中的文件
                            saveFile.delete();
                        }
                        if (dialogRepository != null && dialogRepository.isShowing()) { //关闭下载完成后的弹出框
                            dialogRepository.dismiss();
                        }
                        RepositoryUtil.openDownloadFile(activity, RepositoryUtil.FILE_DOWNLOADED_FLODER +
                                bean.getFile_name() + bean.getId() + "." + bean.getFile_type(), bean.getFile_name() + "." + bean.getFile_type(), bean); //下载完毕后打开文件
                        BusProvider.getInstance().post(bean);

                        int resetDownLoadsize = (Integer) (SPUtils.get(activity, DOWNLOADED_SIZE, 0, Constance.JLONGG)); //重新获取已下载的次数
                        SPUtils.put(activity, DOWNLOADED_SIZE, resetDownLoadsize + 1, Constance.JLONGG);
                    }
                });
                dialogRepository.setListener(new DialogRepository.FileDownLoadingListener() { //知识库文件下载弹出框
                    @Override
                    public void cancel() { //取消了文件的下载
                        bean.setIs_downloading(false); //设置当前文件未处于下载状态
                        httpHandler.cancel();
                        BusProvider.getInstance().post(bean);
                    }
                });
            }
        });
    }


    /**
     * 搜索知识库
     *
     * @param fileId     文件夹id
     * @param searchName 搜索名称
     * @param activity
     * @param listener   加载完数据的回调
     */
    public static void searchingRepositoryFile(String fileId, String searchName, final BaseActivity activity, final LoadRepositoryListener listener) {
        HttpUtils http = SingsHttpUtils.getHttp();
        final RequestParams params = RequestParamsToken.getExpandRequestParams(activity);
        if (!TextUtils.isEmpty(fileId)) {
            params.addBodyParameter("file_id", fileId);
        }
        params.addBodyParameter("file_name", searchName);
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.SEARCH_FILE,
                params, activity.new RequestCallBackExpand<String>() {
                    @Override
                    public void onSuccess(ResponseInfo<String> responseInfo) {
                        try {
                            CommonListJson<Repository> base = CommonListJson.fromJson(responseInfo.result, Repository.class);
                            if (base.getState() != 0) {
                                checkFilesIsDownLoad(base.getValues());
                                if (listener != null) {
                                    listener.loadRepositorySuccess(base.getValues());
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
                }
        );
    }


    /**
     * 获取知识库文件的下载地址
     *
     * @param fileId   文件夹id
     * @param activity
     * @param listener 加载完数据的回调
     */
    public static void getDownLoadPath(String fileId, final BaseActivity activity, final GetDownLoadPathListener listener) {
        HttpUtils http = SingsHttpUtils.getHttp();
        final RequestParams params = RequestParamsToken.getExpandRequestParams(activity);
        params.addBodyParameter("file_id", fileId);
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.GET_FILE_CONTENT,
                params, activity.new RequestCallBackExpand<String>() {
                    @Override
                    public void onSuccess(ResponseInfo<String> responseInfo) {
                        try {
                            CommonListJson<Repository> base = CommonListJson.fromJson(responseInfo.result, Repository.class);
                            if (base.getState() != 0) {
                                if (base.getValues() != null && base.getValues().size() > 0) {
                                    if (listener != null) {
                                        listener.getDownLoadPath(base.getValues().get(0).getFile_path(), base.getValues().get(0).getFile_type());
                                    }
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
                }
        );
    }

    /**
     * 加载知识库收藏列表
     *
     * @param activity
     * @param listener 加载完数据的回调
     */
    public static void loadCollectionRepositoryData(final Activity activity, final LoadRepositoryListener listener) {
        HttpUtils http = SingsHttpUtils.getHttp();
        final RequestParams params = RequestParamsToken.getExpandRequestParams(activity);
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.GET_COLLECTION_FILE,
                params, new RequestCallBack<String>() {
                    @Override
                    public void onSuccess(ResponseInfo<String> responseInfo) {
                        try {
                            CommonListJson<Repository> base = CommonListJson.fromJson(responseInfo.result, Repository.class);
                            if (base.getState() != 0) {

                                if (base.getValues() != null) {
                                    checkFilesIsDownLoad(base.getValues());
                                    if (listener != null) {
                                        listener.loadRepositorySuccess(base.getValues());
                                    }
                                }
                            } else {
                                DataUtil.showErrOrMsg(activity, base.getErrno(), base.getErrmsg());
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                            CommonMethod.makeNoticeShort(activity, activity.getString(R.string.service_err), CommonMethod.ERROR);
                        }
                    }

                    @Override
                    public void onFailure(HttpException e, String msg) {
                        BaseActivity baseActivity = (BaseActivity) activity;
                        baseActivity.printNetLog(msg, baseActivity);
                    }
                }
        );
    }

    /**
     * 加载知识库
     *
     * @param id         文件夹id
     * @param lastFileId 目录中最后的文件id 主要是分页时以免有重复的数据
     * @param activity
     * @param listener   加载完数据的回调
     * @param pageNum    分页页码
     */
    public static void loadRepositoryData(String id, String lastFileId, final Activity activity, final LoadRepositoryListener listener, int pageNum) {
        HttpUtils http = SingsHttpUtils.getHttp();
        final RequestParams params = RequestParamsToken.getExpandRequestParams(activity);
        params.addBodyParameter("id", id);
        if (!TextUtils.isEmpty(lastFileId)) {
            params.addBodyParameter("last_file_id", lastFileId); //	目录中最后的文件id 主要是分页时以免有重复的数据
        }
        params.addBodyParameter("class_type", "dir");
        params.addBodyParameter("pg", pageNum + "");
        params.addBodyParameter("pagesize", DEFAULT_PAGE_SIZE + ""); //一页显示多少条数据
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.GET_REPOSITORY,
                params, new RequestCallBack<String>() {
                    @Override
                    public void onSuccess(ResponseInfo<String> responseInfo) {
                        try {
                            CommonListJson<Repository> base = CommonListJson.fromJson(responseInfo.result, Repository.class);
                            if (base.getState() != 0) {
                                checkFilesIsDownLoad(base.getValues());
                                if (listener != null) {
                                    listener.loadRepositorySuccess(base.getValues());
                                }
                            } else {
                                DataUtil.showErrOrMsg(activity, base.getErrno(), base.getErrmsg());
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                            CommonMethod.makeNoticeShort(activity, activity.getString(R.string.service_err), CommonMethod.ERROR);
                        }
                    }

                    @Override
                    public void onFailure(HttpException e, String msg) {
                        BaseActivity baseActivity = (BaseActivity) activity;
                        baseActivity.printNetLog(msg, baseActivity);
                    }
                }
        );
    }


    /**
     * 检查文件是否已经下载过
     *
     * @param list 需要检查的文件bean
     */
    private static void checkFilesIsDownLoad(List<Repository> list) {
        if (list == null || list.size() == 0) {
            return;
        }
        for (Repository repository : list) {
            if (!TextUtils.isEmpty(repository.getFile_type()) && repository.getFile_type().equals(DIR)) { //如果是文件夹则进入下一次循环
                continue;
            }
            repository.setIs_show_collection_btn(true);
            String fileName = repository.getFile_name() + repository.getId() + "." + repository.getFile_type();
            File floderFile = new File(FILE_DOWNLOADED_FLODER + fileName); //本地文件路径
            if (floderFile.exists()) { //如果文件夹已经下载则设置已下载的标识符
                repository.setDownloadFile(true);
            }
        }
    }

    /**
     * 收藏知识库、或者取消收藏
     *
     * @param repository 知识库数据
     * @param activity   activity
     * @param listener   收藏、取消收藏成功的回调
     */
    public static void collectionOrCancel(final Repository repository, final BaseActivity activity, final CollectionListener listener) {
        if (!IsSupplementary.accessLogin(activity)) { //只有登录了才能收藏
            return;
        }
        HttpUtils http = SingsHttpUtils.getHttp();
        final RequestParams params = RequestParamsToken.getExpandRequestParams(activity);
        params.addBodyParameter("id", repository.getId());
        params.addBodyParameter("class_type", repository.getIs_collection() == 0 ? "1" : "2"); //	收藏：1；移除：2
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.HAND_COLLECTION_FILE,
                params, activity.new RequestCallBackExpand<String>() {
                    @Override
                    public void onSuccess(ResponseInfo<String> responseInfo) {
                        try {
                            CommonJson<BaseNetBean> base = CommonJson.fromJson(responseInfo.result, BaseNetBean.class);
                            if (base.getState() != 0) {
                                repository.setIs_collection(repository.getIs_collection() == 0 ? 1 : 0);
                                CommonMethod.makeNoticeShort(activity, repository.getIs_collection() == 1 ? "已加入到资料收藏夹" : "已从资料收藏夹移除", CommonMethod.SUCCESS);
                                if (base.getValues() != null && listener != null) {
                                    listener.collection();
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

                }
        );
    }


    /**
     * 打开已下载的文件
     *
     * @param activity
     * @param localFilePath 本地文件的路径
     * @param fileName      文件的名称
     * @param repository    知识库信息
     */
    public static void openDownloadFile(Activity activity, String localFilePath, String fileName, Repository repository) {
//        if (!TextUtils.isEmpty(fileName) && fileName.length() > 10) {
//            fileName = fileName.substring(0, 10) + "...";
//        }
        if (localFilePath.endsWith(".doc")) {
            FileReadActivity.actionStart(activity, localFilePath, fileName, CloudUtil.DOC_TAG, repository);
        } else if (localFilePath.endsWith(".docx")) {
            FileReadActivity.actionStart(activity, localFilePath, fileName, CloudUtil.DOC_TAG, repository);
        } else if (localFilePath.endsWith(".xls")) {
            FileReadActivity.actionStart(activity, localFilePath, fileName, CloudUtil.XLS_TAG, repository);
        } else if (localFilePath.endsWith(".xlsx")) {
            FileReadActivity.actionStart(activity, localFilePath, fileName, CloudUtil.XLS_TAG, repository);
        } else if (localFilePath.endsWith(".pdf")) {
            PdfActivity.actionStart(activity, localFilePath, fileName, repository);
        } else {
            CommonMethod.makeNoticeShort(activity, "未知的格式类型", CommonMethod.ERROR);
        }
    }


    /**
     * 加载知识库Listener
     */
    public interface LoadRepositoryListener {
        public void loadRepositorySuccess(List<Repository> list);

        public void loadRepositoryError();
    }

    /**
     * 收藏、取消收藏Listener
     */
    public interface CollectionListener {
        public void collection();
    }


    /**
     * 获取文件下载路径
     */
    public interface GetDownLoadPathListener {
        public void getDownLoadPath(String filePath, String fileType);
    }
}
