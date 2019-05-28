package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.view.ViewPager.OnPageChangeListener;
import android.view.View;
import android.widget.TextView;

import com.hcs.uclient.utils.LUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.adpter.PhotoZoomDetailAdapter;
import com.jizhi.jlongg.main.bean.ImageItem;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.recoed.manager.AudioRecordMessageButton.FileUtils;

import java.io.File;
import java.util.ArrayList;
import java.util.UUID;

import me.kareluo.imaging.IMGEditActivity;
import uk.co.senab.photoview.PViewPager;

/**
 * 图片缩放
 *
 * @author Xuj
 * @date 2015年12月2日 17:33:27
 */
public class PhotoZoomActivity extends Activity {

    /**
     * 图片数据
     */
    private ArrayList<ImageItem> paths;

    /**
     * 初始索引
     */
    private int initPosition = 0;

    /**
     * 使用修复了android系统缩放Bug的ViewPager
     */
    private PViewPager viewPagerImgs;//

    /**
     * 显示的标题
     */
    private TextView txtTitle;// 显示标题

    /**
     * adapter
     */
    private PhotoZoomDetailAdapter adapter;
    private File mImageFile;
    public int positionn;

    @Override
    protected void onDestroy() {
        super.onDestroy();
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.zoom_viewpager);
        initView();

    }

    public static void actionStart(Activity activity, ArrayList<ImageItem> photos, int position, boolean isEditPic) {
        Intent intent = new Intent(activity, PhotoZoomActivity.class);
        Bundle bundle = new Bundle();
        bundle.putSerializable(Constance.BEAN_CONSTANCE, photos);
        bundle.putInt(Constance.BEAN_INT, position);
        bundle.putBoolean(Constance.BEAN_BOOLEAN, isEditPic);
        intent.putExtras(bundle);
        activity.startActivityForResult(intent, Constance.REQUESTCODE_MSGEDIT);
        activity.overridePendingTransition(R.anim.scale_open_action, 0);
    }

    public void initView() {
        Bundle bundle = getIntent().getExtras();
        viewPagerImgs = (PViewPager) findViewById(R.id.frashowimgs_pager);
        txtTitle = (TextView) findViewById(R.id.showimgs_txt_title);
        paths = (ArrayList<ImageItem>) bundle.getSerializable(Constance.BEAN_CONSTANCE);
        initPosition = bundle.getInt(Constance.BEAN_INT);
        adapter = new PhotoZoomDetailAdapter(paths, this);
        viewPagerImgs.setAdapter(adapter);
        //是否隐藏数字标签
        txtTitle.setVisibility(View.GONE);
        findViewById(R.id.btn_edit).setVisibility(getIntent().getBooleanExtra(Constance.BEAN_BOOLEAN, false) ? View.VISIBLE : View.GONE);
        viewPagerImgs.setOnPageChangeListener(new OnPageChangeListener() {
            @Override
            public void onPageSelected(int position) {
                positionn = position;
                if (paths != null) {
                    txtTitle.setText(String.format(getString(R.string.format_showimgs_txt_title), position + 1, paths.size()));
                }

            }

            @Override
            public void onPageScrolled(int arg0, float arg1, int arg2) {
            }

            @Override
            public void onPageScrollStateChanged(int arg0) {
            }
        });
        viewPagerImgs.setCurrentItem(initPosition);
        try {
            txtTitle.setText(String.format(getString(R.string.format_showimgs_txt_title), initPosition + 1, paths.size()));
        } catch (Exception e) {
            e.printStackTrace();
        }
        findViewById(R.id.btn_edit).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(PhotoZoomActivity.this, IMGEditActivity.class);
                intent.putExtra(IMGEditActivity.EXTRA_IMAGE_URI, "file://" + paths.get(viewPagerImgs.getCurrentItem()).imagePath);
                String filePath = FileUtils.getAppDir(PhotoZoomActivity.this) + "/" + UUID.randomUUID().toString() + ".jpg";
                mImageFile = new File(filePath);
                intent.putExtra(IMGEditActivity.EXTRA_IMAGE_SAVE_PATH, mImageFile.getAbsolutePath());
                startActivityForResult(intent, Constance.REQUESTCODE_MSGEDIT);
            }
        });
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == Constance.REQUESTCODE_MSGEDIT && resultCode == RESULT_OK) {
            LUtils.e(viewPagerImgs.getCurrentItem() + ",,,,,,,,,,,,,," + mImageFile.getAbsolutePath());
            Intent intent = new Intent();
            intent.putExtra(Constance.BEAN_STRING, mImageFile.getAbsolutePath());
            intent.putExtra(Constance.BEAN_INT, viewPagerImgs.getCurrentItem());
            setResult(RESULT_OK, intent);
            finish();

        }
    }

//    @Override
//    public void onBackPressed() {
//        super.onBackPressed();
//        Intent intent = new Intent();
//        Bundle bundle = new Bundle();
//        bundle.putSerializable(Constance.BEAN_CONSTANCE, paths);
//        intent.putExtras(bundle);
//        setResult(RESULT_OK, intent);
//    }


    /**
     * 关闭本页面执行的动画
     */
    public void finishExecuteAnimActivity() {
        finish();
        overridePendingTransition(0, R.anim.scale_close_action);
    }


    @Override
    public void onBackPressed() {
        finishExecuteAnimActivity();
    }
}
