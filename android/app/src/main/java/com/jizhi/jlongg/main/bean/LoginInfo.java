package com.jizhi.jlongg.main.bean;

/**
 * Created by Administrator on 2017/3/14 0014.
 */

public class LoginInfo {
    String os = "";
    String token = "";
    String infover ;
    String path;
    String id;
    String network;
    String copyInfo;
    String uid;
    String currentTabIndex;

    public String getUid() {
        return uid;
    }

    public void setUid(String uid) {
        this.uid = uid;
    }

    public String getCopyInfo() {
        return copyInfo;
    }

    public void setCopyInfo(String copyInfo) {
        this.copyInfo = copyInfo;
    }

    public String getNetwork() {
        return network;
    }

    public void setNetwork(String network) {
        this.network = network;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getPath() {
        return path;
    }

    public void setPath(String path) {
        this.path = path;
    }

    public String getInfover() {
        return infover;
    }

    public void setInfover(String infover) {
        this.infover = infover;
    }

    public String getOs() {
        return os;
    }

    public void setOs(String os) {
        this.os = os;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public String getCurrentTabIndex() {
        return currentTabIndex;
    }

    public void setCurrentTabIndex(String currentTabIndex) {
        this.currentTabIndex = currentTabIndex;
    }
}
