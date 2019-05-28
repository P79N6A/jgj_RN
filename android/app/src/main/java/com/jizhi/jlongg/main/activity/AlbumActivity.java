package com.jizhi.jlongg.main.activity;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.graphics.Bitmap;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.GridView;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.adpter.ImageBucketAdapter;
import com.jizhi.jlongg.main.bean.ImageBucket;
import com.jizhi.jlongg.main.bean.ImageItem;
import com.jizhi.jlongg.main.bean.SerializableMap;
import com.jizhi.jlongg.main.util.AlbumHelper;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.SetTitleName;

import java.io.Serializable;
import java.util.List;

/**
 * 功能:相册列表
 * 时间:2016/3/13 17:50
 * 作者:xuj
 */
@SuppressLint("NewApi")
public class AlbumActivity extends BaseActivity {
    /**
     * 缩略图数据
     */
    private List<ImageBucket> dataList;
    /**
     * 适配器
     */
    private ImageBucketAdapter adapter;
    /**
     * 确认按钮
     */
    private TextView sure_button;
    /**
     * 剩下还能选择图片的个数
     */
    private int MAX = 9;

    private SerializableMap map;

    public static Bitmap bimap;


    static{

    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_image_bucket);
        SetTitleName.setTitle(findViewById(R.id.title), getString(R.string.photo_list));
        AlbumHelper helper = AlbumHelper.getHelper();
        helper.init(getApplicationContext());
        dataList = helper.getImagesBucketList(false);
        initData();
        initView();
    }

    /**
     * 初始化数据
     */
    private void initData() {
        MAX = getIntent().getIntExtra("MAX",0);
    }

    /**
     * 初始化view视图
     */
    private void initView() {
        GridView gridView = (GridView) findViewById(R.id.gridview);
        sure_button = (TextView) findViewById(R.id.right_title);
        sure_button.setAlpha(0.5F);
        sure_button.setClickable(false);
        sure_button.setText("确定");
        adapter = new ImageBucketAdapter(AlbumActivity.this, dataList);
        gridView.setAdapter(adapter);
        gridView.setOnItemClickListener(new OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                if(map== null){
                    map = new SerializableMap();
                }
                Intent intent = new Intent(AlbumActivity.this,AlbumDetailActivity.class);
                intent.putExtra(Constance.BEAN_CONSTANCE,map);
                intent.putExtra(Constance.BEAN_ARRAY,(Serializable)dataList.get(position).imageList);
                intent.putExtra(Constance.BEAN_INT, position);
                intent.putExtra("MAX", MAX);
                System.out.println("MAX---------2-------------" + MAX);
                startActivityForResult(intent, Constance.RETURN);
            }
        });
    }


    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == Constance.RETURN) {
            if (data != null) {
                List<ImageItem> tempList = (List<ImageItem>) data.getSerializableExtra(Constance.BEAN_ARRAY);
                SerializableMap tempMap =  (SerializableMap) data.getSerializableExtra(Constance.BEAN_CONSTANCE);
                int position = data.getIntExtra(Constance.BEAN_INT,-1);
                int size = map.getMap().size();
                if(size != 0){
                    sure_button.setText("确定" + '(' + size + ')');
                    sure_button.setAlpha(1.0F);
                    sure_button.setClickable(true);
                }else{
                    sure_button.setText("确定");
                    sure_button.setAlpha(0.5F);
                    sure_button.setClickable(false);
                }
                if (position!=-1 && dataList.get(position) != null){
                    boolean isChoose = false;
                    for(ImageItem item:tempList){
                        if(item.isSelected){
                            isChoose = true;
                            break;
                        }
                    }
                    if(isChoose){
                        dataList.get(position).isSelected = true;
                    }else{
                        dataList.get(position).isSelected = false;
                    }
                    dataList.get(position).imageList.clear();
                    dataList.get(position).imageList.addAll(tempList);
                    map.getMap().clear();
                    map.getMap().putAll(tempMap.getMap());
                    adapter.notifyDataSetChanged();
                }
            } else {
                CommonMethod.makeNoticeShort(this, "选择失败",CommonMethod.ERROR);
            }
        } else if (resultCode == Constance.PHOTO_REQUEST_AlBUM){ //点击确定回调
//            Serializable se = (Serializable)data.getSerializableExtra(Constance.BEAN_ARRAY);
//            Intent intent = getIntent();
//            intent.putExtra(Constance.BEAN_ARRAY,data.getSe);
            setResult(Constance.PHOTO_REQUEST_AlBUM, data);
            finish();
        }
    }
}
