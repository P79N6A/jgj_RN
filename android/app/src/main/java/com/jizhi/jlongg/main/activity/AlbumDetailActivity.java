package com.jizhi.jlongg.main.activity;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.GridView;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.adpter.ImageGridAdapter;
import com.jizhi.jlongg.main.adpter.ImageGridAdapter.TextCallback;
import com.jizhi.jlongg.main.bean.ImageItem;
import com.jizhi.jlongg.main.bean.SerializableMap;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.SetTitleName;

import java.io.Serializable;
import java.util.List;

/**
 * 功能:相册列表详情
 * 时间:2016/3/11 11:51
 * 作者: xuj
 */
@SuppressLint("NewApi")
public class AlbumDetailActivity extends BaseActivity implements OnClickListener {
    /**
     * 图片数据
     */
    private List<ImageItem> dataList;
    /**
     * 确认按钮
     */
    private TextView sure;
    /**
     * 还能选择图片的最大个数
     */
    private int MAX;

    /** 选择的数据 */
    private SerializableMap map;


    Handler mHandler = new Handler() {
        @Override
        public void handleMessage(Message msg) {
            switch (msg.what) {
                case 0:
                    CommonMethod.makeNoticeShort(AlbumDetailActivity.this,"只能选择" + MAX + "张图片",CommonMethod.ERROR);
                    break;
                default:
                    break;
            }
        }
    };

    /***
     * 设置返回值
     */
    public void setReturnValue() {
        Intent intent = new Intent();
        intent.putExtra(Constance.BEAN_ARRAY, (Serializable) dataList);
        intent.putExtra(Constance.BEAN_INT, getIntent().getIntExtra(Constance.BEAN_INT, -1));
        intent.putExtra(Constance.BEAN_CONSTANCE, map);
        setResult(Constance.RETURN,intent);
    }

    public void onFinish(View view) {
        setReturnValue();
        finish();
    }


    @Override
    public void onBackPressed() {
        setReturnValue();
        super.onBackPressed();
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_image_grid);
        initData();
        initView();
        setButtonStatus();
    }

    public void initData(){
        Intent intent = getIntent();
        MAX = intent.getIntExtra("MAX", 0);
        System.out.println("MAX---------3-------------"+MAX);
        map = (SerializableMap)intent.getSerializableExtra(Constance.BEAN_CONSTANCE);
        dataList = (List<ImageItem>) intent.getSerializableExtra(Constance.BEAN_ARRAY);
    }



    public void setButtonStatus(){
        if (map.getMap().size() != 0){
            sure.setText("确定" + '(' + map.getMap().size() + ')');
            sure.setAlpha(1.0F);
            sure.setClickable(true);
        } else {
            sure.setClickable(false);
            sure.setAlpha(0.5F);
            sure.setText("确定");
        }
    }


    private void initView() {
        sure = (TextView) findViewById(R.id.right_title);
        SetTitleName.setTitle(findViewById(R.id.title), getString(R.string.photo_detail));
        GridView gridView = (GridView) findViewById(R.id.gridview);
        gridView.setSelector(new ColorDrawable(Color.TRANSPARENT));
        ImageGridAdapter adapter = new ImageGridAdapter(this,dataList,mHandler,MAX,map.getMap());
        gridView.setAdapter(adapter);
        adapter.setTextCallback(new TextCallback(){
            public void onListen(int count){
                setButtonStatus();
            }
        });
    }


    @Override
    public void onClick(View v){
        Intent returnIntent = new Intent();
        returnIntent.putExtra(Constance.BEAN_CONSTANCE,map);
        setResult(Constance.PHOTO_REQUEST_AlBUM,returnIntent);
        finish();
    }
}
