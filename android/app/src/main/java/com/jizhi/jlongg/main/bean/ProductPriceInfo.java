package com.jizhi.jlongg.main.bean;

import java.io.Serializable;
import java.util.List;

/**
 * Created by Administrator on 2017/8/9 0009.
 */

public class ProductPriceInfo implements Serializable {


    private List<ProductPriceInfo> list;
    /**
     * 产品服务id
     */
    private int server_id;
    /**
     * 服务名称  黄金服务版
     */
    private String server_name;
    /**
     * 产品原价
     */
    private float total_amount;
    /**
     * 产品现价
     */
    private float price;
    /**
     * 单位 人*半年
     */
    private String units;
    /**
     * 当前服务器时间戳
     */
    private long timestamp;
    /**
     * 单价
     */
    private float unit_price;

    /**
     * 服务器购买版本的时长
     */
    private int service_time;


    public float getTotal_amount() {
        return total_amount;
    }

    public void setTotal_amount(float total_amount) {
        this.total_amount = total_amount;
    }


    public String getUnits() {
        return units;
    }

    public void setUnits(String units) {
        this.units = units;
    }

    public String getServer_name() {
        return server_name;
    }

    public void setServer_name(String server_name) {
        this.server_name = server_name;
    }

    public List<ProductPriceInfo> getList() {
        return list;
    }

    public void setList(List<ProductPriceInfo> list) {
        this.list = list;
    }

    public int getServer_id() {
        return server_id;
    }

    public void setServer_id(int server_id) {
        this.server_id = server_id;
    }


    public float getPrice() {
        return price;
    }

    public void setPrice(float price) {
        this.price = price;
    }

    public long getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(long timestamp) {
        this.timestamp = timestamp;
    }

    public float getUnit_price() {
        return unit_price;
    }

    public void setUnit_price(float unit_price) {
        this.unit_price = unit_price;
    }

    public int getService_time() {
        return service_time;
    }

    public void setService_time(int service_time) {
        this.service_time = service_time;
    }
}
