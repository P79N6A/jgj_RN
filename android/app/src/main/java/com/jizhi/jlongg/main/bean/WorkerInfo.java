package com.jizhi.jlongg.main.bean;

import java.io.Serializable;
import java.util.List;

/**
 * CName:4.0.1工头工人信息
 * User: hcs
 * Date: 2018-07-30
 * Time: 下午 3:39
 */
public class WorkerInfo implements Serializable {
    //工种
    private List<String> work_type;

    public List<String> getWork_type() {
        return work_type;
    }

    public void setWork_type(List<String> work_type) {
        this.work_type = work_type;
    }
}
