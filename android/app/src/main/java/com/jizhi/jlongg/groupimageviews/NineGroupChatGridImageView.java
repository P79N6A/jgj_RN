package com.jizhi.jlongg.groupimageviews;

import android.content.Context;
import android.content.res.TypedArray;
import android.support.v4.content.ContextCompat;
import android.text.TextUtils;
import android.util.AttributeSet;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;

import com.hcs.uclient.utils.DensityUtils;
import com.hcs.uclient.utils.UtilImageLoader;
import com.hcs.uclient.utils.Utils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.jizhi.jongg.widget.HashCodeGenerateText;
import com.nostra13.universalimageloader.core.ImageLoader;

import java.util.List;

/**
 * 功能: 九宫格 群聊头像
 * 作者：xuj
 * 时间:2018年1月26日9:38:35
 */
public class NineGroupChatGridImageView<T> extends ViewGroup {

    private int mRowCount; //行数
    private int mColumnCount;  //列数
    private int mMaxSize = 9;  //最大图片数
    private int mGap; //图片宫格间距
    private int parentWidth;//父组件宽
    private int parentHeight;//父组件高
    private boolean isSquareParent; //父控件是否为正方形

    private List<T> mImgDataList; //图片数据

    public NineGroupChatGridImageView(Context context) {
        this(context, null);
    }

    public NineGroupChatGridImageView(Context context, AttributeSet attrs) {
        this(context, attrs, 0);
    }

    public NineGroupChatGridImageView(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        TypedArray typedArray = context.obtainStyledAttributes(attrs, R.styleable.NineGridImageView);
        this.mGap = (int) typedArray.getDimension(R.styleable.NineGridImageView_imgGap, DensityUtils.dp2px(context, 2));
        this.isSquareParent = (boolean) typedArray.getBoolean(R.styleable.NineGridImageView_isSquare, false);
        typedArray.recycle();
    }


    /**
     * 设定宽高
     *
     * @param widthMeasureSpec
     * @param heightMeasureSpec
     */
    @Override
    protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
        super.onMeasure(widthMeasureSpec, heightMeasureSpec);
        parentWidth = measureWidth(widthMeasureSpec);
        parentHeight = isSquareParent ? parentWidth : measureHeight(heightMeasureSpec);
        setMeasuredDimension(parentWidth, parentHeight);
        int childCount = getChildCount();
        if (childCount > 0) {
            for (int i = 0; i < childCount; i++) {
                int mImageSize = (parentWidth - (mColumnCount + 1) * mGap) / mColumnCount;//图片尺寸
                LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(mImageSize, mImageSize);
                getChildAt(i).setLayoutParams(params);
                measureChild(getChildAt(i), widthMeasureSpec, heightMeasureSpec);
            }
        }
    }

    @Override
    protected void onLayout(boolean changed, int l, int t, int r, int b) {
        layoutChildrenView();
    }

    /**
     * 为子ImageView布局
     */
    private void layoutChildrenView() {
        if (mImgDataList == null) {
            return;
        }
        int childrenCount = mImgDataList.size();
        for (int i = 0; i < childrenCount; i++) {
            View childrenView = getChildAt(i);
            int rowNum = i / mColumnCount;//当前行数
            int columnNum = i % mColumnCount;//当前列数

            int mImageSize = (parentWidth - (mColumnCount + 1) * mGap) / mColumnCount;//图片尺寸

            int t_center = (parentHeight + mGap) / 2;//中间位置以下的顶点（有宫格间距）
            int b_center = (parentHeight - mGap) / 2;//中间位置以上的底部（有宫格间距）
            int l_center = (parentWidth + mGap) / 2;//中间位置以右的左部（有宫格间距）
            int r_center = (parentWidth - mGap) / 2;//中间位置以左的右部（有宫格间距）
            int center = (parentHeight - mImageSize) / 2;//中间位置以上顶部（无宫格间距）

            int left = mImageSize * columnNum + mGap * (columnNum + 1);
            int top = mImageSize * rowNum + mGap * (rowNum + 1);
            int right = left + mImageSize;
            int bottom = top + mImageSize;

            /**
             * 不同子view情况下的不同显示
             */
            if (childrenCount == 1) {
                childrenView.layout(left, top, right, bottom);
            } else if (childrenCount == 2) {
                childrenView.layout(left, center, right, center + mImageSize);
            } else if (childrenCount == 3) {
                if (i == 0) {
                    childrenView.layout(center, top, center + mImageSize, bottom);
                } else {
                    childrenView.layout(mGap * i + mImageSize * (i - 1), t_center, mGap * i + mImageSize * i, t_center + mImageSize);
                }
            } else if (childrenCount == 4) {
                childrenView.layout(left, top, right, bottom);
            } else if (childrenCount == 5) {
                if (i == 0) {
                    childrenView.layout(r_center - mImageSize, r_center - mImageSize, r_center, r_center);
                } else if (i == 1) {
                    childrenView.layout(l_center, r_center - mImageSize, l_center + mImageSize, r_center);
                } else {
                    childrenView.layout(mGap * (i - 1) + mImageSize * (i - 2), t_center, mGap * (i - 1) + mImageSize * (i - 1), t_center + mImageSize);
                }
            } else if (childrenCount == 6) {
                if (i < 3) {
                    childrenView.layout(mGap * (i + 1) + mImageSize * i, b_center - mImageSize, mGap * (i + 1) + mImageSize * (i + 1), b_center);
                } else {
                    childrenView.layout(mGap * (i - 2) + mImageSize * (i - 3), t_center, mGap * (i - 2) + mImageSize * (i - 2), t_center + mImageSize);
                }
            } else if (childrenCount == 7) {
                if (i == 0) {
                    childrenView.layout(center, mGap, center + mImageSize, mGap + mImageSize);
                } else if (i > 0 && i < 4) {
                    childrenView.layout(mGap * i + mImageSize * (i - 1), center, mGap * i + mImageSize * i, center + mImageSize);
                } else {
                    childrenView.layout(mGap * (i - 3) + mImageSize * (i - 4), t_center + mImageSize / 2, mGap * (i - 3) + mImageSize * (i - 3), t_center + mImageSize / 2 + mImageSize);
                }
            } else if (childrenCount == 8) {
                if (i == 0) {
                    childrenView.layout(r_center - mImageSize, mGap, r_center, mGap + mImageSize);
                } else if (i == 1) {
                    childrenView.layout(l_center, mGap, l_center + mImageSize, mGap + mImageSize);
                } else if (i > 1 && i < 5) {
                    childrenView.layout(mGap * (i - 1) + mImageSize * (i - 2), center, mGap * (i - 1) + mImageSize * (i - 1), center + mImageSize);
                } else {
                    childrenView.layout(mGap * (i - 4) + mImageSize * (i - 5), t_center + mImageSize / 2, mGap * (i - 4) + mImageSize * (i - 4), t_center + mImageSize / 2 + mImageSize);
                }
            } else if (childrenCount == 9) {
                childrenView.layout(left, top, right, bottom);
            }
            String headPath = (String) mImgDataList.get(i);
            if (TextUtils.isEmpty(headPath)) {
                headPath = "";
            }
            int textSize = 0;
            switch (getChildCount()) {
                case 1:
                    textSize = 11;
                    break;
                case 2:
                case 3:
                case 4:
                    textSize = 11;
                    break;
                case 5:
                case 6:
                case 7:
                case 8:
                case 9:
                    textSize = 8;
                    break;
            }
            if (childrenView instanceof HashCodeGenerateText && !TextUtils.isEmpty(headPath) && headPath.contains("real_name=")) {
                String realName = headPath.substring(headPath.indexOf("real_name=") + "real_name=".length());
                if (!TextUtils.isEmpty(realName) && realName.length() > 0) {
                    String firstName = null;
                    if (childrenCount == 1 && realName.length() >= 2) {
                        firstName = realName.substring(realName.length() - 2, realName.length()); //取字体的最后二个字
                    } else {
                        firstName = realName.substring(realName.length() - 1, realName.length()); //取字体的最后一个字
                    }
                    HashCodeGenerateText hashCodeGenerateText = (HashCodeGenerateText) childrenView;
                    hashCodeGenerateText.setTextSize(textSize);
                    hashCodeGenerateText.setGravity(Gravity.CENTER);
                    hashCodeGenerateText.accordingHashCodeSetBackgroundAndTextString(firstName);
                }
            } else if (childrenView instanceof ImageView) {
                ImageView imageView = (ImageView) childrenView;
                if (imageView.getTag() != null && imageView.getTag().equals(headPath + i)) {
                } else { // 如果不相同，就加载。现在在这里来改变闪烁的情况
                    ImageLoader.getInstance().displayImage(NetWorkRequest.IP_ADDRESS + headPath, imageView, UtilImageLoader.getRectangleHead(getContext()));
                    imageView.setTag(headPath + i);
                }
            }
        }
    }

    /**
     * 设置图片数据
     *
     * @param lists 图片数据集合
     */
    public void setImagesData(List lists) {
        if (lists == null || lists.isEmpty()) {
            setVisibility(GONE);
            return;
        } else {
            setVisibility(VISIBLE);
        }
        if (lists.size() > 1) {
            Utils.setBackGround(this, getResources().getDrawable(R.drawable.bg_rd_d8d9e6_2radius));
        } else {
            Utils.setBackGround(this, null);
        }
        if (lists.size() > mMaxSize) { //不能超过图片的最大数
            lists = lists.subList(0, mMaxSize);
        }
        int[] gridParam = calculateGridParam(lists.size());
        mRowCount = gridParam[0];
        mColumnCount = gridParam[1];

        if (getChildCount() > 0) {
            removeAllViews();
        }

        int i = 0;
        while (i < lists.size()) {
            String headPath = (String) lists.get(i);
            if (TextUtils.isEmpty(headPath)) {
                headPath = "";
            }
            View view = generateView(headPath, i);
            if (view == null) {
                return;
            }
            addView(view);
            i++;
        }
        mImgDataList = lists;
        requestLayout();
    }

    /**
     * 设置宫格参数
     *
     * @param imagesSize 图片数量
     * @return 宫格参数 gridParam[0] 宫格行数 gridParam[1] 宫格列数
     */
    protected int[] calculateGridParam(int imagesSize) {
        int[] gridParam = new int[2];
        if (imagesSize < 3) {
            gridParam[0] = 1;
            gridParam[1] = imagesSize;
        } else if (imagesSize <= 4) {
            gridParam[0] = 2;
            gridParam[1] = 2;
        } else {
            gridParam[0] = imagesSize / 3 + (imagesSize % 3 == 0 ? 0 : 1);
            gridParam[1] = 3;
        }
        return gridParam;
    }

    /**
     * 设置宫格间距
     *
     * @param gap 宫格间距 px
     */
    public void setGap(int gap) {
        mGap = gap;
    }

    /**
     * 对宫格的宽高进行重新定义
     */
    private int measureWidth(int measureSpec) {
        int result;
        int specMode = MeasureSpec.getMode(measureSpec);
        int specSize = MeasureSpec.getSize(measureSpec);
        if (specMode == MeasureSpec.EXACTLY) {
            result = specSize;
        } else {
            result = 200;
            if (specMode == MeasureSpec.AT_MOST) {
                result = Math.min(result, specSize);
            }
        }
        return result;
    }

    private int measureHeight(int measureSpec) {
        int result;

        int specMode = MeasureSpec.getMode(measureSpec);
        int specSize = MeasureSpec.getSize(measureSpec);

        if (specMode == MeasureSpec.EXACTLY) {
            result = specSize;
        } else {
            result = 200;
            if (specMode == MeasureSpec.AT_MOST) {
                result = Math.min(result, specSize);
            }
        }
        return result;
    }

    /**
     * 生成图片
     *
     * @param headPic
     * @param position
     */
    public View generateImageView(String headPic, int position) {
        if (TextUtils.isEmpty(headPic)) {
            headPic = "";
        }
        ImageView imageView = new ImageView(getContext());
        imageView.setScaleType(ImageView.ScaleType.CENTER_CROP);
        if (imageView.getTag() != null && imageView.getTag().equals(headPic + position)) {
        } else { // 如果不相同，就加载。现在在这里来改变闪烁的情况
            ImageLoader.getInstance().displayImage(NetWorkRequest.IP_ADDRESS + headPic, imageView, UtilImageLoader.getRectangleHead(getContext()));
            imageView.setTag(headPic + position);
        }
        return imageView;
    }

    /**
     * 生成HashCode  字符
     */
    public View generateHashCodeTextView() {
        HashCodeGenerateText hashCodeGenerateText = new HashCodeGenerateText(getContext());
        hashCodeGenerateText.setTextColor(ContextCompat.getColor(getContext(), R.color.white));
        return hashCodeGenerateText;
    }


    public View generateView(String headPic, int position) {
        if (!TextUtils.isEmpty(headPic) && !headPic.contains("headpic_m") && !headPic.contains("headpic_f") && !headPic.contains("nopic=1")) {
            return generateImageView(headPic, position);
        } else {
            return generateHashCodeTextView();
        }
    }

}
