package com.jizhi.jlongg.main.adpter;

import android.annotation.TargetApi;
import android.content.Context;
import android.os.Build;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseExpandableListAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.Project;
import com.jizhi.jlongg.main.bean.SourceMemberProInfo;

import java.util.List;

/**
 * 功能:创建项目组 添加成员
 * 时间:2016年8月23日 17:02:33
 * 作者:xuj
 */
public class UnDealSourceAdapter extends BaseExpandableListAdapter {
    /**
     * 列表数据
     */
    private List<SourceMemberProInfo> groupList;
    /**
     * 上下文
     */
    private Context context;
    /**
     * 回调函数
     */
    private SelecteSourceProjectListener selecteSourceProjectListener;

    public void updateList(List<SourceMemberProInfo> groupList) {
        this.groupList = groupList;
        notifyDataSetChanged();
    }

    public UnDealSourceAdapter(Context context, List<SourceMemberProInfo> groupList, SelecteSourceProjectListener selecteSourceProjectListener) {
        this.context = context;
        this.groupList = groupList;
        this.selecteSourceProjectListener = selecteSourceProjectListener;
    }


    @Override
    public int getGroupCount() {
        if (groupList == null) {
            return 0;
        }
        return groupList.size();
    }

    @Override
    public int getChildrenCount(int groupPosition) {
        return getGroup(groupPosition).getSync_unsource().getList().size();
    }

    @Override
    public SourceMemberProInfo getGroup(int groupPosition) {
        return groupList.get(groupPosition);
    }

    @Override
    public Project getChild(int groupPosition, int childPosition) {
        return groupList.get(groupPosition).getSync_unsource().getList().get(childPosition);
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
        return true;
    }

    @Override
    public boolean isChildSelectable(int groupPosition, int childPosition) {
        return true;
    }

    @Override
    public boolean areAllItemsEnabled() {
        return false;
    }

    @Override
    public boolean isEmpty() {
        return false;
    }

    @Override
    public long getCombinedChildId(long groupId, long childId) {
        return childId;
    }

    @Override
    public long getCombinedGroupId(long groupId) {
        return groupId;
    }


    @TargetApi(Build.VERSION_CODES.JELLY_BEAN)
    @Override
    public View getGroupView(int groupPosition, boolean isExpanded, View convertView, ViewGroup parent) {  //创建组Group
        GroupHolder holder = null;
        if (convertView == null) {
            convertView = LayoutInflater.from(context).inflate(R.layout.un_deal_source_title, parent, false);
            holder = new GroupHolder(convertView);
            convertView.setTag(holder);
        } else {
            holder = (GroupHolder) convertView.getTag();
        }
        SourceMemberProInfo bean = getGroup(groupPosition);
        holder.usernamePhone.setText(bean.getReal_name() + "(" + bean.getTelephone() + ")");
        return convertView;
    }

    @Override
    public View getChildView(final int groupPosition, final int childPosition, boolean isLastChild, View convertView, ViewGroup parent) { //创建子group
        ChildHolder holder = null;
        if (convertView == null) {
            convertView = LayoutInflater.from(context).inflate(R.layout.item_synch_add_pro, parent, false);
            holder = new ChildHolder(convertView);
            convertView.setTag(holder);
        } else {
            holder = (ChildHolder) convertView.getTag();
        }
        bindChildData(convertView, holder, groupPosition, childPosition);
        return convertView;
    }

    /**
     * 绑定子集合数据
     *
     * @param holder
     * @param groupPosition 父ID
     * @param childPosition 子ID
     */
    public void bindChildData(final View convertView, final ChildHolder holder, final int groupPosition, final int childPosition) {
        final Project bean = getChild(groupPosition, childPosition);
        int size = groupList.get(groupPosition).getSync_unsource().getList().size();
        holder.teamName.setText(bean.getPro_name());
        holder.diverLine.setVisibility(childPosition == size - 1 ? View.GONE : View.VISIBLE);
        holder.selectImage.setImageResource(!bean.isSelected() ? R.drawable.checkbox_normal : R.drawable.checkbox_pressed);
        convertView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                bean.setIsSelected(!bean.isSelected());
                notifyDataSetChanged();
                if (selecteSourceProjectListener != null) {
                    selecteSourceProjectListener.selecte(bean);
                }
            }
        });

    }


    class GroupHolder {
        /**
         * 人物名称和电话号码
         */
        private TextView usernamePhone;

        public GroupHolder(View view) {
            usernamePhone = (TextView) view.findViewById(R.id.username_phone);
        }
    }

    class ChildHolder {
        /**
         * 项目组名称
         */
        TextView teamName;
        /**
         * 选中状态
         */
        ImageView selectImage;
        /**
         * 底部线条
         */
        View diverLine;

        public ChildHolder(View convertView) {
            selectImage = (ImageView) convertView.findViewById(R.id.cb_del);
            teamName = (TextView) convertView.findViewById(R.id.teamName);
            diverLine = convertView.findViewById(R.id.line);
        }
    }

    public List<SourceMemberProInfo> getGroupList() {
        return groupList;
    }

    public void setGroupList(List<SourceMemberProInfo> groupList) {
        this.groupList = groupList;
    }


    public interface SelecteSourceProjectListener {
        public void selecte(Project project);
    }
}
