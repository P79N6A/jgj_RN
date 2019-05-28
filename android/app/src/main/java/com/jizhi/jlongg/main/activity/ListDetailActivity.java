package com.jizhi.jlongg.main.activity;

import android.annotation.TargetApi;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.PopupWindow;
import android.widget.TextView;

import com.hcs.uclient.utils.AppUtils;
import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.account.NewAccountActivity;
import com.jizhi.jlongg.main.adpter.ListDetailAdapter;
import com.jizhi.jlongg.main.adpter.ListProjectOrPeopleAdapter;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.BaseNetBean;
import com.jizhi.jlongg.main.bean.BillingList;
import com.jizhi.jlongg.main.bean.BillingListDetail;
import com.jizhi.jlongg.main.bean.DiffBill;
import com.jizhi.jlongg.main.bean.Project;
import com.jizhi.jlongg.main.bean.WorkerDay;
import com.jizhi.jlongg.main.bean.status.CommonJson;
import com.jizhi.jlongg.main.bean.status.CommonListJson;
import com.jizhi.jlongg.main.dialog.CheckBillDialog;
import com.jizhi.jlongg.main.dialog.SpinerPopWindow;
import com.jizhi.jlongg.main.util.AccountUtil;
import com.jizhi.jlongg.main.util.BackGroundUtil;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
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

import java.util.List;

/**
 * 功能: 记工清单
 * 时间:2016/3/14 14:42
 * 作者: xuj
 */
//Record workpoints listing
public class ListDetailActivity extends BaseActivity implements View.OnClickListener, CheckBillDialog.MpoorinfoCLickListener, SpinerPopWindow.SelectReturnListener, AdapterView.OnItemClickListener {

    private String TAG = getClass().getName();
    /**
     * 1.人  2.项目 3、记账详情
     */
    private int filter;
    /**
     * 记账详情Adapter
     */
    private ListDetailAdapter detailAdapter;
    /**
     * 记账分类Adapter
     */
    private ListProjectOrPeopleAdapter typeAdapter;
    /**
     * 检查差帐状态Dialog
     */
    private CheckBillDialog diaglog;
    /**
     * 记账详情数据
     */
    private List<WorkerDay> detailList;
    /**
     * 记账分类数据
     */
    private List<BillingListDetail> typeList;
    /**
     * 项目列表弹出框
     */
    private SpinerPopWindow mSpinerPopWindow;
    @ViewInject(R.id.project_layout)
    private LinearLayout project_layout;
    /**
     * 箭头
     */
    @ViewInject(R.id.point)
    private ImageView point;
    /**
     * 项目名称
     */
    @ViewInject(R.id.name)
    private TextView name;

    /**
     * listView
     */
    @ViewInject(R.id.listView)
    private ListView listView;
    /**
     * 项目id
     */
    private int pid;
    /**
     * 项目数据
     */
    private List<Project> projectList;
    /**
     * 记录项目名称 如果请求接口失败则返回
     */
    private String projectName;

    /**
     * 项目回调
     */
    @Override
    public void onItemClickReturn(int pos) {
        projectName = projectList.get(pos).getPro_name();
        pid = projectList.get(pos).getPid();
        name.setText(projectName);
        searchingListData();
    }

    private void showSpinWindow() {
        point.setImageResource(R.drawable.red_top);
        mSpinerPopWindow.showAsDropDown(project_layout);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.list_detail);
        ViewUtils.inject(this); // Xutil必须调用的一句话
        initView();
        searchingListData();
    }


    public void initView() {
        Intent intent = getIntent();
        filter = intent.getIntExtra(Constance.BEAN_INT, -1);
        if (filter == -1) {
            finish();
            return;
        }
        pid = intent.getIntExtra(Constance.PID, 0);
        String role = UclientApplication.getRoler(this);
        switch (filter) {
            case Constance.TYPE_PROJECT: //点击看项目
                SetTitleName.setTitle(findViewById(R.id.title), String.format(getString(R.string.about_project), getIntent().getStringExtra(Constance.BEAN_STRING))); //设置标题
                if (role.equals(Constance.ROLETYPE_FM) && pid != 0) {
                    SetTitleName.setTitle(findViewById(R.id.right_title), "同步账单"); //设置标题
                }
                findViewById(R.id.record_layout).setVisibility(View.GONE);
                findViewById(R.id.project_layout).setVisibility(View.GONE);
                getTextView(R.id.title_text_one).setText(getString(R.string.forman_headman));
                getTextView(R.id.title_text_two).setText(getString(R.string.amounts));
                getTextView(R.id.title_text_three).setText(getString(R.string.total));
                break;
            case Constance.TYPE_PERSON: //点击看人
                SetTitleName.setTitle(findViewById(R.id.title), String.format(getString(R.string.about_person), getIntent().getStringExtra(Constance.BEAN_STRING))); //设置标题
                findViewById(R.id.project_layout).setVisibility(View.GONE);
                findViewById(R.id.record_layout).setVisibility(View.GONE);
                getTextView(R.id.title_text_one).setText(getString(R.string.project_name_title));
                getTextView(R.id.title_text_two).setText(getString(R.string.amounts));
                getTextView(R.id.title_text_three).setText(getString(R.string.total));
                break;
            case Constance.TYPE_DETAIL: //详情
                projectName = intent.getStringExtra(Constance.PROJECTNAME); //传递过来的项目名称
                name.setText(projectName);
                SetTitleName.setTitle(findViewById(R.id.title), getIntent().getStringExtra(Constance.BEAN_STRING));//设置标题
                boolean isProject = intent.getBooleanExtra(Constance.BEAN_BOOLEAN, false); //上个页面是否是查看项目
                if (!isProject) {
                    SetTitleName.setTitle(findViewById(R.id.right_title), "下载账单"); //设置标题
                }
                getTextView(R.id.title_text_one).setText(getString(R.string.title_date));
                getTextView(R.id.title_text_two).setText(getString(R.string.title_content));
                getTextView(R.id.title_text_three).setText(getString(R.string.total));
                project_layout.setOnClickListener(this);
                break;
        }
        listView.setOnItemClickListener(this);
    }

    public RequestParams params() {
        Intent intent = getIntent();
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        params.addBodyParameter("month", intent.getStringExtra(Constance.YEAR) + intent.getStringExtra(Constance.MONTH)); //日期
        params.addBodyParameter("filter", filter + ""); //检索形式（1按人id、2按项目id）
        params.addBodyParameter("id", filter == Constance.TYPE_PROJECT ? intent.getIntExtra(Constance.PID, -1) + "" : intent.getStringExtra(Constance.UID));
        params.addBodyParameter("uid", intent.getStringExtra(Constance.UID));
        params.addBodyParameter("pid", pid + "");
        return params;
    }

    /**
     * 查询列表数据
     */
    public void searchingListData() {
        String URL = null;
        if (filter == Constance.TYPE_PROJECT || filter == Constance.TYPE_PERSON) { //所属账目列表
            URL = NetWorkRequest.GETWITHPEOPLEPROJECT;
        } else { //记账详情
            URL = NetWorkRequest.STREAMDETAIL;
        }
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, URL,
                params(), new RequestCallBackExpand<String>() {
                    @Override
                    public void onSuccess(ResponseInfo<String> responseInfo) {
                        LUtils.e(TAG, responseInfo.result);
                        try {
                            CommonJson<BillingList> base = CommonJson.fromJson(responseInfo.result, BillingList.class);
                            if (base.getState() != 0) {
                                update(base.getValues());
                                return;
                            } else {
                                CommonMethod.makeNoticeShort(ListDetailActivity.this, base.getErrmsg(), CommonMethod.ERROR);
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                            CommonMethod.makeNoticeShort(ListDetailActivity.this, getString(R.string.service_err), CommonMethod.ERROR);
                        } finally {
                            closeDialog();
                        }
                        finish();
                    }

                    @Override
                    public void onFailure(HttpException exception, String errormsg) {
                        super.onFailure(exception, errormsg);
                        finish();
                    }
                });
    }


    @TargetApi(Build.VERSION_CODES.JELLY_BEAN)
    public void update(final BillingList bean) {
        if (findViewById(R.id.main).getVisibility() == View.GONE) {
            findViewById(R.id.main).setVisibility(View.VISIBLE); //显示主页面
        }
        TextView t_total = getTextView(R.id.t_total); //当月总收入情况
        TextView month_txt = getTextView(R.id.month_txt); //月份
        TextView status = getTextView(R.id.status); //收支状况   欠钱还是  不欠钱
        t_total.setText(Utils.m2(Double.parseDouble(bean.getM_total())));
        month_txt.setText(bean.getMonth_txt());
        if (Float.parseFloat(bean.getM_total()) < 0) {
            t_total.setTextColor(getResources().getColor(R.color.green_7ec568)); //当金额小于0时显示绿色的文字
        } else {
            t_total.setTextColor(getResources().getColor(R.color.red_f75a23)); //当金额大于0时显示红色的文字
        }
        if (!TextUtils.isEmpty(bean.getMonth_total_txt())) {//是否欠钱
            status.setText(bean.getMonth_total_txt());
            status.setVisibility(View.VISIBLE);
            Utils.setBackGround(status, getResources().getDrawable(R.drawable.bg_gn_7ec568_3radius));
        } else {
            status.setVisibility(View.GONE);
        }
        if (filter == Constance.TYPE_DETAIL) { //账目详情
            detailList = bean.getWorkday();
            if (detailAdapter == null) {
                detailAdapter = new ListDetailAdapter(this, detailList);
                listView.setAdapter(detailAdapter);
            } else {
                detailAdapter.setList(detailList);
                detailAdapter.notifyDataSetChanged();
            }
            if (bean.getPro_list() != null && bean.getPro_list().size() > 0) {
                projectList = bean.getPro_list();
                if (mSpinerPopWindow == null) {
                    mSpinerPopWindow = new SpinerPopWindow(this, projectList, this, getIntent().getStringExtra(Constance.PROJECTNAME));
                    mSpinerPopWindow.setWidth(project_layout.getWidth());
                    mSpinerPopWindow.setOnDismissListener(new PopupWindow.OnDismissListener() {
                        @Override
                        public void onDismiss() {
                            point.setImageResource(R.drawable.red_down);
                        }
                    });
                } else {
                    mSpinerPopWindow.setList(projectList, projectName);
                }
            }
        } else { // 账目分类
            typeList = bean.getList();
            if (typeAdapter == null) {
                typeAdapter = new ListProjectOrPeopleAdapter(this, typeList, filter);
                listView.setAdapter(typeAdapter);
            } else {
                typeAdapter.setList(typeList);
                typeAdapter.notifyDataSetChanged();
            }

        }
    }


    /**
     * 获取差帐详情
     *
     * @param id
     * @param type 差帐类型
     */
    public void getShowPoor(String id, final String type) {
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        params.addBodyParameter("id", id);
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.SHOW_POOR_TIP, params,
                new RequestCallBackExpand<String>() {
                    @Override
                    public void onSuccess(ResponseInfo<String> responseInfo) {
                        LUtils.e(TAG, responseInfo.result);
                        try {
                            CommonJson<DiffBill> bean = CommonJson.fromJson(responseInfo.result, DiffBill.class);
                            if (bean.getState() == 0) {
                                CommonMethod.makeNoticeShort(ListDetailActivity.this, bean.getErrmsg(), CommonMethod.ERROR);
                            } else {
                                if (bean.getValues() != null && bean.getValues().getMain_role() != 0) {
                                    if (diaglog == null) {
                                        diaglog = new CheckBillDialog(ListDetailActivity.this, type, bean.getValues(), ListDetailActivity.this);
                                    } else {
                                        diaglog.setValue(type, bean.getValues());
                                    }
                                    diaglog.showAtLocation(findViewById(R.id.main), Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0); //设置layout在PopupWindow中显示的位置
                                    BackGroundUtil.backgroundAlpha(ListDetailActivity.this, 0.5F);
                                }
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                            CommonMethod.makeNoticeShort(ListDetailActivity.this, getString(R.string.service_err), CommonMethod.ERROR);
                        } finally {
                            closeDialog();
                        }
                    }
                });
    }

    @Override
    public void mpporClick(DiffBill bean, String type, View agreeBtn) {
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        params.addBodyParameter("id", bean.getId() + "");
        params.addBodyParameter("main_set_amount", bean.getSecond_set_amount() + "");
        params.addBodyParameter("main_manhour", type.equals(AccountUtil.HOUR_WORKER) ? bean.getSecond_manhour() + "" : (int) bean.getSecond_set_unitprice() + "");
        params.addBodyParameter("main_overtime", type.equals(AccountUtil.HOUR_WORKER) ? bean.getSecond_overtime() + "" : bean.getSecond_set_quantities() + "");
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.MPOORINFO, params,
                new RequestCallBackExpand<String>() {
                    @Override
                    public void onSuccess(ResponseInfo<String> responseInfo) {
                        LUtils.e(TAG, responseInfo.result);
                        try {
                            CommonListJson<BaseNetBean> bean = CommonListJson.fromJson(responseInfo.result, BaseNetBean.class);
                            if (bean.getState() == 0) {
                                CommonMethod.makeNoticeShort(ListDetailActivity.this, bean.getErrmsg(), CommonMethod.ERROR);
                            } else {
                                diaglog.dismiss();
                                isUpdate = true;
                                searchingListData();
                                CommonMethod.makeNoticeShort(ListDetailActivity.this, "修改成功", CommonMethod.SUCCESS);
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                            CommonMethod.makeNoticeShort(ListDetailActivity.this, getString(R.string.service_err), CommonMethod.ERROR);
                        } finally {
                            closeDialog();
                        }
                    }

                });
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == Constance.DISPOSEATTEND_RESULTCODE) { //编辑保存成功
            isUpdate = true;
            if (data != null) {
                projectName = data.getStringExtra(Constance.BEAN_STRING);
                projectName = TextUtils.isEmpty(projectName) ? "其他项目" : projectName;
                if (!TextUtils.isEmpty(projectName) && !projectName.equals(name.getText().toString())) {
                    name.setText(projectName);
                    pid = data.getIntExtra(Constance.PID, 0);
                }
            }
            searchingListData();
        } else if (resultCode == Constance.SUCCESS) {
            isUpdate = true;
            searchingListData();
        }
    }

    @Override
    public void onClick(View v) {
        Intent intent = null;
        switch (v.getId()) {
            case R.id.record_layout:
                intent = new Intent(this, NewAccountActivity.class);
                intent.putExtra(Constance.enum_parameter.ROLETYPE.toString(), UclientApplication.getRoler(this));
                startActivityForResult(intent, 100);
                break;
            case R.id.project_layout:
                showSpinWindow();
                break;
            case R.id.right_title:
                if (filter == Constance.TYPE_DETAIL) {
                    intent = getIntent();
                    String year = intent.getStringExtra(Constance.YEAR);
                    String month = intent.getStringExtra(Constance.MONTH);
                    String target_uid = intent.getStringExtra(Constance.UID);
                    String cur_uid = intent.getStringExtra("cur_uid");
                    StringBuilder sb = new StringBuilder();
                    String role = UclientApplication.getRoler(this);
                    role = role.equals(Constance.ROLETYPE_WORKER) ? Constance.ROLETYPE_FM : Constance.ROLETYPE_WORKER;
                    sb.append("role=" + role + "&");
                    sb.append("year=" + year + "&");
                    sb.append("month=" + month + "&");
                    sb.append("cur_uid=" + cur_uid + "&");
                    sb.append("type=down&");
                    sb.append("target_uid=" + target_uid + "&");
                    sb.append("ver=" + AppUtils.getVersionName(this));
                    intent.setClass(this, DownLoadBillActivity.class);
                    intent.putExtra(Constance.BEAN_STRING, sb.toString());
                    intent.putExtra("year", year);
                    intent.putExtra("month", month);
                    startActivity(intent);
                } else {
                    intent = new Intent(this, SyncManagerActivity.class);
                    intent.putExtra(Constance.BEAN_BOOLEAN, true);
                    intent.putExtra(Constance.PID, pid);
                    intent.putExtra(Constance.BEAN_STRING, getIntent().getStringExtra(Constance.BEAN_STRING));
                    startActivityForResult(intent, Constance.REQUEST_ADD);
                }
                break;
        }
    }

    private boolean isUpdate;

    /**
     * 退出
     */
    public void onFinish(View view) {
        if (isUpdate) {
            setResult(Constance.SUCCESS);
        }
        finish();
    }


    @Override
    public void onBackPressed() {
        if (isUpdate) {
            setResult(Constance.SUCCESS);
        }
        super.onBackPressed();
    }


    @Override
    public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
        Intent intent = null;
        if (filter == Constance.TYPE_DETAIL) { //账目详情
//            WorkerDay day = detailList.get(position);
//            String type = day.getAccounts_type().getCode() + "";
//            if (day.getModify_marking() != 0) { //当前记录是否有差帐
//                getShowPoor(day.getId() + "", type);
//                return;
//            }
//            intent = new Intent();
//            if (type.equals(AccountUtil.HOUR_WORKER)) {
////                intent.setClass(ListDetailActivity.this, EditHourWorkerBookKeepingActivity.class);
//            } else if (type.equals(AccountUtil.CONSTRACTOR)) {
////                intent.setClass(ListDetailActivity.this, EditAllBookKeepingActivity.class);
//            } else if (type.equals(AccountUtil.BORROWING)) {
////                intent.setClass(ListDetailActivity.this, EditBorrowingBookKeepingActivity.class);
//            }
//            intent.putExtra(Constance.BEAN_INT, day.getId());
//            startActivityForResult(intent, Constance.EDITOR);
        } else {
            intent = getIntent();
            intent.setClass(ListDetailActivity.this, ListDetailActivity.class);
            intent.putExtra(Constance.BEAN_STRING, typeList.get(position).getName());
            intent.putExtra(Constance.PID, typeList.get(position).getPid()); //项目ID
            intent.putExtra(Constance.UID, typeList.get(position).getUid() + ""); //人物ID
            intent.putExtra(Constance.BEAN_BOOLEAN, filter == Constance.TYPE_PERSON ? false : true);
            intent.putExtra(Constance.BEAN_INT, Constance.TYPE_DETAIL); //
            intent.putExtra(Constance.PROJECTNAME, typeList.get(position).getPname());
            startActivityForResult(intent, 100);
        }
    }
}