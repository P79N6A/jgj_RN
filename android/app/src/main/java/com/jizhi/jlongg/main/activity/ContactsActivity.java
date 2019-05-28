package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Build;
import android.os.Bundle;
import android.text.Editable;
import android.text.InputFilter;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.ContextMenu;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewTreeObserver;
import android.widget.AdapterView;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;

import com.hcs.cityslist.widget.ClearEditText;
import com.hcs.cityslist.widget.SideBar;
import com.hcs.uclient.utils.DensityUtils;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.adpter.CommonPersonListAdapter;
import com.jizhi.jlongg.main.bean.GroupMemberInfo;
import com.jizhi.jlongg.main.bean.MessageBean;
import com.jizhi.jlongg.main.bean.UserInfo;
import com.jizhi.jlongg.main.dialog.DialogTips;
import com.jizhi.jlongg.main.listener.DiaLogTitleListener;
import com.jizhi.jlongg.main.msg.MessageType;
import com.jizhi.jlongg.main.popwindow.ContactPopWindow;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DBMsgUtil;
import com.jizhi.jlongg.main.util.MessageUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SearchEditextHanlderResult;
import com.jizhi.jlongg.main.util.SearchMatchingUtil;
import com.jizhi.jlongg.main.util.WebSocketConstance;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.jizhi.jongg.widget.RoundeImageHashCodeTextLayout;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;

import java.util.ArrayList;
import java.util.List;

/**
 * CName:通讯录
 * User: xuj
 * Date: 2016-12-20
 * Time: 9:53:21
 */
public class ContactsActivity extends BaseActivity implements View.OnClickListener {


    /**
     * 通讯录适配器
     */
    private CommonPersonListAdapter adapter;
    /**
     * 当通讯录没有数据时，展示的布局
     */
    private View contactDefaultLayout;
    /**
     * ListView
     */
    private ListView listView;
    /**
     * 长按点击的下标
     */
    private int longClickPosition;
    /**
     * 搜索输入框
     */
    private String matchString;
    /**
     * 列表数据、筛选数据
     */
    private List<GroupMemberInfo> list;
    /**
     * 顶部更多按钮
     */
    private ImageView rightImage;
    /**
     * 新朋友小红点
     */
    private View newFriendCountText;
    /**
     * 新朋友头像、文字组件
     */
    private RoundeImageHashCodeTextLayout newFriendWeight;
    /**
     * 无数据时显示文本
     */
    private TextView defaultText;
    /**
     * 搜索联系人输入框
     */
    private EditText mClearEditText;
    /**
     * 搜索布局
     */
    private View searchView;


    /**
     * 启动当前Activity
     *
     * @param context
     */
    public static void actionStart(Activity context) {
        Intent intent = new Intent(context, ContactsActivity.class);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.contact);
        initView();
        initSeatchEdit();
        registerReceiver();
        getChatFriendsData();
        getFriendApplicationList();
    }


    /**
     * 获取申请好友列表
     * 展示小红点使用
     */
    private void getFriendApplicationList() {
        MessageUtil.getTempFriend(this, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                UserInfo friendBean = (UserInfo) object;
                if (friendBean != null && !TextUtils.isEmpty(friendBean.getReal_name())) {
                    newFriendWeight.setDEFAULT_TEXT_SIZE(13);
                    newFriendWeight.setView(friendBean.getHead_pic(), friendBean.getReal_name(), 0);
                    newFriendWeight.setVisibility(View.VISIBLE);
                    newFriendCountText.setVisibility(View.VISIBLE);
                } else {
                    newFriendCountText.setVisibility(View.GONE);
                    newFriendWeight.setVisibility(View.GONE);
                }
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {

            }
        });
    }

    /**
     * 获取好友列表
     */
    private void getChatFriendsData() {
        if (!TextUtils.isEmpty(mClearEditText.getText().toString())) {
            mClearEditText.setText("");
        }
        MessageUtil.getFriendList(this, null, null, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                ArrayList<GroupMemberInfo> serverList = (ArrayList<GroupMemberInfo>) object;
                if (serverList != null && serverList.size() > 0) {
                    Utils.setPinYinAndSort(serverList);
                }
                setAdapter(serverList);
                list = serverList;
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
                finish();
            }
        });
    }


    /**
     * 初始化View
     */
    private void initView() {
        setTextTitle(R.string.contact);
        searchView = findViewById(R.id.input_layout);
        listView = (ListView) findViewById(R.id.listView);
        rightImage = (ImageView) findViewById(R.id.rightImage);
        rightImage.setImageResource(R.drawable.chat_add_large_icon);
        final View contactHeadView = getLayoutInflater().inflate(R.layout.contact_head, null); // 通讯录头部
        contactDefaultLayout = getLayoutInflater().inflate(R.layout.contact_default, null); // 通讯录默认
        defaultText = (TextView) contactDefaultLayout.findViewById(R.id.defaultText);
        contactHeadView.findViewById(R.id.groupChat).setOnClickListener(this); //群聊
        contactHeadView.findViewById(R.id.workCircle).setOnClickListener(this); //项目
        contactHeadView.findViewById(R.id.newFriendLayout).setOnClickListener(this); //新朋友
        defaultText.setText(SearchEditextHanlderResult.getUoEmptyResultString(ContactsActivity.class.getName()));

        newFriendCountText = contactHeadView.findViewById(R.id.newFriendCountText);
        newFriendWeight = (RoundeImageHashCodeTextLayout) contactHeadView.findViewById(R.id.newFriendWeight);

        listView.addHeaderView(contactHeadView, null, false);
        listView.addFooterView(contactDefaultLayout, null, false);
        TextView centerText = getTextView(R.id.center_text); //当前正在搜索的英文字母
        SideBar sideBar = (SideBar) findViewById(R.id.sidrbar); //侧边搜索框
        sideBar.setTextView(centerText);
        // 设置右侧触摸监听
        sideBar.setOnTouchingLetterChangedListener(new SideBar.OnTouchingLetterChangedListener() {
            @Override
            public void onTouchingLetterChanged(String s) {
                if (adapter != null) {
                    //该字母首次出现的位置
                    int position = adapter.getPositionForSection(s.charAt(0));
                    if (position != -1) {
                        listView.setSelection(position);
                    }
                }
            }
        });
        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() { //listView 点击事件
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                Intent intent = new Intent(getApplicationContext(), ChatUserInfoActivity.class);
                intent.putExtra(Constance.BEAN_BOOLEAN, true);
                intent.putExtra(Constance.UID, adapter.getList().get(position - listView.getHeaderViewsCount()).getUid());
                startActivityForResult(intent, Constance.REQUEST);
            }
        });
        listView.getViewTreeObserver().addOnGlobalLayoutListener(new ViewTreeObserver.OnGlobalLayoutListener() { //当布局加载完毕  是否需要引导
            @Override
            public void onGlobalLayout() {
                //动态计算默认页的高度
                //但是需要注意的是OnGlobalLayoutListener可能会被多次触发，因此在得到了高度之后，要
                calculateDefaultHeight(listView, contactHeadView.getHeight());
                if (Build.VERSION.SDK_INT < 16) {
                    listView.getViewTreeObserver().removeGlobalOnLayoutListener(this);
                } else {
                    listView.getViewTreeObserver().removeOnGlobalLayoutListener(this);
                }
            }
        });
        listView.setOnItemLongClickListener(new AdapterView.OnItemLongClickListener() {
            @Override
            public boolean onItemLongClick(AdapterView<?> parent, View view, int position, long id) {
                position = position - listView.getHeaderViewsCount();
                longClickPosition = position;
                return false;
            }
        });
        listView.setOnCreateContextMenuListener(new View.OnCreateContextMenuListener() {
            public void onCreateContextMenu(ContextMenu menu, View v, ContextMenu.ContextMenuInfo menuInfo) {
                //在上下文菜单选项中添加选项内容
                //add方法的参数：add(分组id,itemid, 排序, 菜单文字)
                menu.add(0, Menu.FIRST, 0, "备注名字");
                menu.add(0, Menu.FIRST + 1, 0, "删除");
            }
        });
        setAdapter(null);
    }

    /**
     * 初始化搜索框
     */
    private void initSeatchEdit() {
        mClearEditText = (ClearEditText) findViewById(R.id.filterEdit);
        mClearEditText.setHint("请输入名字查找");
        mClearEditText.setFilters(new InputFilter[]{new InputFilter.LengthFilter(20)});
        // 根据输入框输入值的改变来过滤搜索
        mClearEditText.addTextChangedListener(new TextWatcher() {
            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                // 当输入框里面的值为空，更新为原来的列表，否则为过滤数据列表
                filterData(s.toString());
            }

            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {
            }

            @Override
            public void afterTextChanged(Editable s) {
            }
        });
    }

    /**
     * 根据输入框中的值来过滤数据并更新ListView
     *
     * @param mMatchString 筛选文字
     */
    private void filterData(final String mMatchString) {
        if (adapter == null || list == null || list.size() == 0) {
            return;
        }
        matchString = mMatchString;
        new Thread(new Runnable() {
            @Override
            public void run() {
                final List<GroupMemberInfo> filterDataList = SearchMatchingUtil.match(GroupMemberInfo.class, list, matchString);
                if (mMatchString.equals(matchString)) {
                    runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            defaultText.setText(filterDataList == null || filterDataList.size() == 0 ?
                                    SearchEditextHanlderResult.getEmptyResultString(ContactsActivity.class.getName()) :
                                    SearchEditextHanlderResult.getUoEmptyResultString(ContactsActivity.class.getName()));
                            adapter.setFilterValue(mMatchString);
                            setAdapter(filterDataList);
                        }
                    });
                }
            }
        }).start();
    }


    /**
     * 计算默认页 高度
     *
     * @param listView
     * @param contactHeadViewHeight 头部高度
     */
    private void calculateDefaultHeight(ListView listView, int contactHeadViewHeight) {
        int listViewHeight = listView.getHeight();
        View layout = contactDefaultLayout.findViewById(R.id.contentLayout);
        LinearLayout.LayoutParams params = (LinearLayout.LayoutParams) layout.getLayoutParams();
        params.height = listViewHeight - contactHeadViewHeight - DensityUtils.dp2px(this, 7);
        layout.setLayoutParams(params);
    }


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.groupChat: //群聊
                ChooseTeamActivity.actionStart(this, MessageUtil.TYPE_GROUP_CHAT, null, null, null, MessageUtil.WAY_GROUP_TEAM_GROUPCHAT_SEE_MEMBER);
                break;
            case R.id.workCircle: //项目
                ChooseTeamActivity.actionStart(this, MessageUtil.TYPE_GROUP_AND_TEAM, null, null, null, MessageUtil.WAY_GROUP_TEAM_GROUPCHAT_SEE_MEMBER);
                break;
            case R.id.newFriendLayout: //新朋友
                newFriendCountText.setVisibility(View.GONE);
                newFriendWeight.setVisibility(View.GONE);
                FriendApplicationListActivity.actionStart(this);
                break;
            case R.id.rightImage: //黑名单、添加朋友弹出框
                new ContactPopWindow(this).showAsDropDown(rightImage, 0, 0);
                break;
        }
    }


    /**
     * 删除联系人
     *
     * @param uid 被删除人id
     */
    private void removeUser(final String uid) {
        String httpUrl = NetWorkRequest.DEL_FRIEND;
        RequestParams params = RequestParamsToken.getExpandRequestParams(getApplicationContext());
        params.addBodyParameter("uid", uid);
        CommonHttpRequest.commonRequest(this, httpUrl, GroupMemberInfo.class, true, params, true, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                DBMsgUtil.getInstance().deleteMessage(ContactsActivity.this, uid, WebSocketConstance.SINGLECHAT);
                adapter.getList().remove(longClickPosition);
                adapter.notifyDataSetChanged();
                if (!TextUtils.isEmpty(mClearEditText.getText().toString())) {
                    mClearEditText.setText("");
                }
                setAdapter(list);
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {

            }
        });
    }


    //    给菜单项添加事件
    @Override
    public boolean onContextItemSelected(MenuItem item) {
        //参数为用户选择的菜单选项对象
        //根据菜单选项的id来执行相应的功能
        switch (item.getItemId()) {
            case Menu.FIRST: //备注名字
                ModifyGroupTeamInfoActivity.actionStart(this, adapter.getList().get(longClickPosition).getReal_name(),
                        null, null, adapter.getList().get(longClickPosition).getUid(), ModifyGroupTeamInfoActivity.UPDATE_PERSON_REMARK);
                break;
            case Menu.FIRST + 1: //删除通讯录好友
                new DialogTips(this, new DiaLogTitleListener() {
                    @Override
                    public void clickAccess(int position) {
                        removeUser(adapter.getList().get(longClickPosition).getUid());
                    }
                }, "删除朋友，同时将删除与TA的聊天记录，你确定要删除吗？", DialogTips.REMOVE_CONTACT_MEMBER).show();
                break;
        }
        return super.onOptionsItemSelected(item);
    }

    private void setAdapter(List<GroupMemberInfo> list) {
        searchView.setVisibility((list == null || list.size() == 0) && TextUtils.isEmpty(matchString) ? View.GONE : View.VISIBLE);
        if (adapter == null) {
            adapter = new CommonPersonListAdapter(this, list, false);
            adapter.setHiddenTel(true);
            listView.setAdapter(adapter);
        } else {
            adapter.updateListView(list);
        }
        int footCount = listView.getFooterViewsCount();
        if (list != null && list.size() > 0) {
            if (footCount > 0) {
                listView.removeFooterView(contactDefaultLayout);
            }
        } else {
            if (footCount == 0) {
                listView.addFooterView(contactDefaultLayout, null, false);
            }
        }
    }

//    /**
//     * 广播回调
//     */
//    class MessageBroadcast extends BroadcastReceiver {
//        @Override
//        public void onReceive(Context context, Intent intent) {
//            String action = intent.getAction();
//            if (action.equals(WebSocketConstance.ACTION_SINGLE_CHAT)) { //获取通讯录单聊列表
//                GroupManager manager = (GroupManager) intent.getSerializableExtra(Constance.BEAN_CONSTANCE);
//                if (!TextUtils.isEmpty(manager.getClass_type()) && manager.getClass_type().equals(WebSocketConstance.FRIENDCHATS)) {
//                    List<GroupMemberInfo> serverList = manager.getMember_list();
//                    if (serverList != null && serverList.size() > 0) {
//                        Utils.setPinYinAndSort(serverList);
//                    }
//                    setAdapter(serverList);
//                    list = serverList;
//                }
//            } else if (action.equals(WebSocketConstance.ACTION_GET_TEMPORARYFRIEND)) { //获取新好友临时列表
//                FriendValidate friendBean = (FriendValidate) intent.getSerializableExtra(Constance.BEAN_CONSTANCE);
//                if (friendBean != null && !TextUtils.isEmpty(friendBean.getReal_name())) {
//                    newFriendWeight.setDEFAULT_TEXT_SIZE(13);
//                    newFriendWeight.setView(friendBean.getHead_pic(), friendBean.getReal_name(), 0);
//                    newFriendWeight.setVisibility(View.VISIBLE);
//                    newFriendCountText.setVisibility(View.VISIBLE);
//                } else {
//                    newFriendCountText.setVisibility(View.GONE);
//                    newFriendWeight.setVisibility(View.GONE);
//                }
//            }
//        }
//    }


    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == Constance.CLICK_SINGLECHAT) { //点击单聊消息
            setResult(resultCode, data);
            finish();
        } else if (resultCode == Constance.CLICK_GROUP_CHAT) { //点击群聊消息
            setResult(resultCode, data);
            finish();
        } else if (resultCode == Constance.SUCCESS) { //设置好友备注名称回调
            String commentName = data.getStringExtra(Constance.COMMENT_NAME);
            if (!TextUtils.isEmpty(commentName)) {
                adapter.getList().get(longClickPosition).setSortLetters(null);
                adapter.getList().get(longClickPosition).setReal_name(commentName);
                Utils.setPinYinAndSort(adapter.getList());
                adapter.notifyDataSetChanged();
            }
        } else {
            getChatFriendsData();
        }
    }

    /**
     * 注册广播
     */
    private void registerReceiver() {
        IntentFilter filter = new IntentFilter();
        filter.addAction(WebSocketConstance.RED_DOTMESSAGE);
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
            switch (action) {
                case WebSocketConstance.RED_DOTMESSAGE: //接收消息
                    MessageBean friendBean = (MessageBean) intent.getSerializableExtra(Constance.BEAN_CONSTANCE);
                    if (friendBean != null && !TextUtils.isEmpty(friendBean.getReal_name()) && MessageType.ADD_FRIEND_REDDOT_MESSAGE.equals(friendBean.getMsg_type())) {
                        newFriendWeight.setDEFAULT_TEXT_SIZE(13);
                        newFriendWeight.setView(friendBean.getHead_pic(), friendBean.getReal_name(), 0);
                        newFriendWeight.setVisibility(View.VISIBLE);
                        newFriendCountText.setVisibility(View.VISIBLE);
                    } else {
                        newFriendCountText.setVisibility(View.GONE);
                        newFriendWeight.setVisibility(View.GONE);
                    }
                    break;
            }
        }
    }
}
