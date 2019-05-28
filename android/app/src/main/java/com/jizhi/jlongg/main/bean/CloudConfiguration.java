package com.jizhi.jlongg.main.bean;

/**
 * Created by Administrator on 2017/7/25 0025.
 */
public class CloudConfiguration {
    /**
     * 访问id
     */
    private String AccessKeyId;
    /**
     * 秘钥
     */
    private String AccessKeySecret;
    /**
     * token
     */
    private String SecurityToken;
    /**
     * 访问地址
     */
    private String EndPoint;
    /**
     * 空间名
     */
    private String Bucketname;
    /**
     * 有效期
     */
    private String Expiration;
    /**
     * 回调地址
     */
    private String callbackUrl;
    /**
     *
     */
    private String callbackBody;
    /**
     *
     */
    private String object_name;
    /**
     * 文件id
     */
    private String id;
    /**
     * 文件属于哪个类型  比如word有2007和2003他们的格式都不一样  需要统一返回然后本地设置 相同的icon  主要是文件上传的时候使用
     */
    private String file_broad_type;
    /**
     * 文件大小
     */
    private long file_size;
    /**
     * 文件上传时间
     */
    private long upload_time;
    /**
     * 表示剩余空间（字节）
     */
    private long reduce_space;


    public String getAccessKeyId() {
        return AccessKeyId;
    }

    public void setAccessKeyId(String accessKeyId) {
        AccessKeyId = accessKeyId;
    }

    public String getAccessKeySecret() {
        return AccessKeySecret;
    }

    public void setAccessKeySecret(String accessKeySecret) {
        AccessKeySecret = accessKeySecret;
    }

    public String getSecurityToken() {
        return SecurityToken;
    }

    public void setSecurityToken(String securityToken) {
        SecurityToken = securityToken;
    }

    public String getEndPoint() {
        return EndPoint;
    }

    public void setEndPoint(String endPoint) {
        EndPoint = endPoint;
    }

    public String getBucketname() {
        return Bucketname;
    }

    public void setBucketname(String bucketname) {
        Bucketname = bucketname;
    }

    public String getExpiration() {
        return Expiration;
    }

    public void setExpiration(String expiration) {
        Expiration = expiration;
    }

    public String getCallbackUrl() {
        return callbackUrl;
    }

    public void setCallbackUrl(String callbackUrl) {
        this.callbackUrl = callbackUrl;
    }

    public String getCallbackBody() {
        return callbackBody;
    }

    public void setCallbackBody(String callbackBody) {
        this.callbackBody = callbackBody;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getFile_broad_type() {
        return file_broad_type;
    }

    public void setFile_broad_type(String file_broad_type) {
        this.file_broad_type = file_broad_type;
    }

    public String getObject_name() {
        return object_name;
    }

    public void setObject_name(String object_name) {
        this.object_name = object_name;
    }

    public long getFile_size() {
        return file_size;
    }

    public void setFile_size(long file_size) {
        this.file_size = file_size;
    }

    public long getUpload_time() {
        return upload_time;
    }

    public void setUpload_time(long upload_time) {
        this.upload_time = upload_time;
    }

    public long getReduce_space() {
        return reduce_space;
    }

    public void setReduce_space(long reduce_space) {
        this.reduce_space = reduce_space;
    }
}
