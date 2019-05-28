package com.jizhi.jlongg.main.activity;

import android.annotation.TargetApi;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.graphics.Color;
import android.graphics.Rect;
import android.os.Build;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.v4.content.ContextCompat;
import android.text.Editable;
import android.text.Html;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewTreeObserver;
import android.view.animation.Animation;
import android.view.animation.Transformation;
import android.widget.EditText;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.chuanglan.shanyan_sdk.OneKeyLoginManager;
import com.chuanglan.shanyan_sdk.listener.OneKeyLoginListener;
import com.hcs.uclient.utils.DensityUtils;
import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.StrUtil;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.welcome.ChooseRoleActivity;
import com.jizhi.jlongg.main.bean.LoginStatu;
import com.jizhi.jlongg.main.util.CheckListHttpUtils;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DataUtil;
import com.jizhi.jlongg.main.util.GetCodeUtil;
import com.jizhi.jlongg.main.util.RegisterTimerTextView;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.jizhi.jlongg.main.util.shadow.ShadowUtil;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.jizhi.jlongg.wxapi.WXUtil;
import com.liaoinstan.springview.utils.DensityUtil;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;
import com.yanzhenjie.permission.Action;
import com.yanzhenjie.permission.AndPermission;
import com.yanzhenjie.permission.Permission;

import org.json.JSONObject;

import java.util.List;
import java.util.Timer;
import java.util.TimerTask;

/**
 * 登录界面
 * 如果是手机卡能获取到相关信息并且数据流量已经打开
 * 则会去加载SDK 看是否支持一键登录功能，如果支持一键登录功能那么则会跳转到授权页默认选择一键登录页
 *
 * @author Xuj
 * @time 2015年11月28日 11:14:30
 * @Version 1.0
 */
public class LoginActivity extends BaseActivity implements OnClickListener {
    /**
     * 手机号
     */
    private EditText telEdit;
    /**
     * 验证码
     * 获取验证码按钮
     */
    private EditText codeEdit;
    /**
     */
    private TextView getCodeBtn;
    /**
     * 登录文本
     */
    private TextView loginText;
    /**
     * 验证码布局
     */
    private LinearLayout codeLayout;
    /**
     * 找回密码
     * 这里主要是做键盘弹出来时的一个下标高度
     */
    private TextView findPassWord;
    /**
     * 根部view
     */
    private View rootView;
    /**
     * 首次进入
     */
    private boolean isFirstIn = true;
    /**
     * true表示当前页面正在前台
     */
    private boolean isFont;


    @Override
    protected void onResume() {
        super.onResume();
        isFont = true;
        //登录页不使用截屏信息
        stopScreenShotListener();
    }

    @Override
    protected void onPause() {
        super.onPause();
        isFont = false;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setRestartWebSocketService(false);
        setContentView(R.layout.login);
        initView();
        registerWXCallBack();
        hideSoftKeyboard();
        initOneKeyLogin();
    }

    private void initView() {
        setTextTitle(R.string.login);
        telEdit = getEditText(R.id.telEdit);
        codeEdit = getEditText(R.id.codeEdit);
        getCodeBtn = getTextView(R.id.getCodeBtn);
        loginText = getTextView(R.id.loginText);
        codeLayout = (LinearLayout) findViewById(R.id.codeLayout);
        findPassWord = getTextView(R.id.findPassWord);
        rootView = findViewById(R.id.rootView);

        getTextView(R.id.protcolText).setText(Html.fromHtml("<font color='#999999'>登录即同意</font><font color='#d7252c'>" + "《吉工家用户服务协议》</font>"));
        setKeyBoardAnimation();
        ShadowUtil.setShadowAndUserOriginalBackground(this, loginText, Color.parseColor("#fb4e4e")); //登录按钮设置阴影
        //但有时，我们确实是想让EditText自动获得焦点并弹出软键盘，在设置了EditText自动获得焦点后，
        // 软件盘不会弹出。注意：此时是由于刚跳到一个新的界面，界面未加载完全而无法弹出软键盘。
        // 此时应该适当的延迟弹出软键盘，如500毫秒（保证界面的数据加载完成，如果500毫秒仍未弹出，
        // 则延长至500毫秒）。可以在EditText后面加上一段代码，实例代码如下：
        TextWatcher textWatcher = new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence charSequence, int i, int i1, int i2) {

            }

            @Override
            public void onTextChanged(CharSequence charSequence, int i, int i1, int i2) {
            }

            @Override
            public void afterTextChanged(Editable editable) {
                if (!TextUtils.isEmpty(telEdit.getText().toString()) && !TextUtils.isEmpty(codeEdit.getText().toString())) {
                    setLoginBtnEnable();
                } else {
                    setLoginBtnUnEnable();
                }
            }
        };
        telEdit.addTextChangedListener(textWatcher);
        codeEdit.addTextChangedListener(textWatcher);
        codeEdit.setOnFocusChangeListener(new View.OnFocusChangeListener() {
            @Override
            public void onFocusChange(View v, boolean hasFocus) {
                Utils.setBackGround(codeLayout, getResources().getDrawable(hasFocus ? R.drawable.login_pwd_red_background : R.drawable.login_pwd_background));
            }
        });
        setLoginBtnUnEnable();
    }

    /**
     * 初始化一键登录信息
     */
    private void initOneKeyLogin() {
        requestPermission(Permission.READ_PHONE_STATE);
    }

    private void requestPermission(String... permissions) {
//        final long enterTime = System.currentTimeMillis();

        AndPermission.with(this)
                .permission(permissions)
                .onGranted(new Action() {
                    @TargetApi(Build.VERSION_CODES.M)
                    @Override
                    public void onAction(List<String> permissions) {
                        //设置状态监听
                        /**
                         * 拉起授权页
                         （1）、在需要登录的activity中调用，可以在多个页面调用。调用拉起授权页方法，SDK将会调起运营商授权页面，
                         用户授权后点击一键登录，SDK将返回包含token在内的请求参数给应用客户端，开发者用这些参数调用自己的服务器可以交换用户信息。
                         拉起授权页需要获取READ_PHONE_STATE权限，无权限会返回相应失败状态码。方法原型：
                         （2）示例代码：
                         OneKeyLoginManager.getInstance().LoginStart();
                         */
                        OneKeyLoginManager.getInstance().setOneKeyLoginListener(2, new OneKeyLoginListener() {
                            @Override
                            public void getPhoneCode(int code, String result) {
//                                if (System.currentTimeMillis() - enterTime > 2000) { //超过两秒则不在请求
//                                    return;
//                                }
                                dataProcessing(code, result);
                            }
                        });
                        //开始拉取授权页
                        OneKeyLoginManager.getInstance().LoginStart();
                    }
                })
                .onDenied(new Action() {
                    @Override
                    public void onAction(@NonNull List<String> permissions) {
                    }
                })
                .start();
    }

    private void dataProcessing(int code, String result) {
        LUtils.e("拉起授权页&&一键登录code=" + code + "result==" + result);
        if (code == 1000) {
            try {
                JSONObject jsonObject = new JSONObject(result);
                RequestParams params = RequestParamsToken.getExpandRequestParams(getApplicationContext());
                params.addBodyParameter("telecom", jsonObject.optString("telecom"));//运营商
                params.addBodyParameter("accessToken", jsonObject.optString("accessToken"));//	闪验token
                params.addBodyParameter("flashtimestamp", jsonObject.optString("timestamp"));//时间戳,验证失效
                params.addBodyParameter("randoms", jsonObject.optString("randoms"));//随机数
                params.addBodyParameter("flashsign", jsonObject.optString("sign")); //闪验sign
                params.addBodyParameter("flashversion", jsonObject.optString("version")); //闪验版本号
                params.addBodyParameter("device", jsonObject.optString("device"));//设备号
                params.addBodyParameter("os", "A");
                CommonHttpRequest.commonRequest(LoginActivity.this, NetWorkRequest.FLASH_LOGIN, LoginStatu.class, CommonHttpRequest.OBJECT, params, true, new CommonHttpRequest.CommonRequestCallBack() {
                    @Override
                    public void onSuccess(Object object) {
                        LoginStatu loginStatu = (LoginStatu) object;
                        //放置一些基本信息 如头像、姓名、是否已经完善姓名等资料
                        DataUtil.putUserLoginInfo(getApplicationContext(), loginStatu);
                        goAppHomePage();
                    }

                    @Override
                    public void onFailure(HttpException exception, String errormsg) {

                    }
                });
            } catch (Exception e) {
                e.printStackTrace();
//                CommonMethod.makeNoticeLong(getApplicationContext(), e.toString(), false);
            }
        } else if (code != 1011 && code != 1013 && code != 1003) { //出错了的信息  1011和1012为点击返回后返回的错误码
            if (!isFont) {
                CommonMethod.makeNoticeLong(getApplicationContext(), "免密登录失败，请使用验证码登录", false);
            }
        }
    }

    /**
     * 设置按钮不可点时的颜色
     */
    private void setLoginBtnUnEnable() {
        loginText.setTextColor(ContextCompat.getColor(getApplicationContext(), R.color.white_50_alpha));
        loginText.setClickable(false);
    }

    /**
     * 设置按钮可点时的颜色
     */
    private void setLoginBtnEnable() {
        loginText.setTextColor(ContextCompat.getColor(getApplicationContext(), android.R.color.white));
        loginText.setClickable(true);
    }

    /**
     * 设置键盘弹起动画 将元素 收缩的动画
     */
    private void setKeyBoardAnimation() {
        getWindow().getDecorView().getViewTreeObserver().addOnGlobalLayoutListener(new ViewTreeObserver.OnGlobalLayoutListener() {
            //当键盘弹出隐藏的时候会 调用此方法。
            @Override
            public void onGlobalLayout() {
                if (isFirstIn) {
                    isFirstIn = false;
                    return;
                }
                if (isLoadKeyBoardAnimation) {
                    return;
                }
                Rect r = new Rect();
                //获取当前界面可视部分
                getWindow().getDecorView().getWindowVisibleDisplayFrame(r);
                //获取屏幕的高度
                int screenHeight = getWindow().getDecorView().getRootView().getHeight();
                //获取屏幕的高度
//                int screenHeight = DensityUtils.getScreenHeight(getApplicationContext());
                //此处就是用来获取键盘的高度的， 在键盘没有弹出的时候 此高度为0 键盘弹出的时候为一个正数
                int keyboardHeihgt = screenHeight - r.bottom;
                //获取空白区域的高度
//                int emptyAreaHeight = screenHeight - loginText.getBottom();
//                获取空白区域的高度
                int emptyAreaHeight = screenHeight - findPassWord.getBottom();
                //虚拟键的高度
                int navBarHeight = 0;
                if (DensityUtils.hasNavBar(getApplicationContext())) { //是否有虚拟键,如果有虚拟键需要加上虚拟键的高度
                    navBarHeight = DensityUtils.getNavigationBarHeight(getApplicationContext());
                }
                if (keyboardHeihgt > emptyAreaHeight && moveDistance == 0) { //如果键盘弹出的高度还没有遮住找回密码之前的高度 则不用 加载弹出动画
                    moveDistance = keyboardHeihgt - emptyAreaHeight + findPassWord.getHeight() + DensityUtil.dp2px(15);
                }
                setKeyBoardAnimation(rootView, keyboardHeihgt == 0 + navBarHeight ? 0 : moveDistance);
            }
        });
    }


    /**
     * 弹出键盘时View移动距离
     */
    private int moveDistance;
    /**
     * 是否正在显示键盘动画
     */
    private boolean isLoadKeyBoardAnimation;


    /**
     * 设置键盘弹出和关闭动画效果
     *
     * @param rootView
     * @param visibleHeight
     */
    private void setKeyBoardAnimation(final View rootView, final int visibleHeight) {
        final FrameLayout.LayoutParams layoutParams = (FrameLayout.LayoutParams) rootView.getLayoutParams();
        if (!isLoadKeyBoardAnimation && layoutParams.topMargin == -visibleHeight) {
            return;
        }
        isLoadKeyBoardAnimation = true;
        Animation animation = new Animation() {
            @Override
            protected void applyTransformation(float interpolatedTime, Transformation t) {
                if (visibleHeight == 0) { //键盘关闭
                    layoutParams.topMargin = -(int) (moveDistance - moveDistance * interpolatedTime);
                } else {  //键盘弹出事件
                    layoutParams.topMargin = -(int) (moveDistance * interpolatedTime);
                }
                rootView.setLayoutParams(layoutParams);
            }

            @Override
            public void initialize(int width, int height, int parentWidth, int parentHeight) {
                super.initialize(width, height, parentWidth, parentHeight);
            }
        };
        animation.setDuration(300);
        animation.setAnimationListener(new Animation.AnimationListener() {
            @Override
            public void onAnimationStart(Animation animation) {

            }

            @Override
            public void onAnimationEnd(Animation animation) {
                isLoadKeyBoardAnimation = false;
            }

            @Override
            public void onAnimationRepeat(Animation animation) {

            }
        });
        rootView.startAnimation(animation);
    }


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.getCodeBtn: //获取验证码
                if (StrUtil.isFastDoubleClick()) {
                    return;
                }
                String value = telEdit.getText().toString().trim();
                if (StrUtil.isNull(value)) {
                    CommonMethod.makeNoticeShort(this, getString(R.string.input_mobile), CommonMethod.ERROR);
                    return;
                }
                if (!StrUtil.isMobileNum(value)) {
                    CommonMethod.makeNoticeShort(this, getString(R.string.input_sure_mobile), CommonMethod.ERROR);
                    return;
                }
                getCodeBtn.setClickable(false);
                GetCodeUtil.getCode(this, value, Constance.LOGIN_APP_CODE, new GetCodeUtil.NetRequestListener() {
                    @Override
                    public void onFailure() {
                        getCodeBtn.setClickable(true);
                    }

                    @Override
                    public void onSuccess() {
                        //开启验证码倒计时  每次倒计时的时间为1分钟
                        new RegisterTimerTextView(60000, 1000, getCodeBtn, getResources()).start();
                        codeEdit.requestFocus();
                        new Timer().schedule(new TimerTask() {
                            public void run() {
                                showSoftKeyboard(codeEdit);
                            }
                        }, 200);
                    }
                });
                break;
            case R.id.loginText: // 登录验证
                String phone = telEdit.getText().toString().trim(); // 手机号
                if (TextUtils.isEmpty(phone)) {
                    CommonMethod.makeNoticeShort(this, getString(R.string.mobile_is_no_empty), CommonMethod.ERROR);
                    return;
                }
                if (!StrUtil.isMobileNum(phone)) {
                    CommonMethod.makeNoticeShort(this, getString(R.string.input_sure_mobile), CommonMethod.ERROR);
                    return;
                }
                String password_value = codeEdit.getText().toString(); // 验证码
                if (TextUtils.isEmpty(password_value)) {
                    CommonMethod.makeNoticeShort(this, getString(R.string.input_message_code), CommonMethod.ERROR);
                    return;
                }
                login();
                break;
            case R.id.protcolText: //吉工家 用户协议
                X5WebViewActivity.actionStart(this, NetWorkRequest.WEBURLS + "my/agreement");
                break;
            case R.id.wxLoginText: //发起微信的登录，获取一些账户信息如名称、头像等
                new WXUtil().sendWXLogin(LoginActivity.this);
                break;
            case R.id.findPassWord: //找回密码
                FindPwdInputTelphoneActivity.actionStart(this);
                break;
            default:
                break;
        }
    }

    /**
     * 普通登录验证
     */
    private void login() {
        String telephone = telEdit.getText().toString().trim();
        String vcode = codeEdit.getText().toString().trim();
        CommonHttpRequest.login(this, telephone, vcode, new CheckListHttpUtils.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object checkPlan) {
                goAppHomePage();
            }

            @Override
            public void onFailure(HttpException e, String s) {

            }
        });
    }

    /**
     * 微信登录验证
     *
     * @param wechatid
     */
    private void wxLogin(final String wechatid) {
        CommonHttpRequest.wxLogin(this, wechatid, new CheckListHttpUtils.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object checkPlan) {
                LoginStatu loginStatu = (LoginStatu) checkPlan;
                int isBind = loginStatu.getIs_bind();
                if (isBind == 1) { //如果已经绑定了微信号 则直接去到首页
                    goAppHomePage();
                } else {  //如果没有绑定微信号 则去到绑定微信页面
                    BindWxActivity.actionStart(LoginActivity.this, wechatid);
                }
            }

            @Override
            public void onFailure(HttpException e, String s) {

            }
        });
    }


    /**
     * 去到App首页
     */
    private void goAppHomePage() {
//        Intent intent = new Intent(LoginActivity.this, AppMainActivity.class);
//        startActivity(intent);
//        setResult(Constance.LOGIN_SUCCESS);
//        finish();
        Intent intent = getIntent();
        String url = intent.getStringExtra(Constance.COMPLETE_SCHEME);
        if (TextUtils.isEmpty(url)) {
            ChooseRoleActivity.actionStart(LoginActivity.this, true);
        } else {
            ChooseRoleActivity.actionStart(LoginActivity.this, true, url);
        }
        finish();
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == Constance.LOGIN_SUCCESS) { //通过绑定微信成功后的回调 直接去到首页
            goAppHomePage();
        }
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
                LUtils.e("--------接收到的unionid--------" + unionid);
                wxLogin(unionid);
            }
        }
    }
}