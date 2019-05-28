package com.jizhi.jlongg.main.activity.task;

import android.annotation.TargetApi;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.graphics.Rect;
import android.graphics.drawable.Drawable;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.support.v4.app.FragmentTransaction;
import android.text.Html;
import android.text.TextUtils;
import android.view.View;
import android.view.ViewTreeObserver;
import android.view.inputmethod.InputMethodManager;
import android.widget.AdapterView;
import android.widget.GridView;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.RadioButton;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.hcs.uclient.utils.DensityUtils;
import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.StrUtil;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.emoji.emotionkeyboard.BarClickLintener;
import com.jizhi.jlongg.emoji.emotionkeyboard.EmotionKeyboard;
import com.jizhi.jlongg.emoji.fragment.EmotionMainFragment;
import com.jizhi.jlongg.groupimageviews.NineGridImageViewAdapter;
import com.jizhi.jlongg.groupimageviews.NineGridMsgImageView;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.activity.ChatUserInfoActivity;
import com.jizhi.jlongg.main.adpter.QuelityAndSafeDetailAdapter;
import com.jizhi.jlongg.main.adpter.TaskMemberAdapters;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;
import com.jizhi.jlongg.main.bean.GroupMemberInfo;
import com.jizhi.jlongg.main.bean.LocalInfoBean;
import com.jizhi.jlongg.main.bean.ReplyInfo;
import com.jizhi.jlongg.main.bean.TaskBean;
import com.jizhi.jlongg.main.bean.TaskDetail;
import com.jizhi.jlongg.main.bean.status.CommonJson;
import com.jizhi.jlongg.main.bean.status.CommonListJson;
import com.jizhi.jlongg.main.dialog.DialogDelReply;
import com.jizhi.jlongg.main.dialog.DialogTips;
import com.jizhi.jlongg.main.listener.DiaLogTitleListener;
import com.jizhi.jlongg.main.message.MessageImagePagerActivity;
import com.jizhi.jlongg.main.message.MessageUtils;
import com.jizhi.jlongg.main.msg.MessageType;
import com.jizhi.jlongg.main.util.CameraPop;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DataUtil;
import com.jizhi.jlongg.main.util.GlideUtils;
import com.jizhi.jlongg.main.util.MessageUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SetTitleName;
import com.jizhi.jlongg.main.util.SingsHttpUtils;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.jizhi.jongg.widget.RoundeImageHashCodeTextLayout;
import com.liaoinstan.springview.container.DefaultHeader;
import com.liaoinstan.springview.widget.SpringView;
import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.callback.RequestCallBack;
import com.lidroid.xutils.http.client.HttpRequest;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

import me.nereo.multi_image_selector.MultiImageSelectorActivity;

import static com.jizhi.jlongg.R.id.tv_received;


/**
 * 任务详情
 *
 * @author huChangSheng
 * @version 1.0
 * @time 2016-11-25 下午2:41:57
 */

public class TaskDetailActivity extends BaseActivity implements View.OnClickListener, DiaLogTitleListener, QuelityAndSafeDetailAdapter.ReplyContentClickListener, BarClickLintener, EmotionKeyboard.ClickKeyBoardClickListner {
    private TaskDetailActivity mActivity;
    //列表数据
    private ListView listView;
    //头像
    private RoundeImageHashCodeTextLayout img_head;
    //头部数据
    private TaskBean taskBean;
    //内容
    private TextView tv_content;
    //完成时间
    private TextView tv_finish_time;
    //项目名称
    private TextView tv_proName;
    //状态
    private RadioButton rb_state;
    //名字
    private TextView tv_name;
    //图片集
    private NineGridMsgImageView imageGridView;
    //评论数据
    private List<ReplyInfo> replyInfos;
    private QuelityAndSafeDetailAdapter adapter;
    private TaskMemberAdapters headAdapter;
    private GridView mRecyclerView;
    private View headerView;
    //是否已经关闭
    private boolean isClose;
    //消息数据
//    private ReplyInfo readInfo;
    private TextView tv_unreceived;
    private String task_id, group_id;
    private boolean isChangeTaskState;
    //日志更多DialogCloseTeam
    private DialogTips dialogLogMore;
    //表情主界面
    private EmotionMainFragment emotionMainFragment;
    private SpringView springView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_notice_detail);
        mActivity = TaskDetailActivity.this;
        getIntentData();
        initView();
        registerFinishActivity();


        findViewById(R.id.rootView).setOnClickListener(this);
        headerView.setOnClickListener(this);
        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                hideSoftKeyboard();
            }
        });
    }

    private boolean isPush;

    /**
     * 获取传递过来的数据
     */
    private void getIntentData() {

        Bundle bun = getIntent().getExtras();
        if (bun != null) {
            //推送跳转进来的
            Set<String> keySet = bun.keySet();
            for (String key : keySet) {
                LUtils.e(key + "-----111---------" + bun.getString(key));
                if (!TextUtils.isEmpty(key) && key.equals("msg_id")) {
                    isPush = true;
                    task_id = bun.getString(key);
                } else if (!TextUtils.isEmpty(key) && key.equals("group_id")) {
                    isPush = true;
                    group_id = bun.getString(key);
                }
            }

            LUtils.e("-----111---------" + task_id);
        }
        if (!isPush || TextUtils.isEmpty(task_id)) {//页面跳转进来的
            task_id = getIntent().getStringExtra(Constance.TASK_ID);
            group_id = getIntent().getStringExtra(Constance.GROUP_ID);
            isClose = getIntent().getBooleanExtra(Constance.BEAN_BOOLEAN, false);
            LUtils.e("-----2222---------" + task_id);
        }
    }

    /**
     * 启动当前Acitivyt
     *
     * @param context
     */
    public static void actionStart(Activity context, String id, String group_id, String group_name, boolean isClose) {
        Intent intent = new Intent(context, TaskDetailActivity.class);
        intent.putExtra(Constance.TASK_ID, id);
        intent.putExtra(Constance.BEAN_BOOLEAN, isClose);
        intent.putExtra(Constance.GROUP_ID, group_id);
        intent.putExtra(Constance.GROUP_NAME, group_name);
        context.startActivityForResult(intent, Constance.REQUEST);
    }


    /**
     * 初始化View
     */
    public void initView() {
        headerView = getLayoutInflater().inflate(R.layout.layout_task_detail_head, null);
        SetTitleName.setTitle(findViewById(R.id.title), "任务详情");
        //初始化headview信息
        listView = findViewById(R.id.listview);
        img_head = headerView.findViewById(R.id.img_head);
        tv_content = headerView.findViewById(R.id.tv_content);
        tv_finish_time = headerView.findViewById(R.id.tv_finish_time);
        tv_proName = headerView.findViewById(R.id.tv_proName);
        tv_unreceived = headerView.findViewById(R.id.tv_unreceived);
        tv_name = headerView.findViewById(R.id.tv_name);
        imageGridView = headerView.findViewById(R.id.ngl_images);
        rb_state = headerView.findViewById(R.id.rb_state);
        listView.addHeaderView(headerView);
        mRecyclerView = headerView.findViewById(R.id.recyclerview);
        headerView.findViewById(R.id.lin_received).setOnClickListener(this);
        headerView.findViewById(R.id.lin_unreceived).setOnClickListener(this);
        img_head.setOnClickListener(this);
        tv_name.setOnClickListener(this);
        //显示headview
        replyInfos = new ArrayList<>();
        adapter = new QuelityAndSafeDetailAdapter(mActivity, MessageType.MSG_TASK_STRING, replyInfos, this, new DialogDelReply.DelSuccessClickListener() {


            @Override
            public void delClickSuccess(int position) {
                replyInfos.remove(position);
                adapter.updateListView(replyInfos);

            }
        }, isClose ? 1 : 0);
        listView.setAdapter(adapter);
        //初始化其它控件
        rb_state.setOnClickListener(this);
        tv_proName.setOnClickListener(this);
        if (!isClose) {
            initEmotionMainFragment();
            readLocalInfo();
            initKeyBoardView();
        }
        headerView.setVisibility(View.GONE);
        springView = findViewById(R.id.springview);
        springView.setType(SpringView.Type.FOLLOW);
        springView.setEnableFooter(false);
        springView.setHeader(new DefaultHeader(this));
        springView.callFreshDelay();
        springView.setListener(new SpringView.OnFreshListener() {
            @Override
            public void onRefresh() {
                getTaskDetail();

            }

            @Override
            public void onLoadmore() {
            }
        });
    }

    /**
     * 初始化表情面板
     */
    public void initEmotionMainFragment() {
        //构建传递参数
        Bundle bundle = new Bundle();
        //绑定主内容编辑框
        bundle.putBoolean(EmotionMainFragment.BIND_TO_EDITTEXT, true);
        //隐藏控件
        bundle.putBoolean(EmotionMainFragment.HIDE_BAR_EDIT_PIC, false);
        //替换fragment
        //创建修改实例
        emotionMainFragment = EmotionMainFragment.newInstance(EmotionMainFragment.class, bundle);
        emotionMainFragment.bindToContentView(listView);
        emotionMainFragment.setBarClickLintener(this);
        emotionMainFragment.setClickKeyBoardClickListner(this);
        FragmentTransaction transaction = getSupportFragmentManager().beginTransaction();
        // Replace whatever is in thefragment_container view with this fragment,
        // and add the transaction to the backstack
        transaction.replace(R.id.fl_emotionview_main, emotionMainFragment);
        transaction.addToBackStack(null);
        //提交修改
        transaction.commit();
    }

    private boolean isClearAt;

    @Override
    public void CLickKeyBoardClick(boolean isClear) {
        this.isClearAt = isClear;
        if (!isShowKeyBoard && !isClearAt) {
            reply_uid = null;
            emotionMainFragment.getBar_edit_text().setHint("请输入回复内容");
        }
    }

    @Override
    public void ClickEmojiButtom() {

    }

    @Override
    public void ClickMoreButtom() {

    }

    @Override
    public void ClickShareInfo() {

    }


    /**
     * 初始化键盘监听
     */
    public void initKeyBoardView() {
        rea_noticedetail = (RelativeLayout) findViewById(R.id.rootView);
        //contentlayout是最外层布局
        mChildOfContent = rea_noticedetail.getChildAt(0);
        mChildOfContent.getViewTreeObserver().addOnGlobalLayoutListener(new ViewTreeObserver.OnGlobalLayoutListener() {
            public void onGlobalLayout() {
                possiblyResizeChildOfContent();
            }
        });
    }

    private RelativeLayout rea_noticedetail;
    private View mChildOfContent;
    private int usableHeightPrevious = 0;
    private boolean isShowKeyBoard;
    private String reply_uid;


    private void possiblyResizeChildOfContent() {
        int usableHeightNow = computeUsableHeight();
        if (usableHeightNow != usableHeightPrevious) {
            int usableHeightSansKeyboard = mChildOfContent.getRootView().getHeight();
            int heightDifference = usableHeightSansKeyboard - usableHeightNow;
            if (heightDifference > (usableHeightSansKeyboard / 4)) {
                // 键盘弹出
                isShowKeyBoard = true;
            } else {
                // 键盘收起
                isShowKeyBoard = false;
                if (!isShowKeyBoard && !isClearAt) {
                    reply_uid = null;
                    emotionMainFragment.getBar_edit_text().setHint("请输入回复内容");
                }
            }
            mChildOfContent.requestLayout();
            usableHeightPrevious = usableHeightNow;
        }
    }

    @Override
    public void barBtnSendClick() {
        if (isClose) {
            return;
        }
        // 发送回复信息
        String text = emotionMainFragment.getBar_edit_text().getText().toString().trim();
        if (TextUtils.isEmpty(text)) {
            CommonMethod.makeNoticeShort(mActivity, "请填写回复内容", CommonMethod.ERROR);
            return;
        }
        fileUpData(null);
    }

    @Override
    public void barImageAddClick() {
        Toast.makeText(mActivity, "添加", Toast.LENGTH_SHORT).show();
    }

    private int computeUsableHeight() {
        Rect r = new Rect();
        mChildOfContent.getWindowVisibleDisplayFrame(r);
        return (r.bottom - r.top);
    }

    @Override
    public void replyContentClick(String uid, final String name) {
        if (taskBean.getTask_status() == 1) {
            CommonMethod.makeNoticeShort(mActivity, "该任务已完成，不能操作", CommonMethod.SUCCESS);
            return;
        }
        if (!TextUtils.isEmpty(name)) {
            emotionMainFragment.getBar_edit_text().setHint("回复" + name);
            reply_uid = uid;
            if (isClose) {
                return;
            }
            //弹出回复键盘
            InputMethodManager imm = (InputMethodManager) emotionMainFragment.getBar_edit_text().getContext().getSystemService(Context.INPUT_METHOD_SERVICE);
            imm.toggleSoftInput(0, InputMethodManager.SHOW_IMPLICIT);
            emotionMainFragment.getBar_edit_text().setFocusable(true);
            emotionMainFragment.getBar_edit_text().setFocusableInTouchMode(true);
            emotionMainFragment.getBar_edit_text().requestFocus();
        }


    }


    /**
     * 设置head显示内容
     */

    private void setHeadData() {
        headerView.setVisibility(View.VISIBLE);
        img_head.setView(taskBean.getPub_man().getHead_pic(), taskBean.getPub_man().getReal_name(), 0);
//        tv_proName.setText("来自：" + taskBean.getTeam_or_group_name());
        tv_proName.setText(Html.fromHtml("<font color='#999999'>来自：</font>" + taskBean.getTeam_or_group_name() + ""));
        if (!TextUtils.isEmpty(taskBean.getTask_content())) {
            tv_content.setText(taskBean.getTask_content());
            tv_content.setVisibility(View.VISIBLE);
        } else {
            tv_content.setVisibility(View.GONE);
        }
        tv_name.setTextColor(getResources().getColor(R.color.color_628ae0));
        tv_name.setText(taskBean.getPub_man().getReal_name());
        if (taskBean.getTask_imgs() != null && taskBean.getTask_imgs().size() > 0) {
            imageGridView.setVisibility(View.VISIBLE);
            imageGridView.setAdapter(mAdapter);
            imageGridView.setImagesData(taskBean.getTask_imgs());
        } else {
            imageGridView.setVisibility(View.GONE);
        }
        setTaskState();
        String changeTaskContent = StrUtil.ToDBC(StrUtil.StringFilter(taskBean.getTask_finish_time()));
        findViewById(R.id.rea_finish_time).setVisibility(View.GONE);
        if (!TextUtils.isEmpty(changeTaskContent)) {
            changeTaskContent = "完成期限：" + changeTaskContent;
            switch (taskBean.getTask_level()) { // 任务级别(1:一般；2：紧急；3：非常紧急)
                case TaskDetail.COMMONLY:
                    tv_finish_time.setText(changeTaskContent);
                    ((TextView) findViewById(R.id.tv_level)).setText("");
                    break;
                case TaskDetail.URGENT:
                    ((TextView) findViewById(R.id.tv_level)).setText((Html.fromHtml("<font color='#f9a00f'>[紧急]</font>")));
                    tv_finish_time.setText(Html.fromHtml("<font color='#f9a00f'>" + changeTaskContent + "</font>"));
                    break;
                case TaskDetail.VERY_URGENT:
                    ((TextView) findViewById(R.id.tv_level)).setText((Html.fromHtml("<font color='#d7252c'>[非常紧急] </font>")));
                    tv_finish_time.setText(Html.fromHtml("</font><font color='#d7252c'>" + changeTaskContent + "</font>"));
                    break;
            }
            findViewById(R.id.rea_finish_time).setVisibility(View.VISIBLE);
        } else {
            switch (taskBean.getTask_level()) { // 任务级别(1:一般；2：紧急；3：非常紧急)
                case TaskDetail.COMMONLY:
                    ((TextView) findViewById(R.id.tv_level)).setText("一般");
                    findViewById(R.id.rea_finish_time).setVisibility(View.GONE);
                    break;
                case TaskDetail.URGENT:
                    ((TextView) findViewById(R.id.tv_level)).setText(Html.fromHtml("<font color='#f9a00f'>[紧急]</font>"));
                    tv_finish_time.setText(Html.fromHtml("<font color='#f9a00f'>" + changeTaskContent + "</font>"));
                    findViewById(R.id.rea_finish_time).setVisibility(View.VISIBLE);
                    break;
                case TaskDetail.VERY_URGENT:
                    ((TextView) findViewById(R.id.tv_level)).setText(Html.fromHtml("<font color='#d7252c'>[非常紧急] </font>"));
                    tv_finish_time.setText(Html.fromHtml("</font><font color='#d7252c'>" + changeTaskContent + "</font>"));
                    findViewById(R.id.rea_finish_time).setVisibility(View.VISIBLE);
                    break;
            }


        }

        //是否显示暂无数据
        if (taskBean.getMembers().size() == 0) {
            findViewById(R.id.tv_nodata).setVisibility(View.VISIBLE);
        } else {
            findViewById(R.id.tv_nodata).setVisibility(View.GONE);
        }
        if (null != taskBean.getUnrelay_members() && taskBean.getUnrelay_members().size() > 0) {
            tv_unreceived.setText(Html.fromHtml("<font color='#666666'>参与者</font><font color='#999999'> (" + taskBean.getUnrelay_members().size() + ")</font>"));
        } else {
            tv_unreceived.setText(Html.fromHtml("<font color='#666666'>参与者</font>"));
        }
    }

    /**
     * 设置负责人参与者信息
     */
    public void setReadHead(boolean isReadData) {
        if (null == taskBean) {
            return;
        }
        findViewById(R.id.tv_nodata).setVisibility(View.GONE);
        if (isReadData) {//负责人信息
            //设置负责人选中参与者不选中
            headAdapter = null;
            List<GroupMemberInfo> members = taskBean.getMembers();
            if (UclientApplication.getUid(mActivity).equals(taskBean.getPub_man().getUid())) {
                if (members.size() == 0 || !TextUtils.isEmpty(members.get(members.size() - 1).getHead_pic())) {
                    GroupMemberInfo memberInfo = new GroupMemberInfo();
                    members.add(memberInfo);
                }
            }
            TaskMemberAdapters headAdapter = new TaskMemberAdapters(this, members, group_id, true, isClose);
            mRecyclerView.setAdapter(headAdapter);
            //是否显示暂无数据
            if (taskBean.getMembers().size() == 0) {
                findViewById(R.id.tv_nodata).setVisibility(View.VISIBLE);
            } else {
                findViewById(R.id.tv_nodata).setVisibility(View.GONE);
            }

            (headerView.findViewById(R.id.view_received)).setVisibility(View.VISIBLE);

            //负责人显示的颜色信息
            (headerView.findViewById(R.id.view_unreceived)).setVisibility(View.GONE);
            (headerView.findViewById(R.id.view_received)).setVisibility(View.VISIBLE);
            ((TextView) findViewById(tv_received)).setText(Html.fromHtml("<font color='#eb4e4e'>负责人</font>"));
            ((TextView) headerView.findViewById(R.id.tv_unreceived)).setTextColor(getResources().getColor(R.color.color_666666));

            boolean isUnMembers = false;
            for (int i = 0; i < taskBean.getMembers().size(); i++) {
                if (!TextUtils.isEmpty(taskBean.getMembers().get(i).getUid()) &&
                        UclientApplication.getUid(mActivity).equals(taskBean.getMembers().get(i).getUid())) {
                    isUnMembers = true;
                }
            }

            //参与者标题信息
            if (taskBean.getUnrelay_members().size() == 0) {
                ((TextView) findViewById(R.id.tv_unreceived)).setText(Html.fromHtml("<font color='#666666'>参与者</font>"));
                findViewById(R.id.tv_nodata).setVisibility(View.GONE);
            } else {
                findViewById(R.id.tv_nodata).setVisibility(View.GONE);
                if (UclientApplication.getUid(mActivity).equals(taskBean.getPub_man().getUid()) || isUnMembers) {
                    LUtils.e("---------1111----");
                    if ((taskBean.getUnrelay_members().size() - 1) == 0) {
                        ((TextView) findViewById(R.id.tv_unreceived)).setText(Html.fromHtml("<font color='#666666'>参与者</font>"));
                    } else {
                        if (UclientApplication.getUid(mActivity).equals(taskBean.getPub_man().getUid()) || isUnMembers) {
                            int size = 1;

                            for (int i = 0; i < taskBean.getUnrelay_members().size(); i++) {
                                if (!TextUtils.isEmpty(taskBean.getUnrelay_members().get(i).getUid())) {
                                    size += 1;
                                }
                            }
                            if (size == 1) {
                                ((TextView) findViewById(R.id.tv_unreceived)).setText(Html.fromHtml("<font color='#666666'>参与者</font>"));
                            } else {
                                ((TextView) findViewById(R.id.tv_unreceived)).setText(Html.fromHtml("<font color='#666666'>参与者</font><font color='#999999'> (" + (size - 1) + ")</font>"));
                            }
                        } else {
                            ((TextView) findViewById(R.id.tv_unreceived)).setText(Html.fromHtml("<font color='#666666'>参与者</font><font color='#999999'> (" + (taskBean.getUnrelay_members().size()) + ")</font>"));
                        }
                    }
                } else {
                    if (taskBean.getUnrelay_members().size() == 0) {
                        ((TextView) findViewById(R.id.tv_unreceived)).setText(Html.fromHtml("<font color='#666666'>参与者</font>"));
                    } else {

                        ((TextView) findViewById(R.id.tv_unreceived)).setText(Html.fromHtml("<font color='#666666'>参与者</font><font color='#999999'> (" + taskBean.getUnrelay_members().size() + ")</font>"));
                    }
                }
            }
            //是否显示暂无数据
            if (taskBean.getMembers().size() == 0) {
                findViewById(R.id.tv_nodata).setVisibility(View.VISIBLE);
            } else {
                findViewById(R.id.tv_nodata).setVisibility(View.GONE);
            }
        } else {//参与者信息
            //设置参与者选中负责人不选中
            (headerView.findViewById(R.id.view_unreceived)).setVisibility(View.VISIBLE);
            (headerView.findViewById(R.id.view_received)).setVisibility(View.GONE);
            boolean isUnMembers = false;
            for (int i = 0; i < taskBean.getMembers().size(); i++) {
                if (!TextUtils.isEmpty(taskBean.getMembers().get(i).getUid()) &&
                        UclientApplication.getUid(mActivity).equals(taskBean.getMembers().get(i).getUid())) {
                    isUnMembers = true;
                }
            }

            List<GroupMemberInfo> members = taskBean.getUnrelay_members();
            if (UclientApplication.getUid(mActivity).equals(taskBean.getPub_man().getUid()) || isUnMembers) {
                if (members.size() == 0 || !TextUtils.isEmpty(members.get(members.size() - 1).getHead_pic())) {
                    GroupMemberInfo memberInfo = new GroupMemberInfo();
                    members.add(memberInfo);
                }
            }
            TaskMemberAdapters headAdapter = new TaskMemberAdapters(this, members, group_id, true, isClose);
            mRecyclerView.setAdapter(headAdapter);
            //参与者标题信息
            if (taskBean.getUnrelay_members().size() == 0) {
                ((TextView) findViewById(R.id.tv_unreceived)).setText(Html.fromHtml("<font color='#eb4e4e'>参与者</font>"));
                findViewById(R.id.tv_nodata).setVisibility(View.VISIBLE);
            } else {
                findViewById(R.id.tv_nodata).setVisibility(View.GONE);
                if (UclientApplication.getUid(mActivity).equals(taskBean.getPub_man().getUid()) || isUnMembers) {
                    if ((taskBean.getUnrelay_members().size() - 1) == 0) {
                        ((TextView) findViewById(R.id.tv_unreceived)).setText(Html.fromHtml("<font color='#eb4e4e'>参与者</font>"));
                    } else {
                        ((TextView) findViewById(R.id.tv_unreceived)).setText(Html.fromHtml("<font color='#eb4e4e'>参与者</font><font color='#999999'> (" + (taskBean.getUnrelay_members().size() - 1) + ")</font>"));
                    }
                } else {
                    if (taskBean.getUnrelay_members().size() == 0) {
                        ((TextView) findViewById(R.id.tv_unreceived)).setText(Html.fromHtml("<font color='#eb4e4e'>参与者</font>"));
                    } else {

                        ((TextView) findViewById(R.id.tv_unreceived)).setText(Html.fromHtml("<font color='#eb4e4e'>参与者</font><font color='#999999'> (" + taskBean.getUnrelay_members().size() + ")</font>"));
                    }
                }
            }
            //负责人标题信息
            ((TextView) findViewById(tv_received)).setText(Html.fromHtml("<font color='#666666'>负责人</font>"));
            //是否显示暂无数据
            if (taskBean.getMembers().size() == 0) {
                findViewById(R.id.tv_nodata).setVisibility(View.VISIBLE);
            } else {
                findViewById(R.id.tv_nodata).setVisibility(View.GONE);
            }
        }


    }

    /**
     * 设置已完成待处理状态
     */
    @TargetApi(Build.VERSION_CODES.JELLY_BEAN)
    public void setTaskState() {
        if (taskBean.getIs_can_deal() == 1 && !isClose) {
            //如果有操作权限
            //如果任务已经完成
            if (taskBean.getTask_status() == 1) {
                //显示可操作的【待处理】按钮
                rb_state.setTextColor(getResources().getColor(R.color.color_83c76e));
                rb_state.setText("已完成");

                Drawable img_right = getResources().getDrawable(R.drawable.icon_pen_green);
                img_right.setBounds(0, 0, img_right.getMinimumWidth(), img_right.getMinimumHeight());
                rb_state.setCompoundDrawables(null, null, img_right, null); //设置左图标
                rb_state.setCompoundDrawablePadding(DensityUtils.dp2px(mActivity, 10));
                rb_state.setBackgroundResource(R.drawable.stroke_83c76e);
                int left = (int) DensityUtils.dp2px(mActivity, 10);
                int top = (int) DensityUtils.dp2px(mActivity, 5);
                int right = (int) DensityUtils.dp2px(mActivity, 10);
                int bottom = (int) DensityUtils.dp2px(mActivity, 5);
                LUtils.e(left + ",," + top + ",," + right + ",,," + bottom);

                rb_state.setPadding(left, top, right, bottom);
            } else {
                // 显示 可操作的【已完成】按钮
                rb_state.setTextColor(getResources().getColor(R.color.color_f9a00f));
                rb_state.setText("待处理");
                Drawable img_right = getResources().getDrawable(R.drawable.icon_pen_yellow);
                img_right.setBounds(0, 0, img_right.getMinimumWidth(), img_right.getMinimumHeight());
                rb_state.setCompoundDrawables(null, null, img_right, null); //设置左图标
                rb_state.setCompoundDrawablePadding(DensityUtils.dp2px(mActivity, 10));
                rb_state.setBackgroundResource(R.drawable.stroke_f9a00f);
//                int left, int top, int right, int bottom
                int left = (int) DensityUtils.dp2px(mActivity, 10);
                int top = (int) DensityUtils.dp2px(mActivity, 5);
                int right = (int) DensityUtils.dp2px(mActivity, 10);
                int bottom = (int) DensityUtils.dp2px(mActivity, 5);
                LUtils.e(left + ",," + top + ",," + right + ",,," + bottom);
                rb_state.setPadding(left, top, right, bottom);
            }

        } else {
            //如果没有操作权限
            if (taskBean.getTask_status() == 1) {
                //显示不可操作的"已完成"按钮
                rb_state.setTextColor(getResources().getColor(R.color.color_83c76e));
                rb_state.setText("已完成");
                rb_state.setCompoundDrawables(null, null, null, null); //设置左图标
                rb_state.setCompoundDrawablePadding(DensityUtils.dp2px(mActivity, 10));
                rb_state.setBackground(null);
            } else {
                // 显示不可操作的“待处理”状态
                rb_state.setTextColor(getResources().getColor(R.color.color_f9a00f));
                rb_state.setText("待处理");
                rb_state.setCompoundDrawables(null, null, null, null); //设置左图标
                rb_state.setCompoundDrawablePadding(DensityUtils.dp2px(mActivity, 10));
                rb_state.setBackground(null);
            }
        }

        goneLayotedit();
    }

    /**
     * 隐藏回复按钮
     */
    public void goneLayotedit() {
    }

    private NineGridImageViewAdapter<String> mAdapter = new NineGridImageViewAdapter<String>() {
        @Override
        public void onDisplayImage(Context context, ImageView imageView, String s) {
            new GlideUtils().glideImage(context, NetWorkRequest.IP_ADDRESS + s, imageView, R.drawable.icon_message_fail_default, R.drawable.icon_message_fail_default);
//            Glide.with(context).load(NetWorkRequest.IP_ADDRESS + s).placeholder(R.drawable.icon_message_fail_default).error(R.drawable.icon_message_fail_default).into(imageView);
        }

        @Override
        public void onItemImageClick(Context context, int index, List<String> list, ImageView imageView) {
            //imagesize是作为loading时的图片size
            MessageImagePagerActivity.ImageSize imageSize = new MessageImagePagerActivity.ImageSize(imageView.getMeasuredWidth(), imageView.getMeasuredHeight());
            MessageImagePagerActivity.startImagePagerActivity(TaskDetailActivity.this, list, index, imageSize);
        }
    };

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            //能否处理 1：能；0：不能
            case R.id.rootView:
            case R.id.layout_notice_detail_head:
                if (isClose) {
                    return;
                }
                hideSoftKeyboard();
                break;
            case R.id.lin_received:
                setReadHead(true);
                break;
            case R.id.lin_unreceived:
                setReadHead(false);
                break;
            case R.id.img_head:
            case R.id.tv_name:
                if (TextUtils.isEmpty(taskBean.getPub_man().getUid())) {
                    return;
                }
                if (isClose || null == taskBean) {
                    return;
                }
                Intent intent = new Intent(TaskDetailActivity.this, ChatUserInfoActivity.class);
                intent.putExtra(Constance.UID, taskBean.getPub_man().getUid());
                startActivityForResult(intent, Constance.REQUESTCODE_SINGLECHAT);
                break;
            case R.id.tv_proName:
                if (isClose) {
                    return;
                }

                GroupDiscussionInfo info = new GroupDiscussionInfo();
                info.setGroup_id(group_id);
                info.setClass_type(Constance.TEAM);
                MessageUtil.setIndexList(mActivity, info, false, true);
                break;
            case R.id.rb_state:
                if (isClose || null == taskBean) {
                    return;
                }
                //能否处理 1：能；0：不能
                if (taskBean.getIs_can_deal() == 1) {
                    String desc;
                    if (taskBean.getTask_status() == 1) {
                        desc = "你确定要将该任务修改为“待处理”状态吗？";
                    } else {
                        desc = "你确定要将该任务修改为“已完成”状态吗？";
                    }
                    dialogLogMore = null;
                    dialogLogMore = new DialogTips(mActivity, this, desc, DialogTips.CLOSE_TEAM);
                    dialogLogMore.show();
                }
                break;
        }
    }

    //隐藏键盘

    private void toggleInput(Context context) {
        InputMethodManager inputMethodManager =
                (InputMethodManager) context.getSystemService(Context.INPUT_METHOD_SERVICE);
        inputMethodManager.toggleSoftInput(0, InputMethodManager.HIDE_NOT_ALWAYS);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == Constance.REQUESTCODE_SINGLECHAT && resultCode == Constance.CLICK_SINGLECHAT) {
            GroupDiscussionInfo info = (GroupDiscussionInfo) data.getSerializableExtra(Constance.BEAN_CONSTANCE);
            Intent intent = new Intent();
            Bundle bundle = new Bundle();
            bundle.putSerializable(Constance.BEAN_CONSTANCE, info);
            intent.putExtras(bundle);
            setResult(Constance.CLICK_SINGLECHAT, intent);
            finish();
        } else if (requestCode == Constance.REQUEST && resultCode == Constance.SELECTED_PRINCIPAL) {

            if (null != data) {
                GroupMemberInfo info = (GroupMemberInfo) data.getSerializableExtra(Constance.BEAN_CONSTANCE);
                if (null != info) {
                    setTaskPersonChange(null, info, true);
                }
            }

        } else if (resultCode == Constance.SELECTED_ACTOR) { //选择参与者

            if (null != data) {
                List<GroupMemberInfo> groupMemberInfos = (List<GroupMemberInfo>) data.getSerializableExtra(Constance.BEAN_CONSTANCE);
                if (null != groupMemberInfos) {
                    setTaskPersonChange(groupMemberInfos, null, false);
                } else {
                    setTaskPersonChange(new ArrayList<GroupMemberInfo>(), null, false);
                }
            }


        } else if (resultCode == Constance.CLICK_SINGLECHAT) {
            setResult(Constance.CLICK_SINGLECHAT, data);
            finish();
        } else if (requestCode == CameraPop.REQUEST_IMAGE && resultCode == RESULT_OK) {//选择相册回调
            ArrayList<String> mSelected = data.getStringArrayListExtra(MultiImageSelectorActivity.EXTRA_RESULT);
//            taskStatusChange(null, mSelected);
            fileUpData(mSelected);
        }
    }


    /**
     * 任务详情
     */
    protected void getTaskDetail() {
        HttpUtils http = SingsHttpUtils.getHttp();
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        params.addBodyParameter("id", task_id);
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.TASKDETAIL,
                params, new RequestCallBack<String>() {
                    @Override
                    public void onSuccess(ResponseInfo<String> responseInfo) {
                        try {
                            CommonJson<TaskBean> bean = CommonJson.fromJson(responseInfo.result, TaskBean.class);
                            if (bean.getState() != 0) {
                                findViewById(R.id.rootView).setVisibility(View.VISIBLE);
                                taskBean = bean.getValues();
                                setHeadData();
                                //参与者标题信息
                                if (taskBean.getUnrelay_members().size() == 0) {
                                    ((TextView) findViewById(R.id.tv_unreceived)).setText(Html.fromHtml("<font color='#666666'>参与者</font>"));
                                } else {
                                    ((TextView) findViewById(R.id.tv_unreceived)).setText(Html.fromHtml("<font color='#666666'>参与者</font><font color='#999999'> (" + (taskBean.getUnrelay_members().size()) + ")</font>"));
                                }
                                setReadHead(true);
                                getTaskReplyList();
                            } else {
                                DataUtil.showErrOrMsg(mActivity, bean.getErrno(), bean.getErrmsg());
                                finish();
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                            CommonMethod.makeNoticeShort(mActivity, getString(R.string.service_err), CommonMethod.ERROR);
                            finish();
                        } finally {
                            springView.onFinishFreshAndLoad();
                        }
                    }

                    /** xutils 连接失败 调用的 方法 */
                    @Override
                    public void onFailure(HttpException exception, String errormsg) {
                        CommonMethod.makeNoticeShort(mActivity, getString(R.string.service_err), CommonMethod.ERROR);
                        springView.onFinishFreshAndLoad();
                        finish();
                    }
                });
    }


    /**
     * 任务回复列表
     */

    protected void getTaskReplyList() {
        HttpUtils http = SingsHttpUtils.getHttp();
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        params.addBodyParameter("id", task_id);
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.TASKREPLYLIST,
                params, new RequestCallBack<String>() {
                    @Override
                    public void onSuccess(ResponseInfo<String> responseInfo) {
                        try {
                            CommonListJson<ReplyInfo> bean = CommonListJson.fromJson(responseInfo.result, ReplyInfo.class);
                            if (bean.getState() != 0) {
                                replyInfos = bean.getValues();
                                adapter.updateListView(replyInfos);
                                if (isReplyToBottom) {
                                    listView.setSelection(bean.getValues().size());
                                    isReplyToBottom = false;
                                }
                            } else {
                                DataUtil.showErrOrMsg(mActivity, bean.getErrno(), bean.getErrmsg());
                                finish();
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                            CommonMethod.makeNoticeShort(mActivity, getString(R.string.service_err), CommonMethod.ERROR);
                            finish();
                        } finally {
                            closeDialog();
                        }
                    }

                    /** xutils 连接失败 调用的 方法 */
                    @Override
                    public void onFailure(HttpException exception, String errormsg) {
                        closeDialog();
                        finish();
                    }
                });
    }

    private boolean isReplyToBottom;
    RequestParams params;

    /**
     * 消息回复
     *
     * @param list
     */
    public void fileUpData(final List<String> list) {
        createCustomDialog();
        new Thread(new Runnable() {
            @Override
            public void run() {
                params = RequestParamsToken.getExpandRequestParams(mActivity);
//                params.addBodyParameter("reply_type", MessageType.MSG_NOTICE_STRING);
                if (null != list && list.size() > 0) {
                    RequestParamsToken.compressImageAndUpLoad(params, list, mActivity);
                }
//                if (!TextUtils.isEmpty(group_id)) {
//                    params.addBodyParameter("group_id", group_id);
//                }
                params.addBodyParameter("id", task_id);

//                if (!TextUtils.isEmpty(gnInfo.getClass_type())) {
//                    params.addBodyParameter("class_type", gnInfo.getClass_type());
//                }
                if (!TextUtils.isEmpty(emotionMainFragment.getBar_edit_text().getText().toString().trim())) {
                    params.addBodyParameter("reply_text", emotionMainFragment.getBar_edit_text().getText().toString().trim());
                }
                if (!TextUtils.isEmpty(reply_uid)) {
                    //2.3.2增加回复单个人功能
                    params.addBodyParameter("reply_uid", reply_uid);
                }
                Message message = Message.obtain();
                message.what = 0X01;
                mHandler.sendMessage(message);
            }
        }).start();
    }

    public Handler mHandler = new Handler() {
        public void handleMessage(Message msg) {
            switch (msg.what) {
                case 0X01:
                    getTaskReply();
                    break;
            }

        }
    };

    /**
     * 回复任务
     */
    protected void getTaskReply() {
        HttpUtils http = SingsHttpUtils.getHttp();
//        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
//        params.addBodyParameter("id", task_id);
//        if (!TextUtils.isEmpty(emotionMainFragment.getBar_edit_text().getText().toString().trim())) {
//            params.addBodyParameter("reply_text", emotionMainFragment.getBar_edit_text().getText().toString().trim());
//        }
//        if (!TextUtils.isEmpty(reply_uid)) {
//            //2.3.2增加回复单个人功能
//            params.addBodyParameter("reply_uid", reply_uid);
//        }
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.TASKREPLY,
                params, new RequestCallBackExpand<String>() {
                    @Override
                    public void onSuccess(ResponseInfo<String> responseInfo) {
                        try {
                            CommonListJson<ReplyInfo> bean = CommonListJson.fromJson(responseInfo.result, ReplyInfo.class);
                            if (bean.getState() != 0) {
                                emotionMainFragment.getBar_edit_text().setText("");
                                saveAndClearLocalInfo(false);
                                isReplyToBottom = true;
                                reply_uid = "";
                                if (null != emotionMainFragment) {
                                    emotionMainFragment.isInterceptBackPress();
                                }
                                getTaskReplyList();
                                hideSoftKeyboard();
                            } else {
                                DataUtil.showErrOrMsg(mActivity, bean.getErrno(), bean.getErrmsg());
                                finish();
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                            CommonMethod.makeNoticeShort(mActivity, getString(R.string.service_err), CommonMethod.ERROR);
                            finish();
                        } finally {
                            closeDialog();
                        }
                    }

                    /** xutils 连接失败 调用的 方法 */
                    @Override
                    public void onFailure(HttpException exception, String errormsg) {
                        closeDialog();
                        finish();
                    }
                });
    }

    /**
     * 修改任务状态
     */
    protected void taskStatusChange() {
        HttpUtils http = SingsHttpUtils.getHttp();
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        params.addBodyParameter("id", task_id);
        params.addBodyParameter("task_status", taskBean.getTask_status() == 1 ? "0" : "1");
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.TASKSTATUSCHANGE,
                params, new RequestCallBackExpand<String>() {
                    @Override
                    public void onSuccess(ResponseInfo<String> responseInfo) {
                        try {
                            CommonListJson<ReplyInfo> bean = CommonListJson.fromJson(responseInfo.result, ReplyInfo.class);
                            if (bean.getState() != 0) {
                                isChangeTaskState = true;
                                if (taskBean.getTask_status() == 1) {
                                    taskBean.setTask_status(0);
                                } else {
                                    taskBean.setTask_status(1);
                                }
                                setTaskState();
                                getTaskReplyList();

                            } else {
                                DataUtil.showErrOrMsg(mActivity, bean.getErrno(), bean.getErrmsg());
                                finish();
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                            CommonMethod.makeNoticeShort(mActivity, getString(R.string.service_err), CommonMethod.ERROR);
                            finish();
                        } finally {
                            closeDialog();
                        }
                    }

                    /** xutils 连接失败 调用的 方法 */
                    @Override
                    public void onFailure(HttpException exception, String errormsg) {
                        closeDialog();
                        finish();
                    }
                });
    }


    /**
     * 修改负责人
     */
    protected void setTaskPersonChange(final List<GroupMemberInfo> groupMemberInfos, final GroupMemberInfo info, final boolean isPrincipal) {
        HttpUtils http = SingsHttpUtils.getHttp();
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        params.addBodyParameter("id", task_id);
        if (isPrincipal) {
            params.addBodyParameter("principal_uid", info.getUid());
        } else {
            params.addBodyParameter("priticipant_uids", getActorUids(groupMemberInfos));
        }

        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.TASK_PERSON_CHANGE,
                params, new RequestCallBackExpand<String>() {
                    @Override
                    public void onSuccess(ResponseInfo<String> responseInfo) {
                        try {
                            CommonListJson<TaskBean> bean = CommonListJson.fromJson(responseInfo.result, TaskBean.class);
                            if (bean.getState() != 0) {
                                if (isPrincipal) {
                                    taskBean.getMembers().clear();
                                    taskBean.getMembers().add(info);
                                    setReadHead(true);
                                } else {
                                    taskBean.getUnrelay_members().clear();
                                    taskBean.getUnrelay_members().addAll(groupMemberInfos);
                                    setReadHead(false);
                                }
                                isChangeTaskState = true;
                                getTaskReplyList();
                            } else {
                                DataUtil.showErrOrMsg(mActivity, bean.getErrno(), bean.getErrmsg());
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                            CommonMethod.makeNoticeShort(mActivity, getString(R.string.service_err), CommonMethod.ERROR);
                        } finally {
                            closeDialog();
                        }
                    }

                    /** xutils 连接失败 调用的 方法 */
                    @Override
                    public void onFailure(HttpException exception, String errormsg) {
                        closeDialog();
                        finish();
                    }
                });
    }

    /**
     * 获取参与者id
     *
     * @return
     */
    private String getActorUids(List<GroupMemberInfo> groupMemberInfos) {
        StringBuilder builder = new StringBuilder();
        int i = 0;
        for (GroupMemberInfo groupMemberInfo : groupMemberInfos) {
            if (!TextUtils.isEmpty(groupMemberInfo.getUid())) {
                builder.append(i == 0 ? groupMemberInfo.getUid() : "," + groupMemberInfo.getUid());
                i += 1;
            }

        }
        return builder.toString();
    }

    @Override
    public void onFinish(View view) {
        if (null == emotionMainFragment) {
            mActivity.finish();
            return;
        }
        if (!emotionMainFragment.isInterceptBackPress()) {
            saveAndClearLocalInfo(true);
            if (isChangeTaskState) {
                setResult(Constance.RESULTCODE_FINISH, getIntent());
            }
            super.onFinish(view);
        }

    }

    @Override
    public void onBackPressed() {
        if (null == emotionMainFragment) {
            mActivity.finish();
            return;
        }
        if (!emotionMainFragment.isInterceptBackPress()) {
            saveAndClearLocalInfo(true);
            if (isChangeTaskState) {
                setResult(Constance.RESULTCODE_FINISH, getIntent());
            }
            mActivity.finish();
        }

    }

    @Override
    protected void onDestroy() {
        unregisterFinishActivity();
        super.onDestroy();
    }


    /**
     * 保存草稿信息
     */
    public void saveAndClearLocalInfo(boolean isSava) {
        String content = emotionMainFragment.getBar_edit_text().getText().toString().trim();
        if (TextUtils.isEmpty(content) && isSava) {
            return;
        }

        try {
            String class_type = Constance.TEAM;
            String msg_id = task_id;
            String msg_type = MessageType.MSG_TASK_STRING;
            LocalInfoBean logModeBean = new LocalInfoBean(Integer.parseInt(msg_id), class_type, msg_type, group_id, content, LocalInfoBean.TYPE_REPLY);
            MessageUtils.saveAndClearLocalInfo(logModeBean, isSava);
        } catch (Exception e) {

        }

    }

    /**
     * 读取草稿信息
     */
    public void readLocalInfo() {
        try {
            String class_type = Constance.TEAM;
            String msg_id = task_id;
            String msg_type = MessageType.MSG_TASK_STRING;
            LocalInfoBean logModeBean = new LocalInfoBean(Integer.parseInt(msg_id), class_type, msg_type, group_id, "", LocalInfoBean.TYPE_REPLY);
            String content = MessageUtils.selectLocalInfoNotice(logModeBean);
            LUtils.e("-----------readLocalInfo---------:" + content);
            emotionMainFragment.getBar_edit_text().setText(content);
        } catch (Exception e) {

        }

    }

    @Override
    public void clickAccess(int position) {
        taskStatusChange();
    }
}