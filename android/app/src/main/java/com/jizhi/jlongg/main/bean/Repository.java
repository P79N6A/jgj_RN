package com.jizhi.jlongg.main.bean;

import java.io.Serializable;

/**
 * 知识库
 *
 * @author xuj
 * @version 1.0
 * @time 2017年3月27日17:06:07
 */
public class Repository implements Serializable {
    /**
     * 状态标识
     */
    private int stateFlag;
    /**
     * 文件大小、主要是做展示
     */
    private String file_size;
    /**
     * 当前文件id
     */
    private String id;
    /**
     * 文件类型   dir、
     */
    private String file_type;
    /**
     * 文件名称
     */
    private String file_name;
    /**
     * 文件大小
     */
    private String file_total_size;
    /**
     * //0:文件；1：表示收藏夹；2：资料那些事
     */
    private int type;
    /**
     * 文件路径
     */
    private String file_path;
    /**
     * 是否在下载文件
     */
    private boolean is_downloading;
    /**
     * 下载文件的百分比
     */
    private float downloadPercentage;
    /**
     * 文件下载中的大小
     */
    private String fileDownLoadDesc;
    /**
     * 文件是否下载完毕
     */
    private boolean isDownloadFile;
    /**
     * 是否收藏、 0.未收藏  1.收藏
     */
    private int is_collection;
    /**
     * 文件创建时间
     */
    private String create_time;
    /**
     * 文件是否选中
     */
    private boolean is_selected;
    /**
     * 是否显示详情页收藏按钮
     */
    private boolean is_show_collection_btn = true;
    //1成功
    private int status;

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public boolean isIs_downloading() {
        return is_downloading;
    }

    public String getFile_name() {
        return file_name;
    }

    public void setFile_name(String file_name) {
        this.file_name = file_name;
    }

    public String getFile_total_size() {
        return file_total_size;
    }

    public void setFile_total_size(String file_total_size) {
        this.file_total_size = file_total_size;
    }

    public String getFile_path() {
        return file_path;
    }

    public void setFile_path(String file_path) {
        this.file_path = file_path;
    }

    public boolean is_downloading() {
        return is_downloading;
    }

    public void setIs_downloading(boolean is_downloading) {
        this.is_downloading = is_downloading;
    }

    public Repository(String file_name, String file_size, String file_path) {
        this.file_name = file_name;
        this.file_total_size = file_size;
        this.file_path = file_path;
    }


    public Repository(String file_name, String file_path, String create_time, String file_type, boolean is_show_collection_btn) {
        this.file_name = file_name;
        this.file_path = file_path;
        this.file_type = file_type;
        this.create_time = create_time;
        this.is_show_collection_btn = is_show_collection_btn;
    }

    public float getDownloadPercentage() {
        return downloadPercentage;
    }

    public void setDownloadPercentage(float downloadPercentage) {
        this.downloadPercentage = downloadPercentage;
    }

    public String getFileDownLoadDesc() {
        return fileDownLoadDesc;
    }

    public void setFileDownLoadDesc(String fileDownLoadDesc) {
        this.fileDownLoadDesc = fileDownLoadDesc;
    }


    public String getFile_type() {
        return file_type;
    }

    public void setFile_type(String file_type) {
        this.file_type = file_type;
    }

    public int getIs_collection() {
        return is_collection;
    }

    public void setIs_collection(int is_collection) {
        this.is_collection = is_collection;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public boolean isDownloadFile() {
        return isDownloadFile;
    }

    public void setDownloadFile(boolean downloadFile) {
        isDownloadFile = downloadFile;
    }

    public String getFile_size() {
        return file_size;
    }

    public void setFile_size(String file_size) {
        this.file_size = file_size;
    }

    public int getStateFlag() {
        return stateFlag;
    }

    public void setStateFlag(int stateFlag) {
        this.stateFlag = stateFlag;
    }

    public int getType() {
        return type;
    }

    public void setType(int type) {
        this.type = type;
    }

    public String getCreate_time() {
        return create_time;
    }

    public void setCreate_time(String create_time) {
        this.create_time = create_time;
    }

    public boolean isIs_selected() {
        return is_selected;
    }

    public void setIs_selected(boolean is_selected) {
        this.is_selected = is_selected;
    }

    public boolean isIs_show_collection_btn() {
        return is_show_collection_btn;
    }

    public void setIs_show_collection_btn(boolean is_show_collection_btn) {
        this.is_show_collection_btn = is_show_collection_btn;
    }
}
