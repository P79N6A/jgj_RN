package com.jizhi.jongg.widget;

import android.app.Activity;
import android.content.Context;
import android.util.AttributeSet;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.hcs.uclient.utils.DensityUtils;
import com.hcs.uclient.utils.UtilImageLoader;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.nostra13.universalimageloader.core.ImageLoader;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by Administrator on 2017/8/17 0017.
 */

public class HorizotalImageLayout extends LinearLayout {
    private Context context;

    public HorizotalImageLayout(Context context) {
        super(context);
        this.context = context;
    }

    public HorizotalImageLayout(Context context, AttributeSet attrs) {
        super(context, attrs);
        this.context = context;
    }

    public void createImages(List<String> imagePaths) {
        int imageSize = imagePaths.size();
        if (imagePaths == null || imagePaths.size() == 0) {
            return;
        }
        if (getChildCount() > 0) {
            removeAllViews();
        }
        if (imagePaths.size() > 3) {
            imagePaths = imagePaths.subList(0, 3);
        }
        int imagePedding = DensityUtils.dp2px(getContext(), 5);//每个图片间隔一dp
        View parentView = (View) getParent();
        int width = DensityUtils.getScreenWidth(getContext()) - parentView.getPaddingLeft() - parentView.getPaddingRight() - imagePedding * 3;
        int imageWidth = width / 4;
        int size = imagePaths.size();
        for (int i = 0; i < size; i++) {
            SquareImageView squareImageView = getImageView(imagePedding, imageWidth);
            ImageLoader.getInstance().displayImage(NetWorkRequest.IP_ADDRESS + imagePaths.get(i), squareImageView, UtilImageLoader.getExperienceOptions());
            addView(squareImageView);
        }
        if (imageSize >= 4) {
            SquareImageView squareImageView = getImageView(0, imageWidth);
            squareImageView.setImageResource(R.drawable.bg_default_imgnotice);
            addView(squareImageView);
        }
    }

    //    public void createImages(List<String> imagePaths, int px) {
//        int imageSize = imagePaths.size();
//        if (imagePaths == null || imagePaths.size() == 0) {
//            return;
//        }
//        if (getChildCount() > 0) {
//            removeAllViews();
//        }
//        if (imagePaths.size() > 3) {
//            imagePaths = imagePaths.subList(0, 3);
//        }
//        int imagePedding = DensityUtils.dp2px(getContext(), 5);//每个图片间隔一dp
//        View parentView = (View) getParent();
//        int width = (DensityUtils.getScreenWidth(getContext()) - parentView.getPaddingLeft() - parentView.getPaddingRight() - imagePedding * 3) - px;
//        int imageWidth = width / 4;
//        int size = imagePaths.size();
//        for (int i = 0; i < size; i++) {
//            SquareImageView squareImageView = getImageView(imagePedding, imageWidth);
//            ImageLoader.getInstance().displayImage(NetWorkRequest.IP_ADDRESS + imagePaths.get(i), squareImageView, UtilImageLoader.getExperienceOptions());
//            addView(squareImageView);
//        }
//        if (imageSize >= 4) {
//            SquareImageView squareImageView = getImageView(0, imageWidth);
//            squareImageView.setImageResource(R.drawable.bg_default_imgnotice);
//            addView(squareImageView);
//        }
//    }
    public void createImages(List<String> imagePath, int px) {
        int imageSize = imagePath.size();
        if (imagePath == null || imagePath.size() == 0) {
            return;
        }
        if (getChildCount() > 0) {
            removeAllViews();
        }
        List<String> teamPath;
        if (imagePath.size() >= 4) {
            teamPath = imagePath.subList(0, 3);
        } else {
            teamPath = imagePath;
        }
        int imagePedding = DensityUtils.dp2px(getContext(), 5);//每个图片间隔一dp
        View parentView = (View) getParent();
        int width = (DensityUtils.getScreenWidth(getContext()) - parentView.getPaddingLeft() - parentView.getPaddingRight() - imagePedding * 3) - px;
        int imageWidth = width / 4;
        for (int i = 0; i < teamPath.size(); i++) {
            SquareImageView squareImageView = getImageView(imagePedding, imageWidth);
            ImageLoader.getInstance().displayImage(NetWorkRequest.IP_ADDRESS + teamPath.get(i), squareImageView, UtilImageLoader.getExperienceOptions());
            addView(squareImageView);

        }
        if (imageSize >= 4) {
            View view = ((Activity) context).getLayoutInflater().inflate(R.layout.layout_squareimg, null);
            SquareImageView squareImageView = (SquareImageView) view.findViewById(R.id.img_view);
            ImageLoader.getInstance().displayImage(NetWorkRequest.IP_ADDRESS + imagePath.get(3), squareImageView, UtilImageLoader.getExperienceOptions());
            squareImageView.setScaleType(ImageView.ScaleType.CENTER_CROP);
            int count = imageSize - teamPath.size() - 1;
            if (count <= 0) {
                view.findViewById(R.id.img_mc).setVisibility(View.GONE);
                view.findViewById(R.id.tv_count).setVisibility(View.GONE);
            } else {
                view.findViewById(R.id.img_mc).setVisibility(View.VISIBLE);
                view.findViewById(R.id.tv_count).setVisibility(View.VISIBLE);
                ((TextView) view.findViewById(R.id.tv_count)).setText("+" + count);
            }
            LayoutParams layoutParams = new LayoutParams(imageWidth, imageWidth);
            layoutParams.rightMargin = imagePedding;
            view.setLayoutParams(layoutParams);
            addView(view);
        }
    }

    public SquareImageView getImageView(int imagePedding, int imageWidth) {
        SquareImageView imageView = new SquareImageView(getContext());
        imageView.setScaleType(ImageView.ScaleType.CENTER_CROP);
        LayoutParams layoutParams = new LayoutParams(imageWidth, imageWidth);
        layoutParams.rightMargin = imagePedding;
        imageView.setLayoutParams(layoutParams);
        return imageView;
    }


}
