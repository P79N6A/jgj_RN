package com.jizhi.jlongg.main.bean;

/**
 * CName:
 * User: hcs
 * Date: 2016-07-11
 * Time: 18:50
 */
public class ShareBill {

    private String url;
    private String imgUrl;
    private String describe;
    private String title;
    private String downloadUrl;
    private String msg;
    private String state;
    private int isShowHeader;
    private int type;
    //1.隐藏内部分享
    private int topdisplay;
    private WxMini wxMini;

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    public int getType() {
        return type;
    }

    public void setType(int type) {
        this.type = type;
    }

    public int getIsShowHeader() {
        return isShowHeader;
    }

    public void setIsShowHeader(int isShowHeader) {
        this.isShowHeader = isShowHeader;
    }

    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state;
    }

    public String getDownloadUrl() {
        return downloadUrl;
    }

    public void setDownloadUrl(String downloadUrl) {
        this.downloadUrl = downloadUrl;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public String getImgUrl() {
        return imgUrl;
    }

    public void setImgUrl(String imgUrl) {
        this.imgUrl = imgUrl;
    }

    public String getDescribe() {
        return describe;
    }

    public void setDescribe(String describe) {
        this.describe = describe;
    }

    public WxMini getWxMini() {
        return wxMini;
    }

    public void setWxMini(WxMini wxMini) {
        this.wxMini = wxMini;
    }

    public int getTopdisplay() {
        return topdisplay;
    }

    public void setTopdisplay(int topdisplay) {
        this.topdisplay = topdisplay;
    }
}
