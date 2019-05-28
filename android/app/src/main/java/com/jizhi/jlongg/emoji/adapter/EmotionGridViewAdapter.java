package com.jizhi.jlongg.emoji.adapter;

import android.content.Context;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.jizhi.jlongg.R;

import java.util.List;

/**
 * Created by zejian
 * Time  16/1/7 下午4:46
 * Email shinezejian@163.com
 * Description:
 */
public class EmotionGridViewAdapter extends BaseAdapter {

    private Context context;
    private List<String> emotionNames;
    private int itemWidth;
    private int emotion_map_type;

    public EmotionGridViewAdapter(Context context, List<String> emotionNames, int itemWidth, int emotion_map_type) {
        this.context = context;
        this.emotionNames = emotionNames;
        this.itemWidth = itemWidth;
        this.emotion_map_type = emotion_map_type;
    }

    @Override
    public int getCount() {
        // +1 最后一个为删除按钮
        return emotionNames.size() + 1;
    }

    @Override
    public String getItem(int position) {
        return emotionNames.get(position);
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    //    @Override
//    public View getView(int position, View convertView, ViewGroup parent) {
//        TextView iv_emotion = new TextView(context);
//        // 设置内边距
//        iv_emotion.setPadding(itemWidth / 8, itemWidth / 8, itemWidth / 8, itemWidth / 8);
//        LayoutParams params = new LayoutParams(itemWidth, itemWidth);
//        iv_emotion.setLayoutParams(params);
//
//        //判断是否为最后一个item
//        if (position == getCount() - 1) {
//            iv_emotion.setBackgroundResource(R.drawable.compose_emotion_delete);
//        } else {
//            String emotionName = emotionNames.get(position);
//            iv_emotion.setText(emotionName);
////			iv_emotion.setImageResource(EmotionUtils.getImgByName(emotion_map_type,emotionName));
//        }
//
//        return iv_emotion;
//    }
    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        ViewHolder holder = null;
        if (null == convertView) {
            holder = new ViewHolder();
            convertView = View.inflate(context, R.layout.item_emoji, null);
            holder.emojiTv = (TextView) convertView.findViewById(R.id.tv_emoji);
            holder.img_delete = (ImageView) convertView.findViewById(R.id.img_delete);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        if (position == getCount() - 1) {
            //第28个显示删除按钮
//            holder.emojiTv.setBackgroundResource(R.drawable.ic_emojis_delete);
            holder.img_delete.setVisibility(View.VISIBLE);
            holder.emojiTv.setVisibility(View.GONE);
        } else {
            holder.emojiTv.setText(emotionNames.get(position));
            holder.img_delete.setVisibility(View.GONE);
        }
        return convertView;
    }

    private static class ViewHolder {
        private TextView emojiTv;
        private ImageView img_delete;
    }
}
