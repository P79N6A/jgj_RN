package com.jizhi.jlongg.main.adpter;

import android.content.Context;
import android.support.v4.content.ContextCompat;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.RecordWorkConfirmMonth;
import com.jizhi.jlongg.main.bean.Salary;
import com.jizhi.jlongg.main.bean.WorkDetail;
import com.jizhi.jlongg.main.util.AccountUtil;
import com.jizhi.jlongg.main.util.NameUtil;
import com.jizhi.jlongg.main.util.RecordUtils;
import com.liaoinstan.springview.utils.DensityUtil;

import java.util.ArrayList;

/**
 * 作者    你的名字
 * 时间    2018-11-22 下午 3:12
 * 文件    yzg_android_s
 * 描述
 */
public class RecordWorkConfirmAdapter extends BaseAdapter {

    /**
     * 已删除的记账记录
     */
    private int DELETE_ACCOUNT = 0;
    /**
     * 正常状态的记账信息
     */
    private int NORMAL_HOUR_ACCOUNT = 1;
    /**
     * 正常状态的记账信息
     */
    private int NORMAL_OTHER_ACCOUNT = 2;
    /**
     * 列表数据
     */
    private ArrayList<RecordWorkConfirmMonth> list;
    /**
     * 上下文
     */
    private Context context;
    /**
     * 查看和确认按钮的回调
     */
    private RecordWorkConfirmCallBackListener listener;
    /**
     * 已经拉到底了没有数据
     */
    private boolean noDate;
    /**
     * 页码编号
     */
    private int pageNumber;


    public RecordWorkConfirmAdapter(Context context, ArrayList<RecordWorkConfirmMonth> list, RecordWorkConfirmCallBackListener listener) {
        this.context = context;
        this.list = list;
        this.listener = listener;
    }

    @Override
    public int getItemViewType(int position) {
        WorkDetail workDetail = list.get(position);
        boolean isDelete = workDetail.getIs_del() == 1 ? true : false;
        if (isDelete) {
            return DELETE_ACCOUNT;
        }
        String accountType = workDetail.getAccounts_type();
        return AccountUtil.HOUR_WORKER.equals(accountType) || AccountUtil.CONSTRACTOR_CHECK.equals(accountType) ? NORMAL_HOUR_ACCOUNT : NORMAL_OTHER_ACCOUNT;
    }

    @Override
    public int getViewTypeCount() {
        return 3;
    }

    @Override
    public int getCount() {
        return list == null ? 0 : list.size();
    }

    @Override
    public RecordWorkConfirmMonth getItem(int position) {
        return list.get(position);
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    @Override
    public View getView(final int position, View convertView, ViewGroup parent) {
        int itemType = getItemViewType(position);
        final ViewHolder viewHolder;
        if (convertView == null) {
            if (itemType == DELETE_ACCOUNT) { //已删除的数据
                convertView = LayoutInflater.from(context).inflate(R.layout.record_work_confirm_other_work, null);
            } else if (itemType == NORMAL_HOUR_ACCOUNT) {//点工布局
                convertView = LayoutInflater.from(context).inflate(R.layout.record_work_confirm_little_work, null);
            } else if (itemType == NORMAL_OTHER_ACCOUNT) {//其他记账类型 如包工、借支、结算
                convertView = LayoutInflater.from(context).inflate(R.layout.record_work_confirm_other_work, null);
            }
            viewHolder = new ViewHolder(convertView, itemType);
            convertView.setTag(viewHolder);
        } else {
            viewHolder = (ViewHolder) convertView.getTag();
        }
        bindData(viewHolder, itemType, position, convertView);
        return convertView;
    }


    private void bindData(final ViewHolder viewHolder, int itemType, final int position, final View convertView) {
        final RecordWorkConfirmMonth workDetail = getItem(position);
        if (position != 0) {
            if (workDetail.getCreate_time() == list.get(position - 1).getCreate_time()) {
                viewHolder.dateLayout.setVisibility(View.GONE);
                viewHolder.itemDiver.setVisibility(View.VISIBLE);
            } else {
                viewHolder.dateLayout.setVisibility(View.VISIBLE);
                viewHolder.itemDiver.setVisibility(View.GONE);
                if (!TextUtils.isEmpty(workDetail.getDate_desc())) {
                    viewHolder.date.setText(workDetail.getFormat_create_time() + "(" + workDetail.getDate_desc() + ")");
                } else {
                    viewHolder.date.setText(workDetail.getFormat_create_time());
                }
            }
        } else {
            viewHolder.dateLayout.setVisibility(View.VISIBLE);
            viewHolder.itemDiver.setVisibility(View.GONE);
            if (!TextUtils.isEmpty(workDetail.getDate_desc())) {
                viewHolder.date.setText(workDetail.getFormat_create_time() + "(" + workDetail.getDate_desc() + ")");
            } else {
                viewHolder.date.setText(workDetail.getFormat_create_time());
            }
        }
        viewHolder.scrollBottomLayout.setVisibility(noDate && position == getCount() - 1 ? View.VISIBLE : View.GONE);
        viewHolder.proName.setText(workDetail.getProname()); //设置项目名称
        viewHolder.recordWorkName.setText(NameUtil.setName(workDetail.getWorker_name())); //设置工人名称
        viewHolder.notesIcon.setVisibility(workDetail.getIs_notes() == 1 ? View.VISIBLE : View.GONE); //是否已设置了备注信息
        switch (workDetail.getRecord_type()) {
            case 1://新增
                viewHolder.recordType.setTextColor(ContextCompat.getColor(context.getApplicationContext(), R.color.color_1892E7));
                break;
            case 2://修改
                viewHolder.recordType.setTextColor(ContextCompat.getColor(context.getApplicationContext(), R.color.color_27B441));
                break;
            case 3://删除
                viewHolder.recordType.setTextColor(ContextCompat.getColor(context.getApplicationContext(), R.color.color_eb4e4e));
                break;
        }
        if (AccountUtil.CONSTRACTOR.equals(workDetail.getAccounts_type())) {
            if (workDetail.getContractor_type() == 1) { //承包
                viewHolder.foremanName.setText((UclientApplication.isForemanRoler(context) ? "承包对象:" : "班组长:") + NameUtil.setName(workDetail.getForeman_name())); //设置工头名称
            } else if (workDetail.getContractor_type() == 2) { //分包
                viewHolder.foremanName.setText("班组长:" + NameUtil.setName(workDetail.getForeman_name())); //设置工头名称
            }
        } else {
            viewHolder.foremanName.setText("班组长:" + NameUtil.setName(workDetail.getForeman_name())); //设置工头名称
        }
        viewHolder.recordType.setText(workDetail.getRecord_desc());
        if (itemType == DELETE_ACCOUNT) { //当前账已经删除
            switch (workDetail.getAccounts_type()) {
                case AccountUtil.HOUR_WORKER: //点工
                    viewHolder.workType.setText("删除点工");
                    viewHolder.recordTypeIcon.setVisibility(View.VISIBLE);
                    viewHolder.recordTypeIcon.setImageResource(R.drawable.hour_worker_flag);
                    break;
                case AccountUtil.CONSTRACTOR: //包工
                    if (workDetail.getContractor_type() == 1) { //承包
                        viewHolder.workType.setText("删除包工(承包)");
                    } else if (workDetail.getContractor_type() == 2) { //分包
                        viewHolder.workType.setText("删除包工(分包)");
                    }
                    viewHolder.recordTypeIcon.setVisibility(View.GONE);
                    break;
                case AccountUtil.BORROWING: //借支
                    viewHolder.workType.setText("删除借支");
                    viewHolder.recordTypeIcon.setVisibility(View.GONE);
                    break;
                case AccountUtil.SALARY_BALANCE: //结算
                    viewHolder.workType.setText("删除结算");
                    viewHolder.recordTypeIcon.setVisibility(View.GONE);
                    break;
                case AccountUtil.CONSTRACTOR_CHECK: //结算
                    viewHolder.workType.setText("删除包工记工天");
                    viewHolder.recordTypeIcon.setVisibility(View.VISIBLE);
                    viewHolder.recordTypeIcon.setImageResource(R.drawable.constar_flag);
                    break;
            }
            viewHolder.workMoney.setVisibility(View.GONE);
        } else {
            if (itemType == NORMAL_HOUR_ACCOUNT) { //点工
                bindHourWorkerInfo(viewHolder, workDetail);
            } else if (itemType == NORMAL_OTHER_ACCOUNT) { //包工 借支 结算
                bindOtherWorkerInfo(viewHolder, workDetail);
            }
        }
        if (viewHolder.notesIcon.getVisibility() == View.VISIBLE) {
            LinearLayout.LayoutParams params = (LinearLayout.LayoutParams) viewHolder.recordTypeIcon.getLayoutParams();
            params.bottomMargin = DensityUtil.dp2px(2);
            viewHolder.recordTypeIcon.setLayoutParams(params);
        }
        viewHolder.confirmSearchLayout.setVisibility(View.VISIBLE);
        viewHolder.confirm.setVisibility(View.VISIBLE);
        viewHolder.search.setVisibility(View.VISIBLE);
        View.OnClickListener onClickListener = new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                switch (view.getId()) {
                    case R.id.confirm: //确认记工
                        if (listener != null) {
                            listener.confirm(workDetail.getId(), position, convertView, viewHolder.confirm);
                        }
                        break;
                    case R.id.search: //查看记工
                        if (listener != null) {
                            listener.search(workDetail.getAccounts_type(), workDetail.getId(), position, convertView, viewHolder.confirm);
                        }
                        break;
                }
            }
        };
        viewHolder.confirm.setOnClickListener(onClickListener);
        viewHolder.search.setOnClickListener(onClickListener);
    }

    /**
     * 绑定点工记账信息
     *
     * @param workDetail
     */
    private void bindHourWorkerInfo(ViewHolder viewHolder, WorkDetail workDetail) {
        viewHolder.normalWork.setText(AccountUtil.getAccountShowTypeString(context, true, false, true, workDetail.getManhour(), workDetail.getWorking_hours()));
        viewHolder.overTimeWork.setText(AccountUtil.getAccountShowTypeString(context, true, false, false, workDetail.getOvertime(), workDetail.getOvertime_hours()));
//        if (workDetail.getSet_tpl() != null) {
//            viewHolder.salaryNormalWork.setText("上班" + RecordUtils.cancelIntergerZeroFloat(workDetail.getSet_tpl().getW_h_tpl()) + "小时算1个工"); //工资标准  上班时长
//            viewHolder.salaryOverTimeWork.setText("加班" + RecordUtils.cancelIntergerZeroFloat(workDetail.getSet_tpl().getO_h_tpl()) + "小时算1个工"); //工资标准 加班时长
//        }
        //4.0.2显示工资模板方式
        int hour_type = workDetail.getSet_tpl().getHour_type();
        Salary tplMode = workDetail.getSet_tpl();
        if (hour_type == 1) {//按小时
            if (tplMode.getW_h_tpl() != 0) {
                viewHolder.salaryNormalWork.setText("上班" + (tplMode.getW_h_tpl() + "").replace(".0", "") + "小时算一个工");
            }
            if (tplMode.getO_s_tpl() != 0) {
                viewHolder.salaryOverTimeWork.setText("加班" + (Utils.m2(tplMode.getO_s_tpl()) + "元/小时"));
            }
        } else {//按工天
            if (tplMode.getW_h_tpl() != 0) {
                viewHolder.salaryNormalWork.setText("上班" + (tplMode.getW_h_tpl() + "").replace(".0", "") + "小时算一个工");
            }
            if (tplMode.getO_h_tpl() != 0) {
                viewHolder.salaryOverTimeWork.setText("加班" + (tplMode.getO_h_tpl() + "").replace(".0", "") + "小时算一个工");
            }
        }
        viewHolder.recordTypeIcon.setImageResource(workDetail.getAccounts_type().equals(AccountUtil.HOUR_WORKER) ? R.drawable.hour_worker_flag : R.drawable.constar_flag);
    }

    /**
     * 绑定其他记账信息
     *
     * @param workDetail
     */
    private void bindOtherWorkerInfo(ViewHolder viewHolder, WorkDetail workDetail) {
        switch (workDetail.getAccounts_type()) {
            case AccountUtil.CONSTRACTOR: //包工
                boolean isForeman = UclientApplication.isForemanRoler(context);
                if (workDetail.getContractor_type() == 1) { //承包
                    viewHolder.workType.setText("包工(承包)");
                    viewHolder.workMoney.setTextColor(ContextCompat.getColor(context, isForeman ? R.color.borrow_color : R.color.app_color));
                } else if (workDetail.getContractor_type() == 2) { //分包
                    viewHolder.workType.setText("包工(分包)");
                    viewHolder.workMoney.setTextColor(ContextCompat.getColor(context, R.color.app_color));
                }
                break;
            case AccountUtil.BORROWING: //借支
                viewHolder.workType.setText("借支");
                viewHolder.workMoney.setTextColor(ContextCompat.getColor(context.getApplicationContext(), R.color.green));
                break;
            case AccountUtil.SALARY_BALANCE: //结算
                viewHolder.workType.setText("结算");
                viewHolder.workMoney.setTextColor(ContextCompat.getColor(context.getApplicationContext(), R.color.green));
                break;
        }
        viewHolder.workMoney.setText(workDetail.getAmounts()); //设置薪资
        viewHolder.recordTypeIcon.setVisibility(View.INVISIBLE);
    }

    class ViewHolder {

        /**
         * 记账日期
         */
        TextView date;
        /**
         * 记账日期布局
         */
        View dateLayout;
        /**
         * 项目名称
         */
        TextView proName;
        /**
         * 查看按钮
         */
        Button search;
        /**
         * 确认按钮
         */
        Button confirm;
        /**
         * 记账人员名称
         */
        TextView recordWorkName;
        /**
         * 班组长名称
         */
        TextView foremanName;
        /**
         * 上班工时
         */
        TextView normalWork;
        /**
         * 加班工时
         */
        TextView overTimeWork;
        /**
         * 工资标准 上班时长
         */
        TextView salaryNormalWork;
        /**
         * 工资标准 加班时长
         */
        TextView salaryOverTimeWork;
        /**
         * 记账类型
         */
        TextView workType;
        /**
         * 记账金额
         */
        TextView workMoney;
        /**
         * 记账类型图标
         * 包工、点工
         */
        ImageView recordTypeIcon;
        /**
         * 备注图标
         */
        ImageView notesIcon;
        /**
         * 记账类型 1新增 2修改；3删除
         */
        TextView recordType;
        /**
         * 分割线
         */
        View itemDiver;
        /**
         * 滑动到底部 没有数据时展示的页面
         */
        View scrollBottomLayout;

        /**
         * 确定和查看按钮所在的布局
         */
        View confirmSearchLayout;

        public ViewHolder(View convertView, int childType) {
            dateLayout = convertView.findViewById(R.id.date_layout);
            itemDiver = convertView.findViewById(R.id.itemDiver);
            date = (TextView) convertView.findViewById(R.id.date);
            proName = (TextView) convertView.findViewById(R.id.proName);
            search = (Button) convertView.findViewById(R.id.search);
            confirm = (Button) convertView.findViewById(R.id.confirm);
            recordWorkName = (TextView) convertView.findViewById(R.id.recordWorkName);
            foremanName = (TextView) convertView.findViewById(R.id.foremanName);
            recordTypeIcon = (ImageView) convertView.findViewById(R.id.recordTypeIcon);
            notesIcon = (ImageView) convertView.findViewById(R.id.notesIcon);
            recordType = (TextView) convertView.findViewById(R.id.recordType);
            scrollBottomLayout = convertView.findViewById(R.id.scroll_bottom_layout);
            confirmSearchLayout = convertView.findViewById(R.id.confirm_search_layout);
            if (childType == NORMAL_OTHER_ACCOUNT || childType == DELETE_ACCOUNT) {
                workType = (TextView) convertView.findViewById(R.id.workType);
                workMoney = (TextView) convertView.findViewById(R.id.workMoney);
            } else if (childType == NORMAL_HOUR_ACCOUNT) { //只有点工并且未删除记账记录时才会加载点工列表item
                normalWork = (TextView) convertView.findViewById(R.id.normalWork);
                overTimeWork = (TextView) convertView.findViewById(R.id.overTimeWork);
                salaryNormalWork = (TextView) convertView.findViewById(R.id.salaryNormalWork);
                salaryOverTimeWork = (TextView) convertView.findViewById(R.id.salaryOverTimeWork);
            }
        }
    }


    public interface RecordWorkConfirmCallBackListener {
        /**
         * 查看按钮的回调
         *
         * @param accountType 记账类型
         * @param accountId   记账id
         * @param position    当前点击的下标
         * @param itemView    当前点击对应下标的view
         * @param searchView  查看按钮对应下表的view
         */
        public void search(final String accountType, final String accountId, final int position, final View itemView, final View searchView);

        /**
         * 确认按钮的回调
         *
         * @param accountId  记账的id
         * @param position   当前点击的下标
         * @param itemView   当前点击对应下标的view 主要是做动画偏移
         * @param confirmBtn 确认按钮
         */
        public void confirm(String accountId, int position, View itemView, View confirmBtn);
    }

    public ArrayList<RecordWorkConfirmMonth> getList() {
        return list;
    }

    public void setList(ArrayList<RecordWorkConfirmMonth> list) {
        this.list = list;
    }

    public void updateList(ArrayList<RecordWorkConfirmMonth> list) {
        this.list = list;
        notifyDataSetChanged();
    }

    public void addMoreList(ArrayList<RecordWorkConfirmMonth> list) {
        this.list.addAll(list);
        notifyDataSetChanged();
    }


    public void setNoDate(boolean noDate) {
        this.noDate = noDate;
    }


    public void setPageNumber(int pageNumber) {
        this.pageNumber = pageNumber;
    }
}
