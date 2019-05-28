package com.jizhi.jlongg.main.message;

import android.Manifest;
import android.app.Activity;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.location.LocationManager;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.provider.Settings;
import android.support.annotation.NonNull;
import android.support.v4.content.ContextCompat;
import android.text.Html;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.View;
import android.widget.AbsListView;
import android.widget.ListView;
import android.widget.RadioButton;
import android.widget.TextView;

import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.activity.DownLoadExcelActivity;
import com.jizhi.jlongg.main.adpter.SignListAdapter;
import com.jizhi.jlongg.main.bean.GroupDiscussionInfo;
import com.jizhi.jlongg.main.bean.Repository;
import com.jizhi.jlongg.main.bean.SignBean;
import com.jizhi.jlongg.main.bean.SignListBean;
import com.jizhi.jlongg.main.bean.SignMyInfoBean;
import com.jizhi.jlongg.main.bean.UserInfo;
import com.jizhi.jlongg.main.dialog.DialogLeftRightBtnConfirm;
import com.jizhi.jlongg.main.dialog.WheelViewSelectYearAndMonth;
import com.jizhi.jlongg.main.listener.YearAndMonthClickListener;
import com.jizhi.jlongg.main.util.BackGroundUtil;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.HelpCenterUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.WebSocketConstance;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.jizhi.jongg.widget.RoundeImageHashCodeTextLayout;
import com.liaoinstan.springview.container.DefaultFooter;
import com.liaoinstan.springview.container.DefaultHeader;
import com.liaoinstan.springview.widget.SpringView;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;


/**
 * CName:签到列表页面
 * User: hcs
 * Date: 2018-08-18
 * Time: 11:34
 */

public class SignListActivity extends BaseActivity implements View.OnClickListener, AbsListView.OnScrollListener {
    private static final int PERMISSION = 0x11;
    private SignListActivity mActivity;
    private GroupDiscussionInfo gnInfo;
    private SpringView springView;
    private View layout_default;
    private ListView listView;
    private int pg = 0;
    private boolean isFulsh;
    /* 是否还有更多的数据 */
    private View headerView;
    private SignListAdapter signListAdapter;
    private List<SignListBean> signListBean;
    private UserInfo myInfo;
    //当前年月
    private int year, month;

    //rea_sign
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_sign_list);
        getIntentData();
        initView();
    }

    /**
     * 获取传递过来的数据
     */
    public void getIntentData() {
        gnInfo = (GroupDiscussionInfo) getIntent().getSerializableExtra(Constance.BEAN_CONSTANCE);
        findViewById(R.id.lin_send).setVisibility(gnInfo.getIs_closed() == 1 ? View.GONE : View.VISIBLE);
        findViewById(R.id.img_close).setVisibility(gnInfo.getIs_closed() == 1 ? View.VISIBLE : View.GONE);
        Utils.setBackGround(findViewById(R.id.img_close), gnInfo.getClass_type().equals(WebSocketConstance.TEAM) ? getResources().getDrawable(R.drawable.team_closed_icon) : getResources().getDrawable(R.drawable.group_closed_icon));
    }

    /**
     * 启动当前Activity
     *
     * @param context
     */
    public static void actionStart(Activity context, GroupDiscussionInfo info) {
        Intent intent = new Intent(context, SignListActivity.class);
        intent.putExtra(Constance.BEAN_CONSTANCE, info);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    /**
     * 初始化View
     */
    public void initView() {
        mActivity = SignListActivity.this;
        setTextTitle(R.string.sign_in);
        headerView = getLayoutInflater().inflate(R.layout.layout_sign_list_head, null);
        ((TextView) findViewById(R.id.tv_top)).setText("暂无记录哦~");
        ((TextView) findViewById(R.id.right_title)).setText("下载签到表");
        findViewById(R.id.right_title).setVisibility(gnInfo.getCan_at_all() == 1 && gnInfo.is_closed == 0 ? View.VISIBLE : View.GONE);
        year = Calendar.getInstance().get(Calendar.YEAR);
        month = Calendar.getInstance().get(Calendar.MONTH) + 1;
        layout_default = findViewById(R.id.layout_default);
        listView = findViewById(R.id.listView);
        listView.setOnScrollListener(this);
        findViewById(R.id.lin_send).setOnClickListener(this);
        findViewById(R.id.title).setOnClickListener(this);
        findViewById(R.id.img_top).setOnClickListener(this);
        findViewById(R.id.right_title).setOnClickListener(this);
        springView = findViewById(R.id.springview);
        springView.setType(SpringView.Type.FOLLOW);
        springView.setHeader(new DefaultHeader(this));
        springView.setFooter(new DefaultFooter(this));
        springView.callFreshDelay();
        springView.setListener(new SpringView.OnFreshListener() {
            @Override
            public void onRefresh() {
                isFulsh = true;
                pg = 1;
                getSignList();
            }

            @Override
            public void onLoadmore() {
                isFulsh = false;
                pg += 1;
                getSignList();
            }
        });
        headerView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                myInfo.setReal_name("我");
                UserSignListActivity.actionStart(mActivity, gnInfo, myInfo);
            }
        });
    }

    /**
     * 签到列表
     */
    public void getSignList() {
        final RequestParams params = RequestParamsToken.getExpandRequestParams(mActivity);
        params.addBodyParameter("group_id", gnInfo.getGroup_id());
        params.addBodyParameter("class_type", gnInfo.getClass_type());
        params.addBodyParameter("pg", String.valueOf(pg));
        params.addBodyParameter("pagesize", "10");
        CommonHttpRequest.commonRequest(this, NetWorkRequest.SIGN_LIST, SignBean.class, CommonHttpRequest.OBJECT, params, false, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                try {
                    SignBean signBean = (SignBean) object;
                    if (pg == 1) {
                        setHeadData(signBean.getMyself());
                    }
                    setVaues(signBean.getList());
                } catch (Exception e) {
                    pg -= 1;
                    e.printStackTrace();
                    CommonMethod.makeNoticeShort(mActivity, mActivity.getString(R.string.service_err), CommonMethod.ERROR);
                } finally {
                    springView.onFinishFreshAndLoad();
                }
            }

            @Override
            public void onFailure(HttpException error, String msg) {
                pg -= 1;
                printNetLog(msg, mActivity);
                springView.onFinishFreshAndLoad();
            }
        });
    }

    /**
     * 签到顶部
     */
    public void setHeadData(SignMyInfoBean signMyInfoBean) {
        myInfo = signMyInfoBean.getUser_info();
        //头像
        ((RoundeImageHashCodeTextLayout) headerView.findViewById(R.id.img_head)).setView(signMyInfoBean.getUser_info().getHead_pic(), TextUtils.isEmpty(signMyInfoBean.getUser_info().getReal_name()) ? "我" : signMyInfoBean.getUser_info().getReal_name(), 0);
        if (signMyInfoBean.getToday_sign_record_num() == 0) {
            //进入未签到
            headerView.findViewById(R.id.tv_adres).setVisibility(View.GONE);
            headerView.findViewById(R.id.rb_my_time).setVisibility(View.GONE);
            headerView.findViewById(R.id.icon_nosign).setVisibility(View.VISIBLE);
        } else {
            headerView.findViewById(R.id.tv_adres).setVisibility(View.VISIBLE);
            headerView.findViewById(R.id.rb_my_time).setVisibility(View.VISIBLE);
            headerView.findViewById(R.id.icon_nosign).setVisibility(View.GONE);
            ((TextView) headerView.findViewById(R.id.tv_adres)).setText(signMyInfoBean.getSign_addr());
            ((TextView) headerView.findViewById(R.id.tv_sign_my)).setText(Html.fromHtml("今日签到<font color=\"#83c76e\"><b>" + signMyInfoBean.getToday_sign_record_num() + "</b></font>次"));
            ((RadioButton) headerView.findViewById(R.id.rb_my_time)).setText(signMyInfoBean.getSign_time());
        }
    }

    public void setVaues(List<SignListBean> list) {
        if (null == signListBean) {
            signListBean = new ArrayList<>();
        }
        if (isFulsh) {
            signListBean = list;
            signListAdapter = new SignListAdapter(mActivity, signListBean, gnInfo);
            if (listView.getHeaderViewsCount() == 0) {
                listView.addHeaderView(headerView);
            }
            listView.setAdapter(signListAdapter);
            listView.setSelection(0);
        } else {
            int seletionPositon = list.size() > 0 ? (list.size() + 1) : list.size();
            signListBean.addAll(list);
            signListAdapter.notifyDataSetChanged();
            listView.setSelection(seletionPositon);
            if (list.size() == 0) {
                pg -= 1;
            }
        }
        LUtils.e(listView.getHeaderViewsCount() + "----------------" + signListBean.size());
        if (listView.getHeaderViewsCount() == 1 && signListBean.size() == 0) {
            layout_default.setVisibility(View.VISIBLE);
        } else {
            layout_default.setVisibility(View.GONE);
        }
    }

    private WheelViewSelectYearAndMonth selecteYearMonthPopWindow;

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if (requestCode == PERMISSION) {
            if (grantResults[0] == PackageManager.PERMISSION_GRANTED &&
                    grantResults[1] == PackageManager.PERMISSION_GRANTED) {
                SigninActivity.actionStart(mActivity, gnInfo.getGroup_id(), gnInfo.getClass_type());
            }
        }
    }

    DialogLeftRightBtnConfirm dialog;

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.lin_send:
                LocationManager lm = (LocationManager) getSystemService(LOCATION_SERVICE);
                boolean noLocationPermission = ContextCompat.checkSelfPermission(this,
                        Manifest.permission.ACCESS_COARSE_LOCATION) != PackageManager.PERMISSION_GRANTED ||
                        ContextCompat.checkSelfPermission(this,
                                Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED;
                boolean ok = false;https://github.com/tbruyelle/RxPermissions.git
                if (lm != null) {
                    ok = lm.isProviderEnabled(LocationManager.GPS_PROVIDER);
                }
                if (!ok && noLocationPermission) {
                    noGpsService();
                } else if (!ok) {
                    noGpsService();
                } else if (noLocationPermission) {
                    noLocationPermission();
                } else {
                    SigninActivity.actionStart(mActivity, gnInfo.getGroup_id(), gnInfo.getClass_type());
                }

                break;
            case R.id.title:
                HelpCenterUtil.actionStartHelpActivity(mActivity, 185);
                break;
            case R.id.img_top:
                listView.setSelection(0);
                break;
            case R.id.right_title:
                //3.4.1增加创建者下载签到
                if (selecteYearMonthPopWindow == null) {
                    selecteYearMonthPopWindow = new WheelViewSelectYearAndMonth(mActivity, new YearAndMonthClickListener() {
                        @Override
                        public void YearAndMonthClick(String years, String months) {
                            year = Integer.parseInt(years);
                            month = Integer.parseInt(months);
                            getDownUrl();
                        }
                    }, year, month);
                } else {
                    selecteYearMonthPopWindow.update();
                }
                selecteYearMonthPopWindow.showAtLocation(getWindow().getDecorView(), Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0); //设置layout在PopupWindow中显示的位置
                BackGroundUtil.backgroundAlpha(this, 0.5F);
                break;
        }
    }

    private void noLocationPermission() {
        dialog = new DialogLeftRightBtnConfirm(this,
                "定位服务已关闭", "签到需要获取你的位置信息，打开手机定位可完成签到。请到设置＞应用管理＞吉工家＞权限管理中开启。", new DialogLeftRightBtnConfirm.LeftRightBtnListener() {
            @Override
            public void clickLeftBtnCallBack() {
                dialog.dismiss();
            }

            @Override
            public void clickRightBtnCallBack() {
                Intent mIntent = new Intent();
                mIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                if (Build.VERSION.SDK_INT >= 9) {
                    mIntent.setAction("android.settings.APPLICATION_DETAILS_SETTINGS");
                    mIntent.setData(Uri.fromParts("package", getPackageName(), null));
                } else if (Build.VERSION.SDK_INT <= 8) {
                    mIntent.setAction(Intent.ACTION_VIEW);
                    mIntent.setClassName("com.android.settings", "com.android.setting.InstalledAppDetails");
                    mIntent.putExtra("com.android.settings.ApplicationPkgName", getPackageName());
                }
                startActivity(mIntent);


            }
        });
        dialog.setRightBtnText("前往开启");
        dialog.setLeftBtnText("以后设置");
        dialog.show();
    }

    private void noGpsService() {
        dialog = new DialogLeftRightBtnConfirm(this,
                "位置信息已关闭", "签到需要获取你的位置信息，打开手机定位信息（GPS）才可完成签到。", new DialogLeftRightBtnConfirm.LeftRightBtnListener() {
            @Override
            public void clickLeftBtnCallBack() {
                dialog.dismiss();
            }

            @Override
            public void clickRightBtnCallBack() {
                try {
                    Intent intent = new Intent(Settings.ACTION_LOCATION_SOURCE_SETTINGS);
                    startActivityForResult(intent, 0);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        });
        dialog.setRightBtnText("前往开启");
        dialog.setLeftBtnText("以后设置");
        dialog.show();
    }


    /**
     * 获取下载地址
     */
    public void getDownUrl() {
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        params.addBodyParameter("export_time", year + "-" + month);
        params.addBodyParameter("group_id", gnInfo.getGroup_id());
        params.addBodyParameter("class_type", gnInfo.getClass_type());
        CommonHttpRequest.commonRequest(this, NetWorkRequest.SIGN_EXPORT, Repository.class, CommonHttpRequest.OBJECT, params, true, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                try {
                    Repository repository = (Repository) object;
                    //文件名称、文件下载路径、文件类型都不能为空
                    if (!TextUtils.isEmpty(repository.getFile_name()) && !TextUtils.isEmpty(repository.getFile_type()) && !TextUtils.isEmpty(repository.getFile_path())) {
//                        AccountUtils.downLoadAccount(mActivity, NetWorkRequest.IP_ADDRESS + repository.getFile_path(), repository.getFile_name());
                        DownLoadExcelActivity.actionStart(mActivity, NetWorkRequest.IP_ADDRESS + repository.getFile_path(), repository.getFile_name());
                    } else {
                        CommonMethod.makeNoticeLong(mActivity, "你选择的月份没有签到数据可下载", CommonMethod.ERROR);
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    CommonMethod.makeNoticeShort(mActivity, mActivity.getString(R.string.service_err), CommonMethod.ERROR);
                }
            }

            @Override
            public void onFailure(HttpException error, String msg) {
                printNetLog(msg, mActivity);
            }
        });
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == Constance.REQUESTCODE_START && resultCode == Constance.RESULTCODE_FINISH) {
            springView.callFreshDelay();
        }
    }

    @Override
    public void onScrollStateChanged(AbsListView view, int scrollState) {

    }

    @Override
    public void onScroll(AbsListView view, int firstVisibleItem, int visibleItemCount, int totalItemCount) {
        if (firstVisibleItem >= 2) {
            if (findViewById(R.id.img_top).getVisibility() != View.VISIBLE)
                findViewById(R.id.img_top).setVisibility(View.VISIBLE);
        } else {
            if (findViewById(R.id.img_top).getVisibility() != View.GONE)
                findViewById(R.id.img_top).setVisibility(View.GONE);
        }
    }

}
