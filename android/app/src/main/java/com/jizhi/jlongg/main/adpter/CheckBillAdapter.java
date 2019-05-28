package com.jizhi.jlongg.main.adpter;

import android.app.Activity;
import android.content.res.Resources;
import android.support.v4.content.ContextCompat;
import android.text.Html;
import android.text.TextPaint;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.PopupWindow;
import android.widget.TextView;

import com.hcs.uclient.utils.LUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.CheckBillField;
import com.jizhi.jlongg.main.bean.CheckBillInfo;
import com.jizhi.jlongg.main.bean.DiffBill;
import com.jizhi.jlongg.main.util.AccountUtil;

import java.util.List;

/**
 * 功能:差帐Adapter 3.4.1修改
 * 时间:2018-11-26 11:04
 * 作者:hcs
 */
public class CheckBillAdapter extends BaseAdapter {
    /**
     * xml解析器
     */
    private LayoutInflater inflater;

    private List<CheckBillInfo> list;

    private Activity context;

    public static final int HEAD = 0;

    public static final int CONTENT = 1;
    public static final int CONTENT_WAGE = 3;

    //    public static final int HOURWORK = 2;
    public static final int SALARY = 2;

    private boolean isHourWork;

    private DiffBill bill;

    private String orign;

    private PopupWindow popuWindow;
    private String account_type;


    public CheckBillAdapter(Activity context, List<CheckBillInfo> list, boolean isHourWork, DiffBill bill, String orign, PopupWindow dialog, String account_type) {
        this.list = list;
        this.context = context;
        inflater = LayoutInflater.from(context);
        this.isHourWork = isHourWork;
        this.bill = bill;
        this.orign = orign;
        this.popuWindow = dialog;
        this.account_type = account_type;
    }

    @Override
    public int getViewTypeCount() {
        return 4;
    }

    @Override
    public int getItemViewType(int position) {
        CheckBillInfo checkBillField = list.get(position);
        switch (checkBillField.getType()) {
            case HEAD:
                return HEAD;
            case CONTENT:
                return CONTENT;
            case CONTENT_WAGE:
                return CONTENT_WAGE;
            case SALARY:
                return SALARY;
            default:
                return -1;
        }
    }

    @Override
    public int getCount() {
        return list.size();
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
        final int type = getItemViewType(position);
        CheckBillInfo info = list.get(position);
        switch (type) {
            case HEAD: //头部
                convertView = inflater.inflate(R.layout.layout_check_billdialog_roleinfo, parent, false);
                //记账类型
                ((TextView) convertView.findViewById(R.id.tv_account_type)).setText(account_type);
                //左边名字
                ((TextView) convertView.findViewById(R.id.tv_name_left)).setText(info.getFieldLeft());
                //右边名字
                ((TextView) convertView.findViewById(R.id.tv_name_right)).setText(info.getFieldRight());
                break;
            case CONTENT: //点工，包工记账，借支,时间相关
                convertView = inflater.inflate(R.layout.layout_check_billdialog_hour, parent, false);
                //左边文字
                ((TextView) convertView.findViewById(R.id.tv_left)).setText(info.getFieldLeft());
                //右边文字
                ((TextView) convertView.findViewById(R.id.tv_right)).setText(info.getFieldRight());
                //最左边文字内容以及颜色
                ((TextView) convertView.findViewById(R.id.tv_name)).setText(info.getFieldName());
                ((TextView) convertView.findViewById(R.id.tv_left)).setTextColor(ContextCompat.getColor(context, R.color.color_eb4e4e));
                TextPaint tp = ((TextView) convertView.findViewById(R.id.tv_name)).getPaint();
                if (info.isBold()) {
                    tp.setFakeBoldText(true);
                } else {
                    tp.setFakeBoldText(false);
                }
                //最有一条内容需要隐藏分割线
                break;
            case CONTENT_WAGE: //结算内容
                convertView = inflater.inflate(R.layout.layout_check_billdialog_wage, parent, false);
                //左边文字
                ((TextView) convertView.findViewById(R.id.tv_left)).setText(info.getFieldLeft());
                //右边文字
                ((TextView) convertView.findViewById(R.id.tv_right)).setText(info.getFieldRight());
                //最左边文字内容以及颜色
                ((TextView) convertView.findViewById(R.id.tv_name)).setText(info.getFieldName());
                ((TextView) convertView.findViewById(R.id.tv_left)).setTextColor(ContextCompat.getColor(context, R.color.color_eb4e4e));
                //处理分割线
                if (position == list.size() - 1) {
                    convertView.findViewById(R.id.img_view_bottom).setVisibility(View.VISIBLE);
                    convertView.findViewById(R.id.img_view_top).setVisibility(View.GONE);
                }
//                } else if (position == 2) {
//                    convertView.findViewById(R.id.img_view_bottom).setVisibility(View.GONE);
//                    convertView.findViewById(R.id.img_view_top).setVisibility(View.VISIBLE);
//                } else {
//                    convertView.findViewById(R.id.img_view_bottom).setVisibility(View.GONE);
//                    convertView.findViewById(R.id.img_view_top).setVisibility(View.VISIBLE);
//                }
                break;
            case SALARY://点工包工金额相关
                convertView = inflater.inflate(R.layout.audit_salary, parent, false);
                TextView tv_worktime_my = convertView.findViewById(R.id.tv_worktime_my);
                TextView tv_overtime_my = convertView.findViewById(R.id.tv_overtime_my);
                TextView tv_worktime_other = convertView.findViewById(R.id.tv_worktime_other);
                TextView tv_overtime_other = convertView.findViewById(R.id.tv_overtime_other);
                TextView tv_title1 = convertView.findViewById(R.id.tv_title1);
                TextView tv_title2 = convertView.findViewById(R.id.tv_title2);

                CheckBillInfo bean = list.get(position);
                if (orign.equals(AccountUtil.HOUR_WORKER) || orign.equals(AccountUtil.CONSTRACTOR_CHECK)) {  //点工
                    tv_title1.setText(bean.isSalary() ? "上班标准" : "上班");
                    tv_title2.setText(bean.isSalary() ? "加班标准" : "加班");
                    tv_worktime_my.setText(bean.getW_h_tpl_my());
                    tv_overtime_my.setText(bean.getO_h_tpl_my());
                    tv_worktime_other.setText(bean.getW_h_tpl_other());
                    tv_overtime_other.setText(bean.getO_h_tpl_other());
                    tv_worktime_my.setTextColor(ContextCompat.getColor(context, R.color.color_eb4e4e));
                    tv_overtime_my.setTextColor(ContextCompat.getColor(context, R.color.color_eb4e4e));
                } else if (orign.equals(AccountUtil.CONSTRACTOR)) {  //包工
                    tv_title1.setText("单价");
                    tv_title2.setText("数量");
                    tv_worktime_my.setText(bean.getWorkDetail().getUnitprice_my());
                    tv_overtime_my.setText(bean.getWorkDetail().getQuantities_my());
                    tv_worktime_other.setText(bean.getWorkDetail().getUnitprice_other());
                    tv_overtime_other.setText(bean.getWorkDetail().getQuantities_other());
                    tv_worktime_my.setTextColor(ContextCompat.getColor(context, R.color.color_eb4e4e));
                    tv_overtime_my.setTextColor(ContextCompat.getColor(context, R.color.color_eb4e4e));
                }
                convertView.findViewById(R.id.line).setVisibility(bean.isSalary() ? View.VISIBLE : View.GONE);

                break;
        }

        return convertView;
    }
}
