package com.jizhi.jlongg.main.activity;

import android.Manifest;
import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.graphics.Color;
import android.os.Bundle;
import android.os.Environment;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.TextView;

import com.hcs.uclient.utils.AppUtils;
import com.hcs.uclient.utils.DataCleanManager;
import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.StrUtil;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.adpter.ChatManagerAdapter;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.ChatManagerItem;
import com.jizhi.jlongg.main.bean.LoginStatu;
import com.jizhi.jlongg.main.bean.SingleSelected;
import com.jizhi.jlongg.main.bean.Version;
import com.jizhi.jlongg.main.bean.WechatBean;
import com.jizhi.jlongg.main.dialog.CustomProgress;
import com.jizhi.jlongg.main.dialog.DialogLeftRightBtnConfirm;
import com.jizhi.jlongg.main.dialog.DialogTips;
import com.jizhi.jlongg.main.listener.DiaLogTitleListener;
import com.jizhi.jlongg.main.popwindow.SingleSelectedPopWindow;
import com.jizhi.jlongg.main.util.BackGroundUtil;
import com.jizhi.jlongg.main.util.CheckListHttpUtils;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DataUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SingsHttpUtils;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.jizhi.jlongg.utis.acp.Acp;
import com.jizhi.jlongg.utis.acp.AcpListener;
import com.jizhi.jlongg.utis.acp.AcpOptions;
import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.client.HttpRequest;

import java.io.File;
import java.util.ArrayList;
import java.util.List;


/**
 * 设置界面
 *
 * @author Xuj
 * @time 2015年11月28日 11:14:30
 * @Version 1.0
 */
public class SetActivity extends BaseActivity {


    /**
     * 手机号码是否已绑定微信
     */
    private boolean isBindWX;


    public static final int UPDATE_TELPHONE = 1; //修改手机号码
    public static final int BIND_WX = 2; //绑定微信
    //    public static final int ACCOUNT_MANAGER = 3; //账户管理
    public static final int ABOUT_US = 3; //关于我们
    public static final int CONTACTS_US = 4; //联系我们
    public static final int CHECKVERSION = 5; //检测版本
    public static final int CLEAR_CACHE = 6; //清空缓存
    public static final int OPEN_WECHAT_SERVICE = 7; //开通吉工家微信服务
    public static final int HELP_CENTER = 8; //帮助中心

    /**
     * 设置列表适配器
     */
    private ChatManagerAdapter adapter;
    /**
     * 开通微信服务，关联账号
     */
    private ChatManagerItem openWechatService, relationAccountNumber;
    /**
     * 当前微信绑定状态1：已经绑定  0：未绑定
     */
    private int wechatBindStatus;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_set);
        initView();
        getAppCache();
        AutoCheckVersion();
        registerWXCallBack();
        //微信绑定状态
        getWXBindTelphoneStatus();
        //开通微信服务状态
        getWechatServiceStatus();
    }

    public static final String CANCEL_ACCOUNT_ITEM = "1";
    public static final String ITEM_2 = "2";

    public List<SingleSelected> getItem() {
        List<SingleSelected> list = new ArrayList<>();
        list.add(new SingleSelected(true, true, CANCEL_ACCOUNT_ITEM));
        list.add(new SingleSelected("取消", false, false, ITEM_2, Color.parseColor("#999999")));
        return list;
    }

    private void initView() {
        setTextTitleAndRight(R.string.set, R.string.more);
        //只有已登录的用户 才会显示是否注销的按钮
        TextView rightTitle = getTextView(R.id.right_title);
        if (UclientApplication.isLogin(getApplicationContext())) {
            rightTitle.setVisibility(View.VISIBLE);
            rightTitle.setOnClickListener(new OnClickListener() {
                @Override
                public void onClick(View v) {
                    SingleSelectedPopWindow popWindow = new SingleSelectedPopWindow(SetActivity.this, getItem(), new SingleSelectedPopWindow.SingleSelectedListener() {
                        @Override
                        public void getSingleSelcted(SingleSelected bean) {
                            switch (bean.getSelecteNumber()) {
                                case CANCEL_ACCOUNT_ITEM: //跳转到注销账户页面
                                    UnSubscribeActivity.actionStart(SetActivity.this);
                                    break;
                            }
                        }
                    });
                    popWindow.showAtLocation(getWindow().getDecorView(), Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0); //设置layout在PopupWindow中显示的位置
                    BackGroundUtil.backgroundAlpha(SetActivity.this, 0.5F);
                }
            });
        } else {
            rightTitle.setVisibility(View.GONE);
        }
        initListItem();
        findViewById(R.id.title).setOnLongClickListener(new View.OnLongClickListener() {
            @Override
            public boolean onLongClick(View v) {
                try {
                    ApplicationInfo appInfo = getPackageManager().getApplicationInfo(getPackageName(),
                            PackageManager.GET_META_DATA);
                    String value = appInfo.metaData.getString("UMENG_CHANNEL");
                    CommonMethod.makeNoticeLong(SetActivity.this, "渠道名称：" + value, CommonMethod.SUCCESS);
                } catch (PackageManager.NameNotFoundException e) {
                    e.printStackTrace();
                }
                return false;
            }
        });
    }

    /**
     * 启动当前Activity
     *
     * @param context
     */
    public static void actionStart(Activity context) {
        Intent intent = new Intent(context, SetActivity.class);
        context.startActivityForResult(intent, Constance.REQUEST);
    }


    private void initListItem() {
        List<ChatManagerItem> chatManagerList = new ArrayList<>();


        ChatManagerItem menu1 = new ChatManagerItem("更换手机号", true, true, UPDATE_TELPHONE);
        //3.4.2把绑定微信移到二级界面，增加关联账号入口
        relationAccountNumber = new ChatManagerItem("关联账号", true, true, BIND_WX);
        relationAccountNumber.setItemType(ChatManagerItem.RIGHT_IMAGE_AND_ARROW);
        relationAccountNumber.setHideRightImage(true);
        ChatManagerItem menu7 = new ChatManagerItem("帮助中心", true, false, HELP_CENTER);
        ChatManagerItem menu3 = new ChatManagerItem("关于我们", true, false, ABOUT_US);
        ChatManagerItem menu4 = new ChatManagerItem("联系我们", true, true, CONTACTS_US);
        ChatManagerItem menu5 = new ChatManagerItem("检测版本", true, true, CHECKVERSION);
        ChatManagerItem menu6 = new ChatManagerItem("清空缓存", true, true, CLEAR_CACHE);
        openWechatService = new ChatManagerItem("开通吉工家微信服务", true, true, OPEN_WECHAT_SERVICE);
        menu1.setValueColor(Color.parseColor("#999999"));
        menu3.setValueColor(Color.parseColor("#999999"));
        menu4.setValueColor(Color.parseColor("#999999"));
        menu5.setValueColor(Color.parseColor("#999999"));
        menu6.setValueColor(Color.parseColor("#999999"));
        openWechatService.setValueColor(Color.parseColor("#999999"));

        menu5.setItemType(ChatManagerItem.CHECK_VERSION_ITEM);
        menu5.setValue(String.format(getString(R.string.current_version), AppUtils.getVersionName(getApplicationContext())));
        openWechatService.setValue(wechatBindStatus == 0 ? "不再错过重要的信息" : "已绑定");
        chatManagerList.add(openWechatService);
        chatManagerList.add(menu1);
        chatManagerList.add(relationAccountNumber);
        chatManagerList.add(menu7);
        chatManagerList.add(menu3);
        chatManagerList.add(menu4);
        chatManagerList.add(menu5);
        chatManagerList.add(menu6);
        ListView listView = findViewById(R.id.listView);
        if (UclientApplication.isLogin(getApplicationContext())) {
            View deleteLayout = getLayoutInflater().inflate(R.layout.quit_account, null);
            TextView quitLayout = deleteLayout.findViewById(R.id.quitLayout);
            quitLayout.setOnClickListener(new OnClickListener() {
                @Override
                public void onClick(View v) {
                    if (StrUtil.isFastDoubleClick()) {
                        return;
                    }
                    DialogLeftRightBtnConfirm dialogLeftRightBtnConfirm = new DialogLeftRightBtnConfirm(SetActivity.this, null,
                            "退出后不会删除任何历史数据，下次登录依然可以使用本账号。", new DialogLeftRightBtnConfirm.LeftRightBtnListener() {
                        @Override
                        public void clickLeftBtnCallBack() {

                        }

                        @Override
                        public void clickRightBtnCallBack() {
                            requestServiceQuit();
                        }
                    });
                    dialogLeftRightBtnConfirm.setRightBtnText("退出登录");
                    dialogLeftRightBtnConfirm.show();
                }
            });
            listView.addFooterView(deleteLayout, null, false);
        }
        adapter = new ChatManagerAdapter(this, chatManagerList, null);
        listView.setAdapter(adapter);
        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                ChatManagerItem item = adapter.getList().get(position);
                Intent intent = null;
                switch (item.getMenuType()) {
                    case BIND_WX: //绑定微信
                        RelationAccountNumberActivity.actionStart(SetActivity.this);
//                        /**1、状态说明：
//                         （1）未绑定：该用户未绑定微信号；
//                         （2）已绑定：该用户已绑定一个微信号；
//                         2、交互说明：
//                         （1）未绑定：显示提示信息“未绑定”；点击该条信息跳转至微信授权页面；
//                         （2）已绑定：显示提示信息“已绑定”；点击该条信息弹出确认框：确定要解除绑定的微信账号？*/
//                        if (isBindWX) {
//                            DialogTips deleteDialog = new DialogTips(SetActivity.this, new DiaLogTitleListener() {
//                                @Override
//                                public void clickAccess(int position) {
//                                    unBindWxTelphone();
//                                }
//                            }, "确定要解除绑定的微信账号？", -1);
//                            deleteDialog.show();
//                        } else {
//                            new WXUtil().sendWXLogin(SetActivity.this);
//                        }
                        break;
                    case UPDATE_TELPHONE: //修改电话号码
                        UpdateTelFirstNewActivity.actionStart(SetActivity.this);
                        break;
                    case HELP_CENTER: //帮助中心
                        X5WebViewActivity.actionStart(SetActivity.this, NetWorkRequest.HELP_CENTER);
                        break;
//                    case ACCOUNT_MANAGER: //账号管理
//                        intent = new Intent(getApplicationContext(), AccountManagerActivity.class);
//                        break;
                    case ABOUT_US: //关于我们
                        intent = new Intent(getApplicationContext(), X5WebViewActivity.class);
                        intent.putExtra("url", NetWorkRequest.ABOUT_US + "?ver=" + AppUtils.getVersionName(getApplicationContext()));
                        break;
                    case CONTACTS_US: //联系我们
                        intent = new Intent(getApplicationContext(), X5WebViewActivity.class);
                        intent.putExtra("url", NetWorkRequest.CONTACT + "?ver=" + AppUtils.getVersionName(getApplicationContext()));
                        break;
                    case CHECKVERSION: //检测版本
                        if (StrUtil.isFastDoubleClick()) {
                            return;
                        }
                        Acp.getInstance(SetActivity.this).request(new AcpOptions.Builder().setPermissions(Manifest.permission.READ_PHONE_STATE).build(),
                                new AcpListener() {
                                    @Override
                                    public void onGranted() {
                                        Utils.checkVersionNeedDiaLog(SetActivity.this);
                                    }

                                    @Override
                                    public void onDenied(List<String> permissions) {
                                        CommonMethod.makeNoticeShort(getApplicationContext(), getResources().getString(R.string.permission_close), CommonMethod.ERROR);
                                    }
                                });
                        break;
                    case CLEAR_CACHE: //清空缓存
                        DialogTips clearCacheDialog = new DialogTips(SetActivity.this, new DiaLogTitleListener() {
                            @Override
                            public void clickAccess(int position) {
                                clearAppCache();
                            }
                        }, "你确定要清除缓存吗？", DialogTips.CLEAR_CACHE);
                        clearCacheDialog.setContentCenterGravity();
                        clearCacheDialog.show();
                        break;
                    case OPEN_WECHAT_SERVICE: //开通微信服务
                        OpenWechatServiceActivity.actionStart(SetActivity.this, wechatBindStatus, false);
                        return;
                }
                if (intent != null) {
                    startActivityForResult(intent, Constance.REQUEST);
                }
            }
        });
    }

    /**
     * 获取微信服务绑定状态
     */
    public void getWechatServiceStatus() {
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        CommonHttpRequest.commonRequest(this, NetWorkRequest.CREATE_WX_STATUS, WechatBean.class, CommonHttpRequest.OBJECT, params, false, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                WechatBean wechatBean = (WechatBean) object;
                wechatBindStatus = wechatBean.getStatus();
                openWechatService.setValue(wechatBindStatus == 0 ? "不再错过重要的信息" : "已绑定");
                adapter.notifyDataSetChanged();
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
            }
        });


    }

    /**
     * 退出登录
     */
    public void requestServiceQuit() {
        RequestParams params = RequestParamsToken.getExpandRequestParams(getApplicationContext());
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.LOGOUT, params, new RequestCallBackExpand<String>() {
            @Override
            public void onSuccess(ResponseInfo<String> responseInfo) {
                closeDialog();
                DataUtil.removeUserLoginInfo(SetActivity.this);
                setResult(Constance.EXIT_LOGIN);
                finish();
            }
        });
    }

    /**
     * 进入当前模块检测App是否有更新
     */
    public void AutoCheckVersion() {
        String httpUrl = NetWorkRequest.CHECK_VERSION;
        RequestParams params = RequestParamsToken.getExpandRequestParams(getApplicationContext());
        params.addBodyParameter("os", "A");// 密码
        params.addBodyParameter("version", AppUtils.getVersionName(getApplicationContext()) + "");// 版本号
        params.addBodyParameter("client_type", "person");// 客户端 为个人版
        params.addBodyParameter("device_id", AppUtils.getImei(getApplicationContext()));// imei
        CommonHttpRequest.commonRequest(this, httpUrl, Version.class, CommonHttpRequest.OBJECT, params, false, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                Version version = (Version) object;
                if (!TextUtils.isEmpty(version.getDownloadLink())) {
                    setVersionValue(true);
                }
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {

            }
        });
    }


    /**
     * 开启子线程计算并获取App缓存大小
     */
    public void getAppCache() {
        new Thread(new Runnable() {
            @Override
            public void run() {
                try {
                    final String cacheSize = DataCleanManager.getImageLoaderTotalCacheSize(SetActivity.this);
                    runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            setItemValue(CLEAR_CACHE, String.format(getString(R.string.cache_size), cacheSize));
                        }
                    });
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }).start();
    }

    /**
     * 清空App缓存
     */
    private void clearAppCache() {
        final CustomProgress dialog = new CustomProgress(this);
        dialog.show(this, "正在为你清除缓存", false);
        new Thread(new Runnable() {
            @Override
            public void run() {
                DataCleanManager.deleteDir(new File(Environment.getExternalStorageDirectory(), DataCleanManager.IMAGELOADER_PERSONL_CACHE));
                DataCleanManager.deleteDir(new File(Environment.getExternalStorageDirectory(), DataCleanManager.IMAGELOADER_CACHE));
                DataCleanManager.deleteDir(new File(Environment.getExternalStorageDirectory(), DataCleanManager.REPOSITORY_FILE));
                DataCleanManager.deleteDir(getApplicationContext().getCacheDir());
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        setItemValue(CLEAR_CACHE, String.format(getString(R.string.cache_size), "0M"));
                        dialog.closeDialog();
                        CommonMethod.makeNoticeShort(getApplicationContext(), "缓存已清除", CommonMethod.SUCCESS);
                    }
                });
            }
        }).start();
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

    public void setVersionValue(boolean isNewVersion) {
        for (ChatManagerItem bean : adapter.getList()) {
            if (bean.getMenuType() == CHECKVERSION) {
                bean.setNewVersion(isNewVersion);
                adapter.notifyDataSetChanged();
                return;
            }
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
                //1已经绑定，false不隐藏右边按钮
                relationAccountNumber.setHideRightImage(loginStatu.getIs_bind() == 1 ? false : true);
                adapter.notifyDataSetChanged();
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
                finish();
            }
        });
    }


//    /**
//     * 微信解除电话号码绑定
//     */
//    public void unBindWxTelphone() {
//        String httpUrl = NetWorkRequest.UN_BIND_WX;
//        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
//        CommonHttpRequest.commonRequest(this, httpUrl, LoginStatu.class, CommonHttpRequest.OBJECT, params, true, new CommonHttpRequest.CommonRequestCallBack() {
//            @Override
//            public void onSuccess(Object object) {
//                LoginStatu loginStatu = (LoginStatu) object;
//                boolean isBind = loginStatu.getIs_bind() == 0 ? false : true;
//                setItemValue(BIND_WX, isBind ? "已绑定" : "未绑定");
//                isBindWX = isBind;
//                if (!isBind) {
//                    CommonMethod.makeNoticeLong(getApplicationContext(), "微信绑定解除成功！", CommonMethod.SUCCESS);
//                }
//            }
//
//            @Override
//            public void onFailure(HttpException exception, String errormsg) {
//                finish();
//            }
//        });
//    }

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
                setItemValue(BIND_WX, isBind ? "已绑定" : "未绑定");
                isBindWX = isBind;
            }

            @Override
            public void onFailure(HttpException e, String s) {

            }
        });
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (resultCode == Constance.LOGIN_SUCCESS) { //通过绑定微信成功后的回调 直接去到首页
            getWXBindTelphoneStatus(); //重新获取微信状态
        } else if (resultCode == Constance.OPEN_WECHAT_WERVICE) { //开通微信服务
            wechatBindStatus = data.getIntExtra(Constance.BEAN_INT, 0);
            LUtils.e("------------开通微信服务-------------" + wechatBindStatus);
            openWechatService.setValue(wechatBindStatus == 0 ? "不再错过重要的信息" : "已绑定");
            adapter.notifyDataSetChanged();
        } else if (resultCode == Constance.BIND_WECHAT) { //绑定微信
            boolean isHide = data.getBooleanExtra(Constance.BEAN_BOOLEAN, true);
            //1已经绑定，false不隐藏右边按钮
            relationAccountNumber.setHideRightImage(isHide);
            adapter.notifyDataSetChanged();
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
                wxLogin(unionid);
            }
        }
    }

}