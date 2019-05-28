package com.jizhi.jlongg.main.adpter;

import android.app.Activity;
import android.content.Context;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseExpandableListAdapter;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.hcs.uclient.utils.DensityUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.log.LogDetailActivity;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;
import com.jizhi.jlongg.main.bean.LogChildBean;
import com.jizhi.jlongg.main.bean.LogGroupBean;
import com.jizhi.jlongg.main.bean.MessageEntity;
import com.jizhi.jlongg.main.message.ActivityNoticeDetailActivity;
import com.jizhi.jlongg.main.util.NameUtil;
import com.jizhi.jongg.widget.HorizotalImageLayout;
import com.jizhi.jongg.widget.RoundeImageHashCodeTextLayout;

import java.util.List;


/**
 * CName:新日志适配器2.3.0
 * User: hcs
 * Date: 2017-07-20
 * Time: 10:08
 */

public class MessageLogAdapter extends BaseExpandableListAdapter {
    private List<LogGroupBean> listMsg;
    private LayoutInflater inflater;
    private Context context;
    private String proName;
    private String groupName;
    private String classType;
    private GroupDiscussionInfo gnInfo;

    public MessageLogAdapter(Context context, List<LogGroupBean> listMsg, GroupDiscussionInfo gnInfo) {
        this.context = context;
        inflater = LayoutInflater.from(context);
        this.listMsg = listMsg;
        this.gnInfo = gnInfo;
    }

    public MessageLogAdapter(Context context, List<LogGroupBean> listMsg, String proName, String groupName, String classType) {
        this.context = context;
        inflater = LayoutInflater.from(context);
        this.listMsg = listMsg;
        this.proName = proName;
        this.groupName = groupName;
        this.classType = classType;
    }

    @Override
    public int getGroupCount() {
        return listMsg == null ? 0 : listMsg.size();
    }

    @Override
    public int getChildrenCount(int groupPosition) {
        return listMsg.get(groupPosition).getList().size();
    }

    @Override
    public Object getGroup(int groupPosition) {
        return listMsg.get(groupPosition);
    }

    @Override
    public Object getChild(int groupPosition, int childPosition) {
        return listMsg.get(groupPosition).getList().get(childPosition);
    }

    @Override
    public long getGroupId(int groupPosition) {
        return groupPosition;
    }

    @Override
    public long getChildId(int groupPosition, int childPosition) {
        return childPosition;
    }

    @Override
    public boolean hasStableIds() {
        return false;
    }

    @Override
    public View getGroupView(int groupPosition, boolean isExpanded, View convertView, ViewGroup parent) {
        final GroupHolder holder;
        if (convertView == null) {
            holder = new GroupHolder();
            convertView = inflater.inflate(R.layout.item_message_log_group, null);
            holder.tv_date = (TextView) convertView.findViewById(R.id.tv_date);
            holder.tv_count = (TextView) convertView.findViewById(R.id.tv_count);
            convertView.setTag(holder);
        } else {
            holder = (GroupHolder) convertView.getTag();
        }
        LogGroupBean logGroupBean = listMsg.get(groupPosition);
        holder.tv_date.setText(logGroupBean.getLog_date());
        holder.tv_count.setText("共" + logGroupBean.getDay_num() + "篇");
        return convertView;
    }

    @Override
    public View getChildView(final int groupPosition, final int childPosition, boolean isLastChild, View convertView, ViewGroup parent) {
        final ChildHolder childHolder;
        final LogChildBean msgEntity = listMsg.get(groupPosition).getList().get(childPosition);
        if (convertView == null) {
            childHolder = new ChildHolder();
            convertView = inflater.inflate(R.layout.item_message_log_child, null);
            childHolder.img_head = (RoundeImageHashCodeTextLayout) convertView.findViewById(R.id.img_head);
            childHolder.tv_name = (TextView) convertView.findViewById(R.id.tv_name);
            childHolder.tv_date = (TextView) convertView.findViewById(R.id.tv_date);
            childHolder.tv_type = (TextView) convertView.findViewById(R.id.tv_type);
            childHolder.tv_content = (TextView) convertView.findViewById(R.id.tv_content);
            childHolder.ngl_images = (HorizotalImageLayout) convertView.findViewById(R.id.ngl_images);
            convertView.setTag(childHolder);
        } else {
            childHolder = (ChildHolder) convertView.getTag();
        }
        childHolder.img_head.setView(msgEntity.getUser_info().getHead_pic(), msgEntity.getUser_info().getReal_name(), groupPosition);
        childHolder.tv_name.setText(NameUtil.setName(msgEntity.getUser_info().getReal_name()));
        childHolder.tv_type.setText(msgEntity.getCat_name());
        convertView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                LogDetailActivity.actionStart((Activity) context, gnInfo, msgEntity.getId() + "", msgEntity.getCat_name(), false);
            }
        });
        if (!TextUtils.isEmpty(msgEntity.getShow_list_content())) {
            childHolder.tv_content.setVisibility(View.VISIBLE);
            childHolder.tv_content.setText(msgEntity.getShow_list_content());
        } else {
            childHolder.tv_content.setVisibility(View.GONE);
            LinearLayout.LayoutParams layoutParams = new LinearLayout.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT);//定义一个LayoutParams
            layoutParams.setMargins(0, 30, 0, 0);
            childHolder.ngl_images.setLayoutParams(layoutParams);
        }
        if (msgEntity.getImgs().size() == 0) {
            childHolder.ngl_images.setVisibility(View.GONE);
            childHolder.tv_content.setMaxLines(2);
        } else {
            childHolder.tv_content.setMaxLines(2);
            childHolder.ngl_images.setVisibility(View.VISIBLE);
            childHolder.ngl_images.createImages(msgEntity.getImgs(), DensityUtils.dp2px(context, 20));
            convertView.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    LogDetailActivity.actionStart((Activity) context, gnInfo, msgEntity.getId() + "", msgEntity.getCat_name(), false);
                }
            });
        }
        return convertView;
    }

    public void startActivity(MessageEntity finalEn) {
        ActivityNoticeDetailActivity.actionStart(((Activity) context), gnInfo, finalEn.getMsg_id());
    }

    @Override
    public boolean isChildSelectable(int groupPosition, int childPosition) {
        return false;
    }


    class GroupHolder {
        /* 日期 */
        TextView tv_date;
        TextView tv_count;
    }

    class ChildHolder {
        RoundeImageHashCodeTextLayout img_head;
        TextView tv_name;
        TextView tv_date;
        TextView tv_content;
        HorizotalImageLayout ngl_images;
        LinearLayout lin;
        TextView tv_type;
    }
}
