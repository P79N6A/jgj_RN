package com.jizhi.jlongg.main.activity;


import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.View;
import android.widget.Button;
import android.widget.RadioButton;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.dialog.DialogDonateSeniorCloud;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.ProductUtil;


/**
 * 功能: 支付提示页面
 * 作者：huchangsheng
 * 时间: 2017-8-24 11:06
 */


public class PayHintActivity extends BaseActivity implements DialogDonateSeniorCloud.DonateSeniorCloudInterfaceClickListener {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_payhint);
        String titile = getIntent().getStringExtra("title");
        ((TextView) findViewById(R.id.title)).setText(titile);

        TextView tv_help = (TextView) findViewById(R.id.tv_help);
        Button btn_buy = (Button) findViewById(R.id.btn_buy);
        RadioButton rb_state = (RadioButton) findViewById(R.id.rb_state);
        if (getIntent().getIntExtra(Constance.IS_BUYED, 1) == 0) {
            rb_state.setVisibility(View.VISIBLE);
        } else {
            rb_state.setVisibility(View.GONE);
        }
        rb_state.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                String group_id = getIntent().getStringExtra(Constance.GROUP_ID);
                new DialogDonateSeniorCloud(PayHintActivity.this, group_id, PayHintActivity.this).show();

            }
        });
        tv_help.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                X5WebViewActivity.actionStart(PayHintActivity.this, getIntent().getStringExtra("url"));
            }
        });

        btn_buy.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                String group_id = getIntent().getStringExtra(Constance.GROUP_ID);
                if (TextUtils.isEmpty(group_id)) {
                    return;
                }
//                ConfirmVersionOrderNewActivity.actionStart(PayHintActivity.this, group_id);
            }
        });
    }


    public static void actionStart(Activity context, String titile, String group_id, int is_buyed, String url) {
        Intent intent = new Intent();
        intent.setClass(context, PayHintActivity.class);
        intent.putExtra("title", titile);
        intent.putExtra(Constance.GROUP_ID, group_id);
        intent.putExtra(Constance.IS_BUYED, is_buyed);
        intent.putExtra("url", url);
        context.startActivityForResult(intent, Constance.REQUEST_WEB);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == ProductUtil.PAID_GO_TO_ORDERLIST) { //查看订单
            setResult(ProductUtil.PAID_GO_TO_ORDERLIST);
            finish();
        } else if (resultCode == ProductUtil.PAID_GO_HOME) { //返回首页
            setResult(ProductUtil.PAID_GO_HOME);
            finish();
        }
    }

    @Override
    public void donateSeniorCloudSuccess() {
        setResult(Constance.REQUEST_WEB);
        finish();
    }
}
