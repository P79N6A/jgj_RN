package com.jizhi.jlongg.main.util;

import android.content.Context;
import android.content.res.Resources;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.view.View;
import android.view.ViewParent;
import android.widget.ImageView;

import com.jizhi.jlongg.R;

import java.util.List;

/**
 * 功能: 创建浮层引导
 * 作者：Administrator
 * 时间: 2016/3/11 14:20
 */
public class FunctionGuide {

    private List<Bitmap> bitmap;


    public void createView(View view,Context context,Resources res){
        ViewParent parent = view.getParent();

        ImageView image =new ImageView(context); //橙色按钮
        Bitmap orange_button_bitmap = BitmapFactory.decodeResource(res, R.drawable.orange_button);
        image.setImageBitmap(orange_button_bitmap);




        ImageView white_line =new ImageView(context); //白条
        Bitmap white_line_bitmap = BitmapFactory.decodeResource(res, R.drawable.orange_button);
        white_line.setImageBitmap(white_line_bitmap);




        ImageView right_top_point =new ImageView(context); //右上箭头
        Bitmap right_top_bitmap = BitmapFactory.decodeResource(res, R.drawable.orange_button);

        image.setImageBitmap(right_top_bitmap);

    }

}
