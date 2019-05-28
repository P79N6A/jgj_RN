package com.jizhi.jongg.widget;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.res.TypedArray;
import android.graphics.Bitmap;
import android.util.AttributeSet;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.ImageView;
import android.widget.LinearLayout;
import com.hcs.uclient.utils.DensityUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.util.ReleaseBitmap;
import java.util.ArrayList;
import java.util.List;

@SuppressLint("NewApi")
public class MyRattingBar extends LinearLayout implements OnClickListener {

	/** 星星个数 */
	private int star_number = 5;

	private List<ImageView> images = new ArrayList<ImageView>();

	private int before;
	
	private boolean isClick = false;
	
	private int star_width;
	
	private int star_height;
	
	private int star_margin;
	
	private ClickStar listener;
	
	private List<Bitmap> bitmapList;
	

	

	public MyRattingBar(Context context) {
		super(context);
		createStar(context);
	}

	public MyRattingBar(Context context, AttributeSet attrs, int defStyle) {
		super(context, attrs, defStyle);
		createStar(context);
	}

	public MyRattingBar(Context context, AttributeSet attrs) {
		super(context, attrs);
		TypedArray array = context.obtainStyledAttributes(attrs,R.styleable.MyRattingBar);
		isClick = array.getBoolean(R.styleable.MyRattingBar_isClick,false);
		star_width = array.getDimensionPixelSize(R.styleable.MyRattingBar_star_width,(int) getResources().getDimension(R.dimen.x14));
		star_height = array.getDimensionPixelSize(R.styleable.MyRattingBar_star_height,(int)getResources().getDimension(R.dimen.y12));
		star_margin = array.getDimensionPixelSize(R.styleable.MyRattingBar_star_margin,DensityUtils.dp2px(context,10));
		array.recycle();
		createStar(context);
	}
	
	
	public void setListener(ClickStar listener){
		this.listener = listener;
	}

	/***
	 * 创建星星
	 * 
	 * @param context
	 */
	public void createStar(Context context) {
//		int padding = DensityUtils.dp2px(context,5);
//		for (int i = 0; i < star_number; i++) {
//			LinearLayout line = new LinearLayout(context);
//			LinearLayout.LayoutParams line_params = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.WRAP_CONTENT,LinearLayout.LayoutParams.WRAP_CONTENT);
//			line.setPadding(line.getPaddingLeft(),line.getPaddingTop()+padding,line.getPaddingRight()+star_margin,line.getPaddingBottom()+padding);
//			line.setLayoutParams(line_params);
//			line.setGravity(Gravity.CENTER);
//			LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(star_width,star_height);
//			if(bitmapList == null){
//				bitmapList = new ArrayList<Bitmap>();
//			}
//			ImageView image = new ImageView(context);
//			Bitmap bitmap = BitmapFactory.decodeResource(getResources(),R.drawable.star_normal);
//			image.setImageBitmap(bitmap);
//			bitmapList.add(bitmap);
//			image.setLayoutParams(params);
//			line.setId(i+1);
//			if(isClick){
//				line.setOnClickListener(this);
//			}
//			images.add(image);
//			line.addView(image);
//			addView(line);
//		}
	}


	/**
	 * 设置星星等级
	 * @param grade
	 */
	public void setStarGrade(int grade) {
//		if(grade == before){
//			return;
//		}
//		before = grade;
//		List<Bitmap> tempList = new ArrayList<Bitmap>();
//		for (int j = 0; j < 5; j++) {
//			ImageView image = images.get(j);
//			Bitmap bitmap = null;
//			if(j<before){
//				 bitmap = BitmapFactory.decodeResource(getResources(),R.drawable.star_press);
//			}else{
//				 bitmap = BitmapFactory.decodeResource(getResources(),R.drawable.star_normal);
//			}
//			image.setImageBitmap(bitmap);
//			tempList.add(bitmap);
//		}
//		recycle();
//		bitmapList.clear();
//		bitmapList.addAll(tempList);
//		tempList = null;
	}

	@Override
	public void onClick(View v) {
//		if(v.getId() == before){
//			return;
//		}
//		switch (v.getId()) {
//		case 1:
//			before = 1;
//			break;
//		case 2:
//			before = 2;
//			break;
//		case 3:
//			before = 3;
//			break;
//		case 4:
//			before = 4;
//			break;
//		case 5:
//			before = 5;
//			break;
//		default:
//			break;
//		}
//		List<Bitmap> tempList = new ArrayList<Bitmap>();
//		for (int j = 0; j < 5; j++) {
//			ImageView image = images.get(j);
//			Bitmap bitmap = null;
//			if(j<before){
//				 bitmap = BitmapFactory.decodeResource(getResources(),R.drawable.star_press);
//			}else{
//				 bitmap = BitmapFactory.decodeResource(getResources(),R.drawable.star_normal);
//			}
//			image.setImageBitmap(bitmap);
//			tempList.add(bitmap);
//		}
//		recycle();
//		bitmapList.clear();
//		bitmapList.addAll(tempList);
//		tempList = null;
//		if(listener!=null){
//			listener.click(this,before);
//		}
	}
	
	
	public interface ClickStar{
		void click(View view, int grade);
	}

	/**
	 * 获取星星分数
	 * @return
	 */
	public int getGrade() {
		return before;
	}



	public void recycle(){
		ReleaseBitmap.recycle(bitmapList);
	}
	
	
	
	

}
