package com.jizhi.jlongg.db.dao;


import android.content.Context;

import com.jizhi.jlongg.main.bean.Cloud;

import java.util.List;

/**
 * 功能: 项目云
 * 作者：Xuj
 * 时间: 2017年7月31日15:40:10
 */
public interface ProCloudDao {


    /**
     * 清空加载状态
     * @return
     */
    public void clearLoadingState();


    /**
     * 获取文件上传的状态
     *
     * @param context
     * @return
     */
    public int getFileUpLoadState(Context context, String fileLocalPath, String groupId);

    /**
     * 获取下载的文件状态
     *
     * @param context
     * @return
     */
    public int getFileDownLoadState(Context context, String fileId, String groupId);

    /**
     * 获取已下载的文件信息
     *
     * @param context
     * @return
     */
    public Cloud getFileDownLoadInfo(Context context, String fileId, String groupId);

    /**
     * 获取已上传的文件信息
     *
     * @param context
     * @return
     */
    public Cloud getFileUpLoadInfo(Context context, String fileId, String groupId);

    /**
     * 获取云盘已下载的列表
     *
     * @param context
     * @return
     */
    public List<Cloud> getUploadOrDownLoadFileList(Context context, int fileState, String groupId);

    /**
     * 修改文件下载进度
     */
    public void updateFileDownLoadProgress(Context context, Cloud cloud, String groupId);

    /**
     * 修改文件上传进度
     */
    public void updateFileUpLoadProgress(Context context, Cloud cloud, String groupId);


    /**
     * 修改文件上传id
     */
    public void setUpLoadId(Context context, Cloud cloud, String groupId);

    /**
     * 修改下载完毕的标志
     *
     * @param cloud
     */
    public void updateFileDownloadFileState(Context context, Cloud cloud, String groupId);

    /**
     * 修改下载完毕的标志
     *
     * @param cloud
     */
    public void updateFileUpLoadFileState(Context context, Cloud cloud, String groupId);

    /**
     * 保存下载文件信息
     *
     * @param context
     * @param cloud
     */
    public void saveFileDownLoadInfo(Context context, Cloud cloud);

    /**
     * 保存上传文件信息
     *
     * @param context
     * @param cloud
     */
    public void saveFileUpLoadInfo(Context context, Cloud cloud, String groupId);


    /**
     * 移除下载文件信息
     *
     * @param context
     * @param fileId
     */
    public void deleteFileInfo(Context context, String fileId, String groupId, String fileTypeState);
}
