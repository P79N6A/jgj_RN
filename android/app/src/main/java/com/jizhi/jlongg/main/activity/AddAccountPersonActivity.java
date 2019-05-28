package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.TextView;

import com.hcs.cityslist.widget.ClearEditText;
import com.hcs.cityslist.widget.SideBar;
import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.SPUtils;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.adpter.AddAccountPersonAdapter;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.PersonBean;
import com.jizhi.jlongg.main.util.AccountUtil;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.MessageUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SearchMatchingUtil;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;

import java.util.ArrayList;
import java.util.List;


/**
 * 功能:添加记账对象
 * 时间:2016/3/11 11:42
 * 作者:xuj
 */
public class AddAccountPersonActivity extends BaseActivity implements View.OnClickListener {
    /**
     * listView
     */
    private ListView listView;
    /**
     * 列表数据
     */
    private ArrayList<PersonBean> list;
    /**
     * 删除按钮
     */
    private TextView deleteBtn;
    /**
     * 列表适配器
     */
    private AddAccountPersonAdapter adapter;
    /**
     * 当前是否正在删除数据
     */
    private boolean isDel;
    /**
     * 搜索框输入的文字
     */
    private String matchString;
    /**
     * 项目组id
     */
    private String groupId;
    /**
     * 头部View
     */
    private View headView;
    /**
     * 模糊输入框
     */
    private View inputLayout;
    /**
     * 被删除的记账对象uid
     */
    private String deleteAccountUids;

    /**
     * 启动当前Activity
     *
     * @param context
     * @param selecteUid      已选择的记账对象uid
     * @param groupId         项目组id
     * @param accountTyps     记账类型
     * @param constractorType 包工类型  (1是承包 2是分包)如果不是包工记账 则传0
     */
    public static void actionStart(Activity context, String selecteUid, String groupId, int accountTyps, int constractorType) {
        Intent intent = new Intent(context, AddAccountPersonActivity.class);
        intent.putExtra(Constance.UID, selecteUid);
        intent.putExtra(Constance.GROUP_ID, groupId);
        intent.putExtra(Constance.ACCOUNT_TYPE, accountTyps);
        intent.putExtra(Constance.CONSTRACTOR_TYPE, constractorType);
        context.startActivityForResult(intent, Constance.REQUEST);
    }


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.add_account_person);
        initView();
        searchAccountPerson();
    }

    /**
     * 初始化
     */
    public void initView() {
        groupId = getIntent().getStringExtra(Constance.GROUP_ID);
        listView = (ListView) findViewById(R.id.listView);
        deleteBtn = (TextView) findViewById(R.id.right_title);
        inputLayout = findViewById(R.id.input_layout);
        //批量记工-记单笔-选择工人界面，右上角的“删除”按钮隐藏（注意：从记一笔工进入选择工人界面右上角的删除不隐藏）
        //如果是从批量记工点进来 记单笔则GroupId不为空
        //记账类型
        if (TextUtils.isEmpty(groupId)) {
            deleteBtn.setOnClickListener(this);
            View headView = getLayoutInflater().inflate(R.layout.add_account_head, null);
            View fromContact = headView.findViewById(R.id.fromContact);
            View fromGroup = headView.findViewById(R.id.fromGroup);
            View fromPerson = headView.findViewById(R.id.fromPerson);
            TextView manualAddText = (TextView) headView.findViewById(R.id.manualAddText);
            TextView manualAddTextDesc = (TextView) headView.findViewById(R.id.manualAddTextDesc);
            fromContact.setOnClickListener(AddAccountPersonActivity.this);
            fromPerson.setOnClickListener(AddAccountPersonActivity.this);
            manualAddTextDesc.setVisibility(View.VISIBLE);
            manualAddTextDesc.setText("没有电话号码也可添加");

            if (isContractor()) { //承包对象
                manualAddText.setText("添加承包对象");
                fromGroup.setVisibility(View.GONE);
            } else {
                if (UclientApplication.isForemanRoler(getApplicationContext())) {
                    manualAddText.setText(R.string.manual_add_worker);
                    fromGroup.setOnClickListener(AddAccountPersonActivity.this);
                    fromGroup.setVisibility(View.VISIBLE);
                } else {
                    fromGroup.setVisibility(View.GONE);
                    manualAddText.setText(R.string.manual_add_foreman);
                }
            }
            listView.addHeaderView(headView, null, false);
            this.headView = headView;
        } else {
            deleteBtn.setVisibility(View.GONE);
        }
        if (isContractor()) {
            setTextTitleAndRight(TextUtils.isEmpty(groupId) ? R.string.selecte_work_account_contract : R.string.selecte_member, R.string.delete);
        } else {
            if (UclientApplication.isForemanRoler(getApplicationContext())) {//工头
                setTextTitleAndRight(TextUtils.isEmpty(groupId) ? R.string.selectWorker : R.string.selecte_member, R.string.delete);
            } else { //工人
                setTextTitleAndRight(TextUtils.isEmpty(groupId) ? R.string.selectForeman_title : R.string.selecte_member, R.string.delete);
            }
        }
        SideBar sideBar = (SideBar) findViewById(R.id.sidrbar);
        TextView centerText = getTextView(R.id.center_text);
        ClearEditText mClearEditText = (ClearEditText) findViewById(R.id.filterEdit);
        mClearEditText.setHint("请输入姓名或手机号查找");
        sideBar.setTextView(centerText);
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
                if (TextUtils.isEmpty(groupId)) {
                    if (TextUtils.isEmpty(s.toString())) {
                        if (listView.getHeaderViewsCount() == 0) {
                            listView.addHeaderView(headView, null, false);
                        }
                    } else {
                        if (listView.getHeaderViewsCount() > 0) {
                            listView.removeHeaderView(headView);
                        }
                    }
                }
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
                if (isDel) { //删除状态下 不允许点击
                    return;
                }
                position = position - listView.getHeaderViewsCount();
                if (position < 0) {
                    position = 0;
                }
                Intent intent = getIntent();
                intent.putExtra(Constance.BEAN_CONSTANCE, adapter.getItem(position)); //获取已中的记账对象
                setResult(Constance.SUCCESS, intent);
                finish();
            }
        });

    }

    /**
     * 获取记账对象
     */
    public void searchAccountPerson() {
        RequestParams params = RequestParamsToken.getExpandRequestParams(getApplicationContext());
        if (!TextUtils.isEmpty(groupId)) { //如果从班组中进来的则只查询班组中的记账对象
            params.addBodyParameter("group_id", groupId);
        }
        if (isContractor()) { //承包对象
            params.addBodyParameter("contractor_type", "1");
        }
        String httpUrl = TextUtils.isEmpty(groupId) ? NetWorkRequest.JLWORKDAY_NEW : NetWorkRequest.BILLGROUPLIST;
        CommonHttpRequest.commonRequest(this, httpUrl, PersonBean.class, CommonHttpRequest.LIST, params, true, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                ArrayList<PersonBean> list = (ArrayList<PersonBean>) object;
                removeEmptyNamePerson(list);
                //检测上次已选中的记账对象
                String uid = getIntent().getStringExtra(Constance.UID);
                if (!TextUtils.isEmpty(uid)) {
                    for (PersonBean personBean : list) {
                        if (uid.equals(personBean.getUid() + "")) {
                            personBean.setIsChecked(true);
                            break;
                        }
                    }
                }
                setAdapter(list);
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
                finish();
            }
        });
    }


    /**
     * 搜索联系人
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


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.fromGroup: //班组新增记账对象
                GetGroupAccountActivity.actionStart(this, false, getExistTelhone(list));
                break;
            case R.id.fromContact: //来自通讯录
                AddContactsActivity.actionStart(this, list, isContractor() ? 3 : 1);
                break;
            case R.id.addBtn: //添加记账人员
            case R.id.fromPerson: //手动添加工人、班组长
                AddWorkerActivity.actionStart(this, list, getIntent().getIntExtra(Constance.ACCOUNT_TYPE, AccountUtil.HOUR_WORKER_INT),
                        getIntent().getIntExtra(Constance.CONSTRACTOR_TYPE, 0));
                break;
            case R.id.right_title: //删除按钮
                isDel = !isDel;
                deleteBtn.setText(getResources().getString(isDel ? R.string.cancel : R.string.delete));
                adapter.setDel(isDel);
                adapter.notifyDataSetChanged();
                break;
        }
    }


    private String getExistTelhone(ArrayList<PersonBean> memberList) {
        if (memberList != null && memberList.size() > 0) {
            StringBuilder builder = new StringBuilder();
            int count = 0;
            for (PersonBean groupMemberInfo : memberList) {
                builder.append(count == 0 ? groupMemberInfo.getTelph() : "," + groupMemberInfo.getTelph());
                count += 1;
            }
            return builder.toString();
        }
        return null;
    }

    /**
     * 设置列表适配器
     *
     * @param list
     */
    public void setAdapter(final ArrayList<PersonBean> list) {
        inputLayout.setVisibility(list != null && list.size() > 0 ? View.VISIBLE : View.GONE);
        AddAccountPersonActivity.this.list = list;
        Utils.setPinYinAndSortPerson(list); //按照A.B.C.D排序
        adapter = new AddAccountPersonAdapter(AddAccountPersonActivity.this, list, new AddAccountPersonAdapter.AddAccountListener() {
            @Override
            public void delete(PersonBean personBean, int position) {
                delAccountMember(personBean, position);
            }
        }, getIntent().getIntExtra(Constance.ACCOUNT_TYPE, AccountUtil.HOUR_WORKER_INT), getIntent().getIntExtra(Constance.CONSTRACTOR_TYPE, 0));
        if (TextUtils.isEmpty(groupId)) {
            deleteBtn.setVisibility(list != null && list.size() > 0 ? View.VISIBLE : View.GONE);
        } else {
            adapter.setGroupId(groupId);
        }
        listView.setAdapter(adapter);
    }


    /**
     * 删除记账对象
     *
     * @param position
     */
    private void delAccountMember(final PersonBean personBean, final int position) {
        String httpUrl = NetWorkRequest.DELFM;
        RequestParams params = RequestParamsToken.getExpandRequestParams(getApplicationContext());
        params.addBodyParameter("partner", personBean.getUid() + "");
        if (isContractor()) { //承包对象
            params.addBodyParameter("contractor_type", "1");
        }
        CommonHttpRequest.commonRequest(this, httpUrl, PersonBean.class, CommonHttpRequest.LIST, params, true, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                //当给工头记账时  会将工头的信息给记录下来 比如加班时长  上班时长  等等信息
                //如果在删除工头时需要将这些信息一并删除
                CommonMethod.makeNoticeShort(AddAccountPersonActivity.this, "删除成功", CommonMethod.SUCCESS);
                if (UclientApplication.getRoler(getApplicationContext()).equals(Constance.ROLETYPE_WORKER)) {
                    //工头的uid
                    int saveForemanUid = (int) SPUtils.get(getApplicationContext(), "uid", 0, Constance.WOKRBILL);
                    if ((saveForemanUid + "").equals(personBean.getUid())) {
                        SPUtils.clear(getApplicationContext(), Constance.WOKRBILL);
                    }
                }
                deleteAccountUids = TextUtils.isEmpty(deleteAccountUids) ? personBean.getUid() + "" : deleteAccountUids + "," + personBean.getUid();
                LUtils.e("删除的uid:" + deleteAccountUids);
                Intent intent = getIntent();
                intent.putExtra(Constance.DELETE_UID, deleteAccountUids);
//                if (personBean.isChecked()) { //告诉上个页面 取消对象已选中的状态
                setResult(Constance.SUCCESS, intent);
//                }
                adapter.getList().remove(position);
                if (!TextUtils.isEmpty(matchString)) { //搜索状态下
                    int count = 0;
                    for (PersonBean allBean : list) {
                        if (allBean.getUid() == personBean.getUid()) {
                            list.remove(count);
                            break;
                        }
                        count++;
                    }
                }
                adapter.notifyDataSetChanged();
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
                finish();
            }
        });
    }


    /**
     * 清除名字或者电话号码为空的对象
     */
    private void removeEmptyNamePerson(ArrayList<PersonBean> list) {
        if (list == null || list.size() == 0) {
            return;
        }
        int size = list.size();
        for (int i = 0; i < size; i++) {
            if (TextUtils.isEmpty(list.get(i).getName())) {
                list.remove(i);
                removeEmptyNamePerson(list);
                return;
            }
        }
    }


    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == Constance.RESULTCODE_ADDCONTATS ||
                resultCode == MessageUtil.WAY_GROUP_TEAM_GROUPCHAT_ADD_ACCOUNT_MERMBER ||
                resultCode == Constance.MANUAL_ADD_OR_EDITOR_PERSON) { //添加记账对象的回调
            setResult(Constance.SUCCESS, data);
            finish();
        } else if (resultCode == Constance.SAVE_BATCH_ACCOUNT) { //批量记账
            setResult(Constance.SAVE_BATCH_ACCOUNT);
            finish();
        }
    }

    /**
     * 是否是承包对象
     *
     * @return true表示是
     */
    public boolean isContractor() {
        int accountTyps = getIntent().getIntExtra(Constance.ACCOUNT_TYPE, AccountUtil.HOUR_WORKER_INT);
        int constractorType = getIntent().getIntExtra(Constance.CONSTRACTOR_TYPE, 0);
        return accountTyps == AccountUtil.CONSTRACTOR_INT && constractorType == 1;
    }


}
