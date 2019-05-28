//package com.jizhi.jlongg.main.activity;
//
//import android.content.BroadcastReceiver;
//import android.content.Context;
//import android.content.Intent;
//import android.content.IntentFilter;
//import android.os.Bundle;
//import android.text.Html;
//import android.text.TextUtils;
//import android.view.Gravity;
//import android.view.View;
//import android.widget.ListView;
//import android.widget.RelativeLayout;
//import android.widget.TextView;
//
//import com.hcs.uclient.utils.CallPhoneUtil;
//import com.jizhi.jlongg.R;
//import com.jizhi.jlongg.main.adpter.MergeSynProjectAdapter;
//import com.jizhi.jlongg.main.application.UclientApplication;
//import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;
//import com.jizhi.jlongg.main.bean.GroupMemberInfo;
//import com.jizhi.jlongg.main.bean.NewMessage;
//import com.jizhi.jlongg.main.bean.Project;
//import com.jizhi.jlongg.main.bean.ReleaseProjectInfo;
//import com.jizhi.jlongg.main.bean.SynchMerge;
//import com.jizhi.jlongg.main.bean.status.CommonListJson;
//import com.jizhi.jlongg.main.dialog.DiaLogNoMoreProject;
//import com.jizhi.jlongg.main.dialog.DiaLogSynchMerge;
//import com.jizhi.jlongg.main.dialog.DialogOnlyTitle;
//import com.jizhi.jlongg.main.dialog.DialogTeamManageSourceMemberTips;
//import com.jizhi.jlongg.main.dialog.WheelViewJoinTeam;
//import com.jizhi.jlongg.main.listener.CallBackSingleWheelListener;
//import com.jizhi.jlongg.main.listener.DiaLogTitleListener;
//import com.jizhi.jlongg.main.listener.SelectSynchProListener;
//import com.jizhi.jlongg.main.util.BackGroundUtil;
//import com.jizhi.jlongg.main.util.CommonMethod;
//import com.jizhi.jlongg.main.util.Constance;
//import com.jizhi.jlongg.main.util.DataUtil;
//import com.jizhi.jlongg.main.util.MessageUtil;
//import com.jizhi.jlongg.main.util.RequestParamsToken;
//import com.jizhi.jlongg.main.util.SingsHttpUtils;
//import com.jizhi.jlongg.main.util.WebSocket;
//import com.jizhi.jlongg.main.util.WebSocketConstance;
//import com.jizhi.jlongg.network.NetWorkRequest;
//import com.jizhi.jongg.widget.RoundeImageHashCodeTextLayout;
//import com.lidroid.xutils.HttpUtils;
//import com.lidroid.xutils.ViewUtils;
//import com.lidroid.xutils.exception.HttpException;
//import com.lidroid.xutils.http.RequestParams;
//import com.lidroid.xutils.http.ResponseInfo;
//import com.lidroid.xutils.http.callback.RequestCallBack;
//import com.lidroid.xutils.http.client.HttpRequest;
//import com.lidroid.xutils.view.annotation.ViewInject;
//
//import java.util.ArrayList;
//import java.util.List;
//
///**
// * 功能:新消息、同步想详情
// * 时间:2016/3/11 11:39
// * 作者:xuj
// */
//public class NewMessageDetailActivity extends BaseActivity implements View.OnClickListener, SelectSynchProListener {
//
//
//    /* 项目名称 */
//    @ViewInject(R.id.projectContainingValue)
//    private TextView projectContainingValue;
//    /* 底部确认按钮*/
//    @ViewInject(R.id.red_btn)
//    private TextView confirmBtn;
//    @ViewInject(R.id.bottom_layout)
//    private RelativeLayout bottomLayout;
//    /* 滑动View */
//    private WheelViewJoinTeam wheelView;
//    /* 点击状态 */
//    private int state;
//    /* 加入班组 */
//    private final int JOIN_TEAM = 0;
//    /* 新建班组 */
//    private final int CREATE_TEAM = 1;
//    /* 同步项目 */
//    private final int SYN_PROJECT = 2;
//    /* 创建项目 */
//    private final int CREATE_PROJECT = 3;
//    /* 组id */
//    private String id;
//    /* 同步项目适配器 */
//    private MergeSynProjectAdapter adapter;
//    /* 与我相关项目数据 */
//    private List<Project> projectList;
//    /* 当前选中的项目 */
//    private Project selectProject;
//    /* 新通知对象 */
//    private NewMessage noticeObj;
//    /* 同步的项目从哪来弹窗 */
//    private DialogTeamManageSourceMemberTips dialog;
//
//
//    @Override
//    protected void onCreate(Bundle savedInstanceState) {
//        super.onCreate(savedInstanceState);
//        setContentView(R.layout.message_detail);
//        ViewUtils.inject(this);
//        init();
//        registerReceiver();
//    }
//
//    private void init() {
//        TextView telText = (TextView) findViewById(R.id.telephone); //电话号码
//        RoundeImageHashCodeTextLayout headImage = (RoundeImageHashCodeTextLayout) findViewById(R.id.headPic); //头像
//        TextView accountObject = (TextView) findViewById(R.id.accountObjectText); //记账对象
//        TextView userNameText = (TextView) findViewById(R.id.user_name); //记账对象
//        bottomLayout.setVisibility(View.GONE);
//
//        Intent intent = getIntent();
//        NewMessage newMessage = (NewMessage) intent.getSerializableExtra(Constance.BEAN_CONSTANCE);
//        String type = newMessage.getClass_type();
//        setTextTitle(type.equals(WebSocketConstance.NEW_BILLING) ? R.string.new_message_detail : R.string.sync_project_detal);
//        headImage.setView(newMessage.getMembers_head_pic().get(0), newMessage.getUser_name(), 0);
//        telText.setText(newMessage.getTelphone());
//        userNameText.setText(newMessage.getUser_name());
//        if (type.equals(WebSocketConstance.NEW_BILLING)) { //新记账人
//            accountObject.setText(Html.fromHtml("<font color='#999999'>有新工友&nbsp;</font><font color='#333333'>"
//                    + newMessage.getUser_name() + "</font><font color='#999999'>&nbsp;对你记了一笔账!</font>"));
//            findViewById(R.id.newBillLayout).setVisibility(View.VISIBLE);
//        } else { //添加为数据来源人时 选择同步时的操作
//            accountObject.setText(newMessage.getUser_name() + "要求你同步项目数据");
//            confirmBtn.setText(getString(R.string.synchpro));
//            id = newMessage.getTeam_id();
//            state = SYN_PROJECT;
//            findViewById(R.id.syn_layout).setVisibility(View.VISIBLE);
//            findViewById(R.id.gray_background).setVisibility(View.GONE);
//            getMySelfProject();
//        }
//        noticeObj = newMessage;
//    }
//
//
//    @Override
//    public void onClick(View v) {
//        switch (v.getId()) {
//            case R.id.telephone: //拨打电话
//                CallPhoneUtil.callPhone(this, noticeObj.getTelphone());
//                break;
//            case R.id.newBillLayout: //获取所在项目
//                handlerProject();
//                break;
//            case R.id.red_btn:
//                handlerSubmit();
//                break;
//            case R.id.synch_from: //同步项目数据从哪来
//                if (dialog == null) {
//                    dialog = new DialogTeamManageSourceMemberTips(this, getString(R.string.synch_from_title), getString(R.string.synch_from));
//                }
//                dialog.show();
//                break;
//        }
//    }
//
//
//    private void handlerSubmit() {
//        switch (state) {
//            case JOIN_TEAM: //加入班组
//                joinTeam();
//                break;
//            case CREATE_TEAM: //新建班组
//                createTeam();
//                break;
//            case SYN_PROJECT: //同步项目
//                getMergeProject();
//                break;
//            case CREATE_PROJECT: //创建项目名称
//                Intent intent = new Intent(getApplicationContext(), AddProjectActivity.class);
//                startActivityForResult(intent, Constance.REQUEST);
//                break;
//        }
//    }
//
//    /**
//     * 获取成员信息
//     *
//     * @return
//     */
//    private List<GroupMemberInfo> getMemberInfo() {
//        GroupMemberInfo groupMemberInfo = new GroupMemberInfo();
////        groupMemberInfo.setTelphone(noticeObj.getTelphone());
//        groupMemberInfo.setReal_name(noticeObj.getUser_name());
//        List<GroupMemberInfo> list = new ArrayList<>();
//        list.add(groupMemberInfo);
//        return list;
//    }
//
//    /**
//     * 加入班组
//     */
//    private void joinTeam() {
////        WebSocket webSocket = UclientApplication.getInstance().getSocketManager().getWebSocket();
////        if (webSocket != null) {
////            group.setAction(WebSocketConstance.ACTION_ADD_MEMBERS);
////            group.setCtrl(WebSocketConstance.CTRL_IS_GROUP);
////            group.setGroup_id(id);
////            group.setIs_qr_code("0");
////            group.setBill_id(noticeObj.getBill_id());
////            group.setGroup_members(getMemberInfo());
////            webSocket.requestServerMessage(group, this);
////        }
//    }
//
//    /**
//     * 新建班组
//     */
//    private void createTeam() {
//        DialogOnlyTitle tips = new DialogOnlyTitle(NewMessageDetailActivity.this, new DiaLogTitleListener() {
//            @Override
//            public void clickAccess(int position) {
//                Intent intent = new Intent(NewMessageDetailActivity.this, CreateTeamGroupActivity.class);
//                intent.putExtra(Constance.TELEPHONE, noticeObj.getTelphone());
//                intent.putExtra(Constance.USERNAME, noticeObj.getUser_name());
//                intent.putExtra(Constance.HEAD_IMAGE, noticeObj.getMembers_head_pic().get(0));
//                intent.putExtra(Constance.BILLID, noticeObj.getBill_id());
//                intent.putExtra(Constance.BEAN_CONSTANCE, selectProject); //项目信息
//                startActivityForResult(intent, Constance.REQUEST);
//            }
//        }, 0, "当前选中的项目还未新建班组，确定新建班组吗？");
//        tips.show();
//    }
//
//
//    @Override
//    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
//        super.onActivityResult(requestCode, resultCode, data);
//        if (resultCode == MessageUtil.WAY_CREATE_GROUP_CHAT) { //新建班组成功
//            setResult(MessageUtil.WAY_CREATE_GROUP_CHAT, data);
//            finish();
//        } else if (resultCode == Constance.RESULTWORKERS) { //添加同步项目
//            Project project = (Project) data.getSerializableExtra(Constance.BEAN_CONSTANCE);
//            if (noticeObj.getClass_type().equals(WebSocketConstance.NEW_BILLING)) { //新记账人加入项目回调
//                projectList = new ArrayList<>();
//                projectList.add(project);
//                setSelectedProject(project);
//            } else { //同步项目回调
//                List<Project> projectList = new ArrayList<>();
//                projectList.add(project);
//                ListView listView = (ListView) findViewById(R.id.listView);
//                adapter = new MergeSynProjectAdapter(getApplicationContext(), projectList, this);
//                listView.setAdapter(adapter);
//                confirmBtn.setText(getString(R.string.synchpro));
//                bottomLayout.setVisibility(View.GONE);
//                findViewById(R.id.defaultLayout).setVisibility(View.GONE);
//                state = SYN_PROJECT;
//            }
//        }
//    }
//
//    /**
//     * 设置选中的项目
//     *
//     * @param selectedProject
//     */
//    private void setSelectedProject(Project selectedProject) {
//        bottomLayout.setVisibility(View.VISIBLE); //显示底部按钮
//        id = selectedProject.getGroup_id();
//        projectContainingValue.setText(selectedProject.getPro_name());
//        confirmBtn.setText(selectedProject.getIs_create_group() == 0 ? getString(R.string.create_group) : getString(R.string.addteamgroup));
//        state = selectedProject.getIs_create_group() == 0 ? CREATE_TEAM : JOIN_TEAM; //设置状态为加入班组或者新建班组
//        selectProject = selectedProject;
//    }
//
//
//    /**
//     * 查询所在项目
//     */
//    public void handlerProject() {
//        if (projectList == null || projectList.size() == 0) {
//            WebSocket webSocket = UclientApplication.getInstance().getSocketManager().getWebSocket();
//            if (webSocket != null) {
//                GroupDiscussionInfo group = new GroupDiscussionInfo();
////                group.setAction(WebSocketConstance.ACTION_GROUP_PRO_LIST);
////                group.setCtrl(WebSocketConstance.CTRL_IS_GROUP);
////                webSocket.requestServerMessage(group, this);
//            }
//            return;
//        }
//        if (wheelView == null) {
//            wheelView = new WheelViewJoinTeam(this, projectList, new WheelViewJoinTeam.ScrollSelectedProjectListener() {
//                @Override
//                public void selected(Project selectedBean) { //滑动选中项目
//                    setSelectedProject(selectedBean);
//                }
//            });
//        } else {
//            wheelView.update();
//        }
//        //显示窗口
//        wheelView.showAtLocation(findViewById(R.id.main), Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0); //设置layout在PopupWindow中显示的位置
//        BackGroundUtil.backgroundAlpha(this, 0.5F);
//    }
//
//    @Override
//    public void selected(int size) {
//        bottomLayout.setVisibility(size > 0 ? View.VISIBLE : View.GONE);
//    }
//
//
//    /**
//     * 广播回调
//     */
//    class MessageBroadcast extends BroadcastReceiver {
//        @Override
//        public void onReceive(Context context, Intent intent) {
//            String action = intent.getAction();
//            if (action.equals(WebSocketConstance.ACTION_GROUP_PRO_LIST)) { //获取所在项目
//                List<Project> list = (List<Project>) intent.getSerializableExtra(Constance.BEAN_CONSTANCE);
//                if (list != null && list.size() > 0) {
//                    projectList = list;
//                    handlerProject();
//                } else {
//                    DialogOnlyTitle tips = new DialogOnlyTitle(NewMessageDetailActivity.this, new DiaLogTitleListener() {
//                        @Override
//                        public void clickAccess(int position) {
//                            Intent intent1 = new Intent(NewMessageDetailActivity.this, AddProjectActivity.class);
//                            startActivityForResult(intent1, Constance.REQUEST);
//                        }
//                    }, 0, "暂时没有项目，确定创建项目吗？");
//                    tips.show();
//                }
//            } else if (action.equals(WebSocketConstance.ACTION_ADD_MEMBERS)) { //添加组成员
//                returnSuccess();
//            }
//        }
//    }
//
//
//    /**
//     * 注册广播
//     */
//    public void registerReceiver() {
//        IntentFilter filter = new IntentFilter();
//        filter.addAction(WebSocketConstance.ACTION_GROUP_PRO_LIST);
//        filter.addAction(WebSocketConstance.ACTION_ADD_MEMBERS);
//        receiver = new MessageBroadcast();
//        registerLocal(receiver, filter);
//    }
//
//    private void returnSuccess() {
//        setResult(MessageUtil.WAY_CREATE_GROUP_CHAT);
//        finish();
//    }
//
//
//    /**
//     * 项目参数
//     *
//     * @return
//     */
//    public RequestParams getParams() {
//        RequestParams params = RequestParamsToken.getExpandRequestParams(getApplicationContext());
//        params.addBodyParameter("uid", UclientApplication.getUid(getApplicationContext()));
//        params.addBodyParameter("pg", "1");
//        params.addBodyParameter("synced", "0");//1：已同步的项目列表 0：未同步的项目列表
//        return params;
//    }
//
//    /**
//     * 查询可以同步的项目
//     */
//    public void getMySelfProject() {
//        String url = NetWorkRequest.SYNCEDPRO;
//        HttpUtils http = SingsHttpUtils.getHttp();
//        http.send(HttpRequest.HttpMethod.POST, url, getParams(), new RequestCallBackExpand<String>() {
//            @Override
//            public void onSuccess(ResponseInfo<String> responseInfo) {
//                try {
//                    CommonListJson<Project> bean = CommonListJson.fromJson(responseInfo.result, Project.class);
//                    if (bean.getState() != 0) {
//                        final List<Project> list = bean.getValues();
//                        if (list != null && list.size() > 0) {
//                            ListView listView = (ListView) findViewById(R.id.listView);
//                            adapter = new MergeSynProjectAdapter(getApplicationContext(), list, NewMessageDetailActivity.this);
//                            listView.setAdapter(adapter);
//                        } else {
//                            state = CREATE_PROJECT;
//                            confirmBtn.setText(getString(R.string.create_pro));
//                            findViewById(R.id.defaultLayout).setVisibility(View.VISIBLE);
//                            bottomLayout.setVisibility(View.VISIBLE);
//                        }
//                    }
//                } catch (Exception e) {
//                    e.printStackTrace();
//                    CommonMethod.makeNoticeShort(getApplicationContext(), getString(R.string.service_err), CommonMethod.ERROR);
//                } finally {
//                    closeDialog();
//                }
//            }
//        });
//    }
//
//    /**
//     * 查询合并项目
//     */
//    public void getMergeProject() {
//        if (adapter != null && adapter.getList() != null && adapter.getList().size() > 0) {
//            final StringBuilder builder = new StringBuilder();
//            int i = 0;
//            for (Project bean : adapter.getList()) {
//                if (bean.isSelected()) {
//                    builder.append(i == 0 ? bean.getPid() + "," + bean.getPro_name() : ";" + bean.getPid() + "," + bean.getPro_name());
//                    i += 1;
//                }
//            }
//            if (TextUtils.isEmpty(builder.toString())) {
//                CommonMethod.makeNoticeShort(this, "请选择需要同步的项目", CommonMethod.ERROR);
//                return;
//            }
//            String url = NetWorkRequest.MERGECHECK;
//            HttpUtils http = SingsHttpUtils.getHttp();
//            RequestParams params = RequestParamsToken.getExpandRequestParams(getApplicationContext());
//            params.addBodyParameter("pro_str", builder.toString());
//            params.addBodyParameter("team_id", id);
//            http.send(HttpRequest.HttpMethod.POST, url, params, new RequestCallBackExpand<String>() {
//                @Override
//                public void onSuccess(ResponseInfo<String> responseInfo) {
//                    try {
//                        CommonListJson<SynchMerge> bean = CommonListJson.fromJson(responseInfo.result, SynchMerge.class);
//                        if (bean.getState() != 0) {
//                            List<SynchMerge> list = bean.getValues();
//                            if (list != null && list.size() > 0) {
//                                DiaLogSynchMerge synchDialog = new DiaLogSynchMerge(NewMessageDetailActivity.this, list, new CallBackSingleWheelListener() {
//                                    @Override
//                                    public void onSelected(String content, int postion) {
//                                        synchPro();
//                                    }
//                                });
//                                synchDialog.show();
//                            } else {
//                                synchPro();
//                            }
//                        } else {
//                            DataUtil.showErrOrMsg(NewMessageDetailActivity.this, bean.getErrno(), bean.getErrmsg());
//                            closeDialog();
//                        }
//                    } catch (Exception e) {
//                        e.printStackTrace();
//                        CommonMethod.makeNoticeShort(getApplicationContext(), getString(R.string.service_err), CommonMethod.ERROR);
//                        closeDialog();
//                    }
//                }
//            });
//        }
//    }
//
//    /**
//     * 同步项目
//     */
//    public void synchPro() {
//        String uid = noticeObj.getTarget_uid();
//        final StringBuilder builder = new StringBuilder();
//        final StringBuilder builderIds = new StringBuilder();
//        int i = 0;
//        for (Project bean : adapter.getList()) {
//            if (bean.isSelected()) {
//                builder.append(i == 0 ? uid + "," + bean.getPid() + "," + bean.getPro_name() : ";" + uid + "," + bean.getPid() + "," + bean.getPro_name());
//                builderIds.append(i == 0 ? bean.getPid() : "," + bean.getPid());
//                i += 1;
//            }
//        }
//        String url = NetWorkRequest.SYNCPRO;
//        RequestParams params = RequestParamsToken.getExpandRequestParams(getApplicationContext());
//        params.addBodyParameter("pro_info", builder.toString());
//        params.addBodyParameter("team_id", id);
//        HttpUtils http = SingsHttpUtils.getHttp();
//        http.send(HttpRequest.HttpMethod.POST, url,
//                params, new RequestCallBack<String>() {
//                    @Override
//                    public void onSuccess(ResponseInfo<String> responseInfo) {
//                        try {
//                            CommonListJson<ReleaseProjectInfo> bean = CommonListJson.fromJson(responseInfo.result, ReleaseProjectInfo.class);
//                            if (bean.getState() != 0) {
//                                sendNoticeReaded();
//                                agreeSynch(builderIds.toString());
//                                DiaLogNoMoreProject dialog = new DiaLogNoMoreProject(NewMessageDetailActivity.this, getString(R.string.syn_desc), false);
//                                dialog.show();
//                            } else {
//                                DataUtil.showErrOrMsg(NewMessageDetailActivity.this, bean.getErrno(), bean.getErrmsg());
//                            }
//                        } catch (Exception e) {
//                            CommonMethod.makeNoticeShort(getApplicationContext(), getString(R.string.service_err), CommonMethod.ERROR);
//                        } finally {
//                            closeDialog();
//                        }
//                    }
//
//                    @Override
//                    public void onFailure(HttpException exception, String errormsg) {
//                        printNetLog(errormsg, NewMessageDetailActivity.this);
//                        closeDialog();
//                    }
//                }
//        );
//    }
//
//
//    /**
//     * 发送通知已读
//     */
//    private void sendNoticeReaded() {
//        WebSocket webSocket = UclientApplication.getInstance().getSocketManager().getWebSocket();
//        if (webSocket != null) {
//            WebSocketBaseParameter group = new WebSocketBaseParameter();
//            group.setAction(WebSocketConstance.ACTION_NOTICE_READED);
//            group.setCtrl(WebSocketConstance.CTRL_IS_NOTICE);
////            group.setNotice_id(noticeObj.getNotice_id());
//            webSocket.requestServerMessage(group);
//        }
//    }
//
//    /**
//     * 同意同步
//     */
//    private void agreeSynch(String proId) {
//        WebSocket webSocket = UclientApplication.getInstance().getSocketManager().getWebSocket();
//        if (webSocket != null) {
//            GroupDiscussionInfo group = new GroupDiscussionInfo();
////            group.setAction(WebSocketConstance.ACTION_AGREE_SYNC);
////            group.setCtrl(WebSocketConstance.CTRL_IS_TEAM);
////            group.setTeam_id(id);
////            group.setPro_id(proId);
////            webSocket.requestServerMessage(group);
//        }
//    }
//
//
//}
