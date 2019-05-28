package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;
import android.support.v4.content.ContextCompat;
import android.text.TextUtils;
import android.view.ContextMenu;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseExpandableListAdapter;
import android.widget.ExpandableListView;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.hcs.uclient.utils.DensityUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.ChatInfo;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DBMsgUtil;
import com.jizhi.jlongg.main.util.HelpCenterUtil;
import com.jizhi.jlongg.main.util.MessageUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.WebSocketConstance;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;

import java.util.ArrayList;
import java.util.List;


/**
 * CName:项目列表
 * User: xuj
 * Date: 2017年3月30日
 * Time: 16:26:27
 */
public class ProListActivity extends BaseActivity implements View.OnClickListener {

    /**
     * listView
     */
    private ExpandableListView listView;
    /**
     * 列表适配器
     */
    private ProListAdapter adapter;
    /**
     * 是否展开
     */
    private boolean isExpand;
    /**
     * 长按点击下标
     */
    private int longClickPostion;
    /**
     * 当本地没有数据的时候，需要加载一次服务器数据
     */
    private boolean loadOnceServerData;
    /**
     * 已关闭的班组、项目组列表
     */
    private ArrayList<GroupDiscussionInfo> closedList;

    /**
     * 启动当前Acitivyt
     *
     * @param context
     * @param selecteGroupId 已选中的项目组id
     */
    public static void actionStart(Activity context, String selecteGroupId) {
        Intent intent = new Intent(context, ProListActivity.class);
        intent.putExtra(Constance.GROUP_ID, selecteGroupId);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.pro_list);
        initView();
        registerReceiver();
        getClosedList();
    }


    private void initView() {
        setTextTitleAndRight(R.string.pro_list, R.string.delete_pro_desc);
        getTextView(R.id.red_btn).setText(R.string.create_group);
    }

    /**
     * 加载本地数据库数据
     */
    private void loadLocalDataBaseData() {
        //litepal 加载 数据库已存好的班组、项目组数据
        List<GroupDiscussionInfo> groupDiscussionInfos = MessageUtil.getLocalGroupTeam(true, null, null);
        if (groupDiscussionInfos == null || groupDiscussionInfos.size() == 0) { //如果第一次加载本地没有数据,则去加载一次服务器获取数据
            if (!loadOnceServerData) {
                loadOnceServerData = true;
                MessageUtil.getChatListData(ProListActivity.this, false);
                return;
            }
        }
        ArrayList<GroupDiscussionInfo> unClosedList = new ArrayList<>();
        for (GroupDiscussionInfo groupDiscussionInfo : groupDiscussionInfos) {
            if (groupDiscussionInfo == null) {
                continue;
            }
            unClosedList.add(groupDiscussionInfo);
        }
        ChatInfo chatInfo = new ChatInfo();
        chatInfo.setUnclose_list(unClosedList);
        chatInfo.setClosed_list(closedList);
        setAdapter(chatInfo);
    }

    /**
     * 获取已关闭的项目组、班组列表数据
     * 我们这里执行的顺序是 先用http接口获取到已关闭的项目组、班组数据
     * 获取到的数据有可能是空或者没有已关闭的列表数据，获取成功后不管成功与否都去加载本地未关闭的项目列表数据
     */
    private void getClosedList() {
        String httpUrl = NetWorkRequest.GET_CLOSE_CHAT_LIST;
        RequestParams params = RequestParamsToken.getExpandRequestParams(getApplicationContext());
        CommonHttpRequest.commonRequest(this, httpUrl, GroupDiscussionInfo.class, true, params, true, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                ArrayList<GroupDiscussionInfo> closedList = (ArrayList<GroupDiscussionInfo>) object;
                ProListActivity.this.closedList = closedList;
                loadLocalDataBaseData();
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
                finish();
            }
        });
    }


    /**
     * 彻底删除项目
     *
     * @param groupDiscussionInfo 项目组信息
     */
    private void thoroughDeleteGroup(final GroupDiscussionInfo groupDiscussionInfo) {
        MessageUtil.thoroughDeleteGroup(this, groupDiscussionInfo.getGroup_id(), groupDiscussionInfo.getClass_type(), new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                CommonMethod.makeNoticeShort(getApplicationContext(), "删除成功", CommonMethod.SUCCESS);
                DBMsgUtil.getInstance().deleteMessage(ProListActivity.this, groupDiscussionInfo.getGroup_id(), groupDiscussionInfo.getClass_type());
                getClosedList();
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {

            }
        });
    }

    /**
     * 重新开启班组、项目组
     *
     * @param groupDiscussionInfo 项目组信息
     */
    private void reOpen(final GroupDiscussionInfo groupDiscussionInfo) {
        MessageUtil.reOpen(this, groupDiscussionInfo.getGroup_id(), groupDiscussionInfo.getClass_type(), new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                GroupDiscussionInfo saveInfo = (GroupDiscussionInfo) object;
                MessageUtil.addTeamOrGroupToLocalDataBase(ProListActivity.this, "开启成功", saveInfo, true);
                setResult(Constance.GO_MAIN_ACTIVITY);
                finish();
                finish();
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {

            }
        });
    }

    private void setAdapter(final ChatInfo chatInfo) {
//        if (chatInfo == null) {
//            return;
//        }
        if (adapter == null) {
            listView = (ExpandableListView) findViewById(R.id.listView);
            listView.setEmptyView(findViewById(R.id.defaultLayout));
            listView.setOnGroupClickListener(new ExpandableListView.OnGroupClickListener() {
                @Override
                public boolean onGroupClick(ExpandableListView parent, View v, int groupPosition, long id) {
                    if (groupPosition == 0) { //进行中的项目标题不能点击
                        return true;
                    }
                    ArrayList<GroupDiscussionInfo> closedList = adapter.getGroup(groupPosition).getClosed_list();
                    int closedCount = closedList != null ? closedList.size() : 0;
                    if (closedCount <= 0) { //已关闭的项目组数量必须大于1才能点击
                        return true;
                    }
                    isExpand = !isExpand;
                    if (isExpand) { //展开
                        listView.expandGroup(groupPosition);
                    } else { //收拢
                        listView.collapseGroup(groupPosition);
                    }
                    return true;
                }
            });
            adapter = new ProListAdapter(ProListActivity.this, chatInfo);
            listView.setAdapter(adapter);
        } else {
            adapter.updateList(chatInfo);
        }
        if (chatInfo != null) {
            listView.expandGroup(0); //默认展开第一项
        }
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.red_btn_layout: //点击右上角图标 跳转到新建班组
                CreateTeamGroupActivity.actionStart(this);
                break;
            case R.id.right_title: //删除项目说明
                HelpCenterUtil.actionStartHelpActivity(ProListActivity.this, 239);
                break;
        }
    }


    //给菜单项添加事件
    @Override
    public boolean onContextItemSelected(MenuItem item) {
        //参数为用户选择的菜单选项对象
        //根据菜单选项的id来执行相应的功能
        switch (item.getItemId()) {
            case Menu.FIRST: //重新开启
                reOpen(adapter.getGroup().getClosed_list().get(longClickPostion));
                break;
            case Menu.FIRST + 1: //彻底删除
                thoroughDeleteGroup(adapter.getGroup().getClosed_list().get(longClickPostion));
                break;
        }
        return super.onOptionsItemSelected(item);
    }

    /**
     * 注册广播
     */
    public void registerReceiver() {
        IntentFilter filter = new IntentFilter();
        filter.addAction(WebSocketConstance.LOAD_CHAT_LIST);//加载聊聊数据
        filter.addAction(Constance.SET_INDEX);//设置首页项目组、班组成功后的回调
        receiver = new MessageBroadcast();
        registerLocal(receiver, filter);
    }


    /**
     * 广播回调
     */
    class MessageBroadcast extends BroadcastReceiver {
        @Override
        public void onReceive(Context context, Intent intent) {
            String action = intent.getAction();
            if (action.equals(WebSocketConstance.LOAD_CHAT_LIST)) { //加载聊聊列表数据成功后的回调
                loadLocalDataBaseData();
            } else if (action.equals(Constance.SET_INDEX)) { //设置首页项目组、班组成功后的回调
                finish();
            }
        }
    }


    /**
     * 项目列表适配器
     */
    class ProListAdapter extends BaseExpandableListAdapter {
        /**
         * xml解析器
         */
        private LayoutInflater inflater;
        /**
         * 列表数据
         */
        private ChatInfo chatInfo;
        /**
         * 未关闭
         */
        private final int UN_CLOSE = 0;
        /**
         * 已关闭
         */
        private final int CLOSED = 1;


        public void updateList(ChatInfo group) {
            this.chatInfo = group;
            notifyDataSetChanged();
        }


        public ProListAdapter(Context context, ChatInfo chatInfo) {
            inflater = LayoutInflater.from(context);
            this.chatInfo = chatInfo;
        }

        @Override
        public int getGroupType(int groupPosition) {
            return groupPosition == 0 ? UN_CLOSE : CLOSED;
        }


        @Override
        public int getGroupTypeCount() {
            return 2;
        }

        @Override
        public int getGroupCount() {
            if (chatInfo == null) {
                return 0;
            }
            return 2;
        }


        @Override
        public int getChildrenCount(int groupPosition) {
            if (groupPosition == 0) {
                List<GroupDiscussionInfo> unclose = chatInfo.getUnclose_list();
                if (unclose == null || unclose.size() == 0) {
                    return 0;
                }
                return unclose.size();
            } else {
                List<GroupDiscussionInfo> closeList = chatInfo.getClosed_list();
                if (closeList == null || closeList.size() == 0) {
                    return 0;
                }
                return closeList.size();
            }
        }

        public ChatInfo getGroup() {
            return chatInfo;
        }


        @Override
        public ChatInfo getGroup(int groupPosition) {
            return chatInfo;
        }

        @Override
        public GroupDiscussionInfo getChild(int groupPosition, int childPosition) {
            if (groupPosition == 0) {
                return chatInfo.getUnclose_list().get(childPosition);
            } else {
                return chatInfo.getClosed_list().get(childPosition);
            }
        }

        @Override
        public long getGroupId(int groupPosition) {
            return groupPosition;
        }

        @Override
        public long getChildId(int groupPosition, int childPosition) {
            return childPosition;
        }

        @Override
        public boolean hasStableIds() {
            return false;
        }

        @Override
        public View getGroupView(int groupPosition, boolean isExpanded, View convertView, ViewGroup parent) {
            final GroupHolder holder;
            int groupType = getGroupType(groupPosition);
            if (convertView == null) {
                convertView = inflater.inflate(R.layout.pro_list_title, null);
                holder = new GroupHolder(convertView);
                convertView.setTag(holder);
            } else {
                holder = (GroupHolder) convertView.getTag();
            }
            ChatInfo chatInfo = getGroup(groupPosition);
            if (groupType == UN_CLOSE) { //未关闭的项目组
                holder.openStateIcon.setVisibility(View.GONE);
                holder.title.setText("进行中的项目(" + (chatInfo != null && chatInfo.getUnclose_list() != null ? chatInfo.getUnclose_list().size() : 0) + ")");
                holder.title.setTextColor(ContextCompat.getColor(ProListActivity.this, R.color.color_333333));
            } else { //已关闭的项目组
                if (chatInfo != null && chatInfo.getClosed_list() != null && chatInfo.getClosed_list().size() > 0) {
                    holder.openStateIcon.setVisibility(View.VISIBLE);
                    holder.openStateIcon.setImageResource(isExpanded ? R.drawable.down_arrows : R.drawable.guide_image);
                } else {
                    holder.openStateIcon.setVisibility(View.GONE);
                }
                holder.title.setText("已关闭且存档的项目 (" + (chatInfo != null && chatInfo.getClosed_list() != null ? chatInfo.getClosed_list().size() : 0) + ")");
                holder.title.setTextColor(ContextCompat.getColor(ProListActivity.this, R.color.color_999999));
            }
            return convertView;
        }

        @Override
        public View getChildView(final int groupPosition, final int childPosition, boolean isLastChild, View convertView, ViewGroup parent) {
            int groupType = getGroupType(groupPosition);
            final ChildHolder childHolder;
            if (convertView == null) {
                convertView = inflater.inflate(R.layout.pro_list_content, null);
                childHolder = new ChildHolder(convertView);
                convertView.setTag(childHolder);
            } else {
                childHolder = (ChildHolder) convertView.getTag();
            }
            final GroupDiscussionInfo groupDiscussionInfo = getChild(groupPosition, childPosition);
            final ChatInfo chatInfo = getGroup(groupPosition);
            if (UclientApplication.getUid().equals(groupDiscussionInfo.getCreater_uid())) { //我创建的项目
                childHolder.desc.setText("(我创建的" + (groupDiscussionInfo.getClass_type().equals(WebSocketConstance.TEAM) ? "项目)" : "班组)"));
                childHolder.desc.setVisibility(View.VISIBLE);
            } else if (groupDiscussionInfo.getAgency_group_user() != null && UclientApplication.getUid().equals(groupDiscussionInfo.getAgency_group_user().getUid())) { //我代班的标识
                childHolder.desc.setText("(我代班的班组)");
                childHolder.desc.setVisibility(View.VISIBLE);
            } else {
                childHolder.desc.setVisibility(View.GONE);
            }
            childHolder.teamNameText.setText(groupDiscussionInfo.getGroup_name());
            LinearLayout.LayoutParams params = (LinearLayout.LayoutParams) childHolder.itemLayout.getLayoutParams();
            if (groupType == UN_CLOSE) { //未关闭
                params.height = DensityUtils.dp2px(getApplicationContext(), 45);
                childHolder.itemLayout.setLayoutParams(params);
                childHolder.closedTimeText.setVisibility(View.GONE);
                childHolder.itemDiver.setVisibility(chatInfo.getUnclose_list().size() - 1 == childPosition ? View.INVISIBLE : View.VISIBLE);
            } else { //已关闭
                params.height = DensityUtils.dp2px(getApplicationContext(), 60);
                childHolder.itemLayout.setLayoutParams(params);
                if (TextUtils.isEmpty(groupDiscussionInfo.getClose_time()) || "0".equals(groupDiscussionInfo.getClose_time())) {
                    childHolder.closedTimeText.setVisibility(View.GONE);
                } else {
                    childHolder.closedTimeText.setVisibility(View.VISIBLE);
                    childHolder.closedTimeText.setText("关闭时间:  " + groupDiscussionInfo.getClose_time());
                }
                childHolder.itemDiver.setVisibility(chatInfo.getClosed_list().size() - 1 == childPosition ? View.GONE : View.VISIBLE);
            }
            String selecteGroupId = getIntent().getStringExtra(Constance.GROUP_ID);
            if (!TextUtils.isEmpty(selecteGroupId) && selecteGroupId.equals(groupDiscussionInfo.getGroup_id())) {
                childHolder.unreadMessageFlag.setVisibility(View.GONE);
                childHolder.teamNameText.setTextColor(ContextCompat.getColor(getApplicationContext(), R.color.app_color));
            } else {
                if (groupDiscussionInfo.getUnread_quality_count() > 0 || //未读质量数
                        groupDiscussionInfo.getUnread_safe_count() > 0 || //未读安全数
                        groupDiscussionInfo.getUnread_inspect_count() > 0 || //未读检查数
                        groupDiscussionInfo.getUnread_task_count() > 0 || //未读任务数
                        groupDiscussionInfo.getUnread_notice_count() > 0 || //未读通知数
                        groupDiscussionInfo.getUnread_meeting_count() > 0 || //未读会议数
                        groupDiscussionInfo.getUnread_approval_count() > 0 || //未读审批数数
                        groupDiscussionInfo.getUnread_log_count() > 0 ||  //未读日志数
                        groupDiscussionInfo.getUnread_billRecord_count() > 0 || //出勤公示小红点
                        groupDiscussionInfo.getWork_message_num() > 0 ||//未读工作回复消息数
                        groupDiscussionInfo.getUnread_msg_count() > 0) {//未读组消息数
                    childHolder.unreadMessageFlag.setVisibility(View.VISIBLE);
                } else {
                    childHolder.unreadMessageFlag.setVisibility(View.GONE);
                }
                childHolder.teamNameText.setTextColor(ContextCompat.getColor(getApplicationContext(), R.color.color_333333));
            }
            childHolder.isSelected.setVisibility(!TextUtils.isEmpty(selecteGroupId) && selecteGroupId.equals(groupDiscussionInfo.getGroup_id())
                    ? View.VISIBLE : View.INVISIBLE);
            convertView.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    MessageUtil.setIndexList(ProListActivity.this, groupDiscussionInfo, true, false);
                }
            });
            convertView.setOnLongClickListener(new View.OnLongClickListener() {
                @Override
                public boolean onLongClick(View v) {
                    longClickPostion = childPosition;
                    return false;
                }
            });
            if (groupPosition == 1) { //已关闭的项目
                convertView.setOnCreateContextMenuListener(new View.OnCreateContextMenuListener() {
                    public void onCreateContextMenu(ContextMenu menu, View v, ContextMenu.ContextMenuInfo menuInfo) {
                        menu.add(0, Menu.FIRST, 0, "重新开启");
                        menu.add(0, Menu.FIRST + 1, 0, "彻底删除");
                    }
                });
            }
            return convertView;
        }

        @Override
        public boolean isChildSelectable(int groupPosition, int childPosition) {
            return false;
        }

        class GroupHolder {
            /**
             * 菜单标题
             */
            TextView title;
            /**
             * 打开和关闭 图标状态
             */
            ImageView openStateIcon;
            /**
             * 背景色
             */
            View background;
            /**
             * 分割线
             */
            View itemDiver;


            public GroupHolder(View convertView) {
                title = (TextView) convertView.findViewById(R.id.title);
                openStateIcon = (ImageView) convertView.findViewById(R.id.openStateIcon);
                background = convertView.findViewById(R.id.background);
                itemDiver = convertView.findViewById(R.id.itemDiver);
            }
        }

        class ChildHolder {
            /**
             * 分割线
             */
            View itemDiver;
            /**
             * 项目名称
             */
            TextView teamNameText;
            /**
             * 项目关闭时间
             */
            TextView closedTimeText;
            /**
             * 未读消息小红点标志
             */
            View unreadMessageFlag;
            /**
             * 是否选中
             */
            ImageView isSelected;
            /**
             *
             */
            View itemLayout;
            /**
             * 描述
             */
            TextView desc;

            public ChildHolder(View convertView) {
                itemLayout = convertView.findViewById(R.id.itemLayout);
                teamNameText = (TextView) convertView.findViewById(R.id.teamNameText);
                closedTimeText = (TextView) convertView.findViewById(R.id.closedTimeText);
                unreadMessageFlag = convertView.findViewById(R.id.unreadMessageFlag);
                isSelected = (ImageView) convertView.findViewById(R.id.isSelected);
                itemDiver = convertView.findViewById(R.id.itemDiver);
                desc = (TextView) convertView.findViewById(R.id.desc);
            }
        }
    }


    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == MessageUtil.WAY_CREATE_GROUP_CHAT) { //创建了班组
            setResult(resultCode, data);
            finish();
        }
    }
}
