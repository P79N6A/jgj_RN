package com.jizhi.jlongg.main.adpter;

import android.annotation.TargetApi;
import android.content.Intent;
import android.os.Build;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.activity.ChatUserInfoActivity;
import com.jizhi.jlongg.main.bean.GroupMemberInfo;
import com.jizhi.jlongg.main.dialog.DialogUnRegister;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.NameUtil;
import com.jizhi.jlongg.main.util.WebSocketConstance;
import com.jizhi.jongg.widget.RoundeImageHashCodeTextLayout;

import java.util.List;

/**
 * 功能:汇报对象Adapter
 * 时间:2016年9月13日 16:24:54
 * 作者:xuj
 */
public class ReportPersonAdapter extends PersonBaseAdapter {
    /**
     * xml解析器
     */
    private LayoutInflater inflater;
    /**
     * 上下文
     */
    private BaseActivity context;
    /**
     * 班组人员
     */
    private List<GroupMemberInfo> list;
    /**
     * groupId
     */
    private String groupId;

    /**
     * 当ListView数据发生变化时,调用此方法来更新ListView
     *
     * @param list
     */
    public void updateListView(List<GroupMemberInfo> list) {
        this.list = list;
        notifyDataSetChanged();
    }

    public ReportPersonAdapter(BaseActivity context, List<GroupMemberInfo> list, String groupId) {
        this.context = context;
        inflater = LayoutInflater.from(context);
        this.list = list;
        this.groupId = groupId;
    }

    public void addListView(List<GroupMemberInfo> list) {
        this.list.addAll(list);
        notifyDataSetChanged();
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
        final GroupMemberInfo bean = list.get(position);
        holder.roundImageHashText.setView(bean.getHead_pic(), bean.getReal_name(), position);
        holder.userName.setText(NameUtil.setName(bean.getReal_name()));
        holder.tagIcon.setVisibility(View.GONE);
        holder.isActive.setVisibility(bean.getIs_active() == 0 ? View.VISIBLE : View.GONE);
        View.OnClickListener onClickListener = new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if (bean.getIs_active() == 0) { //未注册
                    new DialogUnRegister(context, WebSocketConstance.GROUP, groupId, bean).show();
                } else {
                    Intent intent = new Intent(context, ChatUserInfoActivity.class);
                    intent.putExtra(Constance.CLASSTYPE, WebSocketConstance.GROUP);
                    intent.putExtra(Constance.GROUP_ID, groupId);
                    intent.putExtra(Constance.UID, bean.getUid());
                    intent.putExtra(Constance.BEAN_BOOLEAN, true);
                    context.startActivityForResult(intent, Constance.REQUEST);
                }
            }
        };
        holder.roundImageHashText.setOnClickListener(onClickListener);
    }


    public class ViewHolder {

        public ViewHolder(View view) {
            userName = (TextView) view.findViewById(R.id.userName);
            tagIcon = (ImageView) view.findViewById(R.id.tagIcon);
            isActive = view.findViewById(R.id.is_active);
            roundImageHashText = (RoundeImageHashCodeTextLayout) view.findViewById(R.id.roundImageHashText);
        }

        /**
         * 创建者、管理者标签
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
        private RoundeImageHashCodeTextLayout roundImageHashText;
    }

    public List<GroupMemberInfo> getList() {
        return list;
    }

}
