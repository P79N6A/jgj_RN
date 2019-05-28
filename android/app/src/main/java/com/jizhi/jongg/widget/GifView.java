package com.jizhi.jongg.widget;


import android.annotation.SuppressLint;
import android.content.Context;
import android.content.res.TypedArray;
import android.graphics.Canvas;
import android.graphics.Movie;
import android.os.Build;
import android.util.AttributeSet;
import android.view.View;

import com.jizhi.jlongg.R;


public class GifView extends View {

    /**
     * Gif播放总次数
     */
    private int playCount = 2;
    /**
     * Gif记数器
     */
    private int playNumberCount = -1;
    /**
     * 默认为1秒
     */
    private static final int DEFAULT_MOVIE_DURATION = 1000;

    private int mMovieResourceId;

    private Movie mMovie;

    private long mMovieStart;

    private int mCurrentAnimationTime = 0;

    private float mScale = 1.0F;

    private boolean mVisible = true;

    private volatile boolean mPaused = false;
    /**
     * 播放完毕回调
     */
    private PlayGifCompleteListener playCompleteListener;

    public GifView(Context context) {
        this(context, null);
    }

    public GifView(Context context, AttributeSet attrs) {
        this(context, attrs, R.styleable.CustomTheme_gifViewStyle);
    }

    public GifView(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
        setViewAttributes(context, attrs, defStyle);
    }

    @SuppressLint("NewApi")
    private void setViewAttributes(Context context, AttributeSet attrs, int defStyle) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB) {
            setLayerType(View.LAYER_TYPE_SOFTWARE, null);
        }
        // 从描述文件中读出gif的值，创建出Movie实例
        final TypedArray array = context.obtainStyledAttributes(attrs, R.styleable.GifView);
        mMovieResourceId = array.getResourceId(R.styleable.GifView_gifs, -1);
        mPaused = array.getBoolean(R.styleable.GifView_pauseds, false);
        array.recycle();
        if (mMovieResourceId != -1) {
            mMovie = Movie.decodeStream(getResources().openRawResource(
                    mMovieResourceId));
        }
    }

    /**
     * 设置gif图资源
     *
     * @param movieResId
     */
    public void setMovieResource(int movieResId) {
        this.mMovieResourceId = movieResId;
        mMovie = Movie.decodeStream(getResources().openRawResource(mMovieResourceId));
        requestLayout();
    }

    public void setMovie(Movie movie) {
        this.mMovie = movie;
        requestLayout();
    }

    public Movie getMovie() {
        return mMovie;
    }

    public void setMovieTime(int time) {
        mCurrentAnimationTime = time;
        invalidate();
    }

    /**
     * 设置暂停
     *
     * @param paused
     */
    public void setPaused(boolean paused) {
        this.mPaused = paused;
        if (!paused) {
            mMovieStart = android.os.SystemClock.uptimeMillis()
                    - mCurrentAnimationTime;
        }
        invalidate();
    }

    /**
     * 判断gif图是否停止了
     *
     * @return
     */
    public boolean isPaused() {
        return this.mPaused;
    }

    @Override
    protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
        if (mMovie != null) {
            int movieWidth = mMovie.width();
            int movieHeight = mMovie.height();
            setMeasuredDimension(movieWidth, movieHeight);
        } else {
            setMeasuredDimension(getSuggestedMinimumWidth(), getSuggestedMinimumHeight());
        }
    }


    @Override
    protected void onDraw(Canvas canvas) {
        if (playNumberCount == playCount) {
            if (playCompleteListener != null) {
                playCompleteListener.playComplete();
            }
            return;
        }
        if (mMovie != null) {
            if (!mPaused) {
                updateAnimationTime(canvas);
                drawMovieFrame(canvas);
                invalidateView();
            } else {
                drawMovieFrame(canvas);
            }
        }
    }

    @SuppressLint("NewApi")
    private void invalidateView() {
        if (mVisible) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN) {
                postInvalidateOnAnimation();
            } else {
                invalidate();
            }
        }
    }

    private void updateAnimationTime(Canvas canvas) {
        long now = android.os.SystemClock.uptimeMillis();
        // 如果第一帧，记录起始时间
        if (mMovieStart == 0) {
            mMovieStart = now;
        }
        // 取出动画的时长
        int duration = mMovie.duration();
        if (duration == 0) {
            duration = DEFAULT_MOVIE_DURATION;
        }
        // 算出需要显示第几帧
        mCurrentAnimationTime = (int) ((now - mMovieStart) % duration);
        // 设置要显示的帧，绘制即可
        mMovie.setTime(mCurrentAnimationTime);
        canvas.save();
//        canvas.save(Canvas.MATRIX_SAVE_FLAG);
        canvas.scale(mScale, mScale);
        mMovie.draw(canvas, 0, 0);
        canvas.restore();
        if ((now - mMovieStart) >= duration) {
            mMovieStart = 0;
            playNumberCount += 1;
        }
    }

    private void drawMovieFrame(Canvas canvas) {


    }

    @SuppressLint("NewApi")
    @Override
    public void onScreenStateChanged(int screenState) {
        super.onScreenStateChanged(screenState);
        mVisible = screenState == SCREEN_STATE_ON;
        invalidateView();
    }

    @SuppressLint("NewApi")
    @Override
    protected void onVisibilityChanged(View changedView, int visibility) {
        super.onVisibilityChanged(changedView, visibility);
        mVisible = visibility == View.VISIBLE;
        invalidateView();
    }

    @Override
    protected void onWindowVisibilityChanged(int visibility) {
        super.onWindowVisibilityChanged(visibility);
        mVisible = visibility == View.VISIBLE;
        invalidateView();
    }

    public PlayGifCompleteListener getPlayCompleteListener() {
        return playCompleteListener;
    }

    public void setPlayCompleteListener(PlayGifCompleteListener playCompleteListener) {
        this.playCompleteListener = playCompleteListener;
    }

    public interface PlayGifCompleteListener {
        public void playComplete();
    }

}
