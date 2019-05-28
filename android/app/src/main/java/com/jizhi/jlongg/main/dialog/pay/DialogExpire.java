package com.jizhi.jlongg.main.dialog.pay;

import android.annotation.TargetApi;
import android.app.Activity;
import android.app.Dialog;
import android.os.Build;
import android.view.View;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.util.ProductUtil;


/**
 * 功能:项目过期提示
 * 时间:2017年8月7日10:10:12
 * 作者:xuj
 */
public class DialogExpire extends Dialog implements View.OnClickListener {


    /**
     * 回调
     */
    private ProductUtil.ExpireListener listener;

    /**
     * 设置弹出框公共属性
     */
    public void commendAttribute(boolean isCancelDialog) {
        setCanceledOnTouchOutside(isCancelDialog);
        setCancelable(isCancelDialog);
    }

    public DialogExpire(BaseActivity activity, ProductUtil.ExpireListener listener, boolean isCreatorOrAdmintor, String proNames, boolean isAddPerson) {
        super(activity, R.style.network_dialog_style);
        this.listener = listener;
        createLayout(activity, isCreatorOrAdmintor, proNames, isAddPerson);
        commendAttribute(true);
    }


    @TargetApi(Build.VERSION_CODES.HONEYCOMB)
    public void createLayout(final Activity activity, boolean isCreatorOrAdmintor, String proNames, boolean isAddPerson) {
        setContentView(R.layout.expire_dialog);
        View degradeFreeVersionText = findViewById(R.id.degradeFreeVersionText);
        TextView proNameText = (TextView) findViewById(R.id.proName);
        TextView expireTipsText = (TextView) findViewById(R.id.expireTipsText);
        TextView tipsTitleText = (TextView) findViewById(R.id.tipsTitleText);
        tipsTitleText.setVisibility(isAddPerson ? View.GONE : View.VISIBLE);
        expireTipsText.setText(isAddPerson ? "订购的黄金服务版已过期暂时不能添加成员" : "订购的黄金服务版已过期");
        proNameText.setText("\"" + proNames + "\"");
        degradeFreeVersionText.setVisibility(isCreatorOrAdmintor ? View.VISIBLE : View.GONE); //如果是管理员需要显示降级处理操作
        degradeFreeVersionText.setOnClickListener(this);
        findViewById(R.id.nowReNewText).setOnClickListener(this);
    }

    @Override
    public void onClick(View v) {
        dismiss();
        if (listener == null) {
            return;
        }
        switch (v.getId()) {
            case R.id.degradeFreeVersionText: //降级使用免费版
                listener.degradeFreeVersion();
                break;
            case R.id.nowReNewText: //立即续期
                listener.nowRenew();
                break;
        }
    }


}
