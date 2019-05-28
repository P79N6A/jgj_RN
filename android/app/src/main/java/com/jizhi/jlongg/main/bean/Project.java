package com.jizhi.jlongg.main.bean;

import java.io.Serializable;

/**
 * Created by Administrator on 2016/3/3.
 */
public class Project implements Serializable {
    /* 组id */
    private String group_id;

    /**
     * 0表示该项目还没有创建过班组，1表示已经创建过
     */
    private int is_create_group;
    /**
     * 项目id
     */
    private String pro_id;
    /**
     * 项目名称
     */
    private String pro_name;
    /**
     * 项目id
     */
    private int pid;
    /**
     * 是否选择了当前项目
     */
    private boolean isSelected;
    /**
     * 是否已经显示了动画
     */
    private boolean isShowAnim;
    /**
     * 是否正在编辑挡条项目
     */
    private boolean isEditor;
    /**
     * 编辑名称
     */
    private String editor_name;
    /**
     * 当前用户id
     */
    private String self_uid;

    public String getPro_name() {
        return pro_name;
    }

    public void setPro_name(String pro_name) {
        this.pro_name = pro_name;
    }


    public boolean isSelected() {
        return isSelected;
    }

    public void setIsSelected(boolean isSelected) {
        this.isSelected = isSelected;
    }

    public Project() {
    }

    public Project(String pro_name, int pid) {
        this.pro_name = pro_name;
        this.pid = pid;
    }

    public int getPid() {
        return pid;
    }

    public void setPid(int pid) {
        this.pid = pid;
    }

    public boolean isShowAnim() {
        return isShowAnim;
    }

    public void setShowAnim(boolean showAnim) {
        isShowAnim = showAnim;
    }

    public int getIs_create_group() {
        return is_create_group;
    }

    public void setIs_create_group(int is_create_group) {
        this.is_create_group = is_create_group;
    }

    public String getPro_id() {
        return pro_id;
    }

    public void setPro_id(String pro_id) {
        this.pro_id = pro_id;
    }

    @Override
    public String toString() {
        return "Project{" +
                "is_create_group=" + is_create_group +
                ", pro_id='" + pro_id + '\'' +
                ", pro_name='" + pro_name + '\'' +
                ", pid=" + pid +
                ", isSelected=" + isSelected +
                ", isShowAnim=" + isShowAnim +
                '}';
    }

    public String getGroup_id() {
        return group_id;
    }

    public void setGroup_id(String group_id) {
        this.group_id = group_id;
    }

    public void setSelected(boolean selected) {
        isSelected = selected;
    }

    public boolean isEditor() {
        return isEditor;
    }

    public void setEditor(boolean editor) {
        isEditor = editor;
    }

    public String getEditor_name() {
        return editor_name;
    }

    public void setEditor_name(String editor_name) {
        this.editor_name = editor_name;
    }

    public String getSelf_uid() {
        return self_uid;
    }

    public void setSelf_uid(String self_uid) {
        this.self_uid = self_uid;
    }
}
