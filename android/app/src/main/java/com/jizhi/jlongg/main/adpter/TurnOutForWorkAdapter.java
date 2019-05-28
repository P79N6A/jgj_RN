package com.jizhi.jlongg.main.adpter;

import android.content.Context;
import android.support.v4.content.ContextCompat;
import android.text.Html;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseExpandableListAdapter;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.AccountDateList;
import com.jizhi.jlongg.main.bean.PayRollList;
import com.jizhi.jlongg.main.util.AccountUtil;

import java.util.List;


/**
 * 功能:出勤公式适配器
 * 时间:2018年1月10日16:45:44
 * 作者:xuj
 */
public class TurnOutForWorkAdapter extends BaseExpandableListAdapter {
    /**
     * 列表数据
     */
    private List<AccountDateList> list;
    /**
     * xml解析器
     */
    private LayoutInflater inflater;
    /**
     * 上下文
     */
    private Context context;


    public TurnOutForWorkAdapter(Context context, List<AccountDateList> list) {
        super();
        this.list = list;
        this.context = context;
        inflater = LayoutInflater.from(context);
    }


    @Override
    public int getGroupCount() {
        if (list == null || list.size() == 0) {
            return 0;
        }
        return list.size();
    }

    @Override
    public int getChildrenCount(int groupPosition) {
        List<PayRollList> lists = list.get(groupPosition).getList();
        if (lists == null || lists.size() == 0) {
            return 0;
        }
        return lists.size();
    }

    @Override
    public AccountDateList getGroup(int groupPosition) {
        return list.get(groupPosition);
    }

    @Override
    public PayRollList getChild(int groupPosition, int childPosition) {
        return list.get(groupPosition).getList().get(childPosition);
    }

    @Override
    public long getGroupId(int groupPosition) {
        return 0;
    }

    @Override
    public long getChildId(int groupPosition, int childPosition) {
        return 0;
    }

    @Override
    public boolean hasStableIds() {
        return false;
    }

    @Override
    public View getGroupView(int groupPosition, boolean isExpanded, View convertView, ViewGroup parent) {
        final GroupHolder holder;
        if (convertView == null) {
            convertView = inflater.inflate(R.layout.turn_out_for_work_title, null, false);
            holder = new GroupHolder(convertView);
            convertView.setTag(holder);
        } else {
            holder = (GroupHolder) convertView.getTag();
        }
        AccountDateList bean = getGroup(groupPosition);
        holder.date.setText(bean.getDate() + "(" + bean.getDate_turn() + ")");
        if (bean.getList() != null && bean.getList().size() > 0) {
            holder.accountCount.setText(Html.fromHtml("<font color='#999999'>当日记工人数：&nbsp;</font><font color='#000000'>" +
                    getGroup(groupPosition).getMem_cnt() + "</font>"));
        }
        return convertView;
    }

    @Override
    public View getChildView(int groupPosition, int childPosition, boolean isLastChild, View convertView, ViewGroup parent) {
        final ChildViewHolder holder;
        if (convertView == null) {
            convertView = inflater.inflate(R.layout.turn_out_for_work_item, null, false);
            holder = new ChildViewHolder(convertView);
            convertView.setTag(holder);
        } else {
            holder = (ChildViewHolder) convertView.getTag();
        }
        bindChildData(holder, groupPosition, childPosition, convertView);
        return convertView;
    }

    private void bindChildData(final ChildViewHolder holder, final int groupPosition, final int childPosition, View convertView) {
        final PayRollList payRollList = getChild(groupPosition, childPosition);
//        String manhourValue = current_work_show_flag == AccountUtil.WORK_OF_HOUR ?
//                RecordUtils.getNormalWorkString(payRollList.getManhour(), false, current_work_show_flag, false) : RecordUtils.getNormalWorkUtil(payRollList.getWorking_hours(), false, false);
//        String overTimeValue = current_work_show_flag == AccountUtil.WORK_OF_HOUR ?
//                RecordUtils.getOverTimeWorkString(payRollList.getOvertime(), false, current_work_show_flag, false) : RecordUtils.getOverTimeWorkUtil(payRollList.getOvertime_hours(), false, false);
        holder.name.setText(payRollList.getName());
        holder.manhour.setText(AccountUtil.getAccountShowTypeString(context, false, false, true, payRollList.getManhour(), payRollList.getWorking_hours()));
        holder.overtime.setText(AccountUtil.getAccountShowTypeString(context, false, false, false, payRollList.getOvertime(), payRollList.getOvertime_hours()));
        String uid = UclientApplication.getUid(context.getApplicationContext());
        //如果是自己记的账  需要将颜色标注为红色 否则设置成黑色
        int textColor = !TextUtils.isEmpty(uid) && uid.equals(payRollList.getUid()) ? R.color.color_eb4e4e : R.color.color_333333;
        holder.name.setTextColor(ContextCompat.getColor(context, textColor));
        holder.manhour.setTextColor(ContextCompat.getColor(context, textColor));
        holder.overtime.setTextColor(ContextCompat.getColor(context, textColor));
        holder.itemDiver.setVisibility(groupPosition == getGroupCount() - 1 && childPosition == getChildrenCount(groupPosition) - 1 ? View.GONE : View.VISIBLE);
    }

    @Override
    public boolean isChildSelectable(int groupPosition, int childPosition) {
        return false;
    }


    class GroupHolder {

        /**
         * 日期
         */
        TextView date;
        /**
         * 记工笔数
         */
        TextView accountCount;


        public GroupHolder(View convertView) {
            date = (TextView) convertView.findViewById(R.id.date);
            accountCount = (TextView) convertView.findViewById(R.id.accountCount);
        }
    }

    class ChildViewHolder {
        /**
         * 记账人名称
         */
        TextView name;
        /**
         * 上班时长
         */
        TextView manhour;
        /**
         * 加班时长
         */
        TextView overtime;
        /**
         * 分割线
         */
        View itemDiver;


        public ChildViewHolder(View convertView) {
            name = (TextView) convertView.findViewById(R.id.name);
            manhour = (TextView) convertView.findViewById(R.id.manhour);
            overtime = (TextView) convertView.findViewById(R.id.overtime);
            itemDiver = convertView.findViewById(R.id.itemDiver);
        }
    }

    public void updateList(List<AccountDateList> list) {
        this.list = list;
        notifyDataSetChanged();
    }

    public List<AccountDateList> getList() {
        return list;
    }

    public void setList(List<AccountDateList> list) {
        this.list = list;
    }


    public void updateListView(List<AccountDateList> list) {
        this.list = list;
        notifyDataSetChanged();
    }

    public void addMoreList(List<AccountDateList> list) {
        this.list.addAll(list);
        notifyDataSetChanged();
    }

}
