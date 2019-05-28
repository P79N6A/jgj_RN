package com.jizhi.jlongg.main.adpter;

import android.app.Activity;
import android.content.res.Configuration;
import android.graphics.Color;
import android.graphics.drawable.Drawable;
import android.text.Spannable;
import android.text.SpannableStringBuilder;
import android.text.TextUtils;
import android.text.style.ForegroundColorSpan;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import com.hcs.uclient.utils.UtilImageLoader;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.UserInfo;
import com.jizhi.jlongg.main.bean.Video;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.jizhi.jongg.widget.RoundeImageHashCodeTextLayout;
import com.nostra13.universalimageloader.core.ImageLoader;
import com.xiao.nicevideoplayer.NiceVideoPlayer;
import com.xiao.nicevideoplayer.TxVideoPlayerController;

import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * 功能:新项目、新机会列表 Adapter
 * 时间:2016-4-18 18:34
 * 作者:xuj
 */
public class WonderfulAdapter extends BaseAdapter {
    /**
     * 视频列表
     */
    private List<Video> list;
    /**
     * xml解析器
     */
    private LayoutInflater inflater;
    /**
     * 分享、点赞、评论按钮回调
     */
    private VideoItemListener listener;
    /**
     * Activity
     */
    private Activity activity;
    /**
     * 是否播放第一个视频
     */
    private boolean isAutoPlayingFirstVideo;
    /**
     * 是否还有更多数据
     */
    private boolean isMoreData = true;


    public WonderfulAdapter(Activity activity, List<Video> list, VideoItemListener listener, boolean isAutoPlayingFirstVideo) {
        this.activity = activity;
        this.list = list;
        this.listener = listener;
        this.isAutoPlayingFirstVideo = isAutoPlayingFirstVideo;
        inflater = LayoutInflater.from(activity);
    }

    public void updateList(List<Video> list) {
        this.list = list;
    }

    public List<Video> getList() {
        return list;
    }


    @Override
    public int getCount() {
        return list == null ? 0 : list.size();
    }

    @Override
    public Video getItem(int position) {
        return list.get(position);
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    @Override
    public View getView(final int position, View convertView, ViewGroup parent) {
        final ViewHolder holder;
        if (convertView == null) {
            convertView = inflater.inflate(R.layout.video_item_new, parent, false);
            holder = new ViewHolder(convertView);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }
        final Video video = getItem(position);
        String content = video.getCms_content();
        if (!TextUtils.isEmpty(content) && content.indexOf("#") != -1) {
            Pattern p = Pattern.compile("#[^#]+#");
            if (!TextUtils.isEmpty(content)) { //姓名不为空的时才进行模糊匹配
                SpannableStringBuilder builder = new SpannableStringBuilder(content);
                Matcher nameMatch = p.matcher(content);
                while (nameMatch.find()) {
                    ForegroundColorSpan redSpan = new ForegroundColorSpan(Color.parseColor("#5BA0ED"));
                    builder.setSpan(redSpan, nameMatch.start(), nameMatch.end(), Spannable.SPAN_INCLUSIVE_INCLUSIVE);
                }
                holder.cmsContent.setText(builder);
            }
        } else {
            holder.cmsContent.setText(content); //视频内容
        }
        holder.realName.setText(video.getUser_info().getReal_name()); //上传者名称
        holder.commentNum.setText(video.getComment_num() == 0 ? "评论" : video.getComment_num() + ""); //评论数
        holder.likeNum.setText(video.getLike_num() == 0 ? "点赞" : video.getLike_num() + ""); //点赞数
        final UserInfo userInfo = video.getUser_info(); //上传者视频信息
        String uploadPersonName = !TextUtils.isEmpty(userInfo.getReal_name()) && userInfo.getReal_name().length() >= 2 ? userInfo.getReal_name().substring(0, 1) : userInfo.getReal_name(); //设置上传者名称
        holder.headPic.setView(userInfo.getHead_pic(), uploadPersonName, position); //设置用户头像
        if (video.getIs_liked() == 1) { //已点赞
            Drawable mClearDrawable = convertView.getResources().getDrawable(R.drawable.like_num_zan);
            mClearDrawable.setBounds(0, 0, mClearDrawable.getIntrinsicWidth(), mClearDrawable.getIntrinsicHeight()); //设置清除的图片
            holder.likeNum.setCompoundDrawables(mClearDrawable, null, null, null);
        } else {
            Drawable mClearDrawable = convertView.getResources().getDrawable(R.drawable.like_num);
            mClearDrawable.setBounds(0, 0, mClearDrawable.getIntrinsicWidth(), mClearDrawable.getIntrinsicHeight()); //设置清除的图片
            holder.likeNum.setCompoundDrawables(mClearDrawable, null, null, null);
        }
        holder.scrollFootLayout.setVisibility(position == getCount() - 1 && !isMoreData ? View.VISIBLE : View.GONE);
        bindVideoInfo(holder, video, position);
        View.OnClickListener onClickListener = new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (listener == null) {
                    return;
                }
                switch (v.getId()) {
                    case R.id.comment_num://评论数
                    case R.id.cms_content:
                        listener.commentNum(video);
                        break;
                    case R.id.like_num: //点赞数
                        listener.likeNum(video);
                        break;
                    case R.id.share_video: //分享
                        listener.share(video);
                        break;
                    case R.id.head_pic: //上传者头像
                        listener.clickHead(userInfo.getUid());
                        break;
                }
            }
        };
        holder.cmsContent.setOnClickListener(onClickListener);
        holder.commentNum.setOnClickListener(onClickListener);
        holder.likeNum.setOnClickListener(onClickListener);
        holder.headPic.setOnClickListener(onClickListener);
        holder.shareVideo.setOnClickListener(onClickListener);
        return convertView;
    }


    /**
     * 绑定视频信息
     *
     * @param holder
     * @param video
     * @param position
     */
    private void bindVideoInfo(ViewHolder holder, Video video, final int position) {
        NiceVideoPlayer niceVideoPlayer = holder.mVideoPlayer;
        niceVideoPlayer.setUp(video.getVideo_url(), null);//设置视频播放路径
        String videoThumbnailSrc = video.getPic_src() != null && video.getPic_src().size() > 0 ? NetWorkRequest.CDNURL + video.getPic_src().get(0) : "";//视频缩略图地址
        if (holder.mController.imageView().getVisibility() == View.VISIBLE) {
            if (holder.mController.imageView().getTag() != null && holder.mController.imageView().getTag().equals(videoThumbnailSrc + position)) {

            } else { // 如果不相同，就加载。现在在这里来改变闪烁的情况
                ImageLoader.getInstance().displayImage(videoThumbnailSrc, holder.mController.imageView(), UtilImageLoader.getVideoThumbnailOptions());
                holder.mController.imageView().setTag(videoThumbnailSrc + position);
            }
        }
        int orientation = activity.getResources().getConfiguration().orientation; //获取屏幕方向
        holder.mController.setTitle(orientation == Configuration.ORIENTATION_LANDSCAPE ? video.getCms_content() : ""); //竖向的时候不需要显示视频标题,横向的时候才需要展示视频标题
        holder.mController.setLenght(video.getVideo_time() * 1000); //这里以毫秒为单位
        holder.mVideoPlayer.setMediaPlayerListener(new TxVideoPlayerController.MediaPlayerListener() {
            @Override
            public void startVideoCallBack() { //开始播放视频的回调
                if (listener != null) {
                    listener.getStartingVideoPosition(position);
                }
            }
        });
        if (position == 0 && isAutoPlayingFirstVideo) {
            isAutoPlayingFirstVideo = false;
            holder.mVideoPlayer.start();
        }

    }


    class ViewHolder {
        /**
         * 媒体播放控制
         */
        TxVideoPlayerController mController;
        /**
         * 媒体播放控制
         */
        NiceVideoPlayer mVideoPlayer;
        /**
         * 视频内容信息
         */
        TextView cmsContent;
        /**
         * 上传者头像
         */
        RoundeImageHashCodeTextLayout headPic;
        /**
         * 上传视频者名称
         */
        TextView realName;
        /**
         * 点赞数
         */
        TextView likeNum;
        /**
         * 评论数
         */
        TextView commentNum;
        /**
         * 分享按钮
         */
        TextView shareVideo;
        /**
         * 如果ListView滚动到底部需要显示的布局
         */
        View scrollFootLayout;

        private ViewHolder(View convertView) {
            cmsContent = (TextView) convertView.findViewById(R.id.cms_content);
            headPic = (RoundeImageHashCodeTextLayout) convertView.findViewById(R.id.head_pic);
            realName = (TextView) convertView.findViewById(R.id.real_name);
            commentNum = (TextView) convertView.findViewById(R.id.comment_num);
            likeNum = (TextView) convertView.findViewById(R.id.like_num);
            shareVideo = (TextView) convertView.findViewById(R.id.share_video);
            mVideoPlayer = (NiceVideoPlayer) convertView.findViewById(R.id.nice_video_player);
            scrollFootLayout = convertView.findViewById(R.id.scrollFootLayout);
            TxVideoPlayerController controller = new TxVideoPlayerController(activity);
            ViewGroup.LayoutParams params = mVideoPlayer.getLayoutParams();
            params.width = convertView.getResources().getDisplayMetrics().widthPixels; // 宽度为屏幕宽度
            params.height = (int) (params.width * 9f / 16f);    // 高度为宽度的9/16
            mVideoPlayer.setLayoutParams(params);
            mController = controller;
            mVideoPlayer.setController(mController);
            //将列表中的每个视频设置为默认16: 9 的比例
        }
    }


    public interface VideoItemListener {
        public void share(Video video); //分享

        public void likeNum(Video video); //点赞

        public void commentNum(Video video); //点击评论

        public void clickHead(String uid); //点击头像

        public void getStartingVideoPosition(int position); //获取当前播放的视频下标
    }


    public void addList(List<Video> list) {
        this.list.addAll(list);
    }

    public boolean isMoreData() {
        return isMoreData;
    }

    public void setMoreData(boolean moreData) {
        isMoreData = moreData;
    }
}
