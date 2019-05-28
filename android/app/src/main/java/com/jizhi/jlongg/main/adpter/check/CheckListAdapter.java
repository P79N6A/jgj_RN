package com.jizhi.jlongg.main.adpter.check;

import android.annotation.TargetApi;
import android.app.Activity;
import android.os.Build;
import android.support.v4.content.ContextCompat;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AbsListView;
import android.widget.BaseExpandableListAdapter;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.CheckContent;
import com.jizhi.jlongg.main.bean.CheckPoint;

import java.util.ArrayList;

/**
 * 功能:检查项适配器
 * 时间:2017年11月22日15:02:05
 * 作者:xuj
 */
public class CheckListAdapter extends BaseExpandableListAdapter {

    /**
     * 检查项数据
     */
    private ArrayList<CheckContent> list;
    /**
     * xml解析器
     */
    private LayoutInflater inflater;
    /**
     * activity
     */
    private Activity activity;
    /**
     * true 表示正在编辑
     */
    private boolean isEditor;
    /**
     * 移除检查内容回调
     */
    private RemoveCheckContentListener listener;
    /**
     * 未展开选项时 显示的条数
     */
    private int unExpandShowItemSize = 3;
    /**
     * 默认数据页的高度
     */
    private int listViewHeadHeight;


    private final int SHOW_CHECK_POINT = 0; //显示检查点
    private final int SHOW_EXPAND_POINT = 1; //展示更多

    private final int SHOW_EMPTY_VIEW = 0; //展示无数据的页
    private final int SHOW_NORMAL_DATA = 1; //展示正常的数据


    public CheckListAdapter(Activity activity, ArrayList<CheckContent> list, boolean isEditor, RemoveCheckContentListener listener) {
        inflater = LayoutInflater.from(activity);
        this.listener = listener;
        this.activity = activity;
        this.isEditor = isEditor;
        this.list = list;
    }


    @Override
    public int getChildType(int groupPosition, int childPosition) {
        CheckContent checkContent = getGroup(groupPosition);
        if (checkContent.getDot_list().size() > unExpandShowItemSize) { //当数据大于三条时展示的效果
            if (checkContent.is_expand()) { //展开了全部
                return checkContent.getDot_list().size() == childPosition ? SHOW_EXPAND_POINT : SHOW_CHECK_POINT;
            } else { //未展开全部
                return childPosition == unExpandShowItemSize ? SHOW_EXPAND_POINT : SHOW_CHECK_POINT;
            }
        } else {
            return SHOW_CHECK_POINT;
        }
    }

    @Override
    public int getChildTypeCount() {
        return 2;
    }

    @Override
    public int getGroupTypeCount() {
        return 2;
    }

    @Override
    public int getGroupType(int groupPosition) {
        return list == null || list.size() == 0 ? SHOW_EMPTY_VIEW : SHOW_NORMAL_DATA;
    }

    @Override
    public int getGroupCount() {
        if (getGroupType(0) == SHOW_EMPTY_VIEW) {
            return 1;
        }
        return list.size();
    }

    @Override
    public int getChildrenCount(int groupPosition) {
        if (getGroupType(groupPosition) == SHOW_EMPTY_VIEW) {
            return 0;
        }
        CheckContent checkContent = getGroup(groupPosition);
        if (checkContent.getDot_list() != null && checkContent.getDot_list().size() > unExpandShowItemSize) { //当数据大于三条时展示的效果
            if (checkContent.is_expand()) { //展开了全部
                return checkContent.getDot_list().size() + 1;
            } else { //未展开全部
                return unExpandShowItemSize + 1;
            }
        } else {
            return checkContent.getDot_list().size();
        }
    }

    @Override
    public CheckContent getGroup(int groupPosition) {
        return list.get(groupPosition);
    }

    @Override
    public CheckPoint getChild(int groupPosition, int childPosition) {
        return list.get(groupPosition).getDot_list().get(childPosition);
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
    public View getGroupView(final int groupPosition, boolean isExpanded, View convertView, ViewGroup parent) {  //创建组Group
        GroupHolder holder = null;
        int groupType = getGroupType(groupPosition);
        if (groupType == SHOW_EMPTY_VIEW) {
            convertView = inflater.inflate(R.layout.default_check, parent, false);
            if (listViewHeadHeight != 0) {
                TextView defaultDesc = (TextView) convertView.findViewById(R.id.defaultDesc);
                defaultDesc.setText(R.string.no_check_content);
                AbsListView.LayoutParams params = (AbsListView.LayoutParams) defaultDesc.getLayoutParams();
                params.height = parent.getHeight() - listViewHeadHeight;
                defaultDesc.setLayoutParams(params);
            }
            return convertView;
        }
        if (convertView == null) {
            convertView = inflater.inflate(R.layout.item_check_content_or_check_point, parent, false);
            holder = new GroupHolder(convertView);
            convertView.setTag(holder);
        } else {
            holder = (GroupHolder) convertView.getTag();
        }
        holder.deleteCheckContentIcon.setVisibility(isEditor ? View.VISIBLE : View.INVISIBLE);
        holder.deleteIconLine.setVisibility(isEditor ? View.VISIBLE : View.GONE);
        holder.checkContent.setText(list.get(groupPosition).getContent_name());
        holder.deleteCheckContentIcon.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                list.remove(groupPosition);
                notifyDataSetChanged();
                if (listener != null && getGroupCount() == 0) {
                    listener.isRemoveAll();
                }
            }
        });
        return convertView;
    }

    @Override
    public View getChildView(final int groupPosition, final int childPosition, boolean isLastChild, View convertView, ViewGroup parent) { //创建子group
        ChildHolder holder = null;
        int childType = getChildType(groupPosition, childPosition);
        if (convertView == null) {
            switch (childType) {
                case SHOW_CHECK_POINT:
                    convertView = inflater.inflate(R.layout.item_check_content_or_check_point, parent, false);
                    break;
                case SHOW_EXPAND_POINT:
                    convertView = inflater.inflate(R.layout.item_check_content_expand, parent, false);
                    break;
            }
            holder = new ChildHolder(convertView, childType);
            convertView.setTag(holder);
        } else {
            holder = (ChildHolder) convertView.getTag();
        }
        if (childType == SHOW_CHECK_POINT) {
            bindChildData(holder, groupPosition, childPosition);
        } else {
            bindExpandData(holder, groupPosition, convertView);
        }
        return convertView;
    }

    /**
     * 绑定子集合数据
     *
     * @param holder
     * @param groupPosition 父ID
     * @param childPosition 子ID
     */
    public void bindChildData(final ChildHolder holder, final int groupPosition, final int childPosition) {
        CheckPoint checkPoint = getChild(groupPosition, childPosition);
        LinearLayout.LayoutParams params = (LinearLayout.LayoutParams) holder.checkContent.getLayoutParams();
        int peddingTopBottom = (int) activity.getResources().getDimension(R.dimen.check_padding);
        params.topMargin = peddingTopBottom;
        params.bottomMargin = peddingTopBottom;
        holder.checkContent.setLayoutParams(params);
        holder.checkContent.setText(checkPoint.getDot_name());
        holder.divierBackground.setVisibility(childPosition + 1 == getChildrenCount(groupPosition) ? View.VISIBLE : View.GONE);
        holder.divierLine.setVisibility(childPosition + 1 == getChildrenCount(groupPosition) ? View.GONE : View.VISIBLE);
    }

    /**
     * 绑定展开选项状态
     *
     * @param holder
     * @param groupPosition 父ID
     */
    public void bindExpandData(final ChildHolder holder, final int groupPosition, View convertView) {
        final CheckContent checkContent = getGroup(groupPosition);
        holder.expandStateIcon.setImageResource(checkContent.is_expand() ? R.drawable.expand_check_content : R.drawable.collapse_check_content);
        holder.expandStateText.setText(checkContent.is_expand() ? "收起全部" : "展开全部");
        convertView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                checkContent.setIs_expand(!checkContent.is_expand());
                notifyDataSetChanged();
            }
        });
    }

    class GroupHolder {
        /**
         * 红色提示图标
         */
        private ImageView redTipsIcon;
        /**
         * 检查内容
         */
        private TextView checkContent;
        /**
         * 移除图标
         */
        private View deleteCheckContentIcon;
        /**
         * 移除图标 线
         */
        private View deleteIconLine;

        public GroupHolder(View convertView) {
            redTipsIcon = (ImageView) convertView.findViewById(R.id.redTipsIcon);
            checkContent = (TextView) convertView.findViewById(R.id.checkContent);
            deleteCheckContentIcon = convertView.findViewById(R.id.deleteCheckContentIcon);
            deleteIconLine = convertView.findViewById(R.id.deleteIconLine);

            checkContent.setTextColor(ContextCompat.getColor(activity, R.color.color_333333));
            checkContent.getPaint().setFakeBoldText(true); //设置字体加粗

            redTipsIcon.setVisibility(View.VISIBLE);
        }
    }

    class ChildHolder {
        /**
         * 检查内容
         */
        private TextView checkContent;
        /**
         * 分割线
         */
        private View divierLine;
        /**
         * 分割行
         */
        private View divierBackground;

        /**
         * 展开、关闭状态图标
         */
        private ImageView expandStateIcon;
        /**
         * 展开、关闭状态文本
         */
        private TextView expandStateText;


        public ChildHolder(View convertView, int childType) {
            if (childType == SHOW_CHECK_POINT) { //显示检查点
                checkContent = (TextView) convertView.findViewById(R.id.checkContent);
                View deleteCheckContentIcon = convertView.findViewById(R.id.deleteCheckContentIcon);
                View deleteIconLine = convertView.findViewById(R.id.deleteIconLine);
                View redTipsIcon = convertView.findViewById(R.id.redTipsIcon);

                divierLine = convertView.findViewById(R.id.divierLine);
                divierBackground = convertView.findViewById(R.id.divierBackground);
                redTipsIcon.setVisibility(View.INVISIBLE);
                deleteCheckContentIcon.setVisibility(View.INVISIBLE);
                deleteIconLine.setVisibility(View.GONE);
            } else { //展示更多的操作
                expandStateText = (TextView) convertView.findViewById(R.id.expandStateText);
                expandStateIcon = (ImageView) convertView.findViewById(R.id.expandStateIcon);
            }
        }
    }

    public ArrayList<CheckContent> getList() {
        return list;
    }

    public void setList(ArrayList<CheckContent> list) {
        this.list = list;
    }


    public void updateList(ArrayList<CheckContent> list) {
        this.list = list;
        notifyDataSetChanged();
    }

    public interface RemoveCheckContentListener {
        //是否已经移除了全部的检查内容
        public void isRemoveAll();
    }

    public int getListViewHeadHeight() {
        return listViewHeadHeight;
    }

    public void setListViewHeadHeight(int listViewHeadHeight) {
        this.listViewHeadHeight = listViewHeadHeight;
    }


    public boolean isEmptyData() {
        return getGroupType(0) == SHOW_EMPTY_VIEW ? true : false;
    }
}
