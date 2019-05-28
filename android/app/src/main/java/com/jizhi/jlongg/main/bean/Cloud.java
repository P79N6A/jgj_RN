package com.jizhi.jlongg.main.bean;

import java.io.Serializable;
import java.util.List;

/**
 * 云
 *
 * @author xuj
 * @version 1.0
 * @time 2017年7月17日10:43:54
 */
public class Cloud implements Serializable {


    /**
     * 文件id
     */
    private String id;
    /**
     * 文件名称
     */
    private String file_name;
    /**
     *
     */
    private String oss_file_name;
    /**
     * 文件夹父id
     */
    private String parent_id;
    /**
     * 空间名称
     */
    private String bucket_name;
    /**
     * 文件类型 区分是dir还是文件
     */
    private String type;
    /**
     * 文件大小
     */
    private String file_size;
    /**
     * 文件创建时间
     */
    private String date;
    /**
     * 文件修改时间
     */
    private String update_time;
    /**
     * 文件类型
     */
    private String file_type;
    /**
     * 文件属于哪个类型  比如word有2007和2003他们的格式都不一样  需要统一返回然后本地设置 相同的icon
     */
    private String file_broad_type;
    /**
     * 文件路径
     */
    private String file_path;
    /**
     * 图片缩略图
     */
    private String thumbnail_file_path;
    /**
     * 是否显示文件内容详情
     */
    private boolean isShowFileDetail;
    /**
     * 是否选中
     */
    private boolean isSelected;
    /**
     * 文件手机本地路径
     */
    private String fileLocalPath;
    /**
     * 文件总大小
     */
    private long fileTotalSize;
    /**
     * 文件已下载大小
     */
    private long file_downloading_size;
    /**
     * 文件类型状态  1为 上传  2为下载
     */
    private int fileTypeState;
    /**
     * 文件状态
     * public static final int FILE_NO_COMPLETE_STATE = 1; //文件未下载标识
     * public static final int FILE_LOADING_STATE = 2; //文件正在下载标识
     * public static final int FILE_COMPLETED_STATE = 3; //文件下载完毕标识
     */
    private int fileState;

    /**
     * 所属项目id
     */
    private String group_id;
    /**
     * 上传的唯一编号 主要是做断点续传使用
     */
    private String upLoadId;
    /**
     * 操作人姓名
     */
    private String opeator_name;



    private List<Cloud> list;

    public String getFile_name() {
        return file_name;
    }

    public void setFile_name(String file_name) {
        this.file_name = file_name;
    }


    public String getFile_path() {
        return file_path;
    }

    public void setFile_path(String file_path) {
        this.file_path = file_path;
    }


    public Cloud(String file_name, String type) {
        this.file_name = file_name;
        this.type = type;
    }

    public Cloud() {
    }

    /**
     * 读取数据库时构建的对象
     *
     * @param fileId
     * @param file_name
     * @param bucket_name
     * @param oss_file_name
     * @param file_size
     * @param date
     * @param file_type
     * @param file_broad_type
     * @param file_downloading_size
     * @param file_path
     * @param fileLocalPath
     * @param fileTotalSize
     * @param fileTypeState
     * @param fileState
     * @param parent_id
     * @param groupId
     * @param type
     */
    public Cloud(String fileId, String file_name, String bucket_name, String oss_file_name, String file_size, String date, String file_type, String file_broad_type,
                 long file_downloading_size, String file_path, String thumbnail_file_path, String fileLocalPath, long fileTotalSize, int fileTypeState, int fileState,
                 String parent_id, String groupId, String type, String upLoadId) {
        this.id = fileId;
        this.file_name = file_name;
        this.bucket_name = bucket_name;
        this.oss_file_name = oss_file_name;
        this.file_size = file_size;
        this.date = date;
        this.file_type = file_type;
        this.file_broad_type = file_broad_type;
        this.file_downloading_size = file_downloading_size;
        this.file_path = file_path;
        this.thumbnail_file_path = thumbnail_file_path;
        this.fileLocalPath = fileLocalPath;
        this.fileTotalSize = fileTotalSize;
        this.fileTypeState = fileTypeState;
        this.fileState = fileState;
        this.parent_id = parent_id;
        this.group_id = groupId;
        this.type = type;
        this.upLoadId = upLoadId;
    }


    /**
     * 文件上传 首次保存对象时需要创建的对象
     *
     * @param fileId
     * @param fileName
     * @param filePath
     * @param bucket_name
     * @param oss_file_name
     * @param date
     * @param file_broad_type
     * @param file_type
     * @param fileLocalPath
     * @param fileTotalSize
     * @param fileState
     * @param fileTypeState
     * @param parent_id
     * @param groupId
     */
    public Cloud(String fileId, String fileName, String filePath, String bucket_name, String oss_file_name, String date, String file_broad_type, String file_type,
                 String fileLocalPath, long fileTotalSize, int fileState, int fileTypeState, String parent_id, String groupId, String type, String upLoadId) {
        this.id = fileId;
        this.file_name = fileName;
        this.file_path = filePath;
        this.bucket_name = bucket_name;
        this.oss_file_name = oss_file_name;
        this.date = date;
        this.file_type = file_type;
        this.file_broad_type = file_broad_type;
        this.fileLocalPath = fileLocalPath;
        this.fileTotalSize = fileTotalSize;
        this.fileState = fileState;
        this.fileTypeState = fileTypeState;
        this.parent_id = parent_id;
        this.group_id = groupId;
        this.type = type;
        this.upLoadId = upLoadId;
        this.thumbnail_file_path = filePath;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }


    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }


    public String getFile_size() {
        return file_size;
    }

    public void setFile_size(String file_size) {
        this.file_size = file_size;
    }


    public boolean isShowFileDetail() {
        return isShowFileDetail;
    }

    public void setShowFileDetail(boolean showFileDetail) {
        isShowFileDetail = showFileDetail;
    }

    public boolean isSelected() {
        return isSelected;
    }

    public void setSelected(boolean selected) {
        isSelected = selected;
    }

    public String getParent_id() {
        return parent_id;
    }

    public void setParent_id(String parent_id) {
        this.parent_id = parent_id;
    }

    public String getBucket_name() {
        return bucket_name;
    }

    public void setBucket_name(String bucket_name) {
        this.bucket_name = bucket_name;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public List<Cloud> getList() {
        return list;
    }

    public void setList(List<Cloud> list) {
        this.list = list;
    }

    public String getFile_type() {
        return file_type;
    }

    public void setFile_type(String file_type) {
        this.file_type = file_type;
    }

    public String getFile_broad_type() {
        return file_broad_type;
    }

    public void setFile_broad_type(String file_broad_type) {
        this.file_broad_type = file_broad_type;
    }


    public String getFileLocalPath() {
        return fileLocalPath;
    }

    public void setFileLocalPath(String fileLocalPath) {
        this.fileLocalPath = fileLocalPath;
    }


    public String getOss_file_name() {
        return oss_file_name;
    }

    public void setOss_file_name(String oss_file_name) {
        this.oss_file_name = oss_file_name;
    }

    public long getFileTotalSize() {
        return fileTotalSize;
    }

    public void setFileTotalSize(long fileTotalSize) {
        this.fileTotalSize = fileTotalSize;
    }

    public long getFile_downloading_size() {
        return file_downloading_size;
    }

    public void setFile_downloading_size(long file_downloading_size) {
        this.file_downloading_size = file_downloading_size;
    }


    public int getFileTypeState() {
        return fileTypeState;
    }

    public void setFileTypeState(int fileTypeState) {
        this.fileTypeState = fileTypeState;
    }

    public int getFileState() {
        return fileState;
    }

    public void setFileState(int fileState) {
        this.fileState = fileState;
    }


    public String getThumbnail_file_path() {
        return thumbnail_file_path;
    }

    public void setThumbnail_file_path(String thumbnail_file_path) {
        this.thumbnail_file_path = thumbnail_file_path;
    }

    @Override
    public String toString() {
        return "Cloud{" +
                "id='" + id + '\'' +
                ", file_name='" + file_name + '\'' +
                ", oss_file_name='" + oss_file_name + '\'' +
                ", parent_id='" + parent_id + '\'' +
                ", bucket_name='" + bucket_name + '\'' +
                ", type='" + type + '\'' +
                ", file_size='" + file_size + '\'' +
                ", date='" + date + '\'' +
                ", file_type='" + file_type + '\'' +
                ", file_broad_type='" + file_broad_type + '\'' +
                ", file_path='" + file_path + '\'' +
                ", thumbnail_file_path='" + thumbnail_file_path + '\'' +
                ", isShowFileDetail=" + isShowFileDetail +
                ", isSelected=" + isSelected +
                ", fileLocalPath='" + fileLocalPath + '\'' +
                ", fileTotalSize=" + fileTotalSize +
                ", file_downloading_size=" + file_downloading_size +
                ", fileTypeState=" + fileTypeState +
                ", fileState=" + fileState +
                ", groupId='" + group_id + '\'' +
                ", list=" + list +
                '}';
    }

    public String getUpLoadId() {
        return upLoadId;
    }

    public void setUpLoadId(String upLoadId) {
        this.upLoadId = upLoadId;
    }

    public String getGroup_id() {
        return group_id;
    }

    public void setGroup_id(String group_id) {
        this.group_id = group_id;
    }

    public String getUpdate_time() {
        return update_time;
    }

    public void setUpdate_time(String update_time) {
        this.update_time = update_time;
    }

    public String getOpeator_name() {
        return opeator_name;
    }

    public void setOpeator_name(String opeator_name) {
        this.opeator_name = opeator_name;
    }
}
