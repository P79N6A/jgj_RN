package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.TextView;

import com.hcs.uclient.utils.AccountUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.util.Constance;

/**
 * 功能:下载页面
 * 时间:2019年2月19日14:52:28
 * 作者:xuj
 */
public class DownLoadExcelActivity extends BaseActivity implements View.OnClickListener {

    /**
     * 启动当前Activity
     *
     * @param context
     * @param downLoadPath 下载地址
     * @param fileName     文件名称
     */
    public static void actionStart(Activity context, String downLoadPath, String fileName) {
        Intent intent = new Intent(context, DownLoadExcelActivity.class);
        intent.putExtra("download_path", downLoadPath);
        intent.putExtra("file_name", fileName);
        context.startActivityForResult(intent, Constance.REQUEST);
    }


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.download_excel);
        initView();
    }

    private void initView() {
        setTextTitle(R.string.download);
        TextView fileNameText = findViewById(R.id.file_name);
        fileNameText.setText(getIntent().getStringExtra("file_name"));
    }


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.share_friend: //分享给好友
                AccountUtils.downLoadExcel(this, getIntent().getStringExtra("download_path"), getIntent().getStringExtra("file_name"), 2);
                break;
            case R.id.download_and_open: //下载并打开
                AccountUtils.downLoadExcel(this, getIntent().getStringExtra("download_path"), getIntent().getStringExtra("file_name"), 1);
                break;
        }
    }
}
