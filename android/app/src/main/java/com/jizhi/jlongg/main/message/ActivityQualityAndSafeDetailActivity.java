package com.jizhi.jlongg.main.message;

import android.annotation.TargetApi;
import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.graphics.Rect;
import android.graphics.drawable.Drawable;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.support.v4.app.FragmentTransaction;
import android.text.Html;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.View;
import android.view.ViewTreeObserver;
import android.view.inputmethod.InputMethodManager;
import android.widget.AdapterView;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.RadioButton;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.hcs.uclient.utils.DensityUtils;
import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.TimesUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.emoji.emotionkeyboard.BarClickLintener;
import com.jizhi.jlongg.emoji.emotionkeyboard.EmotionKeyboard;
import com.jizhi.jlongg.emoji.fragment.EmotionMainFragment;
import com.jizhi.jlongg.groupimageviews.NineGridImageViewAdapter;
import com.jizhi.jlongg.groupimageviews.NineGridMsgImageView;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.activity.ChatUserInfoActivity;
import com.jizhi.jlongg.main.activity.MsgQualityAndSafeFilterActivity;
import com.jizhi.jlongg.main.activity.RectificationInstructionsActivity;
import com.jizhi.jlongg.main.activity.ReleaseProjecPeopleActivity;
import com.jizhi.jlongg.main.activity.ReleaseQualityAndSafeActivity;
import com.jizhi.jlongg.main.activity.qualityandsafe.QualityAndSafeChangeStepActivity;
import com.jizhi.jlongg.main.adpter.QuelityAndSafeDetailAdapter;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;
import com.jizhi.jlongg.main.bean.ImageItem;
import com.jizhi.jlongg.main.bean.LocalInfoBean;
import com.jizhi.jlongg.main.bean.MessageBean;
import com.jizhi.jlongg.main.bean.MessageEntity;
import com.jizhi.jlongg.main.bean.ReplyInfo;
import com.jizhi.jlongg.main.bean.status.CommonJson;
import com.jizhi.jlongg.main.dialog.DialogDelReply;
import com.jizhi.jlongg.main.dialog.DialogLogMore;
import com.jizhi.jlongg.main.popwindow.RecordAccountDateNotWeekPopWindow;
import com.jizhi.jlongg.main.util.BackGroundUtil;
import com.jizhi.jlongg.main.util.CameraPop;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DataUtil;
import com.jizhi.jlongg.main.util.GlideUtils;
import com.jizhi.jlongg.main.util.MessageUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SingsHttpUtils;
import com.jizhi.jlongg.main.util.SocketManager;
import com.jizhi.jlongg.main.util.WebSocket;
import com.jizhi.jlongg.main.util.WebSocketConstance;
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


/**
 * 通知质量详情
 *
 * @author huChangSheng
 * @version 1.0
 * @time 2016-11-25 下午2:41:57
 */

public class ActivityQualityAndSafeDetailActivity extends BaseActivity implements View.OnClickListener, QuelityAndSafeDetailAdapter.ReplyContentClickListener, BarClickLintener, EmotionKeyboard.ClickKeyBoardClickListner {
    private ActivityQualityAndSafeDetailActivity mActivity;
    //列表数据
    private ListView listView;
    //头像
    private RoundeImageHashCodeTextLayout img_head;
    //头部数据
    private MessageEntity msgEntity;
    //状态
    private RadioButton rb_state;
    //内容
    private TextView tv_content;
    //项目名称
    private TextView tv_proName;
    //名字
    private TextView tv_name;
    //图片集
    private NineGridMsgImageView imageGridView;
    //评论数据
    private List<ReplyInfo> replyInfos;
    //    private NoticeDetailAdapter adapter;
    private View headerView;
    //是否已经关闭
    private boolean isClose;
    //消息数据
    private ReplyInfo readInfo;
    private QuelityAndSafeDetailAdapter adapter;
    private GroupDiscussionInfo gnInfo;
    //整改时间修改
    private String timeStr;
    //整改负责人 修改
    private String people_uid;
    private boolean isReplyToBottom;
    //表情主界面
    private EmotionMainFragment emotionMainFragment;
    private SpringView springView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_notice_detail);
        mActivity = ActivityQualityAndSafeDetailActivity.this;
        getIntentData();
        initView();
        registerFinishActivity();
        registerReceiver();
        findViewById(R.id.rootView).setOnClickListener(this);
        headerView.setOnClickListener(this);
        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                hideSoftKeyboard();
            }
        });
    }

    String msg_id, group_id, msg_type, class_type;

    /**
     * 获取传递过来的数据
     */
    private void getIntentData() {

        Bundle bun = getIntent().getExtras();
        if (bun != null) {
            //推送跳转进来的
            Set<String> keySet = bun.keySet();
            for (String key : keySet) {
                if (!TextUtils.isEmpty(key) && key.equals("msg_id")) {
                    msg_id = bun.getString(key);
                } else if (!TextUtils.isEmpty(key) && key.equals("group_id")) {
                    group_id = bun.getString(key);
                } else if (!TextUtils.isEmpty(key) && key.equals("msg_type")) {
                    msg_type = bun.getString(key);
                } else if (!TextUtils.isEmpty(key) && key.equals("class_type")) {
                    class_type = bun.getString(key);
                }
            }

        }
        if (!TextUtils.isEmpty(msg_id) && !TextUtils.isEmpty(group_id) && !TextUtils.isEmpty(msg_type) && !TextUtils.isEmpty(class_type)) {
            msg = new MessageBean();
            msg.setMsg_id(Integer.parseInt(msg_id));
            msg.setGroup_id(group_id);
            msg.setMsg_type(msg_type);
            msg.setClass_type(class_type);
            isClose = false;
            LUtils.e("------11--------:");
        } else {
            msg = (MessageBean) getIntent().getSerializableExtra(Constance.BEAN_CONSTANCE);
            if (null == msg) {
                finish();
            }

        }
        isClose = getIntent().getBooleanExtra(Constance.BEAN_BOOLEAN, false);
        if (isClose) {
            findViewById(R.id.layout_edit).setVisibility(View.GONE);
        }
    }

    /**
     * 启动当前Acitivyt
     *
     * @param context
     */
    public static void actionStart(Activity context, MessageBean entity, GroupDiscussionInfo info) {
        Intent intent = new Intent(context, ActivityQualityAndSafeDetailActivity.class);
        intent.putExtra(Constance.BEAN_CONSTANCE, entity);
        intent.putExtra(Constance.GINFO, info);
        intent.putExtra(Constance.BEAN_BOOLEAN, info.getIs_closed() == 1);
        context.startActivityForResult(intent, Constance.REQUESTCODE_START);
    }

    /**
     * 启动当前Acitivyt
     *
     * @param context
     */
    public static void actionStart(Activity context, MessageBean entity, GroupDiscussionInfo info, String bill_id) {
        Intent intent = new Intent(context, ActivityQualityAndSafeDetailActivity.class);
        intent.putExtra(Constance.BEAN_CONSTANCE, entity);
        intent.putExtra(Constance.GINFO, info);
        intent.putExtra(Constance.BILLID, bill_id);
        intent.putExtra(Constance.BEAN_BOOLEAN, info.getIs_closed() == 1);
        context.startActivityForResult(intent, Constance.REQUESTCODE_START);
    }

    /**
     * 初始化View
     */
    public void initView() {
        headerView = getLayoutInflater().inflate(R.layout.layout_quality_and_safe_detail_head, null);
        //设置默认提示信息
        setTextTitleAndRight(R.string.question_detai, R.string.more);
        //初始化headview信息
        listView = findViewById(R.id.listview);
        img_head = headerView.findViewById(R.id.img_head);
        tv_content = headerView.findViewById(R.id.tv_content);
        tv_proName = headerView.findViewById(R.id.tv_proName);
        tv_name = headerView.findViewById(R.id.tv_name);
        rb_state = headerView.findViewById(R.id.rb_state);
        imageGridView = headerView.findViewById(R.id.ngl_images);
        listView.addHeaderView(headerView);
        //显示headview
        replyInfos = new ArrayList<>();
        adapter = new QuelityAndSafeDetailAdapter(mActivity, msg.getMsg_type(), replyInfos, this, new DialogDelReply.DelSuccessClickListener() {

            @Override
            public void delClickSuccess(int position) {
                replyInfos.remove(position);
                adapter.updateListView(replyInfos);

            }
        }, isClose ? 1 : 0);
        listView.setAdapter(adapter);
        gnInfo = (GroupDiscussionInfo) getIntent().getSerializableExtra(Constance.GINFO);
        findViewById(R.id.rea_change_name).setOnClickListener(this);
        findViewById(R.id.rea_change_time).setOnClickListener(this);
        findViewById(R.id.tv_change_name).setOnClickListener(this);
        findViewById(R.id.rea_steps_name).setOnClickListener(this);
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
                getDetail();
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

    @Override
    public void barBtnSendClick() {
        if (isClose) {
            return;
        }
        String text = emotionMainFragment.getBar_edit_text().getText().toString().trim();
        if (TextUtils.isEmpty(text)) {
            CommonMethod.makeNoticeShort(mActivity, "请填写回复内容", CommonMethod.ERROR);
            return;
        }
        fileUpData(null);
    }

    /**
     * 初始化键盘监听
     */
    @Override
    public void barImageAddClick() {
        Toast.makeText(mActivity, "添加", Toast.LENGTH_SHORT).show();
    }

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

    private int computeUsableHeight() {
        Rect r = new Rect();
        mChildOfContent.getWindowVisibleDisplayFrame(r);
        return (r.bottom - r.top);
    }

    @Override
    public void replyContentClick(String uid, final String name) {
        if (!TextUtils.isEmpty(name) && null != emotionMainFragment && null != emotionMainFragment.getBar_edit_text()) {
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
    @TargetApi(Build.VERSION_CODES.LOLLIPOP)
    private void setHeadData() {
        headerView.setVisibility(View.VISIBLE);
        if (TextUtils.isEmpty(msgEntity.getReal_name())) {
            img_head.setView(msgEntity.getHead_pic(), msgEntity.getUser_name(), 0);
        } else {
            img_head.setView(msgEntity.getHead_pic(), msgEntity.getReal_name(), 0);
        }
        tv_proName.setText(Html.fromHtml("<font color='#999999'>来自：</font>" + msgEntity.getFrom_group_name() + ""));
        if (!TextUtils.isEmpty(msgEntity.getMsg_text())) {
            tv_content.setText(msgEntity.getMsg_text());
            tv_content.setVisibility(View.VISIBLE);
            DataUtil.setHtmlClick(tv_content, mActivity);
        }

        ((TextView) headerView.findViewById(R.id.tv_addr)).setText(msgEntity.getLocation());
        TextView tv_level = headerView.findViewById(R.id.tv_level);
        if (msgEntity.getSeverity().equals("1")) {
            tv_level.setTextColor(getResources().getColor(R.color.color_666666));
        }
        //隐患级别
        tv_level.setText("[" + msgEntity.getSeverity_text() + "]");
        //整改负责人
        if (!TextUtils.isEmpty(msgEntity.getPrincipal_name())) {
            ((TextView) headerView.findViewById(R.id.tv_change_name)).setText(msgEntity.getPrincipal_name());
            findViewById(R.id.rea_change_name).setVisibility(View.VISIBLE);
            people_uid = msgEntity.getPrincipal_uid();

            ((TextView) headerView.findViewById(R.id.tv_change_time)).setText(msgEntity.getFinish_time());
            findViewById(R.id.rea_change_time).setVisibility(View.VISIBLE);

            //整改完成期限
            if (!TextUtils.isEmpty(msgEntity.getFinish_time())) {
                ((TextView) headerView.findViewById(R.id.tv_change_time)).setText(msgEntity.getFinish_time());
                ((TextView) headerView.findViewById(R.id.tv_change_time)).setTextColor(getResources().getColor(R.color.color_333333));
                findViewById(R.id.rea_change_time).setVisibility(View.VISIBLE);
//                if (msgEntity.getFinish_time_status() == 1) {
//                    ((TextView) headerView.findViewById(R.id.tv_change_time)).setTextColor(getResources().getColor(R.color.color_d7252c));
//                } else if (msgEntity.getFinish_time_status() == 2) {
//                    ///2：待整改的问题，0<=整改完成期限-当前日期<3天时；
//                    ((TextView) headerView.findViewById(R.id.tv_change_time)).setTextColor(getResources().getColor(R.color.color_f9a00f));
//                } else if (msgEntity.getFinish_time_status() == 3) {
//                    //3：待整改的问题，0<=整改完成期限-当前日期>=3天时
//                    ((TextView) headerView.findViewById(R.id.tv_change_time)).setTextColor(getResources().getColor(R.color.color_333333));
//                } else {
//                    ((TextView) headerView.findViewById(R.id.tv_change_time)).setTextColor(getResources().getColor(R.color.color_999999));
//                }
            }

            //整改措施
            if (!TextUtils.isEmpty(msgEntity.getMsg_steps())) {
                headerView.findViewById(R.id.tv_text_stecp).setVisibility(View.VISIBLE);
                ((TextView) headerView.findViewById(R.id.tv_text_stecp)).setText(msgEntity.getMsg_steps());
            } else {
                headerView.findViewById(R.id.tv_text_stecp).setVisibility(View.GONE);
            }
        }


        tv_name.setTextColor(getResources().getColor(R.color.color_628ae0));
        findViewById(R.id.img_head).setOnClickListener(this);
        findViewById(R.id.tv_name).setOnClickListener(this);
        setStatu(msgEntity.getStatu());

        tv_name.setText(msgEntity.getReal_name());
        if (msgEntity.getMsg_src() != null && msgEntity.getMsg_src().size() > 0) {
            imageGridView.setVisibility(View.VISIBLE);
            imageGridView.setAdapter(mAdapter);
            imageGridView.setImagesData(msgEntity.getMsg_src());
        } else {
            imageGridView.setVisibility(View.GONE);
        }
        rb_state.setOnClickListener(this);
        if (!msgEntity.getStatu().equals("3") && (msgEntity.getIs_admin() == 1 || msgEntity.getIs_creater() == 1 || UclientApplication.getUid(mActivity).equals(msgEntity.getUid()))) {
            findViewById(R.id.rea_change_name).setVisibility(View.VISIBLE);
            findViewById(R.id.rea_change_time).setVisibility(View.VISIBLE);
            if (!isClose) {
                findViewById(R.id.img_rights).setVisibility(View.VISIBLE);
                findViewById(R.id.img_right).setVisibility(View.VISIBLE);
                findViewById(R.id.img_right_step).setVisibility(View.VISIBLE);
                findViewById(R.id.tv_tochange_name).setVisibility(View.VISIBLE);
                findViewById(R.id.tv_tochange_time).setVisibility(View.VISIBLE);
                findViewById(R.id.tv_right_step).setVisibility(View.VISIBLE);

            }
        }
        if (msgEntity.getStatu().equals("3")) {
            findViewById(R.id.img_rights).setVisibility(View.GONE);
            findViewById(R.id.img_right).setVisibility(View.GONE);
            findViewById(R.id.rea_change_name).setVisibility(View.GONE);
            findViewById(R.id.rea_change_time).setVisibility(View.GONE);
            findViewById(R.id.img_right_step).setVisibility(View.GONE);
            findViewById(R.id.tv_tochange_name).setVisibility(View.GONE);
            findViewById(R.id.tv_tochange_time).setVisibility(View.GONE);
            findViewById(R.id.tv_right_step).setVisibility(View.GONE);
        }
        if (msgEntity.getUid().equals(UclientApplication.getUid(mActivity)) && !isClose) {
            findViewById(R.id.right_title).setVisibility(View.VISIBLE);
        }
    }

    @TargetApi(Build.VERSION_CODES.LOLLIPOP)
    public void setStatu(String statu) {

        if (msgEntity.getShow_bell() == 1) {
            headerView.findViewById(R.id.img_light).setBackground(getResources().getDrawable(R.drawable.icon_bill_red));
            rb_state.setTextColor(getResources().getColor(R.color.color_eb4e4e));
            if ((UclientApplication.getUid(mActivity).equals(msgEntity.getUid()) || msgEntity.getIs_creater() == 1 || msgEntity.getIs_admin() == 1) && !isClose) {
                //当前用户ID=提交人ID/复查人ID
                Drawable img_right = getResources().getDrawable(R.drawable.icon_pen_red);
                img_right.setBounds(0, 0, img_right.getMinimumWidth(), img_right.getMinimumHeight());
                rb_state.setCompoundDrawables(null, null, img_right, null); //设置左图标
                rb_state.setCompoundDrawablePadding(5);
                int left = (int) DensityUtils.px2dp(mActivity, 60);
                int top = (int) DensityUtils.px2dp(mActivity, 20);
                int right = (int) DensityUtils.px2dp(mActivity, 60);
                int bottom = (int) DensityUtils.px2dp(mActivity, 20);
                rb_state.setBackgroundResource(R.drawable.stroke_5998f6);
                rb_state.setPadding(left, top, right, bottom);
            } else {
                rb_state.setCompoundDrawables(null, null, null, null); //设置左图标
                rb_state.setBackground(null);
            }
        } else if (msgEntity.getShow_bell() == 2) {
            headerView.findViewById(R.id.img_light).setBackground(getResources().getDrawable(R.drawable.icon_bill_yellow));
            rb_state.setTextColor(getResources().getColor(R.color.color_f9a00f));
            if (UclientApplication.getUid(mActivity).equals(msgEntity.getPrincipal_uid()) && !isClose) {
                //如果自己是整改人显示整改完成
                Drawable img_right = getResources().getDrawable(R.drawable.icon_pen_yellow);
                img_right.setBounds(0, 0, img_right.getMinimumWidth(), img_right.getMinimumHeight());
                rb_state.setCompoundDrawables(null, null, img_right, null); //设置左图标
                rb_state.setCompoundDrawablePadding(5);
                int left = (int) DensityUtils.px2dp(mActivity, 60);
                int top = (int) DensityUtils.px2dp(mActivity, 20);
                int right = (int) DensityUtils.px2dp(mActivity, 60);
                int bottom = (int) DensityUtils.px2dp(mActivity, 20);
                rb_state.setBackgroundResource(R.drawable.stroke_f9a00f);
                rb_state.setPadding(left, top, right, bottom);
            } else {
                rb_state.setCompoundDrawables(null, null, null, null); //设置左图标
                rb_state.setBackground(null);
            }
        } else if (msgEntity.getShow_bell() == 3) {
            headerView.findViewById(R.id.img_light).setBackground(getResources().getDrawable(R.drawable.icon_bill_green));
            rb_state.setTextColor(getResources().getColor(R.color.color_83c76e));
            if (UclientApplication.getUid(mActivity).equals(msgEntity.getPrincipal_uid()) && !isClose) {
                //如果自己是整改人显示整改完成

                Drawable img_right = getResources().getDrawable(R.drawable.icon_pen_green);
                img_right.setBounds(0, 0, img_right.getMinimumWidth(), img_right.getMinimumHeight());
                rb_state.setCompoundDrawables(null, null, img_right, null); //设置左图标
                rb_state.setCompoundDrawablePadding(5);
                int left = (int) DensityUtils.px2dp(mActivity, 60);
                int top = (int) DensityUtils.px2dp(mActivity, 20);
                int right = (int) DensityUtils.px2dp(mActivity, 60);
                int bottom = (int) DensityUtils.px2dp(mActivity, 20);
                rb_state.setBackgroundResource(R.drawable.stroke_83c76e);
                rb_state.setPadding(left, top, right, bottom);
            } else {
                rb_state.setCompoundDrawables(null, null, null, null); //设置左图标
                rb_state.setBackground(null);
            }
        }
        //1:待整改；2：待复查；3：已完结
        if (statu.equals("1")) {
            rb_state.setText("待整改");
            if (UclientApplication.getUid(mActivity).equals(msgEntity.getPrincipal_uid())) {
                Drawable img_right = getDrawableOpen();
                img_right.setBounds(0, 0, img_right.getMinimumWidth(), img_right.getMinimumHeight());
                rb_state.setCompoundDrawables(null, null, img_right, null); //设置左图标
                rb_state.setCompoundDrawablePadding(5);
                int left = (int) DensityUtils.px2dp(mActivity, 60);
                int top = (int) DensityUtils.px2dp(mActivity, 20);
                int right = (int) DensityUtils.px2dp(mActivity, 60);
                int bottom = (int) DensityUtils.px2dp(mActivity, 20);
                rb_state.setBackgroundResource(getBck());
                rb_state.setPadding(left, top, right, bottom);
            } else {
                rb_state.setCompoundDrawables(null, null, null, null); //设置左图标
                rb_state.setBackground(null);
            }


        } else if (statu.equals("2")) {
            rb_state.setText("待复查");
            if (UclientApplication.getUid(mActivity).equals(msgEntity.getUid()) || msgEntity.getIs_creater() == 1 || msgEntity.getIs_admin() == 1) {
                Drawable img_right = getDrawableOpen();
                img_right.setBounds(0, 0, img_right.getMinimumWidth(), img_right.getMinimumHeight());
                rb_state.setCompoundDrawables(null, null, img_right, null); //设置左图标
                rb_state.setCompoundDrawablePadding(5);
                int left = (int) DensityUtils.px2dp(mActivity, 60);
                int top = (int) DensityUtils.px2dp(mActivity, 20);
                int right = (int) DensityUtils.px2dp(mActivity, 60);
                int bottom = (int) DensityUtils.px2dp(mActivity, 20);
                rb_state.setBackgroundResource(getBck());
                rb_state.setPadding(left, top, right, bottom);
            } else {
                rb_state.setCompoundDrawables(null, null, null, null); //设置左图标
                rb_state.setBackground(null);
            }
        } else if (statu.equals("3")) {
            rb_state.setText("已完结");
            findViewById(R.id.right_title).setVisibility(View.GONE);
            rb_state.setCompoundDrawables(null, null, null, null); //设置左图标
            rb_state.setBackground(null);
        }

        msgEntity.setStatu(statu);
    }

    public Drawable getDrawableOpen() {
        Drawable img_right = null;
        //当前用户ID=提交人ID/复查人ID
        if (msgEntity.getShow_bell() == 1) {
            img_right = getResources().getDrawable(R.drawable.icon_pen_red);
        } else if (msgEntity.getShow_bell() == 2) {
            img_right = getResources().getDrawable(R.drawable.icon_pen_yellow);
        } else if (msgEntity.getShow_bell() == 3) {
            img_right = getResources().getDrawable(R.drawable.icon_pen_green);
        }
        return img_right;
    }

    public int getBck() {
        //当前用户ID=提交人ID/复查人ID
        if (msgEntity.getShow_bell() == 1) {
            return R.drawable.stroke_5998f6;
        } else if (msgEntity.getShow_bell() == 2) {
            return R.drawable.stroke_f9a00f;
        } else if (msgEntity.getShow_bell() == 3) {
            return R.drawable.stroke_83c76e;
        }
        return 0;
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
            MessageImagePagerActivity.startImagePagerActivity((Activity) context, list, index, imageSize);
        }
    };
    //日志更多
    private DialogLogMore dialogLogMore;

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
//            case R.id.rb_reply:
//                if (isClose) {
//                    return;
//                }
//                //弹出回复键盘
//                InputMethodManager imm = (InputMethodManager) emotionMainFragment.getBar_edit_text().getContext().getSystemService(Context.INPUT_METHOD_SERVICE);
//                imm.toggleSoftInput(0, InputMethodManager.SHOW_IMPLICIT);
//                emotionMainFragment.getBar_edit_text().setFocusable(true);
//                emotionMainFragment.getBar_edit_text().setFocusableInTouchMode(true);
//                emotionMainFragment.getBar_edit_text().requestFocus();
//                break;
//            case R.id.rb_received:
//                if (isClose) {
//                    return;
//                }
//                //收到
//                requsetMessage();
//                break;
            case R.id.rootView:
            case R.id.layout_notice_detail_head:
                if (isClose) {
                    return;
                }
                hideSoftKeyboard();
                break;
            case R.id.img_head:
            case R.id.tv_name:
                if (TextUtils.isEmpty(msgEntity.getUid())) {
                    return;
                }
                Intent intent = new Intent(ActivityQualityAndSafeDetailActivity.this, ChatUserInfoActivity.class);
                intent.putExtra(Constance.UID, msgEntity.getUid());
                startActivityForResult(intent, Constance.REQUESTCODE_SINGLECHAT);
                break;
            case R.id.rb_state:
                if (isClose) {
                    return;
                }
                //1:待整改；2：待复查；3：已完结
                if (msgEntity.getStatu().equals("1")) {
                    if (UclientApplication.getUid(mActivity).equals(msgEntity.getPrincipal_uid())) {
                        RectificationInstructionsActivity.actionStart(mActivity, gnInfo, msgEntity.getStatu(), msg_id + "", msgEntity.getMsg_type(), msgEntity);
                    }
                } else if (msgEntity.getStatu().equals("2")) {
                    if (UclientApplication.getUid(mActivity).equals(msgEntity.getUid()) || msgEntity.getIs_creater() == 1 || msgEntity.getIs_admin() == 1) {
                        RectificationInstructionsActivity.actionStart(mActivity, gnInfo, msgEntity.getStatu(), msg_id + "", msgEntity.getMsg_type(), msgEntity);
                    }
                }
                break;
            case R.id.rea_change_name:
                if (isClose) {
                    return;
                }
                //整改负责人
                if (!msgEntity.getStatu().equals("3") && (msgEntity.getIs_admin() == 1 || msgEntity.getIs_creater() == 1 || UclientApplication.getUid(mActivity).equals(msgEntity.getUid()))) {
                    ReleaseProjecPeopleActivity.actionStart(mActivity, gnInfo, !TextUtils.isEmpty(people_uid) ? people_uid : "", MsgQualityAndSafeFilterActivity.FILTER_CHANGE, "选择整改负责人");
                }
                break;
            case R.id.rea_change_time:
                if (isClose) {
                    return;
                }
                //完成期限
                if (!msgEntity.getStatu().equals("3") && (msgEntity.getIs_admin() == 1 || msgEntity.getIs_creater() == 1 || UclientApplication.getUid(mActivity).equals(msgEntity.getUid()))) {
                    setTime();
                }
                break;
            case R.id.rea_steps_name:
                //整改措施
                if (!msgEntity.getStatu().equals("3") && (msgEntity.getIs_admin() == 1 || msgEntity.getIs_creater() == 1 || UclientApplication.getUid(mActivity).equals(msgEntity.getUid()))) {
                    String text = ((TextView) headerView.findViewById(R.id.tv_text_stecp)).getText().toString();
                    QualityAndSafeChangeStepActivity.actionStart(mActivity, msg.getMsg_id() + "", msgEntity.getMsg_type(), text);
                }
                break;
            case R.id.right_title:
                if (dialogLogMore == null) {
                    String desc = "你确定要删除该记录吗？";
                    dialogLogMore = new DialogLogMore(mActivity, desc, msgEntity.getMsg_id() + "", msgEntity.getMsg_type(), null);
                }
                dialogLogMore.goneEdit();
                dialogLogMore.showAtLocation(findViewById(R.id.rootView), Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0);//这种方式无论有虚拟按键还是没有都可完全显示，因为它显示的在整个父布局中
                BackGroundUtil.backgroundAlpha(mActivity, 0.5f);
                break;
            case R.id.tv_proName:
                if (isClose) {
                    return;
                }
                MessageUtil.setIndexList(mActivity, gnInfo, false, true);
                break;
            case R.id.tv_change_name:
                if (isClose) {
                    return;
                }
                TextView tv_change_name = (TextView) findViewById(R.id.tv_change_name);
                if (!TextUtils.isEmpty(tv_change_name.getText().toString())) {
                    ChatUserInfoActivity.actionStart(mActivity, people_uid);
                }
                break;
        }
    }


    private RecordAccountDateNotWeekPopWindow datePickerPopWindow;

    public void setTime() {
        if (null == datePickerPopWindow) {
            datePickerPopWindow = new RecordAccountDateNotWeekPopWindow(mActivity, getString(R.string.choosetime), 1, new RecordAccountDateNotWeekPopWindow.SelectedDateListener() {
                @Override
                public void selectedDays() { //选择多天
                }

                @Override
                public void selectedDate(String year, String month, String day, String week) {
                    int intYear = Integer.parseInt(year);
                    int intMonth = Integer.parseInt(month);
                    int intDay = Integer.parseInt(day);
                    int currentTime = TimesUtils.getCurrentTimeYearMonthDay()[0] * 10000 + TimesUtils.getCurrentTimeYearMonthDay()[1] * 100 + TimesUtils.getCurrentTimeYearMonthDay()[2];

//                    if (intYear * 10000 + intMonth * 100 + intDay < currentTime) {
//                        CommonMethod.makeNoticeShort(mActivity, "不能记录今天之前的内容", CommonMethod.ERROR);
//                        return;
//                    } else {
                    String months = Integer.parseInt(month) < 10 ? "0" + month : month;
                    String days = Integer.parseInt(day) < 10 ? "0" + day : day;
                    timeStr = year + "-" + months + "-" + days;
                    modifyQualitySafe(timeStr, null, null, true);
                    isFlushData = true;
//                    }
                }
            }, 0, 0, 0);
        } else {
            datePickerPopWindow.update();
        }
        datePickerPopWindow.showAtLocation(mActivity.findViewById(R.id.rootView), Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0); //设置layout在PopupWindow中显示的位置
        BackGroundUtil.backgroundAlpha(mActivity, 0.5F);
        datePickerPopWindow.goneRecordDays();
    }


    //隐藏键盘

    private void toggleInput(Context context) {
        InputMethodManager inputMethodManager =
                (InputMethodManager) context.getSystemService(Context.INPUT_METHOD_SERVICE);
        inputMethodManager.toggleSoftInput(0, InputMethodManager.HIDE_NOT_ALWAYS);
    }

    /**
     * 注册广播
     */
    private void registerReceiver() {
        receiver = new MessageBroadcast();
        IntentFilter filter = new IntentFilter();
        filter.addAction(WebSocketConstance.LOGDEL);
        filter.addAction(WebSocketConstance.requestMessage);
        registerLocal(receiver, filter);
    }


    /**
     * 通知,安全,质量,日志 收到
     */
    private void requsetMessage() {
        WebSocket webSocket = SocketManager.getInstance(getApplicationContext()).getWebSocket();
        if (webSocket != null) {
            WebSocketMeassgeParameter group = new WebSocketMeassgeParameter();
            group.setCtrl("message");
            group.setAction(WebSocketConstance.requestMessage);
            group.setMsg_id(msgEntity.getMsg_id() + "");
            webSocket.requestServerMessage(group);
        }
    }

    //返回后是否刷新数据
    private boolean isFlushData;

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == Constance.REQUESTCODE_SINGLECHAT & resultCode == Constance.CLICK_SINGLECHAT) {
            GroupDiscussionInfo info = (GroupDiscussionInfo) data.getSerializableExtra(Constance.BEAN_CONSTANCE);
            Intent intent = new Intent();
            Bundle bundle = new Bundle();
            bundle.putSerializable(Constance.BEAN_CONSTANCE, info);
            intent.putExtras(bundle);
            setResult(Constance.CLICK_SINGLECHAT, intent);
            finish();
        } else if (requestCode == Constance.REQUEST && resultCode == MsgQualityAndSafeFilterActivity.FILTER_CHANGE) {
            //整改负责人
            String peopleStr = data.getStringExtra(ReleaseQualityAndSafeActivity.VALUE);
            String people_uid = data.getStringExtra(ReleaseProjecPeopleActivity.UID);
            if (TextUtils.isEmpty(people_uid) || !this.people_uid.equals(people_uid)) {
                this.people_uid = people_uid;
                modifyQualitySafe(null, this.people_uid, peopleStr, false);
            }
            isFlushData = true;
        } else if (requestCode == Constance.REQUEST && resultCode == RectificationInstructionsActivity.FINISH) {
            isFlushData = true;
            getDetail();
        } else if (requestCode == CameraPop.REQUEST_IMAGE && resultCode == RESULT_OK) {//选择相册回调
            ArrayList<String> mSelected = data.getStringArrayListExtra(MultiImageSelectorActivity.EXTRA_RESULT);
//            taskStatusChange(null, mSelected);
            fileUpData(mSelected);
        } else if (requestCode == Constance.REQUESTCODE_START && resultCode == Constance.REQUEST) {
            //修改整改措施回调
            LUtils.e("----------AAAAAaaaa------------");
            isFlushData = true;
            getDetail();
        }
    }


    /**
     * 广播回调
     */
    class MessageBroadcast extends BroadcastReceiver {
        @Override
        public void onReceive(Context context, Intent intent) {
            String action = intent.getAction();
            if (action.equals(WebSocketConstance.LOGDEL)) {
                findViewById(R.id.lin_message_def).setVisibility(View.VISIBLE);
                findViewById(R.id.lin_content).setVisibility(View.GONE);
                findViewById(R.id.right_title).setVisibility(View.GONE);
            }
        }

    }

    private MessageBean msg;

    /**
     * 获取安全质量详情
     */
    protected void getDetail() {
        HttpUtils http = SingsHttpUtils.getHttp();
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        String bill_id = getIntent().getStringExtra(Constance.BILLID);
        if (!TextUtils.isEmpty(bill_id)) {
            params.addBodyParameter("bill_id", bill_id);
            params.addBodyParameter("msg_type", msg.getMsg_type());
        } else {
            params.addBodyParameter("msg_id", msg.getMsg_id() + "");
        }
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.GET_GETQUALITYANDSAFEINFO,
                params, new RequestCallBack<String>() {
                    @Override
                    public void onSuccess(ResponseInfo<String> responseInfo) {
                        try {
                            CommonJson<MessageEntity> bean = CommonJson.fromJson(responseInfo.result, MessageEntity.class);
                            if (bean.getState() != 0) {
                                msgEntity = bean.getValues();
                                msg.setMsg_id(msgEntity.getMsg_id());
                                setHeadData();
                                getReplyMessageList();
                            } else {
//                                    if (bean.getErrno().equals("820020")) {
//                                        findViewById(R.id.lin_message_def).setVisibility(View.VISIBLE);
//                                        findViewById(R.id.lin_content).setVisibility(View.GONE);
////                                        findViewById(R.id.rightLayout).setVisibility(View.GONE);
//                                        return;
//                                    }
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
     * 获取安全质量回复列表
     */
    protected void getReplyMessageList() {
        HttpUtils http = SingsHttpUtils.getHttp();
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        String bill_id = getIntent().getStringExtra(Constance.BILLID);
        if (!TextUtils.isEmpty(bill_id)) {
            params.addBodyParameter("bill_id", bill_id);
            params.addBodyParameter("msg_type", msg.getMsg_type());
        } else {
            params.addBodyParameter("msg_id", msg.getMsg_id() + "");
        }
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.GET_RPLYMESSAGRLIST,
                params, new RequestCallBack<String>() {
                    @Override
                    public void onSuccess(ResponseInfo<String> responseInfo) {
                        try {
                            CommonJson<ReplyInfo> bean = CommonJson.fromJson(responseInfo.result, ReplyInfo.class);
                            if (bean.getState() != 0) {
                                replyInfos = bean.getValues().getList();
                                adapter.updateListView(bean.getValues().getList());
                                if (isReplyToBottom) {
                                    listView.setSelection(replyInfos.size());
                                    isReplyToBottom = false;
                                }

                            } else {
                                DataUtil.showErrOrMsg(mActivity, bean.getErrno(), bean.getErrmsg());
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                            CommonMethod.makeNoticeShort(mActivity, getString(R.string.service_err), CommonMethod.ERROR);
                        } finally {
                        }
                    }

                    /** xutils 连接失败 调用的 方法 */
                    @Override
                    public void onFailure(HttpException exception, String errormsg) {
                    }
                });
    }


    /**
     * 修改整改负责人，完成时间
     */
    protected void modifyQualitySafe(final String finish_time, final String prople_uid, final String people_str, final boolean isFinishTime) {
        HttpUtils http = SingsHttpUtils.getHttp();
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        params.addBodyParameter("msg_id", msg.getMsg_id() + "");
        if (!TextUtils.isEmpty(finish_time)) {
            params.addBodyParameter("finish_time", finish_time);
        }
        if (!TextUtils.isEmpty(prople_uid)) {
            params.addBodyParameter("principal_uid", prople_uid);
        }
        params.addBodyParameter("msg_type", msgEntity.getMsg_type());
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.MODIFY_QUALITY_AND_SAFE,
                params, new RequestCallBackExpand<String>() {
                    @Override
                    public void onSuccess(ResponseInfo<String> responseInfo) {
                        try {
                            CommonJson<MessageEntity> bean = CommonJson.fromJson(responseInfo.result, MessageEntity.class);
                            if (bean.getState() != 0) {
                                if (isFinishTime) {
                                    ((TextView) headerView.findViewById(R.id.tv_change_time)).setText(finish_time);
                                } else {
                                    ((TextView) headerView.findViewById(R.id.tv_change_name)).setText(people_str);
                                }
                                isFlushData = true;
                                getDetail();
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

    RequestParams params;

    public void fileUpData(final List<String> list) {
        createCustomDialog();
        new Thread(new Runnable() {
            @Override
            public void run() {
                params = RequestParamsToken.getExpandRequestParams(mActivity);
                if (null != list && list.size() > 0) {
                    RequestParamsToken.compressImageAndUpLoad(params, list, mActivity);
                }
                params.addBodyParameter("msg_id", msg.getMsg_id() + "");
                if (!TextUtils.isEmpty(gnInfo.getGroup_id())) {
                    params.addBodyParameter("group_id", gnInfo.getGroup_id());
                }
                if (!TextUtils.isEmpty(msg.getClass_type())) {
                    params.addBodyParameter("class_type", gnInfo.getClass_type());
                }
                if (!TextUtils.isEmpty(msg.getMsg_type())) {
                    params.addBodyParameter("reply_type", msg.getMsg_type());
                }
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
                    taskStatusChange();
                    break;
            }

        }
    };

    /**
     * 回复质量安全
     */
    protected void taskStatusChange() {
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.REPLYMESSAGE,
                params, new RequestCallBack<String>() {
                    @Override
                    public void onSuccess(ResponseInfo<String> responseInfo) {
                        try {
                            CommonJson<ReplyInfo> bean = CommonJson.fromJson(responseInfo.result, ReplyInfo.class);
                            if (bean.getState() != 0) {
                                replyInfos = bean.getValues().getList();
                                adapter.updateListView(bean.getValues().getList());
                                listView.setSelection(replyInfos.size());
                                emotionMainFragment.getBar_edit_text().setText("");
                                saveAndClearLocalInfo(false);
                                isReplyToBottom = true;
                                if (null != emotionMainFragment) {
                                    emotionMainFragment.isInterceptBackPress();
                                }
                                CommonMethod.makeNoticeShort(mActivity, "回复成功", CommonMethod.SUCCESS);
                            } else {
                                DataUtil.showErrOrMsg(mActivity, bean.getErrno(), bean.getErrmsg());
                                finish();
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
                    }
                });
    }

    /* 图片数据 */
    private List<ImageItem> photos = new ArrayList<>();

    /**
     * 当前已选图片路径
     */
    public ArrayList<String> selectedPhotoPath() {
        ArrayList<String> mSelected = new ArrayList<String>();
        int size = photos.size();
        for (int i = 0; i < size; i++) {
            ImageItem item = photos.get(i);
            if (!TextUtils.isEmpty(item.imagePath)) {
                mSelected.add(item.imagePath);
            }

        }
        return mSelected;
    }

    @Override
    public void onFinish(View view) {
        if (null == emotionMainFragment) {
            mActivity.finish();
            return;
        }
        if (!emotionMainFragment.isInterceptBackPress()) {
            saveAndClearLocalInfo(true);
            if (isFlushData) {
                mActivity.setResult(RectificationInstructionsActivity.FINISH, getIntent());
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
            if (isFlushData) {
                mActivity.setResult(RectificationInstructionsActivity.FINISH, getIntent());
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
            String group_id = gnInfo.getGroup_id();
            String class_type = gnInfo.getClass_type();
            long msg_id = msg.getMsg_id();
            String msg_type = msg.getMsg_type();
            LocalInfoBean logModeBean = new LocalInfoBean(msg_id, class_type, msg_type, group_id, content, LocalInfoBean.TYPE_REPLY);
            MessageUtils.saveAndClearLocalInfo(logModeBean, isSava);
        } catch (Exception e) {

        }

    }

    /**
     * 读取草稿信息
     */
    public void readLocalInfo() {
        try {
            String group_id = gnInfo.getGroup_id();
            String class_type = gnInfo.getClass_type();
            long msg_id = msg.getMsg_id();
            String msg_type = msg.getMsg_type();
            LocalInfoBean logModeBean = new LocalInfoBean(msg_id, class_type, msg_type, group_id, "", LocalInfoBean.TYPE_REPLY);
            String content = MessageUtils.selectLocalInfoNotice(logModeBean);
            emotionMainFragment.getBar_edit_text().setText(content);
        } catch (Exception e) {

        }

    }
}
