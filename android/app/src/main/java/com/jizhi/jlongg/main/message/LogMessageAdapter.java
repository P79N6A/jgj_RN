
package com.jizhi.jlongg.main.message;

import android.app.Activity;
import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.hcs.uclient.utils.TimesUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.groupimageviews.NineGridImageViewAdapter;
import com.jizhi.jlongg.groupimageviews.NineGridMsgImageView;
import com.jizhi.jlongg.main.bean.ChatMsgEntity;
import com.jizhi.jlongg.main.util.GlideUtils;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.jizhi.jongg.widget.CollapsibleTextView;

import java.util.List;

public class LogMessageAdapter extends BaseAdapter {

    private static final String TAG = LogMessageAdapter.class.getSimpleName();
    private List<ChatMsgEntity> data;
    private Context context;
    private LayoutInflater mInflater;

    public LogMessageAdapter(Context context, List<ChatMsgEntity> data) {
        this.context = context;
        this.data = data;
        mInflater = LayoutInflater.from(context);

    }


    //获取ListView的项个数
    public int getCount() {
        return data.size();
    }

    //获取项
    public Object getItem(int position) {
        return data.get(position);
    }


    //获取项的ID
    public long getItemId(int position) {
        return position;
    }


    public View getView(int position, View convertView, ViewGroup parent) {
        final ChatMsgEntity entity = data.get(position);
        ViewHolder viewHolder = null;
        if (convertView == null) {
            //工作通知
            convertView = mInflater.inflate(R.layout.item_log, null);
            //左边
            viewHolder = new ViewHolder();
            viewHolder.img_head = (ImageView) convertView.findViewById(R.id.img_head);
            viewHolder.tv_name = (TextView) convertView.findViewById(R.id.tv_name);
            viewHolder.tv_date = (TextView) convertView.findViewById(R.id.tv_date);
            viewHolder.tv_content = (CollapsibleTextView) convertView.findViewById(R.id.tv_content);
            viewHolder.ngl_images = (NineGridMsgImageView) convertView.findViewById(R.id.ngl_images);
            convertView.setTag(viewHolder);
        } else {
            viewHolder = (ViewHolder) convertView.getTag();
        }
        viewHolder.tv_content.setDesc(entity.getMsg_text(), TextView.BufferType.NORMAL);
        viewHolder.tv_name.setText(entity.getUser_name());
        viewHolder.tv_date.setText(TimesUtils.getMsgdata(entity.getDate()));
        new GlideUtils().glideImage(context, NetWorkRequest.IP_ADDRESS + entity.getHead_pic(), viewHolder.img_head, R.drawable.friend_head, R.drawable.friend_head);

//        Picasso.with(context).load(NetWorkRequest.IP_ADDRESS + entity.getHead_pic()).placeholder(R.drawable.friend_head).error(R.drawable.friend_head).into(viewHolder.img_head);
        viewHolder.ngl_images.setAdapter(mAdapter);
        viewHolder.ngl_images.setImagesData(entity.getMsg_src());
        return convertView;
    }

    class ViewHolder {
        public ImageView img_head;
        public TextView tv_name;
        public TextView tv_date;
        public CollapsibleTextView tv_content;
        public NineGridMsgImageView ngl_images;

    }

    private NineGridImageViewAdapter<String> mAdapter = new NineGridImageViewAdapter<String>() {
        @Override
        public void onDisplayImage(Context context, ImageView imageView, String s) {
//            Picasso.with(context)
//                    .load(NetWorkRequest.IP_ADDRESS + "" + s)
//                    .placeholder(R.drawable.icon_message_fail_default)
//                    .into(imageView);
            new GlideUtils().glideImage(context, NetWorkRequest.IP_ADDRESS + s, imageView, R.drawable.icon_message_fail_default, R.drawable.icon_message_fail_default);


        }


        @Override
        public void onItemImageClick(Context context, int index, List<String> list, ImageView imageView) {
            MessageImagePagerActivity.ImageSize imageSize = new MessageImagePagerActivity.ImageSize(imageView.getMeasuredWidth(), imageView.getMeasuredHeight());
            MessageImagePagerActivity.startImagePagerActivity((Activity) context, list, index, imageSize);
        }
    };

}
