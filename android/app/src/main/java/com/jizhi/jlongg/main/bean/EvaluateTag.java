package com.jizhi.jlongg.main.bean;

/**
 * 评价标签
 */

public class EvaluateTag {
    /**
     * 标签id
     */
    private int tag_id;
    /**
     * 选择数量
     */
    private int num;
    /**
     * 标签名称
     */
    private String tag_name;
    /**
     * 是否已选中当前标签
     */
    private boolean is_selected;

    public int getTag_id() {
        return tag_id;
    }

    public void setTag_id(int tag_id) {
        this.tag_id = tag_id;
    }

    public int getNum() {
        return num;
    }

    public void setNum(int num) {
        this.num = num;
    }

    public String getTag_name() {
        return tag_name;
    }

    public void setTag_name(String tag_name) {
        this.tag_name = tag_name;
    }


    public boolean is_selected() {
        return is_selected;
    }

    public void setIs_selected(boolean is_selected) {
        this.is_selected = is_selected;
    }

    public EvaluateTag() {

    }

    public EvaluateTag(String tag_name) {
        this.tag_name = tag_name;
    }

}
