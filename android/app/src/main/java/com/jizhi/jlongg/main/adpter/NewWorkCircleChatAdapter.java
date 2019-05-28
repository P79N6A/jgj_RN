package com.jizhi.jlongg.main.adpter;

import android.annotation.TargetApi;
import android.os.Build;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;

import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.bean.AccountInfoBean;
import com.jizhi.jlongg.main.bean.ChatMainInfo;
import com.jizhi.jlongg.main.strategy.AccountStrategy;
import com.jizhi.jlongg.main.strategy.MainStrategy;
import com.jizhi.jlongg.main.strategy.TeamGroupStrategy;

/**
 * 功能:首页列表适配器
 * 时间:2018年8月22日14:32:18
 * 作者:xuj
 */
public class NewWorkCircleChatAdapter extends BaseAdapter {
    /**
     * 无数据展示的内容
     */
    private final int NO_DATA = 0;
    /**
     * 显示班组、项目组信息
     */
    private final int SHOW_GROUP = 1;
    /**
     * 讨论组信息
     */
    private ChatMainInfo chatMainInfo;
    /**
     * activity
     */
    private BaseActivity activity;
    /**
     * 记账数据
     */
    private AccountInfoBean accountInfoBean;
    /**
     * 加载的三种状态
     * 0表示加载成功，没有班组和项目组信息
     * 1表示加载失败，需要显示加载失败的布局
     * 2表示加载中，需要显示加载中的布局
     */
    private int load_state = AccountStrategy.LOADING_STATE;


    @Override
    public int getViewTypeCount() {
        return 2;
    }


    @Override
    public int getItemViewType(int position) {
        if (chatMainInfo == null || chatMainInfo.getGroup_info() == null) {
            return NO_DATA;
        }
        return SHOW_GROUP;
    }

    public NewWorkCircleChatAdapter(BaseActivity activity, ChatMainInfo chatMainInfo) {
        super();
        this.activity = activity;
        this.chatMainInfo = chatMainInfo;
    }

    public void updateList(ChatMainInfo chatMainInfo) {
        this.chatMainInfo = chatMainInfo;
        notifyDataSetChanged();
    }


    @Override
    public int getCount() {
        return 1;
    }

    @Override
    public ChatMainInfo getItem(int position) {
        if (chatMainInfo != null && chatMainInfo.getGroup_info() != null) {
            return chatMainInfo;
        }
        return null;
    }

    @Override
    public long getItemId(int position) {
        return position;
    }


    @TargetApi(Build.VERSION_CODES.JELLY_BEAN)
    @Override
    public View getView(final int position, View convertView, ViewGroup parent) {
        int itemViewType = getItemViewType(position);
        MainStrategy strategy = null;
        switch (itemViewType) {
            case SHOW_GROUP:
                strategy = new TeamGroupStrategy(activity);
                convertView = strategy.getView(LayoutInflater.from(activity));
                break;
            case NO_DATA:
                strategy = new AccountStrategy(activity);
                convertView = strategy.getView(LayoutInflater.from(activity));
                break;
        }
        bindData(strategy, convertView, itemViewType, position);
        return convertView;
    }

    private void bindData(MainStrategy mainStrategy, View convertView, int itemViewType, final int position) {
        switch (itemViewType) {
            case SHOW_GROUP:
                ChatMainInfo chatMainInfo = getItem(position);
                mainStrategy.bindData(chatMainInfo, convertView, position);
                break;
            case NO_DATA:
                AccountStrategy accountStrategy = (AccountStrategy) mainStrategy;
                accountStrategy.setLoad_state(load_state);
                accountStrategy.bindData(accountInfoBean, convertView, position);
                break;
        }
    }

    public void setAccountInfoBean(AccountInfoBean accountInfoBean) {
        this.accountInfoBean = accountInfoBean;
    }

    public int getLoad_state() {
        return load_state;
    }

    public void setLoad_state(int load_state) {
        this.load_state = load_state;
    }
}
