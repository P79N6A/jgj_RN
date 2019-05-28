package com.jizhi.jlongg.main.dialog;

import android.annotation.TargetApi;
import android.app.Activity;
import android.app.Dialog;
import android.os.Build;
import android.text.TextUtils;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ListView;

import com.hcs.uclient.utils.CallPhoneUtil;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.adpter.CallPhoneAdapter;
import com.jizhi.jlongg.main.bean.PersonInfo;
import com.jizhi.jlongg.main.util.CommonMethod;

/**
 * 功能:拨打电话Dialog
 * 时间:2016-5-10 9:51
 * 作者:xuj
 */
public class DiaLogCallPhone extends Dialog implements View.OnClickListener {


    public DiaLogCallPhone(Activity context, PersonInfo[] listPhone, CallPhoneListener listener) {
        super(context, R.style.Custom_Progress);
        createLayout(context, listPhone, listener);
        commendAttribute(true);
    }

    @TargetApi(Build.VERSION_CODES.HONEYCOMB)
    public void createLayout(final Activity context, final PersonInfo[] listPhone, final CallPhoneListener listener) {
        setContentView(R.layout.dialog_callphone);
        ListView lv_callphone = (ListView) findViewById(R.id.lv_callphone);
        CallPhoneAdapter CallPhoneAdapter = new CallPhoneAdapter(context, listPhone);
        lv_callphone.setAdapter(CallPhoneAdapter);
        findViewById(R.id.redBtn).setOnClickListener(this);
        lv_callphone.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                PersonInfo bean = listPhone[position];
                String telphone = bean.getTelph();
                if (!TextUtils.isEmpty(telphone)) {
                    CallPhoneUtil.callPhone(context, telphone);
                    dismiss();
                    listener.callBack();
                } else {
                    CommonMethod.makeNoticeShort(context, "电话号码不存在!", CommonMethod.ERROR);
                }
            }
        });
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.redBtn: //关闭
                dismiss();
                break;
        }
    }


    /**
     * 设置弹出框公共属性
     */
    public void commendAttribute(boolean isCancelDialog) {
        setCanceledOnTouchOutside(isCancelDialog);
        setCancelable(isCancelDialog);
    }


    public interface CallPhoneListener {
        public void callBack();
    }
}
