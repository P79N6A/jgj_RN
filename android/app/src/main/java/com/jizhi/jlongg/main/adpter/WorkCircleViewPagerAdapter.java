package com.jizhi.jlongg.main.adpter;

import android.app.Activity;
import android.content.Intent;
import android.support.v4.view.PagerAdapter;
import android.support.v4.view.ViewPager;
import android.text.TextUtils;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;

import com.hcs.uclient.utils.AppUtils;
import com.hcs.uclient.utils.UtilImageLoader;
import com.jizhi.jlongg.account.NewAccountActivity;
import com.jizhi.jlongg.main.activity.X5WebViewActivity;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.Banner;
import com.jizhi.jlongg.main.listener.BannerListener;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.IsSupplementary;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SingsHttpUtils;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.callback.RequestCallBack;
import com.lidroid.xutils.http.client.HttpRequest;
import com.nostra13.universalimageloader.core.ImageLoader;

import java.util.List;

/**
 * 功能: 项目顶部banner 适配器
 * 作者：Xuj
 * 时间: 2016-8-22 11:11
 */
public class WorkCircleViewPagerAdapter extends PagerAdapter {

    /**
     * Banner图片Url 集合
     */
    private List<Banner> imageUrls;
    /**
     * Activity
     */
    private Activity activity;
    /**
     * Banner 图片点击回调
     */
    private BannerListener bannerListener;


    public WorkCircleViewPagerAdapter(List<Banner> imageUrls, Activity activity, BannerListener bannerListener) {
        this.imageUrls = imageUrls;
        this.activity = activity;
        this.bannerListener = bannerListener;
    }

    @Override
    public int getCount() {
        return Integer.MAX_VALUE;
    }

    @Override
    public boolean isViewFromObject(View arg0, Object arg1) {
        return arg0 == arg1;
    }

    @Override
    public void destroyItem(View container, int position, Object object) {
        ((ViewPager) container).removeView((View) object);
    }

    public Object instantiateItem(View container, final int position) {

        String url = imageUrls.get(position % imageUrls.size()).getImg_path();
        final Banner banner = imageUrls.get(position % imageUrls.size());
        ImageView bannerImageView = new ImageView(activity);
        bannerImageView.setScaleType(ImageView.ScaleType.CENTER_CROP);
        ViewGroup.LayoutParams params = new ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT);
        bannerImageView.setLayoutParams(params);
        ImageLoader.getInstance().displayImage(NetWorkRequest.IP_ADDRESS + url, bannerImageView, UtilImageLoader.getRoundOptions());
        ((ViewPager) container).addView(bannerImageView, 0);
        bannerImageView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (imageUrls.get(position % imageUrls.size()).getLink_type().equals(APP)) {
                    //内部地址
                    //1.示例数据example 2.记工 3.找项目
                    if (imageUrls.get(position % imageUrls.size()).getLink_key().equals("example")) {
//                        Intent intent = new Intent(activity, ExampleMessageTabActivity.class);
//                        activity.startActivity(intent);
                    } else if (imageUrls.get(position % imageUrls.size()).getLink_key().equals("record_bill")) {
                        if (!judgeLogin((activity))) {
                            return;
                        }
                        Intent intent = new Intent(activity, NewAccountActivity.class);
                        intent.putExtra(Constance.enum_parameter.ROLETYPE.toString(), UclientApplication.getRoler(activity));
                        activity.startActivity(intent);
                    } else if (imageUrls.get(position % imageUrls.size()).getLink_key().equals("find_job")) {
                        if (bannerListener != null) {
                            bannerListener.bannerClick();
                        }
                    }
                    statisticsBanner(activity, banner);
                } else if (imageUrls.get(position % imageUrls.size()).getLink_type().equals(HTML)) {
                    String webUrl = imageUrls.get(position % imageUrls.size()).getLink_key();
                    if (!TextUtils.isEmpty(webUrl)) {
                        statisticsBanner(activity, banner);
                        if (!webUrl.contains(NetWorkRequest.WEB_DOMAIN) || webUrl.contains(Constance.HEAD)) {
                            X5WebViewActivity.actionStart(activity, webUrl, true);
                        } else {
                            X5WebViewActivity.actionStart(activity, webUrl);
                        }
                    }
                }

            }
        });
        return bannerImageView;
    }


    /**
     * Banner统计
     */
    public void statisticsBanner(Activity activity, Banner banner) {
        String URL = NetWorkRequest.BANNERSTA;
        RequestParams params = RequestParamsToken.getExpandRequestParams(activity);
        params.addBodyParameter("aid", banner.getAid());// 广告位ID
        params.addBodyParameter("pid", banner.getPid());// 系统代码
        params.addBodyParameter("client", AppUtils.getImei(activity));
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, URL, params, new RequestCallBack<String>() {
            @Override
            public void onSuccess(ResponseInfo<String> responseInfo) {
            }

            @Override
            public void onFailure(HttpException e, String s) {
            }
        });
    }


    public static final String APP = "app";
    public static final String HTML = "html";
    //0413

    //判断是否登录或补充资料
    private boolean judgeLogin(Activity context) {
        if (!IsSupplementary.accessLogin(context)) {
            return false;
        }
        String title = UclientApplication.getRoler(context).equals(Constance.ROLETYPE_FM) ? "完善班组长/工头资料,即可查看该内容" : "完善工人资料,即可查看该内容";
        if (IsSupplementary.SupplementaryRegistrationWorker(context, title)) {
            return false;
        }
        return true;
    }

}
