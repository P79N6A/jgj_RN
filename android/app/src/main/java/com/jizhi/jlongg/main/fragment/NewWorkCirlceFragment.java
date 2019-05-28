package com.jizhi.jlongg.main.fragment;

import android.content.Intent;
import android.net.ConnectivityManager;
import android.os.Build;
import android.os.Bundle;
import android.support.v4.content.ContextCompat;
import android.support.v4.view.ViewPager;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewTreeObserver;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.hcs.uclient.utils.DensityUtils;
import com.hcs.uclient.utils.ImageUtils;
import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.SPUtils;
import com.hcs.uclient.utils.ScreenUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.activity.notebook.NoteBookListActivity;
import com.jizhi.jlongg.higuide.HiGuide;
import com.jizhi.jlongg.higuide.Overlay;
import com.jizhi.jlongg.main.AppMainActivity;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.activity.NetFailActivity;
import com.jizhi.jlongg.main.activity.NewCalendarDetailActivity;
import com.jizhi.jlongg.main.activity.X5WebViewActivity;
import com.jizhi.jlongg.main.activity.welcome.ChooseRoleActivity;
import com.jizhi.jlongg.main.adpter.NewWorkCircleChatAdapter;
import com.jizhi.jlongg.main.adpter.WorkCircleViewPagerAdapter;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.AccountInfoBean;
import com.jizhi.jlongg.main.bean.Banner;
import com.jizhi.jlongg.main.bean.ChatMainInfo;
import com.jizhi.jlongg.main.popwindow.WorkCirclePopWindow;
import com.jizhi.jlongg.main.strategy.AccountStrategy;
import com.jizhi.jlongg.main.util.CheckListHttpUtils;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DotViewGroup;
import com.jizhi.jlongg.main.util.MessageUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.ThreadPoolUtils;
import com.jizhi.jlongg.main.util.WebSocketConstance;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.jizhi.jongg.widget.CustomListView;
import com.liaoinstan.springview.utils.DensityUtil;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;
import com.nostra13.universalimageloader.core.ImageLoader;

import java.text.SimpleDateFormat;
import java.util.List;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

/**
 * 功能:项目Fragment
 * 作者：xuj
 * 时间: 2017年4月19日10:43:22
 */
public class NewWorkCirlceFragment extends BaseFragment implements View.OnClickListener {

    /**
     * 项目列表适配器
     */
    private NewWorkCircleChatAdapter adapter;
    /**
     * 顶部Banner viewPager
     */
    private ViewPager viewPager;
    /**
     * 顶部滚动图片数据
     */
    private List<Banner> bannerList;
    /**
     * 小圆点
     */
    private DotViewGroup bannerDots;
    /**
     * 头部Banner
     */
    private View bannerHeadView;
    /**
     * ViewPager当前选中的下标
     */
    private int currentPosition;
    /**
     * 网络连接失败布局
     */
    private LinearLayout netFailLayout;
    /**
     * 更多按钮
     */
    private ImageView messageAdd;
    /**
     * 未读工作消息数
     */
    private ImageView changeRolerIcon;
    /**
     * 当前角色名称
     */
    private TextView rolerText;
    /**
     * 导航栏线条 当滑动的时候 隐藏和显示
     */
    private View navigationNoticeLine;
    /**
     * Banner图切换的 定时器
     */
    private ScheduledExecutorService scheduledExecutorService;
    /**
     * 是否滚动到底部，只有当切换项目组的时候才需要切换到底部
     */
    private boolean isScrollBottom;

    private CustomListView listView;
    /**
     * 如果退出、删除、关闭 群聊信息
     * 如果这个变量为true  则每次回到这个页面 都会重新请求服务器
     * 默认为false
     */
    private boolean isRequestServer = false;
    /**
     * 是否已修改了群聊信息
     * 如果在项目或班组设置里面进行了修改数据那么会发送一条广播将这个变量设为true
     * 如果这个变量为true  则每次回到这个页面 都会重新读取本地数据库进行数据的刷新
     * 默认为false
     */
    private boolean isUpdateLocalGroupInfo = false;
    /**
     * 当前Activity是否在前台
     */
    private boolean isFront = false;

    private boolean isLoadingDataBase;

    @Override
    public void onPause() {
        super.onPause();
        isFront = false;
    }

    @Override
    public void onResume() {
        super.onResume();
        isFront = true;
        if (isRequestServer) { //请求服务器数据
            isRequestServer = false;
            isUpdateLocalGroupInfo = false;
            MessageUtil.getWorkCircleData(getActivity());
            return;
        }
        if (isUpdateLocalGroupInfo) {
            isUpdateLocalGroupInfo = false;
            loadLocalDataBaseData(AccountStrategy.LOAD_SUCCESS_STATE);
        }
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View main_view = inflater.inflate(R.layout.work_circle, container, false);
        return main_view;
    }

    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        initView();
        searchBanner();
        loadLocalDataBaseData(AccountStrategy.LOADING_STATE);
        MessageUtil.getWorkCircleData(getActivity()); //获取首页收据
    }


    @Override
    public void initFragmentData() {
        if (!UclientApplication.isLogin(getActivity())) { //未登录
            setAdapter(null, AccountStrategy.LOADING_STATE);
        }
        rolerText.setText(UclientApplication.getRoler(getActivity()).equals(Constance.ROLETYPE_FM) ? "我是班组长" : "我是工人");
    }


    /**
     * 初始化布局
     */
    private void initView() {

        listView = (CustomListView) getView().findViewById(R.id.listView);
        getView().findViewById(R.id.navigationBar).setOnClickListener(this);
        getView().findViewById(R.id.signIcon).setOnClickListener(this);

        navigationNoticeLine = getView().findViewById(R.id.navigationNoticeLine);
        changeRolerIcon = (ImageView) getView().findViewById(R.id.changeRolerIcon);
        rolerText = (TextView) getView().findViewById(R.id.rolerText);
        messageAdd = (ImageView) getView().findViewById(R.id.messageAdd);
        netFailLayout = (LinearLayout) getView().findViewById(R.id.netFailLayout);
        rolerText.setText(UclientApplication.getRoler(getActivity()).equals(Constance.ROLETYPE_FM) ? "我是班组长" : "我是工人");

        View recordAccountView = getActivity().getLayoutInflater().inflate(R.layout.new_work_circle_recorde_account, null); // Banner
        bannerHeadView = getActivity().getLayoutInflater().inflate(R.layout.new_work_circle_head, null); // Banner
        bannerDots = (DotViewGroup) bannerHeadView.findViewById(R.id.dots);
        viewPager = (ViewPager) bannerHeadView.findViewById(R.id.viewpager);
        // 在ListView里，HeaderView和FooterView也占一行，与其他的item一样，可以点击，有索引，HeaderView的索引为0.如果要使这两项不可点击，可以使用下面的方法:
        // 如果在view里已经填充数据，第二个参数可以为空，第三个参数设为false,即不可选择
        // public void addFooterView(View v, Object data, boolean isSelectable)
        // public void addHeaderView(View v, Object data, boolean isSelectable)
        setTitleBtnScale(recordAccountView);

        changeRolerIcon.setOnClickListener(this); //导航栏左边消息栏
        messageAdd.setOnClickListener(this); //导航栏添加图标
        netFailLayout.setOnClickListener(this); //网络连接失败
        rolerText.setOnClickListener(this);

        listView.addHeaderView(bannerHeadView, null, false);
        listView.addHeaderView(recordAccountView, null, false);
        final View scrollAlpha = getView().findViewById(R.id.scrollAlpha);
        final View scrollAlphaBackground = getView().findViewById(R.id.scrollAlphaBackground);
        listView.setScrollListener(new CustomListView.CustomScrollListener() {
            @Override
            public void onScroll(int scrollY) {
                //导航条的高度
                int viewHeight = DensityUtils.dp2px(getActivity().getApplicationContext(), 45);
                float alpha = Math.min(1.0f, (float) scrollY / viewHeight);
                scrollAlpha.setAlpha(alpha);
                if (scrollY > viewHeight) {
                    rolerText.setTextColor(ContextCompat.getColor(getActivity(), R.color.app_color));
                    changeRolerIcon.setImageResource(R.drawable.main_roler_red);
                    messageAdd.setImageResource(R.drawable.main_navigation_red_add);
                    scrollAlphaBackground.setVisibility(View.GONE);
                    navigationNoticeLine.setVisibility(View.VISIBLE);
                } else {
                    rolerText.setTextColor(ContextCompat.getColor(getActivity(), R.color.white));
                    changeRolerIcon.setImageResource(R.drawable.main_roler_white);
                    messageAdd.setImageResource(R.drawable.main_navigation_white_add);
                    scrollAlphaBackground.setVisibility(View.VISIBLE);
                    navigationNoticeLine.setVisibility(View.GONE);
                }
            }
        });
        ViewPager viewPager = (ViewPager) bannerHeadView.findViewById(R.id.viewpager);
        viewPager.setOnPageChangeListener(new ViewPager.OnPageChangeListener() {
            @Override
            public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {

            }

            @Override
            public void onPageSelected(int position) {
                bannerDots.setPager(position % bannerList.size()); //设置小点选中状态
                currentPosition = position;
            }

            @Override
            public void onPageScrollStateChanged(int state) {

            }
        });
        setDefaultBannerInfo();
    }

    /**
     * 设置记一笔，和记事本图片缩放比
     *
     * @param recordAccountView
     */
    private void setTitleBtnScale(View recordAccountView) {
        //由于记一笔按钮和 记事本按钮宽度太大我们这里需要对应的缩放一点
        //左内边距
        int paddingleft = DensityUtils.dp2px(getActivity().getApplicationContext(), 12);
        //右内边距
        int paddingRight = DensityUtils.dp2px(getActivity().getApplicationContext(), 12);
        //获取屏幕的宽度
        int screenWidth = ScreenUtils.getScreenWidth(getActivity().getApplicationContext());

        int[] noteImageInfo = ImageUtils.getImageWidthHeight(getActivity(), R.drawable.main_note_icon); //获取记事本图片的宽度
        int[] recordAccountImageInfo = ImageUtils.getImageWidthHeight(getActivity(), R.drawable.main_record_note); //获取记一笔图片的宽度
        float surplusWidth = screenWidth - paddingleft - paddingRight; //除去左内边距,右内边距,得到剩余的宽度

        float percentage = surplusWidth / (noteImageInfo[0] + recordAccountImageInfo[0]); //计算记事本图片占记一笔图片宽度百分百

        View noteImageBtn = recordAccountView.findViewById(R.id.note);
        View recordAccountImageBtn = recordAccountView.findViewById(R.id.takeAPenText);

        ViewGroup.LayoutParams noteParams = noteImageBtn.getLayoutParams();
        noteParams.width = (int) (noteImageInfo[0] * percentage);
        noteParams.height = (int) (noteImageInfo[1] * percentage);
        noteImageBtn.setLayoutParams(noteParams);

        ViewGroup.LayoutParams recordAccountParams = recordAccountImageBtn.getLayoutParams();
        recordAccountParams.width = (int) (recordAccountImageInfo[0] * percentage);
        recordAccountParams.height = (int) (recordAccountImageInfo[1] * percentage);
        recordAccountImageBtn.setLayoutParams(recordAccountParams);

        noteImageBtn.setOnClickListener(this);
        recordAccountImageBtn.setOnClickListener(this);
    }


    /**
     * 设置默认Banner数据
     */
    private void setDefaultBannerInfo() {
        int screenWidth = DensityUtils.getScreenWidth(getActivity());

        int defaultImageResource = R.drawable.default_banner;

        int[] widthHeight = ImageUtils.getImageWidthHeight(getActivity(), defaultImageResource);
        float imageWidth = widthHeight[0]; //默认Banner图片的宽度
        int imageHeight = widthHeight[1]; //默认Banner图片的高度

        float weight = screenWidth / imageWidth;

        ImageView defaultBanner = (ImageView) bannerHeadView.findViewById(R.id.default_banner);
        defaultBanner.setScaleType(ImageView.ScaleType.CENTER_CROP);
        RelativeLayout.LayoutParams params = (RelativeLayout.LayoutParams) defaultBanner.getLayoutParams();
        params.width = (int) Math.ceil(imageWidth * weight);
        params.height = (int) Math.ceil(imageHeight * weight);
        defaultBanner.setLayoutParams(params);
        ImageLoader.getInstance().displayImage("drawable://" + defaultImageResource, defaultBanner);
    }


    @Override
    public void onClick(View v) {
        int id = v.getId();
        Intent intent = null;
        switch (id) {
            case R.id.netFailLayout: //网络连接失败
                intent = new Intent(getActivity(), NetFailActivity.class);
                break;
            case R.id.messageAdd: //顶部右上角更多按钮
                WorkCirclePopWindow moreDialog = new WorkCirclePopWindow((AppMainActivity) getActivity());
                moreDialog.showAsDropDown(messageAdd, 0, DensityUtils.dp2px(getActivity(), 10));
                return;
            case R.id.takeAPenText: //记工本
                intent = new Intent(getActivity(), NewCalendarDetailActivity.class);
                break;
            case R.id.note: //记事本
                intent = new Intent(getActivity(), NoteBookListActivity.class);
                break;
            case R.id.signIcon: //每日一签图标
                X5WebViewActivity.actionStart(getActivity(), NetWorkRequest.WEBURLS + "my/signin");
                break;
            case R.id.rolerText:
            case R.id.changeRolerIcon: //切换角色
                intent = new Intent(getActivity(), ChooseRoleActivity.class);
                intent.putExtra(Constance.BEAN_BOOLEAN, false);
                break;
        }
        if (intent != null) {
            getActivity().startActivityForResult(intent, Constance.REQUEST);
        }
    }


    /**
     * 查询顶部Banner
     */
    public void searchBanner() {
        CommonHttpRequest.getAppBanner((BaseActivity) getActivity(), 6, new CheckListHttpUtils.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object bannerInfo) {
                Banner banner = (Banner) bannerInfo;
                if (banner != null && banner.getList() != null && banner.getList().size() > 0) {
                    bannerList = banner.getList();
                    int screenWidth = DensityUtils.getScreenWidth(getActivity()); //获取屏幕宽度
                    float bannerWidth = banner.getAd_size().get(0); //获取Banner图的宽度
                    float bannerHeight = banner.getAd_size().get(1); //获取Banner图的高度
                    float weight = screenWidth / bannerWidth; //屏幕的宽度/banner图的宽度 获取到缩放百分比
                    RelativeLayout pageLayout = (RelativeLayout) getView().findViewById(R.id.pageLayout);
                    LinearLayout.LayoutParams params1 = (LinearLayout.LayoutParams) pageLayout.getLayoutParams();
                    params1.width = (int) Math.ceil(bannerWidth * weight);
                    params1.height = (int) Math.ceil(bannerHeight * weight);

                    pageLayout.setLayoutParams(params1);
                    bannerDots.createDot(bannerList.size(), getActivity());//创建小圆点
                    viewPager.setAdapter(new WorkCircleViewPagerAdapter(bannerList, getActivity(), null));
                    viewPager.setCurrentItem(0);
                    bannerHeadView.findViewById(R.id.default_banner).setVisibility(View.GONE); //隐藏Banner默认图

                }
                loadAccountFlowGuide();
            }

            @Override
            public void onFailure(HttpException e, String s) {
                loadAccountFlowGuide();
            }
        });
    }

    @Override
    public void onStart() {
        super.onStart();
        //用一个定时器  来完成图片切换
        scheduledExecutorService = Executors.newSingleThreadScheduledExecutor();
//        //通过定时器 来完成 每2秒钟切换一个图片
//        //经过指定的时间后，执行所指定的任务
//        //scheduleAtFixedRate(command, initialDelay, period, unit)
//        //command 所要执行的任务
//        //initialDelay 第一次启动时 延迟启动时间
//        //period  每间隔多次时间来重新启动任务
//        //unit 时间单位
        scheduledExecutorService.scheduleAtFixedRate(new Runnable() {
            @Override
            public void run() {
                if (bannerList != null && bannerList.size() > 0) {
                    currentPosition = currentPosition + 1;
                    getActivity().runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            viewPager.setCurrentItem(currentPosition);
                        }
                    });
                }
            }
        }, 5, 5, TimeUnit.SECONDS);
    }

    @Override
    public void onStop() {
        super.onStop();
        //停止图片切换
        if (scheduledExecutorService != null) {
            scheduledExecutorService.shutdown();
        }
    }

    public void handlerBroadcastData(String action, Intent intent) {
        switch (action) {
            case WebSocketConstance.LOAD_CHAT_MAIN_HTTP_SUCCESS: //加载首页Http数据成功后的回调
                loadLocalDataBaseData(AccountStrategy.LOAD_SUCCESS_STATE);
                break;
            case WebSocketConstance.LOAD_CHAT_MAIN_HTTP_ERROR: //加载首页http数据失败后的回调
                loadLocalDataBaseData(AccountStrategy.LOAD_FAIL_STATE);
                break;
            case WebSocketConstance.REFRESH_LOCAL_DATABASE_MAIN_INDEX_AND_CHAT_LIST://当接收到这个广播的时候如果停留在当前页面则刷新本地列表数据，否则设置标识在onResume里刷新本地数据
                if (isFront) { //如果是在首页页面的话 直接刷新本地数据
                    loadLocalDataBaseData(AccountStrategy.LOAD_SUCCESS_STATE);
                } else { //如果是在其他页面接受到了刷新标识 则设置变量 当onResume在去刷新数据
                    isUpdateLocalGroupInfo = true;
                }
                break;
            case WebSocketConstance.REFRESH_SERVER_MAIN_INDEX_AND_CHAT_LIST://当接收到这个广播的时候如果停留在当前页面则重新调用Http获取首页数据,否则设置标识在onResume里调用Http数据
                if (isFront) {
                    MessageUtil.getWorkCircleData(getActivity());
                } else { //如果是在其他页面接受到了刷新标识 则设置变量 当onResume在去刷新数据
                    isRequestServer = true;
                }
                break;
            case ConnectivityManager.CONNECTIVITY_ACTION: //网络状态发生变化时候的调用
                boolean isConnectionNet = intent.getBooleanExtra(Constance.BEAN_BOOLEAN, false);
                netFailLayout.setVisibility(isConnectionNet ? View.GONE : View.VISIBLE);
                break;
        }
    }


    /**
     * 加载本地数据库数据
     *
     * @param loadState 加载状态
     */
    private void loadLocalDataBaseData(final int loadState) {
        LUtils.e("刷新首页数据:" + new SimpleDateFormat("yyyy-MM-dd hh:ss:mm").format(new java.util.Date()));
        if (!isLoadingDataBase) {
            isLoadingDataBase = true;
            //加载离线消息有可能速度会很快，频繁刷新数据库不是很好，我们这里每次只要涉及到加载数据库的操作就延迟0.2秒
            ThreadPoolUtils.fixedThreadPool.execute(new Runnable() {
                @Override
                public void run() {
                    try {
                        Thread.sleep(100);
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }
                    final ChatMainInfo chatMainInfo = MessageUtil.getLocalWorkCircleData();
                    getActivity().runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            setAdapter(chatMainInfo, loadState);
                            isLoadingDataBase = false;
                        }
                    });
                }
            });
        }
    }


    private void setAdapter(ChatMainInfo chatBaseInfo, int loadingState) {
        if (adapter == null) {
            adapter = new NewWorkCircleChatAdapter((BaseActivity) getActivity(), chatBaseInfo);
            adapter.setLoad_state(loadingState);
            listView.setAdapter(adapter);
        } else {
            adapter.setLoad_state(loadingState);
            adapter.updateList(chatBaseInfo);
        }
        scrollToBottom(chatBaseInfo);
        if (loadingState != AccountStrategy.LOADING_STATE) {
            searchAccount();
        }
    }

    private void scrollToBottom(ChatMainInfo chatMainInfo) {
        if (isScrollBottom) {
            if (chatMainInfo != null && chatMainInfo.getGroup_info() != null) {
                listView.setSelection(adapter.getCount() + listView.getHeaderViewsCount());
            }
            isScrollBottom = false;
        }
    }

    public void scrollToTop() {
        listView.setSelection(0);
        isScrollBottom = false;
    }

    public void setScrollBottom(boolean scrollBottom) {
        isScrollBottom = scrollBottom;
    }

    /**
     * 查询记账信息
     */
    public void searchAccount() {
        if (!UclientApplication.isHasRealName(getActivity())) { //必须完善了姓名才能调用记账接口
            return;
        }
        if (adapter == null || adapter.getItem(0) == null) { //如果首页没有数据才去调用记账
            RequestParams params = RequestParamsToken.getExpandRequestParams(getActivity());
            String httpUrl = NetWorkRequest.WORKDAY_RECORD;
            CommonHttpRequest.commonRequest(getActivity(), httpUrl, AccountInfoBean.class, CommonHttpRequest.OBJECT, params, false,
                    new CommonHttpRequest.CommonRequestCallBack() {
                        @Override
                        public void onSuccess(Object object) {
                            AccountInfoBean accountInfoBean = (AccountInfoBean) object;
                            if (adapter != null) {
                                adapter.setAccountInfoBean(accountInfoBean);
                                adapter.notifyDataSetChanged();
                            }
                        }

                        @Override
                        public void onFailure(HttpException exception, String errormsg) {

                        }
                    });
        }
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        searchAccount();
    }


    /**
     * 加载首页动画
     */
    private void loadAccountFlowGuide() {
        String key = "show_main_guide";
        boolean isShow = (boolean) SPUtils.get(getActivity(), key, false, Constance.JLONGG);
        if (!isShow) {
            //马上记一笔按钮
            final View takeAPenText = getView().findViewById(R.id.takeAPenText);
            takeAPenText.getViewTreeObserver().addOnGlobalLayoutListener(new ViewTreeObserver.OnGlobalLayoutListener() { //当布局加载完毕 设置背景图片的高度和宽度
                @Override
                public void onGlobalLayout() { //但是需要注意的是OnGlobalLayoutListener可能会被多次触发，因此在得到了高度之后，要
                    if (takeAPenText.getHeight() == 0) {
                        return;
                    }
                    int[] range = new int[]{DensityUtil.dp2px(2), DensityUtil.dp2px(2)};  //高亮范围
                    new HiGuide(getActivity()).addHightLight(takeAPenText,
                            range, HiGuide.SHAPE_RECT, new Overlay.Tips(R.layout.main_guide, Overlay.Tips.TO_CENTER_OF, Overlay.Tips.ALIGN_BOTTOM,
                                    new Overlay.Tips.Margin(0, DensityUtil.dp2px(10), 0, 0)))
                            .nextOverLay(new Overlay().addHightLight(getActivity().findViewById(R.id.find_worker_layout), //首页导航找工作 引导
                                    null, HiGuide.SHAPE_RECT, new Overlay.Tips(R.layout.main_guide_find_work, Overlay.Tips.TO_CENTER_OF, Overlay.Tips.ALIGN_TOP,
                                            new Overlay.Tips.Margin(0, 0, DensityUtil.dp2px(10), 0))))
                            .nextOverLay(new Overlay().addHightLight(getActivity().findViewById(R.id.discovered_layout),  //首页导航发现 引导
                                    null, HiGuide.SHAPE_RECT, new Overlay.Tips(R.layout.main_guide_discover, Overlay.Tips.TO_LEFT_OF, Overlay.Tips.ALIGN_TOP,
                                            new Overlay.Tips.Margin(0, 0, DensityUtil.dp2px(10), 0))))
                            .touchDismiss(true)
                            .show();
                    if (Build.VERSION.SDK_INT < 16) {
                        takeAPenText.getViewTreeObserver().removeGlobalOnLayoutListener(this);
                    } else {
                        takeAPenText.getViewTreeObserver().removeOnGlobalLayoutListener(this);
                    }
                }
            });
            SPUtils.put(getActivity(), key, true, Constance.JLONGG); // 存放Token信息
        }
    }
}

