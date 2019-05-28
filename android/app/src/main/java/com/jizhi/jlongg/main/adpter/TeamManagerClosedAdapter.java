package com.jizhi.jlongg.main.adpter;

import android.annotation.TargetApi;
import android.app.Activity;
import android.content.Context;
import android.os.Build;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.GroupMemberInfo;
import com.jizhi.jlongg.main.listener.TeamManagerNoRegisterDialogListener;
import com.jizhi.jongg.widget.RoundeImageHashCodeTextLayout;

import java.util.List;

/**
 * 功能:已关闭的项目
 * 时间:2016年9月13日 16:24:54
 * 作者:xuj
 */
public class TeamManagerClosedAdapter extends PersonBaseAdapter {
    /* xml解析器 */
    private LayoutInflater inflater;
    /* 上下文 */
    private Context context;
    /* 班组人员 */
    private List<GroupMemberInfo> list;
    /* 班组管理未注册弹出框回调 */
    private TeamManagerNoRegisterDialogListener teamManagerListener;


    public TeamManagerClosedAdapter(Activity context, List<GroupMemberInfo> list, TeamManagerNoRegisterDialogListener teamManagerListener) {
        this.context = context;
        inflater = LayoutInflater.from(context);
        this.list = list;
        this.teamManagerListener = teamManagerListener;
    }


    @Override
    public int getCount() {
        return list == null ? 0 : list.size();
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
        return convertView;
    }


    public void bindData(final ViewHolder holder, final int position) {
        GroupMemberInfo bean = list.get(position);
        holder.roundImageHashText.setView(bean.getHead_pic(), bean.getReal_name(), position);
        holder.userName.setText(bean.getReal_name());
        if (bean.getIs_creater() == 1) {
            holder.tagIcon.setImageResource(R.drawable.icon_administrator);
        }
        holder.tagIcon.setVisibility(bean.getIs_creater() == 1 ? View.VISIBLE : View.GONE);
        holder.isActive.setVisibility(bean.getIs_active() == 0 ? View.VISIBLE : View.GONE);
        holder.isActive.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (teamManagerListener != null) {
                    teamManagerListener.showNoRegisterDialog();
                }
            }
        });
    }


    public class ViewHolder {

        public ViewHolder(View view) {
            userName = (TextView) view.findViewById(R.id.userName);
            tagIcon = (ImageView) view.findViewById(R.id.tagIcon);
            isActive = view.findViewById(R.id.is_active);
            roundImageHashText = (RoundeImageHashCodeTextLayout) view.findViewById(R.id.roundImageHashText);
        }


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
        private RoundeImageHashCodeTextLayout roundImageHashText;
    }
}
