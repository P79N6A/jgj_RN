package com.jizhi.jlongg.main.bean;

import java.io.Serializable;

/**
 * 二维码扫描
 *
 * @Author xuj
 * @date 2016年9月6日 17:44:26
 */
public class ScanCode implements Serializable {
    /* 	邀请者uid */
    private String inviter_uid;
    /* 二维码生成时间 */
    private String time;
    /* group为班组，team为项目组 */
    private String class_type;
    /* 	班组id，如果 class_type为group，此值必传 */
    private String group_id;
    /* 	班组id，如果 class_type为team，此值必传 */
    private String team_id;


    public String getInviter_uid() {
        return inviter_uid;
    }

    public void setInviter_uid(String inviter_uid) {
        this.inviter_uid = inviter_uid;
    }

    public String getTime() {
        return time;
    }

    public void setTime(String time) {
        this.time = time;
    }

    public String getClass_type() {
        return class_type;
    }

    public void setClass_type(String class_type) {
        this.class_type = class_type;
    }

    public String getGroup_id() {
        return group_id;
    }

    public void setGroup_id(String group_id) {
        this.group_id = group_id;
    }

    public String getTeam_id() {
        return team_id;
    }

    public void setTeam_id(String team_id) {
        this.team_id = team_id;
    }
}
