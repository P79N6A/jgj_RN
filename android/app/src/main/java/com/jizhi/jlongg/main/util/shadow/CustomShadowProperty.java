package com.jizhi.jlongg.main.util.shadow;
/**
 * Created by Administrator on 2017/5/5 0005.
 */

public class CustomShadowProperty {
    private int shadowColor;
    private int shadowRadius;
    private int shadowDx;
    private int shadowDy;
    private int background;

    public CustomShadowProperty() {
    }

    public int getShadowOffset() {
        return this.getShadowOffsetHalf() * 2;
    }

    public int getShadowOffsetHalf() {
        return 0 >= this.shadowRadius ? 0 : Math.max(this.shadowDx, this.shadowDy) + this.shadowRadius;
    }

    public int getShadowColor() {
        return this.shadowColor;
    }

    public CustomShadowProperty setShadowColor(int shadowColor) {
        this.shadowColor = shadowColor;
        return this;
    }

    public int getShadowRadius() {
        return this.shadowRadius;
    }

    public CustomShadowProperty setShadowRadius(int shadowRadius) {
        this.shadowRadius = shadowRadius;
        return this;
    }

    public int getShadowDx() {
        return this.shadowDx;
    }

    public CustomShadowProperty setShadowDx(int shadowDx) {
        this.shadowDx = shadowDx;
        return this;
    }

    public int getShadowDy() {
        return this.shadowDy;
    }

    public CustomShadowProperty setShadowDy(int shadowDy) {
        this.shadowDy = shadowDy;
        return this;
    }

    public int getBackground() {
        return background;
    }

    public CustomShadowProperty setBackground(int background) {
        this.background = background;
        return this;
    }


}
