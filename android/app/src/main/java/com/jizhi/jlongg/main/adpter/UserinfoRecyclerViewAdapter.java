package com.jizhi.jlongg.main.adpter;

import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.GroupMemberInfo;
import com.jizhi.jlongg.main.util.NameUtil;
import com.jizhi.jongg.widget.RoundeImageHashCodeTextLayout;

import java.util.ArrayList;
import java.util.List;

/**
 * 功能:选择成员横向滚动列表
 * 时间:2016-12-23 15:58:59
 * 作者:xuj
 */
public class UserinfoRecyclerViewAdapter extends RecyclerView.Adapter<UserinfoRecyclerViewAdapter.ViewHolder> {


    private Context context;
    /**
     * 数据
     */
    private final int DATA = 0;
    /**
     * 添加
     */
    private final int ADD_HEAD = 1;
    /**
     * 头像数据
     */
    private List<GroupMemberInfo> selectList;
    /**
     * item点击事件
     */
    private OnItemClickLitener mOnItemClickLitener;
    /**
     * 是否能添加人员
     */
    private boolean isAddPerson;
    /**
     * 是否显示人的名称
     */
    private boolean isShowUserName;
    /**
     * 是否是添加负责人
     */
    private boolean isAddPrini;


    @Override
    public int getItemViewType(int position) {
        if (isAddPerson) {
            if (selectList == null || selectList.size() == 0) return ADD_HEAD;
            return position == selectList.size() ? ADD_HEAD : DATA;
        } else {
            return DATA;
        }
    }


    public UserinfoRecyclerViewAdapter(Context context) {
        this.context = context;
    }

    public UserinfoRecyclerViewAdapter(Context context, List<GroupMemberInfo> selectList,OnItemClickLitener mOnItemClickLitener) {
        this.context = context;
        this.selectList = selectList;
        this.mOnItemClickLitener = mOnItemClickLitener;
    }
    public void setOnItemClickLitener(OnItemClickLitener mOnItemClickLitener) {
        this.mOnItemClickLitener = mOnItemClickLitener;
    }

    @Override
    public ViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        ViewHolder holder = null;
        if (isAddPerson && viewType == ADD_HEAD) {
            holder = new ViewHolder(LayoutInflater.from(context).inflate(R.layout.item_recylist_add_person, parent, false), viewType);
        } else {
            holder = new ViewHolder(LayoutInflater.from(context).inflate(R.layout.item_choose_groupchat_person, parent, false), viewType);
        }
        return holder;
    }

    @Override
    public void onBindViewHolder(final ViewHolder holder, int position) {
        switch (getItemViewType(position)) {
            case DATA: //正常的数据
                GroupMemberInfo bean = selectList.get(position);
                if (isShowUserName) {
                    holder.name.setVisibility(View.VISIBLE);
                    holder.name.setText(NameUtil.setName(bean.getReal_name()));
                } else {
                    holder.name.setVisibility(View.GONE);
                }
                holder.roundImageHashText.setDEFAULT_TEXT_SIZE(12);
                holder.roundImageHashText.setView(bean.getHead_pic(), bean.getReal_name(), position);
                // 如果设置了回调，则设置点击事件
                if (mOnItemClickLitener != null) {
                    holder.itemView.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            int pos = holder.getPosition();
                            mOnItemClickLitener.onItemClick(holder.itemView, pos);
                        }
                    });
                }
                break;
            case ADD_HEAD: //添加
//                if (isAddPrini) {
//                    holder.addFiled.setText("待指派");
//                    holder.addIcon.setImageResource(R.drawable.icon_member_add);
//                } else {
                    holder.addFiled.setText("添加");
                    holder.addIcon.setImageResource(R.drawable.icon_member_add);
//                }
                if (mOnItemClickLitener != null) {
                    holder.addIcon.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            int pos = holder.getPosition();
                            mOnItemClickLitener.onItemClick(holder.itemView, pos);
                        }
                    });
                }
                break;
        }
    }

    @Override
    public int getItemCount() {
        if (isAddPerson) {
            return selectList == null ? 1 : selectList.size() + 1;
        } else {
            return selectList == null ? 0 : selectList.size();
        }
    }

    class ViewHolder extends RecyclerView.ViewHolder {

        /**
         * 头像、HashCode文本
         */
        RoundeImageHashCodeTextLayout roundImageHashText;
        /**
         * 用户名称
         */
        TextView name;
        /**
         * 添加汇报对象
         */
        ImageView addIcon;
        /**
         * 添加字段
         */
        TextView addFiled;

        public ViewHolder(View convertView, int itemType) {
            super(convertView);
            switch (itemType) {
                case DATA:
                    roundImageHashText = (RoundeImageHashCodeTextLayout) convertView.findViewById(R.id.roundImageHashText);
                    name = (TextView) convertView.findViewById(R.id.name);
                    break;
                case ADD_HEAD:
                    addIcon = (ImageView) convertView.findViewById(R.id.addIcon);
                    addFiled = (TextView) convertView.findViewById(R.id.addFiled);
                    break;
            }


        }
    }

    public void addData(GroupMemberInfo info) {
        if (selectList == null) {
            selectList = new ArrayList<>();
        }
        selectList.add(info);
        notifyItemInserted(selectList.size() - 1);
    }

    public void removeData(int position) {
        selectList.remove(position);
        notifyItemRemoved(position);
    }


    public void removeData(String uid) {
        int size = selectList.size();
        int removePostion = -1;
        for (int i = 0; i < size; i++) {
            if (selectList.get(i).getUid().equals(uid)) {
                selectList.remove(i);
                removePostion = i;
                break;
            }
        }
        if (removePostion == -1) {
            return;
        }
        notifyItemRemoved(removePostion);
    }

    public interface OnItemClickLitener {
        void onItemClick(View view, int position);
    }

    public List<GroupMemberInfo> getSelectList() {
        return selectList;
    }

    public void setSelectList(List<GroupMemberInfo> list) {
        if (selectList == null) {
            selectList = new ArrayList<>();
        }
        if (selectList.size() > 0) {
            selectList.clear();
        }
        if (list != null && list.size() > 0) {
            selectList.addAll(list);
        }
        notifyDataSetChanged();
    }

    public boolean isAddPerson() {
        return isAddPerson;
    }

    public void setAddPerson(boolean addPerson) {
        isAddPerson = addPerson;
    }

    public boolean isShowUserName() {
        return isShowUserName;
    }

    public void setShowUserName(boolean showUserName) {
        isShowUserName = showUserName;
    }

    public boolean isAddPrini() {
        return isAddPrini;
    }

    public void setAddPrini(boolean addPrini) {
        isAddPrini = addPrini;
    }
}
