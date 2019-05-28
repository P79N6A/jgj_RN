package com.jizhi.jlongg.main.adpter;

import android.annotation.TargetApi;
import android.app.Activity;
import android.os.Build;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.listener.AddMemberListener;
import com.jizhi.jlongg.main.bean.GroupMemberInfo;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jongg.widget.RoundeImageHashCodeTextLayout;

import java.util.List;

/**
 * 功能:新建班组Adapter
 * 时间:2016年8月23日 17:02:33
 * 作者:xuj
 */
public class TeamCreateAdapter extends PersonBaseAdapter {
    /* xml解析器 */
    private LayoutInflater inflater;
    /* 班组人员 */
    private List<GroupMemberInfo> list;
    /* 头像 */
    private static final int TYPE_HEAD = 0;
    /* 添加人员、刪除人员 */
    private static final int TYPE_ADD_OR_REMOVE = 1;

    private AddMemberListener listener;

    /**
     * 当ListView数据发生变化时,调用此方法来更新ListView
     *
     * @param list
     */
    public void updateListView(List<GroupMemberInfo> list) {
        this.list = list;
        notifyDataSetChanged();
    }

    @Override
    public int getViewTypeCount() {
        return 2;
    }

    @Override
    public int getItemViewType(int position) {
        if (list == null || position >= list.size()) {
            return TYPE_ADD_OR_REMOVE;
        } else {
            return TYPE_HEAD;
        }
    }


    public TeamCreateAdapter(Activity context, List<GroupMemberInfo> list, AddMemberListener listener) {
        inflater = LayoutInflater.from(context);
        this.list = list;
        this.listener = listener;
    }


    @Override
    public int getCount() {
        return list == null ? 1 : list.size() + 1;
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
                image.setImageResource(R.drawable.icon_member_add);
                state.setText("添加");
                convertView.findViewById(R.id.remove_add_image).setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        if (listener == null) {
                            return;
                        }
                        if (list == null || position == list.size()) { //添加
                            listener.add(Constance.CREATE_PRO_ADD_MEMBER);
                        }
                    }
                });
                break;
            case TYPE_HEAD:
                ViewHolder holder = null;
                if (convertView == null) {
                    convertView = inflater.inflate(R.layout.item_team_create, parent, false);
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
        holder.roundImageHashText.setView(bean.getHead_pic(), bean.getReal_name(), position);
        holder.userName.setText(bean.getReal_name());
        holder.roundImageHashText.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                list.remove(position);
                notifyDataSetChanged();
            }
        });
    }


    public class ViewHolder {

        public ViewHolder(View view) {
            userName = (TextView) view.findViewById(R.id.userName);
            roundImageHashText = (RoundeImageHashCodeTextLayout) view.findViewById(R.id.roundImageHashText);
        }

        /**
         * 用户姓名
         */
        private TextView userName;
        /**
         * 头像、HashCode文本
         */
        private RoundeImageHashCodeTextLayout roundImageHashText;
    }


    public List<GroupMemberInfo> getList() {
        return list;
    }

    public void setList(List<GroupMemberInfo> list) {
        this.list = list;
    }
}
