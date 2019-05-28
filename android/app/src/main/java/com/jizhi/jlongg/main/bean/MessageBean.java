package com.jizhi.jlongg.main.bean;

import android.text.TextUtils;

import org.litepal.annotation.Column;
import org.litepal.crud.LitePalSupport;

import java.io.Serializable;
import java.util.List;

/**
 * 消息对象
 */
public class MessageBean extends LitePalSupport implements Serializable, Cloneable {
    private int id;
    /**
     * 消息类型 group,team ,singleChat
     */
    private String class_type;
    /**
     * 系统消息类型
     */
    private String sys_msg_type;
    /**
     * 组id
     */
    private String group_id;
    /**
     * 组名称
     */
    private String group_name;
    /**
     * 本地消息id
     */
    private String local_id;
    /**
     * 消息id
     */
    private long msg_id;
    /**
     * 发送者uid
     */
    private String msg_sender;
    /**
     * 图片内容
     */
    private List<String> msg_src;
    /**
     * 消息状态 0。成功  1.失败  2.发送中
     */
    private int msg_state;
    /**
     * 工作消息、招聘消息类型标题
     */
    private String title;
    /**
     * 消息内容
     */
    private String msg_text;
    /**
     * 消息类型 text,voice,pic等
     */
    private String msg_type;
    /**
     * 消息发送时间
     */
    private long send_time;
    /**
     * 未读数
     */
    private int unread_members_num;
    /**
     * 工作消息里查看详情，如果不传msg_id就传bill_id
     */
    private String bill_id;
    /**
     * at我的消息
     */
    private String at_message;
    /**
     * 发送者信息
     */
    @Column(ignore = true)
    private UserInfo user_info;
    /**
     * 发送者json信息
     */
    private String user_info_json;
    /**
     * 语音长度
     */
    private float voice_long;
    /**
     * 图片宽高
     */
    private List<String> pic_w_h;
    /**
     * 是否正在播放
     */
    private boolean isPlaying;
    /**
     * 本地消息状态 1已读  0未读
     */
    private int is_readed_local;
    /**
     * 是否已读取 1已读  0未读
     */
    private int is_readed;
    /**
     * 是否已回执 1已读  0未读
     */
    private int is_received;
    /**
     * 当前用户uid
     */
    private String message_uid;
    /**
     * 活动消息内容
     */
    private ActivityInfoBean message_info;
    /*特殊消息类型保存的json对象*/
    private String msg_prodetails;
    //3.已经实名
    private String verified;
    /**
     * 回执类型（readed 已读 / received 接收 ）
     */
    @Column(ignore = true)
    private String type;
//    /* 找工作内容 */
//    @Column(ignore = true)
//    private ProjectBase prodetailactive;
//    /* 找帮手内容 */
//    @Column(ignore = true)
//    private FindHelper searchuser;

    public String getClass_type() {
        return class_type;
    }

    @Column(ignore = true)
    private String is_find_job;
    @Column(ignore = true)
    public GroupDiscussionInfo msg_prodetail;
    // 0:表示工人/工头两端都显示；1:表示工人端显示。2:表示工头端显示
    @Column(ignore = true)
    public String role_type;
//    @Column(ignore = true)
//    public String callBackMessageInfo;
    /**
     * 工作消息类型状态
     */
    private int status;
    /**
     * 工作消息是否已修改
     */
    private int modify;
    /**
     * 工作消息、招聘消息详情
     */
    private String detail;
    /**
     * 招聘消息详情url
     */
    private String url;
    /**
     * 原项目组id 工作消息类型时记录对应的组id
     */
    private String origin_group_id;
    /**
     * 原项目组类型 工作消息类型时记录对应的组类型
     */
    private String origin_class_type;
    /**
     * 用户id
     */
    private String uid;
    /**
     * 头像
     */
    private String head_pic;
    /**
     * 名称
     */
    @Column(ignore = true)
    private String real_name;
    /**
     * 扩展消息
     */
    @Column(ignore = true)
    private MessageExtend extend;
    /**
     * 扩展消息
     */
    private String extend_json;
    /**
     * 名片，工作信息等其他扩展消息json字符串
     */
    private String msg_text_other;
    /**
     * 分享的链接信息
     */
    @Column(ignore = true)
    private Share share_info;
    /**
     * 聊聊列表不显示本条消息
     */
    private boolean unShowChatLish;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public GroupDiscussionInfo getMsg_prodetail() {
        return msg_prodetail;
    }

    public void setMsg_prodetail(GroupDiscussionInfo msg_prodetail) {
        this.msg_prodetail = msg_prodetail;
    }

    public String getIs_find_job() {
        return is_find_job;
    }

    public void setIs_find_job(String is_find_job) {
        this.is_find_job = is_find_job;
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

    public String getLocal_id() {
        return local_id;
    }

    public void setLocal_id(String local_id) {
        this.local_id = local_id;
    }

    public long getMsg_id() {
        return msg_id;
    }

    public void setMsg_id(long msg_id) {
        this.msg_id = msg_id;
    }

    public String getMsg_sender() {
        return msg_sender;
    }

    public void setMsg_sender(String msg_sender) {
        this.msg_sender = msg_sender;
    }

    public List<String> getMsg_src() {
        return msg_src;
    }

    public void setMsg_src(List<String> msg_src) {
        this.msg_src = msg_src;
    }

    public int getMsg_state() {
        return msg_state;
    }

    public void setMsg_state(int msg_state) {
        this.msg_state = msg_state;
    }

    public String getMsg_text() {
        return msg_text;
    }

    public void setMsg_text(String msg_text) {
        this.msg_text = msg_text;
    }

    public String getMsg_type() {
        return msg_type;
    }

    public void setMsg_type(String msg_type) {
        this.msg_type = msg_type;
    }

    public long getSend_time() {
        return send_time;
    }

    public void setSend_time(long send_time) {
        this.send_time = send_time;
    }

    public int getUnread_members_num() {
        return unread_members_num;
    }

    public void setUnread_members_num(int unread_members_num) {
        this.unread_members_num = unread_members_num;
    }

    public UserInfo getUser_info() {
        return user_info;
    }

    public void setUser_info(UserInfo user_info) {
        this.user_info = user_info;
    }

    public float getVoice_long() {
        return voice_long;
    }

    public void setVoice_long(float voice_long) {
        this.voice_long = voice_long;
    }

    public List<String> getPic_w_h() {
        return pic_w_h;
    }

    public void setPic_w_h(List<String> pic_w_h) {
        this.pic_w_h = pic_w_h;
    }

    public boolean isPlaying() {
        return isPlaying;
    }

    public void setPlaying(boolean playing) {
        isPlaying = playing;
    }

    public int getIs_readed_local() {
        return is_readed_local;
    }

    public void setIs_readed_local(int is_readed_local) {
        this.is_readed_local = is_readed_local;
    }

    public int getIs_readed() {
        return is_readed;
    }

    public void setIs_readed(int is_readed) {
        this.is_readed = is_readed;
    }

    public String getMessage_uid() {
        return message_uid;
    }

    public void setMessage_uid(String message_uid) {
        this.message_uid = message_uid;
    }

    public int getIs_received() {
        return is_received;
    }

    public void setIs_received(int is_received) {
        this.is_received = is_received;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getSys_msg_type() {
        return sys_msg_type;
    }

    public void setSys_msg_type(String sys_msg_type) {
        this.sys_msg_type = sys_msg_type;
    }


    public ActivityInfoBean getMessage_info() {
        return message_info;
    }

    public void setMessage_info(ActivityInfoBean message_info) {
        this.message_info = message_info;
    }


    public MessageBean() {

    }

    public MessageBean(String class_type, String group_id) {
        this.class_type = class_type;
        this.group_id = group_id;
    }

    public String getGroup_name() {
        return group_name;
    }

    public void setGroup_name(String group_name) {
        this.group_name = group_name;
    }

    public String getDetail() {
        return detail;
    }

    public void setDetail(String detail) {
        this.detail = detail;
    }

    public String getUser_info_json() {
        return user_info_json;
    }

    public void setUser_info_json(String user_info_json) {
        this.user_info_json = user_info_json;
    }

    public String getAt_message() {
        return at_message;
    }

    public void setAt_message(String at_message) {
        this.at_message = at_message;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public int getModify() {
        return modify;
    }

    public void setModify(int modify) {
        this.modify = modify;
    }

    public String getBill_id() {
        return bill_id;
    }

    public void setBill_id(String bill_id) {
        this.bill_id = bill_id;
    }


    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getOrigin_group_id() {
        return origin_group_id;
    }

    public void setOrigin_group_id(String origin_group_id) {
        this.origin_group_id = origin_group_id;
    }

    public String getOrigin_class_type() {
        return origin_class_type;
    }

    public void setOrigin_class_type(String origin_class_type) {
        this.origin_class_type = origin_class_type;
    }

    public String getRole_type() {
        return role_type;
    }

    public void setRole_type(String role_type) {
        this.role_type = role_type;
    }

    public String getUid() {
        return uid;
    }

    public void setUid(String uid) {
        this.uid = uid;
    }

    @Override
    public boolean equals(Object o) {
        if (o instanceof MessageBean) {
            MessageBean bean = (MessageBean) o;
            return this.msg_id == bean.getMsg_id() || (!TextUtils.isEmpty(local_id) && TextUtils.isEmpty(bean.getLocal_id()) && this.local_id.equals(bean.getLocal_id()));
        }
        return super.equals(o);
    }

    public String getReal_name() {
        return real_name;
    }

    public void setReal_name(String real_name) {
        this.real_name = real_name;
    }

    public String getHead_pic() {
        return head_pic;
    }

    public void setHead_pic(String head_pic) {
        this.head_pic = head_pic;
    }

    public String getMsg_prodetails() {
        return msg_prodetails;
    }

    public void setMsg_prodetails(String msg_prodetails) {
        this.msg_prodetails = msg_prodetails;
    }

    public boolean isUnShowChatLish() {
        return unShowChatLish;
    }

    public void setUnShowChatLish(boolean unShowChatLish) {
        this.unShowChatLish = unShowChatLish;
    }

    public String getMsg_text_other() {
        return msg_text_other;
    }

    public void setMsg_text_other(String msg_text_other) {
        this.msg_text_other = msg_text_other;
    }

    public String getVerified() {
        return verified;
    }

    public void setVerified(String verified) {
        this.verified = verified;
    }

    public Share getShare_info() {
        return share_info;
    }

    public void setShare_info(Share share_info) {
        this.share_info = share_info;
    }

    @Override
    public Object clone() throws CloneNotSupportedException {
        MessageBean obj = (MessageBean) super.clone();
        if (obj != null && obj.getShare_info() != null) {
            obj.setShare_info((Share) obj.getShare_info().clone());
        }
        return obj;
    }


    public MessageExtend getExtend() {
        return extend;
    }

    public void setExtend(MessageExtend extend) {
        this.extend = extend;
    }

    public String getExtend_json() {
        return extend_json;
    }

    public void setExtend_json(String extend_json) {
        this.extend_json = extend_json;
    }

    @Override
    public String toString() {
        return "MessageBean{" +
                "id=" + id +
                ", class_type='" + class_type + '\'' +
                ", sys_msg_type='" + sys_msg_type + '\'' +
                ", group_id='" + group_id + '\'' +
                ", group_name='" + group_name + '\'' +
                ", local_id='" + local_id + '\'' +
                ", msg_id=" + msg_id +
                ", msg_sender='" + msg_sender + '\'' +
                ", msg_src=" + msg_src +
                ", msg_state=" + msg_state +
                ", title='" + title + '\'' +
                ", msg_text='" + msg_text + '\'' +
                ", msg_type='" + msg_type + '\'' +
                ", send_time=" + send_time +
                ", unread_members_num=" + unread_members_num +
                ", bill_id='" + bill_id + '\'' +
                ", at_message='" + at_message + '\'' +
                ", user_info=" + user_info +
                ", user_info_json='" + user_info_json + '\'' +
                ", voice_long=" + voice_long +
                ", pic_w_h=" + pic_w_h +
                ", isPlaying=" + isPlaying +
                ", is_readed_local=" + is_readed_local +
                ", is_readed=" + is_readed +
                ", is_received=" + is_received +
                ", message_uid='" + message_uid + '\'' +
                ", message_info=" + message_info +
                ", msg_prodetails='" + msg_prodetails + '\'' +
                ", verified='" + verified + '\'' +
                ", type='" + type + '\'' +
                ", is_find_job='" + is_find_job + '\'' +
                ", msg_prodetail=" + msg_prodetail +
                ", role_type='" + role_type + '\'' +
                ", status=" + status +
                ", modify=" + modify +
                ", detail='" + detail + '\'' +
                ", url='" + url + '\'' +
                ", origin_group_id='" + origin_group_id + '\'' +
                ", origin_class_type='" + origin_class_type + '\'' +
                ", uid='" + uid + '\'' +
                ", head_pic='" + head_pic + '\'' +
                ", real_name='" + real_name + '\'' +
                ", extend=" + extend +
                ", extend_json='" + extend_json + '\'' +
                ", msg_text_other='" + msg_text_other + '\'' +
                ", share_info=" + share_info +
                ", unShowChatLish=" + unShowChatLish +
                '}';
    }
}
