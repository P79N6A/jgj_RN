package com.jizhi.jlongg.main.adpter;

import android.content.Context;
import android.support.v4.content.ContextCompat;
import android.view.ContextMenu;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.WorkDetail;
import com.jizhi.jlongg.main.util.AccountUtil;
import com.jizhi.jlongg.main.util.NameUtil;
import com.liaoinstan.springview.utils.DensityUtil;

import java.util.List;

/**
 * 功能:每日考勤表Adapter
 * 时间:2016-7-15 15:19
 * 作者: xuj
 */
public class EveryDayAttendanceAdapter extends BaseAdapter {
    /**
     * 列表数据
     */
    private List<WorkDetail> list;
    /**
     * Xml解析器
     */
    private LayoutInflater inflater;
    /***
     * 点击事件
     */
    private EveryDayItemClickListener itemClicListener;
    /**
     * 上下文
     */
    private Context context;


    public List<WorkDetail> getList() {
        return list;
    }

    public void updateList(List<WorkDetail> list) {
        this.list = list;
        notifyDataSetChanged();
    }


    public EveryDayAttendanceAdapter(Context context, List<WorkDetail> list, EveryDayItemClickListener listener) {
        inflater = LayoutInflater.from(context);
        this.list = list;
        this.context = context;
        itemClicListener = listener;
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

    @Override
    public View getView(final int position, View convertView, ViewGroup parent) {
        final WorkDetail workDetail = list.get(position);
        final Holder holder;
        if (convertView == null) {
            convertView = inflater.inflate(R.layout.no_money_item, null);
            holder = new Holder(convertView);
            convertView.setTag(holder);
        } else {
            holder = (Holder) convertView.getTag();
        }
        holder.proName.setText(workDetail.getProname()); //设置项目名称
        holder.recordWorkName.setText(NameUtil.setName(workDetail.getWorker_name())); //设置工人名称

        holder.workMoney.setText(workDetail.getAmounts()); //设置金额
        holder.notesIcon.setVisibility(workDetail.getIs_notes() == 1 ? View.VISIBLE : View.GONE); //是否已设置了备注信息
        switch (workDetail.getAccounts_type()) {
            case AccountUtil.HOUR_WORKER: //点工
                holder.recordTypeIcon.setVisibility(View.VISIBLE);
                holder.recordTypeIcon.setImageResource(R.drawable.hour_worker_flag);
                holder.recordTips1.setText(AccountUtil.getAccountShowTypeString(context, true, false, true, workDetail.getManhour(), workDetail.getWorking_hours()));
                holder.recordTips2.setText(AccountUtil.getAccountShowTypeString(context, true, false, false, workDetail.getOvertime(), workDetail.getOvertime_hours()));
                holder.workMoney.setTextColor(ContextCompat.getColor(context, R.color.app_color));
                holder.recordTips2.setVisibility(View.VISIBLE);
                holder.foremanName.setText("班组长:" + NameUtil.setName(workDetail.getForeman_name())); //设置工头名称
                break;
            case AccountUtil.CONSTRACTOR: //包工
                boolean isForeman = UclientApplication.isForemanRoler(context);
                if (workDetail.getContractor_type() == 1) { //承包
                    holder.recordTips1.setText("包工(承包)");
                    holder.workMoney.setTextColor(ContextCompat.getColor(context, isForeman ? R.color.borrow_color : R.color.app_color));
                    holder.foremanName.setText((isForeman ? "承包对象:" : "班组长:") + NameUtil.setName(workDetail.getForeman_name())); //设置工头名称
                } else if (workDetail.getContractor_type() == 2) { //分包
                    holder.recordTips1.setText("包工(分包)");
                    holder.workMoney.setTextColor(ContextCompat.getColor(context, R.color.app_color));
                    holder.foremanName.setText("班组长:" + NameUtil.setName(workDetail.getForeman_name())); //设置工头名称
                }
                holder.recordTypeIcon.setVisibility(View.GONE);
                holder.recordTips2.setVisibility(View.GONE);
                break;
            case AccountUtil.BORROWING: //借支
                holder.recordTypeIcon.setVisibility(View.GONE);
                holder.recordTips1.setText("借支");
                holder.recordTips2.setVisibility(View.GONE);
                holder.workMoney.setTextColor(ContextCompat.getColor(context, R.color.green));
                holder.foremanName.setText("班组长:" + NameUtil.setName(workDetail.getForeman_name())); //设置工头名称
                break;
            case AccountUtil.SALARY_BALANCE: //结算
                holder.recordTypeIcon.setVisibility(View.GONE);
                holder.recordTips1.setText("结算");
                holder.recordTips2.setVisibility(View.GONE);
                holder.workMoney.setTextColor(ContextCompat.getColor(context, R.color.green));
                holder.foremanName.setText("班组长:" + NameUtil.setName(workDetail.getForeman_name())); //设置工头名称
                break;
            case AccountUtil.CONSTRACTOR_CHECK: //包工记工天
                holder.recordTypeIcon.setVisibility(View.VISIBLE);
                holder.recordTypeIcon.setImageResource(R.drawable.constar_flag);
                holder.recordTips1.setText(AccountUtil.getAccountShowTypeString(context, true, false, true, workDetail.getManhour(), workDetail.getWorking_hours()));
                holder.recordTips2.setText(AccountUtil.getAccountShowTypeString(context, true, false, false, workDetail.getOvertime(), workDetail.getOvertime_hours()));
                holder.workMoney.setTextColor(ContextCompat.getColor(context, R.color.app_color));
                holder.recordTips2.setVisibility(View.VISIBLE);
                holder.foremanName.setText("班组长:" + NameUtil.setName(workDetail.getForeman_name())); //设置工头名称
                break;
        }
        if (holder.notesIcon.getVisibility() == View.VISIBLE) {
            LinearLayout.LayoutParams params = (LinearLayout.LayoutParams) holder.recordTypeIcon.getLayoutParams();
            params.bottomMargin = DensityUtil.dp2px(2);
            holder.recordTypeIcon.setLayoutParams(params);
        }

        View.OnClickListener onClick = new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                switch (v.getId()) {
                    case R.id.itemLayout: //item点击
                        itemClicListener.itemClick(position);
                        break;
                }
            }
        };
        holder.itemLayout.setOnClickListener(onClick);
        holder.itemLayout.setOnCreateContextMenuListener(new View.OnCreateContextMenuListener() {
            @Override
            public void onCreateContextMenu(ContextMenu menu, View v, ContextMenu.ContextMenuInfo menuInfo) {
                //在上下文菜单选项中添加选项内容
                //add方法的参数：add(分组id,itemid, 排序, 菜单文字)
                menu.add(0, 1, 0, "删除");
                menu.add(0, 2, 0, "修改");
            }
        });
        holder.itemLayout.setOnLongClickListener(new View.OnLongClickListener() {
            @Override
            public boolean onLongClick(View v) {
                itemClicListener.itemLongClick(position);
                return false;
            }
        });
        return convertView;
    }


    class Holder {


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
         * 分割线背景色
         */
        View itemDiver;
        /**
         * 记账类型图标
         */
        ImageView recordTypeIcon;
        /**
         * 备注图标
         */
        ImageView notesIcon;

        public Holder(View convertView) {
            recordTypeIcon = (ImageView) convertView.findViewById(R.id.recordTypeIcon);
            notesIcon = (ImageView) convertView.findViewById(R.id.notesIcon);
            itemDiver = convertView.findViewById(R.id.itemDiver);
            itemLayout = convertView.findViewById(R.id.itemLayout);

            proName = (TextView) convertView.findViewById(R.id.proName);
            recordWorkName = (TextView) convertView.findViewById(R.id.recordWorkName);
            foremanName = (TextView) convertView.findViewById(R.id.foremanName);

            recordTips1 = (TextView) convertView.findViewById(R.id.recordTips1);
            recordTips2 = (TextView) convertView.findViewById(R.id.recordTips2);

            workMoney = (TextView) convertView.findViewById(R.id.workMoney);

            convertView.findViewById(R.id.date).setVisibility(View.GONE);
            convertView.findViewById(R.id.line).setVisibility(View.GONE);
        }

    }

    public interface EveryDayItemClickListener {
        /**
         * 列表点击
         *
         * @param position 点击的下标
         */
        public void itemClick(int position);

        /**
         * 删除记账信息
         *
         * @param position 点击的下标
         */
        public void deleteAccountInfo(int position);

        /**
         * 列表长按点击
         *
         * @param position 点击的下标
         */
        public void itemLongClick(int position);

        /**
         * 列表点击
         *
         * @param groupPosition 父下标
         * @param childPosition 子下标
         */
        public void expandableItemClick(int groupPosition, int childPosition);
    }

}