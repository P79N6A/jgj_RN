package com.jizhi.jlongg.main.activity;

import android.annotation.TargetApi;
import android.app.Activity;
import android.content.Intent;
import android.graphics.Color;
import android.os.Build;
import android.os.Bundle;
import android.text.Editable;
import android.text.Html;
import android.text.Spannable;
import android.text.SpannableStringBuilder;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.text.style.ForegroundColorSpan;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;

import com.hcs.cityslist.widget.ClearEditText;
import com.hcs.cityslist.widget.SideBar;
import com.hcs.uclient.utils.SPUtils;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.adpter.PersonBaseAdapter;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.BaseNetNewBean;
import com.jizhi.jlongg.main.bean.PersonBean;
import com.jizhi.jlongg.main.bean.SingleSelected;
import com.jizhi.jlongg.main.dialog.DialogLeftRightBtnConfirm;
import com.jizhi.jlongg.main.popwindow.SingleSelectedPopWindow;
import com.jizhi.jlongg.main.util.BackGroundUtil;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.IsSupplementary;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SearchMatchingUtil;
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
 * 功能:班组长、工人管理
 * 时间:2018年4月25日10:03:20
 * 作者:xuj
 */
public class ForemanWorkerManagerActivity extends BaseActivity implements View.OnClickListener {
    /**
     * listView
     */
    private ListView listView;
    /**
     * 右上角按钮
     */
    private TextView rightText;
    /**
     * 列表数据
     */
    private ArrayList<PersonBean> list;
    /**
     * 列表适配器
     */
    private ForemanWorkerManagerAdapter adapter;
    /**
     * 是否在编辑数据
     */
    private boolean isEditor;
    /**
     * 搜索框输入的文字
     */
    private String matchString;
    /**
     * 底部布局
     */
    private View bottomLayout;
    /**
     * 已选的数量
     */
    private int selectCount;
    /**
     * 底部红色按钮
     */
    private Button redBtn;
    /**
     * 全选文字按钮
     */
    private TextView selecteAllText;
    /**
     * 全选图标
     */
    private ImageView selecteAllIcon;
    /**
     * 全选布局
     */
    private View selecteAllLayout;

    /**
     * 启动当前Activity
     *
     * @param context
     */
    public static void actionStart(Activity context) {
        Intent intent = new Intent(context, ForemanWorkerManagerActivity.class);
        context.startActivityForResult(intent, Constance.REQUEST);
    }


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.foreman_worker_manager);
        initView();
        IsSupplementary.isFillRealNameCallBackListener(this, true, new IsSupplementary.CallSupplementNameSuccess() {
            @Override
            public void onSuccess() {
                searchAccountPerson();
            }
        });
    }

    /**
     * 初始化
     */
    public void initView() {
        listView = (ListView) findViewById(R.id.listView);
        bottomLayout = findViewById(R.id.editor_layout);
        redBtn = findViewById(R.id.red_btn);
        rightText = (TextView) findViewById(R.id.right_title);
        selecteAllText = findViewById(R.id.selecte_all_text);
        selecteAllIcon = findViewById(R.id.selecte_all_icon);
        selecteAllLayout = findViewById(R.id.selecte_all_layout);
        getTextView(R.id.clickConfirmText).setText(UclientApplication.getRoler(getApplicationContext()).equals(Constance.ROLETYPE_FM) ? R.string.work_manager_tips : R.string.foreman_manager_tips);
        SideBar sideBar = (SideBar) findViewById(R.id.sidrbar);
        TextView centerText = getTextView(R.id.center_text);

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
        ClearEditText mClearEditText = (ClearEditText) findViewById(R.id.filterEdit);
        mClearEditText.setHint("请输入姓名或手机号码查找");
        // 根据输入框输入值的改变来过滤搜索
        mClearEditText.addTextChangedListener(new TextWatcher() {
            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                selecteAllLayout.setVisibility(TextUtils.isEmpty(s.toString()) ? View.VISIBLE : View.GONE);
                filterData(s.toString());
            }

            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {
            }

            @Override
            public void afterTextChanged(Editable s) {
            }
        });
        if (UclientApplication.isForemanRoler(getApplicationContext())) {//工头
            setTextTitleAndRight(R.string.worker_manager, R.string.more);
        } else { //工人
            setTextTitleAndRight(R.string.foremans, R.string.more);
        }
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
                            adapter.updateListView(filterDataList);
                        }
                    });
                }
            }
        }).start();
    }


    /**
     * 获取记账对象
     */
    public void searchAccountPerson() {
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        String httpUrl = NetWorkRequest.FOREMAN_WORKER_LIST;
        CommonHttpRequest.commonRequest(this, httpUrl, PersonBean.class, CommonHttpRequest.LIST, params, true, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                ArrayList<PersonBean> list = (ArrayList<PersonBean>) object;
                ForemanWorkerManagerActivity.this.list = list;
                setAdapter(list);
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
                finish();
            }
        });
    }

    /**
     * 设置列表选择状态
     *
     * @param isCancelAll true表示取消所有的选择
     */
    private void setSelecteState(boolean isCancelAll) {
        for (PersonBean person : list) {
            if (isCancelAll) {
                person.setIsChecked(false);
            } else {
                person.setIsChecked(true);
            }
        }
        selectCount = isCancelAll ? 0 : list.size();
        checkIsSelectAllOrCancelAll();
        adapter.notifyDataSetChanged();
    }

    private void checkIsSelectAllOrCancelAll() {
        boolean isSelecteAll = selectCount == list.size();
        selecteAllIcon.setImageResource(isSelecteAll ? R.drawable.checkbox_pressed : R.drawable.checkbox_normal);
        selecteAllText.setText(isSelecteAll ? R.string.cancel_check_all : R.string.check_all);
        if (!TextUtils.isEmpty(currentEditorState)) {
            switch (currentEditorState) {
                case "2":
                    String tips = UclientApplication.isForemanRoler(getApplicationContext()) ? "删除工人" : "删除班组长";
                    redBtn.setText(selectCount == 0 ? tips : tips + "(" + selectCount + ")");
                    break;
                case "1":
                    redBtn.setText(selectCount == 0 ? "批量设置工资标准" : "批量设置工资标准" + "(" + selectCount + ")");
                    break;
            }
        }
    }

    public List<SingleSelected> getFileterValue() {
        List<SingleSelected> list = new ArrayList<>();
        list.add(new SingleSelected("批量设置工资标准", false, false, "1"));
        list.add(new SingleSelected(UclientApplication.isForemanRoler(getApplicationContext()) ? "删除工人" : "删除班组长",
                false, true, "2"));
        list.add(new SingleSelected("取消", false, false, "3", Color.parseColor("#999999")));
        return list;
    }

    /**
     * 当前编辑状态
     * 1.表示批量设置工资模板
     * 2.表示删除工人，班组长
     */
    private String currentEditorState;

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.right_title: //批量删除工人,批量设置薪资模板按钮
                if (isEditor) {
                    isEditor = !isEditor;
                    initClickEditorLayout();
                } else {
                    if (selectCount != 0) {
                        setSelecteState(true);
                    }
                    SingleSelectedPopWindow popWindow = new SingleSelectedPopWindow(this, getFileterValue(), new SingleSelectedPopWindow.SingleSelectedListener() {
                        @Override
                        public void getSingleSelcted(SingleSelected bean) {
                            currentEditorState = bean.getSelecteNumber();
                            switch (bean.getSelecteNumber()) {
                                case "1": //批量设置工资标准
                                    isEditor = true;
                                    redBtn.setText("批量设置工资标准");
                                    initClickEditorLayout();
                                    break;
                                case "2": //删除工人
                                    isEditor = true;
                                    initClickEditorLayout();
                                    redBtn.setText(UclientApplication.isForemanRoler(getApplicationContext()) ? "删除工人" : "删除班组长");
                                    break;
                            }
                        }
                    });
                    popWindow.showAtLocation(getWindow().getDecorView(), Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0); //设置layout在PopupWindow中显示的位置
                    BackGroundUtil.backgroundAlpha(this, 0.5F);
                }
                break;
            case R.id.red_btn: //红色按钮
                switch (currentEditorState) {
                    case "1":
                        String uids = getSelecteUids();
                        if (TextUtils.isEmpty(uids)) {
                            String rolerTips = UclientApplication.getRoler(getApplicationContext()).equals(Constance.ROLETYPE_FM) ? "工人" : "班组长";
                            CommonMethod.makeNoticeLong(getApplicationContext(), "你还未选择任何" + rolerTips, CommonMethod.ERROR);
                            return;
                        }
                        SalaryModeSettingActivity.actionStart(this, null, uids, null, UclientApplication.getRoler(getApplicationContext()),
                                getString(R.string.set_salary_mode_title), true, 1, true);
                        break;
                    case "2":
                        deletePersonList();
                        break;
                }
                break;
            case R.id.selecte_all_layout: //全选按钮布局
                if (selectCount == list.size()) { //当前是全选状态 取消全选
                    setSelecteState(true);
                } else { //标记所有的列表为全选状态
                    setSelecteState(false);
                }
                break;

        }
    }

    /**
     * 显示编辑布局
     */
    public void initClickEditorLayout() {
        rightText.setText(getResources().getString(isEditor ? R.string.cancel : R.string.more));
        bottomLayout.setVisibility(isEditor ? View.VISIBLE : View.GONE);
    }


    /**
     * 设置列表适配器
     *
     * @param list
     */
    public void setAdapter(final ArrayList<PersonBean> list) {
        Utils.setPinYinAndSortPerson(list); //按照A.B.C.D排序
        findViewById(R.id.input_layout).setVisibility(list == null || list.isEmpty() ? View.GONE : View.VISIBLE);
        rightText.setVisibility(list != null && list.size() > 0 ? View.VISIBLE : View.GONE);
        if (bottomLayout.getVisibility() == View.VISIBLE && (list == null || list.size() == 0)) {
            bottomLayout.setVisibility(View.GONE);
        }
        if (adapter == null) {
            adapter = new ForemanWorkerManagerAdapter(ForemanWorkerManagerActivity.this, list);
            listView.setEmptyView(findViewById(R.id.defaultLayout));
            listView.setAdapter(adapter);
        } else {
            adapter.updateListView(list);
        }
    }

    /**
     * 获取列表已选的uid
     *
     * @return
     */
    private String getSelecteUids() {
        if (adapter == null || adapter.getCount() == 0) {
            return null;
        }
        StringBuilder builder = new StringBuilder();
        int count = 0;
        for (PersonBean personBean : adapter.getList()) {
            if (personBean.isChecked()) {
                builder.append(count == 0 ? personBean.getUid() : "," + personBean.getUid());
                count++;
            }
        }
        return builder.toString();
    }

    /**
     * 批量删除成员
     */
    public void deletePersonList() {
        if (selectCount == 0) {
            String rolerTips = UclientApplication.getRoler(getApplicationContext()).equals(Constance.ROLETYPE_FM) ? "工人" : "班组长";
            CommonMethod.makeNoticeLong(getApplicationContext(), "你还未选择任何" + rolerTips, CommonMethod.ERROR);
            return;
        }
        DialogLeftRightBtnConfirm dialogLeftRightBtnConfirm = new DialogLeftRightBtnConfirm(this, null,
                "选择删除的用户中，如果有无电话号码的用户，删除后将无法对该类用户记工记账。确定要删除吗？",
                new DialogLeftRightBtnConfirm.LeftRightBtnListener() {
                    @Override
                    public void clickLeftBtnCallBack() {

                    }

                    @Override
                    public void clickRightBtnCallBack() {
                        final String uids = getSelecteUids();
                        if (TextUtils.isEmpty(uids)) {
                            String rolerTips = UclientApplication.getRoler(getApplicationContext()).equals(Constance.ROLETYPE_FM) ? "工人" : "班组长";
                            CommonMethod.makeNoticeLong(getApplicationContext(), "你还未选择任何" + rolerTips, CommonMethod.ERROR);
                            return;
                        }
                        String httpUrl = NetWorkRequest.DEL_FM_LIST;
                        RequestParams params = RequestParamsToken.getExpandRequestParams(getApplicationContext());
                        params.addBodyParameter("uids", uids); //用户uid ，多用户以，形式隔开
                        CommonHttpRequest.commonRequest(ForemanWorkerManagerActivity.this, httpUrl, BaseNetNewBean.class,
                                CommonHttpRequest.OBJECT, params, true, new CommonHttpRequest.CommonRequestCallBack() {
                                    @Override
                                    public void onSuccess(Object object) {
                                        if (isEditor) { //取消编辑状态
                                            isEditor = !isEditor;
                                            initClickEditorLayout();
                                        }
                                        String rolerTips = UclientApplication.getRoler(getApplicationContext()).equals(Constance.ROLETYPE_FM) ? "工人" : "班组长";
                                        CommonMethod.makeNoticeLong(getApplicationContext(), "删除" + rolerTips + "成功", CommonMethod.SUCCESS);
                                        //当给工头记账时  会将工头的信息给记录下来 比如加班时长  上班时长  等等信息
                                        //如果在删除工头时需要将这些信息一并删除
                                        if (UclientApplication.getRoler(getApplicationContext()).equals(Constance.ROLETYPE_WORKER)) {
                                            for (String uid : uids.split(",")) {
                                                //工头的uid
                                                int saveForemanUid = (int) SPUtils.get(getApplicationContext(), "uid", 0, Constance.WOKRBILL);
                                                if ((saveForemanUid + "").equals(uid)) {
                                                    SPUtils.clear(getApplicationContext(), Constance.WOKRBILL);
                                                }
                                            }
                                        }
                                        searchAccountPerson();
                                    }

                                    @Override
                                    public void onFailure(HttpException exception, String errormsg) {

                                    }
                                });
                    }
                });
        dialogLeftRightBtnConfirm.show();
    }


    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == Constance.RESULTCODE_ADDCONTATS || resultCode == Constance.MANUAL_ADD_OR_EDITOR_PERSON) { //通讯录添加了记账对象,手动添加班组长、工头
            searchAccountPerson();
        } else if (resultCode == Constance.SAVE_BATCH_ACCOUNT) { //批量记账
            setResult(Constance.SAVE_BATCH_ACCOUNT);
            finish();
        } else if (resultCode == Constance.REFRESH || resultCode == Constance.EVALUATE_SUCCESS) {  //Constance.EVALUATE_SUCCESS表示评价成功
            if (isEditor) { //取消编辑状态
                isEditor = !isEditor;
                initClickEditorLayout();
            }
            searchAccountPerson();
            if (resultCode == Constance.EVALUATE_SUCCESS) { //评价成功后跳转到评价详情页
                EvaluationDetailActivity.actionStart(this, data.getStringExtra(Constance.UID), null);
            }
        } else if (resultCode == Constance.CLICK_SINGLECHAT) { //单聊聊天
            setResult(resultCode, data);
            finish();
        } else if (resultCode == Constance.SALARYMODESETTING_RESULTCODE) { //设置记账对象薪资模板回调
            if (isEditor) { //取消编辑状态
                isEditor = !isEditor;
                initClickEditorLayout();
            }
        }
    }

    /**
     * 班组长、工人管理适配器
     *
     * @author Xuj
     * @version 1.0
     * @time 2018年4月25日10:06:09
     */
    public class ForemanWorkerManagerAdapter extends PersonBaseAdapter {


        /**
         * 工人、班组长列表数据
         */
        private List<PersonBean> list;
        /**
         * xml解析器
         */
        private LayoutInflater inflater;


        public ForemanWorkerManagerAdapter(BaseActivity context, List<PersonBean> list) {
            super();
            inflater = LayoutInflater.from(context);
            this.list = list;
        }


        /**
         * 当ListView数据发生变化时,调用此方法来更新ListView
         *
         * @param list
         */
        public void updateListView(List<PersonBean> list) {
            this.list = list;
            notifyDataSetChanged();
        }

        @Override
        public int getCount() {
            return list == null ? 0 : list.size();
        }

        @Override
        public PersonBean getItem(int position) {
            return list.get(position);
        }

        @Override
        public long getItemId(int position) {
            return position;
        }


        @TargetApi(Build.VERSION_CODES.JELLY_BEAN)
        @Override
        public View getView(final int position, View convertView, ViewGroup parent) {
            ViewHolder holder = null;
            if (convertView == null) {
                convertView = inflater.inflate(R.layout.foreman_worker_item, null);
                holder = new ViewHolder(convertView);
                convertView.setTag(holder);
            } else {
                holder = (ViewHolder) convertView.getTag();
            }
            bindData(holder, position);
            return convertView;
        }


        private void bindData(ViewHolder holder, final int position) {
            final PersonBean bean = getItem(position);
            holder.roundImageHashText.setView(bean.getHead_pic(), bean.getName(), position);
            if (!TextUtils.isEmpty(matchString)) { //如果过滤文字不为空
                Pattern p = Pattern.compile(matchString);
                if (!TextUtils.isEmpty(bean.getName())) { //姓名不为空的时才进行模糊匹配
                    SpannableStringBuilder builder = new SpannableStringBuilder(bean.getName());
                    Matcher nameMatch = p.matcher(bean.getName());
                    while (nameMatch.find()) {
                        ForegroundColorSpan redSpan = new ForegroundColorSpan(Color.parseColor("#EF272F"));
                        builder.setSpan(redSpan, nameMatch.start(), nameMatch.end(), Spannable.SPAN_INCLUSIVE_INCLUSIVE);
                    }
                    holder.userName.setText(builder);
                }
            } else {
                holder.userName.setText(bean.getName());
            }
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
            if (!TextUtils.isEmpty(bean.getProname())) {
                holder.workInfo.setVisibility(View.VISIBLE);
                if (UclientApplication.getRoler(getApplicationContext()).equals(Constance.ROLETYPE_FM)) {
                    holder.workInfo.setText(Html.fromHtml("<font color='#999999'>他在</font><font color='#eb4e4e'>" + bean.getProname() + "</font><font color='#999999'>干活</font>"));
                } else {
                    holder.workInfo.setText(Html.fromHtml("<font color='#999999'>你在</font><font color='#eb4e4e'>" + bean.getProname() + "</font><font color='#999999'>为他干活</font>"));
                }
            } else {
                holder.workInfo.setVisibility(View.GONE);
            }
            holder.firstTips.setVisibility(position == 0 ? View.VISIBLE : View.GONE);
            if (isEditor) { //编辑状态
                holder.selectIcon.setVisibility(View.VISIBLE);
                holder.leftBtn.setVisibility(View.GONE);
                holder.rightBtn.setVisibility(View.GONE);
                holder.selectIcon.setImageResource(bean.isChecked() ? R.drawable.checkbox_pressed : R.drawable.checkbox_normal);
            } else { //未编辑状态
                holder.selectIcon.setVisibility(View.GONE);
                if (bean.getIs_check_accounts() == 1) { //显示跟他对账的按钮
                    holder.rightBtn.setVisibility(View.VISIBLE);
                    holder.rightBtn.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View view) {
                            RecordWorkConfirmActivity.actionStart(ForemanWorkerManagerActivity.this, null, bean.getUid() + "", null);
                        }
                    });
                } else {
                    holder.rightBtn.setVisibility(View.GONE);
                }
                if (bean.getIs_comment() == 1) { //显示去评价按钮
                    holder.leftBtn.setVisibility(View.VISIBLE);
                    holder.leftBtn.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View view) {
                            GoEvaluateActivity.actionStart(ForemanWorkerManagerActivity.this, bean.getUid() + "", bean.getHead_pic(), bean.getName());
                        }
                    });
                } else {
                    holder.leftBtn.setVisibility(View.GONE);
                }
            }
            holder.itemLayout.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    PersonBean personBean = adapter.getList().get(position);
                    if (isEditor) { //编辑状态
                        personBean.setIsChecked(!personBean.isChecked());
                        if (personBean.isChecked()) {
                            selectCount++;
                        } else {
                            selectCount--;
                        }
                        adapter.notifyDataSetChanged();
                        checkIsSelectAllOrCancelAll();
                    } else {
                        String telephone = personBean.getIs_not_telph() == 1 ? null : personBean.getTelph();
                        PersonEvaluateInfoNewActivity.actionStart(ForemanWorkerManagerActivity.this, personBean.getUid() + "",
                                personBean.getHead_pic(), personBean.getName(), telephone, personBean.getIs_active());
                    }
                }
            });
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
             * 工作信息
             */
            TextView workInfo;
            /**
             * 去评价按钮
             */
            TextView leftBtn;
            /**
             * 跟他对账按钮
             */
            TextView rightBtn;
            /**
             * 头像、HashCode文本
             */
            RoundeImageHashCodeTextLayout roundImageHashText;
            /**
             * 选择框
             */
            ImageView selectIcon;
            /**
             * 常选工人，班组长提醒
             */
            TextView firstTips;


            View itemLayout;


            public ViewHolder(View convertView) {
                catalog = (TextView) convertView.findViewById(R.id.catalog);
                itemLayout = convertView.findViewById(R.id.itemLayout);
                selectIcon = (ImageView) convertView.findViewById(R.id.selectIcon);
                background = convertView.findViewById(R.id.background);
                userName = (TextView) convertView.findViewById(R.id.name);
                workInfo = (TextView) convertView.findViewById(R.id.workInfo);
                leftBtn = (TextView) convertView.findViewById(R.id.leftBtn);
                rightBtn = (TextView) convertView.findViewById(R.id.rightBtn);
                firstTips = convertView.findViewById(R.id.firstTips);
                roundImageHashText = (RoundeImageHashCodeTextLayout) convertView.findViewById(R.id.roundImageHashText);

                firstTips.setText(UclientApplication.getRoler(getApplicationContext()).equals(Constance.ROLETYPE_FM) ? "常选工人" : "常选班组长");
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
                        return i;
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
                return -1;
            }
            return getItem(position).getSortLetters().charAt(0);
        }


        public List<PersonBean> getList() {
            return list;
        }


    }

}
