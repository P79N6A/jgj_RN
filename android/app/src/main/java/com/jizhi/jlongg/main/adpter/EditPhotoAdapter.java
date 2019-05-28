package com.jizhi.jlongg.main.adpter;

import android.annotation.TargetApi;
import android.app.Activity;
import android.content.Intent;
import android.graphics.Bitmap;
import android.os.Build;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.RelativeLayout;

import com.hcs.uclient.utils.UtilImageLoader;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.PhotoZoomActivity;
import com.jizhi.jlongg.main.bean.ImageItem;
import com.jizhi.jlongg.main.util.CameraPop;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.nostra13.universalimageloader.core.assist.FailReason;
import com.nostra13.universalimageloader.core.listener.ImageLoadingListener;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

/**
 * 功能:记账 备注图片上传Adapter
 * 时间:2016-6-1 10:39
 * 作者:xuj
 */
public class EditPhotoAdapter extends BaseAdapter {
    /**
     * gridView 图片列表
     */
    private List<ImageItem> imageItems;
    /**
     * 需要删除的网络图片路径
     */
    private List<String> remove_image_pahts;
    /**
     * xml解析器
     */
    private LayoutInflater inflater;
    /***
     * 图片删除回调
     */
    private PhotoDeleteListener listener;
    /**
     * 最大图片上传数
     */
    private final int max = 9;
    /**
     * 相机
     */
    private static final int TYPE_CAMERA = 0;
    /**
     * 相册
     */
    private static final int TYPE_ALBUM = 1;
    /**
     * activity
     */
    private Activity context;

    /**
     * 创建选择的本地图片String的数组
     */
    public ArrayList<String> createLocalPhotoForString() {
        ArrayList<String> mSelected = null;
        int size = imageItems.size();
        for (int i = 0; i < size; i++) {
            if (mSelected == null) {
                mSelected = new ArrayList<String>();
            }
            ImageItem item = imageItems.get(i);
            if (!item.isNetPicture && !TextUtils.isEmpty(item.imagePath)) {  //添加本地图片
                mSelected.add(item.imagePath);
            }
        }
        return mSelected;
    }


    /**
     * 创建选择的本地图片String的数组
     */
    public int net_image_size() {
        int length = 0;
        if (imageItems != null) {
            int size = imageItems.size();
            for (int i = 0; i < size; i++) {
                ImageItem item = imageItems.get(i);
                if (item.isNetPicture) {  //添加本地图片
                    length += 1;
                }
            }
        }
        return length;
    }


    public EditPhotoAdapter(Activity context, List<ImageItem> imageItems, PhotoDeleteListener listener) {
        this.context = context;
        this.imageItems = imageItems;
        this.listener = listener;
        inflater = LayoutInflater.from(context);
    }

    @Override
    public int getViewTypeCount() {
        return 2;
    }

    @Override
    public int getItemViewType(int position) {
        return position == 0 ? TYPE_CAMERA : TYPE_ALBUM;
    }


    @Override
    public int getCount() {
        return imageItems.size();
    }

    @Override
    public Object getItem(int position) {
        return imageItems.get(position);
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    @TargetApi(Build.VERSION_CODES.JELLY_BEAN)
    @Override
    public View getView(final int position, View convertView, ViewGroup parent) {
        int type = getItemViewType(position);
        switch (type) {
            case TYPE_CAMERA:
                convertView = inflater.inflate(R.layout.account_picture_layout, parent, false);
                ImageView image = (ImageView) convertView.findViewById(R.id.image);
                image.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        selectPhoto();
                    }
                });
            case TYPE_ALBUM:
                ViewHolder holder = null;
                if (convertView == null) {
                    convertView = inflater.inflate(R.layout.item_grid_photo, parent, false);
                    holder = new ViewHolder(convertView);
                    convertView.setTag(holder);
                } else {
                    holder = (ViewHolder) convertView.getTag();
                }
                if (holder != null) {
                    bindData(holder, position);
                }
                break;
        }
        return convertView;
    }

    public void selectPhoto() {
        ArrayList<String> mSelected = createLocalPhotoForString();
        CameraPop.multiSelector(context, mSelected, max - net_image_size());
    }

    public void bindData(final ViewHolder holder, final int position) {
        holder.image.setTag(imageItems.get(position).imagePath);
        final ImageItem item = imageItems.get(position);
        String file = null;
        if (item.isNetPicture) {//是否是网络图片
            file = NetWorkRequest.NETURL + item.imagePath;
        } else { //本地图片
            file = "file://" + item.imagePath;
        }

        ImageLoader.getInstance().displayImage(file, holder.image, UtilImageLoader.getExperienceOptions(), new ImageLoadingListener() {
            @Override
            public void onLoadingStarted(String s, View view) {

            }

            @Override
            public void onLoadingFailed(String s, View view, FailReason failReason) {

            }

            @Override
            public void onLoadingComplete(String s, View view, Bitmap bitmap) {
                ImageView imageView = holder.image;
                if (imageView.getTag() != null && imageView.getTag().equals(imageItems.get(position).imagePath)) {
                    if (bitmap != null) {
                        imageView.setImageBitmap(bitmap);
                    }
                }
            }

            @Override
            public void onLoadingCancelled(String s, View view) {

            }
        });
        holder.remove_layout.setOnClickListener(new View.OnClickListener() {//删除点击事件
            @Override
            public void onClick(View v) {
                removePicture(position);
            }
        });

        View.OnClickListener onClickListener = new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                switch (v.getId()) {
                    case R.id.remove_layout:
                        removePicture(position);
                        break;
                    case R.id.image:
                        List<ImageItem> items = new ArrayList<ImageItem>();
                        int size = imageItems.size();
                        for (int i = 1; i < size; i++) {
                            items.add(imageItems.get(i));
                        }
                        Bundle bundle = new Bundle();
                        bundle.putSerializable(Constance.BEAN_CONSTANCE, (Serializable) items);
                        bundle.putInt(Constance.BEAN_INT, position - 1);
                        Intent intent = new Intent(context, PhotoZoomActivity.class);
                        intent.putExtras(bundle);
                        context.startActivity(intent);
                        break;
                }
            }
        };
        holder.remove_layout.setOnClickListener(onClickListener);
        holder.image.setOnClickListener(onClickListener);
    }

    /**
     * 获取删除图片路径
     */
    public List<String> getDeleteNetImage() {
        return remove_image_pahts;
    }


    public void removePicture(int position) {
        ImageItem item = imageItems.get(position);
        if (item.isNetPicture) { //是否是网络图片
            if (remove_image_pahts == null) {
                remove_image_pahts = new ArrayList<String>();
            }
            remove_image_pahts.add(item.imagePath);
        }
        imageItems.remove(position);
        notifyDataSetChanged();
        if (imageItems.size() == 1) {
            listener.imageSizeIsZero();
        }
    }

    /**
     * 图片删除回调
     */
    public interface PhotoDeleteListener {
        /**
         * 当长度等于0的时候回调此方法
         */
        public void imageSizeIsZero();

    }


    public class ViewHolder {

        public ViewHolder(View view) {
            image = (ImageView) view.findViewById(R.id.image);
            remove_layout = (RelativeLayout) view.findViewById(R.id.remove_layout);
        }

        public ViewHolder() {
        }

        ;

        private ImageView image;
        private RelativeLayout remove_layout;
    }
}
