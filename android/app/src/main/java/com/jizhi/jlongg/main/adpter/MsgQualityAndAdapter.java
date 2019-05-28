package com.jizhi.jlongg.main.adpter;

import android.annotation.TargetApi;
import android.app.Activity;
import android.content.Context;
import android.os.Build;
import android.text.Html;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.hcs.uclient.utils.DensityUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;
import com.jizhi.jlongg.main.bean.MessageBean;
import com.jizhi.jlongg.main.bean.MessageEntity;
import com.jizhi.jlongg.main.message.ActivityQualityAndSafeDetailActivity;
import com.jizhi.jlongg.main.util.NameUtil;
import com.jizhi.jongg.widget.HorizotalImageLayout;
import com.jizhi.jongg.widget.RoundeImageHashCodeTextLayout;

import java.util.List;

/**
 * huchangsheng：Administrator on 2016/2/23 14:01
 */
public class MsgQualityAndAdapter extends BaseAdapter {
    private List<MessageEntity> list;
    private LayoutInflater inflater;
    private Context context;
    private GroupDiscussionInfo gnInfo;

    public MsgQualityAndAdapter(Context context, List<MessageEntity> list, GroupDiscussionInfo gnInfo) {
        this.context = context;
        this.list = list;
        inflater = LayoutInflater.from(context);
        this.gnInfo = gnInfo;
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

    @TargetApi(Build.VERSION_CODES.JELLY_BEAN)
    @SuppressWarnings("deprecation")
    @Override
    public View getView(final int position, View convertView, ViewGroup parent) {
        ViewHolder holder;
        final MessageEntity msgEntity = list.get(position);
        if (convertView == null) {
            holder = new ViewHolder();
            convertView = inflater.inflate(R.layout.item_message_quslity_and_safe, null);
            holder.img_head = (RoundeImageHashCodeTextLayout) convertView.findViewById(R.id.img_head);
            holder.tv_name = (TextView) convertView.findViewById(R.id.tv_name);
            holder.tv_date = (TextView) convertView.findViewById(R.id.tv_date);
            holder.tv_content = (TextView) convertView.findViewById(R.id.tv_content);
            holder.tv_level = (TextView) convertView.findViewById(R.id.tv_level);
            holder.tv_overtime = (TextView) convertView.findViewById(R.id.tv_overtime);
            holder.tv_state = (TextView) convertView.findViewById(R.id.tv_state);
            holder.tv_userinfo = (TextView) convertView.findViewById(R.id.tv_userinfo);
            holder.ngl_images = (HorizotalImageLayout) convertView.findViewById(R.id.ngl_images);
            holder.img_light = (ImageView) convertView.findViewById(R.id.img_light);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        holder.img_head.setView(msgEntity.getHead_pic(), msgEntity.getReal_name(), 0);
        holder.tv_name.setText(NameUtil.setName(msgEntity.getReal_name()));
        holder.tv_date.setText(msgEntity.getUpdate_time());
        //完成时间
        if (!TextUtils.isEmpty(msgEntity.getFinish_time())) {
            holder.tv_overtime.setText("整改完成期限:" + msgEntity.getFinish_time());
        } else {
            holder.tv_overtime.setText("");
        }
        if (msgEntity.getUser_info() != null && !TextUtils.isEmpty(msgEntity.getUser_info().getReal_name())) {
            holder.tv_userinfo.setText(Html.fromHtml("由<font color='#4990e2'>" + NameUtil.setName(msgEntity.getUser_info().getReal_name()) + "</font>负责"));
        } else {
            holder.tv_userinfo.setText("");
        }
        ////1:待整改；2：待复查；3：已完结
        holder.tv_state.setText(msgEntity.getStatu_text());
        // 1：红灯；2：黄灯；3：绿灯
        if (msgEntity.getShow_bell() == 1) {
            holder.img_light.setBackground(context.getResources().getDrawable(R.drawable.icon_bill_red));
            holder.tv_state.setTextColor(context.getResources().getColor(R.color.color_eb4e4e));
        } else if (msgEntity.getShow_bell() == 2) {
            holder.img_light.setBackground(context.getResources().getDrawable(R.drawable.icon_bill_yellow));
            holder.tv_state.setTextColor(context.getResources().getColor(R.color.color_f9a00f));
        } else if (msgEntity.getShow_bell() == 3) {
            holder.img_light.setBackground(context.getResources().getDrawable(R.drawable.icon_bill_green));
            holder.tv_state.setTextColor(context.getResources().getColor(R.color.color_83c76e));
        }
        convertView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                MessageBean messageEntity = new MessageBean();
                messageEntity.setMsg_id(list.get(position).getMsg_id());
                messageEntity.setClass_type(list.get(position).getClass_type());
                messageEntity.setMsg_type(list.get(position).getMsg_type());
                messageEntity.setGroup_id(list.get(position).getGroup_id());
                ActivityQualityAndSafeDetailActivity.actionStart((Activity) context, messageEntity, gnInfo);
            }
        });
        if (!TextUtils.isEmpty(msgEntity.getMsg_text())) {
            holder.tv_content.setVisibility(View.VISIBLE);
            holder.tv_content.setText(msgEntity.getMsg_text());
        } else {
            holder.tv_content.setVisibility(View.GONE);
            LinearLayout.LayoutParams layoutParams = new LinearLayout.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT);//定义一个LayoutParams
            layoutParams.setMargins(0, 30, 0, 0);
            holder.ngl_images.setLayoutParams(layoutParams);
        }
        if (msgEntity.getMsg_src().size() == 0) {
            holder.ngl_images.setVisibility(View.GONE);
        } else {
            holder.ngl_images.setVisibility(View.VISIBLE);
            holder.ngl_images.createImages(msgEntity.getMsg_src(), DensityUtils.dp2px(context, 20));
        }
        if (TextUtils.isEmpty(msgEntity.getMsg_text()) && msgEntity.getMsg_src().size() > 0) {
            LinearLayout.LayoutParams layoutParams = new LinearLayout.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT);//定义一个LayoutParams
            layoutParams.setMargins(0, 5, 0, 40);
            holder.ngl_images.setLayoutParams(layoutParams);
        }
        return convertView;
    }

    class ViewHolder {
        RoundeImageHashCodeTextLayout img_head;
        TextView tv_name;
        TextView tv_date;
        TextView tv_content;
        TextView tv_level;
        TextView tv_overtime;
        TextView tv_state;
        HorizotalImageLayout ngl_images;
        TextView tv_userinfo;
        ImageView img_light;
    }
}
