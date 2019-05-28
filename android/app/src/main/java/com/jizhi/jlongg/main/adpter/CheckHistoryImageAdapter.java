package com.jizhi.jlongg.main.adpter;

import android.app.Activity;
import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;

import com.hcs.uclient.utils.UtilImageLoader;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.message.MessageImagePagerActivity;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.nostra13.universalimageloader.core.ImageLoader;

import java.util.List;

/**
 * 功能:显示九宫格图片
 * 时间:2016年8月25日 18:15:44
 * 作者:xuj
 */
public class CheckHistoryImageAdapter extends BaseAdapter {

    /* 图片数据源 */
    private List<String> list;
    /* xml解析器 */
    private LayoutInflater inflater;
    private Context context;


    public CheckHistoryImageAdapter(Context context, List<String> list) {
        inflater = LayoutInflater.from(context);
        this.context = context;
        this.list = list;
    }

    public int getCount() {
        return list == null ? 0 : list.size();
    }

    public Object getItem(int arg0) {
        return list.get(arg0);
    }

    public long getItemId(int arg0) {
        return arg0;
    }


    public View getView(final int position, View convertView, ViewGroup parent) {
        ViewHolder holder;
        if (convertView == null) {
            convertView = inflater.inflate(R.layout.item_grid_check, parent, false);
            holder = new ViewHolder(convertView);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        if (holder != null) {
            bindData(holder, position);
        }
        return convertView;
    }

    public void bindData(final ViewHolder holder, final int position) {
        if (holder.image.getTag() != null && holder.image.getTag().equals(list.get(position))) {

        } else {
            if (!list.get(position).equals("4")) {
//                Glide.with(context).load(NetWorkRequest.IP_ADDRESS + s).placeholder(R.drawable.icon_message_fail_default).error(R.drawable.icon_message_fail_default).into(imageView);
                // 如果不相同，就加载。现在在这里来改变闪烁的情况
                ImageLoader.getInstance().displayImage(NetWorkRequest.CDNURL + list.get(position), holder.image, UtilImageLoader.getExperienceOptions());
            } else {
                Utils.setBackGround(holder.image, context.getResources().getDrawable(R.drawable.bg_default_imgnotice));
            }
            holder.image.setTag(list.get(position) + position);
        }
        holder.image.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                //imagesize是作为loading时的图片size
                MessageImagePagerActivity.ImageSize imageSize = new MessageImagePagerActivity.ImageSize(holder.image.getMeasuredWidth(), holder.image.getMeasuredHeight());
                MessageImagePagerActivity.startImagePagerActivity((Activity) context, list, position, imageSize);
            }
        });
    }

    public class ViewHolder {

        public ViewHolder(View view) {
            image = (ImageView) view.findViewById(R.id.image);
        }

        private ImageView image;
    }

    public List<String> getList() {
        return list;
    }

    public void setList(List<String> list) {
        this.list = list;
    }
}
