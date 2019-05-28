package com.jizhi.jlongg.main.util.cloud;

import android.content.Context;
import android.os.Environment;
import android.text.TextUtils;
import android.util.Log;

import com.alibaba.sdk.android.oss.ClientConfiguration;
import com.alibaba.sdk.android.oss.ClientException;
import com.alibaba.sdk.android.oss.OSS;
import com.alibaba.sdk.android.oss.OSSClient;
import com.alibaba.sdk.android.oss.ServiceException;
import com.alibaba.sdk.android.oss.callback.OSSCompletedCallback;
import com.alibaba.sdk.android.oss.callback.OSSProgressCallback;
import com.alibaba.sdk.android.oss.common.auth.OSSCredentialProvider;
import com.alibaba.sdk.android.oss.common.auth.OSSStsTokenCredentialProvider;
import com.alibaba.sdk.android.oss.internal.OSSAsyncTask;
import com.alibaba.sdk.android.oss.model.GetObjectRequest;
import com.alibaba.sdk.android.oss.model.GetObjectResult;
import com.alibaba.sdk.android.oss.model.Range;
import com.hcs.uclient.utils.FUtils;
import com.hcs.uclient.utils.LUtils;
import com.jizhi.jlongg.db.ProCloudService;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.Cloud;
import com.jizhi.jlongg.main.bean.CloudConfiguration;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.ThreadPoolUtils;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;
import java.util.Map;

import noman.weekcalendar.eventbus.BusProvider;

/**
 * 阿里云盘工具
 *
 * @author Xuj
 * @time 2017年7月25日16:32:12
 * @Version 1.0
 */
public class OssClientUtil {

    /**
     * 缓存Oss对象的时间为20分钟
     */
    private static final long CACHE_TIME = 20 * 60 * 1000;
    /**
     * 记录时间
     */
    private static long usedTime = 0;

    /**
     * 文件预览集合
     */
    private Map<String, OSSAsyncTask> preViewMap = new HashMap<>();
    /**
     * 文件下载集合数据
     */
    private Map<String, OSSAsyncTask> fileDownLoadMap = new HashMap<>();
    /**
     * 文件上传集合数据
     */
    private Map<String, PauseableUploadTask> fileUpLoadMap = new HashMap<>();
    /**
     * 云oss
     */
    private static OSS oss;
    /**
     * 当前类的实例化
     */
    private static OssClientUtil instance;
    /**
     * 文件在线打开
     */
    public static final String PREVIEW_FILE_PATH = Environment.getExternalStorageDirectory() + "/Jgj/Cloud/preview/";
    /**
     * 下载保存的文件路径
     */
    public static final String DOWNLOADED_PATH = Environment.getExternalStorageDirectory() + "/Jgj/Cloud/downloaded/";
    /**
     * 下载中保存的路径
     */
    public static final String DOWNLOADING_PATH = Environment.getExternalStorageDirectory() + "/Jgj/Cloud/downloading/";


    /**
     * 检查下载文件目录是否存在
     */
    private void checkDownLoadFileDirIsExists() {
        File downLoadingFile = new File(DOWNLOADING_PATH);
        if (!downLoadingFile.exists()) {
            downLoadingFile.mkdirs();
        }
        File downLoadedFile = new File(DOWNLOADED_PATH);
        if (!downLoadedFile.exists()) {
            downLoadedFile.mkdirs();
        }
    }


    private OssClientUtil() {
    }

    /**
     * 初始化
     */
    public static OssClientUtil getInstance(Context context, String endpoint, String accessKeyId, String accessKeySecret, String SecurityToken) {
        synchronized (OssClientUtil.class) {
            if (instance == null) {
                instance = new OssClientUtil();
            }
            initOssClient(context.getApplicationContext(), endpoint, accessKeyId, accessKeySecret, SecurityToken);
        }
        return instance;
    }


    private static void initOssClient(Context context, String endpoint, String accessKeyId, String accessKeySecret, String SecurityToken) {
        long currentTime = System.currentTimeMillis();
        if (oss == null || currentTime - usedTime >= CACHE_TIME) {
            OSSCredentialProvider credentialProvider = new OSSStsTokenCredentialProvider(accessKeyId, accessKeySecret, SecurityToken);
            ClientConfiguration conf = new ClientConfiguration();
            conf.setConnectionTimeout(15 * 1000); // 连接超时，默认15秒
            conf.setSocketTimeout(15 * 1000); // socket超时，默认15秒
            conf.setMaxConcurrentRequest(5); // 最大并发请求书，默认5个
            conf.setMaxErrorRetry(2); // 失败后最大重试次数，默认2次
            oss = new OSSClient(context, endpoint, credentialProvider, conf);
            usedTime = currentTime;
        }
    }

    /**
     * 初始化
     */
    public static OssClientUtil getInstance() {
        synchronized (OssClientUtil.class) {
            if (instance == null) {
                instance = new OssClientUtil();
            }
        }
        return instance;
    }


    /**
     * 设置完成标识
     *
     * @param cloud
     * @param context
     */
    public void setCompleteTag(Cloud cloud, Context context, String groupId) {
        cloud.setFileState(CloudUtil.FILE_COMPLETED_STATE); //设置文件完毕标识
        BusProvider.getInstance().post(cloud);
        switch (cloud.getFileTypeState()) {
            case CloudUtil.FILE_TYPE_DOWNLOAD_TAG: //文件下载
                String fileId = cloud.getId(); //文件id
                if (fileDownLoadMap != null && fileDownLoadMap.size() > 0 && fileDownLoadMap.containsKey(fileId)) {
                    fileDownLoadMap.get(fileId).cancel();
                    fileDownLoadMap.remove(fileId);
                    ProCloudService.getInstance(context).updateFileDownloadFileState(context, cloud, groupId);
                    LUtils.e("文件下载完毕 还剩下:" + fileUpLoadMap.size() + "个task         当前上传状态:" + cloud.getFileState());
                }
                break;
            case CloudUtil.FILE_TYPE_UPLOAD_TAG: //文件上传
                String fileLocalPath = cloud.getFileLocalPath();
                if (fileUpLoadMap != null && fileUpLoadMap.size() > 0 && fileUpLoadMap.containsKey(fileLocalPath)) {
                    fileUpLoadMap.get(fileLocalPath).pause();
                    fileUpLoadMap.remove(fileLocalPath);
                    ProCloudService.getInstance(context).updateFileUpLoadFileState(context, cloud, groupId);
                    LUtils.e("文件上传完毕 还剩下:" + fileUpLoadMap.size() + "个task         当前上传状态:" + cloud.getFileState());
                }
                break;
        }
    }


    /**
     * 暂停下载
     *
     * @param cloud
     * @param context
     */
    public void setPauseTag(Cloud cloud, Context context, String groupId) {
        cloud.setFileState(CloudUtil.FILE_NO_COMPLETE_STATE); //设置文件下载失败标识
        BusProvider.getInstance().post(cloud);
        switch (cloud.getFileTypeState()) {
            case CloudUtil.FILE_TYPE_DOWNLOAD_TAG: //文件下载
                String fileId = cloud.getId(); //文件id
                if (fileDownLoadMap != null && fileDownLoadMap.size() > 0 && fileDownLoadMap.containsKey(fileId)) {
                    fileDownLoadMap.get(fileId).cancel();
                    fileDownLoadMap.remove(fileId);
                    ProCloudService.getInstance(context).updateFileDownloadFileState(context, cloud, groupId);
                    LUtils.e("fileDownLoadMap:" + fileDownLoadMap.size());
                }
                break;
            case CloudUtil.FILE_TYPE_UPLOAD_TAG: //文件上传
                String fileLocalPath = cloud.getFileLocalPath();
                if (fileUpLoadMap != null && fileUpLoadMap.size() > 0 && fileUpLoadMap.containsKey(fileLocalPath)) {
                    fileUpLoadMap.get(fileLocalPath).pause();
                    fileUpLoadMap.remove(fileLocalPath);
                    ProCloudService.getInstance(context).updateFileUpLoadFileState(context, cloud, groupId);
                    LUtils.e("fileUpLoadMap:" + fileUpLoadMap.size());
                }
                break;
        }
    }


    /**
     * 开始下载
     *
     * @param cloud
     * @param context
     */
    public void setStartTag(Cloud cloud, Context context, String groupId) {
        cloud.setFileState(CloudUtil.FILE_LOADING_STATE); //设置文件开始下载标识
        BusProvider.getInstance().post(cloud);
        switch (cloud.getFileTypeState()) {
            case CloudUtil.FILE_TYPE_DOWNLOAD_TAG: //文件下载
                ProCloudService.getInstance(context).updateFileDownloadFileState(context, cloud, groupId); //修改数据库中文件下载标识
                break;
            case CloudUtil.FILE_TYPE_UPLOAD_TAG: //文件上传
                ProCloudService.getInstance(context).updateFileUpLoadFileState(context, cloud, groupId); //修改数据库中文件下载标识
                break;
        }

    }


    /**
     * Oss文件下载
     *
     * @param context
     * @param bucketName 下载名称
     * @param bucketPath 下载路径
     * @param cloud      云信息
     */
    public void downLoadFile(final Context context, String bucketName, final String bucketPath,
                             final Cloud cloud, final String groupId) {
        checkDownLoadFileDirIsExists();
        setStartTag(cloud, context, groupId); //设置开始标志

        String indexFileName = null;
        String fileName = cloud.getFile_name();
        if (!TextUtils.isEmpty(fileName) && fileName.lastIndexOf(".") != -1) {
            indexFileName = fileName.substring(0, fileName.lastIndexOf(".")) + "." + cloud.getFile_type();
        } else {
            indexFileName = fileName + "." + cloud.getFile_type();
        }
        String saveFileName = cloud.getId() + "_" + UclientApplication.getUid(context) + "_" + indexFileName; //文件保存的名称 格式为:fileid_uid_文件名称
        final String downLoadedPath = OssClientUtil.DOWNLOADED_PATH + saveFileName;// 下载完毕的路径
        final String downLoadindPath = OssClientUtil.DOWNLOADING_PATH + saveFileName; //下载中的路径

        GetObjectRequest get = new GetObjectRequest(bucketName, bucketPath);
        get.setRange(new Range(cloud.getFile_downloading_size(), Range.INFINITE)); // 设置范围 下载从100个字节到结尾
        final OSSAsyncTask task = oss.asyncGetObject(get, new OSSCompletedCallback<GetObjectRequest, GetObjectResult>() {
            @Override
            public void onSuccess(GetObjectRequest request, GetObjectResult result) {
                FileOutputStream outputStream = null;
                InputStream inputStream = result.getObjectContent(); // 请求成功
                long dataRefreshTime = 0; //记录界面刷新的时间
                byte[] buffer = new byte[2048];
                int len;
                try {
                    outputStream = new FileOutputStream(downLoadindPath, true);
                    while ((len = inputStream.read(buffer)) != -1) { //循环读取流
                        outputStream.write(buffer, 0, len);
                        cloud.setFile_downloading_size(cloud.getFile_downloading_size() + len); //修改文件已下载的进度
                        if (System.currentTimeMillis() - dataRefreshTime > 500) { //每次发送广播都休息500毫秒以免过度刷新列表
                            ProCloudService.getInstance(context).updateFileDownLoadProgress(context, cloud, groupId); //本地修改文件已下载的进度
                            BusProvider.getInstance().post(cloud); //发送广播修改进度条
                            dataRefreshTime = System.currentTimeMillis();
                        }
                    }
                    cloud.setFileLocalPath(downLoadedPath); //设置文件已下载完毕的路径
                    setCompleteTag(cloud, context, groupId);
                    FUtils.copyFileAndDeleteOldFile(downLoadindPath, downLoadedPath); //将下载好的文件拷贝到指定路径 然后再删除
                } catch (IOException e) {
                    e.printStackTrace();
                    setPauseTag(cloud, context, groupId);
                    CommonMethod.makeNoticeShort(context, e.getMessage(), CommonMethod.ERROR);
                } finally {
                    try {
                        if (outputStream != null) {
                            outputStream.close(); //关闭输出流
                        }
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                    try {
                        if (inputStream != null) {
                            inputStream.close(); //关闭输入流
                        }
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                    ProCloudService.getInstance(context).updateFileDownLoadProgress(context, cloud, groupId); //本地修改文件已下载的进度
                }
            }

            @Override
            public void onFailure(GetObjectRequest request, ClientException clientExcepion, ServiceException serviceException) {
                String info = "";
                // 请求异常
                if (clientExcepion != null) {
                    // 本地异常如网络异常等
                    clientExcepion.printStackTrace();
                    info = clientExcepion.toString();
                }
                if (serviceException != null) {
                    // 服务异常
                    LUtils.e("ErrorCode", serviceException.getErrorCode());
                    LUtils.e("RequestId", serviceException.getRequestId());
                    LUtils.e("HostId", serviceException.getHostId());
                    LUtils.e("RawMessage", serviceException.getRawMessage());
                    info = serviceException.toString();
                }
                setPauseTag(cloud, context, groupId);
                ProCloudService.getInstance(context).updateFileDownLoadProgress(context, cloud, groupId); //本地修改文件已下载的进度
                LUtils.e("文件下载失败原因:" + info);
            }
        });
        fileDownLoadMap.put(cloud.getId(), task);
        LUtils.e("文件开始下载当前map长度:" + fileDownLoadMap.size());
    }


    public void asyncUpload(final Context context, final Cloud cloud, final String bucketName, final String uploadFilePath,
                            String bucketKey, final String groupId, final CloudConfiguration configuration, final OssClientUtil.UpLoadSuccessListener listener) {
        setStartTag(cloud, context, groupId); //设置文件开始下载的标识
        final PauseableUploadRequest request = new PauseableUploadRequest(bucketName, bucketKey, uploadFilePath, 256 * 1024);
        request.setCallbackParam(new HashMap<String, String>() { //回调业务服务器
            {
                put("callbackUrl", configuration.getCallbackUrl());
                put("callbackBody", configuration.getCallbackBody());
            }
        });
        request.setCallbackVars(new HashMap<String, String>() { //回调业务服务器参数
            {
                put("x:id", configuration.getId());
            }
        });
        request.setProgressCallback(new OSSProgressCallback<PauseableUploadRequest>() {
            /**
             * 界面Ui更新时间  现在设置为500毫秒
             */
            long dataRefreshTime;

            //上传回调，这里的进度是指整个分片上传的进度
            @Override
            public void onProgress(PauseableUploadRequest pauseableUploadRequest, long currentSize, long totalSize) {
                cloud.setFile_downloading_size(currentSize); //修改文件已上传的进度 广播推送需要更新界面
                if (System.currentTimeMillis() - dataRefreshTime > 500) { //每次发送广播都休息500毫秒以免过度刷新列表
                    ProCloudService.getInstance(context).updateFileUpLoadProgress(context, cloud, groupId); //本地修改文件已上传的进度
                    BusProvider.getInstance().post(cloud); //发送广播修改进度条
                    dataRefreshTime = System.currentTimeMillis();
                }
            }
        });

        final PauseableUploadTask task = new PauseableUploadTask(oss, request, new OSSCompletedCallback<PauseableUploadRequest, PauseableUploadResult>() {
            //上传成功
            @Override
            public void onSuccess(PauseableUploadRequest request, PauseableUploadResult result) {
                LUtils.e("上传成功     获取的回调:" + result.getServerCallbackReturnBody());
                ProCloudService.getInstance(context).updateFileUpLoadProgress(context, cloud, groupId); //本地修改文件已下载的进度
                if (listener != null) {
                    listener.onUpdateSuccess();
                }
                setCompleteTag(cloud, context, groupId);
            }

            //上传失败
            @Override
            public void onFailure(PauseableUploadRequest request, ClientException clientExcepion, ServiceException serviceException) {
                String info = "";
                // 请求异常
                if (clientExcepion != null) {
                    // 本地异常如网络异常等
                    clientExcepion.printStackTrace();
                    info = clientExcepion.toString();
                }
                if (serviceException != null) {
                    // 服务异常
                    Log.e("ErrorCode", serviceException.getErrorCode());
                    Log.e("RequestId", serviceException.getRequestId());
                    Log.e("HostId", serviceException.getHostId());
                    Log.e("RawMessage", serviceException.getRawMessage());
                    info = serviceException.toString();
                }
                ProCloudService.getInstance(context).updateFileUpLoadProgress(context, cloud, groupId); //本地修改文件已下载的进度
                setPauseTag(cloud, context, groupId);
                // 异常处理
                LUtils.e("文件上传失败原因:" + info);

            }
        });
        ThreadPoolUtils.fixedThreadPool.execute(new Runnable() { //这里使用线程池来建立连接
            @Override
            public void run() {
                LUtils.e("run: " + Thread.currentThread().getName());
                try {
                    if (TextUtils.isEmpty(cloud.getUpLoadId())) {
                        cloud.setUpLoadId(task.initUpload()); //初始化得到UpLoadId
                        ProCloudService.getInstance(context).setUpLoadId(context, cloud, cloud.getGroup_id()); //将upLoadId 存在数据库中
                    }
                    fileUpLoadMap.put(uploadFilePath, task);
                    task.upload(cloud.getUpLoadId()); //使用uploadId来完成上传
                } catch (ServiceException e) {
                    e.printStackTrace();
                } catch (ClientException e) {
                    e.printStackTrace();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        });
    }


    /**
     * 文件预览
     *
     * @param preViewDownLoadAddress 文件预览下载地址
     * @param bucketName             储存空间名称
     * @param bucketPath             储存空间路径
     * @param cloud                  云信息
     * @param listener               进度监听
     */
    public void preViewFile(final String preViewDownLoadAddress, String bucketName, final String bucketPath, final Cloud cloud, final PreviewFileListener listener) {
        File preViewDir = new File(PREVIEW_FILE_PATH);
        if (!preViewDir.exists()) {
            preViewDir.mkdirs(); //创建预览的目录
        }
        GetObjectRequest get = new GetObjectRequest(bucketName, bucketPath);
        get.setRange(new Range(0, Range.INFINITE)); // 设置范围 下载从100个字节到结尾
        final OSSAsyncTask task = oss.asyncGetObject(get, new OSSCompletedCallback<GetObjectRequest, GetObjectResult>() {
            @Override
            public void onSuccess(GetObjectRequest request, GetObjectResult result) {
                FileOutputStream outputStream = null;
                InputStream inputStream = result.getObjectContent(); // 请求成功
                byte[] buffer = new byte[2048];
                int len;
                long progressCount = 0;
                try {
                    outputStream = new FileOutputStream(preViewDownLoadAddress);
                    while ((len = inputStream.read(buffer)) != -1) { //循环读取流
                        outputStream.write(buffer, 0, len);
                        progressCount += len;
                        listener.onProgress(progressCount, result.getContentLength());
                    }
                    listener.onSuccess();
                } catch (Exception e) {
                    e.printStackTrace();
                    listener.onFailure(null);
                } finally {
                    try {
                        if (outputStream != null) {
                            outputStream.close(); //关闭输出流
                        }
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                    try {
                        if (inputStream != null) {
                            inputStream.close(); //关闭输入流
                        }
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                    cancelPreViewDownLoad(cloud);
                }
            }

            @Override
            public void onFailure(GetObjectRequest request, ClientException clientExcepion, ServiceException serviceException) {
                String info = "";
                // 请求异常
                if (clientExcepion != null) {
                    // 本地异常如网络异常等
                    clientExcepion.printStackTrace();
                    info = clientExcepion.toString();
                }
                if (serviceException != null) {
                    // 服务异常
                    LUtils.e("ErrorCode", serviceException.getErrorCode());
                    LUtils.e("RequestId", serviceException.getRequestId());
                    LUtils.e("HostId", serviceException.getHostId());
                    LUtils.e("RawMessage", serviceException.getRawMessage());
                    info = serviceException.toString();
                }
                LUtils.e("文件预览失败原因:" + info);
//                listener.onFailure(context.getString(R.string.conn_fail));
                listener.onFailure("文件预览失败原因" + info);
                cancelPreViewDownLoad(cloud);
            }
        });
        preViewMap.put(cloud.getId(), task);
        LUtils.e("add:preViewMap:" + preViewMap.size());
    }

    /**
     * 取消下载
     */
    public void cancelPreViewDownLoad(Cloud cloud) {
        String fileId = cloud.getId();
        if (preViewMap != null && preViewMap.size() > 0 && preViewMap.containsKey(fileId)) {
            OSSAsyncTask task = preViewMap.get(fileId);
            if (!task.isCanceled()) {
                task.cancel();
            }
            preViewMap.remove(fileId);
            LUtils.e("remove:preViewMap:" + preViewMap.size());
        }
    }

    /**
     * 文件预览
     */
    public interface PreviewFileListener {
        public void onProgress(long current, long total); //获取文件下载进度

        public void onSuccess(); //文件下载成功  文件预览地址

        public void onFailure(String errormsg); //文件下载失败
    }

    /**
     * 文件上传成功后的回调
     */
    public interface UpLoadSuccessListener {
        public void onUpdateSuccess(); //文件上传成功
    }
}
