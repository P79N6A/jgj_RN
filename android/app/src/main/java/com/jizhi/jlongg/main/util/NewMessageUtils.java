package com.jizhi.jlongg.main.util;

import android.app.Activity;
import android.content.Context;
import android.content.IntentFilter;
import android.text.Spannable;
import android.text.SpannableStringBuilder;
import android.text.TextUtils;
import android.text.style.URLSpan;
import android.widget.TextView;

import com.google.gson.Gson;
import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.SPUtils;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;
import com.jizhi.jlongg.main.bean.ItemClickBean;
import com.jizhi.jlongg.main.bean.MessageBean;
import com.jizhi.jlongg.main.bean.PersonBean;
import com.jizhi.jlongg.main.bean.UserInfo;
import com.jizhi.jlongg.main.dialog.NewMessageItemDialog;
import com.jizhi.jlongg.main.message.MessageUtils;
import com.jizhi.jlongg.main.message.WebSocketMeassgeParameter;
import com.jizhi.jlongg.main.msg.MessageType;

import java.util.ArrayList;
import java.util.List;

/**
 * 消息uitls
 */
public class NewMessageUtils {
    private Context activity;
    private GroupDiscussionInfo gnInfo;
    public static String offline_message_str = "";

    public NewMessageUtils(Context activity, GroupDiscussionInfo groupDiscussionInfo) {
        this.activity = activity;
        this.gnInfo = groupDiscussionInfo;
    }

    /**
     * 注册广播信息广播内容
     */
    public IntentFilter getfilter() {
        IntentFilter filter = new IntentFilter();
        filter.addAction(WebSocketConstance.SENDMESSAGE);
        filter.addAction(WebSocketConstance.RECEIVEMESSAGE);
        filter.addAction(WebSocketConstance.GET_CALLBACK_OPERATIONMESSAGE);
        filter.addAction(WebSocketConstance.MSGREADTOSENDER);
        filter.addAction(WebSocketConstance.RECALLMESSAGE);
        filter.addAction(WebSocketConstance.GET_OFFLINE_MESSAGE_LIST);
        filter.addAction(WebSocketConstance.CLEAR_MESSAGE);
        filter.addAction(WebSocketConstance.REFRESH_LOCAL_DATABASE_MAIN_INDEX_AND_CHAT_LIST);
        filter.addAction(WebSocketConstance.UPDATE_GROUP_PERSON_NAME_INCLUDE_MINE);
        filter.addAction(WebSocketConstance.SHOW_GROUP_MESSAGE);
        filter.addAction(WebSocketConstance.CHECK_HEAD_ISCHANGE);
        filter.addAction(WebSocketConstance.FORWARD_SUCCESS);
        filter.addAction(WebSocketConstance.SEND_MSG_FAIL);
        return filter;
    }

    /**
     * 判断消息是否为空
     *
     * @param messageList
     * @return
     */
    public boolean isEmptyList(List<MessageBean> messageList) {
        if (null == messageList || messageList.size() == 0) {
            return true;
        }
        return false;
    }

    /**
     * 获取用户名字
     *
     * @return
     */
    public String getRealName() {
        return SPUtils.get(activity, Constance.USERNAME, "", Constance.JLONGG).toString();

    }

    /**
     * 获取用户头像
     *
     * @return
     */
    public String getHeadPath() {
        return SPUtils.get(activity, Constance.HEAD_IMAGE, "", Constance.JLONGG).toString();

    }

    /**
     * 是否是自己发送的消息
     *
     * @param message
     * @return
     */
    public static boolean isMySendMessage(MessageBean message) {
        if (message.getMsg_sender().equals(UclientApplication.getUid())) {
            return true;
        }
        return false;
    }

    /**
     * 设置textview url样式
     *
     * @param textView
     */
    public static void settextStyle(Activity activity, TextView textView) {
        CharSequence text = textView.getText();
        if (text instanceof Spannable) {
            int end = text.length();
            Spannable sp = (Spannable) text;
            URLSpan urls[] = sp.getSpans(0, end, URLSpan.class);
            SpannableStringBuilder style = new SpannableStringBuilder(text);
            style.clearSpans();
            for (URLSpan urlSpan : urls) {
                MyURLSpan myURLSpan = new MyURLSpan(activity, urlSpan.getURL());
                style.setSpan(myURLSpan, sp.getSpanStart(urlSpan),
                        sp.getSpanEnd(urlSpan),
                        Spannable.SPAN_EXCLUSIVE_INCLUSIVE);
            }
            textView.setText(style);
        }
    }

    /**
     * 网页消息对象
     *
     * @return
     */
    public MessageBean getWorkBean(GroupDiscussionInfo gnInfo) {
        MessageBean messsageBean = new MessageBean();
        messsageBean.setMsg_type("proDetail");
        String local_id = (System.currentTimeMillis() / 1000) + "";
        messsageBean.setSend_time(Long.parseLong(local_id));
        messsageBean.setLocal_id(System.currentTimeMillis() + "");
        messsageBean.setIs_find_job("1");
        messsageBean.setMsg_state(2);
        messsageBean.setGroup_id(gnInfo.getGroup_id());
        messsageBean.setClass_type(gnInfo.getClass_type());
//        messsageBean.setVerified(gnInfo.getVerified());
        messsageBean.setUnread_members_num(0);
        messsageBean.setGroup_name(gnInfo.getGroup_name());
        UserInfo userInfo = new UserInfo();
        userInfo.setReal_name(getRealName());
        userInfo.setHead_pic(getHeadPath());
        messsageBean.setUser_info(userInfo);
        messsageBean.setMsg_id(0);
        messsageBean.setMsg_prodetail(gnInfo);
        messsageBean.setSys_msg_type("normal");
        return messsageBean;
    }

    /**
     * 文本消息对象
     *
     * @param path 图片路径
     * @return
     */
    public MessageBean getPicBean(String path) {
        MessageBean messsageBean = new MessageBean();
        messsageBean.setMsg_type(MessageType.MSG_PIC_STRING);
        String local_id = (System.currentTimeMillis()) + "";
        messsageBean.setSend_time(Long.parseLong(local_id));
        messsageBean.setLocal_id(System.currentTimeMillis() + "");
//        messsageBean.setMsg_text(content);
        List<String> list = new ArrayList<>();
        list.add(path);
        messsageBean.setMsg_src(list);
        messsageBean.setMsg_state(2);
        messsageBean.setGroup_id(gnInfo.getGroup_id());
        messsageBean.setClass_type(gnInfo.getClass_type());
        messsageBean.setMsg_sender(UclientApplication.getUid());
        UserInfo userInfo = new UserInfo();
        userInfo.setReal_name(getRealName());
        userInfo.setHead_pic(getHeadPath());
        messsageBean.setUser_info(userInfo);
        messsageBean.setUnread_members_num(-1);
        messsageBean.setMsg_id(0);
        messsageBean.setSys_msg_type("normal");
        return messsageBean;
    }


    /**
     * 图片路径集合
     *
     * @param serverPath    图片路径
     * @param localFilePath 本地图片路径
     * @return
     */
    public MessageBean getPicBean(ArrayList<String> serverPath, String localFilePath) {
        MessageBean messsageBean = new MessageBean();
        messsageBean.setMsg_type(MessageType.MSG_PIC_STRING);
        String local_id = (System.currentTimeMillis()) + "";
        messsageBean.setSend_time(Long.parseLong(local_id));
        messsageBean.setLocal_id(System.currentTimeMillis() + "");
        messsageBean.setMsg_src(serverPath);
        messsageBean.setMsg_state(2);
        messsageBean.setGroup_id(gnInfo.getGroup_id());
        messsageBean.setClass_type(gnInfo.getClass_type());
        messsageBean.setMsg_sender(UclientApplication.getUid());
        UserInfo userInfo = new UserInfo();
        userInfo.setReal_name(getRealName());
        userInfo.setHead_pic(getHeadPath());
        messsageBean.setUser_info(userInfo);
        messsageBean.setUnread_members_num(-1);
        messsageBean.setMsg_id(0);
        messsageBean.setSys_msg_type("normal");
        if (serverPath != null && serverPath.size() > 0) {
            messsageBean.setPic_w_h(Utils.getImageWidthAndHeight(localFilePath));
        }
        return messsageBean;
    }

    /**
     * 文本消息对象
     *
     * @param content 消息内容
     * @return
     */
    public MessageBean getTextBean(String content) {
        MessageBean messsageBean = new MessageBean();
        messsageBean.setMsg_type(MessageType.MSG_TEXT_STRING);
        String local_id = (System.currentTimeMillis() / 1000) + "";
        messsageBean.setSend_time(Long.parseLong(local_id));
        messsageBean.setLocal_id(System.currentTimeMillis() + "");
        messsageBean.setMsg_text(content.trim());
        messsageBean.setMsg_state(2);
        messsageBean.setGroup_id(gnInfo.getGroup_id());
        messsageBean.setClass_type(gnInfo.getClass_type());
        messsageBean.setMsg_sender(UclientApplication.getUid());
        messsageBean.setSys_msg_type("normal");
        UserInfo userInfo = new UserInfo();
        userInfo.setReal_name(getRealName());
        userInfo.setHead_pic(getHeadPath());
        messsageBean.setUser_info(userInfo);
        messsageBean.setUnread_members_num(-1);
        messsageBean.setMsg_id(0);
        return messsageBean;
    }


    /**
     * 提示消息对象
     *
     * @return
     */
    public MessageBean getHintBean(String real_name) {
        MessageBean messsageBean = new MessageBean();
        messsageBean.setSend_time(System.currentTimeMillis());
        messsageBean.setMsg_type(MessageType.MSG_SIGNIN_STRING);
        String local_id = (System.currentTimeMillis() / 1000) + "";
        messsageBean.setLocal_id(System.currentTimeMillis() + "");
        messsageBean.setSend_time(Long.parseLong(local_id));
        messsageBean.setMsg_text("在聊天过程中，涉及合同汇款、转账 、资金、中奖、回款等信息，请以视频或电话核实对方身份，以避免被骗导致钱款损失");
        messsageBean.setMsg_state(0);
        messsageBean.setGroup_id(gnInfo.getGroup_id());
        messsageBean.setClass_type(gnInfo.getClass_type());
        messsageBean.setMsg_sender(UclientApplication.getUid());
        UserInfo userInfo = new UserInfo();
        userInfo.setReal_name(getRealName());
        userInfo.setHead_pic(getHeadPath());
        messsageBean.setUser_info(userInfo);
        messsageBean.setUnread_members_num(-1);
        messsageBean.setMsg_id(System.currentTimeMillis() / 1000);
        messsageBean.setUnShowChatLish(true);
        messsageBean.setSys_msg_type("normal");

        return messsageBean;
    }

    /**
     * 提示群聊诈骗消息对象
     *
     * @return
     */
    public MessageBean getFraudHintBean(String real_name) {
        MessageBean messsageBean = new MessageBean();
        messsageBean.setSend_time(System.currentTimeMillis());
        messsageBean.setMsg_type(MessageType.MSG_SIGNIN_STRING);
        String local_id = (System.currentTimeMillis() / 1000) + "";
        messsageBean.setLocal_id(System.currentTimeMillis() + "");
        messsageBean.setSend_time(Long.parseLong(local_id));
        messsageBean.setMsg_text("在聊天过程中，涉及到找工作、招聘、招工、找活、包工等信息，请以视频或电话核实对方身份以防被骗，吉工家招聘平台有更多实名发布的真实可靠的招工找活信息。");
        messsageBean.setMsg_state(0);
        messsageBean.setGroup_id(gnInfo.getGroup_id());
        messsageBean.setClass_type(gnInfo.getClass_type());
        messsageBean.setMsg_sender(UclientApplication.getUid());
        UserInfo userInfo = new UserInfo();
        userInfo.setReal_name(getRealName());
        userInfo.setHead_pic(getHeadPath());
        messsageBean.setUser_info(userInfo);
        messsageBean.setUnread_members_num(-1);
        messsageBean.setMsg_id(System.currentTimeMillis() / 1000);
        messsageBean.setUnShowChatLish(true);
        return messsageBean;
    }

    public MessageBean getVoiceBean(float seconds, String voicePath, int msgState, DBMsgUtil dbMsgUtil, String real_name) {
        MessageBean messsageBean = new MessageBean();
        messsageBean.setMsg_type(MessageType.MSG_VOICE_STRING);
        int sencond = Math.round(seconds);
        messsageBean.setGroup_id(gnInfo.getGroup_id());
        messsageBean.setVoice_long(sencond);
        String local_id = (System.currentTimeMillis() / 1000) + "";
        messsageBean.setLocal_id(System.currentTimeMillis() + "");
        messsageBean.setSend_time(Long.parseLong(local_id));
        messsageBean.setClass_type(gnInfo.getClass_type());
        messsageBean.setMsg_sender(UclientApplication.getUid());
        UserInfo userInfo = new UserInfo();
        userInfo.setReal_name(getRealName());
        userInfo.setHead_pic(getHeadPath());
        messsageBean.setUser_info(userInfo);
        messsageBean.setMsg_state(msgState);
        messsageBean.setUnread_members_num(0);
        messsageBean.setMsg_id(Integer.parseInt(dbMsgUtil.selectMaxId(gnInfo.getGroup_id(), gnInfo.getClass_type())) + 2);
        List<String> list = new ArrayList<>();
        list.add(voicePath);
        messsageBean.setMsg_src(list);
        messsageBean.setMsg_id(0);
        messsageBean.setSys_msg_type("normal");
        return messsageBean;
    }

    /**
     * 名片或者招工消息对象
     *
     * @return
     */
    public MessageBean getInfoBean(String message_text_other, String msg_type) {
        MessageBean messsageBean = new MessageBean();
        messsageBean.setMsg_type(msg_type);
        String local_id = (System.currentTimeMillis() / 1000) + "";
        messsageBean.setSend_time(Long.parseLong(local_id));
        messsageBean.setLocal_id(System.currentTimeMillis() + "");
        messsageBean.setMsg_text("");
        messsageBean.setMsg_state(2);
        messsageBean.setGroup_id(gnInfo.getGroup_id());
        messsageBean.setClass_type(gnInfo.getClass_type());
        messsageBean.setMsg_sender(UclientApplication.getUid());
        messsageBean.setSys_msg_type("normal");
        UserInfo userInfo = new UserInfo();
        userInfo.setReal_name(getRealName());
        userInfo.setHead_pic(getHeadPath());
        messsageBean.setUser_info(userInfo);
        messsageBean.setUnread_members_num(-1);
        messsageBean.setMsg_id(0);
        /**
         * 名片消息内容
         */
        messsageBean.setMsg_text_other(message_text_other);
        return messsageBean;
    }

    /**
     * 提示消息对象
     *
     * @return
     */
    public MessageBean getAuthBean(String real_name) {
        MessageBean messsageBean = new MessageBean();
        messsageBean.setSend_time(System.currentTimeMillis());
        messsageBean.setMsg_type(MessageType.MSG_AUTH_STRING);
        String local_id = (System.currentTimeMillis() / 1000) + "";
        messsageBean.setLocal_id(System.currentTimeMillis() + "");
        messsageBean.setSend_time(Long.parseLong(local_id));
        messsageBean.setMsg_text(!TextUtils.isEmpty(real_name) ? real_name : getRealName());
        messsageBean.setMsg_state(0);
        messsageBean.setGroup_id(gnInfo.getGroup_id());
        messsageBean.setClass_type(gnInfo.getClass_type());
        messsageBean.setMsg_sender(UclientApplication.getUid());
        UserInfo userInfo = new UserInfo();
        userInfo.setReal_name(real_name);
        userInfo.setHead_pic(getHeadPath());
        messsageBean.setUser_info(userInfo);
        messsageBean.setUnread_members_num(-1);
        messsageBean.setMsg_id(System.currentTimeMillis() / 1000);
        messsageBean.setUnShowChatLish(true);
        messsageBean.setSys_msg_type("normal");

        return messsageBean;
    }

    /**
     * 文本消息对象
     *
     * @return
     */
    public static int getmsg_type_number(String msg_type) {
        switch (msg_type) {
            case MessageType.MSG_NEW_STRING:
                return MessageType.MSG_NEW_INT;
            case MessageType.MSG_TEXT_STRING://文字
                return MessageType.MSG_TEXT_INT;
            case MessageType.MSG_PIC_STRING:   //   图片
                return MessageType.MSG_PIC_INT;
            case MessageType.MSG_VOICE_STRING: //语音
                return MessageType.MSG_VOICE_INT;
            //邀请朋友
            case MessageType.ADD_GROUP_FRIEND_TEXT:
                return MessageType.ADD_GROUP_FRIEND_INT;
            //通知
            case MessageType.MSG_NOTICE_STRING:
                return MessageType.MSG_NOTICE_INT;
            //质量
            case MessageType.MSG_QUALITY_STRING:
                return MessageType.MSG_QUALITY_INT;
            //安全
            case MessageType.MSG_SAFE_STRING:
                return MessageType.MSG_SAFE_INT;
            //日志
            case MessageType.MSG_LOG_STRING:
                return MessageType.MSG_LOG_INT;
            //撤回
            case MessageType.MSG_RECALL_STRING:
                return MessageType.MSG_RECALL_INT;
            //找工作消息
            case MessageType.MSG_FINDWORK_STRING:
                return MessageType.MSG_FINDWORK_INT;
            //活动消息
            case MessageType.MSG_ACTIVITY_STRING:
                return MessageType.MSG_ACTIVITY_INT;
            //送积分消息
            case MessageType.MSG_PRESENT_STRING:
                return MessageType.MSG_PRESENT_INT;
            //加入地方群通知
            case MessageType.LOCAL_GROUP_CHAT_STRING:
                return MessageType.LOCAL_GROUP_CHAT_INT;
            //加入工作群通知
            case MessageType.WORK_GROUP_CHAT_STRING:
                return MessageType.WORK_GROUP_CHAT_INT;
            //名片消息
            case MessageType.MSG_POSTCARD_STRING:
                return MessageType.MSG_POSTCARD_INT;
            //新招工消息
            case MessageType.RECTUITMENT_STRING:
                return MessageType.RECTUITMENT_INT;
            //新招工消息
            case MessageType.MSG_FINDWORK_TEMP_STRING:
                return MessageType.MSG_FINDWORK_TEMP_INT;
            //认证消息
            case MessageType.MSG_AUTH_STRING:
                return MessageType.MSG_AUTH_INT;
            //链接消息
            case MessageType.MSG_LINK_STRING:
                return MessageType.MSG_LINK_INT;
                //链接消息
            case MessageType.MSG_POST_CENSOR_STRING:
                return MessageType.MSG_POST_CENSO_INT;
            //默认
            default:
                return -1;
        }
    }

    /**
     * 长按集合内容
     *
     * @param message
     * @return 消息状态 0。成功  1.失败  2.发送中
     */
    public static List<ItemClickBean> getMsgLongClickList(MessageBean message) {
        List<ItemClickBean> list = new ArrayList<>();
        //所有的长按事件
        if (message.getMsg_type().equals(MessageType.MSG_TEXT_STRING)) {
            //根据不同情况显示不同的内容  true，已经发送成功的消息 ，false 1发送失败的
            if (!NewMessageUtils.isMySendMessage(message)) {
                //对方的只能复制
                list.add(new ItemClickBean(NewMessageItemDialog.FORWARD, "转发"));

                list.add(new ItemClickBean(NewMessageItemDialog.COPY, "复制"));
            } else {
                if (message.getMsg_state() == 1) {
                    //失败
                    list.add(new ItemClickBean(NewMessageItemDialog.SEND, "重新发送"));
                    list.add(new ItemClickBean(NewMessageItemDialog.DELETE, "删除"));
                } else if (message.getMsg_state() == 2) {
                    //发送中
                    list.add(new ItemClickBean(NewMessageItemDialog.COPY, "复制"));

                } else if (message.getMsg_state() == 0) {
                    //成功
                    list.add(new ItemClickBean(NewMessageItemDialog.FORWARD, "转发"));
                    list.add(new ItemClickBean(NewMessageItemDialog.COPY, "复制"));
                    list.add(new ItemClickBean(NewMessageItemDialog.RECALL, "撤回"));
                }
            }
        } else if (message.getMsg_type().equals(MessageType.MSG_VOICE_STRING) || message.getMsg_type().equals(MessageType.MSG_PIC_STRING)) {
            //根据不同情况显示不同的内容  true，已经发送成功的消息 ，false 1发送失败的
            if (NewMessageUtils.isMySendMessage(message)) {
                //自己发送的
                if (message.getMsg_state() == 1) {
                    //失败
                    list.add(new ItemClickBean(NewMessageItemDialog.SEND, "重新发送"));
                    list.add(new ItemClickBean(NewMessageItemDialog.DELETE, "删除"));
                } else if (message.getMsg_state() == 0) {
                    //成功
                    if (message.getMsg_type().equals(MessageType.MSG_PIC_STRING)) {
                        list.add(new ItemClickBean(NewMessageItemDialog.FORWARD, "转发"));
                    }
                    list.add(new ItemClickBean(NewMessageItemDialog.RECALL, "撤回"));
                }
            } else {
                if (message.getMsg_type().equals(MessageType.MSG_PIC_STRING)) {
                    list.add(new ItemClickBean(NewMessageItemDialog.FORWARD, "转发"));
                }
            }
        }

        //可以转发的类型文字，图片，名片，链接
        if (message.getMsg_type().equals(MessageType.MSG_POSTCARD_STRING) || message.getMsg_type().equals(MessageType.MSG_LINK_STRING)) {
            if (message.getMsg_state() == 1) {
                //失败
                list.add(new ItemClickBean(NewMessageItemDialog.SEND, "重新发送"));
                list.add(new ItemClickBean(NewMessageItemDialog.DELETE, "删除"));
            } else if (message.getMsg_state() == 0) {
                //成功
                if (!message.getMsg_type().equals(MessageType.RECTUITMENT_INT)) {
                    list.add(new ItemClickBean(NewMessageItemDialog.FORWARD, "转发"));
                    list.add(new ItemClickBean(NewMessageItemDialog.RECALL, "撤回"));
                }

            }
        }

        if (null == list || list.size() == 0) {
            list = new ArrayList<>();
        }
        return list;
    }

    /**
     * 获取消息发送对象
     *
     * @param messsageBean
     * @param personList
     * @param isUrlMsg
     * @param isSource     分享转发错误提示问题
     *                     分享数据 is_source => 1
     *                     转发数据 is_source => 2
     *                     解决转发消息留言的问题
     *                     如果不是这个入口发送的消息只需要传0
     * @return
     */
    public WebSocketMeassgeParameter getMessageParemeter(MessageBean messsageBean, List<PersonBean> personList, boolean isUrlMsg, int isSource) {
        WebSocketMeassgeParameter msgParmeter = new WebSocketMeassgeParameter();
        msgParmeter.setAction(WebSocketConstance.SENDMESSAGE);


        msgParmeter.setCtrl(WebSocketConstance.MESSAGE);
        msgParmeter.setMsg_type(messsageBean.getMsg_type());
        msgParmeter.setClass_type(gnInfo.getClass_type());
        msgParmeter.setGroup_id(messsageBean.getGroup_id());
        msgParmeter.setLocal_id(messsageBean.getLocal_id() + "");
        if (!TextUtils.isEmpty(messsageBean.getMsg_text())) {
            msgParmeter.setMsg_text(messsageBean.getMsg_text());
        }
        if (isSource != 0) {
            msgParmeter.setIs_source(isSource);
        }
        //文本内容就读取@信息
        if (messsageBean.getMsg_type().equals(MessageType.MSG_TEXT_STRING)) {
            String atStr = MessageUtils.getAtInfo(messsageBean, personList);
            if (!TextUtils.isEmpty(atStr)) {
                msgParmeter.setAt_uid(atStr);
            }
        }
        if (null != messsageBean && null != messsageBean.getMsg_src() && messsageBean.getMsg_src().size() > 0) {
            for (int i = 0; i < messsageBean.getMsg_src().size(); i++) {
                if (!messsageBean.getMsg_src().get(i).contains("/storage/")) {
                    List<String> list = new ArrayList<>();
                    list.add(messsageBean.getMsg_src().get(i));
                    msgParmeter.setMsg_src(list);
                }
            }

        }
        if (null != messsageBean && messsageBean.getVoice_long() != 0) {
            msgParmeter.setVoice_long(messsageBean.getVoice_long() + "");
        }
        if (null != messsageBean.getPic_w_h() && messsageBean.getPic_w_h().size() > 0) {
            msgParmeter.setPic_w_h(messsageBean.getPic_w_h());
        }
        //名片信息
        if (!TextUtils.isEmpty(messsageBean.getMsg_text_other())) {
            msgParmeter.setMsg_text_other(messsageBean.getMsg_text_other());
        }
        if (gnInfo.is_find_job == 1) {
            msgParmeter.setIs_find_job("1");
            LUtils.e(+gnInfo.getIs_resume()+"------22-------发送找工作消息到服务器---------------" + gnInfo.is_find_job);
        }
        if(gnInfo.getIs_resume()==1){
            msgParmeter.setIs_resume(gnInfo.getIs_resume()+"");
        }
        return msgParmeter;
    }

    /**
     * 保存消息到本地
     */
    public static void saveMessage(MessageBean bean, Activity activity) {
        if (null == bean) {
            return;
        }
        if (null != bean && null != bean.getUser_info()) {
            bean.setMessage_uid(UclientApplication.getUid());
            bean.setUser_info_json(new Gson().toJson(bean.getUser_info()));//存储到子类为了方便修改昵称
            bean.save();
        }
        //刷新聊聊列表
        MessageUtil.setGroupChatLastMessageInfo(activity, "", -1, bean.getGroup_id(), bean.getClass_type(), bean);
    }


}
