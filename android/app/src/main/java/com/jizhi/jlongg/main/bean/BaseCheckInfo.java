package com.jizhi.jlongg.main.bean;

import java.io.Serializable;
import java.util.List;

/**
 * CName:检查基础信息
 * User: xuj
 * Date: 2017年11月13日
 * Time:15:50:51
 */
public class BaseCheckInfo implements Serializable {
    /**
     * 1、表示能操作删除
     */
    private int is_operate;
    /**
     * 1、表示已选 0表示未选中
     */
    private int is_selected;
    /**
     * 有效性 0：表示已删除
     */
    private int is_active;
    /**
     * 主要是检查项和检查内容列表时区分使用
     * pro表示 检查项,content表示检查内容
     */
    private String type;
    /**
     * 列表名称
     */
    private String name;
    /**
     * id
     */
    private int id;
    /**
     * 列表数据
     */
    private List<BaseCheckInfo> list;

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
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

    public List<BaseCheckInfo> getList() {
        return list;
    }

    public void setList(List<BaseCheckInfo> list) {
        this.list = list;
    }

    public int getIs_operate() {
        return is_operate;
    }

    public void setIs_operate(int is_operate) {
        this.is_operate = is_operate;
    }

    public int getIs_selected() {
        return is_selected;
    }

    public void setIs_selected(int is_selected) {
        this.is_selected = is_selected;
    }

    public int getIs_active() {
        return is_active;
    }

    public void setIs_active(int is_active) {
        this.is_active = is_active;
    }
}
