package com.jizhi.jlongg.main.adpter;

import android.app.Activity;
import android.graphics.Bitmap;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.hcs.uclient.utils.LUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BitmapCache;
import com.jizhi.jlongg.main.activity.BitmapCache.ImageCallback;
import com.jizhi.jlongg.main.bean.ImageBucket;

import java.util.List;

public class ImageBucketAdapter extends BaseAdapter {
    final String TAG = getClass().getSimpleName();

    Activity activity;
    /**
     * 图片集列表
     */
    List<ImageBucket> dataList;
    BitmapCache cache;
    ImageCallback callback = new ImageCallback() {
        @Override
        public void imageLoad(ImageView imageView, Bitmap bitmap,Object... params) {
            if (imageView != null && bitmap != null){
                String url = (String) params[0];
                if (url != null && url.equals(imageView.getTag())) {
                    imageView.setImageBitmap(bitmap);
                } else {
                    LUtils.e(TAG,"callback bmp not match");
                }
            } else {
                LUtils.e(TAG,"callback bmp null");
            }
        }
    };

    public ImageBucketAdapter(Activity activity, List<ImageBucket> list) {
        this.activity = activity;
        dataList = list;
        cache = new BitmapCache();
    }

    @Override
    public int getCount() {
        return dataList == null ? 0 : dataList.size();
    }

    @Override
    public Object getItem(int arg0) {
        return null;
    }

    @Override
    public long getItemId(int arg0) {
        return arg0;
    }

    class Holder {
        private ImageView iv;
        private ImageView selected;
        private TextView name;
//        private TextView count;
    }

    @Override
    public View getView(int position, View converview, ViewGroup arg2) {
        Holder holder;
        if (converview == null) {
            holder = new Holder();
            converview = View.inflate(activity, R.layout.item_image_bucket, null);
            holder.iv = (ImageView) converview.findViewById(R.id.image);
            holder.selected = (ImageView) converview.findViewById(R.id.isselected);
            holder.name = (TextView) converview.findViewById(R.id.name);
            converview.setTag(holder);
        } else {
            holder = (Holder) converview.getTag();
        }
        ImageBucket item = dataList.get(position);
        if (item.isSelected) {
            holder.selected.setImageResource(R.drawable.icon_data_select);
        } else {
            holder.selected.setImageResource(-1);
        }
        holder.name.setText(item.bucketName+"共("+ item.count+")张");
        if (item.imageList != null && item.imageList.size() > 0) {
            String thumbPath = item.imageList.get(0).thumbnailPath;
            String sourcePath = item.imageList.get(0).imagePath;
            holder.iv.setTag(sourcePath);
            cache.displayBmp(holder.iv, thumbPath, sourcePath, callback);
        } else {
            holder.iv.setImageBitmap(null);
            LUtils.e(TAG,"no images in bucket "+ item.bucketName);
        }
        return converview;
    }

}
