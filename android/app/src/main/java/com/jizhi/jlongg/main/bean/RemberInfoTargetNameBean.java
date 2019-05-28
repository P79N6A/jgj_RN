package com.jizhi.jlongg.main.bean;

import java.io.Serializable;

/**
 * 记工流水顶部筛选数据
 */

public class RemberInfoTargetNameBean extends UserInfo implements Serializable {
    private String class_type_id;//项目的id
    private String name;//项目名称
    private String class_type;//项目
    private boolean isSelect;

    public String getClass_type_id() {
        return class_type_id;
    }

    public void setClass_type_id(String class_type_id) {
        this.class_type_id = class_type_id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }


    public String getClass_type() {
        return class_type;
    }

    public void setClass_type(String class_type) {
        this.class_type = class_type;
    }

    public boolean isSelect() {
        return isSelect;
    }

    public void setSelect(boolean select) {
        isSelect = select;
    }

}
