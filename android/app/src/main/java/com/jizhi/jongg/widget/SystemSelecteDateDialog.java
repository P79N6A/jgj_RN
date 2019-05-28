package com.jizhi.jongg.widget;

import android.app.DatePickerDialog;
import android.content.Context;

/**
 * 系统选择日历弹出框
 * 定义一个类，继承DialogFragment并实现DatePickerDialog.OnDateSetListener
 */
public class SystemSelecteDateDialog extends DatePickerDialog {

    public SystemSelecteDateDialog(Context context, OnDateSetListener callBack, int year, int monthOfYear, int dayOfMonth) {
        super(context, callBack, year, monthOfYear, dayOfMonth);
    }

    /**
     * 大家只需写一个子类继承DatePickerDialog，然后在里面重写父类的onStop()方法
     */
    @Override
    protected void onStop() { //DatePickerDialog中onDateSet执行两次的问题
//            super.onStop();
    }

}