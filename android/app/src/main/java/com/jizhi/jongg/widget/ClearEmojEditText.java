package com.jizhi.jongg.widget;


import android.content.Context;
import android.graphics.drawable.Drawable;
import android.text.Editable;
import android.text.Selection;
import android.text.Spannable;
import android.text.TextWatcher;
import android.util.AttributeSet;
import android.view.MotionEvent;
import android.view.View;
import android.widget.EditText;
import android.widget.TextView;

import com.hcs.uclient.utils.DensityUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.emoji.emotionkeyboard.EmojiUtil;

import java.lang.reflect.Field;


public class ClearEmojEditText extends EditText implements View.OnFocusChangeListener {
    //输入表情前EditText中的文本
    private String inputAfterText;
    //是否重置了EditText的内容
    private boolean resetText;

//    /**
//     * 删除按钮的引用
//     */
//    private Drawable mClearDrawable;

    public ClearEmojEditText(Context context) {
        super(context);
        initEditText();
        initCursor();
    }

    public ClearEmojEditText(Context context, AttributeSet attrs) {
        super(context, attrs);
        initEditText();
        initCursor();
    }

    public ClearEmojEditText(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        initEditText();
        initCursor();
    }

    private void initCursor() {
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
     * 因为我们不能直接给EditText设置点击事件，所以我们用记住我们按下的位置来模拟点击事件
     * 当我们按下的位置 在  EditText的宽度 - 图标到控件右边的间距 - 图标的宽度  和
     * EditText的宽度 - 图标到控件右边的间距之间我们就算点击了图标，竖直方向没有考虑
     */
    @Override
    public boolean onTouchEvent(MotionEvent event) {
//        if (getCompoundDrawables()[2] != null) {
//            if (event.getAction() == MotionEvent.ACTION_UP) {
//                boolean touchable = event.getX() > (getWidth() - getPaddingRight() - mClearDrawable.getIntrinsicWidth()) && (event.getX() < ((getWidth() - getPaddingRight())));
//                if (touchable) {
//                    this.setText("");
//                }
//            }
//        }
        return super.onTouchEvent(event);
    }

    /**
     * 当ClearEditText焦点发生变化的时候，判断里面字符串长度设置清除图标的显示与隐藏
     */
    @Override
    public void onFocusChange(View v, boolean hasFocus) {
        if (hasFocus) {
            setClearIconVisible(getText().length() > 0);
        } else {
            setClearIconVisible(false);
        }
    }


    /**
     * 设置清除图标的显示与隐藏，调用setCompoundDrawables为EditText绘制上去
     *
     * @param visible
     */
    protected void setClearIconVisible(boolean visible) {
//        Drawable right = visible ? mClearDrawable : null;
////        setCompoundDrawables(getCompoundDrawables()[0], getCompoundDrawables()[1], right, getCompoundDrawables()[3]);
//        setCompoundDrawables(null, null, right, null);
    }


    private void setClearDrawable() {
        //获取EditText的DrawableRight,假如没有设置我们就使用默认的图片
//        mClearDrawable = getCompoundDrawables()[2];
//        if (mClearDrawable == null) {
//            mClearDrawable = getResources().getDrawable(R.drawable.emotionstore_progresscancelbtn);
//        }
//        mClearDrawable.setBounds(0, 0, mClearDrawable.getIntrinsicWidth(), mClearDrawable.getIntrinsicHeight()); //设置清除的图片
//        setCompoundDrawablePadding(DensityUtils.dp2px(getContext(), 10)); //设置文字与清除图片的距离
    }

    // 初始化edittext 控件
    private void initEditText() {
        addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int before, int count) {
                if (!resetText) {
                    // 这里用s.toString()而不直接用s是因为如果用s，
                    // 那么，inputAfterText和s在内存中指向的是同一个地址，s改变了，
                    // inputAfterText也就改变了，那么表情过滤就失败了
                    inputAfterText = s.toString();
                }
            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                setClearIconVisible(s.length() > 0);
                if (!resetText) {
                    if (count - before >= 2) {//表情符号的字符长度最小为2
                        CharSequence input = s.subSequence(start + before, start + count);
                        if (EmojiUtil.containsEmoji(input.toString())) {
                            resetText = true;
//                            Toast.makeText(mContext, "不支持输入Emoji表情符号", Toast.LENGTH_SHORT).show();
                            //是表情符号就将文本还原为输入表情符号之前的内容
                            setText(inputAfterText);
                            CharSequence text = getText();
                            if (text instanceof Spannable) {
                                Spannable spanText = (Spannable) text;
                                Selection.setSelection(spanText, text.length());
                            }
                        }
                    }
                } else {
                    resetText = false;
                }
            }

            @Override
            public void afterTextChanged(Editable editable) {

            }
        });
//        setClearDrawable();
    }


    @Override
    protected void onLayout(boolean changed, int left, int top, int right, int bottom) {
        super.onLayout(changed, left, top, right, bottom);
//        setPadding(getPaddingLeft(), 0, DensityUtils.dp2px(getContext(), 10), 0);
    }


}

