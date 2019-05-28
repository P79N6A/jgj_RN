package com.jizhi.jlongg.main.message;


import android.app.Activity;
import android.content.Context;
import android.text.TextUtils;

import com.google.gson.Gson;
import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.SPUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;
import com.jizhi.jlongg.main.bean.LocalInfoBean;
import com.jizhi.jlongg.main.bean.MessageBean;
import com.jizhi.jlongg.main.bean.MessageEntity;
import com.jizhi.jlongg.main.bean.MessageInfo;
import com.jizhi.jlongg.main.bean.PersonBean;
import com.jizhi.jlongg.main.bean.PersonWorkInfoBean;
import com.jizhi.jlongg.main.bean.ProjectBase;
import com.jizhi.jlongg.main.bean.Share;
import com.jizhi.jlongg.main.bean.UserInfo;
import com.jizhi.jlongg.main.msg.MessageType;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.NewMessageUtils;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SocketManager;
import com.jizhi.jlongg.main.util.ThreadPoolManager;
import com.jizhi.jlongg.main.util.WebSocket;
import com.jizhi.jlongg.main.util.WebSocketConstance;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;

import org.litepal.LitePal;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;

/**
 * 消息数据库操作类
 */

public class MessageUtils {
    /**
     * 班组项目组是是否已经关闭
     *
     * @param info
     * @param activity
     * @return
     */
    public static boolean isCloseGroupAndTeam(GroupDiscussionInfo info, Context activity) {
        if (info.getIs_closed() == 1) {
            if (info.getClass_type().equals(WebSocketConstance.GROUP)) {
                CommonMethod.makeNoticeLong(activity, String.format(activity.getString(R.string.close_team_already), "班组"), CommonMethod.ERROR);
            } else {
                CommonMethod.makeNoticeLong(activity, String.format(activity.getString(R.string.close_team_already), "项目组"), CommonMethod.ERROR);
            }
            return true;
        }
        return false;
    }


    /**
     * 读取@成员信息
     *
     * @param mEntity
     * @param personList
     * @return
     */
    public static String getAtInfo(MessageBean mEntity, List<PersonBean> personList) {
        if (personList == null || personList.size() == 0) {
            return "";
        }
        //读取@人员列表
        if (mEntity.getMsg_text().trim().contains("@所有人")) {
            for (int i = 0; i < personList.size(); i++) {
                if (personList.get(i).getUid() == 123456) {
                    return "all";
                }
            }
        } else if (mEntity.getMsg_text().trim().contains("@")) {//包含@符号

            //读取@人员列表
            if (null != personList && personList.size() > 0) {
                HashSet<String> hashSet = new HashSet<>();
                for (int i = 0; i < personList.size(); i++) {
                    //字符串里面是否有这个人名字存在
                    if (mEntity.getMsg_text().trim().contains("@" + personList.get(i).getName().trim())) {
                        hashSet.add(personList.get(i).getUid() + "");
                    }
                }
                if (hashSet.size() > 0) {
                    StringBuffer sb = new StringBuffer();
                    Iterator<String> iterator = hashSet.iterator();
                    while (iterator.hasNext()) {
                        sb.append(iterator.next() + ",");
                    }
                    return sb.toString().substring(0, sb.length() - 1);
                }


            }
        }
        return "";
    }


    /**
     * 更新语言消息为已读
     */

    public static void up_is_read_local(MessageEntity msg) {
        MessageEntity messageEntity = new MessageEntity();
        messageEntity.setIs_readed_local("1");
        messageEntity.updateAll(" msg_id = ? and mobile_phone = ? ", msg.getMsg_id() + "", BaseActivity.mobile_phone);

    }


    /**
     * 保存或者清除草稿信息
     */
    public static void saveAndClearLocalInfo(LocalInfoBean localInfoBean, boolean isSava) {

        LUtils.e("保存的json:-----" + new Gson().toJson(localInfoBean));
        localInfoBean.setMobile_phone(BaseActivity.mobile_phone);

        if (localInfoBean.getInfo_type() == LocalInfoBean.TYPE_SEND) {
            //发送草稿
            LitePal.deleteAll(LocalInfoBean.class, "class_type = ? and msg_type = ? and group_id = ? and info_type = ? and mobile_phone = ? ",
                    localInfoBean.getClass_type(), localInfoBean.getMsg_type(), localInfoBean.getGroup_id(), localInfoBean.getInfo_type() + "", localInfoBean.getMobile_phone());
        } else if (localInfoBean.getInfo_type() == LocalInfoBean.TYPE_REPLY) {
            //回复草稿
            LitePal.deleteAll(LocalInfoBean.class, "msg_id = ? and class_type = ? and msg_type = ? and group_id = ? and info_type = ? and mobile_phone = ? ",
                    localInfoBean.getMsg_id() + "", localInfoBean.getClass_type(), localInfoBean.getMsg_type(), localInfoBean.getGroup_id(), localInfoBean.getInfo_type() + "", localInfoBean.getMobile_phone());
        } else if (localInfoBean.getInfo_type() == LocalInfoBean.TYPE_MSG) {
            //回复草稿
            LitePal.deleteAll(LocalInfoBean.class, "class_type = ? and msg_type = ? and group_id = ? and info_type = ? and mobile_phone = ? ",
                    localInfoBean.getClass_type(), localInfoBean.getMsg_type(), localInfoBean.getGroup_id(), localInfoBean.getInfo_type() + "", localInfoBean.getMobile_phone());
        }
        if (isSava) {
            localInfoBean.save();
        }

    }

    /**
     * 查询草稿信息
     */
    public static String selectLocalInfoNotice(LocalInfoBean localInfoBean) {
        LUtils.e("读取的json:-----" + new Gson().toJson(localInfoBean));
        localInfoBean.setMobile_phone(BaseActivity.mobile_phone);
        String content = "";
        List<LocalInfoBean> localInfoBeen = null;
        if (localInfoBean.getInfo_type() == LocalInfoBean.TYPE_SEND) {
            //发送草稿
            localInfoBeen = LitePal.select("content").where("class_type = ? and msg_type = ? and group_id = ? and info_type = ? and mobile_phone = ?", localInfoBean.getClass_type(), localInfoBean.getMsg_type(), localInfoBean.getGroup_id(), localInfoBean.getInfo_type() + "", localInfoBean.getMobile_phone()).find(LocalInfoBean.class);
        } else if (localInfoBean.getInfo_type() == LocalInfoBean.TYPE_REPLY) {
            //回复草稿
            localInfoBeen = LitePal.select("content").where("msg_id = ? and class_type = ? and msg_type = ? and group_id = ? and info_type = ? and mobile_phone = ?", localInfoBean.getMsg_id() + "", localInfoBean.getClass_type(), localInfoBean.getMsg_type(), localInfoBean.getGroup_id(), localInfoBean.getInfo_type() + "", localInfoBean.getMobile_phone()).find(LocalInfoBean.class);
        } else if (localInfoBean.getInfo_type() == LocalInfoBean.TYPE_MSG) {
            //回复草稿
            localInfoBeen = LitePal.select("content").where("class_type = ? and msg_type = ? and group_id = ? and info_type = ? and mobile_phone = ?", localInfoBean.getClass_type(), localInfoBean.getMsg_type(), localInfoBean.getGroup_id(), localInfoBean.getInfo_type() + "", localInfoBean.getMobile_phone()).find(LocalInfoBean.class);
        }
        if (null == localInfoBeen || localInfoBeen.size() == 0) {
            return "";
        }
        for (int i = 0; i < localInfoBeen.size(); i++) {
            LUtils.e("读取保存的草稿内容：" + localInfoBeen.get(i).getContent());
            content = localInfoBeen.get(i).getContent();
        }
        if (TextUtils.isEmpty(content)) {
            return "";
        }
        return content;
    }


    /**
     * 获取聊聊列表最新一条消息
     */
    public static String getRealName(String msg_type, String real_name) {
        if (!TextUtils.isEmpty(msg_type)) {
            switch (msg_type) {
                case MessageType.MSG_TEXT_STRING:  //文字
                case MessageType.MSG_PIC_STRING: //图片
                case MessageType.MSG_VOICE_STRING: //语音
                case MessageType.MSG_NOTICE_STRING://通知
                case MessageType.MSG_QUALITY_STRING://质量
                case MessageType.MSG_SAFE_STRING: //安全
                case MessageType.MSG_LOG_STRING://日志
                case MessageType.MSG_RECALL_STRING://撤回
                    return real_name;
                default:
                    return "";
            }
        }
        return "";
    }

    /**
     * 获取聊聊列表最新一条消息
     */
    public static String getMsg_Text(MessageBean bean) {
        if (!TextUtils.isEmpty(bean.getSys_msg_type())) {
            switch (bean.getSys_msg_type()) {
                case MessageType.WORK_MESSAGE_TYPE://工作消息
                case MessageType.RECRUIT_MESSAGE_TYPE: //招聘消息
                    return bean.getMsg_text();
                default: //普通消息
                    if (null == bean.getUser_info() || TextUtils.isEmpty(bean.getUser_info().getReal_name())) {
                        return bean.getMsg_text();
                    }
                    StringBuilder builder = new StringBuilder();
                    if (!TextUtils.isEmpty(bean.getMsg_type())) {
                        if (!WebSocketConstance.SINGLECHAT.equals(bean.getClass_type())) {
                            if (MessageType.MSG_SIGNIN_STRING.equals(bean.getMsg_type())) {
                                builder.append((UclientApplication.getUid().equals(bean.getMsg_sender()) ? "你" : bean.getUser_info().getReal_name()));
                            } else {//签到不需要拼接冒号:
                                builder.append(UclientApplication.getUid().equals(bean.getMsg_sender()) ? "我" : bean.getUser_info().getReal_name() + "：");
                            }
                        }
                        switch (bean.getMsg_type()) {
                            case MessageType.MSG_SIGNIN_STRING://签到
                            case MessageType.MSG_TEXT_STRING:  //文字
                                builder.append(bean.getMsg_text());
                                break;
                            case MessageType.MSG_PIC_STRING: //图片
                                builder.append("[图片]");
                                break;
                            case MessageType.MSG_VOICE_STRING: //语音
                                builder.append("[语音]");
                                break;
                            case MessageType.MSG_NOTICE_STRING://通知
                                builder.append("发布了一条工作通知");
                                break;
                            case MessageType.MSG_QUALITY_STRING://质量
                                builder.append("发布了一条质量问题");
                                break;
                            case MessageType.MSG_SAFE_STRING: //安全
                                builder.append("发布了一条安全问题");
                                break;
                            case MessageType.MSG_LOG_STRING://日志
                                builder.append("发布了一条工作日志");
                                break;
                            case MessageType.MSG_RECALL_STRING://撤回
                                builder.append("[撤回一条消息]");
                                break;
                            case MessageType.MSG_POSTCARD_STRING://名片
                                if (!TextUtils.isEmpty(bean.getMsg_text_other())) {
                                    UserInfo userInfo = new Gson().fromJson(bean.getMsg_text_other(), UserInfo.class);
                                    if (userInfo != null) {
                                        builder.append("[找活名片]" + userInfo.getReal_name());
                                    }
                                }
                                break;
                            case MessageType.MSG_LINK_STRING://链接
                                if (!TextUtils.isEmpty(bean.getMsg_text_other())) {
                                    Share linkShare = new Gson().fromJson(bean.getMsg_text_other(), Share.class);
                                    if (linkShare != null) {
                                        // [链接]XXXXX（有标题为标题，无标题为内容，都没有则只有“[链接]”两字）
                                        builder.append("[链接]" + (!TextUtils.isEmpty(linkShare.getTitle()) ? linkShare.getTitle() : linkShare.getDescribe()));
                                    }
                                }
                                break;
                            case MessageType.RECTUITMENT_STRING://找工作
                                if (!TextUtils.isEmpty(bean.getMsg_text_other())) {
                                    ProjectBase findProjectBean = new Gson().fromJson(bean.getMsg_text_other(), ProjectBase.class);
                                    if (findProjectBean != null) {
                                        builder.append("[招工信息]" + findProjectBean.getPro_title());
                                    }
                                }
                                break;
                            case MessageType.MSG_AUTH_STRING: //实名认证
                                if (bean.getUser_info() != null) {
                                    return bean.getUser_info().getReal_name() + " 未实名认证";
                                }
                            default:
                                return bean.getMsg_text();
                        }
                    }
                    return builder.toString();
            }
        }
        return "";
    }

    /**
     * 是否新增小数点+1
     *
     * @return
     */
    public static boolean isAddUnreadCount(Context context, MessageBean messageBean) {
        if (!TextUtils.isEmpty(messageBean.getSys_msg_type())) {
            switch (messageBean.getSys_msg_type()) {
                case MessageType.ACTIVITY_MESSAGE_TYPE: //活动消息
                    return true;
                case MessageType.WORK_MESSAGE_TYPE: //工作消息
                    return true;
                case MessageType.RECRUIT_MESSAGE_TYPE: //招聘消息
                    return true;
                case MessageType.NEW_FRIEND_MESSAGE_TYPE: //新朋友消息
                    String billIds = (String) SPUtils.get(context, "add_friend_bills", "", Constance.CHAT_SHAREPREFRENCES);
                    if (!TextUtils.isEmpty(billIds)) { //验证是否已有相同的好友发送了多次添加请求
                        if (billIds.contains(messageBean.getBill_id())) {
                            return false;
                        } else {
                            SPUtils.put(context, "add_friend_bills", billIds + "," + messageBean.getBill_id(), Constance.CHAT_SHAREPREFRENCES);
                            return true;
                        }
                    } else {
                        SPUtils.put(context, "add_friend_bills", messageBean.getBill_id(), Constance.CHAT_SHAREPREFRENCES);
                        return true;
                    }
            }
        }
        if (!TextUtils.isEmpty(messageBean.getMsg_type())) {  //普通消息
            switch (messageBean.getMsg_type()) {
                case MessageType.MSG_TEXT_STRING: //文本
                case MessageType.MSG_PIC_STRING:  //图片
                case MessageType.MSG_VOICE_STRING: //语音
                case MessageType.MSG_NOTICE_STRING: //通知
                case MessageType.MSG_QUALITY_STRING: //质量
                case MessageType.MSG_SAFE_STRING: //安全
                case MessageType.MSG_LOG_STRING: //日志
                case MessageType.MSG_POSTCARD_STRING: //名片
                case MessageType.MSG_LINK_STRING: //链接
                case MessageType.RECTUITMENT_STRING: //招工信息
                    return true;
                default:
                    return false;
            }
        }
        return false;
    }

    /**
     * 最后一条消息回执数据
     *
     * @param bean
     * @return
     */
    public static String getReciveReadInfo(MessageBean bean) {
        MessageInfo info = new MessageInfo();
        info.setGroup_id(bean.getGroup_id());
        info.setClass_type(bean.getClass_type());
        info.setMsg_id(String.valueOf(bean.getMsg_id()));
        List<MessageInfo> offLineMessage = new ArrayList<>();
        offLineMessage.add(info);
        return new Gson().toJson(offLineMessage);
    }

    /**
     * 发送已收到、已读回执
     *
     * @param jsonBean
     * @param type     回执类型（readed 已读 / received 接收 recall 消息撤回）
     */
    public static void getCallBackOperationMessage(Context context, String jsonBean, String type) {
        WebSocket webSocket = SocketManager.getInstance(context.getApplicationContext()).getWebSocket();
        LUtils.e("---sendBroadCastToShow-----11--ccccccc:" + jsonBean);

        if (webSocket != null) {
            LUtils.e("---sendBroadCastToShow-----11--ddddd");

            WebSocketMeassgeParameter msgParmeter = new WebSocketMeassgeParameter();
            msgParmeter.setCtrl(WebSocketConstance.MESSAGE);
            msgParmeter.setAction(WebSocketConstance.GET_CALLBACK_OPERATIONMESSAGE);
            msgParmeter.setMsg_info(jsonBean);
            //回执类型（readed 已读 / received 接收 recall 消息撤回）
            msgParmeter.setType(type);
            webSocket.requestServerMessage(msgParmeter);
        } else {
            NewMessageUtils.offline_message_str = jsonBean;
        }
    }

    /**
     * 当WebSocket连接成功的时候 调用的离线消息
     *
     * @param activity
     * @param isCheckGroupIsExist
     */
    public static void getOffMessageList(final Context activity, final boolean isCheckGroupIsExist) {
        final RequestParams params = RequestParamsToken.getExpandRequestParams(activity);
        CommonHttpRequest.commonRequest(activity, NetWorkRequest.GET_OFFLINE_MESSAGE_LIST, MessageBean.class, CommonHttpRequest.LIST, params, false, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(final Object object) {
                List<MessageBean> beanList = (List<MessageBean>) object;
                if (null != beanList && beanList.size() > 0) {
                    if (!ThreadPoolManager.isRunning) {
                        ThreadPoolManager.getInstance().executeReceiveMessage(beanList, activity, isCheckGroupIsExist);
                    }
                }
            }

            @Override
            public void onFailure(HttpException error, String msg) {
            }
        });
    }

    /**
     * 保存 工作消息和招聘消息
     *
     * @param activity
     * @param beanList   储存的对象
     * @param sysMsgType public static final String WORK_MESSAGE_TYPE  = "work"; //工作消息类型
     *                   public static final String RECRUIT_MESSAGE_TYPE = "recruit"; //招聘消息类型
     */
    public static void saveWorkRecruitMessage(Activity activity, final List<MessageBean> beanList, String sysMsgType) {
        if (beanList == null || beanList.isEmpty()) {
            return;
        }
        for (MessageBean bean : beanList) {
            if (MessageType.WORK_MESSAGE_TYPE.equals(sysMsgType)) {
                String msgType = bean.getMsg_type();
                if (msgType.equals(MessageType.JGB_SYNC_PROJECT_TO_YOU) || msgType.equals(MessageType.JGB_JOIN_TEAM) ||
                        msgType.equals(MessageType.JGB_CREATE_NEW_TEAM) || msgType.equals(MessageType.AGREE_SYNC_PROJECT_TO_YOU)) {
                    continue;
                }
            }
            if (bean.getUser_info() != null) {
                bean.setUser_info_json(new Gson().toJson(bean.getUser_info()));
            }
            if (bean.getExtend() != null) {
                bean.setExtend_json(new Gson().toJson(bean.getExtend()));
            }
            bean.setMessage_uid(UclientApplication.getUid());
            bean.saveOrUpdate(" message_uid = ? and msg_id = ? and sys_msg_type = ? ", UclientApplication.getUid(), String.valueOf(bean.getMsg_id()), sysMsgType);
        }
        MessageUtils.getCallBackOperationMessage(activity, new Gson().toJson(beanList), WebSocketConstance.RECEIVED);
    }

    /**
     * 合并工种
     */
    public static List<String> getWork_type(PersonWorkInfoBean personWorkInfoBean) {
        List<String> work_type = new ArrayList<>();
        if (null != personWorkInfoBean.getWorker_info() && null != personWorkInfoBean.getWorker_info().getWork_type() && personWorkInfoBean.getWorker_info().getWork_type().size() > 0) {
            for (String string : personWorkInfoBean.getWorker_info().getWork_type()) {
                if (!work_type.contains(string)) {
                    work_type.add(string);
                }
            }
        }
        if (null != personWorkInfoBean.getForeman_info() && null != personWorkInfoBean.getForeman_info().getWork_type() && personWorkInfoBean.getForeman_info().getWork_type().size() > 0) {
            for (String string : personWorkInfoBean.getForeman_info().getWork_type()) {
                if (!work_type.contains(string)) {
                    work_type.add(string);
                }
            }
        }
        return work_type;
    }
}
