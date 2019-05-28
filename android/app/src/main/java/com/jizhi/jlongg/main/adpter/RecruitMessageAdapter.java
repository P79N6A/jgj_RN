package com.jizhi.jlongg.main.adpter;

import android.content.Context;
import android.graphics.Color;
import android.text.Spannable;
import android.text.SpannableStringBuilder;
import android.text.Spanned;
import android.text.TextUtils;
import android.text.style.ForegroundColorSpan;
import android.text.style.StyleSpan;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.MessageBean;
import com.jizhi.jlongg.main.bean.MessageExtend;

import java.util.ArrayList;
import java.util.regex.Matcher;
import java.util.regex.Pattern;


/**
 * 功能:招聘消息列表适配器
 * 时间:2018年7月31日15:05:54
 * 作者:xuj
 */
public class RecruitMessageAdapter extends BaseAdapter {
    /**
     * 列表数据
     */
    private ArrayList<MessageBean> list;
    /**
     * xml解析器
     */
    private LayoutInflater inflater;
    /**
     * 普通消息
     */
    private final int NORMAL_RECRUIT_MESSAGE = 0;
    /**
     * 拨打电话消息
     */
    private final int PROJECT_INFO_RECRUIT_MESSAGE = 1;

    public RecruitMessageAdapter(Context context, ArrayList<MessageBean> list) {
        super();
        this.list = list;
        inflater = LayoutInflater.from(context);
    }

    @Override
    public int getItemViewType(int position) {
        switch (getItem(position).getMsg_type()) {
            case "projectinfo":
                return PROJECT_INFO_RECRUIT_MESSAGE;
        }
        return NORMAL_RECRUIT_MESSAGE;
    }

    @Override
    public int getViewTypeCount() {
        return 2;
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
            switch (itemType) {
                case NORMAL_RECRUIT_MESSAGE:
                    convertView = inflater.inflate(R.layout.recruit_normal_message, null, false);
                    break;
                case PROJECT_INFO_RECRUIT_MESSAGE:
                    convertView = inflater.inflate(R.layout.recruit_project_info_message, null, false);
                    break;
            }
            holder = new ViewHolder(convertView, itemType);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        bindData(holder, position, convertView, itemType);
        return convertView;
    }

    private void bindData(final ViewHolder holder, final int position, View convertView, int itemType) {
        MessageBean recruitMessage = getItem(position);
        holder.messageTypeAndDate.setText("找活招工小助手 " + (recruitMessage.getSend_time() == 0 ? "" : Utils.simpleMessageForDate(recruitMessage.getSend_time())));
        switch (itemType) {
            case NORMAL_RECRUIT_MESSAGE:
                if (recruitMessage.getUser_info() != null && !TextUtils.isEmpty(recruitMessage.getUser_info().getReal_name())) {
                    holder.messageTitle.setText(Utils.setSelectedFontChangeColor(recruitMessage.getTitle(), recruitMessage.getUser_info().getReal_name(),
                            Color.parseColor("#000000"), true));
                } else {
                    holder.messageTitle.setText(recruitMessage.getTitle());
                }
                if (recruitMessage.getExtend() != null && recruitMessage.getExtend().getContent() != null) {
                    SpannableStringBuilder builder = new SpannableStringBuilder(recruitMessage.getDetail());
                    for (MessageExtend messageExtend : recruitMessage.getExtend().getContent()) {
                        String textColor = messageExtend.getColor();
                        String content = messageExtend.getField();
                        if (!TextUtils.isEmpty(textColor) && !TextUtils.isEmpty(content)) {
                            Matcher matcher = Pattern.compile(content).matcher(recruitMessage.getDetail());
                            while (matcher.find()) {
                                builder.setSpan(new ForegroundColorSpan(Color.parseColor(textColor)), matcher.start(), matcher.end(), Spannable.SPAN_INCLUSIVE_INCLUSIVE);
                                builder.setSpan(new StyleSpan(android.graphics.Typeface.BOLD), matcher.start(), matcher.end(), Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);  //粗体
                            }
                        }
                    }
                    holder.messageContent.setText(builder);
                } else {
                    holder.messageContent.setText(recruitMessage.getDetail());
                }
                //feedback是举报信息 不需要显示查看详情
                holder.searchDetail.setVisibility(TextUtils.isEmpty(recruitMessage.getUrl()) || "feedback".equals(recruitMessage.getMsg_type()) ? View.GONE : View.VISIBLE);
                break;
            case PROJECT_INFO_RECRUIT_MESSAGE:
                if (recruitMessage.getExtend() != null && recruitMessage.getExtend().getMsg_content() != null) {
                    MessageExtend extend = recruitMessage.getExtend().getMsg_content();
                    if (!TextUtils.isEmpty(recruitMessage.getTitle())) {
                        SpannableStringBuilder builder = new SpannableStringBuilder(recruitMessage.getTitle());
                        for (MessageExtend messageExtend : recruitMessage.getExtend().getContent()) {
                            String textColor = messageExtend.getColor();
                            String content = messageExtend.getField();
                            if (!TextUtils.isEmpty(textColor) && !TextUtils.isEmpty(content)) {
                                Matcher matcher = Pattern.compile(content).matcher(recruitMessage.getTitle());
                                while (matcher.find()) {
                                    builder.setSpan(new ForegroundColorSpan(Color.parseColor(textColor)), matcher.start(), matcher.end(), Spannable.SPAN_INCLUSIVE_INCLUSIVE);
                                    builder.setSpan(new StyleSpan(android.graphics.Typeface.BOLD), matcher.start(), matcher.end(), Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);  //粗体
                                }
                            }
                        }
                        holder.messageTitle.setText(builder);
                    } else {
                        holder.messageTitle.setText(recruitMessage.getTitle());
                    }
                    holder.todayNumTextValue.setText(extend.getToday_num());
                    if (!TextUtils.isEmpty(extend.getPro_name())) {
                        holder.proNameText.setVisibility(View.VISIBLE);
                        holder.proNameTextValue.setVisibility(View.VISIBLE);
                        holder.proNameTextValue.setText(extend.getPro_name());
                    } else {
                        holder.proNameText.setVisibility(View.GONE);
                        holder.proNameTextValue.setVisibility(View.GONE);
                    }
                    holder.viewCountTextValue.setText(extend.getView_count());
                    holder.allNumTextValue.setText(extend.getAll_num());
                    if (!TextUtils.isEmpty(extend.getSystem_msg())) {
                        holder.systemMsg.setVisibility(View.VISIBLE);
                        holder.systemMsg.setText("系统提示：" + extend.getSystem_msg());
                    } else {
                        holder.systemMsg.setVisibility(View.GONE);
                    }
                    //feedback是举报信息 不需要显示查看详情
                    holder.searchDetail.setVisibility(TextUtils.isEmpty(extend.getJump_url()) ? View.GONE : View.VISIBLE);
                }
                break;
        }
    }


    class ViewHolder {
        public ViewHolder(View convertView, int itemType) {
            messageTypeAndDate = (TextView) convertView.findViewById(R.id.message_type_and_date);
            messageTitle = (TextView) convertView.findViewById(R.id.message_title);
            searchDetail = convertView.findViewById(R.id.detail_content);
            switch (itemType) {
                case NORMAL_RECRUIT_MESSAGE:
                    messageContent = (TextView) convertView.findViewById(R.id.message_content);
                    break;
                case PROJECT_INFO_RECRUIT_MESSAGE:
                    todayNumTextValue = (TextView) convertView.findViewById(R.id.today_num_text_value);
                    proNameText = (TextView) convertView.findViewById(R.id.pro_name_text);
                    proNameTextValue = (TextView) convertView.findViewById(R.id.pro_name_text_value);
                    viewCountTextValue = (TextView) convertView.findViewById(R.id.view_count_text_value);
                    allNumTextValue = (TextView) convertView.findViewById(R.id.all_num_text_value);
                    systemMsg = (TextView) convertView.findViewById(R.id.system_msg);
                    break;
            }
        }

        /**
         * 消息类型以及发送时间
         * 04-19 12:57
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

        //以下是项目消息所需要使用到的字段
        /**
         * 今日拨打电话人数
         */
        TextView todayNumTextValue;
        /**
         * 项目名称标题
         */
        TextView proNameText;
        /**
         * 项目名称值
         */
        TextView proNameTextValue;
        /**
         * 累计浏览次数
         */
        TextView viewCountTextValue;
        /**
         * 累计拨打电话人数
         */
        TextView allNumTextValue;
        /**
         * 系统提示
         */
        TextView systemMsg;
    }

    public ArrayList<MessageBean> getList() {
        return list;
    }

    public void setList(ArrayList<MessageBean> list) {
        this.list = list;
    }


    public interface WorkMessageSyncListener {
        public void agreeSync(); //同意同步

        public void refuseSync(); //拒绝同步

    }

    public void updateList(ArrayList<MessageBean> list) {
        this.list = list;
        notifyDataSetChanged();
    }

}
