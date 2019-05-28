package com.jizhi.jlongg.main.dialog;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;

import com.hcs.uclient.utils.AppUtils;
import com.hcs.uclient.utils.DensityUtils;
import com.hcs.uclient.utils.UtilImageLoader;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.activity.X5WebViewActivity;
import com.jizhi.jlongg.main.adpter.WorkCircleViewPagerAdapter;
import com.jizhi.jlongg.main.application.UclientApplication;
import com.jizhi.jlongg.main.bean.Banner;
import com.jizhi.jlongg.main.util.BackGroundUtil;
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
import com.nineoldandroids.animation.Animator;
import com.nineoldandroids.animation.AnimatorSet;
import com.nineoldandroids.animation.ObjectAnimator;
import com.nostra13.universalimageloader.core.ImageLoader;

import static com.jizhi.jlongg.main.adpter.WorkCircleViewPagerAdapter.HTML;


/**
 * 广告位弹出框
 *
 * @author Xuj
 * @date 2017年6月19日11:21:11
 */
public class AdvertisementPopWindow extends PopupWindowExpand implements View.OnClickListener {
    /**
     * 动画开始
     */
    private float from = 1.0f;
    /**
     * 动画结束
     */
    private float after = 0.5f;
    /**
     * 滚动小球1
     */
    private View view1;
    /**
     * 滚动小球2
     */
    private View view2;
    /**
     * 滚动小球3
     */
    private View view3;
    /**
     * 是否暂停
     */
    private boolean isPauseAnim;

    public AdvertisementPopWindow(Activity activity, float imageWidth, float imageHeight, Banner banner) {
        super(activity);
        this.activity = activity;
        setPopView();
        init(imageWidth, imageHeight, banner);
        startLoadingAnim();
    }

    private void setPopView() {
        LayoutInflater inflater = (LayoutInflater) activity.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        popView = inflater.inflate(R.layout.advertisement_popwindow, null);
        setContentView(popView);
        setPopParameter();
        setOnDismissListener(new OnDismissListener() {
            @Override
            public void onDismiss() {
                isPauseAnim = true;
                BackGroundUtil.backgroundAlpha(activity, 1.0F);
            }
        });
    }

    private void init(float imageWidth, float imageHeight, final Banner banner) {
        view1 = popView.findViewById(R.id.view1);
        view2 = popView.findViewById(R.id.view2);
        view3 = popView.findViewById(R.id.view3);

        RelativeLayout loadingLayout = (RelativeLayout) popView.findViewById(R.id.loadingLayout);

        int adPadding = DensityUtils.dp2px(activity, 80); //图片左右的间距
        int screenWidth = DensityUtils.getScreenWidth(activity) - adPadding; //获取屏幕宽度
        float weight = screenWidth / imageWidth; //计算屏幕和服务器返回图片大小的百分比  放大或缩小
        ImageView advertisementImage = (ImageView) popView.findViewById(R.id.advertisementImage);


        LinearLayout.LayoutParams params = (LinearLayout.LayoutParams) loadingLayout.getLayoutParams();
        params.width = (int) (weight * imageWidth);
        params.height = (int) (weight * imageHeight);
        loadingLayout.setLayoutParams(params);

        RelativeLayout.LayoutParams imageParams = (RelativeLayout.LayoutParams) advertisementImage.getLayoutParams();
        imageParams.width = params.width;
        imageParams.height = params.height;
        advertisementImage.setLayoutParams(imageParams);

        ImageLoader.getInstance().displayImage(NetWorkRequest.IP_ADDRESS + banner.getImg_path(),
                advertisementImage, UtilImageLoader.getAdvertiseOptions(activity));

        popView.findViewById(R.id.closeIcon).setOnClickListener(this);
        advertisementImage.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                handlerClickAdvertisementImage(banner);
            }
        });
    }

    /**
     * 开启加载广告动画
     */
    public void startLoadingAnim() {
        if (isPauseAnim) {
            return;
        }
        // 将一个TextView沿垂直方向先从原大小（1f）放大到5倍大小（5f），然后再变回原大小。
        ObjectAnimator view1AnimX = ObjectAnimator.ofFloat(view1, "scaleX", from, after);
        ObjectAnimator view1AnimY = ObjectAnimator.ofFloat(view1, "scaleY", from, after);

        ObjectAnimator view2AnimX = ObjectAnimator.ofFloat(view2, "scaleX", from, after);
        ObjectAnimator view2AnimY = ObjectAnimator.ofFloat(view2, "scaleY", from, after);

        ObjectAnimator view3AnimX = ObjectAnimator.ofFloat(view3, "scaleX", from, after);
        ObjectAnimator view3AnimY = ObjectAnimator.ofFloat(view3, "scaleY", from, after);
        /**
         * anim1，anim2,anim3同时执行
         * anim4接着执行
         */
        AnimatorSet animSet = new AnimatorSet();
        if (from == 1.0f) {
            animSet.play(view1AnimX).with(view1AnimY).before(view2AnimX); //按顺序执行动画1、2、3
            animSet.play(view2AnimX).with(view2AnimY).before(view3AnimX);
            animSet.play(view3AnimX).with(view3AnimY);
        } else {
            animSet.play(view3AnimX).with(view3AnimY).before(view2AnimX); //按顺序执行动画3、2、1
            animSet.play(view2AnimX).with(view2AnimY).before(view1AnimX);
            animSet.play(view1AnimX).with(view1AnimY);
        }
        animSet.setDuration(300);
        animSet.start();
        animSet.addListener(new Animator.AnimatorListener() {
            @Override
            public void onAnimationStart(Animator animator) {

            }

            @Override
            public void onAnimationEnd(Animator animator) {
                from = from == 1.0f ? 0.5f : 1.0f;
                after = after == 1.0f ? 0.5f : 1.0f;
                startLoadingAnim();
            }

            @Override
            public void onAnimationCancel(Animator animator) {

            }

            @Override
            public void onAnimationRepeat(Animator animator) {

            }
        });
    }


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.closeIcon: //关闭广告按钮
                dismiss();
                break;
        }
    }

    /**
     * 处理广告位点击事件
     */
    public void handlerClickAdvertisementImage(Banner banner) {
        String linKType = banner.getLink_type();
        String linkKey = banner.getLink_key();
        if (TextUtils.isEmpty(linKType) || TextUtils.isEmpty(linkKey)) {
            return;
        }
        if (linKType.equals(WorkCircleViewPagerAdapter.APP)) {//内部地址
            //1.新建班组 2.示例界面 3.找项目组find_helper
            if (linkKey.equals("creat_group")) {
                if (!judgeLogin((activity))) {
                    return;
                }
            } else if (linkKey.equals("example")) {
//                Intent intent = new Intent(activity, ExampleMessageTabActivity.class);
//                activity.startActivity(intent);
            }
            countBanner(activity, banner);
        } else if (linKType.equals(HTML)) { //网页
            if (!TextUtils.isEmpty(linkKey)) {
                countBanner(activity, banner);
                Intent intent = new Intent(activity, X5WebViewActivity.class);
                intent.putExtra("url", linkKey);
                if (!linkKey.contains(NetWorkRequest.WEBURLS)) {
                    intent.putExtra("isShowTitle", true);
                }
                activity.startActivity(intent);
            }
        }
    }

    /**
     * Banner统计
     */
    public void countBanner(Activity activity, Banner banner) {
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