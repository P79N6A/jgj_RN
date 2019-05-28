package com.jizhi.jlongg.main.activity;

import android.annotation.TargetApi;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.support.v4.content.ContextCompat;
import android.text.Html;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.TextView;

import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.account.NewAccountActivity;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.DiffBill;
import com.jizhi.jlongg.main.bean.PayRollList;
import com.jizhi.jlongg.main.bean.PayRollProList;
import com.jizhi.jlongg.main.bean.status.CommonJson;
import com.jizhi.jlongg.main.dialog.CheckBillDialog;
import com.jizhi.jlongg.main.util.AccountUtil;
import com.jizhi.jlongg.main.util.BackGroundUtil;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.NameUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SingsHttpUtils;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.client.HttpRequest;

import java.util.Calendar;
import java.util.List;

import static com.jizhi.jlongg.main.util.Constance.REQUEST;

/**
 * 功能: 工资清单详情
 * 作者：Xuj
 * 时间: 2016-7-19 11:10
 */
public class PayrollDetailLastActivity extends BaseActivity implements View.OnClickListener {
    /**
     * 当前时间的年月日
     */
    private int year, month;
    /**
     * 上一个月文字描述
     */
    private TextView previousMonthText;
    /**
     * 下一个月文字描述
     */
    private TextView nextMonthText;
    /**
     * 当前日期描述
     */
    private TextView currentDate;
    /**
     * 当前月总发生
     */
    private TextView currentMonthMoney;
    /**
     * 统计
     */
    private TextView countText;
    /**
     * 列表适配器
     */
    private PayRollListAdapter adapter;
    /**
     * 没有数据时展示的默认页
     */
    private LinearLayout defaultLayout;
    /**
     * 根布局 主要是popWindow所需
     */
    private View rootView;
    /**
     * 下载账单
     */
    private TextView downLoadTxt;

    /**
     * @param context
     * @param uid             用户id
     * @param pid             项目id
     * @param personOrProName 项目名称或班组长、工人名称
     * @param title           导航栏标题
     * @param date            当前日期
     * @param classType       类型 person   project
     * @param targetId        目标id
     */
    public static void actionStart(Activity context, String uid, String pid, String personOrProName, String title, String date, String classType, String targetId) {
        Intent intent = new Intent(context, PayrollDetailLastActivity.class);
        intent.putExtra("param1", uid);
        intent.putExtra("param2", pid);
        intent.putExtra("param3", personOrProName);
        intent.putExtra("param4", title);
        intent.putExtra("param5", date);
        intent.putExtra("param6", classType);
        intent.putExtra("param7", targetId);
        context.startActivityForResult(intent, REQUEST);
    }


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.payroll_detail_last);
        Intent intent = getIntent();
        String uid = intent.getStringExtra("param1");
        if (TextUtils.isEmpty(uid)) {
            CommonMethod.makeNoticeShort(this, "获取id出错了", CommonMethod.ERROR);
            finish();
            return;
        }
        initView();
        setNextAndPreviousMonth();
        getData();
    }

    private void initView() {
        Intent intent = getIntent();
        rootView = findViewById(R.id.rootView);
        downLoadTxt = getTextView(R.id.right_title);
        defaultLayout = (LinearLayout) findViewById(R.id.defaultLayout);
        previousMonthText = getTextView(R.id.previousMonthText);
        nextMonthText = getTextView(R.id.nextMonthText);
        currentDate = getTextView(R.id.currentDate);
        currentMonthMoney = getTextView(R.id.currentMonthMoney);
        countText = getTextView(R.id.countText);

        getTextView(R.id.title).setText(intent.getStringExtra("param4"));
        downLoadTxt.setText(getString(R.string.downloadbill));

        String date = intent.getStringExtra("param5");
        String[] dates = date.split("-");
        year = Integer.parseInt(dates[0]);
        month = Integer.parseInt(dates[1]);

        currentDate.setText(String.format(getString(R.string.date_desc), year, month, "工资"));
//        currentDate.setText(String.format(getString(R.string.date_desc), year, month, UclientApplication.getRoler(this).equals(Constance.ROLETYPE_WORKER) ? "收入" : "工资"));
    }

    public RequestParams params() {
        Intent intent = getIntent();
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        params.addBodyParameter("uid", intent.getStringExtra("param1"));
        params.addBodyParameter("pid", intent.getStringExtra("param2"));
        params.addBodyParameter("month", year + "" + (month < 10 ? "0" + month : month)); //日期
        return params;
    }

    private void setAdapter(List<PayRollList> list) {
        defaultLayout.setVisibility(list == null || list.size() == 0 ? View.VISIBLE : View.GONE);
        if (adapter == null) {
            ListView listView = (ListView) findViewById(R.id.listView);
            adapter = new PayRollListAdapter(this, list);
            listView.setAdapter(adapter);
            listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
                @Override
                public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                    PayRollList bean = adapter.getList().get(position);
                    final String accountType = bean.getAccounts_type();  //获取记账类型  1表示点工  2.表示包工  3.表示借支  4.表示结算
                    final int accountId = Integer.parseInt(bean.getId()); //记账id
                    final String currentRole = UclientApplication.getRoler(getApplicationContext());//当前角色
                    if (bean.getAmounts_diff() == 1) { //有差帐


                        AccountUtil.getPoorInfo(PayrollDetailLastActivity.this, bean.getId(), "", new AccountUtil.GetPoorInfoListener() {
                            @Override
                            public void loadSuccess(DiffBill bean) { //差帐信息
                                CheckBillDialog showPoorDialog = new CheckBillDialog(PayrollDetailLastActivity.this, accountType, bean, accountId, currentRole, new CheckBillDialog.MpoorinfoCLickListener() { //差帐dialog
                                    @Override
                                    public void mpporClick(DiffBill bean, String type, View agreeBtn) { //点击复制记账按钮
                                        AccountUtil.copyAccount(PayrollDetailLastActivity.this, bean, accountType, new AccountUtil.CopyAccountListener() {
                                            @Override
                                            public void copySuccess() { //复制记账数据成功
                                                getData(); //重新获取列表数据
                                            }
                                        });
                                    }
                                }, false);
                                showPoorDialog.showAtLocation(rootView, Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0); //设置layout在PopupWindow中显示的位置
                                BackGroundUtil.backgroundAlpha(PayrollDetailLastActivity.this, 0.5F);
                            }
                        });
                    } else { //如果没有差帐则进入记账详情
//                        AccountDetailActivity.actionStart(PayrollDetailLastActivity.this, accountType, accountId, currentRole,true);
                    }
                }
            });
        } else {
            adapter.updateList(list);
        }
    }

//    /**
//     * 处理ListView 子项点击事件
//     *
//     * @param payRollList
//     */
//    private void handlerListItemClick(final PayRollList payRollList) {
//
//        //获取当前账目是否有差帐信息
//        AccountUtil.AccountIsDiff(PayrollDetailLastActivity.this, payRollList.getId(), new AccountUtil.AccountIsDiff() {
//            @Override
//            public void loadSuccess(int isDiff) {
//                if (isDiff == 0) {//没有差账 直接进入账目编辑页
//                    if (TextUtils.isEmpty(accountType)) { //记账类型为空
//                        return;
//                    }
//                    Intent intent = new Intent();
//                    if (accountType.equals(AccountUtil.HOUR_WORKER)) {  //点工
//                        intent.setClass(PayrollDetailLastActivity.this, EditHourWorkerBookKeepingActivity.class);
//                    } else if (accountType.equals(AccountUtil.CONSTRACTOR)) {  //包工
//                        intent.setClass(PayrollDetailLastActivity.this, EditAllBookKeepingActivity.class);
//                    } else if (accountType.equals(AccountUtil.BORROWING)) {  //借支
//                        intent.setClass(PayrollDetailLastActivity.this, EditBorrowingBookKeepingActivity.class);
//                    } else if (accountType.equals(AccountUtil.SALARY_BALANCE)) {  //结算
//                        intent.setClass(PayrollDetailLastActivity.this, EditWagesBookKeepingActivity.class);
//                    }
//                    intent.putExtra(Constance.BEAN_INT, Integer.parseInt(payRollList.getId()));
//                    startActivityForResult(intent, Constance.REQUEST);
//                } else {//存在差账 获取差帐的信息
//
//                }
//            }
//        });
//    }


    /**
     * 根据用户id查询个人清单
     */
    public void getData() {
        downLoadTxt.setVisibility(View.GONE);
        if (adapter != null) { //为了保证数据的完整性 ,先清空在设置
            adapter.updateList(null);
        }
        currentMonthMoney.setText("¥0.00");
        String URL = NetWorkRequest.STREAMDETAILSTANDARD;
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, URL, params(), new RequestCallBackExpand<String>() {
            @Override
            public void onSuccess(ResponseInfo<String> responseInfo) {
                try {
                    CommonJson<PayRollProList> base = CommonJson.fromJson(responseInfo.result, PayRollProList.class);
                    if (base.getState() != 0 && base.getValues() != null) {
                        downLoadTxt.setVisibility(View.VISIBLE);
                        PayRollProList bean = base.getValues();
                        currentMonthMoney.setTextColor(ContextCompat.getColor(getApplicationContext(), bean.getTotal_month() >= 0 ? R.color.app_color : R.color.green)); //设置收入颜色
                        currentMonthMoney.setText(Utils.m2(bean.getTotal_month())); //设置当前月收入
                        setAdapter(bean.getWorkday());
                        countText.setText(Html.fromHtml("<font color='#999999'>合计:&nbsp;&nbsp;&nbsp;上班&nbsp;</font>" +
                                "<font color='#d7252c'>" + bean.getTotal_manhour() + "</font><font  color='#999999'>个工&nbsp;&nbsp;|&nbsp;加班&nbsp;</font>" +
                                "<font color='#d7252c'>" + bean.getTotal_over() + "</font><font  color='#999999'>个工</font>"));
                    } else {
                        CommonMethod.makeNoticeShort(PayrollDetailLastActivity.this, base.getErrmsg(), CommonMethod.ERROR);
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    CommonMethod.makeNoticeShort(PayrollDetailLastActivity.this, getString(R.string.service_err), CommonMethod.ERROR);
                    finish();
                } finally {
                    closeDialog();
                }
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
                super.onFailure(exception, errormsg);
                finish();
            }
        });
    }


    public void dateChanged() {
        setNextAndPreviousMonth();
//        currentDate.setText(String.format(getString(R.string.date_desc), year, month, UclientApplication.getRoler(this).equals(Constance.ROLETYPE_WORKER) ? "收入" : "应付"));
        currentDate.setText(String.format(getString(R.string.date_desc), year, month, "工资"));
        getData();

    }

    /**
     * 设置上一个和下一个月的描述
     */
    private void setNextAndPreviousMonth() {
        int previousMonth = month - 1;//上个月
        int nextMonth = month + 1;//下个月
        previousMonthText.setText((previousMonth == 0 ? 12 : previousMonth) + "月");
        nextMonthText.setText((nextMonth == 13 ? 1 : nextMonth) + "月");
    }


    @Override
    public void onClick(View v) {
        Intent intent = null;
        switch (v.getId()) {
            case R.id.previousMonthText: //上一个月
                if (year == 2014 && month == 1) {
                    return;
                }
                month -= 1;
                if (month == 0) {
                    year -= 1;
                    month = 12;
                }
                dateChanged();
                break;
            case R.id.nextMonthText: //下一个月
                Calendar calendar = Calendar.getInstance();
                int mYear = calendar.get(calendar.YEAR);
                int mMonth = calendar.get(calendar.MONTH) + 1;
                if (year == mYear && month == mMonth) {
                    return;
                }
                month += 1;
                if (month == 13) {
                    year += 1;
                    month = 1;
                }
                dateChanged();
                break;
            case R.id.right_title: //下载账单
                StringBuilder builder = new StringBuilder();
                String role = UclientApplication.getRoler(this);
                String selectedDate = year + "-" + (month < 10 ? "0" + month : month) + "-01";
                builder.append("role=" + role + "&");
                builder.append("class_type=" + getIntent().getStringExtra("param6") + "&");
                builder.append("date=" + selectedDate + "&");
//                builder.append("target_id=" + getIntent().getStringExtra("param7") + "&");
                //此处替换uid很pid
                builder.append("target_id=" + getIntent().getStringExtra("param2") + "&");
                builder.append("uid=" + getIntent().getStringExtra("param1") + "&");

                builder.append("week=0&"); //0(非周报)，1(周报)
                intent = new Intent(this, X5WebViewActivity.class);
                intent.putExtra("url", NetWorkRequest.BILL + "?" + builder.toString());
                break;
            case R.id.record_layout: //在记一笔
                intent = new Intent(this, NewAccountActivity.class);
                intent.putExtra(Constance.enum_parameter.ROLETYPE.toString(), UclientApplication.getRoler(PayrollDetailLastActivity.this));
                break;
        }
        if (intent != null) {
            startActivityForResult(intent, Constance.REQUEST);
        }
    }


    /**
     * 功能:工资清单某月详情适配器
     * 时间:2017年4月21日16:06:02
     * 作者:xuj
     */
    public class PayRollListAdapter extends BaseAdapter {
        /**
         * 工资清单数据
         */
        private List<PayRollList> list;
        /**
         * xml解析器
         */
        private LayoutInflater inflater;
        /**
         * Context
         */
        private Context context;


        public void updateList(List<PayRollList> list) {
            this.list = list;
            notifyDataSetChanged();
        }

        public PayRollListAdapter(Context context, List<PayRollList> list) {
            super();
            this.list = list;
            this.context = context;
            inflater = LayoutInflater.from(context);
        }

        @Override
        public int getCount() {
            return list == null ? 0 : list.size();
        }

        @Override
        public Object getItem(int position) {
            return list.get(position);
        }

        @Override
        public long getItemId(int position) {
            return position;
        }


        @TargetApi(Build.VERSION_CODES.JELLY_BEAN)
        @Override
        public View getView(final int position, View convertView, ViewGroup parent) {
            ViewHolder holder;
            if (convertView == null) {
                convertView = inflater.inflate(R.layout.item_payroll_detail_value, null);
                holder = new ViewHolder(convertView);
                convertView.setTag(holder);
            } else {
                holder = (ViewHolder) convertView.getTag();
            }
            bindData(holder, position);

            return convertView;
        }

        private void bindData(ViewHolder holder, int position) {
            PayRollList workDetail = list.get(position);
            holder.dateTurn.setText(workDetail.getDate_turn());
            holder.dateTxt.setText(workDetail.getDate_txt());
            holder.proName.setText(workDetail.getProname()); //设置项目名称
            holder.recordWorkName.setText(NameUtil.setName(workDetail.getWorker_name())); //设置工人名称
            holder.foremanName.setText(Html.fromHtml("<font color='#999999'>工头  </font><font color='#333333'>" + NameUtil.setName(workDetail.getForeman_name()) + "</font>")); //设置工头名称
            holder.workMoney.setText(workDetail.getAmounts()); //设置金额
            switch (workDetail.getAccounts_type()) {
                case AccountUtil.HOUR_WORKER: //点工

//                    if (workDetail.getIs_rest() == 1) { //休息
//                        holder.recordTips1.setText("休息");
//                    } else {
//                        holder.recordTips1.setText(Html.fromHtml("<font color='#333333'>上班 " + workDetail.getManhour() +
//                                "小时</font><font color='#999999'>(" + workDetail.getWorking_hours() +
//                                "个工)</font>")); //上班工时
//                    }
//                    if (workDetail.getOvertime() == 0) { //加班时长
//                        holder.recordTips2.setVisibility(View.GONE);
//                    } else {
//                        holder.recordTips2.setText(Html.fromHtml("<font color='#333333'>加班 " + workDetail.getOvertime() + "小时</font><font color='#999999'>(" + workDetail.getOvertime_hours() +
//                                "个工)</font>")); //加班工时
//                        holder.recordTips2.setVisibility(View.VISIBLE);
//                    }
//                    holder.recordTips1.setText(RecordUtils.getNormalWorkString(workDetail.getManhour(), workDetail.getWorking_hours(),true));
//                    holder.recordTips2.setText(RecordUtils.getOverTimeWorkString(workDetail.getOvertime(), workDetail.getOvertime_hours(),true));
                    holder.workMoney.setTextColor(ContextCompat.getColor(context, R.color.app_color));
                    break;
                case AccountUtil.CONSTRACTOR: //包工
                    holder.recordTips1.setText("包工");
                    holder.recordTips2.setVisibility(View.GONE);
                    holder.workMoney.setTextColor(ContextCompat.getColor(context, R.color.app_color));
                    break;
                case AccountUtil.BORROWING: //借支
                    holder.recordTips1.setText("借支");
                    holder.recordTips2.setVisibility(View.GONE);
                    holder.workMoney.setTextColor(ContextCompat.getColor(context, R.color.green));
                    break;
                case AccountUtil.SALARY_BALANCE: //结算
                    holder.recordTips1.setText("结算");
                    holder.recordTips2.setVisibility(View.GONE);
                    holder.workMoney.setTextColor(ContextCompat.getColor(context, R.color.green));
                    break;
            }
            holder.recordStateIcon.setImageResource(workDetail.getAmounts_diff() == 1 ? //getModify_marking为1表示有差帐
                    R.drawable.chazhang_icon : R.drawable.houtui);
        }


        class ViewHolder {
            public ViewHolder(View convertView) {
                dateTxt = (TextView) convertView.findViewById(R.id.dateTxt);
                dateTurn = (TextView) convertView.findViewById(R.id.dateTurn);
                itemLayout = convertView.findViewById(R.id.itemLayout);
                proName = (TextView) convertView.findViewById(R.id.proName);
                recordWorkName = (TextView) convertView.findViewById(R.id.recordWorkName);
                foremanName = (TextView) convertView.findViewById(R.id.foremanName);
                recordTips1 = (TextView) convertView.findViewById(R.id.recordTips1);
                recordTips2 = (TextView) convertView.findViewById(R.id.recordTips2);
                recordStateIcon = (ImageView) convertView.findViewById(R.id.recordStateIcon);
                workMoney = (TextView) convertView.findViewById(R.id.workMoney);
            }


            /**
             * 日期
             */
            TextView dateTxt;
            /**
             * 阴历
             */
            TextView dateTurn;
            /**
             * 记账人名称
             */
            TextView recordWorkName;
            /**
             * 记账提示1
             */
            TextView recordTips1;
            /**
             * 记账提示2
             */
            TextView recordTips2;
            /**
             * 工头名称
             */
            TextView foremanName;
            /**
             * 记账金额
             */
            TextView workMoney;
            /**
             * 记账状态图标
             */
            ImageView recordStateIcon;
            /**
             * 项目名称
             */
            TextView proName;
            /**
             * item标签
             */
            View itemLayout;
        }

        public List<PayRollList> getList() {
            return list;
        }

        public void setList(List<PayRollList> list) {
            this.list = list;
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == Constance.REQUEST) {
            getData();
        }
    }
}
