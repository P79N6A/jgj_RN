package com.jizhi.jlongg.main.bean;

import java.io.Serializable;

/**
 * 项目 消息菜单信息
 *
 * @author xuj
 * @version 1.0
 * @time 2017年3月30日15:05:20
 */
public class WorkCircleMessageMenu implements Serializable {


    public static final int SINGLE_RECORD_ACCOUNT = 1; //添加记工 工友使用
    public static final int MULTI_RECORD_ACCOUNT = 2; //批量记账  工头使用
    public static final int WORK_BOOKS = 3; //记工账本
    public static final int SIGN = 4; //签到
    public static final int REPOSITY = 5; //知识库
    public static final int NOTICE = 6; //通知
    public static final int QUALITY = 7; //质量
    public static final int SAFETY = 8; //安全
    public static final int GROUP_MANAGER = 9; //班组管理
    public static final int LOG = 10; //日志
    public static final int RECODER_TABLE = 11; //记工报表
    public static final int TEAM_MANAGER = 12; //项目组管理
    public static final int TASK = 13; //任务
    public static final int EXAMINATION = 14; //审批
    public static final int WEATHER_TABLE = 15; //晴雨表

    public static final int DEVICE = 16; //设备记录
    public static final int PRO_CLOUD = 17; //项目云盘
    public static final int APP_WEBSITE = 18; //项目微官网
    public static final int CHECK = 19; //检查
    public static final int MEETING = 20; //会议


    public static final int PROXY_RECORD = 21; //代班记工
    public static final int PROXY_FLOW = 22; //代班流水
    public static final int PROXY_CHECK_ACCOUNT = 23; //代班对账
    public static final int RECORD_ACCOUNT_UPDATE = 24; //记工变更
    public static final int MEMBER_MANAGER = 25; //成员管理
    public static final int ACCOUNT_BORROW = 26; //借支/结算


    /**
     * 菜单名称
     */
    private String menuName;
    /**
     * 图片资源信息
     */
    private int imageResource;
    /**
     * 菜单类型
     */
    private int menuType;
    /**
     * 是否显示小红点
     */
    private boolean isShowRedCircle;

    public WorkCircleMessageMenu(String menuName, int imageResource, int menuType) {
        this.menuName = menuName;
        this.imageResource = imageResource;
        this.menuType = menuType;
    }

    public String getMenuName() {
        return menuName;
    }

    public void setMenuName(String menuName) {
        this.menuName = menuName;
    }

    public int getImageResource() {
        return imageResource;
    }

    public void setImageResource(int imageResource) {
        this.imageResource = imageResource;
    }

    public int getMenuType() {
        return menuType;
    }

    public void setMenuType(int menuType) {
        this.menuType = menuType;
    }

    public boolean isShowRedCircle() {
        return isShowRedCircle;
    }

    public void setShowRedCircle(boolean showRedCircle) {
        isShowRedCircle = showRedCircle;
    }
}
