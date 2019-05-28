package com.jizhi.jlongg.main.activity;

import android.Manifest;
import android.app.Activity;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.support.v4.app.ActivityCompat;
import android.support.v7.widget.DefaultItemAnimator;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.text.TextUtils;
import android.view.View;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.ListView;

import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.adpter.CommonPersonListAdapter;
import com.jizhi.jlongg.main.adpter.MemberRecyclerViewAdapter;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.GroupMemberInfo;
import com.jizhi.jlongg.main.dialog.DiaLogAddMember;
import com.jizhi.jlongg.main.listener.AccordingTelgetRealNameListener;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.MessageUtil;
import com.jizhi.jlongg.main.util.ProductUtil;
import com.jizhi.jlongg.main.util.WebSocketConstance;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.jizhi.jongg.widget.WrapLinearLayoutManager;
import com.lidroid.xutils.exception.HttpException;
import com.umeng.socialize.ShareAction;
import com.umeng.socialize.bean.SHARE_MEDIA;
import com.umeng.socialize.media.UMImage;
import com.umeng.socialize.media.UMMin;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;


/**
 * 添加成员类型
 *
 * @author Xuj
 * @time 2017年10月10日11:39:50
 * @Version 1.0
 */
public class AddMemberWayActivity extends BaseActivity implements View.OnClickListener {


    /**
     * 加入群聊按钮
     */
    private Button joinChatBtn;
    /**
     * 通讯录适配器
     */
    private CommonPersonListAdapter adapter;
    /**
     * 横向滚动头像
     */
    private RecyclerView mRecyclerView;
    /**
     * 聊天成员适配器
     */
    private MemberRecyclerViewAdapter horizontalAdapter;
    /**
     * 当前选中的成员数量
     */
    private int selectMemberSize;

    /**
     * 启动当前Acitivty 主要是项目组使用
     *
     * @param context
     * @param chooseMemberType MessageUtils
     *                         public static final int WAY_GROUP_TEAM_GROUPCHAT_ADD_MEMBER = 0X1; 班组、项目组、群聊添加成员
     *                         public static final int WAY_GROUP_TEAM_GROUPCHAT_ADD_ACCOUNT_MERMBER = 0X2; 记单笔-->从班组、项目组、群聊添加记账成员
     *                         public static final int WAY_GROUP_TEAM_GROUPCHAT_SEE_MEMBER = 0X3; 班组、项目组、群聊查看成员
     *                         public static final int WAY_CREATE_GROUP_CHAT = 0X14; 创建群聊、班组、项目组
     *                         public static final int WAY_LOCAL_CREATE_GROUP_SELECTE_MEMBER = 0X5; 新建班组时从项目选择成员
     *                         public static final int WAY_ADD_SOURCE_MEMBER = 0X101; 添加数据来源人
     * @param groupId          项目组id
     * @param classType        项目组类型
     * @param memberHeadPics   成员头像
     * @param groupName        项目名称
     * @param memberList       成员列表数据(已有的成员电话号码 用逗号隔开 ,排除相同电话号码)
     * @param isFromBatch      true表示来自批量记账
     */
    public static void actionStart(Activity context, int chooseMemberType, String groupId, String classType, List<String> memberHeadPics, String groupName,
                                   List<GroupMemberInfo> memberList, boolean isFromBatch) {
        Intent intent = new Intent(context, AddMemberWayActivity.class);
        intent.putExtra(Constance.CHOOSE_MEMBER_TYPE, chooseMemberType);
        intent.putExtra(Constance.GROUP_ID, groupId);
        intent.putExtra(Constance.CLASSTYPE, classType);
        intent.putExtra(Constance.GROUP_HEAD_IMAGE, (Serializable) memberHeadPics);
        intent.putExtra(Constance.GROUP_NAME, groupName);
        if (memberList != null && memberList.size() > 0) {
            StringBuilder builder = new StringBuilder();
            builder.append(UclientApplication.getTelephone(context)); //将自己给排除掉
            for (GroupMemberInfo groupMemberInfo : memberList) {
                builder.append("," + groupMemberInfo.getTelephone());
            }
            intent.putExtra(Constance.EXIST_TELPHONES, builder.toString());
        } else {
            intent.putExtra(Constance.EXIST_TELPHONES, UclientApplication.getTelephone(context)); //将自己给排除掉
        }
        intent.putExtra(Constance.IS_FROM_BATCH, isFromBatch);
        context.startActivityForResult(intent, Constance.REQUEST);
    }


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.recycle_listview);
        initView();
        getChatFriendsData();
    }


    private void initView() {
        setTextTitle(R.string.addMember);
        joinChatBtn = getButton(R.id.redBtn);
        initRecyleListView();
        btnUnClick();
    }

    private View getHeadView() {
        View headView = getLayoutInflater().inflate(R.layout.add_member_head, null); // 加载对话框

        int chooseMemberType = getIntent().getIntExtra(Constance.CHOOSE_MEMBER_TYPE, MessageUtil.WAY_GROUP_TEAM_GROUPCHAT_ADD_MEMBER);

        headView.findViewById(R.id.from_contact_layout).setOnClickListener(this);
        headView.findViewById(R.id.manual_add_layout).setOnClickListener(this);
        headView.findViewById(R.id.from_group_layout).setOnClickListener(this);

        //只有班组才显示邀请微信好友加入班组
        View inviteWxFriendGroupView = headView.findViewById(R.id.invinte_wx_freind_join_group_layout);
        if (WebSocketConstance.GROUP.equals(getIntent().getStringExtra(Constance.CLASSTYPE)) && chooseMemberType != MessageUtil.WAY_LOCAL_CREATE_GROUP_SELECTE_MEMBER) {
            inviteWxFriendGroupView.setVisibility(View.VISIBLE);
            inviteWxFriendGroupView.setOnClickListener(this);
        } else {
            inviteWxFriendGroupView.setVisibility(View.GONE);
        }
        if (chooseMemberType == MessageUtil.WAY_LOCAL_CREATE_GROUP_SELECTE_MEMBER) {
            headView.findViewById(R.id.from_code_layout).setVisibility(View.GONE);
            headView.findViewById(R.id.code_background).setVisibility(View.VISIBLE);
        } else {
            headView.findViewById(R.id.from_code_layout).setOnClickListener(this);
        }
        return headView;
    }

//    /**
//     * 从聊聊添加
//     */
//    private void goToChatFriends() {
//        Intent intent = getIntent();
//        String groupId = intent.getStringExtra(Constance.GROUP_ID); //项目组ID
//        String classType = intent.getStringExtra(Constance.CLASSTYPE);//项目组类型
//        int memberListType = intent.getIntExtra(Constance.CHOOSE_MEMBER_TYPE, MessageUtil.WAY_GROUP_TEAM_GROUPCHAT_ADD_MEMBER);
//        boolean isFromBatch = intent.getBooleanExtra(Constance.IS_FROM_BATCH, false); //true表示 批量记账时添加的成员
//        String existTelphone = intent.getStringExtra(Constance.EXIST_TELPHONES);
//        InitiateGroupChatActivity.actionStart(this, memberListType, classType, groupId, isFromBatch, existTelphone, null, null, null);
//    }

    /**
     * 从项目添加
     */
    private void goToWorkCircle() {
        Intent intent = getIntent();
        String groupId = intent.getStringExtra(Constance.GROUP_ID);
        String classType = intent.getStringExtra(Constance.CLASSTYPE);
        String existTelphone = intent.getStringExtra(Constance.EXIST_TELPHONES);
        int chooseMemberType = intent.getIntExtra(Constance.CHOOSE_MEMBER_TYPE, MessageUtil.WAY_GROUP_TEAM_GROUPCHAT_ADD_MEMBER);
        ChooseTeamActivity.actionStart(this, MessageUtil.TYPE_GROUP_AND_TEAM, groupId, classType, existTelphone, chooseMemberType);
    }

    /**
     * 从通讯录添加
     */
    private void goToContact() {
        Intent intent = getIntent();
        String groupId = intent.getStringExtra(Constance.GROUP_ID); //项目组ID
        String classType = intent.getStringExtra(Constance.CLASSTYPE);//项目组类型
        String existTelphone = intent.getStringExtra(Constance.EXIST_TELPHONES);
        int chooseMemberType = intent.getIntExtra(Constance.CHOOSE_MEMBER_TYPE, MessageUtil.WAY_GROUP_TEAM_GROUPCHAT_ADD_MEMBER);
        if (chooseMemberType == MessageUtil.WAY_ADD_SOURCE_MEMBER) {
            AddSourceMemberActivity.actionStart(this, groupId, chooseMemberType, existTelphone);
        } else {
            CommonSelecteMemberActivity.actionStart(this, "从手机通讯录添加", classType, groupId, chooseMemberType, existTelphone);
        }
    }


    /**
     * 邀他扫描二维码加入
     */
    private void inviteFriend() {
        Intent intent = getIntent();
        String groupName = intent.getStringExtra(Constance.GROUP_NAME); //项目组名称
        String groupId = intent.getStringExtra(Constance.GROUP_ID); //项目组ID
        String classType = intent.getStringExtra(Constance.CLASSTYPE);//项目组类型
        List<String> memberHeadPic = (List<String>) intent.getSerializableExtra(Constance.GROUP_HEAD_IMAGE); //项目组头像
        TeamGroupQrCodeActivity.actionStart(AddMemberWayActivity.this, groupName, groupId, classType, memberHeadPic);
    }

    /**
     * 手动添加好友
     */
    public void manualAddMember() {
        final Intent intent = getIntent();
        int chooseMemberType = intent.getIntExtra(Constance.CHOOSE_MEMBER_TYPE, MessageUtil.WAY_GROUP_TEAM_GROUPCHAT_ADD_MEMBER);
        final DiaLogAddMember manualAddMemberDialog = new DiaLogAddMember(AddMemberWayActivity.this, chooseMemberType);
        manualAddMemberDialog.setListener(new DiaLogAddMember.AddGroupMemberListener() { //添加按钮回调
            @Override
            public void add(String telphone, String realName, String headPic) {
                String existTelephone = intent.getStringExtra(Constance.EXIST_TELPHONES);
                if (!TextUtils.isEmpty(existTelephone) && existTelephone.contains(telphone)) {
                    CommonMethod.makeNoticeShort(getApplicationContext(), "此联系人已存在", CommonMethod.ERROR);
                    return;
                }
                ArrayList memberList = new ArrayList<>();
                memberList.add(new GroupMemberInfo(realName, telphone, headPic));
                final int addMemberType = intent.getIntExtra(Constance.CHOOSE_MEMBER_TYPE, MessageUtil.WAY_GROUP_TEAM_GROUPCHAT_ADD_MEMBER);
                String classType = intent.getStringExtra(Constance.CLASSTYPE); //项目类型
                String groupId = intent.getStringExtra(Constance.GROUP_ID); //组id
                switch (addMemberType) {
                    case MessageUtil.WAY_GROUP_TEAM_GROUPCHAT_ADD_MEMBER: //班组、项目组、群聊添加成员
                        MessageUtil.addMembers(AddMemberWayActivity.this, groupId, classType, memberList, new CommonHttpRequest.CommonRequestCallBack() {
                            @Override
                            public void onSuccess(Object object) {
                                manualAddMemberDialog.dismiss();
                                CommonMethod.makeNoticeLong(getApplicationContext(), "添加成功", CommonMethod.SUCCESS);
                                setResult(addMemberType, intent);
                                finish();
                            }

                            @Override
                            public void onFailure(HttpException exception, String errormsg) {

                            }
                        });
                        break;
                    case MessageUtil.WAY_LOCAL_CREATE_GROUP_SELECTE_MEMBER://新建班组时从项目选择成员
                        intent.putExtra(Constance.BEAN_ARRAY, memberList);
                        setResult(MessageUtil.WAY_LOCAL_CREATE_GROUP_SELECTE_MEMBER, intent);
                        finish();
                        break;
                    case MessageUtil.WAY_ADD_SOURCE_MEMBER: //添加项目组数据来源人
                        MessageUtil.addSourceMember(AddMemberWayActivity.this, groupId, WebSocketConstance.TEAM, memberList, null, new CommonHttpRequest.CommonRequestCallBack() {
                            @Override
                            public void onSuccess(Object object) {
                                Intent intent = getIntent();
                                setResult(intent.getIntExtra(Constance.CHOOSE_MEMBER_TYPE, MessageUtil.WAY_ADD_SOURCE_MEMBER), intent);
                                finish();
                            }

                            @Override
                            public void onFailure(HttpException exception, String errormsg) {

                            }
                        });
                        break;
                }
            }
        });
        manualAddMemberDialog.setGetTelphoneListener(new AccordingTelgetRealNameListener() { //根据电话号码获取姓名
            @Override
            public void accordingTelgetRealName(String telephone) {
                MessageUtil.useTelGetUserInfo(AddMemberWayActivity.this, telephone, new CommonHttpRequest.CommonRequestCallBack() {
                    @Override
                    public void onSuccess(Object object) {
                        GroupMemberInfo info = (GroupMemberInfo) object;
                        manualAddMemberDialog.setUserName(info.getReal_name());
                        manualAddMemberDialog.setMemberPic(info.getHead_pic());
                    }

                    @Override
                    public void onFailure(HttpException exception, String errormsg) {

                    }
                });
            }
        });
        manualAddMemberDialog.openKeyBoard();
        manualAddMemberDialog.show();
    }


    /**
     * 获取好友列表
     */
    private void getChatFriendsData() {
        String groupId = getIntent().getStringExtra(Constance.GROUP_ID);
        String classType = getIntent().getStringExtra(Constance.CLASSTYPE);
        MessageUtil.getFriendList(this, groupId, classType, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                ArrayList<GroupMemberInfo> serverList = (ArrayList<GroupMemberInfo>) object;
                removeExistTelphoneUser(getIntent().getStringExtra(Constance.EXIST_TELPHONES), serverList);
                setAdapter(serverList);
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
                finish();
            }
        });
    }

    /**
     * 移除项目组、班组、群聊中已存在的群成员
     *
     * @param existTelphone 已存在的电话号码
     * @param serverList
     */
    private void removeExistTelphoneUser(String existTelphone, List<GroupMemberInfo> serverList) {
        if (TextUtils.isEmpty(existTelphone) || serverList == null || serverList.size() == 0) {
            return;
        }
        int size = serverList.size();
        for (int i = 0; i < size; i++) {
            if (existTelphone.contains(serverList.get(i).getTelephone())) {
                serverList.get(i).setClickable(false);
//                serverList.remove(i);
//                removeExistTelphoneUser(existTelphone, serverList);
//                return;
            }
        }
    }

    /**
     * 设置ListView 适配器
     *
     * @param list
     */
    private void setAdapter(List<GroupMemberInfo> list) {
        Utils.setPinYinAndSort(list);
        if (adapter == null) {
            final ListView listView = (ListView) findViewById(R.id.listView);
            adapter = new CommonPersonListAdapter(this, list, true);
            listView.addHeaderView(getHeadView(), null, false);
            listView.setAdapter(adapter);
            listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                @Override
                public void onItemClick(AdapterView<?> adapterView, View view, int position, long l) {
                    position = position - listView.getHeaderViewsCount();
                    GroupMemberInfo bean = adapter.getList().get(position);
                    if (!bean.isClickable()) {
                        return;
                    }
                    bean.setSelected(!bean.isSelected());
                    selectMemberSize = bean.isSelected() ? selectMemberSize + 1 : selectMemberSize - 1;
                    adapter.notifyDataSetChanged();
                    if (selectMemberSize > 0) {
                        btnClick();
                    } else {
                        btnUnClick();
                    }
                    if (bean.isSelected()) {
                        horizontalAdapter.addData(bean);
                    } else {
                        horizontalAdapter.removeDataByTelephone(bean.getTelephone());
                    }
                }
            });
        } else {
            adapter.updateListView(list);
        }
    }

    private void initRecyleListView() {
        mRecyclerView = (RecyclerView) findViewById(R.id.recyclerview);
        WrapLinearLayoutManager linearLayoutManager = new WrapLinearLayoutManager(this);
        linearLayoutManager.setOrientation(LinearLayoutManager.HORIZONTAL);
        mRecyclerView.setLayoutManager(linearLayoutManager);
        // 设置item动画
        mRecyclerView.setItemAnimator(new DefaultItemAnimator());
        horizontalAdapter = new MemberRecyclerViewAdapter(this);
        mRecyclerView.setAdapter(horizontalAdapter);
        horizontalAdapter.setOnItemClickLitener(new MemberRecyclerViewAdapter.OnItemClickLitener() {
            @Override
            public void onItemClick(View view, int position) {
                GroupMemberInfo groupMemberInfo = horizontalAdapter.getSelectList().get(position);
                selectMemberSize -= 1;
                if (selectMemberSize > 0) {
                    btnClick();
                } else {
                    btnUnClick();
                }
                if (position < 0) {
                    position = 0;
                }
                groupMemberInfo.setSelected(false);
                horizontalAdapter.removeDataByPosition(position);
                adapter.notifyDataSetChanged();
            }
        });
    }

    private void btnUnClick() {
        joinChatBtn.setText("确定");
        joinChatBtn.setClickable(false);
        Utils.setBackGround(joinChatBtn, getResources().getDrawable(R.drawable.draw_dis_app_btncolor_5radius));
    }

    private void btnClick() {
        joinChatBtn.setText(String.format(getString(R.string.confirm_add_member_count), selectMemberSize));
        joinChatBtn.setClickable(true);
        Utils.setBackGround(joinChatBtn, getResources().getDrawable(R.drawable.draw_app_btncolor_5radius));
    }


    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == MessageUtil.WAY_GROUP_TEAM_GROUPCHAT_ADD_MEMBER
                || resultCode == MessageUtil.WAY_GROUP_TEAM_GROUPCHAT_ADD_ACCOUNT_MERMBER
                || resultCode == MessageUtil.WAY_GROUP_TEAM_GROUPCHAT_SEE_MEMBER
                || resultCode == MessageUtil.WAY_CREATE_GROUP_CHAT
                || resultCode == MessageUtil.WAY_LOCAL_CREATE_GROUP_SELECTE_MEMBER
                || resultCode == MessageUtil.WAY_ADD_SOURCE_MEMBER
                ) { //从项目添加人员成功
            setResult(resultCode, data);
            finish();
        } else if (resultCode == ProductUtil.PAID_GO_TO_ORDERLIST) { //支付成功查看订单
            setResult(ProductUtil.PAID_GO_TO_ORDERLIST);
            finish();
        } else if (resultCode == ProductUtil.PAID_GO_HOME) { //支付成功返回首页
            setResult(ProductUtil.PAID_GO_HOME);
            finish();
        }
    }

    @Override
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.from_group_layout: //从项目添加
                goToWorkCircle();
                break;
            case R.id.from_contact_layout://从通讯录添加
                goToContact();
                break;
            case R.id.manual_add_layout: //手动添加成员
                manualAddMember();
                break;
            case R.id.from_code_layout: //邀他扫描二维码加入
                inviteFriend();
                break;
            case R.id.redBtn: //添加成员
                addTeamGroupMember();
                break;
            case R.id.invinte_wx_freind_join_group_layout: //邀请微信好友加入班组
                showShare();
                break;
        }
    }

    public void showShare() {
        if (Build.VERSION.SDK_INT >= 23) {
            String[] mPermissionList = new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE, Manifest.permission.ACCESS_FINE_LOCATION, Manifest.permission.CALL_PHONE, Manifest.permission.READ_LOGS, Manifest.permission.READ_PHONE_STATE, Manifest.permission.WRITE_EXTERNAL_STORAGE, Manifest.permission.SET_DEBUG_APP, Manifest.permission.SYSTEM_ALERT_WINDOW, Manifest.permission.GET_ACCOUNTS, Manifest.permission.WRITE_APN_SETTINGS};
            ActivityCompat.requestPermissions(AddMemberWayActivity.this, mPermissionList, Constance.REQUEST);
        } else {
            shareMINApp();
        }
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, String permissions[], int[] grantResults) {
        if (requestCode == Constance.REQUEST) {
            shareMINApp();
        }
    }

    /**
     * 分享到微信小程序
     */
    public void shareMINApp() {
        String groupId = getIntent().getStringExtra(Constance.GROUP_ID);
        String groupName = getIntent().getStringExtra(Constance.GROUP_NAME);
        String realName = UclientApplication.getRealName(getApplicationContext());
        ///兼容低版本的网页链接
        final UMMin umMin = new UMMin(NetWorkRequest.WEBURLS + "page/open-invite.html?uid=" + UclientApplication.getUid(AddMemberWayActivity.this) + "&plat=person");
        // 小程序消息描述
        umMin.setDescription("1200万建筑工友都在用！海量工作任你挑，实名招工更靠谱！");
        // 小程序原始id,在微信平台查询
        umMin.setUserName("gh_89054fe67201");
        //小程序页面路径
        umMin.setPath("/pages/group/groupInvite?group_id=" + groupId + "&group_name=" + groupName + "&pic=" + UclientApplication.getHeadPic(getApplicationContext()) + "&name=" + realName);
        // 小程序消息title
        umMin.setTitle(realName + "邀请你加入[" + groupName + "]班组，即时记工、实时对帐~");
        //最后两个自己拼参数
//        path:"/pages/group/groupInvite?group_id=1050&group_name=d3d-d3&pic=media%2Fimages%2F20190214%2F100438546.png%3Fnopic%3D1%26real_name%3D%E7%8E%8B%E6%B6%9B&name=王涛"
//        title:"王涛邀请你加入[d3d-d3]班组，即时记工、实时对帐~"

        // 小程序消息封面图片
        UMImage shareImage = new UMImage(AddMemberWayActivity.this, R.drawable.share_wxmini_add_member_icon);
        umMin.setThumb(shareImage);
        new ShareAction(AddMemberWayActivity.this).withMedia(umMin).setPlatform(SHARE_MEDIA.WEIXIN).share();
    }


    /**
     * 添加成员
     */
    private void addTeamGroupMember() {
        ArrayList<GroupMemberInfo> selectMemberList = new ArrayList<>();
        for (GroupMemberInfo info : adapter.getList()) {
            if (info.isSelected()) {
                selectMemberList.add(info);
            }
        }
        if (selectMemberList.size() == 0) {
            return;
        }
        Intent intent = getIntent();
        int addMemberType = intent.getIntExtra(Constance.CHOOSE_MEMBER_TYPE, MessageUtil.WAY_GROUP_TEAM_GROUPCHAT_ADD_MEMBER);
        String classType = getIntent().getStringExtra(Constance.CLASSTYPE);
        String groupId = getIntent().getStringExtra(Constance.GROUP_ID);
        switch (addMemberType) {
            case MessageUtil.WAY_LOCAL_CREATE_GROUP_SELECTE_MEMBER: //创建班组,选择成员
                intent.putExtra(Constance.BEAN_ARRAY, selectMemberList);
                setResult(intent.getIntExtra(Constance.CHOOSE_MEMBER_TYPE, MessageUtil.WAY_GROUP_TEAM_GROUPCHAT_ADD_ACCOUNT_MERMBER), intent);
                finish();
                break;
            case MessageUtil.WAY_ADD_SOURCE_MEMBER: //添加项目组数据来源人
                MessageUtil.addSourceMember(AddMemberWayActivity.this, groupId, WebSocketConstance.TEAM, selectMemberList, null, new CommonHttpRequest.CommonRequestCallBack() {
                    @Override
                    public void onSuccess(Object object) {
                        Intent intent = getIntent();
                        setResult(intent.getIntExtra(Constance.CHOOSE_MEMBER_TYPE, MessageUtil.WAY_ADD_SOURCE_MEMBER), intent);
                        finish();
                    }

                    @Override
                    public void onFailure(HttpException exception, String errormsg) {

                    }
                });
            default: //默认添加成员
                MessageUtil.addMembers(this, groupId, classType, selectMemberList, new CommonHttpRequest.CommonRequestCallBack() {
                    @Override
                    public void onSuccess(Object object) {
                        setResult(MessageUtil.WAY_GROUP_TEAM_GROUPCHAT_ADD_MEMBER);
                        finish();
                    }

                    @Override
                    public void onFailure(HttpException exception, String errormsg) {

                    }
                });
                break;
        }
    }
}