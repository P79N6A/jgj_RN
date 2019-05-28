package com.jizhi.jlongg.main.adpter;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.ChatUserInfoActivity;
import com.jizhi.jlongg.main.activity.SelecteActorActivity;
import com.jizhi.jlongg.main.activity.SelectePriniActivity;
import com.jizhi.jlongg.main.bean.GroupMemberInfo;
import com.jizhi.jlongg.main.dialog.DialogUnRegister;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jongg.widget.RoundeImageHashCodeTextLayout;

import java.util.List;

public class TaskMemberAdapters extends BaseAdapter {
    private Context mContext;
    private LayoutInflater mInflater;
    private List<GroupMemberInfo> selectList;
    private String group_id;
    private boolean isMenber;
    private boolean isClose;

    public TaskMemberAdapters(Context context, List<GroupMemberInfo> selectList, String group_id, boolean isMenber, boolean isClose) {
        mContext = context;
        mInflater = LayoutInflater.from(context);
        this.selectList = selectList;
        this.group_id = group_id;
        this.isMenber = isMenber;
        this.isClose = isClose;
    }

    @Override
    public int getCount() {
        return selectList.size();
    }

    @Override
    public Object getItem(int position) {
        return selectList.get(position);
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    @Override
    public View getView(final int position, View convertView, ViewGroup parent) {
        TitleHolder holder;
        if (convertView == null) {
            holder = new TitleHolder();
            convertView = mInflater.inflate(R.layout.item_notice_detail_head, null);
            holder.img_square = convertView.findViewById(R.id.img_square);
            convertView.setTag(holder);
        } else {
            holder = (TitleHolder) convertView.getTag();
        }
        if (TextUtils.isEmpty(selectList.get(position).getHead_pic()) && !isClose) {
            if (isMenber) {
                holder.img_square.setBackgroundResource(R.drawable.icon_task_change);
            } else {
                holder.img_square.setBackgroundResource(R.drawable.icon_add_task);
            }
        } else {
            holder.img_square.setView(selectList.get(position).getHead_pic(), selectList.get(position).getReal_name(), 0);
        }
        holder.img_square.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (isClose) {
                    return;
                }
                if (TextUtils.isEmpty(selectList.get(position).getHead_pic())) {
                    if (isMenber) {
                        SelectePriniActivity.actionStart((Activity) mContext, selectList.get(0).getUid(), group_id);
                    } else {
                        SelecteActorActivity.actionStart((Activity) mContext, getActorUids(), mContext.getString(R.string.selected_actor), true);
                    }
                    return;
                }
                if (selectList.get(position).getIs_active() == 1) {
                    Intent intent = new Intent(mContext, ChatUserInfoActivity.class);
                    intent.putExtra(Constance.UID, selectList.get(position).getUid());
                    ((Activity) mContext).startActivityForResult(intent, Constance.REQUESTCODE_SINGLECHAT);
                } else {
                    GroupMemberInfo bean = new GroupMemberInfo();
                    bean.setUid(selectList.get(position).getUid());
                    bean.setReal_name(selectList.get(position).getReal_name());
                    bean.setTelephone(selectList.get(position).getTelephone());
                    bean.setIs_active(selectList.get(position).getIs_active());
                    new DialogUnRegister((Activity) mContext, null, null, bean).show();
                }

            }
        });
        return convertView;
    }

    /**
     * 当ListView数据发生变化时,调用此方法来更新ListView
     *
     * @param list
     */
    public void updateListView(List<GroupMemberInfo> list) {
        this.selectList = list;
        notifyDataSetChanged();
    }


    public class TitleHolder {
        public RoundeImageHashCodeTextLayout img_square;
    }

    /**
     * 获取参与者id
     *
     * @return
     */
    private String getActorUids() {
        StringBuilder builder = new StringBuilder();
        int i = 0;
        for (GroupMemberInfo groupMemberInfo : selectList) {
            if (!TextUtils.isEmpty(groupMemberInfo.getUid())) {
                builder.append(i == 0 ? groupMemberInfo.getUid() : "," + groupMemberInfo.getUid());
                i += 1;
            }

        }
        return builder.toString();
    }
}
