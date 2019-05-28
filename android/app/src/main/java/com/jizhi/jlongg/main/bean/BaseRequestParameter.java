package com.jizhi.jlongg.main.bean;

import com.jizhi.jlongg.main.activity.WebSocketBaseParameter;

import java.util.List;

/**
 * 请求Socket基类参数
 * <p>
 * import static android.R.attr.author;
 *
 * @author xuj
 * @version 1.0
 * @time 2016-11-30 10:55:07
 */
public class BaseRequestParameter extends WebSocketBaseParameter {

    /* 新建班组、成员集合 */
    private List<GroupMemberInfo> team_members;
    /* 数据来源人集合 */
    private List<GroupMemberInfo> source_members;
    /* 有源的数据人 */
    private List<GroupMemberInfo> confirm_source_members;
    /* 成员uid */
    private String group_members;
    /* 	类别，group为班组，team为讨论组 */
    private String class_type;
    /* 	判断是@成员 type=’at_member’，添加管理员列表 type=’set_admin_list’ 获取管理员列表 type=’get_admin_list’ */
    private String type;
    /* 讨论组id */
    private String team_id;
    /* 组id */
    private String group_id;
    /* 讨论组id集合 */
    private String team_ids;
    /* 项目名称 */
    private String pro_name;
    /* 加入的数据源,多个用逗号隔开，如 2,3,4 */
    private String source_pro_id;
    /* 用户id */
    private String uid;
    /* 	1,通过二维码加入，0从通讯录直接加入 */
    private String is_qr_code;
    /* 邀请者ID */
    private String inviter_uid;
    /* 城市编码 */
    private String city_code;
    /* 项目地址 */
    private String city_name;
    /* 项目id */
    private String pid;
    /* 昵称 */
    private String nickname;
    /* 项目备注 */
    private String team_comment;
    /* 电话号码 */
    private String telephone;
    /* 备注 */
    private String comment;
    /* 项目id */
    private String pro_id;
    /* 项目名称 */
    private String group_name;
    /* 免打扰 */
    private String is_not_disturbed;
    /* 	当前群的id */
    private String cur_group_id;
    /* 	当前群类型（群聊：groupChat；班组：group；项目：team） */
    private String cur_class_type;
    /* 验证码下标 */
    private String code;
    /* 是否包含当前用户：1：排除；0：包含 */
    private String is_exclude_self;
    private String is_active;
    /* 好友发送的验证申请 */
    private String msg_text;


    private int sync_type;

    private String is_delete;

    private String target_uid;

    public String getClass_type() {
        return class_type;
    }

    public void setClass_type(String class_type) {
        this.class_type = class_type;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getTeam_id() {
        return team_id;
    }

    public void setTeam_id(String team_id) {
        this.team_id = team_id;
    }

    public String getPro_name() {
        return pro_name;
    }

    public void setPro_name(String pro_name) {
        this.pro_name = pro_name;
    }

    public String getSource_pro_id() {
        return source_pro_id;
    }

    public void setSource_pro_id(String source_pro_id) {
        this.source_pro_id = source_pro_id;
    }

    public List<GroupMemberInfo> getSource_members() {
        return source_members;
    }

    public void setSource_members(List<GroupMemberInfo> source_members) {
        this.source_members = source_members;
    }

    public List<GroupMemberInfo> getConfirm_source_members() {
        return confirm_source_members;
    }

    public void setConfirm_source_members(List<GroupMemberInfo> confirm_source_members) {
        this.confirm_source_members = confirm_source_members;
    }

    public List<GroupMemberInfo> getTeam_members() {
        return team_members;
    }

    public void setTeam_members(List<GroupMemberInfo> team_members) {
        this.team_members = team_members;
    }

    public String getUid() {
        return uid;
    }

    public void setUid(String uid) {
        this.uid = uid;
    }

    public String getTeam_ids() {
        return team_ids;
    }

    public void setTeam_ids(String team_ids) {
        this.team_ids = team_ids;
    }

    public String getGroup_id() {
        return group_id;
    }

    public void setGroup_id(String group_id) {
        this.group_id = group_id;
    }

    public String getIs_qr_code() {
        return is_qr_code;
    }

    public void setIs_qr_code(String is_qr_code) {
        this.is_qr_code = is_qr_code;
    }

    public String getInviter_uid() {
        return inviter_uid;
    }

    public void setInviter_uid(String inviter_uid) {
        this.inviter_uid = inviter_uid;
    }

    public String getCity_code() {
        return city_code;
    }

    public void setCity_code(String city_code) {
        this.city_code = city_code;
    }

    public String getPid() {
        return pid;
    }

    public void setPid(String pid) {
        this.pid = pid;
    }

    public String getTeam_comment() {
        return team_comment;
    }

    public void setTeam_comment(String team_comment) {
        this.team_comment = team_comment;
    }

    public String getNickname() {
        return nickname;
    }

    public void setNickname(String nickname) {
        this.nickname = nickname;
    }

    public String getTelephone() {
        return telephone;
    }

    public void setTelephone(String telephone) {
        this.telephone = telephone;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public String getPro_id() {
        return pro_id;
    }

    public void setPro_id(String pro_id) {
        this.pro_id = pro_id;
    }

    public String getGroup_name() {
        return group_name;
    }

    public void setGroup_name(String group_name) {
        this.group_name = group_name;
    }

    public String getGroup_members() {
        return group_members;
    }

    public void setGroup_members(String group_members) {
        this.group_members = group_members;
    }

    public String getIs_not_disturbed() {
        return is_not_disturbed;
    }

    public void setIs_not_disturbed(String is_not_disturbed) {
        this.is_not_disturbed = is_not_disturbed;
    }

    public String getCur_group_id() {
        return cur_group_id;
    }

    public void setCur_group_id(String cur_group_id) {
        this.cur_group_id = cur_group_id;
    }

    public String getCur_class_type() {
        return cur_class_type;
    }

    public void setCur_class_type(String cur_class_type) {
        this.cur_class_type = cur_class_type;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getIs_exclude_self() {
        return is_exclude_self;
    }

    public void setIs_exclude_self(String is_exclude_self) {
        this.is_exclude_self = is_exclude_self;
    }

    public String getIs_active() {
        return is_active;
    }

    public void setIs_active(String is_active) {
        this.is_active = is_active;
    }

    public String getMsg_text() {
        return msg_text;
    }

    public void setMsg_text(String msg_text) {
        this.msg_text = msg_text;
    }

    public String getTarget_uid() {
        return target_uid;
    }

    public void setTarget_uid(String target_uid) {
        this.target_uid = target_uid;
    }

    public String getCity_name() {
        return city_name;
    }

    public void setCity_name(String city_name) {
        this.city_name = city_name;
    }

    public String getIs_delete() {
        return is_delete;
    }

    public void setIs_delete(String is_delete) {
        this.is_delete = is_delete;
    }

    public int getSync_type() {
        return sync_type;
    }

    public void setSync_type(int sync_type) {
        this.sync_type = sync_type;
    }
}
