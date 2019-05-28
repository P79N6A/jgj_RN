package com.jizhi.jlongg.main.adpter;

import android.app.Activity;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.drawable.BitmapDrawable;
import android.support.v4.view.PagerAdapter;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.hcs.uclient.utils.UtilImageLoader;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.ImageItem;
import com.jizhi.jlongg.main.util.ImageUtil;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.jizhi.jongg.widget.CircleProgressView;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.nostra13.universalimageloader.core.assist.FailReason;
import com.nostra13.universalimageloader.core.listener.ImageLoadingListener;
import com.nostra13.universalimageloader.core.listener.ImageLoadingProgressListener;

import java.util.List;

import uk.co.senab.photoview.PhotoView;
import uk.co.senab.photoview.PhotoViewAttacher.OnPhotoTapListener;

/**
 * 图片缩放Adapter
 *
 * @author xuj
 * @date 2015年8月27日 13:06:01
 */
public class PhotoZoomDetailAdapter extends PagerAdapter {

    private List<ImageItem> paths;

    private Activity activity;

    public PhotoZoomDetailAdapter(List<ImageItem> list_photos, Activity activity) {
        this.paths = list_photos;
        this.activity = activity;
    }

    public void updateGridView(List<ImageItem> list) {
        this.paths = list;
        notifyDataSetChanged();
    }

    @Override
    public int getCount() {
        return paths == null ? 0 : paths.size();
    }

    @Override
    public View instantiateItem(ViewGroup container, int position) {
        LayoutInflater li = (LayoutInflater) container.getContext().getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        View view = li.inflate(R.layout.item_images_zoom, container, false);
        final PhotoView photoView = (PhotoView) view.findViewById(R.id.image);
        String imageUri = null;
        final ImageItem bean = paths.get(position);
        if (!bean.isNetPicture) {
            imageUri = "file:///" + bean.imagePath;
        } else {
            imageUri = NetWorkRequest.NETURL + bean.imagePath;
        }
        photoView.setOnPhotoTapListener(new OnPhotoTapListener() {
            @Override
            public void onPhotoTap(View arg0, float arg1, float arg2) {
                activity.finish();
                activity.overridePendingTransition(0, R.anim.scale_close_action);
            }
        });
//        ImageLoader.getInstance().displayImage(imageUri, photoView, UtilImageLoader.getExperienceOptions());
        final CircleProgressView circleProgressbar = (CircleProgressView) view.findViewById(R.id.circleProgressbar);
        ImageLoader.getInstance().displayImage(imageUri, photoView, UtilImageLoader.loadCloudOptions(activity), new ImageLoadingListener() {
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
                if (bean.isCamenrPicture) {
                    //原始图片
                    Bitmap sourBitmap = (((BitmapDrawable) photoView.getDrawable()).getBitmap());
                    //水印图片背景
                    Bitmap waterBitmap = BitmapFactory.decodeResource(activity.getResources(), R.drawable.water_bgs);
                    //加文字后的水印图片
                    Bitmap waterTextBitmap = ImageUtil.drawTextBottom(activity, waterBitmap);
                    //加文字水印完成后的图片
                    Bitmap newBitmap = ImageUtil.createWaterMaskBitmap(activity, sourBitmap, waterTextBitmap);
                    photoView.setImageBitmap(newBitmap);
                }
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
