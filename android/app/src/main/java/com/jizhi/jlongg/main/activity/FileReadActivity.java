package com.jizhi.jlongg.main.activity;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.text.TextUtils;
import android.view.View;
import android.view.animation.Animation;
import android.webkit.WebView;
import android.widget.TextView;

import com.hcs.uclient.utils.DensityUtils;
import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.StrUtil;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.Repository;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.FR;
import com.jizhi.jlongg.main.util.RepositoryUtil;
import com.jizhi.jlongg.main.util.ResizeAnimation;
import com.jizhi.jlongg.main.util.ShareUtil;
import com.jizhi.jlongg.main.util.ThreadPoolUtils;
import com.jizhi.jlongg.main.util.cloud.CloudUtil;
import com.umeng.analytics.MobclickAgent;

import java.io.File;

/**
 * 功能: 加载doc、docx、xls、xlsx
 * 作者：xuj
 * 时间: 2017年4月11日16:04:12
 */
public class FileReadActivity extends BaseActivity implements View.OnClickListener {
    /**
     * 知识库文件内容
     */
    private Repository repository;
    /**
     * 收藏文本
     */
    private TextView collectionTxt;
    /**
     * 腾讯X5浏览器
     */
    private WebView webView;

    private final int FILE_RESOLUTION_FAIL = 0; //文件解析失败
    private final int FILE_LOAD_SUCCESS = 1; //文件加载成功
    private final int HIDE_CAN_NOT_OPEN_TEXT_TIPS = 2; //隐藏文件打不开的文本提示


    /**
     * 启动当前Activity
     *
     * @param context
     * @param filePath   文件路径
     * @param fileName   文件名称
     * @param repository 文件内容
     * @param fileType   文件类型
     */
    public static void actionStart(Activity context, String filePath, String fileName, String fileType, Repository repository) {
        Intent intent = new Intent(context, FileReadActivity.class);
        intent.putExtra("param1", filePath);
        intent.putExtra("param2", fileName);
        intent.putExtra("param3", repository);
        intent.putExtra("param4", fileType);
        context.startActivityForResult(intent, Constance.REQUEST);
    }


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.load_file);
        TextView rightTitle = getTextView(R.id.right_title);
        collectionTxt = (TextView) findViewById(R.id.collection);
        TextView title = (TextView) findViewById(R.id.title);

        webView = (WebView) findViewById(R.id.webView);
        webView.getSettings().setBuiltInZoomControls(true);
        webView.getSettings().setUseWideViewPort(true);
        webView.getSettings().setSupportZoom(true);
        webView.setInitialScale(25);

        rightTitle.setVisibility(View.VISIBLE);
        rightTitle.setOnClickListener(this);
        rightTitle.setText(R.string.more);
        /**
         * web.setInitialScale(25);//为25%，最小缩放等级
         解释：  里面的数字代表缩放等级
         web.setInitialScale(100);  代表不缩放。
         什么是不缩放?     比如你要加载的网页中有图片的宽度是 500px ，如果你的手机分辨率（屏幕宽度） 是1000的话，那么整个图片只占一半的屏幕。  其他的字体都是按照标准展示
         如果这个时候如果你设置 web.setInitialScale(200) ，代表放大一倍，真个网页都会放大一倍，这个时候图片正好展示整个屏幕宽度，另外网页的字体也会放大一倍
         如果这个时候如果你设置 web.setInitialScale(50) ，代表缩小一倍，这个时候图片正好展示只占屏幕的四分之一，另外网页的字体也会同时变小
         */
        // 创建意图 获得要显示的文件
        Intent intent = this.getIntent();
        final String filePath = intent.getStringExtra("param1");
        title.setText(StrUtil.ToDBC(StrUtil.StringFilter(intent.getStringExtra("param2"))));
        repository = (Repository) intent.getSerializableExtra("param3");
        LUtils.e("is:" + repository.isIs_show_collection_btn());
        collectionTxt.setVisibility(repository.isIs_show_collection_btn() ? View.VISIBLE : View.GONE);
        collectionTxt.setText(repository.getIs_collection() == 1 ? "取消收藏" : "收藏");
        ThreadPoolUtils.fixedThreadPool.execute(new Runnable() {
            @Override
            public void run() {
                try {
                    final FR fr = new FR(filePath);
                    Message message = Message.obtain();
                    message.obj = fr.returnPath;
                    message.what = FILE_LOAD_SUCCESS;
                    mHandler.sendMessage(message);
                } catch (Exception e) {
                    e.printStackTrace();
                    mHandler.sendEmptyMessage(FILE_RESOLUTION_FAIL);
                }
            }
        });
        ThreadPoolUtils.fixedThreadPool.execute(new Runnable() {
            @Override
            public void run() {
                try {
                    Thread.sleep(5000); //休眠5秒钟后隐藏
                    mHandler.sendEmptyMessage(HIDE_CAN_NOT_OPEN_TEXT_TIPS);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
        });
    }


    public Handler mHandler = new Handler() {
        public void handleMessage(Message msg) {
            switch (msg.what) {
                case FILE_RESOLUTION_FAIL: //文件解析失败
                    CommonMethod.makeNoticeShort(FileReadActivity.this, "文件解析失败", CommonMethod.ERROR);
                    finish();
                case FILE_LOAD_SUCCESS: //文件加载成功
                    findViewById(R.id.loadingProgressBar).setVisibility(View.GONE); //隐藏加载进度框
                    String returnPath = msg.obj.toString();
                    webView.loadUrl(returnPath);
                    break;
                case HIDE_CAN_NOT_OPEN_TEXT_TIPS:
                    hideTips();
                    break;
                default:
                    break;
            }
        }
    };


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.collection: //收藏、取消收藏
                RepositoryUtil.collectionOrCancel(repository, this, new RepositoryUtil.CollectionListener() {
                    @Override
                    public void collection() {
                        collectionTxt.setText(repository.getIs_collection() == 1 ? "取消收藏" : "收藏");
                    }
                });
                break;
            case R.id.share: //分享
                MobclickAgent.onEvent(this, "share_repository"); //U盟点击分享统计
                ShareUtil.shareFile(new File(getIntent().getExtras().getString("param1")), this);
                break;
            case R.id.right_title: //使用第三方软件打开
                String filePath = getIntent().getStringExtra("param1"); //文件的路径
                String fileType = getIntent().getStringExtra("param4"); //文件的类型
                if (TextUtils.isEmpty(fileType)) {
                    return;
                }
                switch (fileType) {
                    case CloudUtil.XLS_TAG: //打开Excel
                        CloudUtil.openExcelFileIntent(this, filePath);
                        break;
                    case CloudUtil.DOC_TAG: //打开Word
                        CloudUtil.openWordFileIntent(this, filePath);
                        break;
                }
                break;
        }
    }

    /**
     * 隐藏选中的动画
     */
    private void hideTips() {
        final TextView canNoOpenTips = (TextView) findViewById(R.id.canNoOpenTips);
        ResizeAnimation animation = new ResizeAnimation(canNoOpenTips);
        animation.setDuration(500);
        animation.setParams(DensityUtils.dp2px(getApplicationContext(), 35), 0);
        canNoOpenTips.startAnimation(animation);
        animation.setAnimationListener(new Animation.AnimationListener() {
            @Override
            public void onAnimationStart(Animation animation) {

            }

            @Override
            public void onAnimationEnd(Animation animation) {
                canNoOpenTips.setVisibility(View.GONE);
            }

            @Override
            public void onAnimationRepeat(Animation animation) {

            }
        });
    }


    @Override
    public void onFinish(View view) {
        Intent intent = getIntent();
        intent.putExtra("param1", repository.getIs_collection());
        setResult(RepositoryUtil.READ_DOC_RETURN, intent);
        super.onFinish(view);
    }

    @Override
    public void onBackPressed() {
        Intent intent = getIntent();
        intent.putExtra("param1", repository.getIs_collection());
        setResult(RepositoryUtil.READ_DOC_RETURN, intent);
        super.onBackPressed();
    }
}
