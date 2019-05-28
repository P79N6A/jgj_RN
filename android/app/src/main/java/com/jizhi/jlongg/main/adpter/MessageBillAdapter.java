package com.jizhi.jlongg.main.adpter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseExpandableListAdapter;
import android.widget.TextView;

import com.hcs.uclient.utils.TimesUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.MessageBillData;

import java.util.List;

/**
 * huchangsheng：Administrator on 2016/2/24 15:42
 */
public class MessageBillAdapter extends BaseExpandableListAdapter {
    private List<MessageBillData> messageBillData;
    private LayoutInflater inflater;

    private int size;


    public MessageBillAdapter(Context context, List<MessageBillData> messageBillData) {
        this.messageBillData = messageBillData;
        inflater = LayoutInflater.from(context);
        getCalculateSize();
    }

    public void addList(List<MessageBillData> messageBillData) {
        this.messageBillData.addAll(messageBillData);
        getCalculateSize();
        notifyDataSetChanged();
    }

    public void update(List<MessageBillData> messageBillData) {
        this.messageBillData = messageBillData;
        getCalculateSize();
        notifyDataSetChanged();
    }

    @Override
    public int getGroupCount() {
        return messageBillData.size();
    }

    @Override
    public int getChildrenCount(int groupPosition) {
        return messageBillData.get(groupPosition).getList().size();
    }

    @Override
    public Object getGroup(int groupPosition) {
        return messageBillData.get(groupPosition);
    }

    @Override
    public Object getChild(int groupPosition, int childPosition) {
        return messageBillData.get(groupPosition).getList().get(childPosition);
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
        final MessageBillData mbData = messageBillData.get(groupPosition);
        if (convertView == null) {
            holder = new GroupHolder();
            convertView = inflater.inflate(R.layout.item_message_bill_group, null);
            holder.tvDate = (TextView) convertView.findViewById(R.id.tv_date);
            holder.topLine = convertView.findViewById(R.id.top_line);
            convertView.setTag(holder);
        } else {
            holder = (GroupHolder) convertView.getTag();
        }
        if (mbData.getDate().length() == 8) {
            //20151111
            String year = mbData.getDate().substring(0, 4);
            String month = mbData.getDate().substring(4, 6);
            String date = mbData.getDate().substring(6, 8);
            if (year.equals(TimesUtils.getCurrYear())) {
                holder.tvDate.setText(month + "月" + date + "日");
            } else {
                holder.tvDate.setText(year + "年" + month + "月" + date + "日");
            }
        } else {
            holder.tvDate.setText(mbData.getDate());
        }
        holder.topLine.setVisibility(groupPosition == 0 ? View.GONE : View.VISIBLE);
        return convertView;
    }

    @Override
    public View getChildView(final int groupPosition, final int childPosition, boolean isLastChild, View convertView, ViewGroup parent) {
        final ChildHolder childHolder;
        final MessageBillData mbData = messageBillData.get(groupPosition).getList().get(childPosition);
        if (convertView == null) {
            childHolder = new ChildHolder();
            convertView = inflater.inflate(R.layout.item_message_bill_child, null);
            childHolder.tv_name = (TextView) convertView.findViewById(R.id.tv_name);
            childHolder.tv_worktime = (TextView) convertView.findViewById(R.id.tv_worktime);
            childHolder.tv_overtime = (TextView) convertView.findViewById(R.id.tv_overtime);
            childHolder.backgroundChild = convertView.findViewById(R.id.background_child);
            convertView.setTag(childHolder);
        } else {
            childHolder = (ChildHolder) convertView.getTag();
        }
        childHolder.tv_name.setText(mbData.getName());
        childHolder.tv_worktime.setText(mbData.getManhour());
        childHolder.tv_overtime.setText(mbData.getOvertime());
        childHolder.backgroundChild.setVisibility(childPosition == (messageBillData.get(groupPosition).getList().size() - 1) ? View.VISIBLE : View.GONE);
        return convertView;
    }

    @Override
    public boolean isChildSelectable(int groupPosition, int childPosition) {
        return false;
    }


    class GroupHolder {
        /* 日期 */
        TextView tvDate;
        /* 顶部线条 */
        View topLine;
    }

    class ChildHolder {
        TextView tv_name;
        TextView tv_worktime;
        TextView tv_overtime;
        View backgroundChild;
    }

    public List<MessageBillData> getMessageBillData() {
        return messageBillData;
    }

    public void setMessageBillData(List<MessageBillData> messageBillData) {
        this.messageBillData = messageBillData;
    }


    public void getCalculateSize() {
        if (messageBillData != null && messageBillData.size() > 0) {
            int size = 0;
            for (MessageBillData bean : messageBillData) {
                size += bean.getList().size();
            }
            this.size = size + messageBillData.size();
        }
    }

    public int getSize() {
        return size;
    }

    public void setSize(int size) {
        this.size = size;
    }
}
