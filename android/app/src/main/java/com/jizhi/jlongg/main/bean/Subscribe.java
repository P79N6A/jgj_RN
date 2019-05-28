package com.jizhi.jlongg.main.bean;

import java.io.Serializable;

/**
 * 记账列表实体
 */

public class Subscribe implements Serializable {
    /**
     * 0没有任何住下操作，1，注销提交，2，注销成功，3住下被拒
     */
    private int status;
    /**
     * 备注信息
     */
    private String comment;

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }
}
