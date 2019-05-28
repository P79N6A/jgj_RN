package com.jizhi.jlongg.main.util.cloud;

import com.alibaba.sdk.android.oss.callback.OSSProgressCallback;
import com.alibaba.sdk.android.oss.model.OSSRequest;

import java.util.Map;

/**
 * Created by OSS on 2015/12/8 0008.
 * 断点上传任务的请求
 */
public class PauseableUploadRequest extends OSSRequest {
    private String bucket;
    private String object;
    private String localFile;
    private int partSize;
    private OSSProgressCallback<PauseableUploadRequest> progressCallback;

    private Map<String, String> callbackParam;
    private Map<String, String> callbackVars;

    public OSSProgressCallback<PauseableUploadRequest> getProgressCallback() {
        return progressCallback;
    }

    public void setProgressCallback(OSSProgressCallback<PauseableUploadRequest> progressCallback) {
        this.progressCallback = progressCallback;
    }

    public PauseableUploadRequest(String bucket, String object, String localFile, int partSize) {
        this.bucket = bucket;
        this.object = object;
        this.localFile = localFile;
        this.partSize = partSize;
    }


    public String getBucket() {
        return bucket;
    }

    public void setBucket(String bucket) {
        this.bucket = bucket;
    }

    public String getObject() {
        return object;
    }

    public void setObject(String object) {
        this.object = object;
    }

    public String getLocalFile() {
        return localFile;
    }

    public void setLocalFile(String localFile) {
        this.localFile = localFile;
    }

    public int getPartSize() {
        return partSize;
    }

    public void setPartSize(int partSize) {
        this.partSize = partSize;
    }

    public Map<String, String> getCallbackParam() {
        return callbackParam;
    }

    public void setCallbackParam(Map<String, String> callbackParam) {
        this.callbackParam = callbackParam;
    }

    public Map<String, String> getCallbackVars() {
        return callbackVars;
    }

    public void setCallbackVars(Map<String, String> callbackVars) {
        this.callbackVars = callbackVars;
    }
}
