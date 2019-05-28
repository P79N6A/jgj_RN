package com.jizhi.jlongg.main.message;

import android.graphics.Color;

/**
 * Created by cxm on 2016/9/27.
 */

public class TipItem {

    private String title;

    private int textColor = Color.WHITE;

    public TipItem(String title) {
        this.title = title;
    }

    public TipItem(String title, int textColor) {
        this.title = title;

        this.textColor = textColor;
    }

    public String getTitle() {
        return title;
    }

    public int getTextColor() {
        return textColor;
    }

    public void setTextColor(int textColor) {
        this.textColor = textColor;
    }

    public void setTitle(String title) {
        this.title = title;
    }
}
