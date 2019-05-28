package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.text.InputFilter;
import android.text.TextUtils;
import android.view.View;
import android.widget.AdapterView;
import android.widget.EditText;
import android.widget.ListView;

import com.facebook.react.bridge.ReactApplicationContext;
import com.hcs.uclient.utils.LUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.adpter.MouldItemAdapter;
import com.jizhi.jlongg.main.bean.AddFriendsSources;
import com.jizhi.jlongg.main.bean.BaseNetNewBean;
import com.jizhi.jlongg.main.bean.MessageModel;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;

import java.util.ArrayList;

import static com.hcs.uclient.utils.SPUtils.get;


/**
 * 添加朋友、发送验证
 *
 * @author Xuj
 * @time 2017年2月10日15:51:52
 * @Version 1.0
 */
public class AddFriendSendCodectivity extends BaseActivity implements View.OnClickListener {

    /**
     * 发送验证内容编辑框
     */
    private EditText sendEdittext;
    /**
     * 用户id
     */
    private String uid;
    /**
     * 我的信息
     */
    private String myInfo;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.add_friend_send_code);
        init();
        getSendMessageModule();
        LUtils.e("====添加朋友==param==="+AddFriendsSources.create().getSource());
    }


    private void init() {
        setTextTitleAndRight(R.string.add_friend, R.string.send_invite);
        sendEdittext = (EditText) findViewById(R.id.sendEdittext);
        sendEdittext.setFilters(new InputFilter[]{new InputFilter.LengthFilter(50)}); //最多可输入50字
        Intent intent = getIntent();
        uid = intent.getStringExtra("param1");
        String realName = get(getApplicationContext(), Constance.USERNAME, "", Constance.JLONGG).toString(); //当前登录人姓名
        String nickName = get(getApplicationContext(), Constance.NICKNAME, "", Constance.JLONGG).toString(); //当前登录人昵称
        myInfo = "我是" + (!TextUtils.isEmpty(nickName) ? nickName : realName); //如果有昵称 优先 显示昵称 否则显示名称
    }


    /**
     * @param context
     * @param uid     用户id
     */
    public static void actionStart(Activity context, String uid) {
        Intent intent = new Intent(context, AddFriendSendCodectivity.class);
        intent.putExtra("param1", uid);
        context.startActivityForResult(intent, Constance.REQUEST);
    }
    /**
     * @param context
     * @param uid     用户id
     */
    public static void actionStart(ReactApplicationContext context, String uid) {
        Intent intent = new Intent(context, AddFriendSendCodectivity.class);
        intent.putExtra("param1", uid);
        context.startActivityForResult(intent, Constance.REQUEST,null);
    }


    /**
     * 发送好友验证申请
     */
    private void sendFriendApply() {
        String httpUrl = NetWorkRequest.ADD_FRIEND;
        RequestParams params = RequestParamsToken.getExpandRequestParams(getApplicationContext());
        params.addBodyParameter("uid", uid);
        params.addBodyParameter("msg_text", sendEdittext.getText().toString().trim());
        params.addBodyParameter("add_from", AddFriendsSources.create().getSource());
        LUtils.e("====添加朋友==param==="+AddFriendsSources.create().getSource());
        CommonHttpRequest.commonRequest(this, httpUrl, BaseNetNewBean.class, false, params, true, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                CommonMethod.makeNoticeShort(getApplicationContext(), "已发送", CommonMethod.SUCCESS);
                setResult(Constance.SEND_ADD_FRIEND_SUCCESS);
                finish();
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {

            }
        });
    }


    /**
     * 获取发送模板信息列表
     */
    public void getSendMessageModule() {
        String httpUrl = NetWorkRequest.SEND_MESSAGE_MOUDLE;
        RequestParams params = RequestParamsToken.getExpandRequestParams(getApplicationContext());
        CommonHttpRequest.commonRequest(this, httpUrl, MessageModel.class, true, params, true, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                final ArrayList<MessageModel> list = (ArrayList<MessageModel>) object;
                if (list != null && list.size() > 0) {
                    ListView listView = (ListView) findViewById(R.id.listView);
                    final MouldItemAdapter adapter = new MouldItemAdapter(AddFriendSendCodectivity.this, list);
                    listView.setAdapter(adapter);
                    String mouldText = list.get(0).getMsg_text();
                    if (!TextUtils.isEmpty(mouldText)) {
                        //设置输入框为模板的第一条信息
                        sendEdittext.setText(mouldText.equals("无") ? myInfo : myInfo + "，" + mouldText);
                        if (!TextUtils.isEmpty(sendEdittext.getText().toString())) { //设置光标在模板的最后
                            sendEdittext.setSelection(sendEdittext.getText().toString().length());
                        }
                    }
                    listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                        @Override
                        public void onItemClick(AdapterView<?> parent, View view, int position, long id) { //好友模板点击信息
                            if (adapter.getSelectedPostion() == position) {
                                return;
                            }
                            adapter.setSelectedPostion(position);
                            adapter.notifyDataSetChanged();
                            sendEdittext.setText(list.get(position).getMsg_text().equals("无") ? myInfo : myInfo + "，" + list.get(position).getMsg_text());
                            if (!TextUtils.isEmpty(sendEdittext.getText().toString())) { //设置光标在模板的最后
                                sendEdittext.setSelection(sendEdittext.getText().toString().length());
                            }
                        }
                    });
                }
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
                finish();
            }
        });
    }


    @Override
    public void onClick(View v) {
        sendFriendApply();
    }
}