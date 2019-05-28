package com.jizhi.jlongg.main.bean;

import java.io.File;
import java.io.Serializable;

/**
 * 分享
 *
 * @author Xuj
 * @time 2015年11月28日 11:03:17
 * @Version 1.0
 */
public class Share extends BaseNetBean implements Serializable, Cloneable {
    /**
     * 分享分享url
     */
    private String url;
    /**
     * 分享图标
     */
    private String imgUrl;
    /**
     * 分享描述
     */
    private String describe;
    /**
     * 分享标题
     */
    private String title;
    /**
     * 连接地址key
     */
    private String link_key;
    /**
     * 小程序id
     */
    private String appId;
    /**
     * 小程序路径
     */
    private String path;
    /**
     * 小程序pic
     */
    private String typeImg;
    /**
     * 本地记录需要分享的文件
     */
    private File shareFile;
    //1.隐藏内部分享
    private int topdisplay;
    private int type;
    private WxMini wxMini;

    private int wxMiniDrawable;

    public int getWxMiniDrawable() {
        return wxMiniDrawable;
    }

    public void setWxMiniDrawable(int wxMiniDrawable) {
        this.wxMiniDrawable = wxMiniDrawable;
    }

    public String getLink_key() {
        return link_key;
    }

    public void setLink_key(String link_key) {
        this.link_key = link_key;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }


    public String getAppId() {
        return appId;
    }

    public void setAppId(String appId) {
        this.appId = appId;
    }

    public String getTypeImg() {
        return typeImg;
    }

    public void setTypeImg(String typeImg) {
        this.typeImg = typeImg;
    }

    public String getPath() {
        return path;
    }

    public void setPath(String path) {
        this.path = path;
    }

    public File getShareFile() {
        return shareFile;
    }

    public void setShareFile(File shareFile) {
        this.shareFile = shareFile;
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

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public int getTopdisplay() {
        return topdisplay;
    }

    public WxMini getWxMini() {
        return wxMini;
    }

    public void setWxMini(WxMini wxMini) {
        this.wxMini = wxMini;
    }

    public void setTopdisplay(int topdisplay) {
        this.topdisplay = topdisplay;
    }

    public int getType() {
        return type;
    }

    public void setType(int type) {
        this.type = type;
    }

    @Override
    protected Object clone() throws CloneNotSupportedException {
        return super.clone();
    }

}
