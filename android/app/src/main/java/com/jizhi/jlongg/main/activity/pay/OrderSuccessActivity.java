package com.jizhi.jlongg.main.activity.pay;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.text.Html;
import android.view.View;
import android.widget.TextView;

import com.hcs.uclient.utils.CallPhoneUtil;
import com.hcs.uclient.utils.LUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.ProductUtil;


/**
 * CName:订单支付成功页面
 * User: hcs
 * Date: 2017-08-16
 * Time: 11:08
 */
public class OrderSuccessActivity extends BaseActivity implements View.OnClickListener {


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        LUtils.e("sssssssss");
        setContentView(R.layout.activity_order_susses);
        setTextTitle(R.string.order_success);
        findViewById(R.id.returnText).setVisibility(View.GONE); //隐藏返回按钮
        TextView tipsText = getTextView(R.id.tips);
        tipsText.setText(Html.fromHtml("<font color='#b9b9b9'>如有疑问,请联系客服</font><font color='#eb4e4e'>400-862-3818</font>"));
        tipsText.setOnClickListener(this);
    }

    /**
     * 启动当前Activity
     *
     * @param activity
     */
    public static void actionStart(Activity activity) {
        Intent intent = new Intent(activity, OrderSuccessActivity.class);
        activity.startActivityForResult(intent, Constance.REQUEST_PAY);
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.btn_home:
                setResult(ProductUtil.PAID_GO_HOME);
                finish();
                break;
            case R.id.btn_order:
                setResult(ProductUtil.PAID_GO_TO_ORDERLIST);
                finish();
                break;
            case R.id.tips:
                CallPhoneUtil.callPhone(this, "4008623818");
                break;
        }
    }

    @Override
    public void onBackPressed() {
        setResult(ProductUtil.PAID_GO_HOME);
        finish();
    }
}
