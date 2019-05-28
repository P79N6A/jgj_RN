package com.jizhi.jlongg.main.adpter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.RelativeLayout;

import com.hcs.uclient.utils.UtilImageLoader;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.listener.OnSquaredImageRemoveClick;
import com.jizhi.jlongg.main.bean.ImageItem;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.nostra13.universalimageloader.core.ImageLoader;

import java.util.List;

/**
 * 功能:九宫格 图片适配器
 * 时间:2016年8月25日 18:15:44
 * 作者:xuj
 */
public class SquaredImageAdapter extends BaseAdapter {

    /**
     * 图片最大上传数
     */
    private int MAXPHOTOCOUNT;
    /**
     * 图片数据源
     */
    private List<ImageItem> list;
    /**
     * xml解析器
     */
    private LayoutInflater inflater;
    /**
     * 添加按钮
     */
    private static final int TYPE_ADD = 0;
    /**
     * 相片
     */
    private static final int TYPE_ALBUM = 1;
    /**
     * 是否显示添加图片
     */
    private boolean isShowAddIcon = true;

    /**
     * 删除图片回调
     */
    private OnSquaredImageRemoveClick listener;

    public void updateGridView(List<ImageItem> list) {
        this.list = list;
        notifyDataSetChanged();
    }


    public SquaredImageAdapter(Context context, OnSquaredImageRemoveClick listener, List<ImageItem> list, int MAXPHOTOCOUNT) {
        inflater = LayoutInflater.from(context);
        this.list = list;
        this.listener = listener;
        this.MAXPHOTOCOUNT = MAXPHOTOCOUNT;
    }

    public int getCount() {
        return list == null ? 0 : list.size() == MAXPHOTOCOUNT ? list.size() : isShowAddIcon ? list.size() + 1 : list.size();
    }

    public Object getItem(int arg0) {
        return list.get(arg0);
    }

    public long getItemId(int arg0) {
        return arg0;
    }

    @Override
    public int getViewTypeCount() {
        return 2;
    }


    @Override
    public int getItemViewType(int position) {
        return position == list.size() ? TYPE_ADD : TYPE_ALBUM;
    }


    public View getView(final int position, View convertView, ViewGroup parent) {
        int type = getItemViewType(position);
        switch (type) {
            case TYPE_ADD:
                convertView = inflater.inflate(R.layout.add_pircture_layout, parent, false);
                if (position == MAXPHOTOCOUNT) {
                    convertView.setVisibility(View.GONE);
                } else {
                    convertView.setVisibility(View.VISIBLE);
                }
            case TYPE_ALBUM:
                ViewHolder holder;
                if (convertView == null) {
                    convertView = inflater.inflate(R.layout.item_grid_experience_detail, parent, false);
                    holder = new ViewHolder(convertView);
                    convertView.setTag(holder);
                } else {
                    holder = (ViewHolder) convertView.getTag();
                }
                if (holder != null) {
                    bindData(holder, position);
                }
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
        holder.remove.setOnClickListener(new View.OnClickListener() {//删除点击事件
            @Override
            public void onClick(View v) {
                if (listener != null) {
                    listener.remove(position);
                }
            }
        });
    }

    public class ViewHolder {

        public ViewHolder(View view) {
            image = view.findViewById(R.id.image);
            remove = view.findViewById(R.id.remove);
        }

        private ImageView image;
        private RelativeLayout remove;
    }

    public boolean isShowAddIcon() {
        return isShowAddIcon;
    }

    public void setShowAddIcon(boolean showAddIcon) {
        isShowAddIcon = showAddIcon;
    }
}
