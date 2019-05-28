package com.jizhi.jlongg.main.activity;

import android.annotation.TargetApi;
import android.app.Activity;
import android.content.Intent;
import android.graphics.Color;
import android.os.Build;
import android.os.Bundle;
import android.text.Editable;
import android.text.Spannable;
import android.text.SpannableStringBuilder;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.text.style.ForegroundColorSpan;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.TextView;

import com.hcs.cityslist.widget.CharacterParser;
import com.hcs.cityslist.widget.ClearEditText;
import com.hcs.cityslist.widget.SideBar;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.adpter.PersonBaseAdapter;
import com.jizhi.jlongg.main.bean.GroupMemberInfo;
import com.jizhi.jlongg.main.bean.PersonBean;
import com.jizhi.jlongg.main.dialog.DiaLogAddAccountPerson;
import com.jizhi.jlongg.main.dialog.DiaLogAddSynPersonNew;
import com.jizhi.jlongg.main.listener.AddSynchPersonListener;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.MessageUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.jizhi.jongg.widget.RoundeImageHashCodeTextLayout;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;

import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;


/**
 * 功能:添加同步对象
 * 时间:2018年5月4日16:39:43
 * 作者:xuj
 */
public class AddSyncPersonActivity extends BaseActivity implements View.OnClickListener {
    /**
     * listView
     */
    private ListView listView;
    /**
     * 列表适配器
     */
    private AddSyncPersonAdapter adapter;
    /**
     * 搜索框输入的文字
     */
    private String matchString;
    /**
     * true表示删除,false表示未进行删除
     */
    private boolean isEditor;
    /**
     * 删除按钮
     */
    private TextView editorText;

    /**
     * 启动当前Activity
     *
     * @param context
     * @param type    1表示添加同步对象  2表示邀请他人向我同步
     */
    public static void actionStart(Activity context, int type) {
        Intent intent = new Intent(context, AddSyncPersonActivity.class);
        intent.putExtra("addType", type);
        context.startActivityForResult(intent, Constance.REQUEST);
    }


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.add_account_person);
        initView();
        getSyncPerson();
    }

    /**
     * 初始化
     */
    public void initView() {
        editorText = getTextView(R.id.right_title);
        //1表示添加同步对象  2表示邀请他人向我同步
        int addType = getIntent().getIntExtra("addType", 1);
        setTextTitleAndRight(addType == 1 ? R.string.selecte_sync_person : R.string.ask_user_to_sync, R.string.delete);
        listView = (ListView) findViewById(R.id.listView);
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
        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                setReturnResult(adapter.getItem(position));
            }
        });

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
     * 搜索联系人
     *
     * @param mMatchString
     */
    private synchronized void filterData(final String mMatchString) {
        if (adapter == null || adapter.getCount() <= 1) {
            return;
        }
        matchString = mMatchString;
        new Thread(new Runnable() {
            @Override
            public void run() {
                final ArrayList<PersonBean> filterDataList = handlerPersonBeanList(adapter.getList(), mMatchString);
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
     * 删除同步人
     *
     * @param uid            要删除的用户id
     * @param removePosition 移除的下标
     */
    public void delSyncUser(String uid, final int removePosition) {
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        params.addBodyParameter("uid", uid);
        String httpUrl = NetWorkRequest.DELETESERDYNC;
        CommonHttpRequest.commonRequest(this, httpUrl, PersonBean.class, CommonHttpRequest.LIST, params, true, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                adapter.getList().remove(removePosition);
                adapter.notifyDataSetChanged();
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {

            }
        });
    }


    /**
     * 获取同步对象数据
     */
    public void getSyncPerson() {
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        String httpUrl = NetWorkRequest.GETUSERSYNLIST;
        CommonHttpRequest.commonRequest(this, httpUrl, PersonBean.class, CommonHttpRequest.LIST, params, true, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                ArrayList<PersonBean> list = (ArrayList<PersonBean>) object;
                for (PersonBean person : list) {
                    person.setName(person.getReal_name());
                }
                setAdapter(list);
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {

            }
        });
    }


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.right_title: //删除同步成员
                if (adapter == null || adapter.getCount() == 0) {
                    return;
                }
                isEditor = !isEditor;
                editorText.setText(isEditor ? R.string.cancel : R.string.delete);
                adapter.notifyDataSetChanged();
                break;
            case R.id.fromContact: //来自通讯录
                AddContactsActivity.actionStart(this, adapter != null && adapter.getCount() > 1 ? adapter.getList() : null, 2);
                break;
            case R.id.addBtn: //添加记账人员
            case R.id.fromPerson: //手动添加工人、班组长
                final DiaLogAddSynPersonNew dialog = new DiaLogAddSynPersonNew(this, getIntent().getIntExtra("addType", 1), new AddSynchPersonListener() {
                    @Override
                    public void add(final String realName, final String telphone, String descript, int position) {
                        PersonBean personBean = checkAccountIsExists(telphone);
                        if (personBean != null) { //验证记账对象是否存在列表中
                            setReturnResult(personBean);
                            return;
                        }
                        RequestParams params = RequestParamsToken.getExpandRequestParams(getApplicationContext());
                        params.addBodyParameter("realname", realName); //姓名
                        params.addBodyParameter("telph", telphone); //电话号码
                        params.addBodyParameter("option", "a"); //如果是添加传a，如果是修改传u
                        String httpUrl = NetWorkRequest.OPTUSERSYN;
                        CommonHttpRequest.commonRequest(AddSyncPersonActivity.this, httpUrl, PersonBean.class, CommonHttpRequest.OBJECT, params, true, new CommonHttpRequest.CommonRequestCallBack() {
                            @Override
                            public void onSuccess(Object object) {
                                PersonBean personBean = (PersonBean) object;
                                personBean.setReal_name(realName);
                                personBean.setTelephone(telphone);
                                setReturnResult(personBean);
                            }

                            @Override
                            public void onFailure(HttpException exception, String errormsg) {

                            }
                        });
                    }
                });
                dialog.setGetRealNameListener(new DiaLogAddAccountPerson.InputTelphoneGetRealNameListener() {
                    @Override
                    public void accordingTelgetRealName(String telephone) {
                        MessageUtil.useTelGetUserInfo(AddSyncPersonActivity.this, telephone, new CommonHttpRequest.CommonRequestCallBack() {
                            @Override
                            public void onSuccess(Object object) {
                                GroupMemberInfo info = (GroupMemberInfo) object;
                                dialog.setUserName(info.getReal_name());
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
     * 检查记账对象是否存在
     *
     * @param telphone
     * @return
     */
    public PersonBean checkAccountIsExists(String telphone) {
        if (adapter != null && adapter.getCount() > 0) {
            for (PersonBean bean : adapter.getList()) {
                if (telphone.equals(bean.getTelephone())) { //电话号码相同
                    return bean;
                }
            }
        }
        return null;
    }


    /**
     * 设置列表适配器
     *
     * @param list
     */
    public void setAdapter(final ArrayList<PersonBean> list) {
        editorText.setVisibility(list == null || list.size() == 0 ? View.GONE : View.VISIBLE);
        Utils.setPinYinAndSortPerson(list); //按照A.B.C.D排序
        adapter = new AddSyncPersonAdapter(AddSyncPersonActivity.this, list);
        listView.setAdapter(adapter);
    }


    /**
     * 返回选中记账对象信息
     */
    private void setReturnResult(PersonBean person) {
        Intent intent = getIntent();
        intent.putExtra(Constance.BEAN_CONSTANCE, person);
        setResult(1, intent);
        finish();
    }


    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == Constance.RESULTCODE_ADDCONTATS) { //添加了记账对象
            PersonBean personBean = (PersonBean) data.getSerializableExtra(Constance.BEAN_CONSTANCE);
            setReturnResult(personBean);
        }
    }


    /**
     * 新增记账对象
     *
     * @author Xuj
     * @version 1.0
     * @time 2017年10月16日11:24:40
     */
    public class AddSyncPersonAdapter extends PersonBaseAdapter {


        /**
         * 同步对象列表数据
         */
        private ArrayList<PersonBean> list;
        /**
         * xml解析器
         */
        private LayoutInflater inflater;
        /**
         * 搜索的过滤文本
         */
        private String filterValue;


        private final int ACCOUNT_WAY_VIEW = 0; //记账方式
        private final int ACCOUNT_PERSON_VIEW = 1; //记账对象列表

        @Override
        public int getItemViewType(int position) {
            return position == 0 ? ACCOUNT_WAY_VIEW : ACCOUNT_PERSON_VIEW;
        }

        @Override
        public int getViewTypeCount() {
            return 2;
        }


        public AddSyncPersonAdapter(BaseActivity context, ArrayList<PersonBean> list) {
            super();
            inflater = LayoutInflater.from(context);
            this.list = list;
        }


        /**
         * 当ListView数据发生变化时,调用此方法来更新ListView
         *
         * @param list
         */
        public void updateListView(ArrayList<PersonBean> list) {
            this.list = list;
            notifyDataSetChanged();
        }

        @Override
        public int getCount() {
            return list == null ? 1 : list.size() + 1;
        }

        @Override
        public PersonBean getItem(int position) {
            return list.get(position - 1);
        }

        @Override
        public long getItemId(int position) {
            return position;
        }


        @TargetApi(Build.VERSION_CODES.JELLY_BEAN)
        @Override
        public View getView(final int position, View convertView, ViewGroup parent) {
            ViewHolder holder = null;
            int type = getItemViewType(position);
            if (convertView == null) {
                if (type == ACCOUNT_WAY_VIEW) { //记账方式View
                    convertView = inflater.inflate(R.layout.add_account_head, null);
                    View fromContact = convertView.findViewById(R.id.fromContact);
                    View fromGroup = convertView.findViewById(R.id.fromGroup);
                    TextView manualAddText = (TextView) convertView.findViewById(R.id.manualAddText);
                    TextView manualAddTextDescText = (TextView) convertView.findViewById(R.id.manualAddTextDesc);
                    fromGroup.setVisibility(View.GONE);
                    fromContact.setOnClickListener(AddSyncPersonActivity.this);
                    convertView.findViewById(R.id.fromPerson).setOnClickListener(AddSyncPersonActivity.this);
                    manualAddText.setText("手动新增同步对象");
                    manualAddTextDescText.setText("输入电话号码和姓名");
                    manualAddTextDescText.setVisibility(View.VISIBLE);
                    return convertView;
                } else {
                    convertView = inflater.inflate(R.layout.add_sync_item, null);
                }
                holder = new ViewHolder(convertView);
                convertView.setTag(holder);
            } else {
                holder = (ViewHolder) convertView.getTag();
            }
            if (type == ACCOUNT_PERSON_VIEW) {
                bindData(holder, position);
            }
            return convertView;
        }


        private void bindData(ViewHolder holder, final int position) {
            final PersonBean bean = getItem(position);
            if (!TextUtils.isEmpty(filterValue)) { //如果过滤文字不为空
                Pattern p = Pattern.compile(filterValue);
                if (!TextUtils.isEmpty(bean.getReal_name())) { //姓名不为空的时才进行模糊匹配
                    SpannableStringBuilder builder = new SpannableStringBuilder(bean.getReal_name());
                    Matcher nameMatch = p.matcher(bean.getReal_name());
                    while (nameMatch.find()) {
                        ForegroundColorSpan redSpan = new ForegroundColorSpan(Color.parseColor("#EF272F"));
                        builder.setSpan(redSpan, nameMatch.start(), nameMatch.end(), Spannable.SPAN_INCLUSIVE_INCLUSIVE);
                    }
                    holder.userName.setText(builder);
                }
            } else {
                holder.userName.setText(bean.getReal_name());
            }
            holder.firstTips.setVisibility(position == 1 ? View.VISIBLE : View.GONE);
            if (isEditor) {
                holder.btnDelete.setVisibility(View.VISIBLE);
                holder.btnDelete.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        delSyncUser(bean.getTarget_uid(), position - 1);
                    }
                });
            } else {
                holder.btnDelete.setVisibility(View.GONE);
            }
            holder.roundImageHashText.setView(bean.getHead_pic(), bean.getReal_name(), position);
            int section = getSectionForPosition(position);
            // 如果当前位置等于该分类首字母的Char的位置 ，则认为是第一次出现
            if (position == getPositionForSection(section)) {
                holder.catalog.setVisibility(View.VISIBLE);
                holder.background.setVisibility(View.GONE);
                holder.catalog.setText(bean.getSortLetters());
            } else {
                holder.background.setVisibility(View.VISIBLE);
                holder.catalog.setVisibility(View.GONE);
            }
        }


        class ViewHolder {
            /**
             * 首字母背景色
             */
            View background;
            /**
             * 拼音首字母
             */
            TextView catalog;
            /**
             * 人物名称
             */
            TextView userName;
            /**
             * 头像、HashCode文本
             */
            RoundeImageHashCodeTextLayout roundImageHashText;
            /**
             * 常选班组长、工人
             */
            TextView firstTips;
            /**
             * 删除同步人按钮
             */
            TextView btnDelete;


            public ViewHolder(View convertView) {
                catalog = (TextView) convertView.findViewById(R.id.catalog);
                background = convertView.findViewById(R.id.background);
                userName = (TextView) convertView.findViewById(R.id.name);
                btnDelete = (TextView) convertView.findViewById(R.id.btnDelete);
                roundImageHashText = (RoundeImageHashCodeTextLayout) convertView.findViewById(R.id.roundImageHashText);
                firstTips = (TextView) convertView.findViewById(R.id.firstTips);
                firstTips.setText("常用同步对象");
                convertView.findViewById(R.id.telph).setVisibility(View.GONE);
            }
        }


        /**
         * 根据分类的首字母的Char ascii值获取其第一次出现该首字母的位置
         */
        @SuppressWarnings("unused")
        public int getPositionForSection(int section) {
            int size = list.size();
            for (int i = 0; i < size; i++) {
                String sortStr = list.get(i).getSortLetters();
                if (null != sortStr) {
                    char firstChar = sortStr.toUpperCase().charAt(0);
                    if (firstChar == section) {
                        return i + 1;
                    }
                }
            }
            return -1;
        }

        /**
         * 根据ListView的当前位置获取分类的首字母的Char ascii值
         */
        public int getSectionForPosition(int position) {
            if (null == getItem(position).getSortLetters()) {
                return 1;
            }
            return getItem(position).getSortLetters().charAt(0);
        }

        public ArrayList<PersonBean> getList() {
            return list;
        }

        public void setList(ArrayList<PersonBean> list) {
            this.list = list;
        }

        public void setFilterValue(String filterValue) {
            this.filterValue = filterValue;
        }
    }

    private ArrayList<PersonBean> handlerPersonBeanList(List<PersonBean> list, String matchString) {
        ArrayList<PersonBean> filterDataList = null;
        CharacterParser parser = CharacterParser.getInstance();
        for (PersonBean bean : list) {
            String name = bean.getReal_name();
            if (name.indexOf(matchString) != -1 || parser.getSelling(name).startsWith(matchString)) {
                if (filterDataList == null) {
                    filterDataList = new ArrayList<>();
                }
                filterDataList.add(bean);
            }
        }
        return filterDataList;
    }


}
