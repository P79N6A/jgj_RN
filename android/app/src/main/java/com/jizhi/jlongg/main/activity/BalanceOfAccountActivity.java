package com.jizhi.jlongg.main.activity;

import android.Manifest;
import android.app.Activity;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.support.v4.app.ActivityCompat;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.Gravity;
import android.view.TextureView;
import android.view.View;
import android.widget.ListView;
import android.widget.TextView;

import com.hcs.cityslist.widget.ClearEditText;
import com.hcs.uclient.utils.CallPhoneUtil;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.adpter.BalanceOfAccountAdapter;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.GroupMemberInfo;
import com.jizhi.jlongg.main.bean.Share;
import com.jizhi.jlongg.main.dialog.CustomShareDialog;
import com.jizhi.jlongg.main.util.BackGroundUtil;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SearchMatchingUtil;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;

import java.util.ArrayList;
import java.util.List;

/**
 * 开启对账详情
 *
 * @author Xuj
 * @time 2019年2月15日9:56:41
 * @Version 1.0
 */
public class BalanceOfAccountActivity extends BaseActivity {
    /**
     * 列表适配器
     */
    private BalanceOfAccountAdapter adapter;
    /**
     * 筛选文字
     */
    private String matchString;
    /**
     * 列表数据
     */
    private ArrayList<GroupMemberInfo> list;

    /**
     * 启动当前Activity
     *
     * @param context
     */
    public static void actionStart(Activity context) {
        Intent intent = new Intent(context, BalanceOfAccountActivity.class);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.listview_sidebar_search);
        initView();
        getData();
    }


    private void initView() {
        setTextTitle(R.string.balance_of_account_title);
        findViewById(R.id.sidrbar).setVisibility(View.GONE);
        TextView defaultDesc = findViewById(R.id.defaultDesc);
        defaultDesc.setText("暂无记录哦~");
        ClearEditText mClearEditText = (ClearEditText) findViewById(R.id.filterEdit);
        // 根据输入框输入值的改变来过滤搜索
        mClearEditText.setHint("请输入姓名或手机号查找");
        mClearEditText.addTextChangedListener(new TextWatcher() {
            @Override
            public void onTextChanged(CharSequence inputText, int start, int before, int count) {
                filterData(inputText.toString());
            }

            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {
            }

            @Override
            public void afterTextChanged(Editable s) {
            }
        });
    }

    /**
     * 搜索框 筛选数据
     *
     * @param mMatchString
     */
    private synchronized void filterData(final String mMatchString) {
        if (adapter == null || list == null || list.size() == 0) {
            return;
        }
        matchString = mMatchString;
        new Thread(new Runnable() {
            @Override
            public void run() {
                final List<GroupMemberInfo> filterDataList = SearchMatchingUtil.match(GroupMemberInfo.class, list, matchString);
                if (mMatchString.equals(matchString)) {
                    runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            adapter.setFilterValue(mMatchString);
                            adapter.updateListView(filterDataList);
                        }
                    });
                }
            }
        }).start();
    }


    /**
     * 获取对账成员列表
     */
    public void getData() {
        String httpUrl = NetWorkRequest.WORKDAY_PARTNER_LIST;
        RequestParams params = RequestParamsToken.getExpandRequestParams(getApplicationContext());
        CommonHttpRequest.commonRequest(this, httpUrl, GroupMemberInfo.class, CommonHttpRequest.LIST, params, false, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                setAdapter((ArrayList<GroupMemberInfo>) object);
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
                finish();
            }
        });
    }

    private void setAdapter(ArrayList<GroupMemberInfo> list) {
        this.list = list;
        if (TextUtils.isEmpty(matchString)) {
            findViewById(R.id.input_layout).setVisibility(list != null && !list.isEmpty() ? View.VISIBLE : View.GONE);
        }
        Utils.setPinYinAndSort(list);
        if (adapter == null) {
            ListView listView = findViewById(R.id.listView);
            listView.setEmptyView(findViewById(R.id.defaultLayout));
            adapter = new BalanceOfAccountAdapter(this, list, new BalanceOfAccountAdapter.BalanceOfAccountListener() {
                @Override
                public void callPhone(String telephone) { //拨打电话
                    CallPhoneUtil.call(BalanceOfAccountActivity.this, telephone);
                }

                @Override
                public void inviteRegister() { //邀请朋友注册
                    if (Build.VERSION.SDK_INT >= 23) {
                        String[] mPermissionList = new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE, Manifest.permission.ACCESS_FINE_LOCATION, Manifest.permission.CALL_PHONE, Manifest.permission.READ_LOGS, Manifest.permission.READ_PHONE_STATE, Manifest.permission.WRITE_EXTERNAL_STORAGE, Manifest.permission.SET_DEBUG_APP, Manifest.permission.SYSTEM_ALERT_WINDOW, Manifest.permission.GET_ACCOUNTS, Manifest.permission.WRITE_APN_SETTINGS};
                        ActivityCompat.requestPermissions(BalanceOfAccountActivity.this, mPermissionList, Constance.REQUEST);
                    } else {
                        showShareDialog();
                    }
                }

                @Override
                public void confirmAccount(String uid) {
                    RecordWorkConfirmActivity.actionStart(BalanceOfAccountActivity.this, null, uid, null);
                }
            });
            listView.setAdapter(adapter);
        } else {
            adapter.updateListView(list);//替换数据
        }
    }

    /**
     * 分享弹窗
     */
    public void showShareDialog() {
        Share share = new Share();
        share.setTitle("记工账本怕丢失？吉工家手机记工更安全！用吉工家记工，账本永不丢失！");
        share.setDescribe("1200万建筑工友都在用！海量工作任你挑，实名招工更靠谱！");
        share.setUrl(NetWorkRequest.WEBURLS + "page/open-invite.html?uid=" + UclientApplication.getUid(BalanceOfAccountActivity.this) + "&plat=person");
        share.setImgUrl(NetWorkRequest.IP_ADDRESS + "media/default_imgs/logo.jpg");
        //微信小程序相关内容
        share.setAppId("gh_89054fe67201");
        share.setPath("/pages/work/index?suid=" + UclientApplication.getUid(BalanceOfAccountActivity.this));
        share.setWxMiniDrawable(2);

        new CustomShareDialog(BalanceOfAccountActivity.this, true, share).showAtLocation(getWindow().getDecorView(), Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0);
        BackGroundUtil.backgroundAlpha(BalanceOfAccountActivity.this, 0.5F);
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, String permissions[], int[] grantResults) {
        if (requestCode == Constance.REQUEST) {
            showShareDialog();
        }
    }


}