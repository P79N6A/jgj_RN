package com.hcs.cityslist.widget;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.res.TypedArray;
import android.text.InputFilter;
import android.text.Spanned;
import android.util.AttributeSet;
import android.widget.EditText;
import android.widget.TextView;

import com.hcs.uclient.utils.LUtils;
import com.jizhi.jlongg.R;

import java.lang.reflect.Field;

/**
 * 右侧有删除图片的EditText
 *
 * @author huChangSheng
 * @version 1.0
 * @time 2015-11-19 上午11:02:11
 */
public class AppCursorEditText extends EditText {
    /**
     * 保留小数点前多少位
     */
    private int mDecimalStarNumber = 0;

    /**
     * 保留小数点后多少位，默认两位
     */
    private int mDecimalEndNumber = 0 ;

    public AppCursorEditText(Context context) {
        this(context, null);
    }

    public AppCursorEditText(Context context, AttributeSet attrs) {
        //这里构造方法也很重要，不加这个很多属性不能再XML里面定义
        this(context, attrs, android.R.attr.editTextStyle);
    }

    public AppCursorEditText(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
        @SuppressLint("CustomViewStyleable")
        TypedArray typedArray = context.obtainStyledAttributes(attrs, R.styleable.AppCursorEditText);

        mDecimalStarNumber = typedArray.getInt(R.styleable.AppCursorEditText_decimalStarNumber, 0);
        mDecimalEndNumber = typedArray.getInt(R.styleable.AppCursorEditText_decimalEndNumber, 0);
        init();
        if(mDecimalStarNumber!=0&&mDecimalEndNumber!=0){
            initInputFilter();
        }
        typedArray.recycle();

    }


    private void init() {
        Field f = null;
        try {
            f = TextView.class.getDeclaredField("mCursorDrawableRes");
            f.setAccessible(true);
            f.set(this, R.drawable.color_cursor);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    /**
     * 初始化
     */
    private void initInputFilter() {
        setFilters(new InputFilter[]{new InputFilter() {
            @Override
            public CharSequence filter(CharSequence source, int start, int end, Spanned dest, int dstart, int dend) {
                String lastInputContent = dest.toString();

//                LUtils.d("source->" + source + "--start->" + start + " " +
//                        "--lastInputContent->" + lastInputContent + "--dstart->" + dstart + "--dend->" + dend);


                if (source.equals(".") && lastInputContent.length() == 0) {
                    return "0.";
                }

                if (!source.equals(".") && !source.equals("") && lastInputContent.equals("0")) {
                    return ".";
                }

                if (source.equals(".") && lastInputContent.contains(".")) {
                    return "";
                }

                if (lastInputContent.contains(".")) {
                    int index = lastInputContent.indexOf(".");
                    if (dend - index >= mDecimalEndNumber + 1) {
                        return "";
                    }
                } else {
                    if (!source.equals(".") && lastInputContent.length() >= mDecimalStarNumber) {
                        return "";
                    }
                }

                return null;
            }
        }});
    }


    public int getDecimalStarNumber() {
        return mDecimalStarNumber;
    }

    public void setDecimalStarNumber(int decimalStarNumber) {
        mDecimalStarNumber = decimalStarNumber;
    }

    public int getDecimalEndNumber() {
        return mDecimalEndNumber;
    }

    public void setDecimalEndNumber(int decimalEndNumber) {
        mDecimalEndNumber = decimalEndNumber;
    }
}
