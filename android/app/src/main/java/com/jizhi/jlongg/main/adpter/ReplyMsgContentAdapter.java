package com.jizhi.jlongg.main.adpter;

import android.support.v4.content.ContextCompat;
import android.text.Html;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.bumptech.glide.Glide;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.activity.ChatUserInfoActivity;
import com.jizhi.jlongg.main.bean.ReplyInfo;
import com.jizhi.jlongg.main.msg.MessageType;
import com.jizhi.jlongg.main.util.GlideUtils;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.jizhi.jongg.widget.RoundeImageHashCodeTextLayout;

import java.util.List;


/**
 * 功能: 2.3.4统一回复列表适配器
 * 作者：胡常生
 * 时间: 2017年11月21日 11:21:12
 */
public class ReplyMsgContentAdapter extends BaseAdapter {

    /* 添加工人列表数据 */
    private List<ReplyInfo> list;
    private LayoutInflater inflater;
    /* 上下文 */
    private BaseActivity context;


    public ReplyMsgContentAdapter(BaseActivity context, List<ReplyInfo> list) {
        super();
        this.list = list;
        inflater = LayoutInflater.from(context);
        this.context = context;
    }

    /**
     * 当ListView数据发生变化时,调用此方法来更新ListView
     *
     * @param list
     */
    public void updateListView(List<ReplyInfo> list) {
        this.list = list;
        notifyDataSetChanged();
    }

    @Override
    public int getCount() {
        return list == null ? 0 : list.size();
    }

    @Override
    public Object getItem(int position) {
        return list.get(position);
    }

    @Override
    public long getItemId(int position) {
        return position;
    }


    @Override
    public View getView(final int position, View convertView, ViewGroup parent) {
        ViewHolder holder;
        if (convertView == null) {
            convertView = inflater.inflate(R.layout.item_reply_msg_content, null);
            holder = new ViewHolder(convertView);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        bindData(holder, position);
        return convertView;
    }


    private void bindData(ViewHolder holder, final int position) {
        final ReplyInfo bean = list.get(position);
        holder.img_head.setView(bean.getUser_info().getHead_pic(), bean.getUser_info().getReal_name(), position);
        //回复的内容，回复人名字日期等
        holder.tv_reply_content.setText(bean.getReply_text());
        holder.tv_name.setText(bean.getUser_info().getReal_name());
        holder.tv_date.setText(bean.getCreate_time());
        if (bean.getReply_msg().size() > 0 && !TextUtils.isEmpty(bean.getReply_text())) {
            //回复的文字图片
            holder.tv_reply_content.setText("[图片]" + bean.getReply_text());
            holder.tv_reply_content.setTextColor(ContextCompat.getColor(context, R.color.color_999999));
        } else if (!TextUtils.isEmpty(bean.getReply_text())) {
            //回复的文字
            holder.tv_reply_content.setText(bean.getReply_text());
            holder.tv_reply_content.setTextColor(bean.getIs_delete() == 1 ? ContextCompat.getColor(context, R.color.color_999999) : ContextCompat.getColor(context, R.color.color_333333));
        } else if (bean.getReply_msg().size() > 0) {
            //回复的图片
            holder.tv_reply_content.setText("[图片]");
            holder.tv_reply_content.setTextColor(ContextCompat.getColor(context, R.color.color_999999));
        } else {
            holder.tv_reply_content.setText("~~");
            holder.tv_reply_content.setTextColor(ContextCompat.getColor(context, R.color.color_999999));
        }
        if (null != bean.getMsg_src() && bean.getMsg_src().size() > 0) {
            //如果发布信息里面有图片就显示图片
            new GlideUtils().glideImage(context,NetWorkRequest.IP_ADDRESS + bean.getMsg_src().get(0),holder.img_picture,R.drawable.icon_message_fail_default,R.drawable.icon_message_fail_default);
//            Glide.with(context).load(NetWorkRequest.CDNURL + bean.getMsg_src().get(0)).placeholder(R.drawable.icon_message_fail_default).error(R.drawable.icon_message_fail_default).into(holder.img_picture);
            holder.img_picture.setVisibility(View.VISIBLE);
            holder.tv_content.setMaxLines(2);
        } else {
            holder.img_picture.setVisibility(View.GONE);
            holder.tv_content.setMaxLines(1);
        }

        if (bean.getReply_type().equals(MessageType.MSG_QUALITY_STRING)) {
            if (!TextUtils.isEmpty(bean.getMsg_text())) {
                holder.tv_content.setText(Html.fromHtml("<font color='#45a1b1'>[质量]</font><font color='#333333'> " + bean.getPub_name() + "：" + "</font>" + bean.getMsg_text()));
            } else {
                holder.tv_content.setText(Html.fromHtml("<font color='#333333'> " + bean.getPub_name() + "：" + "</font>" + "发了一个质量"));
            }
        } else if (bean.getReply_type().equals(MessageType.MSG_SAFE_STRING)) {
            if (!TextUtils.isEmpty(bean.getMsg_text())) {
                holder.tv_content.setText(Html.fromHtml("<font color='#a26bda'>[安全]</font><font color='#333333'> " + bean.getPub_name() + "：" + "</font>" + bean.getMsg_text()));
            } else {
                holder.tv_content.setText(Html.fromHtml("<font color='#333333'> " + bean.getPub_name() + "：" + "</font>" + "发了一个安全"));
            }
        } else if (bean.getReply_type().equals(MessageType.MSG_NOTICE_STRING)) {
            if (!TextUtils.isEmpty(bean.getMsg_text())) {
                holder.tv_content.setText(Html.fromHtml("<font color='#4b70c1'>[通知]</font><font color='#333333'> " + bean.getPub_name() + "：" + "</font>" + bean.getMsg_text()));
            } else {
                holder.tv_content.setText(Html.fromHtml("<font color='#333333'> " + bean.getPub_name() + "：" + "</font>" + "发了一个通知"));
            }
        } else if (bean.getReply_type().equals(MessageType.MSG_LOG_STRING)) {
            if (!TextUtils.isEmpty(bean.getMsg_text())) {
                holder.tv_content.setText(Html.fromHtml("<font color='#e88a36'>[日志]</font><font color='#333333'> " + bean.getPub_name() + "：" + "</font>" + bean.getMsg_text()));
            } else {
                holder.tv_content.setText(Html.fromHtml("<font color='#333333'> " + bean.getPub_name() + "：" + "</font>" + "发了一个日志"));
            }
        } else if (bean.getReply_type().equals(MessageType.MSG_TASK_STRING)) {
            if (!TextUtils.isEmpty(bean.getMsg_text())) {
                holder.tv_content.setText(Html.fromHtml("<font color='#4dab75'>[任务]</font><font color='#333333'> " + bean.getPub_name() + "：" + "</font>" + bean.getMsg_text()));
            } else {
                holder.tv_content.setText(Html.fromHtml("<font color='#333333'> " + bean.getPub_name() + "：" + "</font>" + "发了一个任务"));
            }
        } else if (bean.getReply_type().equals(MessageType.MSG_METTING_STRING)) {
            if (!TextUtils.isEmpty(bean.getMsg_text())) {
                holder.tv_content.setText(Html.fromHtml("<font color='#99bc30'>[会议]</font><font color='#333333'> " + bean.getPub_name() + "：" + "</font>" + bean.getMsg_text()));
            } else {
                holder.tv_content.setText(Html.fromHtml("<font color='#333333'> " + bean.getPub_name() + "：" + "</font>" + "发了一个会议"));
            }
        }
        holder.img_head.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (!TextUtils.isEmpty(bean.getUser_info().getUid())) {
                    ChatUserInfoActivity.actionStart(context, bean.getUser_info().getUid());
                }

            }
        });
        holder.tv_name.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (!TextUtils.isEmpty(bean.getUser_info().getUid())) {
                    ChatUserInfoActivity.actionStart(context, bean.getUser_info().getUid());
                }
            }
        });
        holder.view_bottom.setVisibility(View.VISIBLE);
        holder.rea_history.setVisibility(View.GONE);
        if (position != list.size() - 1 && bean.getIs_readed() == 0 && list.size() >= position && list.get(position + 1).getIs_readed() == 1) {
            holder.rea_history.setVisibility(View.VISIBLE);
            holder.view_bottom.setVisibility(View.GONE);
        }
    }


    class ViewHolder {
        /* 人物名称 */
        TextView tv_name;
        /* 回复内容 */
        TextView tv_reply_content;
        /* 内容详情 */
        TextView tv_content;
        /* 回复日期 */
        TextView tv_date;
        /* 头像 */
        RoundeImageHashCodeTextLayout img_head;
        /* 图片内容 */
        ImageView img_picture;
        View view_bottom;
        RelativeLayout rea_history;

        public ViewHolder(View convertView) {
            tv_name = (TextView) convertView.findViewById(R.id.tv_name);
            tv_reply_content = (TextView) convertView.findViewById(R.id.tv_reply_content);
            tv_content = (TextView) convertView.findViewById(R.id.tv_content);
            tv_date = (TextView) convertView.findViewById(R.id.tv_date);
            img_head = (RoundeImageHashCodeTextLayout) convertView.findViewById(R.id.img_head);
            img_picture = (ImageView) convertView.findViewById(R.id.img_picture);
            view_bottom = convertView.findViewById(R.id.view_bottom);
            rea_history = (RelativeLayout) convertView.findViewById(R.id.rea_history);
        }
    }
}
