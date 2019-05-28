package com.jizhi.jlongg.main.util;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.text.TextUtils;

import com.compress.Luban1;
import com.hcs.uclient.utils.AppUtils;
import com.hcs.uclient.utils.ImageUtils;
import com.hcs.uclient.utils.LUtils;
import com.hcs.uclient.utils.MD5;
import com.hcs.uclient.utils.SPUtils;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.main.bean.ImageItem;
import com.jizhi.jlongg.main.util.request.CommonHttpRequest;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.jizhi.jlongg.recoed.manager.AudioRecordMessageButton.FileUtils;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;

import java.io.File;
import java.util.List;
import java.util.UUID;

public class RequestParamsToken {

    /**
     * 服务器和本地时间的差值
     */
    private static volatile long serverDiffrValue;
    /**
     * 是否已请求服务器和本地时间的差值
     */
    private static volatile boolean serverTimeIsRequest;
    /**
     * true表示正在请求
     */
    private static volatile boolean isRequestingServerTime;

    /**
     * 获取请求头的参数  如果不为空则加入token
     *
     * @param context
     * @return
     */
    public static RequestParams getExpandRequestParams(Context context) {
        RequestParamsToken.getServerTime(context);
        RequestParams params = new RequestParams();
        String token = SPUtils.get(context, Constance.enum_parameter.TOKEN.toString(), "", Constance.JLONGG).toString();
        /**
         * http 签名算法
         timestamp; 当前时间戳
         encryption = token + timestamp;  //如果登陆使用token 没有登陆 token使用socket中的key
         sign = sha1(encryption)
         */
        long timeStame = serverDiffrValue + System.currentTimeMillis() / 1000;
        if (!TextUtils.isEmpty(token)) { //当前用户已经登录
            params.setHeader(Constance.REQUEST_HEAD, token); // token
        }
        params.addBodyParameter("sign", MD5.getSHA1("OaxhSsnvFnRCUql53jVDUVVp26pQkYea" + timeStame));
        params.addBodyParameter("timestamp", timeStame + "");
        params.addBodyParameter("client_type", "person");
        params.addBodyParameter("ver", AppUtils.getVersionName(context));
        return params;
    }

    /**
     * 获取服务器的时间戳
     * 主要是做时间的验证
     */
    public static void getServerTime(Context context) {
        if (!serverTimeIsRequest && !isRequestingServerTime) {
            synchronized (RequestParamsToken.class) {
                if (!serverTimeIsRequest && !isRequestingServerTime) {
                    isRequestingServerTime = true;
                    String httpUrl = NetWorkRequest.GET_SERVER_TIME;
                    CommonHttpRequest.commonRequest(context, httpUrl, ServerTime.class, CommonHttpRequest.OBJECT, null, false, new CommonHttpRequest.CommonRequestCallBack() {
                        @Override
                        public void onSuccess(Object object) {
                            ServerTime serverTime = (ServerTime) object;
                            if (serverTime != null) {
                                serverDiffrValue = serverTime.getServer_time() - System.currentTimeMillis() / 1000;
                                serverTimeIsRequest = true;
                            }
                            isRequestingServerTime = false;
                        }

                        @Override
                        public void onFailure(HttpException exception, String errormsg) {
                            isRequestingServerTime = false;
                        }
                    });
                }
            }
        }
    }


    public class ServerTime {
        public long server_time;

        public long getServer_time() {
            return server_time;
        }
    }

    /**
     * Luban(鲁班)——Android图片压缩工具，仿微信朋友圈压缩策略。
     * 项目描述 Luban(鲁班) 详细介绍
     * 目前做app开发总绕不开图片这个元素。但是随着手机拍照分辨率的提升，图片的压缩成为一个很重要的问题。单纯对图片进行裁切，压缩已经有很多文章介绍。但是裁切成多少，压缩成多少却很难控制好，裁切过头图片太小，质量压缩过头则显示效果太差。
     * 于是自然想到app巨头“微信”会是怎么处理，Luban(鲁班)就是通过在微信朋友圈发送近100张不同分辨率图片，对比原图与微信压缩后的图片逆向推算出来的压缩算法。
     * 因为有其他语言也想要实现 Luban，所以描述了一遍算法步骤
     * 因为是逆向推算，效果还没法跟微信一模一样，但是已经很接近微信朋友圈压缩后的效果，具体看以下对比！
     * 效果与对比
     * 内容	原图	Luban	Wechat
     * 截屏 720P	720*1280,390k	720*1280,87k	720*1280,56k
     * 截屏 1080P	1080*1920,2.21M	1080*1920,104k	1080*1920,112k
     * 拍照 13M(4:3)	3096*4128,3.12M	1548*2064,141k	1548*2064,147k
     * 拍照 9.6M(16:9)	4128*2322,4.64M	1032*581,97k	1032*581,74k
     * 滚动截屏	1080*6433,1.56M	1080*6433,351k	1080*6433,482k
     *
     * @param params
     * @param mSelectPath 选中的图片路径
     * @param context
     * @return
     */
    public static void compressImageAndUpLoad(final RequestParams params, final List<String> mSelectPath, Context context) {
        if (mSelectPath == null || mSelectPath.size() == 0) {
            return;
        }
        if (android.os.Environment.getExternalStorageState().equals(android.os.Environment.MEDIA_MOUNTED)) { //内存卡必须可用
            int index = 0;
            for (final String imageFilePath : mSelectPath) {
                index += 1;
                File file = Luban1.get(context)
                        .load(new File(imageFilePath)).setSaveFileName("images" + index)                     //传人要压缩的图片
                        .putGear(Luban1.THIRD_GEAR).launch();     //设定压缩档次，默认三挡
                params.addBodyParameter("file[" + index + "]", file);
                LUtils.e("path:" + file.getAbsolutePath());
            }
        } else {
            CommonMethod.makeNoticeShort(context, "图片上传失败,请确认你的内存卡是否可用?", CommonMethod.ERROR);
        }
    }

    public static void compressImageAndUpLoadWater(final RequestParams params, final List<ImageItem> mSelectPath, Context context) {
        if (mSelectPath == null || mSelectPath.size() == 0) {
            return;
        }
        if (android.os.Environment.getExternalStorageState().equals(android.os.Environment.MEDIA_MOUNTED)) { //内存卡必须可用
            int index = 0;
            for (final ImageItem imageFilePath : mSelectPath) {
                index += 1;
                File file = Luban1.get(context)
                        .load(new File(imageFilePath.imagePath)).setSaveFileName("images" + index)//传人要压缩的图片
                        .putGear(Luban1.THIRD_GEAR).launch();//设定压缩档次，默认三挡
                if (imageFilePath.isCamenrPicture) {
                    //原始bitmap
                    Bitmap sourBitmap = ImageUtils.getFileBitmap(file.getPath(), context);
                    //水印图片背景
                    Bitmap waterBitmap = BitmapFactory.decodeResource(context.getResources(), R.drawable.water_bgs);
                    //加文字后的水印图片
                    Bitmap waterTextBitmap = ImageUtil.drawTextBottom(context, waterBitmap);
                    //加文字水印完成后的图片
                    Bitmap newBitmap = ImageUtil.createWaterMaskBitmap(context, sourBitmap, waterTextBitmap);
                    //生成bitmap的新文件
                    String filePath = FileUtils.getAppDir(context) + "/" + UUID.randomUUID().toString() + ".jpeg";
                    file = ImageUtils.saveBitmapFile(newBitmap, filePath);
                }
                params.addBodyParameter("file[" + index + "]", file);
                LUtils.e("path:" + file.getAbsolutePath());
            }
        } else {
            CommonMethod.makeNoticeShort(context, "图片上传失败,请确认你的内存卡是否可用?", CommonMethod.ERROR);
        }
    }

}
