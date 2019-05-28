package com.jizhi.jlongg.main.activity;

import android.content.Intent;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;

import com.hcs.cityslist.widget.ClearEditText;
import com.hcs.cityslist.widget.SideBar;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.adpter.AddWorkerOrForemanAdapter;
import com.jizhi.jlongg.main.bean.PersonBean;
import com.jizhi.jlongg.main.bean.status.CommonListJson;
import com.jizhi.jlongg.main.dialog.DialogOnlyTextDesc;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DataUtil;
import com.jizhi.jlongg.main.util.PinYin2Abbreviation;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SearchMatchingUtil;
import com.jizhi.jlongg.main.util.SetTitleName;
import com.jizhi.jlongg.main.util.SingsHttpUtils;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.ViewUtils;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.client.HttpRequest;
import com.lidroid.xutils.view.annotation.ViewInject;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;

import static com.jizhi.jlongg.R.id.add_worker;
import static com.jizhi.jlongg.R.id.tv_addworker;
import static com.jizhi.jlongg.R.id.tv_without_workerinfo;

/**
 * 功能:聊天记工选择工人对象
 * 时间:2016/3/11 11:42
 * 作者:xuj
 */
public class SelectWorkToMessageActivity extends BaseActivity implements View.OnClickListener, DialogOnlyTextDesc.CloseListener {

    /* listView */
    @ViewInject(R.id.listView)
    private ListView listView;
    /* 删除按钮 */
    @ViewInject(R.id.right_title)
    private TextView deleteBtn;
    /* 添加工人、工头列表适配器 */
    private AddWorkerOrForemanAdapter adapter;
    /* 列表数据,模糊搜索数据 */
    private List<PersonBean> list;
    /* 当前是否正在删除数据 */
    private boolean isDel;
    /* 搜索框输入的文字 */
    private String matchString;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.add_worker_foreman_listview);
        ViewUtils.inject(this);
        initView();
        searchData();
    }


    /**
     * 初始化
     */
    public void initView() {
        ClearEditText mClearEditText = (ClearEditText) findViewById(R.id.filterEdit);
        SideBar sideBar = (SideBar) findViewById(R.id.sidrbar);
        getTextView(tv_addworker).setVisibility(View.GONE);
        TextView center_text = getTextView(R.id.center_text);
        ImageView rightImage = getImageView(R.id.rightImage);
        getButton(add_worker).setVisibility(View.GONE); //添加按钮
        rightImage.setImageResource(R.drawable.red_add);
        mClearEditText.setHint("请输入姓名或手机号查找");
        SetTitleName.setTitle(findViewById(R.id.title), getString(R.string.add_worker));
        getTextView(tv_without_workerinfo).setText(getString(R.string.without_workerinfo));
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
                PersonBean personBean = adapter.getList().get(position);
                setChecked(personBean);
                returnParameter(personBean);
            }
        });
    }


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


    public RequestParams params(String name, String telphone) {
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        if (!TextUtils.isEmpty(name)) { //添加人员所需参数
            params.addBodyParameter("name", name); //姓名
            params.addBodyParameter("telph", telphone); //电话号码
        }
        params.addBodyParameter("group_id", getIntent().getStringExtra(Constance.GROUP_ID));
        return params;
    }

    /**
     * 查询班组长/工头信息
     */
    public void searchData() {
        HttpUtils http = SingsHttpUtils.getHttp();
        String group = getIntent().getStringExtra(Constance.GROUP_ID);
        http.send(HttpRequest.HttpMethod.POST, TextUtils.isEmpty(group) ? NetWorkRequest.JLWORKDAY : NetWorkRequest.BILLGROUPLIST,
                    params(null, null), new RequestCallBackExpand<String>() {
                        @Override
                        public void onSuccess(ResponseInfo<String> responseInfo) {
                            try {
                                CommonListJson<PersonBean> bean = CommonListJson.fromJson(responseInfo.result, PersonBean.class);
                                if (bean.getState() != 0) {
                                    if (bean.getValues() != null && bean.getValues().size() > 0) {//当返回数据小于0 并且 为空的时候 则显示 添加工人界面
                                        createList(bean.getValues());
                                    } else {
                                        showDefaultLayout();
                                    }
                                } else {
                                    DataUtil.showErrOrMsg(SelectWorkToMessageActivity.this, bean.getErrno(), bean.getErrmsg());
                                    finish();
                                }
                            } catch (Exception e) {
                                e.printStackTrace();
                                CommonMethod.makeNoticeShort(SelectWorkToMessageActivity.this, getString(R.string.service_err), CommonMethod.ERROR);
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
    public void onClick(View v) {
        Intent Intent = new Intent(SelectWorkToMessageActivity.this, AddContactsActivity.class);
        Intent.putExtra(Constance.BEAN_ARRAY, (Serializable) list);
        startActivityForResult(Intent, Constance.REQUESTCODE_ADDCONTATS);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == Constance.RESULTCODE_ADDCONTATS) {
            PersonBean personBean = (PersonBean) data.getSerializableExtra(Constance.BEAN_CONSTANCE);
            boolean isExist = personBean.isChecked();
            clearSelctedState();
            if (!isExist) {
                createList(personBean);
                setChecked(personBean);
            } else {
                for (PersonBean p : list) {
                    if (p.getTelph().equals(personBean.getTelph())) {
                        personBean = p;
                        setChecked(p);
                    }
                }
            }
            returnParameter(personBean);
        }
    }

    private void returnParameter(PersonBean personBean) {
        Intent intent = getIntent();
//        intent.putExtra(Constance.BEAN_INT, personBean.getUid());
//        intent.putExtra(Constance.BEAN_STRING, personBean.getName());
//        intent.putExtra(Constance.BEAN_ARRAY, (Serializable) list);
//        Salary bean = personBean.getTpl();
//        if (bean != null && bean.getO_h_tpl() != 0 && bean.getW_h_tpl() != 0) {
//            intent.putExtra(Constance.BEAN_CONSTANCE, personBean.getTpl());
//        }
        intent.putExtra(Constance.BEAN_CONSTANCE, personBean);
        setResult(Constance.SUCCESS, intent);
        onFinish(null);
    }


    /**
     * 清除选中状态
     */
    public void clearSelctedState() {
        if (list == null) {
            return;
        }
        for (PersonBean p : list) {
            p.setIsChecked(false);
            p.setSortLetters(PinYin2Abbreviation.cn2py(p.getName().substring(0, 1)).toUpperCase());
            break;
        }
    }

    /**
     * 创建list数据
     *
     * @param object
     */
    public void createList(Object object) {
        if (object instanceof List) {
            list = (List<PersonBean>) object;
            sortcurrentList();
            adapter = new AddWorkerOrForemanAdapter(SelectWorkToMessageActivity.this, list, this);
            listView.setAdapter(adapter);
            goneDefaultLayout();
        } else if (object instanceof PersonBean) {
            if (list == null) {
                list = new ArrayList<>();
                adapter = new AddWorkerOrForemanAdapter(SelectWorkToMessageActivity.this, list, this);
                listView.setAdapter(adapter);
            }
            PersonBean bean = (PersonBean) object;
            list.add(bean);
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
            Utils.setPinYinAndSortPerson(list);
        }
    }


    @Override
    public void callBack(int position) {
        delPerson(list.get(position).getUid() + "", position);
    }

    /**
     * 删除联系人
     */
    public void delPerson(String uid, final int positon) {
        if (adapter.getList().get(positon).isChecked()) {
            CommonMethod.makeNoticeShort(this, "当前对象已选中无法删除", CommonMethod.ERROR);
            return;
        }
        HttpUtils http = SingsHttpUtils.getHttp();
        RequestParams params = RequestParamsToken.getExpandRequestParams(SelectWorkToMessageActivity.this);
        params.addBodyParameter("partner", uid);
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.DELFM,
                    params, new RequestCallBackExpand<String>() {
                        @Override
                        public void onSuccess(ResponseInfo<String> responseInfo) {
                            try {
                                CommonListJson<PersonBean> bean = CommonListJson.fromJson(responseInfo.result, PersonBean.class);
                                if (bean.getState() != 0) {
                                    CommonMethod.makeNoticeShort(SelectWorkToMessageActivity.this, "删除成功", CommonMethod.SUCCESS);
                                    list.remove(positon);
                                    adapter.notifyDataSetChanged();
                                } else {
                                    CommonMethod.makeNoticeShort(SelectWorkToMessageActivity.this, getString(R.string.service_err), CommonMethod.ERROR);
                                }
                            } catch (Exception e) {
                                e.printStackTrace();
                                CommonMethod.makeNoticeShort(SelectWorkToMessageActivity.this, getString(R.string.service_err), CommonMethod.ERROR);
                            } finally {
                                closeDialog();
                            }
                        }

                        /** xutils 连接失败 调用的 方法 */
                        @Override
                        public void onFailure(HttpException exception, String errormsg) {
                            super.onFailure(exception, errormsg);
                        }
                    });
    }


    /**
     * 把list数据 根据a b c d 排序
     */
    class SortList implements Comparator<PersonBean> {
        @Override
        public int compare(PersonBean lhs, PersonBean rhs) {
            if (TextUtils.isEmpty(lhs.getSortLetters())) {
                return -1;
            }
            if (TextUtils.isEmpty(rhs.getSortLetters())) {
                return -1;
            }
            char a = lhs.getSortLetters().charAt(0);
            char b = rhs.getSortLetters().charAt(0);
            return a - b;
        }

    }


    /**
     * 显示默认布局
     */
    private void showDefaultLayout() {
        LinearLayout defaultLayout = (LinearLayout) findViewById(R.id.default_layout);
        ImageView rightImage = (ImageView) findViewById(R.id.rightImage);
        defaultLayout.setVisibility(View.VISIBLE);
        deleteBtn.setVisibility(View.GONE);
        rightImage.setVisibility(View.GONE);
    }

    /**
     * 显示列表数据
     */
    private void goneDefaultLayout() {
        LinearLayout defaultLayout = (LinearLayout) findViewById(R.id.default_layout);
        ImageView rightImage = (ImageView) findViewById(R.id.rightImage);
        defaultLayout.setVisibility(View.GONE);
        deleteBtn.setVisibility(View.GONE);
        rightImage.setVisibility(View.VISIBLE);
    }


    /**
     * 清除名字为空的对象
     */
    private void removeEmptyNamePerson() {
        int size = list.size();
        for (int i = 0; i < size; i++) {
            if (TextUtils.isEmpty(list.get(i).getName())) {
                list.remove(i);
                removeEmptyNamePerson();
                return;
            }
        }
    }
}
