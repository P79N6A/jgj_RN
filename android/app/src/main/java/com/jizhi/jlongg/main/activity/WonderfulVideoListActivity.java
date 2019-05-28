package com.jizhi.jlongg.main.activity;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Intent;
import android.content.res.Configuration;
import android.os.Bundle;
import android.support.v4.content.LocalBroadcastManager;
import android.support.v7.app.AppCompatActivity;
import android.text.TextUtils;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.AbsListView;

import com.hcs.uclient.utils.LUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.listener.PullRefreshCallBack;
import com.jizhi.jlongg.main.adpter.WonderfulAdapter;
import com.jizhi.jlongg.main.bean.Share;
import com.jizhi.jlongg.main.bean.Video;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.RepositoryUtil;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SetTitleName;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.jizhi.jongg.widget.PageListView;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;
import com.xiao.nicevideoplayer.NiceVideoPlayer;
import com.xiao.nicevideoplayer.NiceVideoPlayerManager;

import java.util.List;

/**
 * 功能: 精彩小视频
 * 作者：Xuj
 * 时间: 2018年3月24日11:17:04
 */
public class WonderfulVideoListActivity extends AppCompatActivity implements WonderfulAdapter.VideoItemListener, PullRefreshCallBack {
    /**
     * 视频列表适配器
     */
    private WonderfulAdapter adapter;
    /**
     * listView
     */
    private PageListView pageListView;
    /**
     * 导航条view
     */
    private View navigationView;
    /**
     * 当前视频播放的下标
     */
    private int playingVideoPosition = -1;


    /**
     * 启动当前Activity
     *
     * @param context
     */
    public static void actionStart(Activity context) {
        Intent intent = new Intent(context, WonderfulVideoListActivity.class);
        context.startActivityForResult(intent, Constance.REQUEST);
    }

    /**
     * 启动当前Activity
     *
     * @param context
     * @param noteId  帖子id
     */
    public static void actionStart(Activity context, int noteId) {
        Intent intent = new Intent(context, WonderfulVideoListActivity.class);
        intent.putExtra(Constance.ID, noteId);
        context.startActivityForResult(intent, Constance.REQUEST);
    }


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        this.requestWindowFeature(Window.FEATURE_NO_TITLE); // 隐藏应用程序的标题栏，即当前activity的label
        this.getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN); // 隐藏
        setContentView(R.layout.wonderful_video);
        initView();
        getVideoInfo();
    }

    private void initView() {
        SetTitleName.setTitle(findViewById(R.id.title), getString(R.string.wonderful_video));
        navigationView = findViewById(R.id.head);
        pageListView = (PageListView) findViewById(R.id.listView);
        pageListView.setPullUpToRefreshView(loadMoreDataView(), new AbsListView.OnScrollListener() {
            @Override
            public void onScrollStateChanged(AbsListView view, int scrollState) {

            }

            @Override
            public void onScroll(AbsListView view, int firstVisibleItem, int visibleItemCount, int totalItemCount) {
                if (playingVideoPosition != -1 && (playingVideoPosition < pageListView.getFirstVisiblePosition() || playingVideoPosition > pageListView.getLastVisiblePosition())
                        && getDirection() == Configuration.ORIENTATION_PORTRAIT && isPlayingVideo()) {
                    playingVideoPosition = -1;
                    LUtils.e("释放资源");
                    NiceVideoPlayerManager.instance().releaseNiceVideoPlayer();
                }
            }
        }); //设置上拉刷新组件
        pageListView.setPullRefreshCallBack(this); //设置上拉、下拉刷新回调
    }

    /**
     * 显示listView 底部加载对话框
     *
     * @return
     */
    public View loadMoreDataView() {
        View foot_view = getLayoutInflater().inflate(R.layout.foot_loading_dialog, null); // 加载对话框
        foot_view.setVisibility(View.GONE);
        return foot_view;
    }


    /**
     * 获取当前是横屏状态还是竖屏状态
     *
     * @return
     */
    public int getDirection() {
        return getApplicationContext().getResources().getConfiguration().orientation;
    }

    /**
     * 是否正在播放视频
     *
     * @return
     */
    public boolean isPlayingVideo() {
        NiceVideoPlayer videoPlayer = NiceVideoPlayerManager.instance().getCurrentNiceVideoPlayer();
        return videoPlayer == null ? false : true;
//        boolean isPlaying = videoPlayer == null || !videoPlayer.isPlaying() ? false : true;
//        return isPlaying;
    }

    //屏幕方向发生改变的回调方法
    @Override
    public void onConfigurationChanged(Configuration newConfig) {
        if (newConfig.orientation == Configuration.ORIENTATION_LANDSCAPE) {
            navigationView.setVisibility(View.GONE);
        } else {
            navigationView.setVisibility(View.VISIBLE);
        }
        super.onConfigurationChanged(newConfig);
    }

    /**
     * 获取视频信息
     */
    public void getVideoInfo() {
        String httpUrl = NetWorkRequest.WONDERFUL_VIDEO;
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        params.addBodyParameter("pg", pageListView.getPageNum() + "");
        params.addBodyParameter("pagesize", RepositoryUtil.DEFAULT_PAGE_SIZE + "");
        params.addBodyParameter("id", getIntent().getIntExtra(Constance.ID, 0) + ""); //帖子id
        CommonHttpRequest.commonRequest(this, httpUrl, Video.class, CommonHttpRequest.LIST, params, false, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                List<Video> videoList = (List<Video>) object;
                setAdapter(videoList);
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {
                pageListView.loadOnFailure();
            }
        });
    }

    /**
     * 点赞
     *
     * @param info
     */
    public void dynamicLiked(final Video info) {
        int id = info.getId(); //获取帖子id
        String httpUrl = NetWorkRequest.WONDERFUL_VIDEO_LIKE;
        RequestParams params = RequestParamsToken.getExpandRequestParams(this);
        params.addBodyParameter("id", id + "");
        params.addBodyParameter("class_type", "1");
        params.addBodyParameter("type", info.getIs_liked() == 0 ? "1" : "2"); //	1,点赞，2取消点赞，默认是1
        CommonHttpRequest.commonRequest(this, httpUrl, Video.class, CommonHttpRequest.OBJECT, params, false, new CommonHttpRequest.CommonRequestCallBack() {
            @Override
            public void onSuccess(Object object) {
                Video serverInfo = (Video) object;
                info.setLike_num(serverInfo.getLike_num()); //设置点赞数
                info.setIs_liked(serverInfo.getIs_liked()); //设置是否点赞的状态
                adapter.notifyDataSetChanged();
            }

            @Override
            public void onFailure(HttpException exception, String errormsg) {

            }
        });
    }

    public void onFinish(View view) {
        finish();
    }

    @Override
    public void share(Video video) {//分享视频
        String videoThumbnailSrc = video.getPic_src() != null && video.getPic_src().size() > 0 ? NetWorkRequest.CDNURL + video.getPic_src().get(0) : "";//视频缩略图地址
        Share share = new Share();
        share.setUrl(NetWorkRequest.WEBURLS + "dynamic/info?id=" + video.getId()); //设置分享的视频路径
        share.setImgUrl(videoThumbnailSrc); //设置分享的图片
        share.setTitle("分享" + video.getUser_info().getReal_name() + "的帖子");
        share.setDescribe(TextUtils.isEmpty(video.getCms_content()) ? "分享了视频" : video.getCms_content()); //设置分享的内容
    }

    @Override
    public void likeNum(Video video) { //点赞
        dynamicLiked(video);
    }

    @Override
    public void commentNum(Video video) { //评论视频
        Intent intent = new Intent();
        intent.setAction(Constance.SEND_HTML5_COMMENT);
        intent.putExtra(Constance.ID, video.getId());
        LocalBroadcastManager.getInstance(this).sendBroadcast(intent);
        finish();
    }

    @Override
    public void clickHead(String uid) {
        Intent intent = new Intent();
        intent.setAction(Constance.SEND_HTML5_COMMENT);
        intent.putExtra(Constance.UID, uid);
        LocalBroadcastManager.getInstance(this).sendBroadcast(intent);
        finish();
    }

    @Override
    public void getStartingVideoPosition(int position) {
        playingVideoPosition = position;
    }


    @Override
    protected void onResume() {
        super.onResume();
        NiceVideoPlayerManager.instance().resume();
    }

    @SuppressLint("MissingSuperCall")
    @Override
    protected void onPause() {
        super.onStop();
        NiceVideoPlayerManager.instance().pause();
    }


    @Override
    protected void onDestroy() {
        super.onDestroy();
        NiceVideoPlayerManager.instance().releaseNiceVideoPlayer();
    }

    @Override
    public void onBackPressed() {
        if (NiceVideoPlayerManager.instance().onBackPressd()) return;
        super.onBackPressed();
    }

    @Override
    public void callBackPullUpToRefresh(int pageNum) {
        getVideoInfo();
    }

    @Override
    public void callBackPullDownToRefresh(int pageNum) {
        getVideoInfo();
    }

    private void setAdapter(List<Video> videoList) {
        PageListView pageListView = this.pageListView;
        int pageNum = pageListView.getPageNum();
        if (adapter == null) {
            adapter = new WonderfulAdapter(WonderfulVideoListActivity.this, videoList, WonderfulVideoListActivity.this, true);
            pageListView.setListViewAdapter(adapter); //设置适配器
        } else {
            if (pageNum == 1) { //下拉刷新
                adapter.updateList(videoList);//替换数据
            } else {
                adapter.addList(videoList); //添加数据
            }
        }
        pageListView.loadDataFinish(videoList);
        adapter.setMoreData(pageListView.isMoreData());
        adapter.notifyDataSetChanged();
    }

}
