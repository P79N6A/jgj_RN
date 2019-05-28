package com.jizhi.jlongg.main.bean;

/**
 * 当前登录状态
 *
 * @author Xuj
 * @time 2016年2月2日 10:38:19
 * @Version 1.0
 */
public class LoginStatu {
    /**
     * 登录人头像
     */
    private String head_pic;
    /**
     * 登录人姓名
     */
    private String real_name;
    /**
     * token
     */
    private String token;
    /**
     * 昵称
     */
    private String user_name;
    /**
     * 当前角色
     * 1.工友
     * 2.工头
     */
    private int role;
    /**
     * 是否有当前角色
     * 0.没有当前角色
     * 1.有当前角色
     */
    private int is_info;
    /**
     * 是否有名字
     */
    private int has_realname;
    /**
     * 是否已绑定微信
     */
    private int is_bind;

    /**
     * 登录人id
     */
    private String uid;
    /**
     * 登录人电话
     */
    private String telephone;
    /**
     * 1表示新用户
     */
    private int is_new;

    private String realname;
    private String nickname;
    private String headpic;

    public String getHeadpic() {
        return headpic;
    }

    public void setHeadpic(String headpic) {
        this.headpic = headpic;
    }

    public String getNickname() {
        return nickname;
    }

    public void setNickname(String nickname) {
        this.nickname = nickname;
    }

    public String getRealname() {
        return realname;
    }

    public void setRealname(String realname) {
        this.realname = realname;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public int getRole() {
        return role;
    }

    public void setRole(int role) {
        this.role = role;
    }

    public int getIs_info() {
        return is_info;
    }

    public void setIs_info(int is_info) {
        this.is_info = is_info;
    }

    public int getHas_realname() {
        return has_realname;
    }

    public void setHas_realname(int has_realname) {
        this.has_realname = has_realname;
    }

    public String getUid() {
        return uid;
    }

    public void setUid(String uid) {
        this.uid = uid;
    }

    public String getHead_pic() {
        return head_pic;
    }

    public void setHead_pic(String head_pic) {
        this.head_pic = head_pic;
    }

    public String getReal_name() {
        return real_name;
    }

    public void setReal_name(String real_name) {
        this.real_name = real_name;
    }

    public String getUser_name() {
        return user_name;
    }

    public void setUser_name(String user_name) {
        this.user_name = user_name;
    }

    public String getTelephone() {
        return telephone;
    }

    public void setTelephone(String telephone) {
        this.telephone = telephone;
    }

    public int getIs_bind() {
        return is_bind;
    }

    public void setIs_bind(int is_bind) {
        this.is_bind = is_bind;
    }

    public int getIs_new() {
        return is_new;
    }

    public void setIs_new(int is_new) {
        this.is_new = is_new;
    }
}
