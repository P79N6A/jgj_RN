package com.jizhi.jlongg.main.adpter;

import android.annotation.TargetApi;
import android.content.Context;
import android.os.Build;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.groupimageviews.NineGroupChatGridImageView;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;
import com.jizhi.jlongg.main.util.WebSocketConstance;
import com.jizhi.jongg.widget.RoundeImageHashCodeTextLayout;

import java.util.ArrayList;


/**
 * 功能:头像横向显示
 * 时间:2019年3月28日17:42:31
 * 作者:xuj
 */
public class GridViewHorztalShowHeadAdater extends BaseAdapter {
    /**
     * 列表数据
     */
    private ArrayList<GroupDiscussionInfo> list;
    /**
     * 上下文
     */
    private Context context;


    public GridViewHorztalShowHeadAdater(Context context, ArrayList<GroupDiscussionInfo> list) {
        super();
        this.context = context;
        this.list = list;
    }


    @Override
    public int getCount() {
        return list == null ? 0 : list.size();
    }

    @Override
    public GroupDiscussionInfo getItem(int position) {
        return list.get(position);
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    @TargetApi(Build.VERSION_CODES.JELLY_BEAN)
    @Override
    public View getView(final int position, View convertView, ViewGroup parent) {
        ViewHolder holder = null;
        if (convertView == null) {
            convertView = LayoutInflater.from(context).inflate(R.layout.item_horizontal_head, null);
            holder = new ViewHolder(convertView);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        bindData(holder, position);
        return convertView;
    }

    private void bindData(ViewHolder holder, int position) {
        final GroupDiscussionInfo bean = getItem(position);
        if (WebSocketConstance.SINGLECHAT.equals(bean.getClass_type())) {
            holder.groupChatGridImageView.setVisibility(View.GONE);
            holder.roundImageHashText.setVisibility(View.VISIBLE);
            holder.roundImageHashText.setView(bean.getMembers_head_pic() != null && bean.getMembers_head_pic().size() > 0 ? bean.getMembers_head_pic().get(0) : "",
                    bean.getGroup_name(), position);
        } else {
            holder.groupChatGridImageView.setVisibility(View.VISIBLE);
            holder.roundImageHashText.setVisibility(View.GONE);
            holder.groupChatGridImageView.setImagesData(bean.getMembers_head_pic());
        }
    }


    class ViewHolder {
        /**
         * 头像、HashCode文本
         */
        RoundeImageHashCodeTextLayout roundImageHashText;


        NineGroupChatGridImageView groupChatGridImageView;

        public ViewHolder(View converView) {
            roundImageHashText = converView.findViewById(R.id.roundImageHashText);
            groupChatGridImageView = converView.findViewById(R.id.teamHeads);
        }
    }

}
