package com.jizhi.jlongg.main.adpter;

import android.content.Context;
import android.support.v4.content.ContextCompat;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.PayRollList;
import com.jizhi.jlongg.main.util.AccountUtil;
import com.jizhi.jlongg.main.util.NameUtil;
import com.liaoinstan.springview.utils.DensityUtil;

import java.util.List;


/**
 * 功能:无金额点工适配器
 * 时间:2018年1月8日17:21:42
 * 作者:xuj
 */
public class NoMoneyLittlerWorkAdapter extends BaseAdapter {
    /**
     * 列表数据
     */
    private List<PayRollList> list;
    /**
     * xml解析器
     */
    private LayoutInflater inflater;
    /**
     * 是否正在编辑
     */
    private boolean isEditor;
    /**
     * context
     */
    private Context context;


    public NoMoneyLittlerWorkAdapter(Context context, List<PayRollList> list) {
        super();
        this.list = list;
        this.context = context;
        inflater = LayoutInflater.from(context);
    }


    @Override
    public int getCount() {
        return list == null ? 0 : list.size();
    }

    @Override
    public PayRollList getItem(int position) {
        return list.get(position);
    }

    @Override
    public long getItemId(int position) {
        return 0;
    }


    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        final ViewHolder holder;
        if (convertView == null) {
            convertView = inflater.inflate(R.layout.no_money_item, null, false);
            holder = new ViewHolder(convertView);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        PayRollList accountDateList = getItem(position);
        if (position != 0) {
            if (accountDateList.getDate().equals(list.get(position - 1).getDate())) {
                holder.date.setVisibility(View.GONE);
            } else {
                holder.date.setVisibility(View.VISIBLE);
                holder.date.setText(accountDateList.getDate());
            }
            holder.line.setVisibility(View.VISIBLE);
        } else {
            holder.date.setVisibility(View.VISIBLE);
            holder.line.setVisibility(View.GONE);
            holder.date.setText(accountDateList.getDate());
        }
        holder.itemDiver.setVisibility(View.GONE);
        holder.proName.setText(accountDateList.getProname()); //设置项目名称
        holder.recordWorkName.setText(NameUtil.setName(accountDateList.getWorker_name())); //设置工人名称
        holder.foremanName.setText("班组长:" + NameUtil.setName(accountDateList.getForeman_name())); //设置工头名称
        holder.workMoney.setText(accountDateList.getAmounts()); //设置金额
        holder.notesIcon.setVisibility(accountDateList.getIs_notes() == 1 ? View.VISIBLE : View.GONE); //是否已设置了备注信息
        switch (accountDateList.getAccounts_type()) {
            case AccountUtil.HOUR_WORKER: //点工
                holder.recordTips1.setText(AccountUtil.getAccountShowTypeString(context, true, false, true, accountDateList.getManhour(), accountDateList.getWorking_hours()));
                holder.recordTips2.setText(AccountUtil.getAccountShowTypeString(context, true, false, false, accountDateList.getOvertime(), accountDateList.getOvertime_hours()));
                holder.workMoney.setTextColor(ContextCompat.getColor(context, R.color.app_color));
                holder.recordTypeIcon.setVisibility(View.VISIBLE);
                holder.recordTypeIcon.setImageResource(R.drawable.hour_worker_flag);
                break;
            case AccountUtil.CONSTRACTOR: //包工
                holder.recordTypeIcon.setVisibility(View.GONE);
                holder.recordTips1.setText("包工");
                holder.recordTips2.setVisibility(View.GONE);
                holder.workMoney.setTextColor(ContextCompat.getColor(context, R.color.app_color));
                break;
            case AccountUtil.BORROWING: //借支
                holder.recordTypeIcon.setVisibility(View.GONE);
                holder.recordTips1.setText("借支");
                holder.recordTips2.setVisibility(View.GONE);
                holder.workMoney.setTextColor(ContextCompat.getColor(context, R.color.green));
                break;
            case AccountUtil.SALARY_BALANCE: //结算
                holder.recordTypeIcon.setVisibility(View.GONE);
                holder.recordTips1.setText("结算");
                holder.recordTips2.setVisibility(View.GONE);
                holder.workMoney.setTextColor(ContextCompat.getColor(context, R.color.green));
                break;
            case AccountUtil.CONSTRACTOR_CHECK: //包工记工天
                holder.recordTips1.setText(AccountUtil.getAccountShowTypeString(context, true, false, true, accountDateList.getManhour(), accountDateList.getWorking_hours()));
                holder.recordTips2.setText(AccountUtil.getAccountShowTypeString(context, true, false, false, accountDateList.getOvertime(), accountDateList.getOvertime_hours()));
                holder.workMoney.setTextColor(ContextCompat.getColor(context, R.color.app_color));
                holder.recordTypeIcon.setVisibility(View.VISIBLE);
                holder.recordTypeIcon.setImageResource(R.drawable.constar_flag);
                break;
        }
        if (isEditor) {
            holder.selecteIcon.setVisibility(View.VISIBLE);
            holder.selecteIcon.setImageResource(accountDateList.is_selected ? R.drawable.checkbox_pressed : R.drawable.checkbox_normal);
        } else {
            holder.selecteIcon.setVisibility(View.GONE);
        }
        if (holder.notesIcon.getVisibility() == View.VISIBLE) {
            LinearLayout.LayoutParams params = (LinearLayout.LayoutParams) holder.recordTypeIcon.getLayoutParams();
            params.bottomMargin = DensityUtil.dp2px(2);
            holder.recordTypeIcon.setLayoutParams(params);
        }

        return convertView;
    }

    class ViewHolder {

        /**
         * 日期
         */
        TextView date;
        /**
         * 分割线
         */
        View itemDiver;
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
        View line;
        /**
         * 记账类型图标
         */
        ImageView recordTypeIcon;
        /**
         * 备注图标
         */
        ImageView notesIcon;
        /**
         * 已选图标
         */
        ImageView selecteIcon;

        public ViewHolder(View convertView) {
            date = (TextView) convertView.findViewById(R.id.date);
            itemDiver = convertView.findViewById(R.id.itemDiver);
            recordTypeIcon = (ImageView) convertView.findViewById(R.id.recordTypeIcon);
            notesIcon = (ImageView) convertView.findViewById(R.id.notesIcon);
            itemLayout = convertView.findViewById(R.id.itemLayout);
            proName = (TextView) convertView.findViewById(R.id.proName);
            recordWorkName = (TextView) convertView.findViewById(R.id.recordWorkName);
            foremanName = (TextView) convertView.findViewById(R.id.foremanName);
            recordTips1 = (TextView) convertView.findViewById(R.id.recordTips1);
            recordTips2 = (TextView) convertView.findViewById(R.id.recordTips2);
            workMoney = (TextView) convertView.findViewById(R.id.workMoney);
            line = convertView.findViewById(R.id.line);
            selecteIcon = convertView.findViewById(R.id.selecte_icon);
        }
    }

    public void updateList(List<PayRollList> list) {
        this.list = list;
        notifyDataSetChanged();
    }

    public void addMoreList(List<PayRollList> list) {
        this.list.addAll(list);
        notifyDataSetChanged();
    }

    public boolean isEditor() {
        return isEditor;
    }

    public void setEditor(boolean editor) {
        isEditor = editor;
    }

    public List<PayRollList> getList() {
        return list;
    }

    public void setList(List<PayRollList> list) {
        this.list = list;
    }
}
