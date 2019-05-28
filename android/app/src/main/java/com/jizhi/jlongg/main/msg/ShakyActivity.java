package com.jizhi.jlongg.main.msg;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.widget.SwipeRefreshLayout;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.text.TextUtils;
import android.view.View;
import android.widget.TextView;

import com.hcs.uclient.utils.LUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;
import com.jizhi.jlongg.main.bean.MessageBean;
import com.jizhi.jlongg.main.message.MessageUtils;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.MessageUtil;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.lidroid.xutils.exception.HttpException;

import org.litepal.LitePal;

import java.util.ArrayList;
import java.util.List;

/**
 * CName:3.4.0活动消息
 * User: hcs
 * Date: 2018-9-18
 * Time: 10:13
 */
public class ShakyActivity extends BaseActivity implements SwipeRefreshLayout.OnRefreshListener {
    private ShakyActivity mActivity;
    private GroupDiscussionInfo gnInfo;
    /*刷新控件*/
    protected SwipeRefreshLayout mSwipeLayout;
    /*消息RecyclerView*/
    protected RecyclerView lv_msg;
    /*消息适配器*/
    private ShakyMessageAdapter shakyMessageAdapter;
    /*消息集合*/
    private List<MessageBean> beanList;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_shaky);
        getIntentData();
        initView();
        autoRefresh();
    }

    /**
     * 启动Activity
     *
     * @param context
     * @param info
     */
    public static void actionStart(Activity context, GroupDiscussionInfo info) {
        Intent intent = new Intent(context, ShakyActivity.class);
        intent.putExtra(Constance.BEAN_CONSTANCE, info);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    /**
     * 获取传递过来的数据
     */
    protected void getIntentData() {
        gnInfo = (GroupDiscussionInfo) getIntent().getSerializableExtra(Constance.BEAN_CONSTANCE);
        if (null == gnInfo) {
            CommonMethod.makeNoticeShort(this, "数据出错", CommonMethod.SUCCESS);
            finish();
        }
    }

    /**
     * 初始化view
     */
    public void initView() {
        mActivity = ShakyActivity.this;
        setTextTitle(R.string.activity_message);
        lv_msg = findViewById(R.id.listView);
        beanList = new ArrayList<>();
        ((TextView) findViewById(R.id.tv_top)).setText("暂无记录哦~");
        shakyMessageAdapter = new ShakyMessageAdapter(mActivity, beanList);
        lv_msg.setAdapter(shakyMessageAdapter);
        LinearLayoutManager linearLayoutManager = new LinearLayoutManager(mActivity, LinearLayoutManager.VERTICAL, false);
        lv_msg.setLayoutManager(linearLayoutManager);
        mSwipeLayout = findViewById(R.id.swipe_layout);
        mSwipeLayout.setColorSchemeColors(getResources().getColor(R.color.color_eb4e4e), getResources().getColor(R.color.blue_46a6ff));
        mSwipeLayout.setOnRefreshListener(this);
    }

    /**
     * 自动下拉刷新
     */
    public void autoRefresh() {
        mSwipeLayout.post(new Runnable() {
            @Override
            public void run() {
                mSwipeLayout.setRefreshing(true);
                onRefresh();
            }
        });
    }

    @Override
    public void onRefresh() {
        getOnlineHistoryMessage();
    }

    /**
     * 获取线上历史消息
     */
    public void getOnlineHistoryMessage() {
        MessageUtil.getRoamMessageList(this, MessageType.ACTIVITY_MESSAGE_ID, MessageType.ACTIVITY_MESSAGE_TYPE,
                beanList.size() == 0 ? "0" : String.valueOf(beanList.get(0).getMsg_id()), new CommonHttpRequest.CommonRequestCallBack() {
                    @Override
                    public void onSuccess(Object object) {
                        //接收消息
                        List<MessageBean> list = (List<MessageBean>) object;
                        mSwipeLayout.setRefreshing(false);
                        if (null != list && list.size() > 0) {
                            List<MessageBean> tempBean = new ArrayList<>();
                            for (MessageBean bean : list) {
                                //如果本地没有当条消息就保存
                                boolean isExist = LitePal.isExist(MessageBean.class, "message_uid = ? and msg_id = ?", UclientApplication.getUid(), String.valueOf(bean.getMsg_id()));
                                LUtils.e(isExist + "------------" + bean.getMsg_id());

                                if (!isExist) {
                                    bean.setMessage_uid(UclientApplication.getUid());
                                    boolean isSave = bean.save();
                                    LUtils.e(isSave + "-------isSave-----" + bean.getMsg_id());
                                }
                                //屏蔽无角色和帖子送积分消息
                                if (TextUtils.isEmpty(bean.getRole_type())) {
                                    continue;
                                }
                                if (bean.getRole_type().equals(UclientApplication.getRoler(mActivity)) || bean.getRole_type().equals("0")) {
                                    tempBean.add(bean);
                                }
                            }
                            beanList.addAll(0, tempBean);
                            shakyMessageAdapter.notifyDataSetChanged();
                            if (beanList.size() == tempBean.size() && beanList.size() > 0) {
                                lv_msg.scrollToPosition(shakyMessageAdapter.getItemCount() - 1);
                                MessageBean messageBean = beanList.get(beanList.size() - 1);
                                //更新聊聊列表最新的一条消息,包含消息发送的内容,是否有人@我,发送人名称，发送者id
                                MessageUtil.setLastMessageInfo(ShakyActivity.this,
                                        messageBean.getGroup_id(), messageBean.getClass_type(),
                                        "0",
                                        MessageUtils.getMsg_Text(messageBean),
                                        messageBean.getSend_time(),
                                        TextUtils.isEmpty(messageBean.getTitle()) ? "" : messageBean.getTitle(),
                                        messageBean.getMsg_id() + "", messageBean.getUser_info() == null ? null : messageBean.getUser_info().getReal_name(), null);
//                                MessageUtil.modityLocalTeamGroupInfo(mActivity, null, null, null,
//                                        messageBean.getGroup_id(), messageBean.getClass_type(),
//                                        null, //重新获取了一下消息的未读数
//                                        MessageUtils.getMsg_Text(messageBean), null, null,
//                                        messageBean.getSend_time(), null, messageBean.getUser_info() == null ? null : messageBean.getUser_info().getReal_name(),
//                                        messageBean.getMsg_sender(), messageBean.getTitle());
                            } else {
                                lv_msg.scrollToPosition(shakyMessageAdapter.getItemCount() - tempBean.size() - 1);
                            }
                        }
                        findViewById(R.id.layout_default).setVisibility(beanList.size() == 0 ? View.VISIBLE : View.GONE);
                        lv_msg.setVisibility(beanList.size() == 0 ? View.GONE : View.VISIBLE);
                    }

                    @Override
                    public void onFailure(HttpException exception, String errormsg) {
                        if (mSwipeLayout.isRefreshing()) {
                            mSwipeLayout.setRefreshing(false);
                        }
                    }
                });
    }
}
