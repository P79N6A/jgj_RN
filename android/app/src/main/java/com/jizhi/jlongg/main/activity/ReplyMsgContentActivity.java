package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.widget.SwipeRefreshLayout;
import android.view.View;
import android.widget.AbsListView;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.TextView;

import com.hcs.uclient.utils.LUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.log.LogDetailActivity;
import com.jizhi.jlongg.main.activity.task.TaskDetailActivity;
import com.jizhi.jlongg.main.adpter.ReplyMsgContentAdapter;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;
import com.jizhi.jlongg.main.bean.MessageBean;
import com.jizhi.jlongg.main.bean.ReplyInfo;
import com.jizhi.jlongg.main.bean.status.CommonJson;
import com.jizhi.jlongg.main.bean.status.CommonListJson;
import com.jizhi.jlongg.main.dialog.DialogTips;
import com.jizhi.jlongg.main.listener.DiaLogTitleListener;
import com.jizhi.jlongg.main.message.ActivityNoticeDetailActivity;
import com.jizhi.jlongg.main.message.ActivityQualityAndSafeDetailActivity;
import com.jizhi.jlongg.main.msg.MessageType;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DataUtil;
import com.jizhi.jlongg.main.util.MessageUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SetColor;
import com.jizhi.jlongg.main.util.SetTitleName;
import com.jizhi.jlongg.main.util.SingsHttpUtils;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.callback.RequestCallBack;
import com.lidroid.xutils.http.client.HttpRequest;

import java.util.ArrayList;
import java.util.List;

/**
 * 功能: 消息回复列表
 * 作者：huchangsheng
 * 时间: 2017-11-21 11:33
 */

public class ReplyMsgContentActivity extends BaseActivity implements AbsListView.OnScrollListener, SwipeRefreshLayout.OnRefreshListener {
    private ReplyMsgContentActivity mActivity;
    private ListView listView;
    private ReplyMsgContentAdapter adapter;
    private List<ReplyInfo> list;
    private GroupDiscussionInfo gnInfo;
    /* 是否还有更多的数据 */
    private boolean isHaveMoreData = true;
    /* 加载更多 */
    private View loadMoreView;
    private int pg = 1;
    // 下拉刷新
    private SwipeRefreshLayout mSwipeLayout;
    private boolean isFulsh;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_reply_msg_contentl);
        getIntentData();
        initView();
        autoRefresh();
    }


    /**
     * 初始化view
     */
    private void initView() {
        mActivity = ReplyMsgContentActivity.this;
        listView = findViewById(R.id.listView);
        listView.setOnItemClickListener(itemClickListener);
        SetTitleName.setTitle(findViewById(R.id.title), "工作回复");
        ((TextView) findViewById(R.id.right_title)).setText("清空");
        findViewById(R.id.right_title).setVisibility(View.GONE);
        findViewById(R.id.right_title).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (null == list || list.size() == 0) {
                    return;
                }
                DialogTips dialogTips = new DialogTips(mActivity, new DiaLogTitleListener() {
                    @Override
                    public void clickAccess(int position) {
                        cleanReplyMessage();
                    }
                }, "确定要清空工作回复列表吗？", -1);
                dialogTips.setContentCenterGravity();
                dialogTips.show();


            }
        });

        // listView 底部加载对话框
        loadMoreView = loadMoreDataView();
        loadMoreView.setVisibility(View.GONE);
        listView.addFooterView(loadMoreView, null, false);
        listView.setOnScrollListener(this);
        mSwipeLayout = (SwipeRefreshLayout) findViewById(R.id.swipe_layout);
        mSwipeLayout.setOnRefreshListener(mActivity);
        new SetColor(mSwipeLayout);
    }

    /**
     * 获取传递过来的数据
     */
    private void getIntentData() {
        gnInfo = (GroupDiscussionInfo) getIntent().getSerializableExtra(Constance.BEAN_CONSTANCE);
    }

    /**
     * 启动当前Acitivyt
     *
     * @param context
     */
    public static void actionStart(Activity context, GroupDiscussionInfo gnInfo, String msgType) {
        Intent intent = new Intent(context, ReplyMsgContentActivity.class);
        intent.putExtra(Constance.BEAN_CONSTANCE, gnInfo);
        intent.putExtra(Constance.MSG_TYPE, msgType);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    AdapterView.OnItemClickListener itemClickListener = new AdapterView.OnItemClickListener() {
        @Override
        public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
            if (list.get(position).getReply_type().equals(MessageType.MSG_QUALITY_STRING) || list.get(position).getReply_type().equals(MessageType.MSG_SAFE_STRING)) {
                MessageBean messageEntity = new MessageBean();
                messageEntity.setMsg_id(Integer.parseInt(list.get(position).getMsg_id()));
                messageEntity.setClass_type(gnInfo.getClass_type());
                messageEntity.setMsg_type(list.get(position).getReply_type());
                messageEntity.setGroup_id(gnInfo.getGroup_id());
                ActivityQualityAndSafeDetailActivity.actionStart(mActivity, messageEntity, gnInfo);
            } else if (list.get(position).getReply_type().equals(MessageType.MSG_NOTICE_STRING)) {
                ActivityNoticeDetailActivity.actionStart(mActivity, gnInfo, Integer.parseInt(list.get(position).getMsg_id()));
            } else if (list.get(position).getReply_type().equals(MessageType.MSG_LOG_STRING)) {
                LogDetailActivity.actionStart(mActivity, gnInfo, list.get(position).getMsg_id(), list.get(position).getCat_name(), true);
            } else if (list.get(position).getReply_type().equals(MessageType.MSG_TASK_STRING)) {
                TaskDetailActivity.actionStart(mActivity, list.get(position).getMsg_id(), gnInfo.getGroup_id(), "", false);
            } else if (list.get(position).getReply_type().equals(MessageType.MSG_METTING_STRING)) {
                X5WebViewActivity.actionStart(mActivity, NetWorkRequest.MEETINGDETAILS + "class_type=team&close=" + gnInfo.getGroup_id() + "&group_id=" + gnInfo.getGroup_id() + "&id=" + list.get(position).getMsg_id());
            }
        }
    };

    /**
     * 读取回复列表
     */
    public void getAllNoticeMessage() {
        HttpUtils http = SingsHttpUtils.getHttp();
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        params.addBodyParameter("group_id", gnInfo.getGroup_id());
        params.addBodyParameter("class_type", gnInfo.getClass_type());
        params.addBodyParameter("pagesize", "20");
        params.addBodyParameter("pg", pg + "");
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.GET_ALLNOTICEMESSAGE,
                params, new RequestCallBack<String>() {
                    @Override
                    public void onSuccess(ResponseInfo<String> responseInfo) {
                        try {
                            CommonListJson<ReplyInfo> bean = CommonListJson.fromJson(responseInfo.result, ReplyInfo.class);
                            if (bean.getState() != 0) {
                                addListMsg(bean.getValues());
                            } else {
                                DataUtil.showErrOrMsg(mActivity, bean.getErrno(), bean.getErrmsg());
                                finish();
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                            CommonMethod.makeNoticeShort(mActivity, getString(R.string.service_err), CommonMethod.ERROR);
                            finish();
                            pg -= 1;
                        } finally {
                            closeDialog();
                        }
                    }

                    /** xutils 连接失败 调用的 方法 */
                    @Override
                    public void onFailure(HttpException exception, String errormsg) {
                        pg -= 1;
                        finish();
                    }
                });
    }

    /**
     * 显示数据
     *
     * @param msgDataList
     */
    public void addListMsg(List<ReplyInfo> msgDataList) {
        LUtils.e("---------1111--------");
        if (null == msgDataList) {
            msgDataList = new ArrayList<>();
        }
        if (null == list) {
            list = new ArrayList<>();
        }

        if (isFulsh) {
            mSwipeLayout.setRefreshing(false);
            if (msgDataList.size() == 0) {
                findViewById(R.id.lin_message_def).setVisibility(View.VISIBLE);
                listView.setVisibility(View.GONE);
                return;
            }
            findViewById(R.id.lin_message_def).setVisibility(View.GONE);
            list.clear();
        } else {
            //Constance.PAGE_SIZE
            //是否有更多数据
            isHaveMoreData = msgDataList.size() >= 1 ? true : false;
            int count = listView.getFooterViewsCount();
            if (isHaveMoreData) {
                if (count == 0) {
                    listView.addFooterView(loadMoreView, null, false);
                }
            } else {
                if (count > 0) {
                    listView.removeFooterView(loadMoreView);
                }
            }
            loadMoreView.setVisibility(View.GONE);
        }
        list.addAll(msgDataList);
        if (null == adapter) {
            adapter = new ReplyMsgContentAdapter(mActivity, list);
            listView.setAdapter(adapter);
            listView.setSelection(0);
        } else {
            adapter.notifyDataSetChanged();
            if (isFulsh) {
                listView.setSelection(0);
            } else {
                listView.setSelection(list.size() > 0 ? list.size() - msgDataList.size() - 1 : msgDataList.size());
            }
        }
        mSwipeLayout.setRefreshing(false);

        if (null == list || list.size() == 0) {
            findViewById(R.id.lin_message_def).setVisibility(View.VISIBLE);
            listView.setVisibility(View.GONE);
            findViewById(R.id.right_title).setVisibility(View.GONE);
        } else {
            findViewById(R.id.lin_message_def).setVisibility(View.GONE);
            listView.setVisibility(View.VISIBLE);
            findViewById(R.id.right_title).setVisibility(gnInfo.getIs_closed() == 1 ? View.GONE : View.VISIBLE);
        }

    }

    /**
     * 清除工作消息
     */
    public void cleanReplyMessage() {
        HttpUtils http = SingsHttpUtils.getHttp();
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        params.addBodyParameter("group_id", gnInfo.getGroup_id());
        params.addBodyParameter("class_type", gnInfo.getClass_type());
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.CLEAR_REPLYMESSAGE,
                params, new RequestCallBackExpand<String>() {
                    @Override
                    public void onSuccess(ResponseInfo<String> responseInfo) {
                        try {
                            CommonJson<ReplyInfo> bean = CommonJson.fromJson(responseInfo.result, ReplyInfo.class);
                            if (bean.getState() != 0) {
                                list.clear();
                                adapter.notifyDataSetChanged();
                                findViewById(R.id.right_title).setVisibility(View.GONE);
                                findViewById(R.id.lin_message_def).setVisibility(View.VISIBLE);
                                CommonMethod.makeNoticeShort(mActivity, "清除成功！", CommonMethod.SUCCESS);
                            } else {
                                DataUtil.showErrOrMsg(mActivity, bean.getErrno(), bean.getErrmsg());
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
                        super.onFailure(exception, errormsg);
                        finish();
                    }
                });
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == Constance.CLICK_SINGLECHAT) {
            setResult(Constance.CLICK_SINGLECHAT, data);
            finish();
        } else if (requestCode == Constance.REQUEST && resultCode == Constance.FINISH_WEBVIEW) {
            finish();
        }
    }

    @Override
    public void onScrollStateChanged(AbsListView view, int scrollState) {
        if (view.getLastVisiblePosition() == (view.getCount() - 1) && scrollState == AbsListView.OnScrollListener.SCROLL_STATE_IDLE && isHaveMoreData) {
            if (loadMoreView.getVisibility() == View.GONE) {// 是否还有缓存数据
                isFulsh = false;
                loadMoreView.setVisibility(View.VISIBLE);
                pg += 1;
                getAllNoticeMessage();

            }
        }
    }

    @Override
    public void onScroll(AbsListView view, int firstVisibleItem, int visibleItemCount, int totalItemCount) {

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
        pg = 1;
        isFulsh = true;
        isHaveMoreData = true;
        getAllNoticeMessage();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        MessageUtil.clearMainGroupWorkReplyCount(ReplyMsgContentActivity.this, gnInfo.getGroup_id(), gnInfo.getClass_type());
        unRegisterReceiver();
    }
}
