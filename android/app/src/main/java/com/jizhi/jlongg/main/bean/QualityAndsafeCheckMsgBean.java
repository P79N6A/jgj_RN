package com.jizhi.jlongg.main.bean;

import java.io.Serializable;
import java.util.List;

/**
 * CName:质量，安全检查页 bean2.3.0
 * User: hcs
 * Date: 2017-07-13
 * Time: 11:40
 */


public class QualityAndsafeCheckMsgBean implements Serializable {
    private String id;//计划检查项目id
    private String uid;//发布者uid
    private String principal_uid;//执行者uid
    private String group_id;//组id
    private String class_type;//组类型
    private String insp_id;//检查项目id
    private String text;//描述
    private String create_time;//时间
    private String is_active;//有效性
    private String pu_inpsid;//计划检查项目id
    private UserInfo send_user_info;//发布者
    private UserInfo user_info;//执行者
    private String inspect_name;//共50个检查大项
    private String child_inspect_name;//50个检查小项
    private String finish;//完成
    private String pass;//通过
    private int change_color;//0:不显示红，1：显示红
    private String uncheck;//未检查
    private String msg_type;
    private String parent_id;//父质量项
    private int is_sort;
    private List<ReplyInfo> reply_list;
    private boolean isExpand;
    private int is_privilege;
 // 0：未处理 1整改 2未涉及  3通过
    private int statu;;
    private int pub_id;;
    /**
     * 项目全称
     */
    public String all_pro_name;

    public int getPub_id() {
        return pub_id;
    }

    public void setPub_id(int pub_id) {
        this.pub_id = pub_id;
    }

    public String getAll_pro_name() {
        return all_pro_name;
    }

    public void setAll_pro_name(String all_pro_name) {
        this.all_pro_name = all_pro_name;
    }

    public int getIs_privilege() {
        return is_privilege;
    }

    public void setStatu(int statu) {
        this.statu = statu;
    }

    public int getStatu() {
        return statu;
    }

    public int is_privilege() {
        return is_privilege;
    }

    public void setIs_privilege(int is_privilege) {
        this.is_privilege = is_privilege;
    }

    public boolean isExpand() {
        return isExpand;
    }

    public void setExpand(boolean expand) {
        isExpand = expand;
    }

    public List<ReplyInfo> getReply_list() {
        return reply_list;
    }

    public void setReply_list(List<ReplyInfo> reply_list) {
        this.reply_list = reply_list;
    }

    public String getParent_id() {
        return parent_id;
    }

    public void setParent_id(String parent_id) {
        this.parent_id = parent_id;
    }

    public int getIs_sort() {
        return is_sort;
    }

    public void setIs_sort(int is_sort) {
        this.is_sort = is_sort;
    }

    public String getUncheck() {
        return uncheck;
    }

    public void setUncheck(String uncheck) {
        this.uncheck = uncheck;
    }

    public String getMsg_type() {
        return msg_type;
    }

    public void setMsg_type(String msg_type) {
        this.msg_type = msg_type;
    }

    public int getChange_color() {
        return change_color;
    }

    public void setChange_color(int change_color) {
        this.change_color = change_color;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getUid() {
        return uid;
    }

    public void setUid(String uid) {
        this.uid = uid;
    }

    public String getPrincipal_uid() {
        return principal_uid;
    }

    public void setPrincipal_uid(String principal_uid) {
        this.principal_uid = principal_uid;
    }

    public String getGroup_id() {
        return group_id;
    }

    public void setGroup_id(String group_id) {
        this.group_id = group_id;
    }

    public String getClass_type() {
        return class_type;
    }

    public void setClass_type(String class_type) {
        this.class_type = class_type;
    }

    public String getInsp_id() {
        return insp_id;
    }

    public void setInsp_id(String insp_id) {
        this.insp_id = insp_id;
    }

    public String getText() {
        return text;
    }

    public void setText(String text) {
        this.text = text;
    }


    public String getCreate_time() {
        return create_time;
    }

    public void setCreate_time(String create_time) {
        this.create_time = create_time;
    }

    public String getIs_active() {
        return is_active;
    }

    public void setIs_active(String is_active) {
        this.is_active = is_active;
    }

    public String getPu_inpsid() {
        return pu_inpsid;
    }

    public void setPu_inpsid(String pu_inpsid) {
        this.pu_inpsid = pu_inpsid;
    }

    public UserInfo getSend_user_info() {
        return send_user_info;
    }

    public void setSend_user_info(UserInfo send_user_info) {
        this.send_user_info = send_user_info;
    }

    public UserInfo getUser_info() {
        return user_info;
    }

    public void setUser_info(UserInfo user_info) {
        this.user_info = user_info;
    }

    public String getInspect_name() {
        return inspect_name;
    }

    public void setInspect_name(String inspect_name) {
        this.inspect_name = inspect_name;
    }

    public String getChild_inspect_name() {
        return child_inspect_name;
    }

    public void setChild_inspect_name(String child_inspect_name) {
        this.child_inspect_name = child_inspect_name;
    }

    public String getFinish() {
        return finish;
    }

    public void setFinish(String finish) {
        this.finish = finish;
    }

    public String getPass() {
        return pass;
    }

    public void setPass(String pass) {
        this.pass = pass;
    }
}
