package com.jizhi.jlongg.main.bean;

/**
 * Created by Administrator on 2017/8/18 0018.
 */

public class WxCallBack {

    private String appid;
    /**
     * 微信支付分配的商户号
     */
    private String partnerid;
    /**
     * 预支付订单号，app服务器调用“统一下单”接口获取
     */
    private String prepayid;
    /**
     * 随机字符串，不长于32位，服务器小哥会给咱生成
     */
    private String noncestr;
    /**
     * 时间戳，app服务器小哥给出
     */
    private String timestamp;
    /**
     * 固定值Sign=WXPay，可以直接写死，服务器返回的也是这个固定值
     * 因为Java package 是特殊字符 所以这里返回的package_name
     */
    private String package_name;
    /**
     * 签名，服务器小哥给出，他会根据：http
     */
    private String sign;

    public String getAppid() {
        return appid;
    }

    public void setAppid(String appid) {
        this.appid = appid;
    }

    public String getPartnerid() {
        return partnerid;
    }

    public void setPartnerid(String partnerid) {
        this.partnerid = partnerid;
    }

    public String getPrepayid() {
        return prepayid;
    }

    public void setPrepayid(String prepayid) {
        this.prepayid = prepayid;
    }

    public String getNoncestr() {
        return noncestr;
    }

    public void setNoncestr(String noncestr) {
        this.noncestr = noncestr;
    }

    public String getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(String timestamp) {
        this.timestamp = timestamp;
    }

    public String getPackage_name() {
        return package_name;
    }

    public void setPackage_name(String package_name) {
        this.package_name = package_name;
    }

    public String getSign() {
        return sign;
    }

    public void setSign(String sign) {
        this.sign = sign;
    }

    @Override
    public String toString() {
        return "WxCallBack{" +
                "appid='" + appid + '\'' +
                ", partnerid='" + partnerid + '\'' +
                ", prepayid='" + prepayid + '\'' +
                ", noncestr='" + noncestr + '\'' +
                ", timestamp='" + timestamp + '\'' +
                ", package_name='" + package_name + '\'' +
                ", sign='" + sign + '\'' +
                '}';
    }
}
