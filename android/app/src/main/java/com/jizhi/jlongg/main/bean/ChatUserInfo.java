package com.jizhi.jlongg.main.bean;


import java.util.List;

/**
 * 用户基础信息
 */
public class ChatUserInfo extends UserInfo {
    /* 是否是黑名单 0代表不是黑名单 1、代表是黑名单 */
    private int is_black;
    /* 备注名称 */
    private String comment_name;
    /* 昵称 */
    private String nick_name;
    /* 0：工友 1:未加入；2已加入；3已过期 */
    private int status;
    //1：为朋友；0：不是朋友
    private int is_friend;
    //1：能聊天：0：不能聊天
    private int is_chat;
    //1：不能打电话：0：能打电话
    private int is_hidden;
    private List<String> pic_src;
    private String content;
    private String top_name;
    private String chat_name;
    //共同好友
    private List<GroupMemberInfo> common_friends;

    public String getTop_name() {
        return top_name;
    }

    public String getChat_name() {
        return chat_name;
    }

    public void setChat_name(String chat_name) {
        this.chat_name = chat_name;
    }

    public void setTop_name(String top_name) {
        this.top_name = top_name;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public List<String> getPic_src() {
        return pic_src;
    }

    public void setPic_src(List<String> pic_src) {
        this.pic_src = pic_src;
    }
    public int getIs_friend() {
        return is_friend;
    }

    public void setIs_friend(int is_friend) {
        this.is_friend = is_friend;
    }

    public int getIs_chat() {
        return is_chat;
    }

    public void setIs_chat(int is_chat) {
        this.is_chat = is_chat;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public String getNick_name() {
        return nick_name;
    }

    public void setNick_name(String nick_name) {
        this.nick_name = nick_name;
    }

    public int getIs_black() {
        return is_black;
    }

    public void setIs_black(int is_black) {
        this.is_black = is_black;
    }

    public String getComment_name() {
        return comment_name;
    }

    public void setComment_name(String comment_name) {
        this.comment_name = comment_name;
    }

    public List<GroupMemberInfo> getCommon_friends() {
        return common_friends;
    }

    public void setCommon_friends(List<GroupMemberInfo> common_friends) {
        this.common_friends = common_friends;
    }

    public int getIs_hidden() {
        return is_hidden;
    }

    public void setIs_hidden(int is_hidden) {
        this.is_hidden = is_hidden;
    }
}
