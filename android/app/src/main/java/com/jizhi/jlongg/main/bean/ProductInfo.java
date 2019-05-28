package com.jizhi.jlongg.main.bean;

/**
 * Created by Administrator on 2017/8/9 0009.
 */

public class ProductInfo extends GroupDiscussionInfo {


    public static final int VERSION_ID = 1; //版本
    public static final int CLOUD_ID = 2;  //云盘

    public static final int SERVER_ORDER = 3;  //服务订单


    public ProductInfo() {
        members_num = "0";
    }


    /**
     * 云盘剩余天数
     */
    private int cloud_lave_days;
    /**
     * 服务剩余天数
     */
    private int service_lave_days;
    /**
     * 赠送空间
     */
    private String donate_space;
    /**
     * 订单签名字符串
     */
    private String record_id;
    /**
     * 产品价格信息
     */
    private ProductPriceInfo productPriceInfo;
    /**
     * 云盘价格信息
     */
    private ProductPriceInfo cloudPriceInfo;


    public String getDonate_space() {
        return donate_space;
    }

    public void setDonate_space(String donate_space) {
        this.donate_space = donate_space;
    }


    public int getCloud_lave_days() {
        return cloud_lave_days;
    }

    public void setCloud_lave_days(int cloud_lave_days) {
        this.cloud_lave_days = cloud_lave_days;
    }

    public int getService_lave_days() {
        return service_lave_days;
    }

    public void setService_lave_days(int service_lave_days) {
        this.service_lave_days = service_lave_days;
    }


    public ProductPriceInfo getProductPriceInfo() {
        return productPriceInfo;
    }

    public void setProductPriceInfo(ProductPriceInfo productPriceInfo) {
        this.productPriceInfo = productPriceInfo;
    }


    public String getRecord_id() {
        return record_id;
    }

    public void setRecord_id(String record_id) {
        this.record_id = record_id;
    }

    public ProductPriceInfo getCloudPriceInfo() {
        return cloudPriceInfo;
    }

    public void setCloudPriceInfo(ProductPriceInfo cloudPriceInfo) {
        this.cloudPriceInfo = cloudPriceInfo;
    }

}
