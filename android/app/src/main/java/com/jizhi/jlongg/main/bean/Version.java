package com.jizhi.jlongg.main.bean;

public class Version {
    /**
     * 下载地址
     */
    private String downloadLink;
    /**
     * 1需要上传通讯录 0不需要
     */
    private int ifaddressBook;
    /* 版本 */
    private String ver;
    /* 更新内容 */
    private String upinfo;

    public String getVer() {
        return ver;
    }

    public void setVer(String ver) {
        this.ver = ver;
    }

    public String getDownloadLink() {
        return downloadLink;
    }

    public void setDownloadLink(String downloadLink) {
        this.downloadLink = downloadLink;
    }

    public int getIfaddressBook() {
        return ifaddressBook;
    }

    public void setIfaddressBook(int ifaddressBook) {
        this.ifaddressBook = ifaddressBook;
    }

    public String getUpinfo() {
        return upinfo;
    }

    public void setUpinfo(String upinfo) {
        this.upinfo = upinfo;
    }
}
