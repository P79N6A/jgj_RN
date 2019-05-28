package com.jizhi.jlongg.main.message;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.os.Bundle;
import android.os.Parcelable;
import android.support.v4.view.PagerAdapter;
import android.support.v4.view.ViewPager;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.view.WindowManager;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.bumptech.glide.Glide;
import com.bumptech.glide.request.target.Target;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.application.GlideApp;
import com.jizhi.jlongg.main.dialog.SavaPicDialog;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.GlideUtils;
import com.jizhi.jlongg.network.NetWorkRequest;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ExecutionException;

import uk.co.senab.photoview.PhotoView;
import uk.co.senab.photoview.PhotoViewAttacher;

/**
 * CName:大图浏览
 * User: hcs
 * Date: 2016-09-01
 * Time: 14.42
 */
public class MessageImagePagerActivity extends Activity {
    public static final String INTENT_IMGURLS = "imgurls";
    public static final String INTENT_POSITION = "position";
    public static final String INTENT_IMAGESIZE = "imagesize";
    public static final String IMAGE_DIV = "imagediv";
    public static final String GONEPAGE = "GONEPAGE";
    private List<View> guideViewList = new ArrayList<View>();
    private LinearLayout guideGroup;
    public ImageSize imageSize;
    public String imagediv;
    private int startPos;
    private ArrayList<String> imgUrls;
    private TextView tv_guide;

    public static void startImagePagerActivity(Activity context, List<String> imgUrls, int position, ImageSize imageSize, boolean gonepage) {
        Intent intent = new Intent(context, MessageImagePagerActivity.class);
        intent.putStringArrayListExtra(INTENT_IMGURLS, new ArrayList<String>(imgUrls));
        intent.putExtra(INTENT_POSITION, position);
        intent.putExtra(INTENT_IMAGESIZE, imageSize);
        intent.putExtra(GONEPAGE, gonepage);
        context.startActivity(intent);
        context.overridePendingTransition(R.anim.scale_open_action, 0);

    }

    public static void startImagePagerActivity(Activity context, List<String> imgUrls, int position, ImageSize imageSize) {
        Intent intent = new Intent(context, MessageImagePagerActivity.class);
        intent.putStringArrayListExtra(INTENT_IMGURLS, new ArrayList<String>(imgUrls));
        intent.putExtra(INTENT_POSITION, position);
        intent.putExtra(INTENT_IMAGESIZE, imageSize);
        context.startActivity(intent);
        context.overridePendingTransition(R.anim.scale_open_action, 0);
    }

    public static void startImagePagerActivity(Activity context, List<String> imgUrls, int position, ImageSize imageSize, String imgdiv) {
        Intent intent = new Intent(context, MessageImagePagerActivity.class);
        intent.putStringArrayListExtra(INTENT_IMGURLS, new ArrayList<String>(imgUrls));
        intent.putExtra(INTENT_POSITION, position);
        intent.putExtra(INTENT_IMAGESIZE, imageSize);
        intent.putExtra(IMAGE_DIV, imgdiv);
        context.startActivity(intent);
        context.overridePendingTransition(R.anim.scale_open_action, 0);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        //去除title
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        //去掉Activity上面的状态栏
        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN,
                WindowManager.LayoutParams.FLAG_FULLSCREEN);
        setContentView(R.layout.activity_imagepager);
        ViewPager viewPager = (ViewPager) findViewById(R.id.pager);
        guideGroup = (LinearLayout) findViewById(R.id.guideGroup);
        tv_guide = (TextView) findViewById(R.id.tv_guide);
        getIntentData();
        if (imgUrls.size() <= 1) {
            tv_guide.setVisibility(View.GONE);
        }
        ImageAdapter mAdapter = new ImageAdapter(this, imagediv);
        mAdapter.setDatas(imgUrls);
        mAdapter.setImageSize(imageSize);
        viewPager.setAdapter(mAdapter);
        viewPager.addOnPageChangeListener(new ViewPager.OnPageChangeListener() {

            @Override
            public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {

            }

            @Override
            public void onPageSelected(int position) {
                if (imgUrls.size() > 1) {
                    tv_guide.setVisibility(View.VISIBLE);
                    tv_guide.setText((position + 1) + "/" + imgUrls.size());
                } else {
                    tv_guide.setVisibility(View.GONE);
                }
                if (getIntent().getBooleanExtra(GONEPAGE, false)) {
                    tv_guide.setVisibility(View.GONE);
                }
            }

            @Override
            public void onPageScrollStateChanged(int state) {

            }
        });
        viewPager.setCurrentItem(startPos);

        addGuideView(guideGroup, startPos, imgUrls);
        findViewById(R.id.lay).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });


    }

    private void getIntentData() {
        startPos = getIntent().getIntExtra(INTENT_POSITION, 0);
        imgUrls = getIntent().getStringArrayListExtra(INTENT_IMGURLS);
        imageSize = (ImageSize) getIntent().getSerializableExtra(INTENT_IMAGESIZE);
        imagediv = getIntent().getStringExtra(IMAGE_DIV);
        if (getIntent().getBooleanExtra(GONEPAGE, false)) {
            tv_guide.setVisibility(View.GONE);
        }
    }

    private void addGuideView(LinearLayout guideGroup, int startPos, ArrayList<String> imgUrls) {
        if (imgUrls != null && imgUrls.size() > 0) {
            guideViewList.clear();
            tv_guide.setText((startPos + 1) + "/" + imgUrls.size());
//            for (int i = 0; i < imgUrls.size(); i++) {
//                View view = new View(this);
//                view.setBackgroundResource(R.drawable.selector_guide_bg);
//                view.setSelected(i == startPos ? true : false);
//                LinearLayout.LayoutParams layoutParams = new LinearLayout.LayoutParams(getResources().getDimensionPixelSize(R.dimen.gudieview_width),
//                        getResources().getDimensionPixelSize(R.dimen.gudieview_heigh));
//                layoutParams.setMargins(DensityUtils.dp2px(MessageImagePagerActivity.this, 10), 0, 0, DensityUtils.dp2px(MessageImagePagerActivity.this, 15));
//                guideGroup.addView(view, layoutParams);
//                guideViewList.add(view);
//            }
        }
    }

    @Override
    public boolean dispatchTouchEvent(MotionEvent ev) {
        try {
            return super.dispatchTouchEvent(ev);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    private static class ImageAdapter extends PagerAdapter {

        private List<String> datas = new ArrayList<String>();
        private LayoutInflater inflater;
        private Context context;
        private ImageSize imageSize;
        private ImageView smallImageView = null;
        private String imagediv;
        private String imgurl;

        public void setDatas(List<String> datas) {
            if (datas != null)
                this.datas = datas;
        }

        public void setImageSize(ImageSize imageSize) {
            this.imageSize = imageSize;
        }

        public ImageAdapter(Context context, String imagediv) {
            this.context = context;
            this.imagediv = imagediv;
            this.inflater = LayoutInflater.from(context);
        }

        @Override
        public int getCount() {
            if (datas == null) return 0;
            return datas.size();
        }

        Bitmap bm;

        @Override
        public Object instantiateItem(ViewGroup container, final int position) {
            View view = inflater.inflate(R.layout.item_pager_image, container, false);
            if (view != null) {
                final PhotoView imageView = (PhotoView) view.findViewById(R.id.image);
                FrameLayout frame = (FrameLayout) view.findViewById(R.id.frame);
                frame.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        ((Activity) context).finish();
                    }
                });

                if (imageSize != null) {
                    //预览imageView
                    smallImageView = new ImageView(context);
                    FrameLayout.LayoutParams layoutParams = new FrameLayout.LayoutParams(imageSize.getWidth(), imageSize.getHeight());
                    layoutParams.gravity = Gravity.CENTER;
                    smallImageView.setLayoutParams(layoutParams);
                    smallImageView.setScaleType(ImageView.ScaleType.CENTER_CROP);
                    ((FrameLayout) view).addView(smallImageView);
                }
                imageView.setOnPhotoTapListener(new PhotoViewAttacher.OnPhotoTapListener() {

                    @Override
                    public void onPhotoTap(View arg0, float arg1, float arg2) {
                        ((Activity) context).finish();
                    }
                });

//                final String imgurl = NetWorkRequest.IP_ADDRESS + datas.get(position);
                if (TextUtils.isEmpty(imagediv)) {
                    imgurl = NetWorkRequest.CDNURL + datas.get(position);
                } else {
                    imgurl = imagediv + datas.get(position);
                }

                if (!imgurl.contains("/storage/")) {
                    new GlideUtils().glideImage(context, imgurl, imageView, R.drawable.icon_message_fail_default, R.drawable.icon_message_fail_default);
                } else {
                    new GlideUtils().glideImage(context, "file://" + datas.get(position), imageView, R.drawable.icon_message_fail_default, R.drawable.icon_message_fail_default);
                }

                new Thread(new Runnable() {
                    @Override
                    public void run() {
                        try {
                            bm = GlideApp.with(context)
                                    .asBitmap()
                                    .load(imgurl)
                                    .into(Target.SIZE_ORIGINAL, Target.SIZE_ORIGINAL)
                                    .get();

                        } catch (InterruptedException e) {
                            e.printStackTrace();
                        } catch (ExecutionException e) {
                            e.printStackTrace();
                        }
                    }
                }).start();
                imageView.setOnLongClickListener(new View.OnLongClickListener() {
                    @Override
                    public boolean onLongClick(View v) {
                        if (null == bm) {
                            CommonMethod.makeNoticeLong(context, "图片保存失败", CommonMethod.ERROR);
                            return false;
                        }
                        SavaPicDialog savaPicDialog = new SavaPicDialog(context, bm);
                        savaPicDialog.show();
                        return false;
                    }
                });
                container.addView(view, 0);
            }
            return view;
        }

        @Override
        public void destroyItem(ViewGroup container, int position, Object object) {
            container.removeView((View) object);
        }

        @Override
        public boolean isViewFromObject(View view, Object object) {
            return view.equals(object);
        }

        @Override
        public void restoreState(Parcelable state, ClassLoader loader) {
        }

        @Override
        public Parcelable saveState() {
            return null;
        }


    }

    @Override
    protected void onDestroy() {
        guideViewList.clear();
        super.onDestroy();
    }

    public static class ImageSize implements Serializable {

        private int width;
        private int height;

        public ImageSize(int width, int height) {
            this.width = width;
            this.height = height;
        }

        public int getHeight() {
            return height;
        }

        public void setHeight(int height) {
            this.height = height;
        }

        public int getWidth() {
            return width;
        }

        public void setWidth(int width) {
            this.width = width;
        }
    }


    @Override
    public void finish() {
        super.finish();
        overridePendingTransition(0, R.anim.scale_close_action);
    }

}
