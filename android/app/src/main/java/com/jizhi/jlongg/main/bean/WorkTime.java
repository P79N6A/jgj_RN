package com.jizhi.jlongg.main.bean;

import java.io.Serializable;

/**
 * CName:上班,加班时长
 * User: hcs
 * Date: 2016-06-01
 * Time: 10:36
 */
public class WorkTime implements Serializable {

    /**
     * 名称
     */
    private String workName = "小时";
    /**
     * 时长
     */
    private double workTimes;
    /**
     * id
     */
    private int workId;
    /**
     * 是否是0.5个工
     */
    private boolean isHalfWork;
    /**
     * 是否是1个工
     */
    private boolean isOneWork;
    /**
     * 是否是休息、或者无加班
     */
    private boolean isRest;
    private String unit;

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }



    public WorkTime(String workName) {
        this.workName = workName;
    }

    public WorkTime(float workTimes) {
        this.workTimes = workTimes;
    }

    public WorkTime() {
    }

    public String getWorkName() {
        return workName;
    }

    public void setWorkName(String workName) {
        this.workName = workName;
    }

    public double getWorkTimes() {
        return workTimes;
    }

    public void setWorkTimes(double workTimes) {
        this.workTimes = workTimes;
    }

    public int getWorkId() {
        return workId;
    }

    public void setWorkId(int workId) {
        this.workId = workId;
    }

    public boolean isOneWork() {
        return isOneWork;
    }

    public void setOneWork(boolean oneWork) {
        isOneWork = oneWork;
    }

    public boolean isHalfWork() {
        return isHalfWork;
    }

    public void setHalfWork(boolean halfWork) {
        isHalfWork = halfWork;
    }

    public boolean isRest() {
        return isRest;
    }

    public void setRest(boolean rest) {
        isRest = rest;
    }

    @Override
    public String toString() {
        return "WorkTime{" +
                "workName='" + workName + '\'' +
                ", workTimes=" + workTimes +
                ", workId=" + workId +
                ", isOneWork=" + isOneWork +
                '}';
    }
}
