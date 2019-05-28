package com.jizhi.jlongg.main.bean;

import org.litepal.crud.LitePalSupport;

import java.io.Serializable;
import java.util.List;

/**
 * CName:
 * User: hcs
 * Date: 2016-09-03
 * Time: 16:56
 */
public class ReadInfo extends LitePalSupport implements Serializable {

    private String unread_user_num;
    private List<ReadInfos> unread_user_list;
    private List<ReadInfos> readed_user_list;
    private List<ReadInfos> members;
    private List<ReadInfos> unrelay_members;

    public List<ReadInfos> getMembers() {
        return members;
    }

    public void setMembers(List<ReadInfos> members) {
        this.members = members;
    }

    public List<ReadInfos> getUnrelay_members() {
        return unrelay_members;
    }

    public void setUnrelay_members(List<ReadInfos> unrelay_members) {
        this.unrelay_members = unrelay_members;
    }

    public String getUnread_user_num() {
        return unread_user_num;
    }

    public void setUnread_user_num(String unread_user_num) {
        this.unread_user_num = unread_user_num;
    }

    public List<ReadInfos> getUnread_user_list() {
        return unread_user_list;
    }

    public void setUnread_user_list(List<ReadInfos> unread_user_list) {
        this.unread_user_list = unread_user_list;
    }

    public List<ReadInfos> getReaded_user_list() {
        return readed_user_list;
    }

    public void setReaded_user_list(List<ReadInfos> readed_user_list) {
        this.readed_user_list = readed_user_list;
    }
}
