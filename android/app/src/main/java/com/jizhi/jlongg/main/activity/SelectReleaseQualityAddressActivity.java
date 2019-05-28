package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ListView;

import com.hcs.cityslist.widget.CharacterParser;
import com.hcs.cityslist.widget.ClearEditText;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.adpter.SelectReleaseAdapter;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;
import com.jizhi.jlongg.main.bean.PersonBean;
import com.jizhi.jlongg.main.bean.QualitySafeLocation;
import com.jizhi.jlongg.main.bean.status.CommonListJson;
import com.jizhi.jlongg.main.dialog.DialogOnlyTextDesc;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DataUtil;
import com.jizhi.jlongg.main.util.PinYin2Abbreviation;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SetTitleName;
import com.jizhi.jlongg.main.util.SingsHttpUtils;
import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.ViewUtils;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.client.HttpRequest;
import com.lidroid.xutils.view.annotation.ViewInject;

import java.util.ArrayList;
import java.util.List;

import static com.jizhi.jlongg.network.NetWorkRequest.getQualitySafeLocation;

/**
 * 功能: 选择质量，安全地址
 * 作者：胡常生
 * 时间: 2017年5月27日 11:10:12
 */
public class SelectReleaseQualityAddressActivity extends BaseActivity implements DialogOnlyTextDesc.CloseListener, View.OnClickListener {

    /* listView */
    @ViewInject(R.id.listView)
    private ListView listView;
    /* 添加工人、工头列表适配器 */
    private SelectReleaseAdapter adapter;
    /* 列表数据,模糊搜索数据 */
    private List<QualitySafeLocation> list;
    /* 汉字转换成拼音的类 */
    private CharacterParser characterParser;
    /* 显示筛选数据 */
    private final int VISIBLEFILTER = 1;
    /* 隐藏筛选数据 */
    private final int GONEFILTER = 2;
    /* 当前是否正在删除数据 */
    private boolean isDel;
    /* 搜索框输入的文字 */
    private String fileterStr;
    private SelectReleaseQualityAddressActivity mActivity;
    private ClearEditText mClearEditText;
    //组信息
    private GroupDiscussionInfo gnInfo;
    //选择位置编号
    private int addr_id;
    public static final String ADDRID = "addr_id";


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_select_release_address);
        ViewUtils.inject(this);
        initView();
        getIntentData();
        searchData();
    }

    /**
     * 初始化
     */
    public void initView() {
        mClearEditText = (ClearEditText) findViewById(R.id.filterEdit);
        findViewById(R.id.sidrbar).setVisibility(View.GONE);
        characterParser = CharacterParser.getInstance();
        mClearEditText.setHint("请输入隐患部位名称");
        SetTitleName.setTitle(findViewById(R.id.title), getString(R.string.address_release));
        SetTitleName.setTitle(findViewById(R.id.right_title), "确定");
        mActivity = SelectReleaseQualityAddressActivity.this;
        // 根据输入框输入值的改变来过滤搜索
        mClearEditText.addTextChangedListener(new TextWatcher() {
            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                // 当输入框里面的值为空，更新为原来的列表，否则为过滤数据列表
                filterData(s.toString());
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
                clearSelctedState();
                QualitySafeLocation personBean = adapter.getList().get(position);
                addr_id = personBean.getId();
                mClearEditText.setText(personBean.getText());
            }
        });
    }

    /**
     * 获取传递过来的数据
     */
    private void getIntentData() {
        gnInfo = (GroupDiscussionInfo) getIntent().getSerializableExtra(("gnInfo"));
    }

    /**
     * 启动当前Acitivyt
     *
     * @param context
     */
    public static void actionStart(Activity context, GroupDiscussionInfo gnInfo) {
        Intent intent = new Intent(context, SelectReleaseQualityAddressActivity.class);
        intent.putExtra("gnInfo", gnInfo);
//        intent.putExtra("people_uid", people_uid);
//        intent.putExtra(Constance.BEAN_CONSTANCE, type);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    /**
     * 搜索联系人
     *
     * @param mFileterStr
     */
    private synchronized void filterData(final String mFileterStr) {
        new Thread(new Runnable() {
            @Override
            public void run() {
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        if (!TextUtils.isEmpty(mFileterStr) && adapter != null && list != null && list.size() > 0) {
                            fileterStr = mFileterStr;
                            List<QualitySafeLocation> filterDataList = new ArrayList<>();
                            for (QualitySafeLocation bean : list) {
                                String name = bean.getText();
//                                String telphone = bean.getTelph();
                                if (name.indexOf(mFileterStr) != -1 || characterParser.getSelling(name).startsWith(mFileterStr)) {
                                    filterDataList.add(bean);
                                }
                            }
                            if (mFileterStr.equals(fileterStr)) {
                                adapter.setFilterValue(mFileterStr);
                                adapter.updateListView(filterDataList);
                            }
                        } else {
                            if (null == adapter) {
                                return;
                            }
                            adapter.setFilterValue("");
                            adapter.updateListView(new ArrayList<QualitySafeLocation>());
                        }
                    }
                });
            }
        }).start();
    }

    public Handler mHandler = new Handler() {
        public void handleMessage(Message msg) {
            switch (msg.what) {
                case VISIBLEFILTER:
                    Bundle bundle = msg.getData();
                    String filter = bundle.getString(Constance.BEAN_STRING, "");
                    if (!filter.equals(fileterStr)) {
                        return;
                    }
                    List<QualitySafeLocation> filterList = (List<QualitySafeLocation>) bundle.getSerializable(Constance.BEAN_ARRAY);
                    adapter.updateListView(filterList);
                    break;
                case GONEFILTER:
                    adapter.updateListView(list);
                    break;
                default:
                    break;
            }
            super.handleMessage(msg);
        }
    };


    /**
     * 查询历史地址
     */
    public void searchData() {
        HttpUtils http = SingsHttpUtils.getHttp();
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        params.addBodyParameter("group_id", gnInfo.getGroup_id());
        params.addBodyParameter("class_type", gnInfo.getClass_type());
        http.send(HttpRequest.HttpMethod.POST, getQualitySafeLocation,
                    params, new RequestCallBackExpand<String>() {
                        @Override
                        public void onSuccess(ResponseInfo<String> responseInfo) {
                            try {
                                CommonListJson<QualitySafeLocation> bean = CommonListJson.fromJson(responseInfo.result, QualitySafeLocation.class);
                                if (bean.getState() != 0) {
                                    if (bean.getValues() != null && bean.getValues().size() > 0) {//当返回数据小于0 并且 为空的时候 则显示 添加工人界面
                                        list = bean.getValues();
                                        if (!TextUtils.isEmpty(getIntent().getStringExtra("people_uid"))) {
                                            sortcurrentList();
                                        }
                                        adapter = new SelectReleaseAdapter(mActivity, new ArrayList<QualitySafeLocation>());
                                        listView.setAdapter(adapter);
                                    }
                                } else {
                                    DataUtil.showErrOrMsg(SelectReleaseQualityAddressActivity.this, bean.getErrno(), bean.getErrmsg());
                                    finish();
                                }
                            } catch (Exception e) {
                                e.printStackTrace();
                                CommonMethod.makeNoticeShort(SelectReleaseQualityAddressActivity.this, getString(R.string.service_err), CommonMethod.ERROR);
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


    /**
     * 清除选中状态
     */
    public void clearSelctedState() {
        if (list == null) {
            return;
        }
        for (QualitySafeLocation p : list) {
            p.setChecked(false);
            p.setSortLetters(PinYin2Abbreviation.cn2py(p.getText().substring(0, 1)).toUpperCase());
            break;
        }
    }


    public void setChecked(PersonBean bean) {
        bean.setSortLetters("@");
        bean.setIsChecked(true);
    }

    /**
     * 当前list排序
     */
    public void sortcurrentList() {
        removeEmptyNamePerson();
        if (list != null && list.size() > 0) {
            Utils.setPinYinAndSortPersonAddr(list);
        }
    }


    @Override
    public void callBack(int position) {
    }


    /**
     * 清除名字为空的对象
     */
    private void removeEmptyNamePerson() {
        int size = list.size();
        for (int i = 0; i < size; i++) {
            if (TextUtils.isEmpty(list.get(i).getText())) {
                list.remove(i);
                removeEmptyNamePerson();
                return;
            }
        }
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.right_title:
                if (!TextUtils.isEmpty(mClearEditText.getText().toString().trim())) {
                    Intent intent = new Intent();
                    intent.putExtra(ReleaseQualityAndSafeActivity.VALUE, mClearEditText.getText().toString().trim());
                    intent.putExtra(SelectReleaseQualityAddressActivity.ADDRID, addr_id);
                    setResult(ReleaseQualityAndSafeActivity.PROJECT_ADDRESS, intent);
                    finish();
                }
                break;
        }
    }
}
