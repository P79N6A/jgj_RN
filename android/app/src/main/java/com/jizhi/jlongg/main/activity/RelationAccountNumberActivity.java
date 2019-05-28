package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;
import android.view.View;
import android.widget.TextView;

import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.LoginStatu;
import com.jizhi.jlongg.main.dialog.DialogTips;
import com.jizhi.jlongg.main.listener.DiaLogTitleListener;
import com.jizhi.jlongg.main.util.CheckListHttpUtils;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SetTitleName;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.jizhi.jlongg.wxapi.WXUtil;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;


/**
 * 关联账号
 *
 * @author hcs
 * @time 2018年12月13日 10:40:12
 * @Version 1.0
 */
public class RelationAccountNumberActivity extends BaseActivity implements View.OnClickListener {
    /**
     * 是否绑定了微信
     */
    private boolean isBindWX;
    private RelationAccountNumberActivity mActivity;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_relation_account_number);
        initView();
        registerWXCallBack();
        getWXBindTelphoneStatus();
    }


    private void initView() {
        mActivity=RelationAccountNumberActivity.this;
        setTextTitle(R.string.relation_accnum);
        findViewById(R.id.rootLayout).setOnClickListener(this);

    }

    /**
     * 启动当前Activity
     *
     * @param context
     */
    public static void actionStart(Activity context) {
        Intent intent = new Intent(context, RelationAccountNumberActivity.class);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()){
            case R.id.rootLayout:
                /**1、状态说明：
                 （1）未绑定：该用户未绑定微信号；
                 （2）已绑定：该用户已绑定一个微信号；
                 2、交互说明：
                 （1）未绑定：显示提示信息“未绑定”；点击该条信息跳转至微信授权页面；
                 （2）已绑定：显示提示信息“已绑定”；点击该条信息弹出确认框：确定要解除绑定的微信账号？*/
                if (isBindWX) {
                    DialogTips deleteDialog = new DialogTips(mActivity, new DiaLogTitleListener() {
                        @Override
                        public void clickAccess(int position) {
                            unBindWxTelphone();
                        }
                    }, "确定要解除绑定的微信账号？", -1);
                    deleteDialog.show();
                } else {
                    new WXUtil().sendWXLogin(mActivity);
                }
                break;
        }
    }

    /**
     * 获取微信绑定电话号码状态
     */
    public void getWXBindTelphoneStatus() {
        String httpUrl = NetWorkRequest.GET_WECHAT_BIND_INFO;
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        CommonHttpRequest.commonRequest(this, httpUrl, LoginStatu.class, CommonHttpRequest.OBJECT, params, true, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                LoginStatu loginStatu = (LoginStatu) object;
                boolean isBind = loginStatu.getIs_bind() == 0 ? false : true;
                isBindWX = isBind;
                ((TextView)findViewById(R.id.tv_state_wechat)).setText(isBind ?  "已关联":"未关联" );
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
                finish();
            }
        });
    }
    /**
     * 微信解除电话号码绑定
     */
    public void unBindWxTelphone() {
        String httpUrl = NetWorkRequest.UN_BIND_WX;
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        CommonHttpRequest.commonRequest(this, httpUrl, LoginStatu.class, CommonHttpRequest.OBJECT, params, true, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                LoginStatu loginStatu = (LoginStatu) object;
                boolean isBind = loginStatu.getIs_bind() == 0 ? false : true;
                isBindWX = isBind;
                if (!isBind) {
                    CommonMethod.makeNoticeLong(getApplicationContext(), "微信绑定解除成功！", CommonMethod.SUCCESS);
                }
                ((TextView)findViewById(R.id.tv_state_wechat)).setText(isBindWX ?  "已关联":"未关联" );
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
                finish();
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
                isBindWX = isBind;
                ((TextView)findViewById(R.id.tv_state_wechat)).setText(isBindWX ?  "已关联":"未关联" );
            }

            @Override
            public void onFailure(HttpException e, String s) {

            }
        });
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
    @Override
    public void onFinish(View view) {
        Intent intent = new Intent();
        intent.putExtra(Constance.BEAN_BOOLEAN, isBindWX?false:true);
        setResult(Constance.BIND_WECHAT, intent);
        super.onFinish(view);
    }

    @Override
    public void onBackPressed() {
        Intent intent = new Intent();
        intent.putExtra(Constance.BEAN_BOOLEAN, isBindWX?false:true);
        setResult(Constance.BIND_WECHAT, intent);
        super.onBackPressed();
    }
}
