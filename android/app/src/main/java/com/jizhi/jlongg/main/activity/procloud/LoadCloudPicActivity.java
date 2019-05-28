package com.jizhi.jlongg.main.activity.procloud;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.os.Bundle;
import android.support.v4.view.PagerAdapter;
import android.support.v4.view.ViewPager;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.view.WindowManager;
import android.widget.TextView;

import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.UtilImageLoader;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.dialog.SavaPicDialog;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jongg.widget.CircleProgressView;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.nostra13.universalimageloader.core.assist.FailReason;
import com.nostra13.universalimageloader.core.listener.ImageLoadingListener;
import com.nostra13.universalimageloader.core.listener.ImageLoadingProgressListener;

import java.util.ArrayList;
import java.util.List;

import uk.co.senab.photoview.PViewPager;
import uk.co.senab.photoview.PhotoView;
import uk.co.senab.photoview.PhotoViewAttacher;

/**
 * Created by Administrator on 2017/8/18 0018.
 */

public class LoadCloudPicActivity extends Activity {

    /**
     * 启动当前Activity
     *
     * @param context
     * @param images          图片集合
     * @param currentPosition 图片选中的下标
     */
    public static void actionStart(Activity context, ArrayList<String> images, int currentPosition) {
        Intent intent = new Intent(context, LoadCloudPicActivity.class);
        intent.putExtra(Constance.BEAN_ARRAY, images);
        intent.putExtra(Constance.POSITION, currentPosition);
        context.startActivityForResult(intent, Constance.REQUEST_IMAGE);
        context.overridePendingTransition(R.anim.scale_open_action, 0);
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE);//取消标题栏
        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN);//取消状态栏
        setContentView(R.layout.zoom_viewpager);
        initView();
    }

    public void initView() {
        Intent intent = getIntent();
        final ArrayList<String> images = (ArrayList<String>) intent.getSerializableExtra(Constance.BEAN_ARRAY);
        findViewById(R.id.btn_edit).setVisibility(View.GONE);
        findViewById(R.id.showimgs_txt_title).setVisibility(View.GONE);
        int currentPosition = intent.getIntExtra(Constance.POSITION, 0);
        if (images == null || images.size() == 0) {
            CommonMethod.makeNoticeLong(this, "获取图片出错", CommonMethod.ERROR);
            finish();
            return;
        }
        final TextView positionText = (TextView) findViewById(R.id.showimgs_txt_title);
        PViewPager pViewPager = (PViewPager) findViewById(R.id.frashowimgs_pager);
        pViewPager.setAdapter(new PicAdapter(images, this));
        pViewPager.setOnPageChangeListener(new ViewPager.OnPageChangeListener() {
            @Override
            public void onPageSelected(int position) {
                positionText.setText(String.format(getString(R.string.format_showimgs_txt_title), position + 1, images.size()));
            }

            @Override
            public void onPageScrolled(int arg0, float arg1, int arg2) {

            }

            @Override
            public void onPageScrollStateChanged(int arg0) {

            }
        });
        pViewPager.setCurrentItem(currentPosition - 1);
        positionText.setText(String.format(getString(R.string.format_showimgs_txt_title), currentPosition, images.size()));
    }


    public class PicAdapter extends PagerAdapter {
        /**
         * 图片路径
         */
        private List<String> images;

        public PicAdapter(List<String> images, Activity activity) {
            this.images = images;
        }

        @Override
        public int getCount() {
            return images == null ? 0 : images.size();
        }

        @Override
        public View instantiateItem(ViewGroup container, int position) {
            LayoutInflater li = (LayoutInflater) container.getContext().getSystemService(Context.LAYOUT_INFLATER_SERVICE);
            View view = li.inflate(R.layout.load_cloud_pic_item, container, false);
            final PhotoView photoView = (PhotoView) view.findViewById(R.id.image);
            final CircleProgressView circleProgressbar = (CircleProgressView) view.findViewById(R.id.circleProgressbar);
            LUtils.e(images.get(position));
            ImageLoader.getInstance().displayImage(images.get(position), photoView, UtilImageLoader.loadCloudOptions(LoadCloudPicActivity.this), new ImageLoadingListener() {
                @Override
                public void onLoadingStarted(String s, View view) {
                    circleProgressbar.setVisibility(View.VISIBLE);
                }

                @Override
                public void onLoadingFailed(String s, View view, FailReason failReason) {
                    circleProgressbar.setVisibility(View.GONE);
                }

                @Override
                public void onLoadingComplete(String s, View view, final Bitmap bitmap) {
                    circleProgressbar.setVisibility(View.GONE);
                    photoView.setOnLongClickListener(new View.OnLongClickListener() { //图片保存 弹出框
                        @Override
                        public boolean onLongClick(View view) {
                            if (null == bitmap) {
                                CommonMethod.makeNoticeLong(getApplicationContext(), "图片获取失败", CommonMethod.ERROR);
                                return false;
                            }
                            SavaPicDialog savaPicDialog = new SavaPicDialog(LoadCloudPicActivity.this, bitmap);
                            savaPicDialog.show();
                            return false;
                        }
                    });

                }

                @Override
                public void onLoadingCancelled(String s, View view) {
                    circleProgressbar.setVisibility(View.GONE);
                }
            }, new ImageLoadingProgressListener() {
                @Override
                public void onProgressUpdate(String imageUri, View view, int current, int total) {
                    int progress = ((int) (((float) current / total) * 100));
                    circleProgressbar.setProgress(progress); //在这里更新 ProgressBar的进度信息
                }
            });
            photoView.setOnPhotoTapListener(new PhotoViewAttacher.OnPhotoTapListener() { //点击图片消失
                @Override
                public void onPhotoTap(View arg0, float arg1, float arg2) {
                    finishExecuteAnimActivity();
                }
            });

            container.addView(view);
            return view;
        }

        @Override
        public void destroyItem(ViewGroup container, int position, Object object) {
            container.removeView((View) object);
        }

        @Override
        public boolean isViewFromObject(View view, Object object) {
            return view == object;
        }
    }


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
