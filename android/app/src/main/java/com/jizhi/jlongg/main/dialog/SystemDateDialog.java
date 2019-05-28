package com.jizhi.jlongg.main.dialog;

import android.app.Activity;
import android.app.DatePickerDialog;
import android.content.DialogInterface;
import android.widget.DatePicker;
import android.widget.TextView;

import com.hcs.uclient.utils.TimesUtils;

import java.util.Calendar;

/**
 * 功能: 记工记账 所需 弹出框
 * 作者：Administrator
 * 时间: 2016-4-7 11:15
 */
public class SystemDateDialog {

    /**
     * 是否点击了取消按钮
     */
    private boolean isClickCancel;
    /**
     * 系统日期弹出框
     */
    private DatePickerDialog dialog;
    /**
     * 是否显示当前时间
     */
    private boolean isShowCurrentDate;
    private int years, months, dates;

    public SystemDateDialog() {
        Calendar c = Calendar.getInstance();
        years = c.get(Calendar.YEAR);
        months = c.get(Calendar.MONTH);
        dates = c.get(Calendar.DAY_OF_MONTH);
    }

    public SystemDateDialog(boolean isShowCurrentDate, int year, int month, int dates) {
        this.isShowCurrentDate = isShowCurrentDate;
        this.years = year;
        this.months = month - 1;
        this.dates = dates;
    }

    public void setIsClickCancel(boolean isClickCancel) {
        this.isClickCancel = isClickCancel;
    }


    public DatePickerDialog getDialog() {
        return dialog;
    }

    /**
     * 显示系统日期对话框
     *
     * @param activity
     * @param title    顶部标题
     * @param text     将选择的日期显示在TextView 中
     * @param listener 选择日期的回调
     */
    public void showDialog(final Activity activity, String title, final TextView text, final SystemDateCallBack listener) {
        Calendar c = Calendar.getInstance();
        dialog = new DatePickerDialog(activity,
                new DatePickerDialog.OnDateSetListener() {
                    public void onDateSet(DatePicker dp, int year, int month, int dayOfMonth) {
                        if (isClickCancel) {
                            return;
                        }
                        if (listener != null) {
                            if (listener.getDate(year, month, dayOfMonth)) {
                                StringBuffer sb = new StringBuffer(20);
                                sb.append(!isShowCurrentDate ? year + "-" + ((month + 1) < 10 ? "0" + (month + 1) : (month + 1)) + "-" + (dayOfMonth < 10 ? "0" + dayOfMonth : dayOfMonth) + "" : TimesUtils.getWeek(year, month + 1, dayOfMonth));
                                text.setText(sb.toString());
                                listener.getTimestamp(year * 10000 + (month + 1) * 100 + dayOfMonth);
                            }
                        }
                    }
                }, years, // 传入年份
                months, // 传入月份
                dates // 传入天数
        );
        dialog.setButton(DialogInterface.BUTTON_NEGATIVE, "取消", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {
                isClickCancel = true;
                dialog.dismiss();
            }
        });
        dialog.setTitle(title);
        dialog.show();
    }


    public interface SystemDateCallBack {
        void getTimestamp(int time); //获取时间戳

        boolean getDate(int year, int month, int dayOfMonth);


    }


}
