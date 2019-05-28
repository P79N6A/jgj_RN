package com.jizhi.jlongg.main.fragment;

import android.annotation.SuppressLint;
import android.content.Intent;
import android.net.ConnectivityManager;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.text.Editable;
import android.text.InputFilter;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.ContextMenu;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;

import com.hcs.uclient.utils.LUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.AppMainActivity;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.activity.ContactsActivity;
import com.jizhi.jlongg.main.activity.FriendApplicationListActivity;
import com.jizhi.jlongg.main.activity.NetFailActivity;
import com.jizhi.jlongg.main.activity.RecruitMessageActivity;
import com.jizhi.jlongg.main.activity.WorkMessageActivity;
import com.jizhi.jlongg.main.activity.X5WebViewActivity;
import com.jizhi.jlongg.main.adpter.GroupChatAdapter;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.AddFriendsSources;
import com.jizhi.jlongg.main.bean.BaseNetBean;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;
import com.jizhi.jlongg.main.dialog.DialogLeftRightBtnConfirm;
import com.jizhi.jlongg.main.msg.MessageType;
import com.jizhi.jlongg.main.msg.ShakyActivity;
import com.jizhi.jlongg.main.popwindow.ChatAddPopWindow;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DBMsgUtil;
import com.jizhi.jlongg.main.util.IsSupplementary;
import com.jizhi.jlongg.main.util.MessageUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SearchEditextHanlderResult;
import com.jizhi.jlongg.main.util.SearchMatchingUtil;
import com.jizhi.jlongg.main.util.ThreadPoolUtils;
import com.jizhi.jlongg.main.util.WebSocketConstance;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

/**
 * 聊天Fragment
 *
 * @author xuj
 * @version 2.0.0
 * @time 2016-12-19 16:01:54
 */
@SuppressLint("ValidFragment")
public class ChatFragment extends BaseFragment implements View.OnClickListener {
    /**
     * 聊天列表适配器
     */
    private GroupChatAdapter adapter;
    /**
     * 长按事件点击的下标
     */
    private int longClickPostion;
    /**
     * 列表数据
     */
    private ArrayList<GroupDiscussionInfo> list;
    /**
     * 顶部 右边按钮
     */
    private ImageView rightImage;
    /**
     * 搜索框输入的筛选文本
     */
    private String matchString;
    /**
     * 无数据时显示文本
     */
    private TextView defaultText, defaultText1;
    /**
     * 网络连接失败布局
     */
    private LinearLayout netFailLayout;
    /**
     * listView
     */
    private ListView listView;
    /**
     * 是否已修改了群聊信息
     * 如果在项目或班组设置里面进行了修改数据那么会发送一条广播将这个变量设为true
     * 如果这个变量为true  则每次回到这个页面 都会重新读取本地数据库进行数据的刷新
     * 默认为false
     */
    private boolean isUpdateListInfo = false;
    /**
     * 当前Activity是否在前台
     */
    private boolean isFront = false;
    /**
     * 是否在加载本地数据库
     */
    private boolean isLoadingDataBase;
    /**
     * 人脉资源头部
     */
    private View veinView;

    @Override
    public void onPause() {
        super.onPause();
        isFront = false;
    }

    @Override
    public void onResume() {
        super.onResume();
        isFront = true;
        if (isUpdateListInfo) {
            isUpdateListInfo = false;
            loadLocalDataBaseData();
        }
    }


    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View main_view = inflater.inflate(R.layout.main_chat, container, false);
        return main_view;
    }

    @Override
    public void onActivityCreated(@Nullable Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        initView();
        loadLocalDataBaseData();
        MessageUtil.getChatListData(getActivity(), true); //获取聊聊数据
    }

    private void initView() {
        ((TextView) getView().findViewById(R.id.title)).setText(getString(R.string.main_bottom_group_chat));
        listView = (ListView) getView().findViewById(R.id.listView);
        veinView = getActivity().getLayoutInflater().inflate(R.layout.vein_resource_head, null);
        veinView.findViewById(R.id.vein_resouces_layout).setOnClickListener(this);
        listView.addHeaderView(veinView, null, false);
        setDefaultLayout();
        rightImage = (ImageView) getView().findViewById(R.id.rightImage);
        rightImage.setImageResource(R.drawable.add_icon_new);
        netFailLayout = (LinearLayout) getView().findViewById(R.id.netFailLayout);
        getView().findViewById(R.id.returnText).setVisibility(View.GONE);
        rightImage.setOnClickListener(this);
        EditText mClearEditText = (EditText) getView().findViewById(R.id.filterEdit);
        mClearEditText.setHint("搜索");
        mClearEditText.setFilters(new InputFilter[]{new InputFilter.LengthFilter(20)}); //设置搜索长度最大为20
        mClearEditText.addTextChangedListener(new TextWatcher() { //根据输入框输入值的改变来过滤搜索
            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                filterData(s.toString());
            }

            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {
            }

            @Override
            public void afterTextChanged(Editable s) {
            }
        });
        netFailLayout.setOnClickListener(this); //网络连接失败
    }

    private void setDefaultLayout() {
        defaultText = (TextView) getView().findViewById(R.id.defaultDesc);
        defaultText1 = (TextView) getView().findViewById(R.id.defaultDesc1);
        defaultText1.setVisibility(View.VISIBLE);

        defaultText.setText(SearchEditextHanlderResult.getDefaultResultString(this.getClass().getName()));
        defaultText1.setText("你与工友或同事发起单聊或群聊将在此页展示");
        defaultText1.setTextSize(13);
    }


    /**
     * 根据输入框中的值来过滤数据并更新ListView
     *
     * @param mMatchString
     */
    private void filterData(final String mMatchString) {
        if (adapter == null || list == null || list.size() == 0) {
            return;
        }
        matchString = mMatchString;
        ThreadPoolUtils.fixedThreadPool.execute(new Runnable() {
            @Override
            public void run() {
                final List<GroupDiscussionInfo> filterDataList = SearchMatchingUtil.match(GroupDiscussionInfo.class, list, matchString);
                if (mMatchString.equals(matchString)) {
                    getActivity().runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            defaultText.setText(filterDataList == null || filterDataList.size() == 0 ?
                                    SearchEditextHanlderResult.getEmptyResultString(ContactsActivity.class.getName()) :
                                    SearchEditextHanlderResult.getUoEmptyResultString(ContactsActivity.class.getName()));
                            if (TextUtils.isEmpty(matchString)) {
                                if (listView.getHeaderViewsCount() == 0) {
                                    listView.addHeaderView(veinView, null, false);
                                }
                            } else {
                                if (listView.getHeaderViewsCount() > 0) {
                                    listView.removeHeaderView(veinView);
                                }
                            }
                            defaultText1.setVisibility(filterDataList == null || filterDataList.size() == 0 ? View.GONE : View.VISIBLE);
                            adapter.setFilterValue(mMatchString);
                            adapter.updateListView(filterDataList);
                        }
                    });
                }
            }
        });
    }


    @Override
    public void initFragmentData() {
        if (!UclientApplication.isLogin(getActivity())) { //未登录
            if (adapter != null) {
                adapter.updateListView(null);
            }
        }
    }


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.netFailLayout: //网络连接失败
                Intent intent = new Intent(getActivity(), NetFailActivity.class);
                startActivity(intent);
                break;
            case R.id.rightImage: //扫一扫、发起群聊等弹出框
                new ChatAddPopWindow(getActivity()).showAsDropDown(rightImage, 0, 0);    //显示窗口
                break;
            case R.id.vein_resouces_layout://人脉资源
                AddFriendsSources.create().setReset(true).setSource(AddFriendsSources.SOURCE_PEOPLE_CONNECTION);
                X5WebViewActivity.actionStart(getActivity(), NetWorkRequest.WEBURLS + "connection");
                break;
        }
    }

    /**
     * 处理广播消息
     *
     * @param action
     * @param intent
     */
    public void handlerBroadcastData(String action, Intent intent) {
        switch (action) {
            case WebSocketConstance.LOAD_CHAT_LIST://加载消息列表Http数据成功后的回调
                loadLocalDataBaseData();
                break;
            case WebSocketConstance.REFRESH_LOCAL_DATABASE_MAIN_INDEX_AND_CHAT_LIST://当接收到这个广播的时候就刷新本地列表数据
            case WebSocketConstance.REFRESH_SERVER_MAIN_INDEX_AND_CHAT_LIST:
                if (isFront) { //如果是在首页页面的话 直接刷新数据
                    loadLocalDataBaseData();
                } else { //如果是在其他页面接受到了刷新标识 则设置变量 当onResume在去刷新数据
                    isUpdateListInfo = true;
                }
                break;
            case ConnectivityManager.CONNECTIVITY_ACTION: //网络状态发生变化时候的调用
                boolean isConnectionNet = intent.getBooleanExtra(Constance.BEAN_BOOLEAN, false);
                netFailLayout.setVisibility(isConnectionNet ? View.GONE : View.VISIBLE);
                break;
        }
    }


    /**
     * 加载本地数据库数据
     */
    private void loadLocalDataBaseData() {
        LUtils.e("刷新聊聊数据:" + new SimpleDateFormat("yyyy-MM-dd hh:ss:mm").format(new java.util.Date()));
        if (!isLoadingDataBase) {
            isLoadingDataBase = true;
            //加载离线消息有可能速度会很快，频繁刷新数据库不是很好，我们这里每次只要涉及到加载数据库的操作就延迟0.2秒
            ThreadPoolUtils.fixedThreadPool.execute(new Runnable() {
                @Override
                public void run() {
                    try {
                        Thread.sleep(100);
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }
                    final ArrayList<GroupDiscussionInfo> list = MessageUtil.getLocalChatListData(false);
                    int totalUnreadMessageCount = 0;
                    if (list != null && list.size() > 0) { //设置聊聊总的消息未读数
                        for (GroupDiscussionInfo groupDiscussionInfo : list) {
                            if (groupDiscussionInfo.is_no_disturbed == 0) { //只统计未开启免打扰的群聊
                                totalUnreadMessageCount += groupDiscussionInfo.getUnread_msg_count();
                            }
                        }
                    }
                    final int finalTotalUnreadMessageCount = totalUnreadMessageCount;
                    getActivity().runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            //设置首页消息未读数
                            ((AppMainActivity) getActivity()).setGroupChatCount(finalTotalUnreadMessageCount);
                            setAdapter(list);
                            isLoadingDataBase = false;
                        }
                    });
                }
            });
        }
    }

    /**
     * 设置ListView列表适配器
     *
     * @param list
     */
    private void setAdapter(final ArrayList<GroupDiscussionInfo> list) {
        this.list = list;
        if (adapter == null) {
            adapter = new GroupChatAdapter((BaseActivity) getActivity(), list, new GroupChatAdapter.SelecteProListener() {
                @Override
                public void selecte(GroupDiscussionInfo groupDiscussionInfo) { //设置班组、项目组去首页回调
                    MessageUtil.setIndexList(getActivity(), groupDiscussionInfo, true, true);
                }
            });
            listView.setEmptyView(getView().findViewById(R.id.defaultLayout));
            listView.setAdapter(adapter);
            listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                @Override
                public void onItemClick(AdapterView<?> parent, View view, final int position, long id) {
                    //检测是否已完善了姓名
                    IsSupplementary.isFillRealNameCallBackListener(getActivity(), false, new IsSupplementary.CallSupplementNameSuccess() {
                        @Override
                        public void onSuccess() {
                            GroupDiscussionInfo groupDiscussionInfo = adapter.getList().get(position - listView.getHeaderViewsCount());
                            if (groupDiscussionInfo.getIs_closed() == 1) {
                                CommonMethod.makeNoticeLong(getActivity(), "该" + (groupDiscussionInfo.getClass_type().equals(WebSocketConstance.GROUP) ? "班组" : "项目组")
                                        + "已经删除无法聊天", CommonMethod.ERROR);
                                return;
                            }
                            String groupId = groupDiscussionInfo.getGroup_id();
                            if (!TextUtils.isEmpty(groupId)) {
                                switch (groupId) {
                                    case MessageType.WORK_MESSAGE_ID: //工作消息
                                        WorkMessageActivity.actionStart(getActivity());
                                        MessageUtil.clearWorkRecruitActivityMessageUnreadCount(groupDiscussionInfo);
                                        loadLocalDataBaseData();
                                        break;
                                    case MessageType.ACTIVITY_MESSAGE_ID: //活动消息
                                        ShakyActivity.actionStart(getActivity(), groupDiscussionInfo);
                                        MessageUtil.clearWorkRecruitActivityMessageUnreadCount(groupDiscussionInfo);
                                        loadLocalDataBaseData();
                                        break;
                                    case MessageType.RECRUIT_MESSAGE_ID: //招聘消息
                                        RecruitMessageActivity.actionStart(getActivity());
                                        MessageUtil.clearWorkRecruitActivityMessageUnreadCount(groupDiscussionInfo);
                                        loadLocalDataBaseData();
                                        break;
                                    case MessageType.NEW_FRIEND_MESSAGE_ID: //新的朋友
                                        FriendApplicationListActivity.actionStart(getActivity());
                                        MessageUtil.clearWorkRecruitActivityMessageUnreadCount(groupDiscussionInfo);
                                        loadLocalDataBaseData();
                                        break;
                                    default: //普通消息
                                        MessageUtil.clearUnreadMessageCount(getActivity(), groupDiscussionInfo);
                                        break;
                                }
                            }
                        }
                    });
                }
            });
            listView.setOnItemLongClickListener(new AdapterView.OnItemLongClickListener() {
                @Override
                public boolean onItemLongClick(AdapterView<?> parent, View view, int position, long id) {
                    longClickPostion = position - listView.getHeaderViewsCount();
                    return false;
                }
            });
            listView.setOnCreateContextMenuListener(new View.OnCreateContextMenuListener() {
                public void onCreateContextMenu(ContextMenu menu, View v, ContextMenu.ContextMenuInfo menuInfo) {
                    //add方法的参数：add(分组id,itemid, 排序, 菜单文字)
                    GroupDiscussionInfo info = adapter.getList().get(longClickPostion);
                    menu.add(0, Menu.FIRST, 0, info.getIs_sticked() == 0 ? "置顶" : "取消置顶");
                    menu.add(0, Menu.FIRST + 1, 0, "删除");
                }
            });
        } else {
            if (!TextUtils.isEmpty(matchString)) {
                filterData(matchString);
            } else {
                adapter.updateListView(list);
            }
        }
    }


    @Override
    public boolean onContextItemSelected(MenuItem item) {
        //参数为用户选择的菜单选项对象
        //根据菜单选项的id来执行相应的功能
        final GroupDiscussionInfo info = adapter.getList().get(longClickPostion);
        switch (item.getItemId()) {
            case Menu.FIRST: //置顶、取消置顶
                final int toggle = info.getIs_sticked() == 0 ? 1 : 0; //true表示消息置顶 false表示不需要
                MessageUtil.modifyTeamGroupInfo(getActivity(), info.getGroup_id(), info.getClass_type(), null, null, null, null,
                        toggle + "", null, new CommonHttpRequest.CommonRequestCallBack() {
                            @Override
                            public void onSuccess(Object object) {
                                MessageUtil.modityLocalTeamGroupInfo(getActivity(), toggle + "", null, null, info.getGroup_id(), info.getClass_type(),
                                        null, null, null, null, 0, null, null, null, null);
                                loadLocalDataBaseData();
                            }

                            @Override
                            public void onFailure(HttpException exception, String errormsg) {

                            }
                        });
                break;
            case Menu.FIRST + 1: //移除聊天
                DialogLeftRightBtnConfirm dialogLeftRightBtnConfirm = new DialogLeftRightBtnConfirm(getActivity(), null, "删除后，将清空该聊天的消息记录",
                        new DialogLeftRightBtnConfirm.LeftRightBtnListener() {
                            @Override
                            public void clickLeftBtnCallBack() {

                            }

                            @Override
                            public void clickRightBtnCallBack() {
//                                CommonMethod.makeNoticeLong(getActivity(), "删除消息成功！", CommonMethod.SUCCESS);
//                                info.setIs_delete(1); //在本地数据库标识一下已删除的标记
//                                info.setIs_sticked(0);//在本地数据库标识取消置顶的标记
//                                info.setUnread_msg_count(0); //清空聊天未读数
//                                info.saveOrUpdate("group_id = ? and class_type = ? and message_uid = ?",
//                                        info.getGroup_id(), info.getClass_type(), UclientApplication.getUid()); //重新保存一下
//                                DBMsgUtil.getInstance().clearGroupMessage(info.getGroup_id(), info.getClass_type());//清空群聊信息
//                                loadLocalDataBaseData();

                                RequestParams params = RequestParamsToken.getExpandRequestParams(getActivity());
                                params.addBodyParameter("group_id", info.getGroup_id());
                                params.addBodyParameter("class_type", info.getClass_type());
                                String httpUrl = NetWorkRequest.DEL_CHAT;
                                CommonHttpRequest.commonRequest(getActivity(), httpUrl, BaseNetBean.class, CommonHttpRequest.OBJECT, params, true, new CommonHttpRequest.CommonRequestCallBack() {
                                    @Override
                                    public void onSuccess(Object object) {
                                        CommonMethod.makeNoticeLong(getActivity(), "删除消息成功！", CommonMethod.SUCCESS);
                                        DBMsgUtil.getInstance().clearGroupMessage(info.getGroup_id(), info.getClass_type());//清空群聊信息
                                        MessageUtil.deleteLocalGroupInfo(info.getGroup_id(), info.getClass_type()); //移除列表对应消息
                                        loadLocalDataBaseData();
                                    }

                                    @Override
                                    public void onFailure(HttpException exception, String errormsg) {

                                    }
                                });

                            }
                        });
                dialogLeftRightBtnConfirm.setRightBtnText("删除");
                dialogLeftRightBtnConfirm.show();


                break;
        }
        return super.onOptionsItemSelected(item);
    }


    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == Constance.UPGRADE) { //如果为升级班组则调用Activity刷新所有数据
            AppMainActivity mainActivity = (AppMainActivity) getActivity();
            mainActivity.onTabClicked(mainActivity.getmTabs()[0]);
        }
    }


    /**
     * 滑动到顶部
     */
    public void scrollToTop() {
        if (adapter != null && adapter.getCount() > 0) {
            listView.setSelection(0);
        }
    }
}
