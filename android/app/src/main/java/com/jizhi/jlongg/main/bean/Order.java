package com.jizhi.jlongg.main.bean;

import java.util.List;

/**
 * 订单信息
 *
 * @author Xuj
 * @version 1.0
 * @time 2017年2月24日10:07:33
 */
public class Order extends GroupDiscussionInfoOrder {
    /**
     * 订单集合
     */
    private List<Order> list;
    /**
     * 订单id
     */
    private String order_id;
    /**
     * 订单号
     */
    private String order_sn;
    /**
     * 订单状态(1:未支付；2支付完成)
     */
    private int order_status;
    /**
     * 1：购买黄金；2续费黄金；3:购买云盘 4续费云盘
     */
    private int order_type;
    /**
     * 云盘赠送空间
     */
    private long donate_space;
    /**
     * 服务时长
     */
    private String service_time;
    /**
     * 服务人数
     */
    private int server_counts;
    /**
     * 创建时间
     */
    private String create_time;
    /**
     * 产品信息
     */
    private ProductPriceInfo produce_info;
    /**
     * 订单说明
     */
    private String detail;
    /**
     * 优惠金额
     */
    private float discount_amount;
    /**
     * 订单总金额
     */
    private float total_amount;
    /**
     * 实际金额 等于订单总金额-优惠金额
     */
    private float amount;
    /**
     * //支付类型 1：微信；2支付宝
     */
    private int pay_type;

    private String real_name;
    private String telephone;

    public String getTelephone() {
        return telephone;
    }

    public void setTelephone(String telephone) {
        this.telephone = telephone;
    }

    public String getReal_name() {
        return real_name;
    }

    public void setReal_name(String real_name) {
        this.real_name = real_name;
    }

    public List<Order> getList() {
        return list;
    }

    public void setList(List<Order> list) {
        this.list = list;
    }

    public String getOrder_sn() {
        return order_sn;
    }

    public void setOrder_sn(String order_sn) {
        this.order_sn = order_sn;
    }

    public String getPro_name() {
        return pro_name;
    }

    public void setPro_name(String pro_name) {
        this.pro_name = pro_name;
    }

    public int getOrder_status() {
        return order_status;
    }

    public void setOrder_status(int order_status) {
        this.order_status = order_status;
    }

    public int getOrder_type() {
        return order_type;
    }

    public void setOrder_type(int order_type) {
        this.order_type = order_type;
    }


    public ProductPriceInfo getProduce_info() {
        return produce_info;
    }

    public void setProduce_info(ProductPriceInfo produce_info) {
        this.produce_info = produce_info;
    }


    public String getOrder_id() {
        return order_id;
    }

    public void setOrder_id(String order_id) {
        this.order_id = order_id;
    }

    public String getDetail() {
        return detail;
    }

    public void setDetail(String detail) {
        this.detail = detail;
    }


    public long getDonate_space() {
        return donate_space;
    }

    public void setDonate_space(long donate_space) {
        this.donate_space = donate_space;
    }

    public int getServer_counts() {
        return server_counts;
    }

    public void setServer_counts(int server_counts) {
        this.server_counts = server_counts;
    }

    public float getDiscount_amount() {
        return discount_amount;
    }

    public void setDiscount_amount(float discount_amount) {
        this.discount_amount = discount_amount;
    }

    public float getTotal_amount() {
        return total_amount;
    }

    public void setTotal_amount(float total_amount) {
        this.total_amount = total_amount;
    }

    public float getAmount() {
        return amount;
    }

    public void setAmount(float amount) {
        this.amount = amount;
    }

    public String getService_time() {
        return service_time;
    }

    public void setService_time(String service_time) {
        this.service_time = service_time;
    }

    @Override
    public String toString() {
        return "Order{" +
                "list=" + list +
                ", order_id='" + order_id + '\'' +
                ", order_sn='" + order_sn + '\'' +
                ", order_status=" + order_status +
                ", order_type=" + order_type +
                ", donate_space=" + donate_space +
                ", service_time='" + service_time + '\'' +
                ", server_counts=" + server_counts +
                ", create_time='" + create_time + '\'' +
                ", produce_info=" + produce_info +
                ", detail='" + detail + '\'' +
                ", discount_amount=" + discount_amount +
                ", total_amount=" + total_amount +
                ", amount=" + amount +
                '}';
    }

    public int getPay_type() {
        return pay_type;
    }

    public void setPay_type(int pay_type) {
        this.pay_type = pay_type;
    }

    public String getCreate_time() {
        return create_time;
    }

    public void setCreate_time(String create_time) {
        this.create_time = create_time;
    }
}
