package com.jizhi.jlongg.main.adpter;

import android.content.Context;
import android.support.v4.content.ContextCompat;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseExpandableListAdapter;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.hcs.uclient.utils.DensityUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.AccountDateList;
import com.jizhi.jlongg.main.bean.PayRollList;
import com.jizhi.jlongg.main.bean.WorkDetail;
import com.jizhi.jlongg.main.util.AccountUtil;
import com.jizhi.jlongg.main.util.NameUtil;

import java.util.List;


/**
 * 功能:无金额点工适配器
 * 时间:2018年1月8日17:21:42
 * 作者:xuj
 */
public class NoMoneyLittlerWorkExpandableAdapter extends BaseExpandableListAdapter {
    /**
     * 列表数据
     */
    private List<AccountDateList> list;
    /**
     * xml解析器
     */
    private LayoutInflater inflater;
    /**
     * context
     */
    private Context context;
    /***
     * 点击事件
     */
    private EveryDayAttendanceAdapter.EveryDayItemClickListener itemClicListener;


    public NoMoneyLittlerWorkExpandableAdapter(Context context, List<AccountDateList> list, EveryDayAttendanceAdapter.EveryDayItemClickListener listener) {
        super();
        this.list = list;
        this.context = context;
        inflater = LayoutInflater.from(context);
        itemClicListener = listener;
    }

    private void bindChildData(final ChildViewHolder holder, final int groupPosition, final int childPosition, View convertView) {
        final WorkDetail workDetail = getChild(groupPosition, childPosition);
        holder.proName.setText(workDetail.getProname()); //设置项目名称
        holder.recordWorkName.setText(NameUtil.setName(workDetail.getWorker_name())); //设置工人名称
        holder.foremanName.setText("班组长:" + NameUtil.setName(workDetail.getForeman_name())); //设置工头名称
        holder.workMoney.setText(workDetail.getAmounts()); //设置金额
        holder.driverLineTwo.setVisibility(childPosition == getChildrenCount(groupPosition) - 1 ? View.GONE : View.VISIBLE); //隐藏分割线
        holder.itemLayout.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (itemClicListener != null) {
                    itemClicListener.expandableItemClick(groupPosition, childPosition);
                }
            }
        });
        switch (workDetail.getAccounts_type()) {
            case AccountUtil.HOUR_WORKER: //点工
                holder.recordTips1.setText(AccountUtil.getAccountShowTypeString(context, true, false, true, workDetail.getManhour(), workDetail.getWorking_hours()));
                holder.recordTips2.setText(AccountUtil.getAccountShowTypeString(context, true, false, false, workDetail.getOvertime(), workDetail.getOvertime_hours()));
                holder.workMoney.setTextColor(ContextCompat.getColor(context, R.color.app_color));
                holder.recordTypeIcon.setVisibility(View.VISIBLE);
                holder.recordTypeIcon.setImageResource(R.drawable.hour_worker_flag);
                break;
            case AccountUtil.CONSTRACTOR: //包工
                holder.recordTypeIcon.setVisibility(View.INVISIBLE);
                holder.recordTips1.setText("包工");
                holder.recordTips2.setVisibility(View.GONE);
                holder.workMoney.setTextColor(ContextCompat.getColor(context, R.color.app_color));
                break;
            case AccountUtil.BORROWING: //借支
                holder.recordTypeIcon.setVisibility(View.INVISIBLE);
                holder.recordTips1.setText("借支");
                holder.recordTips2.setVisibility(View.GONE);
                holder.workMoney.setTextColor(ContextCompat.getColor(context, R.color.green));
                break;
            case AccountUtil.SALARY_BALANCE: //结算
                holder.recordTypeIcon.setVisibility(View.INVISIBLE);
                holder.recordTips1.setText("结算");
                holder.recordTips2.setVisibility(View.GONE);
                holder.workMoney.setTextColor(ContextCompat.getColor(context, R.color.green));
                break;
            case AccountUtil.CONSTRACTOR_CHECK: //包工记工天
                holder.recordTips1.setText(AccountUtil.getAccountShowTypeString(context, true, false, true, workDetail.getManhour(), workDetail.getWorking_hours()));
                holder.recordTips2.setText(AccountUtil.getAccountShowTypeString(context, true, false, false, workDetail.getOvertime(), workDetail.getOvertime_hours()));
                holder.workMoney.setTextColor(ContextCompat.getColor(context, R.color.app_color));
                holder.recordTypeIcon.setVisibility(View.VISIBLE);
                holder.recordTypeIcon.setImageResource(R.drawable.constar_flag);
                break;
        }
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
        List<PayRollList> lists = list.get(groupPosition).getDate_list();
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
    public WorkDetail getChild(int groupPosition, int childPosition) {
        return list.get(groupPosition).getDate_list().get(childPosition);
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
            convertView = inflater.inflate(R.layout.no_money_little_work_item, null, false);
            holder = new GroupHolder(convertView);
            convertView.setTag(holder);
        } else {
            holder = (GroupHolder) convertView.getTag();
        }
        holder.itemDiver.setVisibility(groupPosition == 0 ? View.GONE : View.VISIBLE);
        holder.date.setText(getGroup(groupPosition).getDate());
        return convertView;
    }

    @Override
    public View getChildView(int groupPosition, int childPosition, boolean isLastChild, View convertView, ViewGroup parent) {
        final ChildViewHolder holder;
        if (convertView == null) {
            convertView = inflater.inflate(R.layout.no_money_item, null, false);
            holder = new ChildViewHolder(convertView);
            convertView.setTag(holder);
        } else {
            holder = (ChildViewHolder) convertView.getTag();
        }
        bindChildData(holder, groupPosition, childPosition, convertView);
        return convertView;
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
         * 分割线
         */
        View itemDiver;

        public GroupHolder(View convertView) {
            date = (TextView) convertView.findViewById(R.id.date);
            itemDiver = convertView.findViewById(R.id.itemDiver);
        }
    }

    class ChildViewHolder {
        /**
         * 记账人名称
         */
        TextView recordWorkName;
        /**
         * 记账提示1
         */
        TextView recordTips1;
        /**
         * 记账提示2
         */
        TextView recordTips2;
        /**
         * 工头名称
         */
        TextView foremanName;
        /**
         * 记账金额
         */
        TextView workMoney;
        /**
         * 项目名称
         */
        TextView proName;
        /**
         * item标签
         */
        View itemLayout;
        /**
         * 分割线
         */
        View driverLineTwo;
        /**
         * 记账类型图标
         */
        ImageView recordTypeIcon;


        public ChildViewHolder(View convertView) {
            recordTypeIcon = (ImageView) convertView.findViewById(R.id.recordTypeIcon);
            itemLayout = convertView.findViewById(R.id.itemLayout);
            proName = (TextView) convertView.findViewById(R.id.proName);
            recordWorkName = (TextView) convertView.findViewById(R.id.recordWorkName);
            foremanName = (TextView) convertView.findViewById(R.id.foremanName);
            recordTips1 = (TextView) convertView.findViewById(R.id.recordTips1);
            recordTips2 = (TextView) convertView.findViewById(R.id.recordTips2);
            workMoney = (TextView) convertView.findViewById(R.id.workMoney);
//            driverLineTwo = convertView.findViewById(R.id.driverLineTwo);
//            convertView.findViewById(R.id.driverLineOne).setVisibility(View.GONE);
//            convertView.findViewById(R.id.driverBackground).setVisibility(View.GONE);

            int margin = DensityUtils.dp2px(context, 10);
            LinearLayout.LayoutParams params = (LinearLayout.LayoutParams) driverLineTwo.getLayoutParams();
            params.leftMargin = margin;
            params.rightMargin = margin;
            driverLineTwo.setLayoutParams(params);

        }
    }

    public void updateList(List<AccountDateList> list) {
        this.list = list;
        notifyDataSetChanged();
    }

    public void addMoreList(List<AccountDateList> list) {
        this.list.addAll(list);
        notifyDataSetChanged();
    }

    public List<AccountDateList> getList() {
        return list;
    }

    public void setList(List<AccountDateList> list) {
        this.list = list;
    }
}
