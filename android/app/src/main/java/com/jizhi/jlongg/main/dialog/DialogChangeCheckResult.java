package com.jizhi.jlongg.main.dialog;

import android.annotation.TargetApi;
import android.app.Dialog;
import android.content.Context;
import android.graphics.drawable.Drawable;
import android.os.Build;
import android.support.annotation.IdRes;
import android.view.View;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.TextView;

import com.jizhi.jlongg.R;


/**
 * 功能:添加来源人弹窗
 * 时间:2016-5-10 9:51
 * 作者:xuj
 */
public class DialogChangeCheckResult extends Dialog implements View.OnClickListener {
    //点击确定按钮
    private DialogSelecteAddress.TipsClickListener listener;
    private Context context;
    private RadioButton rb_uncheck, rb_pass, rb_rectification;
    //选中的1:不用整改 2：通过 3：待整该
    private int selectIndex = 1;
    //带过来的 1：待整改 2：不用检查 3：通过
    private int status;

    public DialogChangeCheckResult(Context context, int status, DialogSelecteAddress.TipsClickListener listener) {
        super(context, R.style.network_dialog_style);
        this.listener = listener;
        this.context = context;
        this.status = status;
        createLayout();
        commendAttribute(true);
    }

    @TargetApi(Build.VERSION_CODES.HONEYCOMB)
    public void createLayout() {
        setContentView(R.layout.dialog_change_check_result);
        TextView close = (TextView) findViewById(R.id.redBtn);
        TextView btnAsscess = (TextView) findViewById(R.id.btn_asscess);
        rb_uncheck = (RadioButton) findViewById(R.id.rb_uncheck);
        rb_pass = (RadioButton) findViewById(R.id.rb_pass);
        rb_rectification = (RadioButton) findViewById(R.id.rb_rectification);
        close.setOnClickListener(this);
        btnAsscess.setOnClickListener(this);
        RadioGroup radioGroup = (RadioGroup) findViewById(R.id.radioGroup);
        final Drawable drawable = context.getResources().getDrawable(R.drawable.icon_check_gou);
        // 这一步必须要做,否则不会显示.
        drawable.setBounds(0, 0, drawable.getMinimumWidth(), drawable.getMinimumHeight());
        //设置传递过来的状态
        gonedrawableLeft();
        if (status == 1) {
            //1：待整改
            rb_rectification.setChecked(true);
            selectIndex = 3;
        } else if (status == 2) {
            //不用检查
            rb_uncheck.setChecked(true);
            selectIndex = 1;
        } else if (status == 3) {
            //3：通过
            rb_pass.setChecked(true);
            selectIndex = 2;
        }

        radioGroup.setOnCheckedChangeListener(new RadioGroup.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(RadioGroup group, @IdRes int checkedId) {
                gonedrawableLeft();
                switch (checkedId) {
                    case R.id.rb_uncheck:
                        rb_uncheck.setCompoundDrawables(drawable, null, null, null);
                        selectIndex = 1;
                        break;
                    case R.id.rb_pass:
                        rb_pass.setCompoundDrawables(drawable, null, null, null);
                        selectIndex = 2;
                        break;
                    case R.id.rb_rectification:
                        rb_rectification.setCompoundDrawables(drawable, null, null, null);
                        selectIndex = 3;
                        break;
                }
            }
        });
    }

    /**
     * 隐藏左边图标
     */
    public void gonedrawableLeft() {
        rb_pass.setCompoundDrawables(null, null, null, null);
        rb_uncheck.setCompoundDrawables(null, null, null, null);
        rb_rectification.setCompoundDrawables(null, null, null, null);
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.btn_asscess:
                listener.clickConfirm(selectIndex);
                break;

        }
        dismiss();
    }


    public void updateContent(String desc, int position) {
        TextView tv_content = (TextView) findViewById(R.id.tv_content);
        tv_content.setText(desc);
    }


    /**
     * 设置弹出框公共属性
     */
    public void commendAttribute(boolean isCancelDialog) {
        setCanceledOnTouchOutside(isCancelDialog);
        setCancelable(isCancelDialog);
    }

}
