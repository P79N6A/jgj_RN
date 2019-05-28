package com.jizhi.jlongg.main.adpter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;

import com.hcs.uclient.utils.UtilImageLoader;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.nostra13.universalimageloader.core.ImageLoader;

import java.util.List;

/**
 * 工头--找帮手（工友) 项目经验
 *
 * @author lilong
 * @version 1.0
 * @time 2015-12-3 上午10:44:12
 */
public class ExperienceImageAdapter extends BaseAdapter {
    private List<String> list;
    @SuppressWarnings("unused")
    private Context context;
    private LayoutInflater inflater;

    public ExperienceImageAdapter(Context context, List<String> list) {
        this.context = context;
        this.list = list;
        this.inflater = LayoutInflater.from(context);
    }

    public void setImgs(List<String> list) {
        this.list = list;
        this.notifyDataSetChanged();
    }

    @Override
    public int getCount() {
        return list.size();
    }

    @Override
    public Object getItem(int position) {
        return list.get(position);
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        final ImageHolder holder;
        if (convertView == null) {
            holder = new ImageHolder();
            convertView = inflater.inflate(R.layout.item_experience, null);
            holder.pic = (ImageView) convertView.findViewById(R.id.pic);
            convertView.setTag(holder);
        } else {
            holder = (ImageHolder) convertView.getTag();
        }
        if (holder.pic.getTag() != null && holder.pic.getTag().equals(NetWorkRequest.NETURL + list.get(position) + position)) {

        } else {
            // 如果不相同，就加载。现在在这里来改变闪烁的情况
            ImageLoader.getInstance().displayImage(NetWorkRequest.NETURL + list.get(position), holder.pic,
                    UtilImageLoader.getExperienceOptions());
            holder.pic.setTag(NetWorkRequest.NETURL + list.get(position) + position);
        }
        return convertView;
    }

    public class ImageHolder {
        ImageView pic;
    }


    public interface ExperienceClickListener {
        void experienceClick(int childPos, int parentPos);
    }


}
