package com.jizhi.jlongg.main.adpter;

import android.content.Context;
import android.text.Html;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseExpandableListAdapter;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.Sign;

import java.util.List;


/**
 * huchangsheng：Administrator on 2016/2/24 15:42
 */
public class MessageSignTodayAdapter extends BaseExpandableListAdapter {
    private List<Sign> listMSg;
    private LayoutInflater inflater;
    private Context context;
    private int is_creater;
    private SignChildClickLisener SignChildClickLisener;

    private int size;

    public MessageSignTodayAdapter(Context context, List<Sign> messageBillData, int is_creater, SignChildClickLisener SignChildClickLisener) {
        this.context = context;
        this.listMSg = messageBillData;
        this.is_creater = is_creater;
        this.SignChildClickLisener = SignChildClickLisener;
        inflater = LayoutInflater.from(context);
//        if (messageBillData != null && messageBillData.size() > 0) {
//            getCalculateSize();
//        }
    }

//    public void addList(List<Sign> messageBillData) {
//        this.listMSg.addAll(messageBillData);
//        notifyDataSetChanged();
//    }

//    public void update(List<Sign> messageBillData) {
//        this.listMSg = messageBillData;
//        getCalculateSize();
//        notifyDataSetChanged();
//    }

    @Override
    public int getGroupCount() {
        return listMSg == null ? 0 : listMSg.size();
    }

    @Override
    public int getChildrenCount(int groupPosition) {
        return listMSg.get(groupPosition).getSign_list().size();
    }

    @Override
    public Object getGroup(int groupPosition) {
        return listMSg.get(groupPosition);
    }

    @Override
    public Object getChild(int groupPosition, int childPosition) {

        return listMSg.get(groupPosition).getSign_list().get(childPosition);
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
        final Sign mbData = listMSg.get(groupPosition);
        if (convertView == null) {
            holder = new GroupHolder();
            convertView = inflater.inflate(R.layout.item_message_sign_group, null);
            holder.tv_date = (TextView) convertView.findViewById(R.id.tv_date);
            holder.tv_count = (TextView) convertView.findViewById(R.id.tv_count);
            convertView.setTag(holder);
        } else {
            holder = (GroupHolder) convertView.getTag();
        }
        if (mbData.getIs_today() == 1) {
            holder.tv_date.setText("今日  " + mbData.getSign_date());
        } else {
            holder.tv_date.setText(mbData.getSign_date());
        }
//        if (is_creater == 1) {
//            holder.tv_count.setText(Html.fromHtml("今日签到<font color=red>" + mbData.getSign_num() + "</font>人"));
//        } else {
        holder.tv_count.setText(Html.fromHtml("签到<font color=red>" + mbData.getSign_num() + "</font>次"));
//        }

        return convertView;
    }

    @Override
    public View getChildView(final int groupPosition, final int childPosition, boolean isLastChild, View convertView, ViewGroup parent) {
        final ChildHolder childHolder;
        final Sign mbData = listMSg.get(groupPosition).getSign_list().get(childPosition);
        if (convertView == null) {
            childHolder = new ChildHolder();
            convertView = inflater.inflate(R.layout.item_message_sign_child_member, null);
//            childHolder.img_head = (CircleImageView) convertView.findViewById(R.id.img_head);
//            childHolder.tv_name = (TextView) convertView.findViewById(R.id.tv_name);
            childHolder.tv_time = (TextView) convertView.findViewById(R.id.tv_time);
            childHolder.tv_address = (TextView) convertView.findViewById(R.id.tv_address);
            convertView.setTag(childHolder);
        } else {
            childHolder = (ChildHolder) convertView.getTag();
        }
//        childHolder.tv_name.setText(mbData.getReal_name());
//        Picasso.with(context).load(NetWorkRequest.IP_ADDRESS + mbData.getHead_pic()).placeholder(R.drawable.friend_head).error(R.drawable.friend_head).into(childHolder.img_head);
        childHolder.tv_address.setText(mbData.getSign_addr());
        childHolder.tv_time.setText(mbData.getSign_time());
        convertView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                SignChildClickLisener.SignChildClick(groupPosition, childPosition);
            }
        });
        return convertView;
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
        TextView tv_name;
        TextView tv_time;
        TextView tv_address;
    }

    public interface SignChildClickLisener {
        void SignChildClick(int groupPosition, int childPosition);
    }

    public List<Sign> getListMSg() {
        return listMSg;
    }

    public void setListMSg(List<Sign> listMSg) {
        this.listMSg = listMSg;
    }

//    public void getCalculateSize() {
//        if (listMSg != null && listMSg.size() > 0) {
//            int size = 0;
//            for (Sign bean : listMSg) {
//                size += bean.getSign_list().size();
//            }
//            this.size = size + listMSg.size();
//        }
//    }

    public int getSize() {
        return size;
    }

    public void setSize(int size) {
        this.size = size;
    }
}
