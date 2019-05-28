package com.jizhi.jlongg.main.activity;

import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.hcs.cityslist.widget.CharacterParser;
import com.hcs.cityslist.widget.ClearEditText;
import com.hcs.cityslist.widget.SideBar;
import com.hcs.uclient.utils.SPUtils;
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
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

import static com.jizhi.jlongg.R.id.right_title;

/**
 * 功能:选择群组成员 @人功能
 * 时间:2016/3/11 11:42
 * 作者:xuj
 */
public class SelectGroupOrTeamMemberActivity extends BaseActivity implements View.OnClickListener, DialogOnlyTextDesc.CloseListener {

    /* listView */
    @ViewInject(R.id.listview)
    private ListView listView;
    /* 删除按钮 */
    @ViewInject(right_title)
    private TextView deleteBtn;
    /* 添加工人、工头列表适配器 */
    private AddWorkerOrForemanAdapter adapter;
    /* 列表数据,模糊搜索数据 */
    private List<PersonBean> list;
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

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.add_worker_foreman_listview);
        ViewUtils.inject(this);
        initView();
        initData();


    }

    private void initData() {
        Intent intent = getIntent();
        final List<PersonBean> tempList = (List<PersonBean>) intent.getSerializableExtra(Constance.BEAN_ARRAY);
        if (tempList != null && tempList.size() > 0) {
            createList(tempList);
        } else {
            searchData();
        }
    }

    /**
     * 初始化
     */
    public void initView() {
        ClearEditText mClearEditText = (ClearEditText) findViewById(R.id.filter_edit);
        SideBar sideBar = (SideBar) findViewById(R.id.sidrbar);
        TextView center_text = getTextView(R.id.center_text);

        ImageView rightImage = getImageView(R.id.rightImage);
        rightImage.setVisibility(View.GONE);
        characterParser = CharacterParser.getInstance();
        SetTitleName.setTitle(findViewById(R.id.title), getString(R.string.select_person));
        rightImage.setVisibility(View.GONE);
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


    private synchronized void filterData(final String mFileterStr) {
        if (!TextUtils.isEmpty(mFileterStr)) {
            if (adapter != null && list != null && list.size() > 0) {
                fileterStr = mFileterStr;
                new Thread(new Runnable() {
                    @Override
                    public void run() {
                        List<PersonBean> filterDataList = new ArrayList<>();
                        for (PersonBean bean : list) {
                            String name = bean.getName();
                            String telphone = bean.getTelph();
                            if (name.indexOf(mFileterStr) != -1 || characterParser.getSelling(name).startsWith(mFileterStr) || telphone.startsWith(mFileterStr)) {
                                filterDataList.add(bean);
                            }
                        }
                        Message message = Message.obtain();
                        Bundle bundle = new Bundle();
                        bundle.putSerializable(Constance.BEAN_ARRAY, (Serializable) filterDataList);
                        bundle.putString(Constance.BEAN_STRING, mFileterStr);
                        message.setData(bundle);
                        message.what = VISIBLEFILTER;
                        mHandler.sendMessage(message);
                    }
                }).start();
            }
        } else {
            mHandler.sendEmptyMessage(GONEFILTER);
        }
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
                    List<PersonBean> filterList = (List<PersonBean>) bundle.getSerializable(Constance.BEAN_ARRAY);
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
     * 查询班组长/工头信息
     */
    public void searchData() {
        HttpUtils http = SingsHttpUtils.getHttp();
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        params.addBodyParameter("group_id", getIntent().getStringExtra(Constance.GROUP_ID));
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.BILLGROUPLIST,
                    params, new RequestCallBackExpand<String>() {
                        @Override
                        public void onSuccess(ResponseInfo<String> responseInfo) {
//                            try {
                            CommonListJson<PersonBean> bean = CommonListJson.fromJson(responseInfo.result, PersonBean.class);
                            if (bean.getState() != 0) {
                                List<PersonBean> list = bean.getValues();
                                if (list != null && list.size() > 0) {
                                    String mobile = SPUtils.get(SelectGroupOrTeamMemberActivity.this, Constance.TELEPHONE.toString(), "", Constance.JLONGG).toString();
                                    for (int i = 0; i < list.size(); i++) {
                                        if (list.get(i).getTelph().equals(mobile)) {
                                            list.remove(i);
                                            break;
                                        }
                                    }
                                    createList(list);
                                }
                            } else {
                                DataUtil.showErrOrMsg(SelectGroupOrTeamMemberActivity.this, bean.getErrno(), bean.getErrmsg());
                                finish();
                            }
//                            } catch (Exception e) {
//                                e.printStackTrace();
//                                CommonMethod.makeNoticeShort(SelectGroupOrTeamMemberActivity.this, getString(R.string.service_err), CommonMethod.ERROR);
//                                finish();
//                            } finally {
                            closeDialog();
//                            }
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
        Intent Intent = new Intent(SelectGroupOrTeamMemberActivity.this, AddContactsActivity.class);
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
        Bundle bundle = new Bundle();
        bundle.putSerializable(Constance.BEAN_ARRAY, personBean);
        intent.putExtras(bundle);
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
            p.setSortLetters(PinYin2Abbreviation.getPingYin(p.getName().substring(0, 1)).toUpperCase());
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
            adapter = new AddWorkerOrForemanAdapter(SelectGroupOrTeamMemberActivity.this, list, this);
            listView.setAdapter(adapter);
            goneDefaultLayout();
        } else if (object instanceof PersonBean) {
            if (list == null) {
                list = new ArrayList<>();
                adapter = new AddWorkerOrForemanAdapter(SelectGroupOrTeamMemberActivity.this, list, this);
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
        int size = list.size();
        for (int i = 0; i < size; i++) {
            PersonBean per = list.get(i);
            if (TextUtils.isEmpty(per.getSortLetters())) {
                per.setSortLetters(PinYin2Abbreviation.getPingYin(per.getName().substring(0, 1)).toUpperCase());
            }
        }
        Collections.sort(list, new SortList());
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
        RequestParams params = RequestParamsToken.getExpandRequestParams(SelectGroupOrTeamMemberActivity.this);
        params.addBodyParameter("partner", uid);
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.DELFM,
                    params, new RequestCallBackExpand<String>() {
                        @Override
                        public void onSuccess(ResponseInfo<String> responseInfo) {
                            try {
                                CommonListJson<PersonBean> bean = CommonListJson.fromJson(responseInfo.result, PersonBean.class);
                                if (bean.getState() != 0) {
                                    CommonMethod.makeNoticeShort(SelectGroupOrTeamMemberActivity.this, "删除成功", CommonMethod.SUCCESS);
                                    list.remove(positon);
                                    adapter.notifyDataSetChanged();
                                } else {
                                    CommonMethod.makeNoticeShort(SelectGroupOrTeamMemberActivity.this, getString(R.string.service_err), CommonMethod.ERROR);
                                }
                            } catch (Exception e) {
                                e.printStackTrace();
                                CommonMethod.makeNoticeShort(SelectGroupOrTeamMemberActivity.this, getString(R.string.service_err), CommonMethod.ERROR);
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
            if (TextUtils.isEmpty(lhs.getName())) {
                return -1;
            }
            if (TextUtils.isEmpty(rhs.getName())) {
                return -1;
            }
            char a = lhs.getSortLetters().charAt(0);
            char b = rhs.getSortLetters().charAt(0);
            return a - b;
        }
    }


    /**
     * 显示列表数据
     */
    private void goneDefaultLayout() {
        LinearLayout defaultLayout = findViewById(R.id.default_layout);
        RelativeLayout listViewLayout =  findViewById(R.id.listView_layout);
        ImageView rightImage = (ImageView) findViewById(R.id.rightImage);
        listViewLayout.setVisibility(View.VISIBLE);
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
