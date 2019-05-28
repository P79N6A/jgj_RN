//package com.jizhi.jlongg.main.util;
//
//import android.Manifest;
//import android.annotation.SuppressLint;
//import android.annotation.TargetApi;
//import android.app.Activity;
//import android.os.Build;
//import android.view.Gravity;
//import android.webkit.JavascriptInterface;
//import android.webkit.WebView;
//
//import com.google.gson.Gson;
//import com.hcs.uclient.utils.LUtils;
//import com.jizhi.jlongg.R;
//import com.jizhi.jlongg.db.BaseInfoDB;
//import com.jizhi.jlongg.db.BaseInfoService;
//import com.jizhi.jlongg.main.activity.BaseActivity;
//import com.jizhi.jlongg.main.bean.BaseNetBean;
//import com.jizhi.jlongg.main.bean.Share;
//import com.jizhi.jlongg.main.bean.WorkType;
//import com.jizhi.jlongg.main.dialog.CustomShareDialog;
//import com.jizhi.jlongg.main.dialog.ProjectTypeDialog;
//import com.jizhi.jlongg.main.dialog.WheelSingleSelected;
//import com.jizhi.jlongg.main.dialog.WheelViewSelectProvinceCityArea;
//import com.jizhi.jlongg.main.listener.CallBackSingleWheelListener;
//import com.jizhi.jlongg.main.listener.SelectProvinceCityAreaListener;
//import com.jizhi.jlongg.network.NetWorkRequest;
//import com.jizhi.jlongg.utis.acp.Acp;
//import com.jizhi.jlongg.utis.acp.AcpListener;
//import com.jizhi.jlongg.utis.acp.AcpOptions;
//import com.lidroid.xutils.HttpUtils;
//import com.lidroid.xutils.http.RequestParams;
//import com.lidroid.xutils.http.ResponseInfo;
//import com.lidroid.xutils.http.client.HttpRequest;
//
//import java.util.ArrayList;
//import java.util.List;
//
//
//public class MyFragmentJSObject implements SelectProvinceCityAreaListener {
//
//
//    /* 上下文 */
//    private BaseActivity context;
//    /* webView */
//    private WebView webView;
//    /* 项目类型 熟练度 */
//    private List<WorkType> workTypeLists, workStateLists;
//    /* 项目类型,工种,熟练度当前选择下标 */
//    private int workstatePos;
//    private BaseInfoService baseInfoService;
//    private ReaTitleListener ReaTitleListener;
//
//    /* 期望工作地弹出框 */
//    private WheelViewSelectProvinceCityArea expectedWorkPopWindow;
//    /* 家乡弹出框 */
//    private WheelViewSelectProvinceCityArea homePopWindow;
//    /* 工种弹出框 */
//    private ProjectTypeDialog diaglog2;
//
//    public MyFragmentJSObject(BaseActivity context, WebView webView, BaseInfoService baseInfoService) {
//        this.context = context;
//        this.webView = webView;
//        this.baseInfoService = baseInfoService;
//        initData();
//    }
//
//    public MyFragmentJSObject(BaseActivity context, WebView webView, BaseInfoService baseInfoService, ReaTitleListener ReaTitleListener) {
//        this.context = context;
//        this.webView = webView;
//        this.baseInfoService = baseInfoService;
//        this.ReaTitleListener = ReaTitleListener;
//        initData();
//    }
//
//
//    /**
//     * 初始化数据
//     */
//    public void initData() {
//        if (null == BaseInfoService.getInstance(context)) {
//            baseInfoService = BaseInfoService.getInstance(context.getApplicationContext());
//        }
////        // 在本地数据库读取 项目类型,工作类型,熟练度
//        workTypeLists = baseInfoService.selectInfo(BaseInfoDB.jlg_work_type);
//        workStateLists = baseInfoService.selectInfo(BaseInfoDB.jlg_work_status);
//    }
//
//    /**
//     * 初始化数据
//     */
//    public void clearState() {
//        if (null != workTypeLists) {
//            for (int i = 0; i < workTypeLists.size(); i++) {
//                workTypeLists.get(i).setIsSelected(false);
//            }
//        }
//    }
//
//    @JavascriptInterface
//    public void userInfoShowTitle() {
//        if (null != ReaTitleListener) {
//            ReaTitleListener.reaTitle();
//        }
//    }
//
//    // 分享
//    @JavascriptInterface
//    public void fork(String img, String desc, String title, String url) {
//        LUtils.e("fork...desc:" + desc);
//        LUtils.e("fork...title:" + title);
//        LUtils.e("fork...url:" + url);
//        final Share shareBean = new Share();
//        // 图标 描述 标题 url
//        shareBean.setImgUrl(img);
//        shareBean.setDescribe(desc);
//        shareBean.setTitle(title);
//        shareBean.setUrl(url);
//        context.runOnUiThread(new Runnable() {
//            public void run() {
//                CustomShareDialog shareDialog = new CustomShareDialog(context, true, shareBean);
//                //显示窗口
//                shareDialog.showAtLocation(context.getWindow().getDecorView(), Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0); //设置layout在PopupWindow中显示的位置
//                BackGroundUtil.backgroundAlpha(context, 0.5F);
//            }
//        });
//    }
//
//    // 分享
//    @JavascriptInterface
//    public void shareArticle(String firstImg, String desc, String title, String url) {
//        LUtils.e("shareArticle...desc:" + desc);
//        LUtils.e("shareArticle...title:" + title);
//        LUtils.e("shareArticle...url:" + url);
//        final Share shareBean = new Share();
//        // 图标 描述 标题 url
//        shareBean.setImgUrl(firstImg);
//        shareBean.setDescribe(desc);
//        shareBean.setTitle(title);
//        shareBean.setUrl(url);
//        context.runOnUiThread(new Runnable() {
//            public void run() {
//                CustomShareDialog shareDialog = new CustomShareDialog(context, true, shareBean);
//                //显示窗口
//                shareDialog.showAtLocation(context.getWindow().getDecorView(), Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0); //设置layout在PopupWindow中显示的位置
//                BackGroundUtil.backgroundAlpha(context, 0.5F);
//            }
//        });
//    }
//
//    // 修改工作状态
//    @JavascriptInterface
//    public void showWorkState() {
//        WheelSingleSelected popWindow = new WheelSingleSelected(context, context.getString(R.string.workstate_hint), workStateLists);
//        popWindow.setListener(new CallBackSingleWheelListener() {
//            @Override
//            public void onSelected(String scrollContent, int postion) {
//                workstatePos = postion;
//                String workId = String.valueOf(workStateLists.get(postion).getWorktype());
//                String workName = String.valueOf(workStateLists.get(postion).getWorkName());
//                //TODO 修改工作状态
//                changeWorkStatus(workId, workName, webView);
//            }
//        });
//        //显示窗口
//        popWindow.showAtLocation(context.findViewById(R.id.main), Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0); //设置layout在PopupWindow中显示的位置
//        context.runOnUiThread(new Runnable() {
//            public void run() {
//                BackGroundUtil.backgroundAlpha(context, 0.5F);
//            }
//        });
//    }
//
//
//    // 更换头像
//    @JavascriptInterface
//    public void changeHeadPicture() {
//        Acp.getInstance(context).request(new AcpOptions.Builder().setPermissions(Manifest.permission.READ_EXTERNAL_STORAGE, Manifest.permission.CAMERA)
//                        .build(),
//                new AcpListener() {
//                    @Override
//                    public void onGranted() {
//                        CameraPop.singleSelector(context, null);
//                    }
//
//                    @Override
//                    public void onDenied(List<String> permissions) {
//                        //已经禁止提示了
//                        CommonMethod.makeNoticeShort(context, context.getResources().getString(R.string.permission_close), CommonMethod.ERROR);
//                    }
//                });
//
//    }
//
//
//    @JavascriptInterface
//    public void backToHomePage() {
//        context.finish();
//    }
//
//    // 期望工作地
//    @TargetApi(Build.VERSION_CODES.HONEYCOMB)
//    @SuppressLint("NewApi")
//    @JavascriptInterface
//    public void changeExpectArea() {
//        if (expectedWorkPopWindow == null) {
//            expectedWorkPopWindow = new WheelViewSelectProvinceCityArea(context, this, context.getString(R.string.expecttowork1), Constance.EXPECTEDWORK);
//        } else {
//            expectedWorkPopWindow.update();
//        }
//        //显示窗口
//        expectedWorkPopWindow.showAtLocation(context.findViewById(R.id.main), Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0); //设置layout在PopupWindow中显示的位置
//        context.runOnUiThread(new Runnable() {
//            public void run() {
//                BackGroundUtil.backgroundAlpha(context, 0.5F);
//            }
//        });
//
//    }
//
//    // 家乡
//    @JavascriptInterface
//    public void changeHometown() {
//        if (homePopWindow == null) {
//            homePopWindow = new WheelViewSelectProvinceCityArea(context, this, context.getString(R.string.home_null), Constance.HOME);
//        } else {
//            homePopWindow.update();
//        }
//        //显示窗口
//        homePopWindow.showAtLocation(context.findViewById(R.id.main), Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL, 0, 0); //设置layout在PopupWindow中显示的位置
//        context.runOnUiThread(new Runnable() {
//            public void run() {
//                BackGroundUtil.backgroundAlpha(context, 0.5F);
//            }
//        });
//    }
//
//
//    // 工作类型
//    @JavascriptInterface
//    public void changeJobType(boolean multi, String str) {
//        clearState();
//        String[] st = str.split(",");
//        for (int j = 0; j < st.length; j++) {
//            for (int i = 0; i < workTypeLists.size(); i++) {
//                if (st[j].equals(workTypeLists.get(i).getWorktype())) {
//                    workTypeLists.get(i).setIsSelected(true);
//                }
//            }
//        }
//        diaglog2 = new ProjectTypeDialog(context, confirmClickListener, workTypeLists, cancelClickListener, Constance.RIGISTR_ORIGIN_WORKERTYPE);
//        diaglog2.setCanceledOnTouchOutside(true);
//        diaglog2.setCancelable(true);
//        diaglog2.show();
//    }
//
////    @Override
////    public void selectedResultClick(CityInfoMode province, final CityInfoMode city, final CityInfoMode areas) {
////        final StringBuffer buffer = new StringBuffer();
////        if (null != province) {
////            buffer.append(province.getCity_name());
////        }
////        if (null != city) {
////            buffer.append(" " + city.getCity_name());
////        }
////        if (null != areas) {
////            buffer.append(" " + areas.getCity_name());
////        }
////        ((Activity) context).runOnUiThread(new Runnable() {
////            @Override
////            public void run() {
////                String aresCode = "";
////                if (null != city) {
////                    aresCode = city.getCity_code();
////                }
////                if (null != areas) {
////                    aresCode = areas.getCity_code();
////                }
////                // 家乡
////                if (!buffer.toString().equals("")) {
////                    webView.loadUrl("javascript:getHometown('" + buffer.toString() + "','" + aresCode + "')");
////                }
////            }
////        });
////    }
//
////    @Override
////    public void selectedCityNoAresClick(final CityInfoMode province, final CityInfoMode city) {
////        final StringBuffer buffer = new StringBuffer();
////        if (null != province) {
////            buffer.append(province.getCity_name());
////        }
////        if (null != city) {
////            buffer.append(" " + city.getCity_name());
////        }
////        ((Activity) context).runOnUiThread(new Runnable() {
////            @Override
////            public void run() {
////                // 期望工作地
////                if (!buffer.toString().equals("")) {
////                    webView.loadUrl("javascript:getExpectArea('" + buffer.toString() + "','" + city.getCity_code() + "')");
////                }
////            }
////        });
////    }
//
//    /**
//     * 工种，项目类型点击事件结束
//     */
//    private ProjectTypeDialog.ConfirmClickListener confirmClickListener = new ProjectTypeDialog.ConfirmClickListener() {
//        @Override
//        public void getText() {
//
//            final StringBuffer buffer = new StringBuffer();
//            final StringBuffer bufferID = new StringBuffer();
//            // 获取工种数据
//            for (int i = 0; i < workTypeLists.size(); i++) {
//                if (workTypeLists.get(i).isSelected()) {
//                    String name = workTypeLists.get(i).getWorkName();
//                    bufferID.append(workTypeLists.get(i).getWorktype() + ",");
//                    buffer.append(name + ",");
//                }
//            }
//            final int nameLength = buffer.toString().length();
//            ((Activity) context).runOnUiThread(new Runnable() {
//                @Override
//                public void run() {
//                    if (nameLength > 2) {
//                        String name = buffer.substring(0,
//                                buffer.length() - 1);
//                        String workTypeId = bufferID.substring(0,
//                                bufferID.length() - 1);
//                        webView.loadUrl("javascript:getJobType('" + name
//                                + "','" + workTypeId + "')");
//
//                    } else {
//                        webView.loadUrl("javascript:getJobType('" + ""
//                                + "','" + "" + "')");
//                    }
//                }
//            });
//
////
////            }
//        }
//    };
//    private ProjectTypeDialog.CancelClickListener cancelClickListener = new ProjectTypeDialog.CancelClickListener() {
//        @Override
//        public void dismiss() {
//            initWorkTypeData();
//        }
//    };
//
//
//    /**
//     * 初始化工作类型
//     */
//    private void initWorkTypeData() {
//        if (null == BaseInfoService.getInstance(context)) {
//            baseInfoService = BaseInfoService.getInstance(context.getApplicationContext());
//        }
//        workTypeLists = new ArrayList<WorkType>();
//        workTypeLists = baseInfoService.selectInfo(BaseInfoDB.jlg_work_type);
//
//    }
//
//
//    @Override
//    public void selectedCityResult(String type, final String cityCode, final String cityName) {
//        switch (type) {
//            case Constance.HOME: //家乡
//                context.runOnUiThread(new Runnable() {
//                    public void run() {
//                        webView.loadUrl("javascript:getHometown('" + cityName + "','" + cityCode + "')");  // 家乡
//                    }
//                });
//                break;
//            case Constance.EXPECTEDWORK: //期望工作地
//                context.runOnUiThread(new Runnable() {
//                    public void run() {
//                        webView.loadUrl("javascript:getExpectArea('" + cityName + "','" + cityCode + "')");// 期望工作地
//                    }
//                });
//                break;
//        }
//    }
//
//    public interface ReaTitleListener {
//        void reaTitle();
//    }
//
//    /**
//     * 更改工作状态
//     *
//     * @param workId
//     * @param webView
//     */
//    public void changeWorkStatus(final String workId, final String workName, final WebView webView) {
//        String url = NetWorkRequest.WORKSTATUS;
//        RequestParams params = RequestParamsToken.getExpandRequestParams(context);
//        params.addBodyParameter("work_status", workId);
//        params.addBodyParameter("op", "m");
//        HttpUtils http = SingsHttpUtils.getHttp();
//        http.send(HttpRequest.HttpMethod.POST, url, params, context.new RequestCallBackExpand<String>() {
//            @Override
//            public void onSuccess(ResponseInfo<String> responseInfo) {
//                try {
//                    Gson gson = new Gson();
//                    BaseNetBean bean = gson.fromJson(responseInfo.result, BaseNetBean.class);
//                    if (bean.getState() == 1) {
//                        webView.loadUrl("javascript:getWorkState('" + workName + "')");
//                    } else {
//                        CommonMethod.makeNoticeLong(context, bean.getErrno() + "", CommonMethod.ERROR);
//                    }
//                } catch (Exception e) {
//                    CommonMethod.makeNoticeShort(context, context.getString(R.string.service_err), CommonMethod.ERROR);
//                } finally {
//                    context.closeDialog();
//                }
//            }
//        });
//    }
//
//}
