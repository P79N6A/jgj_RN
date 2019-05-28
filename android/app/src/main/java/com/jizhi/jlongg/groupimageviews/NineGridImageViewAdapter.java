package com.jizhi.jlongg.groupimageviews;

import android.content.Context;
import android.widget.ImageView;

import java.util.List;

/**
 * Created by loften on 16/4/21.
 */
public abstract class NineGridImageViewAdapter<T> {

    protected abstract void onDisplayImage(Context context, ImageView imageView, T t);

    protected ImageView generateImageView(Context context) {
//        RoundedImageView imageView = new RoundedImageView(context);
//        imageView.setCornerRadius(context.getResources().getDimension(R.dimen.rect_radius));
//        imageView.setOval(false);
//        imageView.setScaleType(ImageView.ScaleType.CENTER_CROP);
        ImageView imageView = new ImageView(context);
        imageView.setScaleType(ImageView.ScaleType.CENTER_CROP);
        return imageView;
    }


    protected void onItemImageClick(Context context, int index, List<T> list, ImageView imageView) {

    }
}
