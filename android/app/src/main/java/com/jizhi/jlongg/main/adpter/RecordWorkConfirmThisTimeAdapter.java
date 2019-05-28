package com.jizhi.jlongg.main.adpter;

import android.content.Context;
import android.support.v4.content.ContextCompat;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.RecordWorkConfirmMonth;
import com.jizhi.jlongg.main.bean.Salary;
import com.jizhi.jlongg.main.util.AccountUtil;
import com.jizhi.jlongg.main.util.NameUtil;

import java.util.List;

/**
 * CName:本次确认的是适配器
 * User: xj
 * Date: 2019年3月26日
 * Time: 16:13:16
 */
public class RecordWorkConfirmThisTimeAdapter extends BaseAdapter {
    /**
     * 列表数据
     */
    private List<RecordWorkConfirmMonth> list;
    /**
     * context
     */
    private Context context;

    public RecordWorkConfirmThisTimeAdapter(Context context, List<RecordWorkConfirmMonth> list) {
        super();
        this.list = list;
        this.context = context;
    }

    @Override
    public RecordWorkConfirmMonth getItem(int position) {
        return list.get(position);
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    @Override
    public int getCount() {
        return list == null ? 0 : list.size();
    }
    /**
     * 计算价钱
     *
     * @param salary
     */
    public void calculateMoney(ViewHolder viewHolder,Salary salary,RecordWorkConfirmMonth workInfo) {
        int hour_type = salary.getHour_type();
        String price;
        if (hour_type==1){//按小时
            double w_money = salary.getS_tpl() / salary.getW_h_tpl() * workInfo.getManhour(); //正常上班计算薪资
            double o_money = salary.getO_s_tpl() * workInfo.getOvertime(); //加班时常计算薪资
            price = Utils.m2(w_money + o_money);
            viewHolder.tv_amounts.setText(price);
        }else {//按工天
            if (salary.getS_tpl() == 0) {
                if (salary.getW_h_tpl() == 0 && salary.getO_h_tpl() == 0) {
                    viewHolder.tv_amounts.setText("");
                } else {
                    viewHolder.tv_amounts.setText("-");
                }
            } else {
                double w_money = salary.getS_tpl() / salary.getW_h_tpl() * workInfo.getManhour(); //正常上班计算薪资
                double o_money = salary.getS_tpl() / salary.getO_h_tpl() * workInfo.getOvertime(); //加班时常计算薪资
                price = Utils.m2(w_money + o_money);
                LUtils.e("========price"+price);
                viewHolder.tv_amounts.setText(price);
            }
        }
    }
    @Override
    public View getView(final int position, View convertView, ViewGroup parent) {
        final ViewHolder viewHolder;
        if (convertView == null) {
            convertView = LayoutInflater.from(context).inflate(R.layout.item_rememberinfo_child, null);
            viewHolder = new ViewHolder(convertView);
            convertView.setTag(viewHolder);
        } else {
            viewHolder = (ViewHolder) convertView.getTag();
        }
        final RecordWorkConfirmMonth workInfo = getItem(position);
        viewHolder.rea_draver1.setVisibility(list.size() == 1 || list.size() - 1 == position ? View.GONE : View.VISIBLE);
        viewHolder.rea_driver10.setVisibility(View.VISIBLE);
        viewHolder.tv_date.setText(workInfo.getDate() + " (" + workInfo.getDate_turn() + ")");
        viewHolder.tv_name.setText(NameUtil.setName(workInfo.getWorker_name()));
        viewHolder.tv_pro_name.setText(NameUtil.setRemark(workInfo.getIs_diff_pro() == 1 ? workInfo.getOth_proname() : workInfo.getProname(), 10));
        viewHolder.tv_billname.setText("班组长：" + NameUtil.setName(workInfo.getForeman_name()));
        String accountType = workInfo.getAccounts_type();
        if (AccountUtil.HOUR_WORKER.equals(accountType)) {
            Salary tpl = workInfo.getSet_tpl();
            /**
             1、正常工资 = 工资模版 / 正常工时模版 * 正常工时
             2、加班工资 = 工资模版 / 加班工时模版 * 加班工时
             */
            calculateMoney(viewHolder,tpl,workInfo);
//            if (tpl != null && workInfo.getSet_my_amounts_tpl() != 0) {
//                String amount = Utils.m2((workInfo.getSet_my_amounts_tpl() / tpl.getW_h_tpl() * workInfo.getManhour()) +
//                        (workInfo.getSet_my_amounts_tpl() / tpl.getO_h_tpl() * workInfo.getOvertime()));
//                viewHolder.tv_amounts.setText(amount.equals("0.00") ? "-" : amount);
//            } else {
//                viewHolder.tv_amounts.setText("-");
//            }
        } else {
            if (TextUtils.isEmpty(workInfo.getAmounts())) {
                viewHolder.tv_amounts.setText("-");
            } else {
                viewHolder.tv_amounts.setText(workInfo.getAmounts().equals("0.00") || workInfo.getAmounts().equals("0")
                        || workInfo.getAmounts().equals("0.0") ? "-" : workInfo.getAmounts());
            }
        }
        if (AccountUtil.HOUR_WORKER.equals(accountType) || AccountUtil.CONSTRACTOR_CHECK.equals(accountType)) { // 1:点工 5.包工记工天
            viewHolder.tv_worktime.setText(AccountUtil.getAccountShowTypeString(context, true, false, true, workInfo.getManhour(), workInfo.getWorking_hours()));
            viewHolder.tv_overtime.setText(AccountUtil.getAccountShowTypeString(context, true, false, false, workInfo.getOvertime(), workInfo.getOvertime_hours()));
            viewHolder.tv_amounts.setTextColor(ContextCompat.getColor(context, R.color.app_color));
            viewHolder.tv_overtime.setVisibility(View.VISIBLE);
            viewHolder.img_type.setVisibility(View.VISIBLE);
            Utils.setBackGround(viewHolder.img_type, context.getResources().getDrawable(AccountUtil.HOUR_WORKER.equals(accountType) ? R.drawable.hour_worker_flag : R.drawable.constar_flag));
        } else if (AccountUtil.CONSTRACTOR.equals(accountType)) { //2:包工
            viewHolder.tv_worktime.setText(workInfo.getContractor_type() == 1 ? "包工(承包)" : "包工(分包)");
            viewHolder.tv_billname.setText(workInfo.getContractor_type() == 1 && UclientApplication.isForemanRoler(context) ? "承包对象：" + NameUtil.setName(workInfo.getForeman_name()) : "班组长：" + NameUtil.setName(workInfo.getForeman_name()));
            viewHolder.tv_amounts.setTextColor(ContextCompat.getColor(context, workInfo.getContractor_type() == 1 && UclientApplication.isForemanRoler(context) ? R.color.green : R.color.color_eb4e4e));
            viewHolder.tv_overtime.setVisibility(View.GONE);
            viewHolder.img_type.setVisibility(View.GONE);
        } else if (AccountUtil.BORROWING.equals(accountType)) {//  3:借支
            viewHolder.tv_worktime.setText("借支");
            viewHolder.tv_overtime.setVisibility(View.GONE);
            viewHolder.tv_amounts.setTextColor(ContextCompat.getColor(context, R.color.green));
            viewHolder.img_type.setVisibility(View.GONE);
        } else if (AccountUtil.SALARY_BALANCE.equals(accountType)) {//   4:结算
            viewHolder.tv_worktime.setText("结算");
            viewHolder.tv_overtime.setVisibility(View.GONE);
            viewHolder.tv_amounts.setTextColor(ContextCompat.getColor(context, R.color.green));
            viewHolder.img_type.setVisibility(View.GONE);
        }
        viewHolder.img_remark.setVisibility(workInfo.getIs_notes() == 1 ? View.VISIBLE : View.GONE);
        if (position != 0) {
            if (workInfo.getDate().equals(list.get(position - 1).getDate())) {
                viewHolder.rea_top.setVisibility(View.GONE);
            } else {
                viewHolder.rea_top.setVisibility(View.VISIBLE);
            }
        } else {
            viewHolder.rea_top.setVisibility(View.VISIBLE);
        }
        return convertView;
    }


    class ViewHolder {
        TextView tv_name;
        TextView tv_worktime;
        TextView tv_overtime;
        TextView tv_amounts;
        TextView tv_pro_name;
        TextView tv_billname;
        ImageView cb_del;
        ImageView img_type;
        ImageView img_remark;
        RelativeLayout rea_draver1;
        LinearLayout rea_top;
        TextView tv_date;
        RelativeLayout rea_driver10;


        public ViewHolder(View convertView) {
            tv_name = convertView.findViewById(R.id.tv_name);
            tv_worktime = convertView.findViewById(R.id.tv_worktime);
            tv_overtime = convertView.findViewById(R.id.tv_overtime);
            tv_amounts = convertView.findViewById(R.id.tv_amounts);
            tv_pro_name = convertView.findViewById(R.id.tv_pro_name);
            tv_billname = convertView.findViewById(R.id.tv_billname);
            cb_del = convertView.findViewById(R.id.cb_del);
            img_type = convertView.findViewById(R.id.img_type);
            rea_draver1 = convertView.findViewById(R.id.rea_draver1);
            tv_date = convertView.findViewById(R.id.tv_date);
            rea_driver10 = convertView.findViewById(R.id.rea_driver10);
            rea_top = convertView.findViewById(R.id.rea_top);
            img_remark = convertView.findViewById(R.id.img_remark);
            convertView.findViewById(R.id.rea_del).setVisibility(View.GONE);
        }


    }

    public interface RememberCheckBoxChangeListener {
        void getSelectLength(int length);

        void itemClicListener(int positonint);

        void itemLongClicListener(int positonint);
    }

}
