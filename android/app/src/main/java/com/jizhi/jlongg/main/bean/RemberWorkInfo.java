package com.jizhi.jlongg.main.bean;

import java.io.Serializable;
import java.util.List;

/**
 * huchangsheng on 2016/2/22 14:36
 */
public class RemberWorkInfo implements Serializable {


    private int id;//记账id
    private int wuid;//工人id
    private int fuid;//工头id
    private String date;//记账日期
    private int role;//本笔记账的角色
    private String manhour;//正常工作时长
    private String overtime;//加班时长
    private String amounts;//记账总额
    private String pro_name;//记账的项目名
    //是否勾选了删除按钮
    private boolean isSelected;
    private boolean isExist;
    //是否显示删除框
    private boolean isShowCb;
    private boolean isShowAnim;
    private String date_turn;//农历日期
    private int is_del;//是否移除
    private int uid;
    private int pid;
    /**
     * 是否有差帐  0 :没有 1：有
     */
    private int amounts_diff;
    private AccountsType accounts_type;//记账类型
    private String name;
    private String sub_pro_name;
    /**
     * 记账类型
     */
    private AccountUtil new_amounts;
    private List<RemberWorkInfo> list;
    private String worker_name;//工人名字
    private String foreman_name;//工头名字
    private String record_name;//记账名字
    private String manhour_text;//
    private String overtime_text;//
    private String unit;//
    private int is_rest;//0:正常  1：休息

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }

    public int getIs_rest() {
        return is_rest;
    }

    public void setIs_rest(int is_rest) {
        this.is_rest = is_rest;
    }

    public String getManhour_text() {
        return manhour_text;
    }

    public void setManhour_text(String manhour_text) {
        this.manhour_text = manhour_text;
    }

    public String getOvertime_text() {
        return overtime_text;
    }

    public void setOvertime_text(String overtime_text) {
        this.overtime_text = overtime_text;
    }

    public String getWorker_name() {
        return worker_name;
    }

    public void setWorker_name(String worker_name) {
        this.worker_name = worker_name;
    }

    public String getForeman_name() {
        return foreman_name;
    }

    public void setForeman_name(String foreman_name) {
        this.foreman_name = foreman_name;
    }

    public String getRecord_name() {
        return record_name;
    }

    public void setRecord_name(String record_name) {
        this.record_name = record_name;
    }

    public boolean isSelected() {
        return isSelected;
    }

    public void setSelected(boolean selected) {
        isSelected = selected;
    }

    /**
     * 是否有差账 0、没有差帐  2、等待自己确认  3、等待对方修改
     */
    private int modify_marking;

    public List<RemberWorkInfo> getList() {
        return list;
    }

    public void setList(List<RemberWorkInfo> list) {
        this.list = list;
    }

    public boolean isShowAnim() {
        return isShowAnim;
    }

    public void setIsShowAnim(boolean isShowAnim) {
        this.isShowAnim = isShowAnim;
    }

    public int getIs_del() {
        return is_del;
    }

    public void setIs_del(int is_del) {
        this.is_del = is_del;
    }

    public int getUid() {
        return uid;
    }

    public void setUid(int uid) {
        this.uid = uid;
    }

    public int getPid() {
        return pid;
    }

    public void setPid(int pid) {
        this.pid = pid;
    }

    public boolean isShowCb() {
        return isShowCb;
    }

    public void setIsShowCb(boolean isShowCb) {
        this.isShowCb = isShowCb;
    }

    public boolean isExist() {
        return isExist;
    }

    public void setIsExist(boolean isExist) {
        this.isExist = isExist;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getWuid() {
        return wuid;
    }

    public void setWuid(int wuid) {
        this.wuid = wuid;
    }

    public int getFuid() {
        return fuid;
    }

    public void setFuid(int fuid) {
        this.fuid = fuid;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public int getRole() {
        return role;
    }

    public void setRole(int role) {
        this.role = role;
    }

    public String getManhour() {
        return manhour;
    }

    public void setManhour(String manhour) {
        this.manhour = manhour;
    }

    public String getOvertime() {
        return overtime;
    }

    public void setOvertime(String overtime) {
        this.overtime = overtime;
    }

    public String getAmounts() {
        return amounts;
    }

    public void setAmounts(String amounts) {
        this.amounts = amounts;
    }

    public String getPro_name() {
        return pro_name;
    }

    public void setPro_name(String pro_name) {
        this.pro_name = pro_name;
    }

    public int getAmounts_diff() {
        return amounts_diff;
    }

    public void setAmounts_diff(int amounts_diff) {
        this.amounts_diff = amounts_diff;
    }

    public AccountsType getAccounts_type() {
        return accounts_type;
    }

    public void setAccounts_type(AccountsType accounts_type) {
        this.accounts_type = accounts_type;
    }

    public String getSub_pro_name() {
        return sub_pro_name;
    }

    public void setSub_pro_name(String sub_pro_name) {
        this.sub_pro_name = sub_pro_name;
    }

    public String getDate_turn() {
        return date_turn;
    }

    public void setDate_turn(String date_turn) {
        this.date_turn = date_turn;
    }


    public int getModify_marking() {
        return modify_marking;
    }

    public void setModify_marking(int modify_marking) {
        this.modify_marking = modify_marking;
    }

    public void setShowCb(boolean showCb) {
        isShowCb = showCb;
    }

    public void setShowAnim(boolean showAnim) {
        isShowAnim = showAnim;
    }

    public AccountUtil getNew_amounts() {
        return new_amounts;
    }

    public void setNew_amounts(AccountUtil new_amounts) {
        this.new_amounts = new_amounts;
    }

    @Override
    public String toString() {
        return "RemberWorkInfo{" +
                    "id=" + id +
                    ", wuid=" + wuid +
                    ", fuid=" + fuid +
                    ", date=" + date +
                    ", role=" + role +
                    ", manhour='" + manhour + '\'' +
                    ", overtime='" + overtime + '\'' +
                    ", amounts=" + amounts +
                    ", pro_name='" + pro_name + '\'' +
                    ", isSelected=" + isSelected +
                    ", isExist=" + isExist +
                    ", isShowCb=" + isShowCb +
                    ", isShowAnim=" + isShowAnim +
                    ", date_turn='" + date_turn + '\'' +
                    ", is_del=" + is_del +
                    ", uid=" + uid +
                    ", pid=" + pid +
                    ", amounts_diff=" + amounts_diff +
                    ", accounts_type=" + accounts_type +
                    ", name='" + name + '\'' +
                    ", sub_pro_name='" + sub_pro_name + '\'' +
                    ", modify_marking=" + modify_marking +
                    '}';
    }
}