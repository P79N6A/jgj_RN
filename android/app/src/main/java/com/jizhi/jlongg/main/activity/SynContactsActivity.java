package com.jizhi.jlongg.main.activity;

import android.Manifest;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.support.annotation.NonNull;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.View;
import android.widget.ListView;
import android.widget.TextView;

import com.hcs.cityslist.widget.ClearEditText;
import com.hcs.cityslist.widget.SideBar;
import com.hcs.uclient.utils.ReadAddressBook;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.adpter.SynContactsAdatper;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.GroupMemberInfo;
import com.jizhi.jlongg.main.bean.SynBill;
import com.jizhi.jlongg.main.dialog.DiaLogAddAccountPerson;
import com.jizhi.jlongg.main.dialog.DiaLogAddSynPerson;
import com.jizhi.jlongg.main.listener.AddSynchPersonListener;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.MessageUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SearchMatchingUtil;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;

import java.util.List;

/**
 * 功能:同步账单
 * 作者：xuj
 * 时间: 2016-5-9 15:37
 */
public class SynContactsActivity extends BaseActivity implements View.OnClickListener, AddSynchPersonListener {

    /**
     * listView 适配器
     */
    private SynContactsAdatper adapter;
    /**
     * 列表数据
     */
    private List<SynBill> list;
    /**
     * listView
     */
    private ListView listView;
    /**
     * 筛选文字
     */
    private String matchString;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.syn_contacts);
        initView();
        if (Build.VERSION.SDK_INT >= 23) {
            requestContactsPermission();
        } else {
            getConstanct();
        }
    }

    private void initView() {
        setTextTitleAndRight(R.string.contacts_title, R.string.add);
        listView = (ListView) findViewById(R.id.listView);
        TextView center_text = getTextView(R.id.center_text);
        SideBar sideBar = (SideBar) findViewById(R.id.sidrbar);
        sideBar.setTextView(center_text);
        // 设置右侧触摸监听
        sideBar.setOnTouchingLetterChangedListener(new SideBar.OnTouchingLetterChangedListener() {
            @Override
            public void onTouchingLetterChanged(String s) {
                if (adapter != null) {
                    //该字母首次出现的位置
                    int position = adapter.getPositionForSection(s.charAt(0));
                    if (position != -1) {
                        listView.setSelection(position);
                    }
                }
            }
        });
        ClearEditText mClearEditText = (ClearEditText) findViewById(R.id.filterEdit);
        mClearEditText.setHint("请输入姓名或手机号查找");
        // 根据输入框输入值的改变来过滤搜索
        mClearEditText.addTextChangedListener(new TextWatcher() {
            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                filterData(s.toString());
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
     * android 6.0需要动态检测权限
     */
    public void requestContactsPermission() {
        //检查权限
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.READ_CONTACTS) != PackageManager.PERMISSION_GRANTED) {
            //进入到这里代表没有权限.
            ActivityCompat.requestPermissions(this, new String[]{Manifest.permission.READ_CONTACTS}, Constance.CHECKSELFPERMISSION);
        } else {
            getConstanct();
        }
    }

    /**
     * 检测权限之后的回调
     *
     * @param requestCode
     * @param permissions
     * @param grantResults
     */
    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        switch (requestCode) {
            case Constance.CHECKSELFPERMISSION:
                if (grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {//用户同意授权
                    getConstanct();
                } else {//用户拒绝授权
                    finish();
                }
                break;
        }
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
                final List<SynBill> filterDataList = SearchMatchingUtil.match(SynBill.class, list, matchString);
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


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.right_title: //新增同步人
                final DiaLogAddSynPerson dialog = new DiaLogAddSynPerson(this, SynContactsActivity.this);
                dialog.setGetRealNameListener(new DiaLogAddAccountPerson.InputTelphoneGetRealNameListener() {
                    @Override
                    public void accordingTelgetRealName(String telephone) {
                        MessageUtil.useTelGetUserInfo(SynContactsActivity.this, telephone, new CommonHttpRequest.CommonRequestCallBack() {
                            @Override
                            public void onSuccess(Object object) {
                                GroupMemberInfo info = (GroupMemberInfo) object;
                                if (info != null) {
                                    dialog.setUserName(info.getReal_name());
                                }
                            }

                            @Override
                            public void onFailure(HttpException exception, String errormsg) {

                            }
                        });
                    }
                });
                dialog.openKeyBoard();
                dialog.show();
                break;
        }
    }


    /**
     * 添加人员信息
     */
    @Override
    public void add(final String realname, final String telph, final String descript, final int position) {
        if (telph.equals(UclientApplication.getLoginTelephone(getApplicationContext()))) {
            CommonMethod.makeNoticeShort(getApplicationContext(), getString(R.string.add_fail), CommonMethod.ERROR);
            return;
        }
        List<SynBill> list = this.list;
        if (list != null && list.size() > 0) {
            for (SynBill synBill : list) {
                String tel = synBill.getTelephone();//获取同步对象电话号码
                if (tel.equals(telph) && synBill.getTarget_uid() != 0) {
                    Intent intent = new Intent(getApplicationContext(), SynchProjectListActivity.class);
                    intent.putExtra(Constance.BEAN_CONSTANCE, synBill);
                    startActivityForResult(intent, Constance.REQUEST);
                    finish();
                    return;
                }
            }
        }
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        params.addBodyParameter("realname", realname); //姓名
        params.addBodyParameter("telph", telph); //电话号码
        if (!TextUtils.isEmpty(descript)) {
            params.addBodyParameter("descript", descript); //备注
        }
        params.addBodyParameter("option", "a"); //如果是添加传a，如果是修改传u
        String httpUrl = NetWorkRequest.OPTUSERSYN;
        CommonHttpRequest.commonRequest(SynContactsActivity.this, httpUrl, SynBill.class,
                CommonHttpRequest.OBJECT, params, true, new CommonHttpRequest.CommonRequestCallBack() {
                    @Override
                    public void onSuccess(Object object) {


//                        SynBill synch = new SynBill();
//                        synch.setReal_name(realname);
//                        synch.setTelephone(telph);
//                        synch.setDescript(descript);
//                        synch.setTarget_uid(bean.getValues().getTarget_uid());
//                        if (getIntent().getBooleanExtra(Constance.BEAN_BOOLEAN, false)) { //是否是同步多个对象
//                            Intent intent = getIntent();
//                            intent.putExtra(Constance.BEAN_CONSTANCE, synch);
//                            setResult(Constance.ADD_SUCCESS, intent);
//                            finish();
//                        } else {
//                            Intent intent = new Intent(getApplicationContext(), SynchProjectListActivity.class);
//                            intent.putExtra(Constance.BEAN_CONSTANCE, synch);
//                            startActivityForResult(intent, Constance.REQUEST);
//                        }
                    }

                    @Override
                    public void onFailure(HttpException exception, String errormsg) {

                    }
                });
    }


    /**
     * 获取通讯录数据
     */
    public void getConstanct() {
        new Thread(new Runnable() {
            @Override
            public void run() {
                mHandler.sendEmptyMessage(LOADING);
                Intent intent = getIntent();
                final List<SynBill> serverList = (List<SynBill>) intent.getSerializableExtra(Constance.BEAN_ARRAY); //同步的项目
                List<SynBill> contactList = ReadAddressBook.getLocalContactsInfos(SynContactsActivity.this, false); //读取本地通讯录
                if (serverList != null && serverList.size() > 0) {
                    for (SynBill s : serverList) {
                        s.setAdd(true);
                    }
                    list = serverList;
                    if (contactList != null && contactList.size() > 0) {
                        int size = contactList.size();
                        for (int i = 0; i < size; i++) {
                            SynBill contact = contactList.get(i);
                            boolean isExist = false;
                            for (SynBill server : serverList) {
                                if (contact.getTelephone().equals(server.getTelephone())) { //本地通讯录号码与传递过来的号码是否相同
                                    isExist = true;
                                    break;
                                }
                            }
                            if (!isExist) {
                                list.add(contact);
                            }
                        }
                    }
                } else {
                    list = contactList;
                }
                mHandler.sendEmptyMessage(LOADED_FINISH);
            }
        }).start();
    }

    /**
     * 加载中
     */
    private final int LOADING = 1;
    /**
     * 加载完毕
     */
    private final int LOADED_FINISH = 2;


    public Handler mHandler = new Handler() {
        public void handleMessage(Message msg) {
            switch (msg.what) {
                case LOADED_FINISH: //数据加载完毕
                    Utils.setPinYinAndSortSynch(list);
                    adapter = new SynContactsAdatper(SynContactsActivity.this, list, SynContactsActivity.this);
                    listView.setAdapter(adapter);
                    closeDialog();
                    break;
                case LOADING: //加载对话框
                    createCustomDialog();
                    break;
                default:
                    break;
            }
        }
    };


    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == Constance.REQUEST_ADD) { //刷新数据
            switch (resultCode) {
                case Constance.RESULTCODE_CHANGFSYNCHOBJECT: //编辑按钮
                    setResult(Constance.RESULTCODE_CHANGFSYNCHOBJECT, getIntent());
                    break;
                case Constance.DELETE_SUCCESS://删除联系人
                    setResult(Constance.RESULTCODE_DELETEPEOPLE, getIntent());
                    break;
            }
        }
        finish();
    }
}
