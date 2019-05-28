package com.jizhi.jlongg.main.adpter;

import android.content.Context;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;

import com.jizhi.jlongg.main.bean.GroupMemberInfo;

import java.util.List;

public class CommonSelecteMemberBaseAdapter extends BaseAdapter {

    /**
     * 成员数据
     */
    public List<GroupMemberInfo> memberInfoList;
    /**
     * 如果搜索框输入的内容不为空,需要将输入的文字标红处理
     */
    private String filterValue;
    /**
     * 上下文
     */
    private Context context;


    public CommonSelecteMemberBaseAdapter(Context context, List<GroupMemberInfo> memberInfoList) {
        this.memberInfoList = memberInfoList;
        this.context = context;
    }

    @Override
    public int getCount() {
        return memberInfoList == null ? 0 : memberInfoList.size();
    }

    @Override
    public Object getItem(int i) {
        return memberInfoList.get(i);
    }

    @Override
    public long getItemId(int i) {
        return i;
    }

    @Override
    public View getView(int i, View view, ViewGroup viewGroup) {
        return null;
    }

    /**
     * 当ListView数据发生变化时,调用此方法来更新ListView
     *
     * @param memberInfoList
     */
    public void updateListView(List<GroupMemberInfo> memberInfoList) {
        this.memberInfoList = memberInfoList;
        notifyDataSetChanged();
    }


    public void setFilterValue(String filterValue) {
        this.filterValue = filterValue;
    }

    public List<GroupMemberInfo> getMemberInfoList() {
        return memberInfoList;
    }

    public void setMemberInfoList(List<GroupMemberInfo> memberInfoList) {
        this.memberInfoList = memberInfoList;
    }
}
