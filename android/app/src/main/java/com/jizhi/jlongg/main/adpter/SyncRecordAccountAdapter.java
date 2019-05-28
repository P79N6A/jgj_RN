package com.jizhi.jlongg.main.adpter;

import android.content.Context;
import android.graphics.Color;
import android.text.SpannableStringBuilder;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseExpandableListAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.SyncDetailInfo;
import com.jizhi.jlongg.main.bean.SyncInfo;

import java.util.List;


/**
 * 功能:新增同步适配器
 * 时间:2018年4月19日10:33:47
 * 作者:xuj
 */
public class SyncRecordAccountAdapter extends BaseExpandableListAdapter {
    /**
     * 列表数据
     */
    private List<SyncInfo> list;
    /**
     * xml解析器
     */
    private LayoutInflater inflater;
    /**
     * 取消同步回调
     */
    private CancelSynListener listener;


    public SyncRecordAccountAdapter(Context context, List<SyncInfo> list, CancelSynListener listener) {
        this.list = list;
        inflater = LayoutInflater.from(context);
        this.listener = listener;
    }

    public void updateList(List<SyncInfo> list) {
        this.list = list;
        notifyDataSetChanged();
    }

    public List<SyncInfo> getList() {
        return list;
    }

    public void setList(List<SyncInfo> list) {
        this.list = list;
    }

    @Override
    public int getGroupCount() {
        return list == null ? 0 : list.size();
    }

    @Override
    public int getChildrenCount(int groupPosition) {
        return list.get(groupPosition).getSynced_list().size();
    }


    @Override
    public SyncInfo getGroup(int groupPosition) {
        return list.get(groupPosition);
    }

    @Override
    public SyncDetailInfo getChild(int groupPosition, int childPosition) {
        return list.get(groupPosition).getSynced_list().get(childPosition);
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
            convertView = inflater.inflate(R.layout.sync_record_account_title, null, false);
            holder = new GroupHolder(convertView);
            convertView.setTag(holder);
        } else {
            holder = (GroupHolder) convertView.getTag();
        }
        SyncInfo syncInfo = getGroup(groupPosition);
        if (syncInfo.getUser_info() != null) {
            holder.syncPerson.setText("向 " + syncInfo.getUser_info().getReal_name() + " 同步的记工");
        }
        holder.firstTips.setVisibility(groupPosition == 0 ? View.VISIBLE : View.GONE);
        holder.syncCount.setText(syncInfo.getSynced_num() + "");
        holder.itemDiverLine.setVisibility(isExpanded ? View.VISIBLE : View.GONE);
        holder.itemDiverBackground.setVisibility(isExpanded ? View.GONE : View.VISIBLE);
        holder.menuIconState.setImageResource(isExpanded ? R.drawable.up_arrows : R.drawable.gray_down);
        return convertView;
    }

    @Override
    public View getChildView(final int groupPosition, final int childPosition, boolean isLastChild, View convertView, final ViewGroup parent) {
        final ChildHolder childHolder;
        if (convertView == null) {
            convertView = inflater.inflate(R.layout.sync_record_account_value, null, false);
            childHolder = new ChildHolder(convertView);
            convertView.setTag(childHolder);
        } else {
            childHolder = (ChildHolder) convertView.getTag();
        }
        final SyncDetailInfo syncDetailInfo = getChild(groupPosition, childPosition);
        SpannableStringBuilder spannableStringBuilder = Utils.setSelectedFontChangeColor(syncDetailInfo.getPro_name() + "（" + syncDetailInfo.getSync_type() + "）",
                "（" + syncDetailInfo.getSync_type() + "）", Color.parseColor("#999999"),false);
        childHolder.syncFrom.setText(spannableStringBuilder);
        childHolder.itemDiverLine.setVisibility(childPosition == getChildrenCount(groupPosition) - 1 ? View.GONE : View.VISIBLE);
        childHolder.itemDiverBackground.setVisibility(childPosition == getChildrenCount(groupPosition) - 1 ? View.VISIBLE : View.GONE);
        childHolder.cancelSyncBtn.setOnClickListener(new View.OnClickListener() { //取消同步
            @Override
            public void onClick(View v) {
                if (listener != null) {
                    listener.cancelSync(syncDetailInfo.getSync_id() + "");
                }
            }
        });
        return convertView;
    }


    @Override
    public boolean isChildSelectable(int groupPosition, int childPosition) {
        return false;
    }

    class GroupHolder {
        /**
         * 同步对象状态
         */
        TextView syncPerson;
        /**
         * 同步数量
         */
        TextView syncCount;
        /**
         * 菜单按钮打开关闭状态
         */
        ImageView menuIconState;
        /**
         * 分割线背景色
         */
        View itemDiverBackground;
        /**
         * 首条item显示的提示
         */
        View firstTips;
        /**
         * 分割线
         */
        View itemDiverLine;

        public GroupHolder(View convertView) {
            firstTips = convertView.findViewById(R.id.firstTips);
            syncPerson = (TextView) convertView.findViewById(R.id.syncPerson);
            syncCount = (TextView) convertView.findViewById(R.id.syncCount);
            menuIconState = (ImageView) convertView.findViewById(R.id.menuIconState);
            itemDiverLine = convertView.findViewById(R.id.itemDiverLine);
            itemDiverBackground = convertView.findViewById(R.id.itemDiverBackground);
        }
    }

    class ChildHolder {

        /**
         * 取消同步按钮
         */
        TextView cancelSyncBtn;
        /**
         * 同步对象来自哪里
         */
        TextView syncFrom;
        /**
         * 分割线
         */
        View itemDiverLine;
        /**
         * 分割线背景色
         */
        View itemDiverBackground;


        public ChildHolder(View convertView) {
            syncFrom = (TextView) convertView.findViewById(R.id.syncFrom);
            cancelSyncBtn = (TextView) convertView.findViewById(R.id.cancelSyncBtn);
            itemDiverLine = convertView.findViewById(R.id.itemDiverLine);
            itemDiverBackground = convertView.findViewById(R.id.itemDiverBackground);

        }
    }

    /**
     * 取消同步
     */
    public interface CancelSynListener {
        public void cancelSync(String syncId);
    }


}


