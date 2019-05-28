package com.jizhi.jongg.widget;

import android.content.Context;
import android.graphics.Color;
import android.graphics.drawable.GradientDrawable;
import android.util.AttributeSet;
import android.widget.TextView;

import com.hcs.uclient.utils.Utils;


/**
 * 根据HashCode生成对应的文本颜色
 */
public class HashCodeGenerateText extends TextView {

    /* hasCode 颜色码 */
    private static final String[] headColorArr = new String[]{"#e6884f", "#ffae2f", "#99bb4f",
            "#56c2c5", "#62b1da", "#5990d4", "#7266ca", "#bf67cf",
            "#da63af", "#df5e5e"};


    /* 是否需要宽高相当 */
    private boolean isQuare = true;

    public HashCodeGenerateText(Context context) {
        super(context);
    }

    public HashCodeGenerateText(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    public HashCodeGenerateText(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
    }

    @Override
    protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
        super.onMeasure(widthMeasureSpec, heightMeasureSpec);
        if (isQuare) {
            setMeasuredDimension(getMeasuredWidth(), getMeasuredWidth());
        }
    }


    public void setQuare(boolean quare) {
        isQuare = quare;
        requestLayout();
    }

    /**
     * 根据HashCode码来设置颜色
     *
     * @param realName
     */
    public void accordingHashCodeSetBackgroundAndTextString(String realName) {
        setText(realName);
        GradientDrawable shape = new GradientDrawable();
        shape.setShape(GradientDrawable.RECTANGLE);
        shape.setColor(Color.parseColor(getHashCodeBackground(realName)));
        Utils.setBackGround(this, shape);
    }

    /**
     * 根据HashCode码来设置颜色
     *
     * @param realName
     */
    public void accordingHashCodeSetBackground(String realName) {
        GradientDrawable shape = new GradientDrawable();
//        shape.setCornerRadius(getContext().getResources().getDimension(R.dimen.rect_radius));
        shape.setShape(GradientDrawable.RECTANGLE);
        shape.setColor(Color.parseColor(getHashCodeBackground(realName)));
        Utils.setBackGround(this, shape);
    }

    public int getHashCode(String realName) {
        if (realName == null || realName.length() == 0) {
            return 0;
        }
        int hash = 1315423911, i;
        char ch;
        realName = realName.substring(realName.length() - 1);
        for (i = realName.length() - 1; i >= 0; i--) {
            ch = realName.charAt(0);
            hash ^= ((hash << 5) + ch + (hash >> 2));
        }
        return (hash & 0x7FFFFFFF);
    }

    public String getHashCodeBackground(String realName) {
        try {
//            String hashCode = getHashCode(realName) + "";
//            char ch = hashCode.charAt(hashCode.length() - 1);
//            int c = (int) ch;
//            c -= 48;
//            return headColorArr[c];

            int ch = realName.charAt(realName.length() - 1);
            String caluterString = ch + "";
            int arrayIndex = Integer.parseInt(caluterString.substring(caluterString.length() - 1));
            return headColorArr[arrayIndex];

        } catch (Exception e) {
            e.printStackTrace();
            return headColorArr[0];
        }
    }
}
