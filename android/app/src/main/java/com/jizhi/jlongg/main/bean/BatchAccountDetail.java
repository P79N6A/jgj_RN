package com.jizhi.jlongg.main.bean;

import java.io.Serializable;

/**
 * 批量记账多人详情
 *
 * @author xuj
 * @version 1.0
 * @time 2017年2月16日15:18:48
 */
public class BatchAccountDetail extends UserInfo implements Serializable {

    /**
     * 薪资模板
     */
    private Salary tpl;
    /**
     * 包工薪资模板
     */
    private Salary unit_quan_tpl;
    /**
     * 已记，记账数据
     */
    private Salary choose_tpl;
    /**
     * 如果当前项目成员在其他项目中已记录过点工信息 则msg不为空
     */
    private BatchAccountOtherProInfo msg;
    /**
     * 是否修改过薪资模板 主要针对已记账的人员 如果已修改了模板 则提交到服务器
     */
    private boolean isUpdateSalary;
    /**
     * 已记账的对象是否已勾选记账信息
     */
    private boolean isSelected;
    /**
     * 记账id
     */
    private String record_id;
    /**
     * 1表示已记录了两笔工
     */
    private int is_double;


    public Salary getTpl() {
        return tpl;
    }

    public void setTpl(Salary tpl) {
        this.tpl = tpl;
    }

    public boolean isUpdateSalary() {
        return isUpdateSalary;
    }

    public void setUpdateSalary(boolean updateSalary) {
        isUpdateSalary = updateSalary;
    }

    public BatchAccountOtherProInfo getMsg() {
        return msg;
    }

    public void setMsg(BatchAccountOtherProInfo msg) {
        this.msg = msg;
    }


    public boolean isSelected() {
        return isSelected;
    }

    public void setSelected(boolean selected) {
        isSelected = selected;
    }


    public Salary getChoose_tpl() {
        return choose_tpl;
    }

    public void setChoose_tpl(Salary choose_tpl) {
        this.choose_tpl = choose_tpl;
    }

    public Salary getUnit_quan_tpl() {
        return unit_quan_tpl;
    }

    public void setUnit_quan_tpl(Salary unit_quan_tpl) {
        this.unit_quan_tpl = unit_quan_tpl;
    }

    public String getRecord_id() {
        return record_id;
    }

    public void setRecord_id(String record_id) {
        this.record_id = record_id;
    }

    public int getIs_double() {
        return is_double;
    }

    public void setIs_double(int is_double) {
        this.is_double = is_double;
    }
}
