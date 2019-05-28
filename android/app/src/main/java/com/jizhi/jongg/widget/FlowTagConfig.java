package com.jizhi.jongg.widget;

/**
 * Created by Administrator on 2018-4-27.
 */

import android.content.Context;
import android.content.res.TypedArray;
import android.util.AttributeSet;

import com.jizhi.jlongg.R;


/**
 * Description:
 * User: chenzheng
 * Date: 2017/2/17 0017
 * Time: 10:23
 */
public class FlowTagConfig {

    private static final int DEFAULT_LINE_SPACING = 5;//默认行间距
    private static final int DEFAULT_TAG_SPACING = 10;//各个标签之间的默认距离
    private static final int DEFAULT_FIXED_COLUMN_SIZE = 3; //默认列数

    private int lineSpacing;
    private int tagSpacing;
    private int columnSize;
    private boolean isFixed;

    public FlowTagConfig(Context context, AttributeSet attrs) {
        TypedArray a = context.obtainStyledAttributes(attrs, R.styleable.FlowTagView);
        try {
            lineSpacing = a.getDimensionPixelSize(R.styleable.FlowTagView_lineSpacing, DEFAULT_LINE_SPACING);
            tagSpacing = a.getDimensionPixelSize(R.styleable.FlowTagView_tagSpacing, DEFAULT_TAG_SPACING);
            columnSize = a.getInteger(R.styleable.FlowTagView_columnSize, DEFAULT_FIXED_COLUMN_SIZE);
            isFixed = a.getBoolean(R.styleable.FlowTagView_isFixed, false);
        } finally {
            a.recycle();
        }
    }

    public int getLineSpacing() {
        return lineSpacing;
    }

    public void setLineSpacing(int lineSpacing) {
        this.lineSpacing = lineSpacing;
    }

    public int getTagSpacing() {
        return tagSpacing;
    }

    public void setTagSpacing(int tagSpacing) {
        this.tagSpacing = tagSpacing;
    }

    public int getColumnSize() {
        return columnSize;
    }

    public void setColumnSize(int columnSize) {
        this.columnSize = columnSize;
    }

    public boolean isFixed() {
        return isFixed;
    }

    public void setIsFixed(boolean isFixed) {
        this.isFixed = isFixed;
    }
}
