package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.util.Constance;

/**
 * 功能:选择同步类型
 * 时间:2018年4月19日10:37:10
 * 作者:xuj
 */
public class SelecteSyncTypeActivity extends BaseActivity implements View.OnClickListener {


    /**
     * 启动当前Activity
     *
     * @param context
     */
    public static void actionStart(Activity context) {
        Intent intent = new Intent(context, SelecteSyncTypeActivity.class);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.selecte_sync_type);
        setTextTitle(R.string.selecte_sync_type);
    }


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.syncRecordAccount: //同步记工记账
                AddSyncActivity.actionStart(this, "1");
                break;
            case R.id.syncAccount: //同步记工
                AddSyncActivity.actionStart(this, "2");
                break;
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == Constance.SYNC_SUCCESS) {
            setResult(Constance.SYNC_SUCCESS);
            finish();
        }
    }
}
