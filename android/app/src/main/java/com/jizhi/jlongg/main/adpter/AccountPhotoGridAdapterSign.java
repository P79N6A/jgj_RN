package com.jizhi.jlongg.main.adpter;

import android.Manifest;
import android.annotation.TargetApi;
import android.app.Activity;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.RelativeLayout;

import com.hcs.uclient.utils.UtilImageLoader;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.listener.OnSquaredImageRemoveClick;
import com.jizhi.jlongg.main.activity.PhotoZoomActivity;
import com.jizhi.jlongg.main.bean.ImageItem;
import com.jizhi.jlongg.main.util.CameraPop;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.jizhi.jlongg.utis.acp.Acp;
import com.jizhi.jlongg.utis.acp.AcpListener;
import com.jizhi.jlongg.utis.acp.AcpOptions;
import com.nostra13.universalimageloader.core.ImageLoader;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

/**
 * 功能:记账 备注图片上传Adapter
 * 时间:2016-6-1 10:39
 * 作者:xuj
 */
public class AccountPhotoGridAdapterSign extends BaseAdapter {
    /**
     * gridView 图片列表
     */
    private List<ImageItem> list;
    /**
     * xml解析器
     */
    private LayoutInflater inflater;
    /***
     * 图片删除回调
     */
    private OnSquaredImageRemoveClick listener;
    /**
     * 最大图片上传数
     */
    private final int max;
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


    public AccountPhotoGridAdapterSign(Activity context, List<ImageItem> list, OnSquaredImageRemoveClick listener, int max) {
        this.context = context;
        this.list = list;
        this.max = max;
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
        return list == null ? 1 : list.size() + 1;


    }

    @Override
    public Object getItem(int position) {
        return list.get(position);
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    @TargetApi(Build.VERSION_CODES.JELLY_BEAN)
    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        int type = getItemViewType(position);
        switch (type) {
            case TYPE_CAMERA:
                convertView = inflater.inflate(R.layout.account_picture_layout, parent, false);
                convertView.findViewById(R.id.image).setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        intentSelectedPhoto();
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
                    position -= 1;
                    bindData(holder, position);
                }
                break;
        }
        return convertView;
    }


    public void bindData(final ViewHolder holder, final int position) {
        final ImageItem item = list.get(position);
        String fileUrl = null;
        if (item.isNetPicture) {//是否是网络图片
            fileUrl = NetWorkRequest.NETURL + item.imagePath;
        } else { //本地图片
            fileUrl = "file://" + item.imagePath;
        }
        if (holder.image.getTag() != null && holder.image.getTag().equals(fileUrl + position)) {

        } else {
            // 如果不相同，就加载。现在在这里来改变闪烁的情况
            ImageLoader.getInstance().displayImage(fileUrl, holder.image, UtilImageLoader.getExperienceOptions());
            holder.image.setTag(fileUrl + position);
        }
        holder.remove_layout.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (listener != null) {
                    listener.remove(position);
                }
            }
        });
        holder.image.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Bundle bundle = new Bundle();
                bundle.putSerializable(Constance.BEAN_CONSTANCE, (Serializable) item);
                bundle.putInt(Constance.BEAN_INT, position);
                Intent intent = new Intent(context, PhotoZoomActivity.class);
                intent.putExtras(bundle);
                context.startActivity(intent);
            }
        });

    }


    public class ViewHolder {

        public ViewHolder(View view) {
            image = (ImageView) view.findViewById(R.id.image);
            remove_layout = (RelativeLayout) view.findViewById(R.id.remove_layout);
        }

        private ImageView image;
        private RelativeLayout remove_layout;
    }

    public void updateGridView(List<ImageItem> list) {
        this.list = list;
        notifyDataSetChanged();
    }

    public List<ImageItem> getList() {
        return list;
    }

    public void setList(List<ImageItem> list) {
        this.list = list;
    }

    /**
     * 当前已选图片路径
     */
    public ArrayList<String> selectedPhotoPath() {
        ArrayList<String> mSelected = new ArrayList<String>();
        int size = list.size();
        for (int i = 0; i < size; i++) {
            ImageItem item = list.get(i);
            mSelected.add(item.imagePath);

        }
        return mSelected;
    }


    public void intentSelectedPhoto() {
        Acp.getInstance(context).request(new AcpOptions.Builder().setPermissions(Manifest.permission.READ_EXTERNAL_STORAGE, Manifest.permission.CAMERA).build(),
                new AcpListener() {
                    @Override
                    public void onGranted() {
                        Acp.getInstance(context).request(new AcpOptions.Builder().setPermissions(Manifest.permission.READ_EXTERNAL_STORAGE
                                , Manifest.permission.CAMERA).build(),
                                new AcpListener() {
                                    @Override
                                    public void onGranted() {
                                        ArrayList<String> mSelected = selectedPhotoPath();
                                        CameraPop.multiSelector(context, mSelected, max);
                                    }

                                    @Override
                                    public void onDenied(List<String> permissions) {
                                        CommonMethod.makeNoticeShort(context, context.getResources().getString(R.string.permission_close), CommonMethod.ERROR);
                                    }
                                });


                    }

                    @Override
                    public void onDenied(List<String> permissions) {
                        CommonMethod.makeNoticeShort(context, context.getResources().getString(R.string.permission_close), CommonMethod.ERROR);
                    }
                });
    }
}
