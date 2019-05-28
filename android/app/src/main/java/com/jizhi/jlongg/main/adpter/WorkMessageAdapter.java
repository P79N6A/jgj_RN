package com.jizhi.jlongg.main.adpter;

import android.app.Activity;
import android.support.v4.content.ContextCompat;
import android.text.Html;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.MessageBean;
import com.jizhi.jlongg.main.msg.MessageType;

import java.util.ArrayList;


/**
 * 功能:工作消息列表适配器
 * 时间:2018年7月31日15:05:54
 * 作者:xuj
 */
public class WorkMessageAdapter extends BaseAdapter {
    /**
     * 列表数据
     */
    private ArrayList<MessageBean> list;
    /**
     * xml解析器
     */
    private LayoutInflater inflater;


    private Activity activity;
    /**
     * 质量、安全、通知、日志、审批、检查、任务 工作消息类型
     */
    private final int NORMAL_WORK_MESSAGE = 0;
    /**
     * 群聊组状态改变的工作消息
     */
    private final int GROUP_STATE_CHANGE_MESSAGE = 1;
    /**
     * 云盘工作消息
     */
    private final int CLOUD_WORK_MESSAGE = 2;
    /**
     * 同步工作消息
     */
    private final int SYNC_WORK_MESSAGE = 3;
    /**
     * 未知的工作消息类型
     */
    private final int UN_KNOW_MESSAGE_TYPE = 4;
    /**
     * 群聊组状态改变的工作消息
     */
    private final int GROUP_STATE_OPEN = 5;


    public WorkMessageAdapter(Activity activity, ArrayList<MessageBean> list) {
        super();
        this.activity = activity;
        this.list = list;
        inflater = LayoutInflater.from(activity);
    }


    @Override
    public int getViewTypeCount() {
        return 6;
    }

    @Override
    public int getItemViewType(int position) {
        MessageBean message = getItem(position);
        switch (message.getMsg_type()) {
            case MessageType.MSG_CLOUD:
                return CLOUD_WORK_MESSAGE;
            case MessageType.MSG_QUALITY_STRING:
            case MessageType.MSG_SAFE_STRING:
            case MessageType.MSG_NOTICE_STRING:
            case MessageType.MSG_LOG_STRING:
            case MessageType.MSG_TASK_STRING:
            case MessageType.MSG_APPROVAL_STRING:
            case MessageType.MSG_INSPECT_STRING:
            case MessageType.MSG_METTING_STRING:
                return NORMAL_WORK_MESSAGE;
            case MessageType.JOIN:
            case MessageType.REOPEN:
            case MessageType.SWITCH_GROUP:
                return GROUP_STATE_OPEN;
            case MessageType.REMOVE:
            case MessageType.CLOSE:
            case MessageType.EVALUATE:
            case MessageType.INTEGRAL:
            case MessageType.DISMISS_GROUP:
            case MessageType.NEW_FRIEND_MESSAGE:
                return GROUP_STATE_CHANGE_MESSAGE;
            case MessageType.REQUIRE_SYNC_PROJECT:
            case MessageType.AGREE_SYNC_PROJECT:
            case MessageType.RESUSE_SYNC_PROJECT:
            case MessageType.DEMAND_SYNC_BILL:
            case MessageType.SYNC_BILL_TO_YOU:
            case MessageType.AGREE_SYNC_BILL:
            case MessageType.REFUSE_SYNC_BILL:
            case MessageType.CANCEL_SYNC_PROJECT:
            case MessageType.CANCEL_SYNC_BILL:
                return SYNC_WORK_MESSAGE;
        }
        return UN_KNOW_MESSAGE_TYPE;
    }

    @Override
    public int getCount() {
        return list == null ? 0 : list.size();
    }

    @Override
    public MessageBean getItem(int position) {
        return list.get(position);
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    @Override
    public View getView(final int position, View convertView, ViewGroup parent) {
        final ViewHolder holder;
        int itemType = getItemViewType(position);
        if (convertView == null) {
//            switch (itemType) {
//                case NORMAL_WORK_MESSAGE:
//                    convertView = inflater.inflate(R.layout.work_message_common_item, null, false);
//                    break;
//                case GROUP_STATE_CHANGE_MESSAGE:
//                    convertView = inflater.inflate(R.layout.work_message_group_state_change_item, null, false);
//                    break;
//                case CLOUD_WORK_MESSAGE:
//                    convertView = inflater.inflate(R.layout.work_message_cloud_item, null, false);
//                    break;
//                case SYNC_WORK_MESSAGE:
//                    convertView = inflater.inflate(R.layout.work_message_sync_item, null, false);
//                    break;
//            }
            convertView = inflater.inflate(R.layout.work_message_common_item, null, false);
            holder = new ViewHolder(convertView, itemType);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        bindData(holder, position, convertView, itemType);
        return convertView;
    }

    private void bindData(final ViewHolder holder, final int position, View convertView, int itemType) {
        final MessageBean workMessage = getItem(position);
        holder.messageContent.setText(TextUtils.isEmpty(workMessage.getMsg_text()) ? "" : Html.fromHtml(workMessage.getMsg_text()));
        holder.searchDetail.setText(R.string.search_detail);
        switch (itemType) {
            case NORMAL_WORK_MESSAGE:
                fillNormalData(holder, workMessage, convertView);
                break;
            case GROUP_STATE_OPEN:
            case GROUP_STATE_CHANGE_MESSAGE:
                fillGroupStateData(holder, workMessage, convertView);
                break;
            case CLOUD_WORK_MESSAGE:
                fillCloudData(holder, workMessage, convertView);
                break;
            case SYNC_WORK_MESSAGE:
                fillSyncData(holder, workMessage, convertView);
                break;
            case UN_KNOW_MESSAGE_TYPE:
                fillUnKnowMessageType(holder, workMessage, convertView);
                break;
        }
    }

    /**
     * 填充质量、安全、通知、日志、任务、审批、会议工作消息数据
     *
     * @param holder
     * @param workMessage
     * @param convertView
     */
    private void fillNormalData(final ViewHolder holder, MessageBean workMessage, View convertView) {
        String date = workMessage.getSend_time() == 0 ? "" : Utils.simpleMessageForDate(workMessage.getSend_time());
        String msgType = workMessage.getMsg_type();
        switch (msgType) {
            case MessageType.MSG_QUALITY_STRING:
                holder.messageTypeIcon.setImageResource(R.drawable.work_message_quality);
                holder.messageTypeAndDate.setText("质量 " + date);
                holder.messageTitle.setText("质量");
                holder.messageTitle.setTextColor(ContextCompat.getColor(activity, R.color.color_F59019));
                break;
            case MessageType.MSG_SAFE_STRING:
                holder.messageTypeIcon.setImageResource(R.drawable.work_message_safe);
                holder.messageTypeAndDate.setText("安全 " + date);
                holder.messageTitle.setText("安全");
                holder.messageTitle.setTextColor(ContextCompat.getColor(activity, R.color.color_5771FF));
                break;
            case MessageType.MSG_NOTICE_STRING:
                holder.messageTypeIcon.setImageResource(R.drawable.work_message_notice);
                holder.messageTypeAndDate.setText("通知 " + date);
                holder.messageTitle.setText("通知");
                holder.messageTitle.setTextColor(ContextCompat.getColor(activity, R.color.color_21B9D0));
                break;
            case MessageType.MSG_METTING_STRING:
                holder.messageTypeIcon.setImageResource(R.drawable.work_message_metting);
                holder.messageTypeAndDate.setText("会议 " + date);
                holder.messageTitle.setText("会议");
                holder.messageTitle.setTextColor(ContextCompat.getColor(activity, R.color.color_21B9D0));
                break;
            case MessageType.MSG_LOG_STRING:
                holder.messageTypeIcon.setImageResource(R.drawable.work_message_log);
                holder.messageTypeAndDate.setText("日志 " + date);
                holder.messageTitle.setText("日志");
                holder.messageTitle.setTextColor(ContextCompat.getColor(activity, R.color.color_F59019));
                break;
            case MessageType.MSG_TASK_STRING:
                holder.messageTypeIcon.setImageResource(R.drawable.work_message_task);
                holder.messageTypeAndDate.setText("任务 " + date);
                holder.messageTitle.setText("任务");
                holder.messageTitle.setTextColor(ContextCompat.getColor(activity, R.color.color_21B9D0));
                break;
            case MessageType.MSG_APPROVAL_STRING:
                holder.messageTypeIcon.setImageResource(R.drawable.work_message_examine);
                holder.messageTypeAndDate.setText("审批 " + date);
                holder.messageTitle.setText("审批");
                holder.messageTitle.setTextColor(ContextCompat.getColor(activity, R.color.color_F59019));
                break;
            case MessageType.MSG_INSPECT_STRING:
                holder.messageTypeIcon.setImageResource(R.drawable.work_message_check);
                holder.messageTypeAndDate.setText("检查 " + date);
                holder.messageTitle.setText("检查");
                holder.messageTitle.setTextColor(ContextCompat.getColor(activity, R.color.color_F96061));
                break;
        }
        holder.searchDetail.setTextColor(ContextCompat.getColor(activity, R.color.color_333333));
        holder.searchDetail.setVisibility(workMessage.getStatus() == 4 &&
                !(MessageType.MSG_APPROVAL_STRING.equals(msgType) || MessageType.MSG_METTING_STRING.equals(msgType)) ? View.GONE : View.VISIBLE);

    }

    /**
     * 填充工班组、项目组 群聊状态信息工作状态数据
     *
     * @param holder
     * @param workMessage
     * @param convertView
     */
    private void fillGroupStateData(final ViewHolder holder, MessageBean workMessage, View convertView) {
        String date = workMessage.getSend_time() == 0 ? "" : Utils.simpleMessageForDate(workMessage.getSend_time());
        holder.messageTypeAndDate.setText("工作消息 " + date);
        holder.messageTypeIcon.setImageResource(R.drawable.work_message_chat_state);
        holder.messageTitle.setText(workMessage.getTitle());
        holder.messageTitle.setTextColor(ContextCompat.getColor(activity, R.color.color_F59019));
        holder.searchDetail.setTextColor(ContextCompat.getColor(activity, R.color.color_333333));
        switch (workMessage.getMsg_type()) {
            case MessageType.EVALUATE: //评价
                //已评价过的隐藏查看详情
                holder.searchDetail.setVisibility(workMessage.getStatus() == 4 ? View.GONE : View.VISIBLE);
                break;
            case MessageType.INTEGRAL: //积分
                holder.searchDetail.setVisibility(View.VISIBLE);
                break;
            case MessageType.NEW_FRIEND_MESSAGE:
                holder.searchDetail.setVisibility(View.VISIBLE);
                holder.searchDetail.setText("加他为好友");
                break;
            case MessageType.JOIN:
            case MessageType.REOPEN:
            case MessageType.SWITCH_GROUP:
                holder.searchDetail.setVisibility(View.VISIBLE);
                holder.searchDetail.setText("查看详情");
                break;
            default:
                holder.searchDetail.setVisibility(View.GONE);
                break;
        }
    }


    /**
     * 填充工班组、项目组 群聊状态信息工作状态数据
     *
     * @param holder
     * @param workMessage
     * @param convertView
     */
    private void fillUnKnowMessageType(final ViewHolder holder, MessageBean workMessage, View convertView) {
        String date = workMessage.getSend_time() == 0 ? "" : Utils.simpleMessageForDate(workMessage.getSend_time());
        holder.messageTypeAndDate.setText("工作消息 " + date);
        holder.messageContent.setText(Html.fromHtml("<font color='color='#666666'>当前版本暂不支持查看此消息，请升级为最新版本查看</font>"));
        holder.messageTypeIcon.setImageResource(R.drawable.work_message_chat_state);
        holder.messageTitle.setText(workMessage.getTitle());
        holder.messageTitle.setTextColor(ContextCompat.getColor(activity, R.color.color_F59019));
        holder.searchDetail.setVisibility(View.GONE);
    }

    /**
     * 填充云盘工作状态数据
     *
     * @param holder
     * @param workMessage
     * @param convertView
     */
    private void fillCloudData(final ViewHolder holder, MessageBean workMessage, View convertView) {
        String date = workMessage.getSend_time() == 0 ? "" : Utils.simpleMessageForDate(workMessage.getSend_time());
        holder.messageTypeAndDate.setText("云盘 " + date);
        holder.messageTypeIcon.setImageResource(R.drawable.work_message_cloud);
        holder.messageTitle.setText(workMessage.getTitle());
        holder.messageTitle.setTextColor(ContextCompat.getColor(activity, R.color.color_21B9D0));
        holder.searchDetail.setTextColor(ContextCompat.getColor(activity, R.color.color_21B9D0));
        holder.searchDetail.setVisibility(View.VISIBLE);
        switch (workMessage.getStatus()) {
            case 3: //云盘期限不足15天
                holder.searchDetail.setText("立即扩容");
                break;
            case 5: //云盘期限即将过期
                holder.searchDetail.setText("立即续订");
                break;
        }
    }

    /**
     * 填充同步工作消息数据
     *
     * @param holder
     * @param workMessage
     * @param convertView
     */
    private void fillSyncData(final ViewHolder holder, final MessageBean workMessage, View convertView) {
        String date = workMessage.getSend_time() == 0 ? "" : Utils.simpleMessageForDate(workMessage.getSend_time());
        final String msgType = workMessage.getMsg_type();
        holder.messageTitle.setText(workMessage.getTitle());
        holder.messageTitle.setTextColor(ContextCompat.getColor(activity, R.color.color_F59019));
        holder.messageTypeIcon.setImageResource(R.drawable.work_message_sync);
        switch (msgType) {
            case MessageType.REQUIRE_SYNC_PROJECT://要求同步项目 用户A 要求你同步项目记工记账情况 【拒绝】 【同步】
                holder.messageTypeAndDate.setText("同步项目 " + date);
                holder.searchDetail.setVisibility(View.VISIBLE);
                break;
            case MessageType.AGREE_SYNC_PROJECT://同意同步项目 你已将XXX项目1、XXX项目2 等项目的记工记账情况同步给用户A  查看详情>
                holder.messageTypeAndDate.setText("同步项目 " + date);
                holder.searchDetail.setVisibility(View.VISIBLE);
                break;
            case MessageType.RESUSE_SYNC_PROJECT://拒绝同步项目 你拒绝同步项目记工记账情况给用户A
                holder.messageTypeAndDate.setText("同步项目 " + date);
                holder.searchDetail.setVisibility(View.GONE);
                break;
            case MessageType.DEMAND_SYNC_BILL://记工同步请求 用户A（班组长）向你请求同步记工记账数据 【同步】【拒绝】
                holder.messageTypeAndDate.setText("同步记工 " + date);
                holder.searchDetail.setVisibility(View.VISIBLE);
                break;
            case MessageType.SYNC_BILL_TO_YOU://记工同步通知 用户B向你同步了记工记账数据    查看详情>
                holder.messageTypeAndDate.setText("同步记工 " + date);
                holder.searchDetail.setVisibility(View.VISIBLE);
                break;
            case MessageType.AGREE_SYNC_BILL://同意记工同步请求 你已将XXX项目同步记工记账数据给用户A  查看详情>
                holder.messageTypeAndDate.setText("同步记工 " + date);
                holder.searchDetail.setVisibility(View.VISIBLE);
                break;
            case MessageType.REFUSE_SYNC_BILL://记工同步被拒
                holder.messageTypeAndDate.setText("同步记工 " + date);
                holder.searchDetail.setVisibility(View.GONE);
                break;
            case MessageType.CANCEL_SYNC_PROJECT://取消同步项目（记工）
                holder.messageTypeAndDate.setText("同步项目 " + date);
                holder.searchDetail.setVisibility(View.GONE);
                break;
            case MessageType.CANCEL_SYNC_BILL://取消同步记账（记工记账）
                holder.messageTypeAndDate.setText("同步记工 " + date);
                holder.searchDetail.setVisibility(View.GONE);
                break;
        }
    }


    public void updateList(ArrayList<MessageBean> list) {
        this.list = list;
        notifyDataSetChanged();
    }

    class ViewHolder {
        public ViewHolder(View convertView, int itemType) {
            messageTypeAndDate = (TextView) convertView.findViewById(R.id.message_type_and_date);
            messageContent = (TextView) convertView.findViewById(R.id.message_content);
            messageTypeIcon = (ImageView) convertView.findViewById(R.id.message_type_icon);
            searchDetail = convertView.findViewById(R.id.detail_content);
            messageTitle = (TextView) convertView.findViewById(R.id.message_title);
        }

        /**
         * 消息类型图标
         */
        ImageView messageTypeIcon;
        /**
         * 消息类型以及发送时间
         * 如 审批 04-19 12:57
         */
        TextView messageTypeAndDate;
        /**
         * 消息内容
         */
        TextView messageContent;
        /**
         * 消息状态 标题
         */
        TextView messageTitle;
        /**
         * 查看详情文本
         */
        TextView searchDetail;
    }

    public ArrayList<MessageBean> getList() {
        return list;
    }

    public void setList(ArrayList<MessageBean> list) {
        this.list = list;
    }


    public interface WorkMessageSyncListener {
        public void clickLeftBtn(MessageBean messageBean); //拒绝同步

        public void clickRightBtn(MessageBean messageBean); //同意同步
    }
}
