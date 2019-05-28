package com.jizhi.jlongg.main.adpter;

import android.annotation.TargetApi;
import android.app.Activity;
import android.os.Build;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.GroupMemberInfo;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jongg.widget.RoundeImageHashCodeTextLayout;

import java.util.List;

/**
 * 功能:班组管理Adapter
 * 时间:2016年8月23日 17:02:33
 * 作者:xuj
 */
public class ExampleTeamManagerAdapter extends BaseAdapter {

    /* 头像 */
    private static final int TYPE_HEAD = 0;
    /* 添加人员、刪除人员 */
    private static final int TYPE_ADD_OR_REMOVE = 1;

    /* xml解析器 */
    private LayoutInflater inflater;
    /* 班组人员数据 */
    private List<GroupMemberInfo> list;


    private Activity context;

    public ExampleTeamManagerAdapter(Activity context, List<GroupMemberInfo> list) {
        inflater = LayoutInflater.from(context);
        this.list = list;
        this.context = context;
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
            return TYPE_HEAD;
        }
    }


    @Override
    public int getCount() {
        return list == null ? 0 : list.size() + 2;
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
                convertView.findViewById(R.id.remove_add_image).setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        CommonMethod.makeNoticeShort(context, "这些都是示范数据,无法操作,谢谢", CommonMethod.ERROR);
                    }
                });
                break;
            case TYPE_HEAD:
                ViewHolder holder = null;
                if (convertView == null) {
                    convertView = inflater.inflate(R.layout.item_team_manager, parent, false);
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


    public void bindData(final ViewHolder holder, final int position) {
        GroupMemberInfo bean = list.get(position);
        holder.userName.setText(bean.getReal_name());
        holder.roundImageHashText.setView(bean.getHead_pic(), bean.getReal_name(), position);
        if (position == 0) {
            holder.tagIcon.setImageResource(R.drawable.icon_creator);
        } else {
            holder.tagIcon.setImageResource(-1);
        }
        holder.isActive.setVisibility(View.GONE);
    }


    public class ViewHolder {

        public ViewHolder(View view) {
            userName = (TextView) view.findViewById(R.id.userName);
            tagIcon = (ImageView) view.findViewById(R.id.tagIcon);
            isActive =  view.findViewById(R.id.is_active);
            roundImageHashText = (RoundeImageHashCodeTextLayout) view.findViewById(R.id.roundImageHashText);
        }

        /**
         * 是否是创建者
         */
        private ImageView tagIcon;
        /**
         * 用户姓名
         */
        private TextView userName;
        /**
         * 是否是平台用户
         */
        private View isActive;
        /**
         * 头像、HashCode文本
         */
        RoundeImageHashCodeTextLayout roundImageHashText;


    }

    public List<GroupMemberInfo> getList() {
        return list;
    }

}
