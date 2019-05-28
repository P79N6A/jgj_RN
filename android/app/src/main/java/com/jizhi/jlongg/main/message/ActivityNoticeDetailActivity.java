package com.jizhi.jlongg.main.message;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.graphics.Rect;
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
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.emoji.emotionkeyboard.BarClickLintener;
import com.jizhi.jlongg.emoji.emotionkeyboard.EmotionKeyboard;
import com.jizhi.jlongg.emoji.fragment.EmotionMainFragment;
import com.jizhi.jlongg.groupimageviews.NineGridImageViewAdapter;
import com.jizhi.jlongg.groupimageviews.NineGridMsgImageView;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.activity.ChatUserInfoActivity;
import com.jizhi.jlongg.main.adpter.QuelityAndSafeDetailAdapter;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;
import com.jizhi.jlongg.main.bean.LocalInfoBean;
import com.jizhi.jlongg.main.bean.MessageEntity;
import com.jizhi.jlongg.main.bean.ReplyInfo;
import com.jizhi.jlongg.main.bean.status.CommonJson;
import com.jizhi.jlongg.main.dialog.DialogDelReply;
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


/**
 * 通知质量详情
 *
 * @author huChangSheng
 * @version 1.0
 * @time 2016-11-25 下午2:41:57
 */

public class ActivityNoticeDetailActivity extends BaseActivity implements View.OnClickListener, QuelityAndSafeDetailAdapter.ReplyContentClickListener, BarClickLintener, EmotionKeyboard.ClickKeyBoardClickListner {
    private ActivityNoticeDetailActivity mActivity;
    //列表数据
    private ListView listView;
    //头像
    private RoundeImageHashCodeTextLayout img_head;
    //    头部数据
    private MessageEntity msgEntity;
    //日期
    private TextView tv_date;
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
    private QuelityAndSafeDetailAdapter adapter;
    private View headerView;
    //是否已经关闭
    private boolean isClose;
    private String msg_type;
    private boolean isFlush;
    private GroupDiscussionInfo gnInfo;
    //表情主界面
    private EmotionMainFragment emotionMainFragment;
    private int msg_id;
    private android.support.v4.app.FragmentManager frg_mng = getSupportFragmentManager(); //全局变量
    private SpringView springView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_notice_detail);
        mActivity = ActivityNoticeDetailActivity.this;
        registerFinishActivity();
        getIntentData();
        initView();
        findViewById(R.id.rootView).setOnClickListener(this);
        headerView.setOnClickListener(this);
        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                hideSoftKeyboard();
            }
        });
        if (isClose) {
        }
    }

    private boolean isPush;

    public void getIntentData() {
        Bundle bun = getIntent().getExtras();
        if (bun != null) {
            //推送跳转进来的
            Set<String> keySet = bun.keySet();
            for (String key : keySet) {
                if (!TextUtils.isEmpty(key) && key.equals("msg_id")) {
                    isPush = true;
                    if (!TextUtils.isEmpty(bun.getString(key))) {
                        msg_id = Integer.parseInt(bun.getString(key));
                    }
                } else if (!TextUtils.isEmpty(key) && key.equals("group_id")) {
                    isPush = true;
                    if (null == gnInfo) {
                        gnInfo = new GroupDiscussionInfo();
                    }
                    gnInfo.setGroup_id(bun.getString(key));
                } else if (!TextUtils.isEmpty(key) && key.equals("class_type")) {
                    isPush = true;
                    if (null == gnInfo) {
                        gnInfo = new GroupDiscussionInfo();
                    }
                    gnInfo.setClass_type(bun.getString(key));
                } else if (!TextUtils.isEmpty(key) && key.equals("msg_type")) {
                    isPush = true;
                    if (null == gnInfo) {
                        gnInfo = new GroupDiscussionInfo();
                    }
                }
            }
        }

        if (!isPush || msg_id == 0) {//页面跳转进来的
            gnInfo = (GroupDiscussionInfo) getIntent().getSerializableExtra(Constance.BEAN_CONSTANCE);
            isClose = getIntent().getBooleanExtra(Constance.BEAN_BOOLEAN, false);
            msg_id = getIntent().getIntExtra(Constance.MSG_ID, 0);
        }
    }

    /**
     * 启动当前Acitivyt
     *
     * @param context
     */
    public static void actionStart(Activity context, GroupDiscussionInfo info, int msg_id) {
        Intent intent = new Intent(context, ActivityNoticeDetailActivity.class);
        intent.putExtra(Constance.BEAN_CONSTANCE, info);
        intent.putExtra(Constance.MSG_ID, msg_id);
        intent.putExtra(Constance.BEAN_BOOLEAN, info.getIs_closed() == 1);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    /**
     * 启动当前Acitivyt
     *
     * @param context
     */
    public static void actionStart(Activity context, GroupDiscussionInfo info, int msg_id, String bill_id) {
        Intent intent = new Intent(context, ActivityNoticeDetailActivity.class);
        intent.putExtra(Constance.BEAN_CONSTANCE, info);
        intent.putExtra(Constance.MSG_ID, msg_id);
        intent.putExtra(Constance.BILLID, bill_id);
        intent.putExtra(Constance.BEAN_BOOLEAN, info.getIs_closed() == 1);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    /**
     * 初始化View
     */
    public void initView() {
        headerView = getLayoutInflater().inflate(R.layout.layout_log_detail_head, null);
        //设置默认提示信息
        SetTitleName.setTitle(findViewById(R.id.title), getString(R.string.messsage_work_inform) + "详情");
        SetTitleName.setTitle(findViewById(R.id.tv_title), getString(R.string.messsage_work_inform));
        msg_type = MessageType.MSG_NOTICE_STRING;
        //初始化headview信息
        listView = findViewById(R.id.listview);
        img_head = headerView.findViewById(R.id.img_head);
        tv_date = headerView.findViewById(R.id.tv_date);
        tv_content = headerView.findViewById(R.id.tv_content);
        tv_proName = headerView.findViewById(R.id.tv_proName);
        tv_name = headerView.findViewById(R.id.tv_name);
        (headerView.findViewById(R.id.rea_read_info)).setOnClickListener(this);
        imageGridView = headerView.findViewById(R.id.ngl_images);
        listView.addHeaderView(headerView);

        //显示headview
        replyInfos = new ArrayList<>();
        adapter = new QuelityAndSafeDetailAdapter(mActivity, msg_type, replyInfos, this, new DialogDelReply.DelSuccessClickListener() {


            @Override
            public void delClickSuccess(int position) {
                replyInfos.remove(position);
                adapter.updateListView(replyInfos);

            }
        },gnInfo.is_closed);
        listView.setAdapter(adapter);
        //初始化其它控件
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
        FragmentTransaction transaction = frg_mng.beginTransaction();
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
        rea_noticedetail = findViewById(R.id.rootView);
        //contentlayout是最外层布局
        mChildOfContent = rea_noticedetail.getChildAt(0);
        mChildOfContent.getViewTreeObserver().addOnGlobalLayoutListener(new ViewTreeObserver.OnGlobalLayoutListener() {
            public void onGlobalLayout() {
                possiblyResizeChildOfContent();
            }
        });
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
        if (gnInfo.is_closed == 1) {
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
        img_head.setView(msgEntity.getUser_info().getHead_pic(), msgEntity.getUser_info().getReal_name(), 0);
        tv_name.setText(msgEntity.getUser_info().getReal_name());
        tv_proName.setText(Html.fromHtml("<font color='#999999'>来自：</font>" + msgEntity.getFrom_group_name() + ""));
        tv_date.setText(msgEntity.getSend_time());
        if (!TextUtils.isEmpty(msgEntity.getMsg_text())) {
            tv_content.setText(msgEntity.getMsg_text());
            tv_content.setVisibility(View.VISIBLE);
        } else {
            tv_content.setVisibility(View.GONE);
        }
        DataUtil.setHtmlClick(tv_content, mActivity);
        tv_name.setTextColor(getResources().getColor(R.color.color_628ae0));
        findViewById(R.id.img_head).setOnClickListener(this);
        findViewById(R.id.tv_name).setOnClickListener(this);
        if (msgEntity.getMsg_src() != null && msgEntity.getMsg_src().size() > 0) {
            imageGridView.setVisibility(View.VISIBLE);
            imageGridView.setAdapter(new NineGridImageViewAdapter<String>() {
                @Override
                public void onDisplayImage(Context context, ImageView imageView, String s) {
                    if (!s.contains("/storage/")) {
                        new GlideUtils().glideImage(context, NetWorkRequest.IP_ADDRESS + s, imageView, R.drawable.icon_message_fail_default, R.drawable.icon_message_fail_default);

//                        Glide.with(context).load(NetWorkRequest.IP_ADDRESS + s).placeholder(R.drawable.icon_message_fail_default).error(R.drawable.icon_message_fail_default).into(imageView);
                    } else {
                        new GlideUtils().glideImage(context, "file://" + s, imageView, R.drawable.icon_message_fail_default, R.drawable.icon_message_fail_default);

//                        Glide.with(context).load("file://" + s).placeholder(R.drawable.icon_message_fail_default).error(R.drawable.icon_message_fail_default).into(imageView);
                    }
                }


                @Override
                public void onItemImageClick(Context context, int index, List<String> list, ImageView imageView) {
                    //imagesize是作为loading时的图片size
                    MessageImagePagerActivity.ImageSize imageSize = new MessageImagePagerActivity.ImageSize(imageView.getMeasuredWidth(), imageView.getMeasuredHeight());
                    MessageImagePagerActivity.startImagePagerActivity(ActivityNoticeDetailActivity.this, list, index, imageSize);
                }
            });
            imageGridView.setImagesData(msgEntity.getMsg_src());
        } else {
            imageGridView.setVisibility(View.GONE);
        }
    }

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
                Intent intent = new Intent(ActivityNoticeDetailActivity.this, ChatUserInfoActivity.class);
                intent.putExtra(Constance.UID, msgEntity.getUser_info().getUid());
                startActivityForResult(intent, Constance.REQUESTCODE_SINGLECHAT);
                break;
            case R.id.tv_proName:
                if (isClose) {
                    return;
                }
                MessageUtil.setIndexList(mActivity, gnInfo, false, true);
                break;
            case R.id.rea_read_info:
                MessageReadInfoListActivity.actionStart(mActivity, gnInfo, msg_id + "", false);
                break;
        }
    }


    //隐藏键盘

    private void toggleInput(Context context) {
        InputMethodManager inputMethodManager =
                (InputMethodManager) context.getSystemService(Context.INPUT_METHOD_SERVICE);
        inputMethodManager.toggleSoftInput(0, InputMethodManager.HIDE_NOT_ALWAYS);
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
                params.addBodyParameter("reply_type", MessageType.MSG_NOTICE_STRING);
                if (null != list && list.size() > 0) {
                    RequestParamsToken.compressImageAndUpLoad(params, list, mActivity);
                }
                params.addBodyParameter("msg_id", String.valueOf(msg_id));
                if (!TextUtils.isEmpty(gnInfo.getGroup_id())) {
                    params.addBodyParameter("group_id", gnInfo.getGroup_id());
                }
                if (!TextUtils.isEmpty(gnInfo.getClass_type())) {
                    params.addBodyParameter("class_type", gnInfo.getClass_type());
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
                                listView.setSelection(bean.getValues().getList().size());
                                emotionMainFragment.getBar_edit_text().setText("");
                                reply_uid = "";
                                if (null != emotionMainFragment) {
                                    emotionMainFragment.isInterceptBackPress();
                                }

                                toggleInput(mActivity);
                                setReadHeadAndUnRead();
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
                    }
                });
    }


    /**
     * 获取安全质量详情
     */
    protected void getReplyMessageList() {
        HttpUtils http = SingsHttpUtils.getHttp();
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        String bill_id = getIntent().getStringExtra(Constance.BILLID);
        if (!TextUtils.isEmpty(bill_id)) {
            params.addBodyParameter("bill_id", bill_id);
            params.addBodyParameter("type", MessageType.MSG_NOTICE_STRING);
        } else {
            params.addBodyParameter("msg_id", msg_id + "");
        }
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.GET_RPLYMESSAGRLIST,
                params, new RequestCallBack<String>() {
                    @Override
                    public void onSuccess(ResponseInfo<String> responseInfo) {
                        try {
                            CommonJson<ReplyInfo> bean = CommonJson.fromJson(responseInfo.result, ReplyInfo.class);
                            if (bean.getState() != 0) {
                                ((TextView) findViewById(R.id.tv_readinfo)).setText("(" + bean.getValues().getReaded_percent() + "人)");
                                replyInfos = bean.getValues().getList();
                                setReadHeadAndUnRead();
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
                    }
                });
    }


    /**
     * 设置收到已收到以及回复列表数据
     */

    private void setReadHeadAndUnRead() {
        //刷新回复列表数据
        if (null != replyInfos && replyInfos.size() > 0) {
            adapter.updateListView(replyInfos);
            listView.setSelection(0);
        }
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
        } else if (requestCode == Constance.REQUESTCODE_START && resultCode == Constance.RESULTCODE_FINISH) {
            msgEntity = (MessageEntity) data.getSerializableExtra("msgEntity");
            isFlush = true;
            setHeadData();
        } else if (resultCode == Constance.CLICK_SINGLECHAT) {
            setResult(Constance.CLICK_SINGLECHAT, data);
            finish();
        } else if (requestCode == CameraPop.REQUEST_IMAGE && resultCode == RESULT_OK) {//选择相册回调
            ArrayList<String> mSelected = data.getStringArrayListExtra(MultiImageSelectorActivity.EXTRA_RESULT);
            fileUpData(mSelected);
        }
    }

    @Override
    public void onBackPressed() {
        /**
         * 判断是否拦截返回键操作
         */
        if (null == emotionMainFragment) {
            mActivity.finish();
            return;
        }
        if (!emotionMainFragment.isInterceptBackPress()) {
            saveAndClearLocalInfo(true);
            if (isFlush) {
                setResult(Constance.RESULTCODE_FINISH, getIntent());
            }
            FragmentTransaction ft_a = frg_mng.beginTransaction();
            ft_a.remove(emotionMainFragment).commit();
            mActivity.finish();
        }
    }

    @Override
    public void onFinish(View view) {
        /**
         * 判断是否拦截返回键操作
         */
        if (null == emotionMainFragment) {
            mActivity.finish();
            return;
        }
        if (!emotionMainFragment.isInterceptBackPress()) {
            saveAndClearLocalInfo(true);
            if (isFlush) {
                setResult(Constance.RESULTCODE_FINISH, getIntent());
            }
            FragmentTransaction ft_a = frg_mng.beginTransaction();
            ft_a.remove(emotionMainFragment).commit();
            super.onFinish(view);
        }

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
            LocalInfoBean logModeBean = new LocalInfoBean(msg_id, class_type, msg_type, group_id, "", LocalInfoBean.TYPE_REPLY);
            String content = MessageUtils.selectLocalInfoNotice(logModeBean);
            emotionMainFragment.getBar_edit_text().setText(content);
        } catch (Exception e) {

        }
    }

    /**
     * 获取安全质量详情
     */
    protected void getDetail() {
        HttpUtils http = SingsHttpUtils.getHttp();
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        String bill_id = getIntent().getStringExtra(Constance.BILLID);
        if (!TextUtils.isEmpty(bill_id)) {
            params.addBodyParameter("bill_id", bill_id);
        } else {
            params.addBodyParameter("id", msg_id + "");
        }
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.GET_NOTICE_INFO,
                params, new RequestCallBack<String>() {
                    @Override
                    public void onSuccess(ResponseInfo<String> responseInfo) {
                        try {
                            CommonJson<MessageEntity> bean = CommonJson.fromJson(responseInfo.result, MessageEntity.class);
                            if (bean.getState() != 0) {
                                msgEntity = bean.getValues();
                                msg_id = msgEntity.getMsg_id();
                                setHeadData();
                                getReplyMessageList();
                            } else {
                                if (bean.getErrno().equals("820020")) {
                                    findViewById(R.id.lin_message_def).setVisibility(View.VISIBLE);
                                    findViewById(R.id.lin_content).setVisibility(View.GONE);
//                                    findViewById(R.id.rightLayout).setVisibility(View.GONE);
                                    return;
                                }
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
                        finish();
                        springView.onFinishFreshAndLoad();
                    }
                });
    }


    @Override
    protected void onDestroy() {
        unregisterFinishActivity();
        super.onDestroy();
    }
}



