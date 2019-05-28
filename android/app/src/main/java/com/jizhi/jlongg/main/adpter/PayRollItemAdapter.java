package com.jizhi.jlongg.main.adpter;

import android.annotation.TargetApi;
import android.content.Context;
import android.os.Build;
import android.support.v4.content.ContextCompat;
import android.text.Html;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.PayRollList;
import com.jizhi.jlongg.main.util.RecordUtils;

import java.util.List;

/**
 * 功能:工资清单列表(1.4.5)
 * 时间:2016年7月22日 10:43:14
 * 作者:xuj
 */
public class PayRollItemAdapter extends BaseAdapter {

    /**
     * xml解析器
     */
    private LayoutInflater inflater;
    /**
     * 工资清单列表数据
     */
    private List<PayRollList> list;
    /**
     * 上下文
     */
    private Context context;

    public void update(List<PayRollList> list) {
        this.list = list;
        notifyDataSetChanged();
    }

    public List<PayRollList> getList() {
        return list;
    }


    public PayRollItemAdapter(Context context, List<PayRollList> list) {
        this.list = list;
        this.context = context;
        inflater = LayoutInflater.from(context);
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

    @TargetApi(Build.VERSION_CODES.JELLY_BEAN)
    @Override
    public View getView(final int position, View convertView, ViewGroup parent) {
        ViewHolder holder = null;
        if (convertView == null) {
            convertView = inflater.inflate(R.layout.payroll_year_month_list_item, parent, false);
            holder = new ViewHolder(convertView);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        bindData(holder, position);
        return convertView;
    }


    public void bindData(final ViewHolder holder, final int position) {
        PayRollList bean = list.get(position);
        holder.month.setText(bean.getMonth() + "月");
        int tPoor = bean.getT_poor(); //差帐笔数
        if (tPoor != 0) {
            holder.totalPoor.setText(Html.fromHtml("<font color='#d7252c'>" + bean.getT_poor() + "&nbsp</font><font style='font-weight:bold' color='#333333'>笔待确认</font>"));
            holder.totalPoor.setVisibility(View.VISIBLE);
        } else {
            holder.totalPoor.setVisibility(View.GONE);
        }
        holder.sumPayableValue.setText(bean.getNew_total().getPre_unit() + bean.getNew_total_income().getTotal() + bean.getNew_total_income().getUnit()); //工资
        holder.sumBorrowValue.setText(bean.getNew_total().getPre_unit() + bean.getNew_total_expend().getTotal() + bean.getNew_total_expend().getUnit()); //借支
        holder.sumBalance.setText(bean.getNew_total().getPre_unit() + bean.getNew_total_balance().getTotal() + bean.getNew_total_balance().getUnit()); //结算
        holder.realIncomeValue.setText(bean.getNew_total().getPre_unit() + bean.getNew_total().getTotal() + bean.getNew_total().getUnit()); //未结工资
        holder.realIncomeValue.setTextColor(ContextCompat.getColor(context, bean.getTotal() >= 0 ? R.color.app_color : R.color.green));

//        holder.totalManhour.setText(String.format(context.getString(R.string.normal_work), Utils.m1(Double.parseDouble(bean.getTotal_manhour() + "")))); //正常上班工时
//        holder.overTime.setText(String.format(context.getString(R.string.overtime_work), Utils.m1(Double.parseDouble(bean.getTotal_overtime() + "")))); //加班时长工时

        holder.totalManhour.setText(RecordUtils.getNormalTotalWorkString(bean.getTotal_manhour(), false)); //正常工时
        holder.overTime.setText(RecordUtils.getOverTimeTotalWorkString(bean.getTotal_overtime(), false)); //加班工时

        int index = getPositionForSection(position);
        if (index != -1) {
            holder.yearLayout.setVisibility(View.VISIBLE);
            holder.year.setText(bean.getYear() + "年");
        } else {
            holder.yearLayout.setVisibility(View.GONE);
        }
    }


    public class ViewHolder {

        public ViewHolder(View convertView) {
            yearLayout = (LinearLayout) convertView.findViewById(R.id.year_layout);
            year = (TextView) convertView.findViewById(R.id.year);
            month = (TextView) convertView.findViewById(R.id.month);
            totalPoor = (TextView) convertView.findViewById(R.id.total_poor);
            totalManhour = (TextView) convertView.findViewById(R.id.totalManhour);
            overTime = (TextView) convertView.findViewById(R.id.overTime);

            sumPayableValue = (TextView) convertView.findViewById(R.id.sumPayableValue);
            sumBorrowValue = (TextView) convertView.findViewById(R.id.sumBorrowValue);
            sumBalance = (TextView) convertView.findViewById(R.id.sumBalance);
            realIncomeValue = (TextView) convertView.findViewById(R.id.realIncomeValue);
        }

        /**
         * 年布局
         */
        LinearLayout yearLayout;
        /**
         * 年
         */
        TextView year;
        /**
         * 月份
         */
        TextView month;
        /**
         * 差帐数量
         */
        TextView totalPoor;
        /**
         * 正常上班工时
         */
        TextView totalManhour;
        /**
         * 加班工时
         */
        TextView overTime;
        /**
         * 收入
         */
        TextView sumPayableValue;
        /**
         * 借支
         */
        TextView sumBorrowValue;
        /**
         * 实际结算
         */
        TextView sumBalance;
        /**
         * 实际收入
         */
        TextView realIncomeValue;


    }

    public int getPositionForSection(int section) {
        int selectYear = list.get(section).getYear();
        for (int i = 0; i < getCount(); i++) {
            int year = list.get(i).getYear();
            if (year == selectYear) {
                if (section != i) {
                    break;
                } else {
                    return i;
                }
            }
        }
        return -1;
    }
}
