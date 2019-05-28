package com.jizhi.jlongg.main.activity;

import android.Manifest;
import android.annotation.TargetApi;
import android.app.Activity;
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
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.TextView;

import com.hcs.cityslist.widget.ClearEditText;
import com.hcs.cityslist.widget.SideBar;
import com.hcs.uclient.utils.ReadAddressBook;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.emoji.emotionkeyboard.EmojiUtil;
import com.jizhi.jlongg.main.adpter.RecordContactsAdatper;
import com.jizhi.jlongg.main.bean.PersonBean;
import com.jizhi.jlongg.main.dialog.DiaLogAddMember;
import com.jizhi.jlongg.main.dialog.DialogRemoveContactsEmoji;
import com.jizhi.jlongg.main.listener.AddSynchPersonListener;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.PinYin2Abbreviation;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SearchMatchingUtil;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;

import java.util.ArrayList;
import java.util.List;

/**
 * 功能:新增联系人
 * 作者：xuj
 * 时间: 2016-5-9 15:37
 */
public class AddContactsActivity extends BaseActivity {

    /**
     * listView 适配器
     */
    private RecordContactsAdatper adapter;
    /**
     * 列表数据
     */
    private List<PersonBean> list;
    /**
     * listView
     */
    private ListView listView;
    /**
     * 初始化加载
     */
    private final int LOADING = 1;
    /**
     * 加载完毕
     */
    private final int LOADED_FINISH = 2;
    /**
     * 筛选文字
     */
    private String matchString;

    /**
     * 添加方式
     * 1表示记账对象
     * 2表示同步对象
     */
    private int addType;

    /**
     * 启动当前Activity
     *
     * @param context
     * @param list
     * @param addType 添加方式1.表示记账对象,2.表示同步对象 3.表示记账对象承包对象
     */
    public static void actionStart(Activity context, ArrayList<PersonBean> list, int addType) {
        Intent intent = new Intent(context, AddContactsActivity.class);
        intent.putExtra(Constance.BEAN_ARRAY, list);
        intent.putExtra("addType", addType);
        context.startActivityForResult(intent, Constance.REQUEST);
    }


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.syn_contacts);
        initView();
        if (Build.VERSION.SDK_INT >= 23) {
            requestContactsPermission();
        } else {
            compareContact();
        }
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
            compareContact();
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
                if (grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                    //用户同意授权
                    compareContact();
                } else {
                    //用户拒绝授权
                    AddContactsActivity.this.finish();
                }
                break;
        }
    }


    private void initView() {
        setTextTitle(R.string.contacts_title);
        addType = getIntent().getIntExtra("addType", 1);
        TextView center_text = getTextView(R.id.center_text);
        listView = (ListView) findViewById(R.id.listView);
        SideBar sideBar = (SideBar) findViewById(R.id.sidrbar);
        ClearEditText mClearEditText = (ClearEditText) findViewById(R.id.filterEdit);
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
        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                PersonBean personBean = adapter.getItem(position);
                if (personBean.isChecked()) { //已添加的成员,直接返回
                    Intent intent = getIntent();
                    intent.putExtra(Constance.BEAN_CONSTANCE, personBean);
                    setResult(Constance.RESULTCODE_ADDCONTATS, intent);
                    finish();
                } else {
                    addPerson(personBean.getName(), personBean.getTelph());
                }
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
                final List<PersonBean> filterDataList = SearchMatchingUtil.match(PersonBean.class, list, matchString);
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
     * 比较通讯录数据
     */
    public void compareContact() {
        new Thread(new Runnable() {
            @Override
            public void run() {
                List<PersonBean> mList = (List<PersonBean>) getIntent().getSerializableExtra(Constance.BEAN_ARRAY); //已添加的对象
                mHandler.sendEmptyMessage(LOADING);
                List<PersonBean> contactsList = ReadAddressBook.getLocalContactsInfos(AddContactsActivity.this, true); //读取本地通讯录
                if (mList != null && mList.size() > 0) {
                    List<PersonBean> persons = new ArrayList<>();
                    for (PersonBean bean : mList) {
                        bean.setIsChecked(true);
                        bean.setSortLetters(PinYin2Abbreviation.getPingYin(bean.getName()).toUpperCase());
                        persons.add(bean);
                    }
                    if (contactsList != null && contactsList.size() > 0) {
                        for (PersonBean contact : contactsList) {
                            boolean isExist = false; //是否已存在
                            for (PersonBean alreadAdd : persons) {
                                if (!TextUtils.isEmpty(contact.getTelph()) && contact.getTelph().equals(alreadAdd.getTelph())) { //本地通讯录号码与传递过来的号码是否相同
                                    isExist = true;
                                    break;
                                }
                            }
                            if (!isExist) {
                                persons.add(contact);
                            }
                        }
                    }
                    list = persons;
                } else {
                    list = contactsList;
                }
                mHandler.sendEmptyMessage(LOADED_FINISH);
            }
        }).start();
    }


    public Handler mHandler = new Handler() {
        @TargetApi(Build.VERSION_CODES.HONEYCOMB_MR1)
        public void handleMessage(Message msg) {
            switch (msg.what) {
                case LOADED_FINISH: //数据加载完毕
                    Utils.setPinYinAndSortPerson(list); //设置拼音首字母 并且排序
                    adapter = new RecordContactsAdatper(AddContactsActivity.this, list, new AddSynchPersonListener() {
                        @Override
                        public void add(final String realName, final String telphone, String descript, int position) {
                            if (EmojiUtil.containsEmoji(realName)) {
                                final DialogRemoveContactsEmoji dialogRemoveContactsEmoji = new DialogRemoveContactsEmoji(AddContactsActivity.this, telphone);
                                dialogRemoveContactsEmoji.setListener(new DiaLogAddMember.AddGroupMemberListener() {
                                    @Override
                                    public void add(String telphone, String realName, String headPic) {
                                        addPerson(realName, telphone);
                                        dialogRemoveContactsEmoji.dismiss();
                                    }
                                });
                                dialogRemoveContactsEmoji.show();
                                return;
                            }
                            addPerson(realName, telphone);
                        }
                    });

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


    public void addPerson(final String realName, final String telphone) {
        if (addType == 1 || addType == 3) {
            CommonHttpRequest.addAccountPerson(AddContactsActivity.this, realName, telphone, addType == 3, new CommonHttpRequest.CommonRequestCallBack() {
                @Override
                public void onSuccess(Object object) {
                    Intent intent = getIntent();
                    intent.putExtra(Constance.BEAN_CONSTANCE, (PersonBean) object);
                    setResult(Constance.RESULTCODE_ADDCONTATS, intent);
                    finish();
                }

                @Override
                public void onFailure(HttpException exception, String errormsg) {

                }
            });
        } else if (addType == 2) {
            final RequestParams params = RequestParamsToken.getExpandRequestParams(getApplicationContext());
            params.addBodyParameter("realname", realName); //姓名
            params.addBodyParameter("telph", telphone); //电话号码
            params.addBodyParameter("option", "a"); //如果是添加传a，如果是修改传u
            String httpUrl = NetWorkRequest.OPTUSERSYN;
            CommonHttpRequest.commonRequest(AddContactsActivity.this, httpUrl, PersonBean.class, CommonHttpRequest.OBJECT, params, true, new CommonHttpRequest.CommonRequestCallBack() {
                @Override
                public void onSuccess(Object object) {
                    PersonBean personBean = (PersonBean) object;
                    personBean.setReal_name(realName);
                    personBean.setTelephone(telphone);
                    personBean.setTelph(telphone);
                    Intent intent = getIntent();
                    intent.putExtra(Constance.BEAN_CONSTANCE, personBean);
                    setResult(Constance.RESULTCODE_ADDCONTATS, intent);
                    finish();
                }

                @Override
                public void onFailure(HttpException exception, String errormsg) {

                }
            });
        }
    }


}
