package com.jizhi.jongg.widget;


import android.content.Context;
import android.support.v4.content.ContextCompat;
import android.text.TextUtils;
import android.util.AttributeSet;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;

import com.hcs.uclient.utils.UtilImageLoader;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.makeramen.roundedimageview.RoundedImageView;
import com.nostra13.universalimageloader.core.ImageLoader;


/**
 * A simple text label view that can be applied as a "badge" to any given
 * {@link View}. This class is intended to be instantiated at
 * runtime rather than included in XML layouts.
 *
 * @author Jeff Gilfelt
 */
public class RoundeImageHashCodeTextLayout extends LinearLayout {
    /**
     * 圆角图片
     */
    private ImageView roundeImageView;
    /**
     * 获取hashCode颜色的码
     */
    private HashCodeGenerateText hashCodeGenerateText;
    /**
     * 默认显示的字体大小
     */
    private int DEFAULT_TEXT_SIZE = 15;

//    @Override
//    protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
//        super.onMeasure(widthMeasureSpec, heightMeasureSpec);
//        setMeasuredDimension(getMeasuredWidth(), getMeasuredWidth());
//        LUtils.e("width:" + MeasureSpec.getSize(widthMeasureSpec) + "      height:" + MeasureSpec.getSize(heightMeasureSpec));
//    }

    public RoundeImageHashCodeTextLayout(Context context) {
        super(context);
    }

    public RoundeImageHashCodeTextLayout(Context context, AttributeSet attrs) {
        super(context, attrs);
    }


    public void setView(String headPic, String realName, int position) {
        if (isUidZero(headPic)) { //uid为空则加载默认图
            loadingDefaultImage(headPic, position);
            return;
        }
        if (!TextUtils.isEmpty(headPic) && !headPic.contains("headpic_m") && !headPic.contains("headpic_f") && !headPic.contains("nopic=1")) {  //如果头像不为 并且 不匹配如下正则表达式
            generateImageView(headPic, position);
        } else {
            if (!TextUtils.isEmpty(realName)) {
                realName = realName.replace("[^0-9a-zA-z\u4e00-\u9fa5]*/g", "");
                generateHashCodeTextView(realName);
            }
        }
    }


    public void loadLocalPic(int imageId, int position) {
        if (hashCodeGenerateText != null) {
            hashCodeGenerateText.setVisibility(View.GONE);
        }
        if (roundeImageView == null) {
            LayoutParams params = new LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT);
            roundeImageView = new RoundedImageView(getContext());
            roundeImageView.setScaleType(ImageView.ScaleType.CENTER_CROP);
            roundeImageView.setLayoutParams(params);
            addView(roundeImageView);
        }
        if (roundeImageView.getVisibility() == View.GONE) {
            roundeImageView.setVisibility(View.VISIBLE);
        }
        if (roundeImageView.getTag() != null && roundeImageView.getTag().equals(imageId + position)) {

        } else { // 如果不相同，就加载。现在在这里来改变闪烁的情况
            ImageLoader.getInstance().displayImage("drawable://" + imageId, roundeImageView, UtilImageLoader.getLocalPicOptions());
            roundeImageView.setTag(imageId + position);
        }
    }

    /**
     * 生成图片
     *
     * @param headPic
     * @param position
     */
    public void generateImageView(String headPic, int position) {
        if (hashCodeGenerateText != null && hashCodeGenerateText.getVisibility() == View.VISIBLE) {
            hashCodeGenerateText.setVisibility(View.GONE);
        }
        if (roundeImageView == null) {
            LayoutParams params = new LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT);
            roundeImageView = new RoundedImageView(getContext());
            roundeImageView.setScaleType(ImageView.ScaleType.CENTER_CROP);
            roundeImageView.setLayoutParams(params);
            addView(roundeImageView);
        }
        if (roundeImageView.getVisibility() == View.GONE) {
            roundeImageView.setVisibility(View.VISIBLE);
        }
        if (roundeImageView.getTag() != null && roundeImageView.getTag().equals(headPic + position)) {
        } else { // 如果不相同，就加载。现在在这里来改变闪烁的情况
            ImageLoader.getInstance().displayImage(NetWorkRequest.IP_ADDRESS + headPic, roundeImageView, UtilImageLoader.getRectangleHead(getContext()));
            roundeImageView.setTag(headPic + position);
        }
    }

    /**
     * 生成HashCode  字符
     *
     * @param realName
     */
    public void generateHashCodeTextView(String realName) {
        if (roundeImageView != null && roundeImageView.getVisibility() == View.VISIBLE) {
            roundeImageView.setVisibility(View.GONE);
        }
        if (hashCodeGenerateText == null) {
            LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT);
            hashCodeGenerateText = new HashCodeGenerateText(getContext());
            hashCodeGenerateText.setGravity(Gravity.CENTER);
            hashCodeGenerateText.setQuare(true);
            hashCodeGenerateText.setTextColor(ContextCompat.getColor(getContext(), R.color.white));
            hashCodeGenerateText.setLayoutParams(params);
            hashCodeGenerateText.setTextSize(DEFAULT_TEXT_SIZE);
            addView(hashCodeGenerateText);
        }
        if (hashCodeGenerateText.getVisibility() == View.GONE || hashCodeGenerateText.getVisibility() == View.INVISIBLE) {
            hashCodeGenerateText.setVisibility(View.VISIBLE);
        }
        hashCodeGenerateText.setText(realName.substring(realName.length() >= 2 ? realName.length() - 2 : realName.length() - 1));
        hashCodeGenerateText.accordingHashCodeSetBackground(realName.substring(realName.length() - 1));
    }


    /**
     * uid是否为0
     *
     * @param headPic
     * @return
     */
    public boolean isUidZero(String headPic) {
        if (!TextUtils.isEmpty(headPic) && headPic.contains("uid=0")) { //未选择负责人
            return true;
        }
        return false;
    }

    /**
     * 加载默认图片
     *
     * @param headPic
     * @param position
     */
    public void loadingDefaultImage(String headPic, int position) {
        if (hashCodeGenerateText != null) {
            hashCodeGenerateText.setVisibility(View.GONE);
        }
        if (roundeImageView == null) {
            LayoutParams params = new LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT);
            roundeImageView = new RoundedImageView(getContext());
            roundeImageView.setScaleType(ImageView.ScaleType.CENTER_CROP);
            roundeImageView.setLayoutParams(params);
            addView(roundeImageView);
        }
        if (roundeImageView.getVisibility() == View.GONE) {
            roundeImageView.setVisibility(View.VISIBLE);
        }
        if (roundeImageView.getTag() != null && roundeImageView.getTag().equals(headPic + position)) {

        } else { // 如果不相同，就加载。现在在这里来改变闪烁的情况
            ImageLoader.getInstance().displayImage("drawable://" + R.drawable.icon_mine_norma, roundeImageView);
            roundeImageView.setTag(headPic + position);
        }
    }

    public ImageView getRoundeImageView() {
        return roundeImageView;
    }

    public void setDEFAULT_TEXT_SIZE(int DEFAULT_TEXT_SIZE) {
        this.DEFAULT_TEXT_SIZE = DEFAULT_TEXT_SIZE;
    }

}

