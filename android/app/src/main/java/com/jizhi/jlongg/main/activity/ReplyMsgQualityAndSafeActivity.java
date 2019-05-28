package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ListView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.log.LogDetailActivity;
import com.jizhi.jlongg.main.activity.task.TaskDetailActivity;
import com.jizhi.jlongg.main.adpter.ReplyQualityAndSafeAdapter;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;
import com.jizhi.jlongg.main.bean.MessageBean;
import com.jizhi.jlongg.main.bean.ReplyInfo;
import com.jizhi.jlongg.main.bean.status.CommonListJson;
import com.jizhi.jlongg.main.message.ActivityNoticeDetailActivity;
import com.jizhi.jlongg.main.message.ActivityQualityAndSafeDetailActivity;
import com.jizhi.jlongg.main.msg.MessageType;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DataUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SetTitleName;
import com.jizhi.jlongg.main.util.SingsHttpUtils;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.client.HttpRequest;

import java.util.List;


/**
 *
 */

public class ReplyMsgQualityAndSafeActivity extends BaseActivity {
    private ReplyMsgQualityAndSafeActivity mActivity;
    private ListView listView;
    private ReplyQualityAndSafeAdapter adapter;
    private List<ReplyInfo> list;
    private GroupDiscussionInfo gnInfo;
    private String msg_type;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_release_level);
        registerFinishActivity();
        initView();
        getIntentData();
        getData();
        listView.setOnItemClickListener(itemClickListener);
    }

    /**
     * 初始化view
     */
    private void initView() {
        mActivity = ReplyMsgQualityAndSafeActivity.this;
        listView = (ListView) findViewById(R.id.listView);
        SetTitleName.setTitle(findViewById(R.id.title), "回复消息");
        msg_type = getIntent().getStringExtra(Constance.MSG_TYPE);
    }

    /**
     * 启动当前Acitivyt
     *
     * @param context
     */
    public static void actionStart(Activity context, GroupDiscussionInfo gnInfo, String msgType) {
        Intent intent = new Intent(context, ReplyMsgQualityAndSafeActivity.class);
        intent.putExtra(Constance.BEAN_CONSTANCE, gnInfo);
        intent.putExtra(Constance.MSG_TYPE, msgType);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    /**
     * 获取传递过来的数据
     */
    private void getIntentData() {
        gnInfo = (GroupDiscussionInfo) getIntent().getSerializableExtra(Constance.BEAN_CONSTANCE);
    }

    AdapterView.OnItemClickListener itemClickListener = new AdapterView.OnItemClickListener() {
        @Override
        public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
            if (msg_type.equals(MessageType.MSG_QUALITY_STRING) || msg_type.equals(MessageType.MSG_SAFE_STRING)) {
                MessageBean messageEntity = new MessageBean();
                messageEntity.setMsg_id(Integer.parseInt(list.get(position).getMsg_id()));
                messageEntity.setClass_type(list.get(position).getClass_type());
                messageEntity.setMsg_type(list.get(position).getMsg_type());
                messageEntity.setGroup_id(list.get(position).getGroup_id());
                ActivityQualityAndSafeDetailActivity.actionStart(mActivity, messageEntity, gnInfo);
            } else if (msg_type.equals(MessageType.MSG_NOTICE_STRING)) {
                ActivityNoticeDetailActivity.actionStart(mActivity, gnInfo, Integer.parseInt(list.get(position).getMsg_id()));
            } else if (msg_type.equals(MessageType.MSG_LOG_STRING)) {
                LogDetailActivity.actionStart(mActivity, gnInfo, list.get(position).getLog_id(), list.get(position).getCat_name(), false);
            } else if (msg_type.equals(MessageType.MSG_TASK_STRING)) {
                TaskDetailActivity.actionStart(mActivity, list.get(position).getReply_id(), gnInfo.getGroup_id(), "", false);
            }
        }
    };

    /**
     * 读取回复列表
     */
    public void getData() {
        HttpUtils http = SingsHttpUtils.getHttp();
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        params.addBodyParameter("group_id", gnInfo.getGroup_id());
        params.addBodyParameter("class_type", gnInfo.getClass_type());
        params.addBodyParameter("msg_type", getIntent().getStringExtra(Constance.MSG_TYPE));
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.GET_QUALITYSAFEALLLIST,
                    params, new RequestCallBackExpand<String>() {
                        @Override
                        public void onSuccess(ResponseInfo<String> responseInfo) {
                            try {
                                CommonListJson<ReplyInfo> bean = CommonListJson.fromJson(responseInfo.result, ReplyInfo.class);
                                if (bean.getState() != 0) {
                                    if (bean.getValues() != null && bean.getValues().size() > 0) {//当返回数据小于0 并且 为空的时候 则显示 添加工人界面
                                        list = bean.getValues();
                                        adapter = new ReplyQualityAndSafeAdapter(mActivity, list);
                                        listView.setAdapter(adapter);
                                        findViewById(R.id.lin_message_def).setVisibility(View.GONE);
                                    } else {
                                        findViewById(R.id.lin_message_def).setVisibility(View.VISIBLE);
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
                            super.onFailure(exception, errormsg);
                            finish();
                        }
                    });
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == Constance.CLICK_SINGLECHAT) {
            GroupDiscussionInfo info = (GroupDiscussionInfo) data.getSerializableExtra(Constance.BEAN_CONSTANCE);
            Intent intent = new Intent();
            Bundle bundle = new Bundle();
            bundle.putSerializable(Constance.BEAN_CONSTANCE, info);
            intent.putExtras(bundle);
            setResult(Constance.CLICK_SINGLECHAT, intent);
            finish();
        }
    }
}
