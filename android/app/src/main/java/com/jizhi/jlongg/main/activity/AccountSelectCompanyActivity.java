package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.text.InputFilter;
import android.text.InputType;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.View;
import android.view.WindowManager;
import android.widget.EditText;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.hcs.cityslist.widget.ClearEditText;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.WorkTime;
import com.jizhi.jlongg.main.dialog.WheelGridViewWorkTime;
import com.jizhi.jlongg.main.util.BackGroundUtil;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DataUtil;

import java.util.List;

/**
 * 功能:点工选择数量单位
 * 作者：hcs
 * 时间: 2017-3-29 15:37
 */
public class AccountSelectCompanyActivity extends BaseActivity {
    private AccountSelectCompanyActivity mActivity;
    /*编辑框*/
    private ClearEditText ed_number;
    /*选择单位布局*/
    private RelativeLayout rea_company;
    /*显示单位文本*/
    private TextView tv_company;
    /* 单位WheelView */
    public WheelGridViewWorkTime selectCompanyDialog;
    /* 单位列表数据 */
    private List<WorkTime> companyList;
    //    /* 单位下标 */
//    private int selectNumber;
    /* 单位名称 */
    private String company;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_account_select_company);
        initView();
        showSoftInputFromWindow(mActivity, ed_number);
    }

    public static void actionStart(Activity activity, String context, String company) {
        Intent intent = new Intent(activity, AccountSelectCompanyActivity.class);
        intent.putExtra(Constance.CONTEXT, context);
        intent.putExtra(Constance.COMPANY, company);
        activity.startActivityForResult(intent, Constance.REQUESTCODE_ALLWORKCOMPANT);
    }

    /**
     * EditText获取焦点并显示软键盘
     */
    public void showSoftInputFromWindow(Activity activity, EditText editText) {
        editText.setFocusable(true);
        editText.setFocusableInTouchMode(true);
        editText.requestFocus();
        activity.getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_ALWAYS_VISIBLE);
    }

    /**
     * 初始化view
     */
    private void initView() {
        setTextTitle(R.string.select_company);
        mActivity = AccountSelectCompanyActivity.this;
        ed_number = (ClearEditText) findViewById(R.id.ed_number);
        rea_company = (RelativeLayout) findViewById(R.id.rea_company);
        tv_company = (TextView) findViewById(R.id.tv_company);
        String values = getIntent().getStringExtra(Constance.CONTEXT);
        company = getIntent().getStringExtra(Constance.COMPANY);
        if (TextUtils.isEmpty(company)) {
            company = "平方米";
        }
        if (!TextUtils.isEmpty(values)) {
            ed_number.setText(values);
        }
        tv_company.setText(company);

        ed_number.setInputType(InputType.TYPE_CLASS_NUMBER | InputType.TYPE_NUMBER_FLAG_DECIMAL);
        ed_number.setFilters(new InputFilter[]{new InputFilter.LengthFilter(6)});
        setEditTextDecimalNumberLength(ed_number, 6, 2);
        //单位点击事件
        findViewById(R.id.rea_company).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                hideSoftKeyboard();
                //选择单位
                if (selectCompanyDialog == null) {
                    companyList = DataUtil.getAccountCompanyList(mActivity, company);
                    selectCompanyDialog = new WheelGridViewWorkTime(mActivity, companyList, "选择单位", 0);
                    selectCompanyDialog.setListener(new WheelGridViewWorkTime.WorkTimeListener() {
                        @Override
                        public void workTimeClick(String scrollContent, int postion, String workUtil) {
//                            selectNumber = companyList.get(postion).getWorkId();
                            company = companyList.get(postion).getWorkName();
                            tv_company.setText(company);
                        }
                    });
                }
                //显示窗口
                selectCompanyDialog.showAtLocation(mActivity.findViewById(R.id.main_layout), Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0); //设置layout在PopupWindow中显示的位置
                BackGroundUtil.backgroundAlpha(mActivity, 0.5F);
            }
        });
    }

    @Override
    public void onFinish(View view) {
        finishAct();
    }

    @Override
    public void onBackPressed() {
        finishAct();
    }

    public void finishAct() {
        Intent intent = new Intent();
        intent.putExtra(Constance.CONTEXT, ed_number.getText().toString().toString());
        intent.putExtra(Constance.COMPANY, company);
        setResult(Constance.RESULTCODE_ALLWORKCOMPANT, intent);
        mActivity.finish();

    }
}
