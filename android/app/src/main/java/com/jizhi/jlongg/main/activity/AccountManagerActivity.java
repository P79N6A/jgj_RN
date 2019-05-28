package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.graphics.Color;
import android.os.Bundle;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AbsListView;
import android.widget.AdapterView;
import android.widget.ListView;

import com.hcs.uclient.utils.DensityUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.adpter.ChatManagerAdapter;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.ChatManagerItem;
import com.jizhi.jlongg.main.bean.LoginStatu;
import com.jizhi.jlongg.main.bean.status.CommonJson;
import com.jizhi.jlongg.main.dialog.DialogTips;
import com.jizhi.jlongg.main.listener.DiaLogTitleListener;
import com.jizhi.jlongg.main.util.CheckListHttpUtils;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DataUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SingsHttpUtils;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.jizhi.jlongg.wxapi.WXUtil;
import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.client.HttpRequest;

import java.util.ArrayList;
import java.util.List;

/**
 * 账户管理
 *
 * @author Xuj
 * @time 2018年3月13日14:42:30
 * @Version 1.0
 */
public class AccountManagerActivity extends BaseActivity {
    /**
     * 修改手机号码
     */
    public static final int UPDATE_TEL = 1;
    /**
     * 绑定微信状态
     */
    public static final int BIND_WX_STATUS = 2;
    /**
     * 是否已绑定
     */
    private boolean isBindWX;
    /**
     * 设置列表适配器
     */
    private ChatManagerAdapter adapter;

    /**
     * 启动当前Activity
     *
     * @param context
     */
    public static void actionStart(Activity context) {
        Intent intent = new Intent(context, AccountManagerActivity.class);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.listview);
        initView();
        getWXBindStatus();
        registerWXCallBack();
    }

    private void initView() {
        setTextTitle(R.string.account_manager);
        initListItem();
    }

    public void registerWXCallBack() {
        IntentFilter filter = new IntentFilter();
        filter.addAction(Constance.ACTION_GET_WX_USERINFO);
        receiver = new MessageBroadcast();
        registerLocal(receiver, filter);
    }

    /**
     * 广播回调
     */
    class MessageBroadcast extends BroadcastReceiver {
        @Override
        public void onReceive(Context context, Intent intent) {
            String action = intent.getAction();
            if (action.equals(Constance.ACTION_GET_WX_USERINFO)) { //微信绑定成功的回调
                String unionid = intent.getStringExtra("unionid"); //微信号唯一id
                wxLogin(unionid);
            }
        }
    }


    private void initListItem() {
        List<ChatManagerItem> chatManagerList = new ArrayList<>();
        ChatManagerItem menu1 = new ChatManagerItem("修改手机号码", true, true, UPDATE_TEL);
        ChatManagerItem menu2 = new ChatManagerItem("绑定微信", true, true, BIND_WX_STATUS);
        menu1.setValueColor(Color.parseColor("#999999"));
        menu2.setValueColor(Color.parseColor("#999999"));
        chatManagerList.add(menu1);
        chatManagerList.add(menu2);
        final ListView listView = (ListView) findViewById(R.id.listView);
        View headView = new View(this);
        AbsListView.LayoutParams params = new AbsListView.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, DensityUtils.dp2px(getApplicationContext(), 10));
        headView.setLayoutParams(params);
        listView.addHeaderView(headView, null, false);

        adapter = new ChatManagerAdapter(this, chatManagerList, null);
        listView.setAdapter(adapter);
        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                position -= listView.getHeaderViewsCount();
                ChatManagerItem item = adapter.getList().get(position);
                Intent intent = null;
                switch (item.getMenuType()) {
                    case BIND_WX_STATUS: //绑定微信
                        /**1、状态说明：
                         （1）未绑定：该用户未绑定微信号；
                         （2）已绑定：该用户已绑定一个微信号；
                         2、交互说明：
                         （1）未绑定：显示提示信息“未绑定”；点击该条信息跳转至微信授权页面；
                         （2）已绑定：显示提示信息“已绑定”；点击该条信息弹出确认框：确定要解除绑定的微信账号？*/
                        if (isBindWX) {
                            DialogTips deleteDialog = new DialogTips(AccountManagerActivity.this, new DiaLogTitleListener() {
                                @Override
                                public void clickAccess(int position) {
                                    unBindWx();
                                }
                            }, "确定要解除绑定的微信账号？", -1);
                            deleteDialog.show();
                        } else {
                            new WXUtil().sendWXLogin(AccountManagerActivity.this);
                        }
                        break;
                    case UPDATE_TEL: //修改电话号码
//                        UpdateTelFirstActivity.actionStart(AccountManagerActivity.this);
                        break;
                }
                if (intent != null) {
                    startActivityForResult(intent, Constance.REQUEST);
                }
            }
        });
    }


    public void setItemValue(int item, String value) {
        for (ChatManagerItem bean : adapter.getList()) {
            if (bean.getMenuType() == item) {
                bean.setValue(value);
                adapter.notifyDataSetChanged();
                return;
            }
        }
    }

    /**
     * 获取微信绑定状态
     */
    public void getWXBindStatus() {
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.GET_WECHAT_BIND_INFO, params, new RequestCallBackExpand<String>() {
            @Override
            public void onSuccess(ResponseInfo<String> responseInfo) {
                try {
                    CommonJson<LoginStatu> base = CommonJson.fromJson(responseInfo.result, LoginStatu.class);
                    if (base.getState() != 0) {
                        boolean isBind = base.getValues().getIs_bind() == 0 ? false : true;
                        setItemValue(BIND_WX_STATUS, isBind ? "已绑定" : "未绑定");
                        isBindWX = isBind;
                    } else {
                        DataUtil.showErrOrMsg(AccountManagerActivity.this, base.getErrno(), base.getErrmsg());
                        finish();
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    CommonMethod.makeNoticeShort(getApplicationContext(), getString(R.string.service_err), CommonMethod.ERROR);
                    finish();
                } finally {
                    closeDialog();
                }
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
                CommonMethod.makeNoticeShort(getApplicationContext(), getString(R.string.service_err), CommonMethod.ERROR);
                finish();
            }
        });
    }


    /**
     * 微信解除绑定
     */
    public void unBindWx() {
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.UN_BIND_WX, params, new RequestCallBackExpand<String>() {
            @Override
            public void onSuccess(ResponseInfo<String> responseInfo) {
                try {
                    CommonJson<LoginStatu> base = CommonJson.fromJson(responseInfo.result, LoginStatu.class);
                    if (base.getState() != 0) {
                        boolean isBind = base.getValues().getIs_bind() == 0 ? false : true;
                        setItemValue(BIND_WX_STATUS, isBind ? "已绑定" : "未绑定");
                        isBindWX = isBind;
                        if (!isBind) {
                            CommonMethod.makeNoticeLong(getApplicationContext(), "微信绑定解除成功！", CommonMethod.SUCCESS);
                        }
                    } else {
                        DataUtil.showErrOrMsg(AccountManagerActivity.this, base.getErrno(), base.getErrmsg());
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    CommonMethod.makeNoticeShort(getApplicationContext(), getString(R.string.service_err), CommonMethod.ERROR);
                } finally {
                    closeDialog();
                }
            }
        });
    }

    /**
     * 微信登录验证
     *
     * @param wechatid 微信唯一id(如果是通过微信登录来调用则这个值不为空)
     */
    public void wxLogin(final String wechatid) {
        CommonHttpRequest.wxOnlineLogin(this, wechatid, UclientApplication.getTelephone(getApplicationContext()), new CheckListHttpUtils.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object checkPlan) {
                LoginStatu loginStatu = (LoginStatu) checkPlan;
                boolean isBind = loginStatu.getIs_bind() == 0 ? false : true;
                setItemValue(BIND_WX_STATUS, isBind ? "已绑定" : "未绑定");
                isBindWX = isBind;
            }

            @Override
            public void onFailure(HttpException e, String s) {

            }
        });
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == Constance.LOGIN_SUCCESS) { //通过绑定微信成功后的回调 直接去到首页
            getWXBindStatus(); //重新获取微信状态
        }
    }
}