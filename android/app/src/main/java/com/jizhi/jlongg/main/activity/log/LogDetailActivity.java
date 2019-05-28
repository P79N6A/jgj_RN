package com.jizhi.jlongg.main.activity.log;

import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.graphics.Rect;
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
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.bumptech.glide.Glide;
import com.hcs.uclient.utils.LUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.emoji.emotionkeyboard.BarClickLintener;
import com.jizhi.jlongg.emoji.emotionkeyboard.EmotionKeyboard;
import com.jizhi.jlongg.emoji.fragment.EmotionMainFragment;
import com.jizhi.jlongg.groupimageviews.NineGridImageViewAdapter;
import com.jizhi.jlongg.groupimageviews.NineGridMsgImageView;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.activity.ChatUserInfoActivity;
import com.jizhi.jlongg.main.adpter.LogDetailHeadInfoAdapter;
import com.jizhi.jlongg.main.adpter.NoticeDetailAdapter;
import com.jizhi.jlongg.main.adpter.QuelityAndSafeDetailAdapter;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;
import com.jizhi.jlongg.main.bean.LocalInfoBean;
import com.jizhi.jlongg.main.bean.LogModeBean;
import com.jizhi.jlongg.main.bean.ReplyInfo;
import com.jizhi.jlongg.main.bean.TaskBean;
import com.jizhi.jlongg.main.bean.status.CommonJson;
import com.jizhi.jlongg.main.dialog.DialogDelReply;
import com.jizhi.jlongg.main.dialog.DialogLeftRightBtnConfirm;
import com.jizhi.jlongg.main.dialog.DialogLogMore;
import com.jizhi.jlongg.main.message.MessageImagePagerActivity;
import com.jizhi.jlongg.main.message.MessageReadInfoListActivity;
import com.jizhi.jlongg.main.message.MessageUtils;
import com.jizhi.jlongg.main.msg.MessageType;
import com.jizhi.jlongg.main.util.BackGroundUtil;
import com.jizhi.jlongg.main.util.CameraPop;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DataUtil;
import com.jizhi.jlongg.main.util.GlideUtils;
import com.jizhi.jlongg.main.util.MessageUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SetTitleName;
import com.jizhi.jlongg.main.util.SingsHttpUtils;
import com.jizhi.jlongg.main.util.WebSocketConstance;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.jizhi.jongg.widget.ListViewForScrollView;
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
 * CName:新日志详情页2.3.0
 * User: hcs
 * Date: 2017-07-25
 * Time: 16:37
 */

//CheckInspectioPlanActivity
public class LogDetailActivity extends BaseActivity implements View.OnClickListener, QuelityAndSafeDetailAdapter.ReplyContentClickListener, BarClickLintener, EmotionKeyboard.ClickKeyBoardClickListner {
    private LogDetailActivity mActivity;
    private GroupDiscussionInfo gnInfo;
    private ListView listView;
    private ListViewForScrollView head_listview;
    //list头部view
    private View headerView;
    //头像
    private RoundeImageHashCodeTextLayout img_head;
    //名字
    private TextView tv_name;
    //评论数据
    private List<ReplyInfo> replyInfos;
    //评论适配器
    private QuelityAndSafeDetailAdapter adapter;
    //图片集
    private NineGridMsgImageView imageGridView;
    //是否已经关闭
    private boolean isClose;
    //消息数据
    private ReplyInfo readInfo;
    private TextView tv_unreceived;
    //项目名称
    private TextView tv_proName;
    private LogModeBean logModeBean;
    //返回时候是否刷新数据
    private boolean isBackFlush;
    private List<String> msg_src;
    private String ids, uid, msg_id;
    //表情主界面
    private EmotionMainFragment emotionMainFragment;
    private boolean isMsg_id;
    private String receiver_uid;
    private SpringView springView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_notice_detail);
        getIntentData();
        initView();
        registerFinishActivity();
        registerReceiver();
    }


    /**
     * 初始化控件
     */
    private void initView() {
        mActivity = LogDetailActivity.this;
        String cat_name = getIntent().getStringExtra(Constance.TEAM_CAT_NAME);
        if (TextUtils.isEmpty(cat_name)) {
            cat_name = "日志";
        }
        SetTitleName.setTitle(findViewById(R.id.title), cat_name + "详情");
        ((TextView) findViewById(R.id.right_title)).setText(getString(R.string.more));
        findViewById(R.id.right_title).setVisibility(View.GONE);
        //初始化headview信息
        listView = findViewById(R.id.listview);
        headerView = getLayoutInflater().inflate(R.layout.layout_new_log_detail_head, null);
        img_head = headerView.findViewById(R.id.img_head);
        tv_name = headerView.findViewById(R.id.tv_name);
        head_listview = headerView.findViewById(R.id.head_listview);
        imageGridView = headerView.findViewById(R.id.ngl_images);
        tv_proName = headerView.findViewById(R.id.tv_proName);
        (headerView.findViewById(R.id.rea_read_info)).setOnClickListener(this);
        //初始化其它控件
        tv_unreceived = headerView.findViewById(R.id.tv_unreceived);
        listView.addHeaderView(headerView);
        //显示headview
        replyInfos = new ArrayList<>();

        adapter = new QuelityAndSafeDetailAdapter(mActivity, MessageType.MSG_LOG_STRING, replyInfos, this, new DialogDelReply.DelSuccessClickListener() {


            @Override
            public void delClickSuccess(int position) {
                replyInfos.remove(position);
                adapter.updateListView(replyInfos);

            }
        },gnInfo.is_closed);
        listView.setAdapter(adapter);
        tv_proName.setOnClickListener(this);
        img_head.setOnClickListener(this);
        tv_name.setOnClickListener(this);
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
                getlogInfo();
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
        if (null == logModeBean || TextUtils.isEmpty(logModeBean.getMsg_id())) {
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

//    public void initRightImageLog() {
//        ImageView imageView = (ImageView) findViewById(R.id.rightImage);
//        LinearLayout.LayoutParams params = (LinearLayout.LayoutParams) imageView.getLayoutParams();
//        params.width = ViewGroup.LayoutParams.WRAP_CONTENT;
//        params.height = ViewGroup.LayoutParams.WRAP_CONTENT;
//        imageView.setLayoutParams(params);
//        imageView.setImageResource(R.drawable.red_dots);
//        findViewById(R.id.rightLayout).setOnClickListener(this);
//    }

    /**
     * 启动当前Activity
     *
     * @param context
     */
    public static void actionStart(Activity context, GroupDiscussionInfo info, String msg_id, String cart_name, boolean isMsg) {
        Intent intent = new Intent(context, LogDetailActivity.class);
        intent.putExtra(Constance.BEAN_CONSTANCE, info);
        intent.putExtra(Constance.MSG_ID, msg_id);
        intent.putExtra(Constance.TEAM_CAT_NAME, cart_name);
        intent.putExtra(Constance.BEAN_BOOLEAN, isMsg);
        context.startActivityForResult(intent, Constance.REQUESTCODE_START);
    }

    /**
     * 启动当前Activity
     *
     * @param context
     */
    public static void actionStart(Activity context, GroupDiscussionInfo info, String msg_id, String bill_id, String cart_name, boolean isMsg) {
        Intent intent = new Intent(context, LogDetailActivity.class);
        intent.putExtra(Constance.BEAN_CONSTANCE, info);
        intent.putExtra(Constance.MSG_ID, msg_id);
        intent.putExtra(Constance.BILLID, bill_id);
        intent.putExtra(Constance.TEAM_CAT_NAME, cart_name);
        intent.putExtra(Constance.BEAN_BOOLEAN, isMsg);
        context.startActivityForResult(intent, Constance.REQUESTCODE_START);
    }

    private String group_id;

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
                    if (null == gnInfo) {
                        gnInfo = new GroupDiscussionInfo();
                    }
                    msg_id = bun.getString(key);
//                    gnInfo.setGroup_id(bun.getString(key));
                } else if (!TextUtils.isEmpty(key) && key.equals("group_id")) {
                    if (null == gnInfo) {
                        gnInfo = new GroupDiscussionInfo();
                    }
                    group_id = bun.getString(key);
                    gnInfo.setGroup_id(group_id);
                    isMsg_id = true;
                } else if (!TextUtils.isEmpty(key) && key.equals("class_type")) {
                    if (null == gnInfo) {
                        gnInfo = new GroupDiscussionInfo();
                    }
                    gnInfo.setClass_type(bun.getString(key));
                }
            }
        }
        if (TextUtils.isEmpty(group_id)) {//页面跳转进来的
            isMsg_id = getIntent().getBooleanExtra(Constance.BEAN_BOOLEAN, false);
            gnInfo = (GroupDiscussionInfo) getIntent().getSerializableExtra(Constance.BEAN_CONSTANCE);
            msg_id = getIntent().getStringExtra(Constance.MSG_ID);
            if (gnInfo.getIs_closed() == 1) {
                isClose = true;
            }
        }
    }


    //日志更多
    private DialogLogMore dialogLogMore;

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.rootView:
            case R.id.layout_notice_detail_head:
                if (isClose) {
                    return;
                }
                hideSoftKeyboard();
                break;
            case R.id.img_head:
            case R.id.tv_name:
                Intent intent = new Intent(mActivity, ChatUserInfoActivity.class);
                intent.putExtra(Constance.UID, uid);
                startActivityForResult(intent, Constance.REQUESTCODE_SINGLECHAT);
                break;


            case R.id.right_title:
                hideSoftKeyboard();
                if (dialogLogMore == null) {
                    String desc = "工作日志删除后不能恢复，\n" + "你确定要删除吗？";
                    dialogLogMore = new DialogLogMore(mActivity, desc, msg_id + "", "log", new DialogLogMore.UpdateLogInterFace() {
                        @Override
                        public void updateLog() {
                            LUtils.e("----------receiver_uid------------" + receiver_uid);
                            UpdateCustomLogActivity.actionStart(mActivity, gnInfo, msg_id, logModeBean.getElement_list(), msg_src, receiver_uid, logModeBean.getReceiver_list().getList());
                        }
                    });
                }

                dialogLogMore.setPu_inpsid(ids);
                gnInfo.setCat_id(logModeBean.getCat_id());
                gnInfo.setCat_name(logModeBean.getCat_name());
                gnInfo.setId(logModeBean.getId());
                dialogLogMore.setElement_list(logModeBean.getElement_list());
                if (msg_src == null) {
                    msg_src = new ArrayList<>();
                }
                dialogLogMore.setMsg_src(msg_src);
                dialogLogMore.setMsgData(null, gnInfo);
                dialogLogMore.showAtLocation(findViewById(R.id.rootView), Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0);//这种方式无论有虚拟按键还是没有都可完全显示，因为它显示的在整个父布局中
                BackGroundUtil.backgroundAlpha(mActivity, 0.5f);
                break;
            case R.id.tv_proName:
                if (isClose) {
                    return;
                }
                MessageUtil.setIndexList(mActivity, gnInfo, false, true);
                break;
            case R.id.rea_read_info:
                MessageReadInfoListActivity.actionStart(mActivity, gnInfo, logModeBean.getMsg_id() + "", false);
                break;

        }
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
        registerLocal(receiver, filter);
    }

    /**
     * 广播回调
     */
    class MessageBroadcast extends BroadcastReceiver {
        @Override
        public void onReceive(Context context, Intent intent) {
            if (intent.getAction().equals(WebSocketConstance.LOGDEL)) {
                findViewById(R.id.lin_message_def).setVisibility(View.VISIBLE);
                findViewById(R.id.lin_content).setVisibility(View.GONE);
                findViewById(R.id.right_title).setVisibility(View.GONE);
            }
        }
    }


    /**
     * 获取日志详情
     */
    protected void getlogInfo() {
        HttpUtils http = SingsHttpUtils.getHttp();
        RequestParams params = RequestParamsToken.getExpandRequestParams(mActivity);
        String bill_id = getIntent().getStringExtra(Constance.BILLID);
        if (!TextUtils.isEmpty(bill_id)) {
            params.addBodyParameter("bill_id", bill_id);
        } else {
            if (isMsg_id) {
                params.addBodyParameter("msg_id", msg_id);
            } else {
                params.addBodyParameter("id", msg_id);
            }
        }


        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.LOGINFO,
                params, new RequestCallBack<String>() {
                    @Override
                    public void onSuccess(ResponseInfo<String> responseInfo) {
                        try {
                            CommonJson<LogModeBean> bean = CommonJson.fromJson(responseInfo.result, LogModeBean.class);
                            if (bean.getState() != 0) {
                                headerView.setVisibility(View.VISIBLE);
                                img_head.setView(bean.getValues().getUser_info().getHead_pic(), bean.getValues().getUser_info().getReal_name(), 0);
                                logModeBean = bean.getValues();
                                tv_name.setText(bean.getValues().getUser_info().getReal_name());
                                ((TextView) findViewById(R.id.tv_date)).setText(bean.getValues().getCreate_time() + "\n" + bean.getValues().getWeek_day());
                                tv_proName.setText(Html.fromHtml("<font color='#999999'>来自：</font>" + bean.getValues().getFrom_group_name() + ""));
                                LogDetailHeadInfoAdapter adapter = new LogDetailHeadInfoAdapter(mActivity, bean.getValues().getElement_list());
                                head_listview.setAdapter(adapter);
                                msg_src = bean.getValues().getMsg_src();
                                uid = bean.getValues().getUser_info().getUid();
                                if (null != bean.getValues().getReceiver_list()) {
                                    receiver_uid = bean.getValues().getReceiver_list().getReceiver_uid();
                                }
                                //设置图片显示
                                if (msg_src != null && msg_src.size() > 0) {
                                    imageGridView.setVisibility(View.VISIBLE);
                                    imageGridView.setAdapter(new NineGridImageViewAdapter<String>() {
                                        @Override
                                        public void onDisplayImage(Context context, ImageView imageView, String s) {
                                            if (!s.contains("/storage/")) {
                                                new GlideUtils().glideImage(context, NetWorkRequest.IP_ADDRESS + s, imageView, R.drawable.icon_message_fail_default, R.drawable.icon_message_fail_default);
                                            } else {
                                                new GlideUtils().glideImage(context, "file://" + s, imageView, R.drawable.icon_message_fail_default, R.drawable.icon_message_fail_default);
                                            }
                                        }

                                        @Override
                                        public void onItemImageClick(Context context, int index, List<String> list, ImageView imageView) {
                                            //imagesize是作为loading时的图片size
                                            MessageImagePagerActivity.ImageSize imageSize = new MessageImagePagerActivity.ImageSize(imageView.getMeasuredWidth(), imageView.getMeasuredHeight());
                                            MessageImagePagerActivity.startImagePagerActivity(LogDetailActivity.this, list, index, imageSize);
                                        }
                                    });
                                    imageGridView.setImagesData(bean.getValues().getMsg_src());
                                } else {
                                    imageGridView.setVisibility(View.GONE);
                                }
                                //设置更多按钮
                                if (bean.getValues().getUser_info().getUid().equals(UclientApplication.getUid(mActivity)) && !isClose) {
                                    findViewById(R.id.right_title).setVisibility(View.VISIBLE);
                                    ids = bean.getValues().getId() + "";
                                    LUtils.e("--right_title-----1111---------");
                                } else {
                                    LUtils.e("---right_title----2222---------");
                                    findViewById(R.id.right_title).setVisibility(View.GONE);

                                }
                                SetTitleName.setTitle(findViewById(R.id.title), bean.getValues().getCat_name() + "详情");
                                findViewById(R.id.lin_message_def).setVisibility(View.GONE);
                                getlogReplyListAndsRreceiveHandle(NetWorkRequest.LOGREPLYLIST);
                            } else {
                                if (bean.getErrno().equals("800107")) { //日志信息删除
                                    listView.setVisibility(View.GONE);
                                    findViewById(R.id.lin_message_def).setVisibility(View.VISIBLE);
                                    findViewById(R.id.right_title).setVisibility(View.GONE);
                                    findViewById(R.id.fl_emotionview_main).setVisibility(View.GONE);
                                    return;
                                }
                                DataUtil.showErrOrMsg(mActivity, bean.getErrno(), bean.getErrmsg());
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
     * 日志回复列表以及收到功能
     */
    protected void getlogReplyListAndsRreceiveHandle(String interfaceStr) {
        HttpUtils http = SingsHttpUtils.getHttp();
        RequestParams params = RequestParamsToken.getExpandRequestParams(mActivity);
        String bill_id = getIntent().getStringExtra(Constance.BILLID);
        if (!TextUtils.isEmpty(bill_id) && interfaceStr.equals(NetWorkRequest.LOGREPLYLIST)) {
            params.addBodyParameter("bill_id", bill_id);
        } else {
            if (isMsg_id) {
                params.addBodyParameter("msg_id", msg_id);
            } else {
                params.addBodyParameter("id", msg_id);
            }
        }

        http.send(HttpRequest.HttpMethod.POST, interfaceStr,
                params, new RequestCallBack<String>() {
                    @Override
                    public void onSuccess(ResponseInfo<String> responseInfo) {
                        try {
                            CommonJson<ReplyInfo> bean = CommonJson.fromJson(responseInfo.result, ReplyInfo.class);
                            if (bean.getState() != 0) {
                                ((TextView) findViewById(R.id.tv_readinfo)).setText("(" + bean.getValues().getReaded_percent() + "人)");
                                readInfo = bean.getValues();
                                setReadHeadAndUnRead();
                            } else {
                                DataUtil.showErrOrMsg(mActivity, bean.getErrno(), bean.getErrmsg());
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                            CommonMethod.makeNoticeShort(mActivity, getString(R.string.service_err), CommonMethod.ERROR);
                            finish();
                        } finally {
                        }
                    }

                    /** xutils 连接失败 调用的 方法 */
                    @Override
                    public void onFailure(HttpException exception, String errormsg) {
                        finish();
                        closeDialog();
                    }
                });
    }


    /**
     * 设置收到已收到以及回复列表数据
     */
    private void setReadHeadAndUnRead() {

        if (null != readInfo.getReplyList() && readInfo.getReplyList().size() > 0) {
            replyInfos = readInfo.getReplyList();
            adapter.updateListView(replyInfos);
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == Constance.REQUESTCODE_START && resultCode == Constance.RESULTCODE_FINISH) {
            //修改了日志回来重新获取日志数据
            isBackFlush = true;
            getlogInfo();
            getlogReplyListAndsRreceiveHandle(NetWorkRequest.LOGREPLYLIST);
        } else if (resultCode == Constance.CLICK_SINGLECHAT) {
            setResult(Constance.CLICK_SINGLECHAT, data);
            finish();
        } else if (resultCode == Constance.CLICK_SINGLECHAT) {
            setResult(Constance.CLICK_SINGLECHAT, data);
            finish();
        } else if (requestCode == CameraPop.REQUEST_IMAGE && resultCode == RESULT_OK) {//选择相册回调
            ArrayList<String> mSelected = data.getStringArrayListExtra(MultiImageSelectorActivity.EXTRA_RESULT);
//            taskStatusChange(null, mSelected);
            fileUpData(mSelected);
        }
    }

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
                if (null != list && list.size() > 0) {
                    RequestParamsToken.compressImageAndUpLoad(params, list, mActivity);
                }
                String bill_id = getIntent().getStringExtra(Constance.BILLID);

                if (!TextUtils.isEmpty(bill_id) && null != logModeBean) {
                    params.addBodyParameter("msg_id", logModeBean.getMsg_id());
                } else {
                    if (isMsg_id) {
                        params.addBodyParameter("msg_id", msg_id);
                    } else {
                        params.addBodyParameter("id", msg_id);
                    }
                }
                if (!TextUtils.isEmpty(emotionMainFragment.getBar_edit_text().getText().toString().trim())) {
                    params.addBodyParameter("reply_text", emotionMainFragment.getBar_edit_text().getText().toString().trim());
                }
                if (!TextUtils.isEmpty(reply_uid)) {
                    //2.3.2增加回复单个人功
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
                    setLogReplyMessage();
                    break;
            }

        }
    };

    /**
     * 日志回复
     */
    protected void setLogReplyMessage() {
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.LOG_REPLY_MESSAGE,
                params, new RequestCallBack<String>() {
                    @Override
                    public void onSuccess(ResponseInfo<String> responseInfo) {
                        try {
                            CommonJson<ReplyInfo> bean = CommonJson.fromJson(responseInfo.result, ReplyInfo.class);
                            if (bean.getState() != 0) {
                                //消息回复
//                                    replyInfos = bean.getValues().getList();
//                                    adapter.updateListView(replyInfos);
//                                    listView.setSelection(replyInfos.size());
                                saveAndClearLocalInfo(false);
                                emotionMainFragment.getBar_edit_text().setText("");
                                reply_uid = "";
                                if (null != emotionMainFragment) {
                                    emotionMainFragment.isInterceptBackPress();
                                }

                                getlogReplyListAndsRreceiveHandle(NetWorkRequest.LOGREPLYLIST);
//                                    if (lin_received_al.getVisibility() != View.VISIBLE) {
//                                        getlogReplyListAndsRreceiveHandle(NetWorkRequest.RECEIVE_HANDLE);
//                                    }
                                hideSoftKeyboard();
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

    @Override
    public void onBackPressed() {
        if (null != emotionMainFragment && !emotionMainFragment.isInterceptBackPress()) {
            saveAndClearLocalInfo(true);
            if (isBackFlush) {
                setResult(Constance.RESULTCODE_FINISH, getIntent());
            }
            mActivity.finish();
        } else {
            mActivity.finish();

        }
    }

    @Override
    public void onFinish(View view) {
        if (null != emotionMainFragment && !emotionMainFragment.isInterceptBackPress()) {
            saveAndClearLocalInfo(true);
            if (isBackFlush) {
                setResult(Constance.RESULTCODE_FINISH, getIntent());
            }
            super.onFinish(view);
        } else {
            super.onFinish(view);
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
            String msg_type = MessageType.MSG_LOG_STRING;
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
            String group_id = gnInfo.getGroup_id();
            String class_type = gnInfo.getClass_type();
            String msg_type = MessageType.MSG_LOG_STRING;
            LocalInfoBean logModeBean = new LocalInfoBean(Integer.parseInt(msg_id), class_type, msg_type, group_id, "", LocalInfoBean.TYPE_REPLY);
            String content = MessageUtils.selectLocalInfoNotice(logModeBean);
            emotionMainFragment.getBar_edit_text().setText(content);
        } catch (Exception e) {

        }

    }
}
