package com.jizhi.jlongg.main.adpter;

import android.annotation.TargetApi;
import android.app.Activity;
import android.graphics.Color;
import android.os.Build;
import android.text.Spannable;
import android.text.SpannableStringBuilder;
import android.text.TextUtils;
import android.text.style.ForegroundColorSpan;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.listener.AddMemberListener;
import com.jizhi.jlongg.main.bean.GroupMemberInfo;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.MessageUtil;
import com.jizhi.jlongg.main.util.NameUtil;
import com.jizhi.jongg.widget.RoundeImageHashCodeTextLayout;

import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * 功能:数据来源人对象Adapter
 * 时间:2016年9月13日 16:24:54
 * 作者:xuj
 */
public class SourceMemberAdapter extends PersonBaseAdapter {
    /**
     * xml解析器
     */
    private LayoutInflater inflater;
    /**
     * 列表数据
     */
    private List<GroupMemberInfo> list;
    /**
     * 显示成员头像
     */
    private static final int TYPE_MEMBER = 0;
    /**
     * 添加人员、刪除人员
     */
    private static final int TYPE_ADD_OR_REMOVE = 1;
    /**
     * 组是否关闭
     */
    private boolean isClose;
    /**
     * 过滤文本
     */
    private String filterValue;
    /**
     * 班组管理添加、删除人员回调
     */
    private AddMemberListener listener;
    /**
     * 点击成员头像回调
     */
    private SourceMemberHeadClick sourceMemberHeadClickListener;

    public void setSourceMemberHeadClickListener(SourceMemberHeadClick sourceMemberHeadClickListener) {
        this.sourceMemberHeadClickListener = sourceMemberHeadClickListener;
    }

    @Override
    public int getViewTypeCount() {
        return 2;
    }

    @Override
    public int getItemViewType(int position) {
        if (position >= list.size()) {
            return TYPE_ADD_OR_REMOVE;
        } else {
            return TYPE_MEMBER;
        }
    }

    /**
     * 当ListView数据发生变化时,调用此方法来更新ListView
     *
     * @param list
     */
    public void updateListView(List<GroupMemberInfo> list) {
        this.list = list;
        notifyDataSetChanged();
    }

    public SourceMemberAdapter(Activity context, List<GroupMemberInfo> list, AddMemberListener listener, boolean isClose) {
        inflater = LayoutInflater.from(context);
        this.list = list;
        this.listener = listener;
        this.isClose = isClose;
    }


    @Override
    public int getCount() {
        if (list == null) {
            return 0;
        }
        if (isClose || !TextUtils.isEmpty(filterValue)) {
            return list.size();
        }
        return list.size() >= 1 ? list.size() + 2 : list.size() + 1;
    }

    @Override
    public Object getItem(int position) {
        return null;
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
            case TYPE_ADD_OR_REMOVE:
                convertView = inflater.inflate(R.layout.item_team_manager_remove, parent, false);
                ImageView image = (ImageView) convertView.findViewById(R.id.remove_add_image);
                TextView state = (TextView) convertView.findViewById(R.id.state);
                image.setImageResource(position == list.size() ? R.drawable.icon_member_add : R.drawable.icon_member_delete);
                state.setText(position == list.size() ? "添加" : "删除");
                View.OnClickListener onClickListener = new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {
                        if (listener == null || isClose) {
                            return;
                        }
                        if (position == list.size()) { //添加
                            listener.add(MessageUtil.WAY_ADD_SOURCE_MEMBER);
                        } else { //删除
                            listener.remove(Constance.DELETE_SOURCE_DATA_MEMBER);
                        }
                    }
                };
                convertView.findViewById(R.id.remove_add_image).setOnClickListener(onClickListener);
                state.setOnClickListener(onClickListener);
                break;
            case TYPE_MEMBER:
                ViewHolder holder = null;
                if (convertView == null) {
                    convertView = inflater.inflate(R.layout.item_team_source_person, parent, false);
                    holder = new ViewHolder(convertView);
                    convertView.setTag(holder);
                } else {
                    holder = (ViewHolder) convertView.getTag();
                }
                if (holder != null) {
                    bindData(holder, position, convertView);
                }
                break;
        }
        return convertView;
    }


    public void bindData(final ViewHolder holder, final int position, View convertView) {
        final GroupMemberInfo bean = list.get(position);
        holder.roundImageHashText.setView(bean.getHead_pic(), bean.getReal_name(), position);
        holder.tagIcon.setVisibility(bean.getIs_admin() == 1 ? View.VISIBLE : View.GONE);
        holder.isSynch.setVisibility(bean.getSynced() == 0 ? View.VISIBLE : View.GONE);
        if (!TextUtils.isEmpty(filterValue)) { //如果过滤文字不为空
            Pattern p = Pattern.compile(filterValue);
            if (!TextUtils.isEmpty(bean.getReal_name())) { //姓名不为空的时才进行模糊匹配
                SpannableStringBuilder builder = new SpannableStringBuilder(NameUtil.setName(bean.getReal_name()));
                Matcher nameMatch = p.matcher(NameUtil.setName(bean.getReal_name()));
                while (nameMatch.find()) {
                    ForegroundColorSpan redSpan = new ForegroundColorSpan(Color.parseColor("#EF272F"));
                    builder.setSpan(redSpan, nameMatch.start(), nameMatch.end(), Spannable.SPAN_INCLUSIVE_INCLUSIVE);
                }
                holder.userName.setText(builder);
            }
        } else {
            holder.userName.setText(NameUtil.setName(bean.getReal_name()));
        }
        convertView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (sourceMemberHeadClickListener != null) {
                    sourceMemberHeadClickListener.clickSourceHead(position);
                }
            }
        });
    }


    public class ViewHolder {

        public ViewHolder(View view) {
            userName = (TextView) view.findViewById(R.id.userName);
            isSynch = (ImageView) view.findViewById(R.id.is_synch);
            tagIcon = (ImageView) view.findViewById(R.id.tagIcon);
            roundImageHashText = (RoundeImageHashCodeTextLayout) view.findViewById(R.id.roundImageHashText);
        }

        /**
         * 用户姓名
         */
        private TextView userName;
        /**
         * 是否已同步
         */
        private ImageView isSynch;
        /**
         * 是否是创建者
         */
        private ImageView tagIcon;
        /**
         * 头像、HashCode文本
         */
        RoundeImageHashCodeTextLayout roundImageHashText;
    }


    public List<GroupMemberInfo> getList() {
        return list;
    }

    public void setList(List<GroupMemberInfo> list) {
        this.list = list;
    }

    public interface SourceMemberHeadClick {
        public void clickSourceHead(int position);
    }

    public String getFilterValue() {
        return filterValue;
    }

    public void setFilterValue(String filterValue) {
        this.filterValue = filterValue;
    }
}
