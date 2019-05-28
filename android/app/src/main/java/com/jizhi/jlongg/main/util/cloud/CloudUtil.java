package com.jizhi.jlongg.main.util.cloud;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Build;
import android.support.v4.content.FileProvider;
import android.text.TextUtils;

import com.hcs.uclient.utils.NetWorkUtil;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.db.ProCloudService;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.activity.pay.ConfirmCloudOrderNewActivity;
import com.jizhi.jlongg.main.activity.procloud.LoadCloudPicActivity;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.Cloud;
import com.jizhi.jlongg.main.bean.CloudConfiguration;
import com.jizhi.jlongg.main.bean.status.CommonJson;
import com.jizhi.jlongg.main.dialog.pay.DialogNotEnoughCloudSpace;
import com.jizhi.jlongg.main.dialog.pro_cloud.DialogOpenFile;
import com.jizhi.jlongg.main.listener.DiaLogTitleListener;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.DataUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.ShareUtil;
import com.jizhi.jlongg.main.util.SingsHttpUtils;
import com.jizhi.jlongg.main.util.WebSocketConstance;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.callback.RequestCallBack;
import com.lidroid.xutils.http.client.HttpRequest;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

import noman.weekcalendar.eventbus.BusProvider;

/**
 * 项目云
 *
 * @author way
 */
public class CloudUtil {

    public static final String ROOT_DIR = "0";

    public static final int OPEN_FILE = 1;

    public static final int SHARE_FILE = 0;

    /**
     * 文件夹标识
     */
    public static final int FOLDER = 0;
    /**
     * 文件标识
     */
    public static final int FILE = 1;
    /**
     * 文件下载标识
     */
    public static final int LOADING = 0;
    /**
     * 文件下载完毕标识
     */
    public static final int LOADED = 1;

    public static final String FOLDER_TAG = "dir";
    public static final String FILE_TAG = "file";
    public static final String DOC_TAG = "word";
    public static final String XLS_TAG = "excel";
    public static final String PPT_TAG = "ppt";
    public static final String VIDEO_TAG = "video";
    public static final String TXT_TAG = "txt";
    public static final String CAD_TAG = "dwg";
    public static final String ZIP_TAG = "zip";
    public static final String PDF_TAG = "pdf";
    public static final String PIC_TAG = "pic";
    public static final int MOVE_FILE_TAG = 1;
    public static final int UN_MOVE_FILE_TAG = 0;


    public static final String DELELTE_FILE = "0"; //删除文件

    public static final String DELETE_BIN_FILE = "-1"; //删除回收站文件


    public static final int FILE_TYPE_UPLOAD_TAG = 1; //文件上传标志
    public static final int FILE_TYPE_DOWNLOAD_TAG = 2; //文件下载标志


    public static final int FILE_NO_EXIST = -1; //本地文件不存在标识

    public static final int FILE_NO_COMPLETE_STATE = 1; //文件未下载标识
    public static final int FILE_LOADING_STATE = 2; //文件正在下载标识
    public static final int FILE_COMPLETED_STATE = 3; //文件下载完毕标识


    public static final int DELETE_FILE_NOTICE = 4; //文件被删除通知


    /**
     * 文件编辑
     */
    public interface FileEditorListener {
        /**
         * 重命名
         */
        public void renameFile(Cloud cloud);

        /**
         * 文件分享
         */
        public void shareFile(Cloud cloud);

        /**
         * 文件下载
         */
        public void downLoadFile(Cloud cloud);

        /**
         * 开始下载文件或上传文件
         *
         * @param cloud
         */
        public void startFile(Cloud cloud);

        /**
         * 暂停下载文件或上传文件
         *
         * @param cloud
         */
        public void pauseFile(Cloud cloud);

        /**
         * 显示文件详情
         *
         * @param cloud
         * @param grouposition
         */
        public void showFileDetail(Cloud cloud, int grouposition);
    }


    /**
     * 创建云文件
     *
     * @param activity
     * @param groupId         组id
     * @param classType       组类型
     * @param parentId        父目录id
     * @param catName         目录名称
     * @param movefile_create 移动目录的文件时，创建文件传  1代表在移动文件  0代表未移动文件
     * @param listener        创建文件夹成功后的回调
     */
    public static void createCloudDir(final BaseActivity activity, String groupId, String classType, String parentId, String catName, int movefile_create, String fileId,
                                      final GetFileListListener listener) {
        RequestParams params = RequestParamsToken.getExpandRequestParams(activity);
        params.addBodyParameter("group_id", groupId);// 	组id
        params.addBodyParameter("class_type", classType);// 组类型
        params.addBodyParameter("parent_id", parentId);// 父目录id
        params.addBodyParameter("cat_name", catName);// 	目录名称
        params.addBodyParameter("file_id", fileId);// 	需要排除的目录
        params.addBodyParameter("movefile_create", movefile_create + "");
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.CREATE_CLOUD_DIR,
                params, activity.new RequestCallBackExpand<String>() {
                    @Override
                    public void onSuccess(ResponseInfo<String> responseInfo) {
                        try {
                            CommonJson<Cloud> base = CommonJson.fromJson(responseInfo.result, Cloud.class);
                            if (base.getState() != 0) {
                                if (listener != null) {
                                    listener.onSuccess(base.getValues().getList());
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
     * 云盘文件列表
     *
     * @param activity
     * @param groupId   组id
     * @param classType 组类型
     * @param parentId  父目录id
     * @param isBin     回收站，1：表示回收站
     * @param listener  获取云盘列表清单回调
     */
    public static void getCloudDir(final BaseActivity activity, String groupId, String classType,
                                   String parentId, boolean isBin, final GetFileListListener listener) {
        RequestParams params = RequestParamsToken.getExpandRequestParams(activity);
        params.addBodyParameter("group_id", groupId);// 	组id
        params.addBodyParameter("class_type", classType);// 组类型
        params.addBodyParameter("parent_id", parentId);// 父目录id
        if (isBin) {
            params.addBodyParameter("is_bin", "1");
        }
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.GET_OSSLIST, params, activity.new RequestCallBackExpand<String>() {
            @Override
            public void onSuccess(ResponseInfo<String> responseInfo) {
                try {
                    CommonJson<Cloud> base = CommonJson.fromJson(responseInfo.result, Cloud.class);
                    if (base.getState() != 0) {
                        if (listener != null) {
                            listener.onSuccess(base.getValues().getList());
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

            @Override
            public void onFailure(HttpException e, String msg) {
                super.onFailure(e, msg);
                if (listener != null) {
                    listener.onFailure();
                }
            }
        });
    }


    /**
     * 显示当前目录下的文件/文件夹
     *
     * @param activity
     * @param groupId   组id
     * @param classType 组类型
     * @param parentId  文件id
     * @param type      dir 文件夹；file文件
     * @param listener  获取云盘列表清单回调
     */
    public static void getFolders(final BaseActivity activity, String groupId, String moveIds, String classType, String parentId, String type, final GetFileListListener listener) {
        RequestParams params = RequestParamsToken.getExpandRequestParams(activity);
        params.addBodyParameter("group_id", groupId);// 	组id
        params.addBodyParameter("class_type", classType);// 组类型
        params.addBodyParameter("parent_id", parentId);// 父目录id
        params.addBodyParameter("move_id", moveIds);// 排除移动文件的id
        params.addBodyParameter("type", type);// 	组id
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.EXCLOUD_FILES,
                params, new RequestCallBack<String>() {
                    @Override
                    public void onSuccess(ResponseInfo<String> responseInfo) {
                        try {
                            CommonJson<Cloud> base = CommonJson.fromJson(responseInfo.result, Cloud.class);
                            if (base.getState() != 0) {
                                if (listener != null) {
                                    listener.onSuccess(base.getValues().getList());
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
                        activity.printNetLog(msg, activity);
                        if (listener != null) {
                            listener.onFailure();
                        }
                    }
                });
    }


    /**
     * 云盘文件列表
     *
     * @param activity
     * @param groupId   组id
     * @param classType 组类型
     * @param sourceIds 父目录id
     * @param parentId  回收站，1：表示回收站
     * @param listener  回复成功后重获列表的回调
     */
    public static void restoreFiles(final BaseActivity activity, String groupId, String classType, String sourceIds,
                                    String parentId, final GetFileListListener listener) {
        RequestParams params = RequestParamsToken.getExpandRequestParams(activity);
        params.addBodyParameter("group_id", groupId);// 	组id
        params.addBodyParameter("class_type", classType);// 组类型
        params.addBodyParameter("source_ids", sourceIds);// json形式,[{‘id’:’2’,’type’:’dir’},{‘id’:’1’,’type’:’file’}
        params.addBodyParameter("parent_id", parentId);// 父目录id
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.RESTORE_FILEES,
                params, activity.new RequestCallBackExpand<String>() {
                    @Override
                    public void onSuccess(ResponseInfo<String> responseInfo) {
                        try {
                            CommonJson<Cloud> base = CommonJson.fromJson(responseInfo.result, Cloud.class);
                            if (base.getState() != 0) {
                                if (listener != null) {
                                    listener.onSuccess(base.getValues().getList());
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
     * 获取阿里云OSS信息
     *
     * @param activity
     * @param fileId   文件id
     * @param listener 获取云盘列表清单回调
     */
    public static void getOssClientDownLoadInfo(final BaseActivity activity, final String fileId, final GetOssConfigurationListener listener) {
        RequestParams params = RequestParamsToken.getExpandRequestParams(activity);
        params.addBodyParameter("file_id", fileId);//文件id
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.DOWN_FILE, params, activity.new RequestCallBackExpand<String>() {
            @Override
            public void onSuccess(ResponseInfo<String> responseInfo) {
                try {
                    CommonJson<CloudConfiguration> base = CommonJson.fromJson(responseInfo.result, CloudConfiguration.class);
                    if (base.getState() != 0) {
                        if (listener != null) {
                            listener.onSuccess(base.getValues());
                        }
                    } else {
                        if (base.getErrno().equals("810504")) { //文件已经不存在
                            BusProvider.getInstance().post(fileId);
                        }
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
     * 移动文件
     *
     * @param activity
     * @param groupId   组id
     * @param classType 组类型
     * @param dirId     移动的目录id，不传，默认是根目录
     * @param sourceIds [{‘id’:’1’,’type’:’dir’},{‘id’:’3’,’type’:’file’}]
     * @param listener
     */
    public static void moveFile(final BaseActivity activity, String groupId, String classType, String dirId, String sourceIds, final MoveFileListener listener) {
        RequestParams params = RequestParamsToken.getExpandRequestParams(activity);
        params.addBodyParameter("group_id", groupId);//组id
        params.addBodyParameter("class_type", classType);//	组类型
        params.addBodyParameter("dir_id", dirId);//		移动的目录id，不传，默认是根目录
        params.addBodyParameter("source_ids", sourceIds);//	[{‘id’:’1’,’type’:’dir’},{‘id’:’3’,’type’:’file’}]
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.MOVE_FILE,
                params, activity.new RequestCallBackExpand<String>() {
                    @Override
                    public void onSuccess(ResponseInfo<String> responseInfo) {
                        try {
                            CommonJson<CloudConfiguration> base = CommonJson.fromJson(responseInfo.result, CloudConfiguration.class);
                            if (base.getState() != 0) {
                                if (listener != null) {
                                    listener.onSuccess();
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
     * 删除文件
     *
     * @param activity
     * @param groupId   组id
     * @param classType 组类型
     * @param sourceIds [{‘id’:’2’,’type’:’dir’},{‘id’:’1’,’type’:’file’}
     * @param delType   删除，默认为0；在回收站删除时，-1
     * @param parentId  父文件id
     * @param listener
     */
    public static void deleteFiles(final BaseActivity activity, String groupId, String classType, String sourceIds, String delType, String parentId, final GetFileListListener listener) {
        RequestParams params = RequestParamsToken.getExpandRequestParams(activity);
        params.addBodyParameter("group_id", groupId);//组id
        params.addBodyParameter("class_type", classType);//	组类型
        params.addBodyParameter("source_ids", sourceIds);//	[{‘id’:’1’,’type’:’dir’},{‘id’:’3’,’type’:’file’}]
        params.addBodyParameter("del_type", delType);//	删除，默认为0；在回收站删除时，-1
        params.addBodyParameter("parent_id", parentId);//父文件id
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.DEL_FILE,
                params, activity.new RequestCallBackExpand<String>() {
                    @Override
                    public void onSuccess(ResponseInfo<String> responseInfo) {
                        try {
                            CommonJson<Cloud> base = CommonJson.fromJson(responseInfo.result, Cloud.class);
                            if (base.getState() != 0) {
                                if (listener != null) {
                                    listener.onSuccess(base.getValues().getList());
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
     * 文件搜索
     *
     * @param activity
     * @param fileName 搜索文件名称
     * @param catId    目录id
     * @param isBin    是否是搜索回收站
     * @param listener
     */
    public static void searchFile(final BaseActivity activity, String fileName, String catId, String groupId, boolean isBin, final GetFileListListener listener) {
        RequestParams params = RequestParamsToken.getExpandRequestParams(activity);
        params.addBodyParameter("file_name", fileName);//文件名
        params.addBodyParameter("cat_id", catId);//	默认是顶级目录
        params.addBodyParameter("group_id", groupId);//组id
        params.addBodyParameter("class_type", WebSocketConstance.TEAM);//组类型
        if (isBin) {
            params.addBodyParameter("is_bin", "1");
        }
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.SEARCH_CLOUD_FILE, params, activity.new RequestCallBackExpand<String>() {
            @Override
            public void onSuccess(ResponseInfo<String> responseInfo) {
                try {
                    CommonJson<Cloud> base = CommonJson.fromJson(responseInfo.result, Cloud.class);
                    if (base.getState() != 0) {
                        if (listener != null) {
                            listener.onSuccess(base.getValues().getList());
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
     * 获取文件上传所需要的oss信息
     *
     * @param activity
     * @param groupId   组id
     * @param classType 组类型
     * @param catId     父目录id
     * @param fileName  文件名称
     * @param fileType  文件类型
     * @param fileSize  文件大小
     * @param fileId    文件id 主要是断点续传的时候判断文件是否重复的时候使用
     * @param listener
     */
    public static void getUploadFileOssClientInfo(final BaseActivity activity, final String groupId, String classType,
                                                  String catId, String fileName, String fileType, String fileSize, String fileId,
                                                  final UploadFileListener listener) {
        RequestParams params = RequestParamsToken.getExpandRequestParams(activity);
        params.addBodyParameter("group_id", groupId);//	文件名
        params.addBodyParameter("class_type", classType);//	文件名
        params.addBodyParameter("cat_id", catId);   //		父目录id
        params.addBodyParameter("file_name", fileName);//	文件名称
        params.addBodyParameter("file_type", fileType);//	文件类型
        params.addBodyParameter("file_size", fileSize);//	文件大小
        if (!TextUtils.isEmpty(fileId)) {
            params.addBodyParameter("file_id", fileId);//	文件id
        }
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.UPLOAD_FILE, params, activity.new RequestCallBackExpand<String>() {
            @Override
            public void onSuccess(ResponseInfo<String> responseInfo) {
                try {
                    CommonJson<CloudConfiguration> base = CommonJson.fromJson(responseInfo.result, CloudConfiguration.class);
                    if (base.getState() != 0) {
                        if (listener != null) {
                            listener.onSuccess(base.getValues());
                        }
                    } else {
                        if (base.getErrno().equals("810507")) { //云盘空间不足
                            DialogNotEnoughCloudSpace notEnoughCloudSpace = new DialogNotEnoughCloudSpace(activity,
                                    new DiaLogTitleListener() {
                                        @Override
                                        public void clickAccess(int position) {
                                            ConfirmCloudOrderNewActivity.actionStart(activity, groupId);
                                        }
                                    });
                            notEnoughCloudSpace.show();
                            return;
                        }
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
     * 重命名文件名称
     *
     * @param activity
     * @param fileName 新名称
     * @param type     文件类型 dir，file
     * @param fileId   文件id
     * @param listener
     */
    public static void renameFile(final BaseActivity activity, String fileName, String type, String fileId, final GetFileListListener listener) {
        RequestParams params = RequestParamsToken.getExpandRequestParams(activity);
        params.addBodyParameter("file_name", fileName);//	新名称
        params.addBodyParameter("type", type);      //文件类型 dir，file
        params.addBodyParameter("file_id", fileId);   //文件id
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.RENAME_FILE, params, activity.new RequestCallBackExpand<String>() {
            @Override
            public void onSuccess(ResponseInfo<String> responseInfo) {
                try {
                    CommonJson<Cloud> base = CommonJson.fromJson(responseInfo.result, Cloud.class);
                    if (base.getState() != 0) {
                        if (listener != null) {
                            listener.onSuccess(null);
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


    public static void openFile(Activity activity, Cloud cloud, List<Cloud> list) {
//        try {
        String fileBroadType = cloud.getFile_broad_type(); //文件类型
        if (TextUtils.isEmpty(fileBroadType)) {
            return;
        }
        switch (fileBroadType) {
            case CloudUtil.VIDEO_TAG://直接在线播放视频
                if (!NetWorkUtil.isConnected(activity)) { //没有网络
                    CommonMethod.makeNoticeShort(activity, "请确认网络是否开启", CommonMethod.ERROR);
                    return;
                }
//                WonderfulVideoListActivity
//                VideoMainActivity.actionStart(activity, cloud.getFile_path());
                break;
            case CloudUtil.PIC_TAG://直接打开图片的地址
                ArrayList images = new ArrayList();
                int imagePosition = 1; //图片选中下标
                for (Cloud bean : list) {
                    if (!TextUtils.isEmpty(bean.getType()) && bean.getType().equals(FILE_TAG) && bean.getFile_broad_type().equals(CloudUtil.PIC_TAG)) {
                        images.add(bean.getFile_path());
                        if (bean.getId().equals(cloud.getId())) {
                            imagePosition = images.size();
                        }
                    }
                }
                LoadCloudPicActivity.actionStart(activity, images, imagePosition);
                break;
            case CloudUtil.PDF_TAG: //pdf
                openPdfFileIntent(activity, cloud.getFileLocalPath());
                break;
            case CloudUtil.DOC_TAG: //word文档
                openWordFileIntent(activity, cloud.getFileLocalPath());
                break;
            case CloudUtil.XLS_TAG: //excel文档
                openExcelFileIntent(activity, cloud.getFileLocalPath());
                break;
            case CloudUtil.PPT_TAG: //ppt
                openPptFileIntent(activity, cloud.getFileLocalPath());
                break;
            case CloudUtil.TXT_TAG: //text文档
                openTextFileIntent(activity, cloud.getFileLocalPath());
                break;
            case CloudUtil.CAD_TAG: //cad文件
                openCadFileIntent(activity, cloud.getFileLocalPath());
                break;
            default:
                CommonMethod.makeNoticeLong(activity, "暂不支持当前格式", CommonMethod.ERROR);
                break;
        }
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
    }

    /**
     * 打开文件
     *
     * @param activity
     * @param filePath 文件路径
     * @param fileType 文件类型
     */
    public static void openFile(Activity activity, String filePath, String fileType) {
        if (TextUtils.isEmpty(fileType)) {
            return;
        }
        switch (fileType) {
            case CloudUtil.VIDEO_TAG://直接在线播放视频
                if (!NetWorkUtil.isConnected(activity)) { //没有网络
                    CommonMethod.makeNoticeShort(activity, "请确认网络是否开启", CommonMethod.ERROR);
                    return;
                }
//                VideoMainActivity.actionStart(activity, filePath);
                break;
            case CloudUtil.PIC_TAG://直接打开图片的地址
                ArrayList images = new ArrayList();
                int imagePosition = 1; //图片选中下标
                images.add(filePath);
                LoadCloudPicActivity.actionStart(activity, images, imagePosition);
                break;
            case CloudUtil.PDF_TAG: //pdf
                openPdfFileIntent(activity, filePath);
                break;
            case CloudUtil.DOC_TAG: //word文档
                openWordFileIntent(activity, filePath);
                break;
            case CloudUtil.XLS_TAG: //excel文档
                openExcelFileIntent(activity, filePath);
                break;
            case CloudUtil.PPT_TAG: //ppt
                openPptFileIntent(activity, filePath);
                break;
            case CloudUtil.TXT_TAG: //text文档
                openTextFileIntent(activity, filePath);
                break;
            case CloudUtil.CAD_TAG: //cad文件
                openCadFileIntent(activity, filePath);
                break;
            default:
                CommonMethod.makeNoticeLong(activity, "暂不支持当前格式", CommonMethod.ERROR);
                break;
        }
    }

    /**
     * 云盘点击文件打开并下载
     *
     * @param activity
     * @param cloud
     * @param openType 打开类型 0为分享  1为打开
     */
    public static void openFileOrShareFile(final BaseActivity activity, final Cloud cloud, final int openType, String groupId, final List<Cloud> list) {
        if (TextUtils.isEmpty(cloud.getFile_broad_type())) {
            return;
        }
        if (openType == OPEN_FILE) {
            switch (cloud.getFile_broad_type()) {
                case VIDEO_TAG:
                    openFile(activity, cloud, list);
                    return;
                case PIC_TAG:
                    openFile(activity, cloud, list);
                    return;
            }
        }
        Cloud daoCloud = ProCloudService.getInstance(activity.getApplicationContext()).getFileDownLoadInfo(activity, cloud.getId(), groupId); //获取文件状态
        if (daoCloud != null && daoCloud.getFileState() == CloudUtil.FILE_COMPLETED_STATE) { //文件已在传输列表中下载过了 则直接拿来使用
            if (!TextUtils.isEmpty(daoCloud.getFileLocalPath())) {
                File file = new File(daoCloud.getFileLocalPath());
                if (file.exists()) {
                    if (openType == SHARE_FILE) { //分享文件
                        ShareUtil.shareFile(new File(daoCloud.getFileLocalPath()), activity);
                    } else if (openType == OPEN_FILE) { //打开文件
                        openFile(activity, daoCloud, list);
                    }
                    return;
                } else {
                    ProCloudService.getInstance(activity.getApplicationContext()).deleteFileInfo(activity.getApplicationContext(), daoCloud.getId(), groupId, CloudUtil.FILE_TYPE_DOWNLOAD_TAG + ""); //如果传输列表的文件已经被删除 则需要清空当前数据
                }
            }
        }
        final String fileId = cloud.getId();
        File openFileDirFile = new File(OssClientUtil.PREVIEW_FILE_PATH);
        if (openFileDirFile.exists()) { //文件目录是否存在,如果不存在说明文件都未下载
            for (File file : openFileDirFile.listFiles()) { //获取预览目录
                String fileName = file.getName();
                if (fileName.indexOf("_") != -1) {
                    String mFileId = fileName.split("_")[0];
                    if (mFileId.equals(fileId)) { //本地已经下载了有相同的文件、直接分享
                        if (openType == SHARE_FILE) { //分享文件
                            ShareUtil.shareFile(file, activity);
                        } else if (openType == OPEN_FILE) { //打开文件
                            cloud.setFileLocalPath(file.getAbsolutePath());
                            openFile(activity, cloud, list);
                        }
                        return;
                    }
                }
            }
        }
        getOssClientDownLoadInfo(activity, cloud.getId(), new CloudUtil.GetOssConfigurationListener() {
            @Override
            public void onSuccess(CloudConfiguration configuration) {
                String indexFileName = null;
                String fileName = cloud.getFile_name();
                if (!TextUtils.isEmpty(fileName) && fileName.lastIndexOf(".") != -1) {
                    indexFileName = fileName.substring(0, fileName.lastIndexOf(".")) + "." + cloud.getFile_type();
                } else {
                    indexFileName = fileName + "." + cloud.getFile_type();
                }
                String saveFileName = cloud.getId() + "_" + UclientApplication.getUid(activity) + indexFileName; //文件保存的名称  名称的格式为 文件id_当前登录人的UID+文件名称
                final String preViewDownLoadAddress = OssClientUtil.PREVIEW_FILE_PATH + saveFileName;// 预览图片的文件地址
                final DialogOpenFile progressDiaLog = new DialogOpenFile(activity, cloud.getFile_name()); //文件下载弹出框 只支持单一下载
                progressDiaLog.show();
                final OssClientUtil ossClientUtil = OssClientUtil.getInstance(activity.getApplicationContext(), configuration.getEndPoint(),
                        configuration.getAccessKeyId(), configuration.getAccessKeySecret(), configuration.getSecurityToken());
                ossClientUtil.preViewFile(preViewDownLoadAddress, cloud.getBucket_name(), cloud.getOss_file_name(), cloud, new OssClientUtil.PreviewFileListener() {
                    @Override
                    public void onProgress(final long current, final long total) {
                        activity.runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                if (progressDiaLog.isShowing()) {
                                    progressDiaLog.updateDownLoading((float) current / total); //修改文件的下载进度
                                }
                            }
                        });
                    }

                    @Override
                    public void onSuccess() { //文件下载成功
                        activity.runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                progressDiaLog.dismiss();
                                File file = new File(preViewDownLoadAddress);
                                if (file.exists()) {
                                    if (openType == SHARE_FILE) { //分享文件
                                        ShareUtil.shareFile(file, activity);
                                    } else if (openType == OPEN_FILE) { //打开文件
                                        cloud.setFileLocalPath(preViewDownLoadAddress);
                                        openFile(activity, cloud, list);
                                    }
                                }
                            }
                        });
                    }

                    @Override
                    public void onFailure(final String errorMsg) {
                        activity.runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                progressDiaLog.dismiss();
                                if (!TextUtils.isEmpty(errorMsg)) {
                                    CommonMethod.makeNoticeLong(activity, errorMsg, CommonMethod.ERROR);
                                }
                                File file = new File(preViewDownLoadAddress);
                                if (file.exists())
                                    file.delete();
                            }
                        });
                    }
                });
                progressDiaLog.setListener(new DialogOpenFile.FileCancelDownLoadListener() { //文件取消
                    @Override
                    public void cancel() {
                        ossClientUtil.cancelPreViewDownLoad(cloud);
                        File file = new File(preViewDownLoadAddress);
                        if (file.exists())
                            file.delete();
                    }
                });
            }
        });
    }


    /**
     * 云盘列表
     */
    public interface GetFileListListener {
        public void onSuccess(List<Cloud> list);

        public void onFailure();
    }

    /**
     * 获取阿里云盘配置回调
     */
    public interface GetOssConfigurationListener {
        public void onSuccess(CloudConfiguration configuration);
    }

    /**
     * 移动文件回调
     */
    public interface MoveFileListener {
        public void onSuccess();
    }

    /**
     * 上传文件回调
     */
    public interface UploadFileListener {
        public void onSuccess(CloudConfiguration configuration);
    }


    //android获取一个用于打开PPT文件的intent
    public static void openPptFileIntent(Context context, String param) {
        try {
            Intent intent = new Intent(Intent.ACTION_VIEW);
            intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            if (Build.VERSION.SDK_INT >= 24) {// 判断是否是7.0
                // 适配android7.0 ，不能直接访问原路径
                // 需要对intent 授权
                intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
                intent.setDataAndType(FileProvider.getUriForFile(context, context.getPackageName() + ".fileProvider", new File(param)), "application/vnd.ms-powerpoint");
            } else {
                intent.setDataAndType(Uri.fromFile(new File(param)), "application/vnd.ms-powerpoint");
            }
            context.startActivity(intent);
        } catch (Exception e) {
            e.printStackTrace();
            CommonMethod.makeNoticeShort(context, context.getString(R.string.can_not_open_ppt), CommonMethod.ERROR);
        }
    }

    //android获取一个用于打开Excel文件的intent
    public static void openExcelFileIntent(Context context, String param) {
        try {
            Intent intent = new Intent(Intent.ACTION_VIEW);
            intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            if (Build.VERSION.SDK_INT >= 24) {// 判断是否是7.0
                // 适配android7.0 ，不能直接访问原路径
                // 需要对intent 授权
                intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
                intent.setDataAndType(FileProvider.getUriForFile(context, context.getPackageName() + ".fileProvider", new File(param)), "application/vnd.ms-excel");
            } else {
                intent.setDataAndType(Uri.fromFile(new File(param)), "application/vnd.ms-excel");
            }
            context.startActivity(intent);
        } catch (Exception e) {
            e.printStackTrace();
            CommonMethod.makeNoticeShort(context, context.getString(R.string.can_not_open_excel), CommonMethod.ERROR);
        }
    }

    //android获取一个用于打开Word文件的intent
    public static void openWordFileIntent(Context context, String param) {
        try {
            Intent intent = new Intent(Intent.ACTION_VIEW);
            intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            if (Build.VERSION.SDK_INT >= 24) {// 判断是否是7.0
                // 适配android7.0 ，不能直接访问原路径
                // 需要对intent 授权
                intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
                intent.setDataAndType(FileProvider.getUriForFile(context, context.getPackageName() + ".fileProvider", new File(param)), "application/msword");
            } else {
                intent.setDataAndType(Uri.fromFile(new File(param)), "application/msword");
            }
            context.startActivity(intent);
        } catch (Exception e) {
            e.printStackTrace();
            CommonMethod.makeNoticeShort(context, context.getString(R.string.can_not_open_word), CommonMethod.ERROR);
        }
    }

    //android获取一个用于打开文本文件的intent
    public static void openTextFileIntent(Context context, String param) {
        try {
            Intent intent = new Intent(Intent.ACTION_VIEW);
            intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            if (Build.VERSION.SDK_INT >= 24) {// 判断是否是7.0
                // 适配android7.0 ，不能直接访问原路径
                // 需要对intent 授权
                intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
                intent.setDataAndType(FileProvider.getUriForFile(context, context.getPackageName() + ".fileProvider", new File(param)), "text/plain");
            } else {
                intent.setDataAndType(Uri.fromFile(new File(param)), "text/plain");
            }
            context.startActivity(intent);
        } catch (Exception e) {
            e.printStackTrace();
            CommonMethod.makeNoticeShort(context, context.getString(R.string.can_not_open_txt), CommonMethod.ERROR);
        }
    }

    //android获取一个用于打开PDF文件的intent
    public static void openPdfFileIntent(Context context, String param) {
        try {
            Intent intent = new Intent(Intent.ACTION_VIEW);
            intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            if (Build.VERSION.SDK_INT >= 24) {// 判断是否是7.0
                // 适配android7.0 ，不能直接访问原路径
                // 需要对intent 授权
                intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
                intent.setDataAndType(FileProvider.getUriForFile(context, context.getPackageName() + ".fileProvider", new File(param)), "application/pdf");
            } else {
                intent.setDataAndType(Uri.fromFile(new File(param)), "application/pdf");
            }
            context.startActivity(intent);
        } catch (Exception e) {
            e.printStackTrace();
            CommonMethod.makeNoticeShort(context, context.getString(R.string.can_not_open_pdf), CommonMethod.ERROR);
        }
    }


    //android获取一个用于打开PDF文件的intent
    public static void openCadFileIntent(Context context, String param) {
        try {
            Intent intent = new Intent(Intent.ACTION_VIEW);
            intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            if (Build.VERSION.SDK_INT >= 24) {// 判断是否是7.0
                // 适配android7.0 ，不能直接访问原路径
                // 需要对intent 授权
                intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
                intent.setDataAndType(FileProvider.getUriForFile(context, context.getPackageName() + ".fileProvider", new File(param)), "application/x-autocad");
            } else {
                intent.setDataAndType(Uri.fromFile(new File(param)), "application/x-autocad");
            }
            context.startActivity(intent);
        } catch (Exception e) {
            e.printStackTrace();
            CommonMethod.makeNoticeShort(context, context.getString(R.string.can_not_open_cad), CommonMethod.ERROR);
        }
    }

}