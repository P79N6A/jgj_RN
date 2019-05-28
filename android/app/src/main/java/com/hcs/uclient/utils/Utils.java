package com.hcs.uclient.utils;

import android.Manifest;
import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.ActivityManager;
import android.app.ActivityManager.RunningAppProcessInfo;
import android.app.ActivityManager.RunningTaskInfo;
import android.content.ActivityNotFoundException;
import android.content.ComponentName;
import android.content.ContentResolver;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.pm.PackageManager.NameNotFoundException;
import android.content.res.AssetManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.net.wifi.WifiInfo;
import android.net.wifi.WifiManager;
import android.os.Build;
import android.os.Bundle;
import android.os.Environment;
import android.preference.PreferenceManager;
import android.provider.MediaStore;
import android.text.InputFilter;
import android.text.InputType;
import android.text.Spannable;
import android.text.SpannableStringBuilder;
import android.text.Spanned;
import android.text.TextUtils;
import android.text.style.AbsoluteSizeSpan;
import android.text.style.ForegroundColorSpan;
import android.text.style.StyleSpan;
import android.util.Base64;
import android.util.Log;
import android.util.Xml;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.view.inputmethod.InputMethodManager;
import android.webkit.CookieManager;
import android.webkit.CookieSyncManager;
import android.widget.AbsListView;
import android.widget.EditText;
import android.widget.ExpandableListView;
import android.widget.ListAdapter;
import android.widget.ListView;
import android.widget.TextView;

import com.baidu.platform.comapi.map.B;
import com.jizhi.jlongg.R;
import com.jizhi.jlongg.account.NewAccountActivity;
import com.jizhi.jlongg.db.BaseInfoService;
import com.jizhi.jlongg.main.activity.BaseActivity;
import com.jizhi.jlongg.main.activity.WebSocketBaseParameter;
import com.jizhi.jlongg.main.bean.GroupMemberInfo;
import com.jizhi.jlongg.main.bean.ImageItem;
import com.jizhi.jlongg.main.bean.PersonBean;
import com.jizhi.jlongg.main.bean.QualitySafeLocation;
import com.jizhi.jlongg.main.bean.RemberInfoTargetNameBean;
import com.jizhi.jlongg.main.bean.SynBill;
import com.jizhi.jlongg.main.bean.Version;
import com.jizhi.jlongg.main.bean.WorkType;
import com.jizhi.jlongg.main.bean.status.CommonJson;
import com.jizhi.jlongg.main.dialog.DiaLogNoMoreProject;
import com.jizhi.jlongg.main.msg.MessageType;
import com.jizhi.jlongg.main.util.CommonMethod;
import com.jizhi.jlongg.main.util.Constance;
import com.jizhi.jlongg.main.util.DataUtil;
import com.jizhi.jlongg.main.util.DecimalInputFilter;
import com.jizhi.jlongg.main.util.IsSupplementary;
import com.jizhi.jlongg.main.util.PinYin2Abbreviation;
import com.jizhi.jlongg.main.util.RequestParamsToken;
import com.jizhi.jlongg.main.util.SingsHttpUtils;
import com.jizhi.jlongg.main.util.WebSocketConstance;
import com.jizhi.jlongg.network.NetWorkRequest;
import com.jizhi.jlongg.utis.acp.Acp;
import com.jizhi.jlongg.utis.acp.AcpListener;
import com.jizhi.jlongg.utis.acp.AcpOptions;
import com.jizhi.jongg.widget.BubbleParams;
import com.lidroid.xutils.HttpUtils;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.RequestParams;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.callback.RequestCallBack;
import com.lidroid.xutils.http.client.HttpRequest;

import org.joda.time.LocalDate;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.lang.reflect.Constructor;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.math.RoundingMode;
import java.text.DateFormat;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class Utils {
    public static String logStringCache;
    // public static String channelIds;
    private static final double EARTH_RADIUS = 6378137;
    private static long lastClickTime;
    public static boolean isFlushWeb = true;

    //    public static boolean isNumeric(String str){
//        for(int i=str.length();--i>=0;){
//            int chr=str.charAt(i);
//            if(chr<48 || chr>57)
//                return false;
//        }
//        return true;
//    }
    public static void synCookies(Context context, String url) {
        CookieSyncManager.createInstance(context);
        CookieManager cookieManager = CookieManager.getInstance();
        cookieManager.setAcceptCookie(true);
        CookieSyncManager.getInstance().startSync();
        cookieManager.removeAllCookie();
        cookieManager.removeSessionCookie();
        String stoken = (String) SPUtils.get(context, "TOKEN", "", Constance.JLONGG);
        cookieManager.setCookie(url, "Authorization=" + stoken.replace(" ", "-"));
        CookieSyncManager.getInstance().sync();

        LUtils.e(cookieManager.getCookie(url) + ",,,," + "Authorization=" + stoken.replace(" ", "-"));
    }

    public static String getUrl(String url) {
        if (url.contains("?")) {
            return url + "&" + System.currentTimeMillis();
        } else {
            return url + "?" + System.currentTimeMillis();
        }
    }

    /*
     * 判断是否为整数
     * @param str 传入的字符串
     * @return 是整数返回true,否则返回false
     */
    public static boolean isInteger(String str) {
        Pattern pattern = Pattern.compile("^[-\\+]?[\\d]*$");
        LUtils.e("-----------------:" + pattern.matcher(str).matches());
        return pattern.matcher(str).matches();
    }

    public static boolean isDouble(double x) {
        return x % 1 == 0;
    }

    /**
     * 获取图片宽高
     *
     * @return
     */
    public static List<String> getImageWidthAndHeight(String path) {
        BitmapFactory.Options options = new BitmapFactory.Options();
        /**
         * 最关键在此，把options.inJustDecodeBounds = true;
         * 这里再decodeFile()，返回的bitmap为空，但此时调用options.outHeight时，已经包含了图片的高了
         */
        options.inJustDecodeBounds = true;
        Bitmap bitmap = BitmapFactory.decodeFile(path, options); // 此时返回的bitmap为null
        /**
         *options.outHeight为原始图片的高
         */
        int width = options.outWidth;
        int height = options.outHeight;
        return getImageWidthAndHeight(width, height);
    }

    public static List<String> getImageWidthAndHeightOriginal(String path) {
        BitmapFactory.Options options = new BitmapFactory.Options();
        /**
         * 最关键在此，把options.inJustDecodeBounds = true;
         * 这里再decodeFile()，返回的bitmap为空，但此时调用options.outHeight时，已经包含了图片的高了
         */
        options.inJustDecodeBounds = true;
        Bitmap bitmap = BitmapFactory.decodeFile(path, options); // 此时返回的bitmap为null
        /**
         *options.outHeight为原始图片的高
         */
        Log.e("Test", "Bitmap Height == " + options.outHeight);
        int width = options.outWidth;
        int height = options.outHeight;
        List<String> list = new ArrayList<>();
        list.add(width + "");
        list.add(height + "");
        return list;
    }

    public static boolean SavePic(Context context, Bitmap bitmap) {
        try {
            ContentResolver cr = context.getContentResolver();
            String url = JImageUtils.insertImage(cr, bitmap, "jgj_" + JImageUtils.getCurrentTimeLong(), "a photo from app", "吉工家");
            //对某些不更新相册的应用程序强制刷新
            Intent intent2 = new Intent(Intent.ACTION_MEDIA_SCANNER_SCAN_FILE);
            Uri uri = Uri.fromFile(new File("/sdcard/image.jpg"));//固定写法
            intent2.setData(uri);
            context.sendBroadcast(intent2);
            if (!TextUtils.isEmpty(url)) {
                CommonMethod.makeNoticeShort(context, "保存成功", CommonMethod.SUCCESS);
                return true;
            } else {
                return false;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }

    }

    public static void saveImageToGallery(Context context, Bitmap bmp) {
        // 创建文件夹
        File appDir = new File(Environment.getExternalStorageDirectory(), "Test");
        //判断不存在就创建
        if (!appDir.exists()) {
            appDir.mkdir();
        }
        //以时间命名
        String fileName = System.currentTimeMillis() + ".jpg";
        File file = new File(appDir, fileName);
        try {
            FileOutputStream fos = new FileOutputStream(file);
            bmp.compress(Bitmap.CompressFormat.JPEG, 100, fos);
            fos.flush();
            fos.close();
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
        // 其次把文件插入到系统图库
        try {
            MediaStore.Images.Media.insertImage(context.getContentResolver(),
                    file.getAbsolutePath(), fileName, null);
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }
        // 最后通知图库更新
        String path = Environment.getExternalStorageDirectory().getPath();
        context.sendBroadcast(new Intent(Intent.ACTION_MEDIA_SCANNER_SCAN_FILE, Uri.parse("file://" + path)));
    }

    /*
     * 保存文件，文件名为当前日期
     */
    public static boolean saveBitmap(Context context, Bitmap bitmap) {
        String bitName = System.currentTimeMillis() + ".JPEG";
        String fileName;
        File file;
        LUtils.e("-----手机品牌名称--------" + Build.BRAND);
        if (Build.BRAND.equalsIgnoreCase("Xiaomi") || Build.BRAND.equalsIgnoreCase("OPPO") || Build.BRAND.equalsIgnoreCase("ViVO") || Build.BRAND.equalsIgnoreCase("huawei")) {
            fileName = Environment.getExternalStorageDirectory().getPath() + "/DCIM/Camera/" + bitName;
        } else {  // Meizu 、Oppo
            fileName = Environment.getExternalStorageDirectory().getPath() + "/DCIM/" + bitName;
        }
        file = new File(fileName);

        if (file.exists()) {
            file.delete();
        }
        FileOutputStream out;
        try {
            out = new FileOutputStream(file);
            // 格式为 JPEG，照相机拍出的图片为JPEG格式的，PNG格式的不能显示在相册中
            if (bitmap.compress(Bitmap.CompressFormat.JPEG, 90, out)) {
                out.flush();
                out.close();
                // 插入图库
                MediaStore.Images.Media.insertImage(context.getContentResolver(), file.getAbsolutePath(), bitName, null);
            }
            // 发送广播，通知刷新图库的显示
            context.sendBroadcast(new Intent(Intent.ACTION_MEDIA_SCANNER_SCAN_FILE, Uri.parse("file://" + fileName)));
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * 优化后的图片宽高
     *
     * @param image_width
     * @param image_height
     * @return
     */
    public static List<String> getImageWidthAndHeight(int image_width, int image_height) {
//        LUtils.e(image_width + "-----11-----image_width:-------image_height-" + image_height);
//        if (image_height > 2000 || image_width > 2000) {
//            List<String> integers = new ArrayList<>();
//            integers.add(320 + "");
//            integers.add(480 + "");
//            return integers;
//        }
        int maxPix = BubbleParams.MAX_PIX;
        int minPix = BubbleParams.MIN_PIX;
        if (image_width > image_height) {
            if (image_width > maxPix) {
                int temp = image_width;
                image_width = maxPix;
                image_height = image_height * image_width / temp;
            } else if (image_width < minPix) {
                int temp = image_width;
                image_width = minPix;
                image_height = image_height * image_width / temp;
            }
        } else {
            if (image_height > maxPix) {
                int temp = image_height;
                image_height = maxPix;
                image_width = image_width * image_height / temp;
            } else if (image_height < minPix) {
                int temp = image_height;
                image_height = minPix;
                image_width = image_width * image_height / temp;
            }
        }
        if (image_width < 150) {
            image_width = 266;
        }
        if (image_height < 100) {
            image_height = 100;
        }
        List<String> integers = new ArrayList<>();
        integers.add(image_width + "");
        integers.add(image_height + "");

//        LUtils.e(image_width + "-----22-----image_width:-------image_height-" + image_height);
        return integers;
    }

    /**
     * 聊天对话
     * 今天的 10:00
     * 昨天的 昨天 10:00
     * 昨天以前今年以内的 05-23 10:00
     * 今年以前 2016-05-12 10:00
     * <p>
     * <p>
     * 聊天列表
     * 今天的 10:00
     * 昨天的 昨天
     * 昨天以前今年以内的 05-23
     * 今年以前 2016年
     *
     * @param time
     * @return
     */
    public static String simpleMessageForDateList(long time) {
        time = time * 1000L;
        long todayStartLongTime = getTodayStartTime();
        long dayLongTime = 24 * 60 * 60 * 1000; // 一天的毫秒数
        long result = todayStartLongTime - time;
        if (dayLongTime >= result) { // 今天的数据只显示小时分钟
            return new SimpleDateFormat("HH:mm").format(new Date(time));
        } else if (todayStartLongTime > time && dayLongTime * 2 >= result) { // 昨天
            return "昨天";
        } else {
            if (isThisYear(time)) {
                return new SimpleDateFormat("MM-dd").format(new Date(time));
            } else {
                return new SimpleDateFormat("yyyy年").format(new Date(time));
            }
        }
    }

    public static String simpleMessageForDate(long time) {
        time = time * 1000L;
        long todayStartLongTime = getTodayStartTime();
        long dayLongTime = 24 * 60 * 60 * 1000; // 一天的毫秒数
        long result = todayStartLongTime - time;
        if (dayLongTime >= result) { // 今天 的数据只显示小时分钟
            return new SimpleDateFormat("HH:mm").format(new Date(time));
        } else if (todayStartLongTime > time && dayLongTime * 2 >= result) { // 昨天
            return "昨天 " + new SimpleDateFormat("HH:mm").format(new Date(time));
        } else {
            if (isThisYear(time)) {
                return new SimpleDateFormat("MM-dd HH:mm").format(new Date(time));
            } else {
                return new SimpleDateFormat("yyyy-MM-dd HH:mm").format(new Date(time));
            }
        }
    }

    public static String simpleForDate(long time) {
        time = time * 1000L;
        long todayStartLongTime = getTodayStartTime();
        long dayLongTime = 24 * 60 * 60 * 1000; // 一天的毫秒数
        long result = todayStartLongTime - time;
        /**
         DateFormat df = new SimpleDateFormat("yyyy-MM-dd HH-mm-ss sss");
         Date date = new Date();
         return df.format(date);
         HH返回的是24小时制的时间
         hh返回的是12小时制的时间
         */
        if (dayLongTime >= result) { // 今天 的数据只显示小时分钟
            SimpleDateFormat simpleDate = new SimpleDateFormat("HH:mm");
            return simpleDate.format(new Date(time));
        } else if (todayStartLongTime > time && dayLongTime * 2 >= result) { // 昨天
            return "昨天";
        } else {
            if (isThisYear(time)) {
                return new SimpleDateFormat("MM-dd HH:mm").format(new Date(time));
            } else {
                return new SimpleDateFormat("yyyy-MM-dd").format(new Date(time));
            }
        }
    }

    private static boolean isThisYear(long time) {
        Calendar calendar = Calendar.getInstance();
        int thisYear = calendar.get(Calendar.YEAR);
        calendar.setTimeInMillis(time);
        int year = calendar.get(Calendar.YEAR);
        if (thisYear == year) {
            return true;
        }
        return false;
    }

    /**
     * 获取今天的初始时间 0点0分的毫秒数
     *
     * @return
     */
    public static long getTodayStartTime() {
        Calendar todayStartDate = new GregorianCalendar();
        todayStartDate.set(Calendar.HOUR_OF_DAY, 23);
        todayStartDate.set(Calendar.MINUTE, 59);
        todayStartDate.set(Calendar.SECOND, 59);
        return todayStartDate.getTimeInMillis();
    }


    /**
     * idcard:身份证号
     */
    public static Boolean JudgeIDCard(String idcard) {
        // 身份证号验证规则
        // String regEx = "(\\d{15}$|^\\d{18}$|^\\d{17}(\\d|X|x))";
        String regEx = "(1[1-5]|2[1-3]|3[1-7]|4[1-6]|5[0-4]|6[1-5]|71|81|82|90)([0-5][0-9]|90)([0-9]{2})(19|20)([0-9]{2})((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))([0-9]{3})([0-9]|X)";
        // 编译正则表达式
        Pattern pattern = Pattern.compile(regEx);
        // 忽略大小写的写法
        Matcher matcher = pattern.matcher(idcard);
        // 字符串是否与正则表达式相匹配
        return matcher.matches();
    }

    /**
     * 字母数字汉字
     */
    public static Boolean JudgeInput(String idcard) {
//        // 身份证号验证规则
//        String regEx = "^([0-9]|[A-Za-z]|[\u4E00-\u9FA5])+$";
//        // 编译正则表达式
//        Pattern pattern = Pattern.compile(regEx);
//        // 忽略大小写的写法
//        Matcher matcher = pattern.matcher(idcard);
//        // 字符串是否与正则表达式相匹配
//        return matcher.matches();
        return true;
    }

    public static String Bitmap2StrByBase64(Bitmap bit) {
        ByteArrayOutputStream bos = new ByteArrayOutputStream();
        bit.compress(Bitmap.CompressFormat.JPEG, 100, bos);// 参数100表示不压缩
        byte[] bytes = bos.toByteArray();
        return Base64.encodeToString(bytes, Base64.DEFAULT);
    }

    //    public static void getBitmapFromPath(String path) {
//        //decode to bitmap
//        Bitmap bitmap = BitmapFactory.decodeFile(path);
////        Log.d(TAG, "bitmap width: " + bitmap.getWidth() + " height: " + bitmap.getHeight());
//        //convert to byte array
//        ByteArrayOutputStream baos = new ByteArrayOutputStream();
//        bitmap.compress(Bitmap.CompressFormat.PNG, 100, baos);
//        byte[] bytes = baos.toByteArray();
//
//        //base64 encode
//        byte[] encode = Base64.encode(bytes,Base64.DEFAULT);
//        String encodeString = new String(encode);
//    }
    public static Bitmap getBitmapFromPath(String path) {

        if (!new File(path).exists()) {
            LUtils.e("getBitmapFromPath: file not exists");
            return null;
        }
        // Bitmap bitmap = Bitmap.createBitmap(1366, 768, Config.ARGB_8888);
        // Canvas canvas = new Canvas(bitmap);
        // Movie movie = Movie.decodeFile(path);
        // movie.draw(canvas, 0, 0);
        //
        // return bitmap;

        byte[] buf = new byte[1024 * 1024];// 1M
        Bitmap bitmap = null;

        try {

            FileInputStream fis = new FileInputStream(path);
            int len = fis.read(buf, 0, buf.length);
            bitmap = BitmapFactory.decodeByteArray(buf, 0, len);
            if (bitmap == null) {
                System.out.println("len= " + len);
                System.err.println("path: " + path + "  could not be decode!!!");
            }
        } catch (Exception e) {
            e.printStackTrace();

        }

        return bitmap;
    }

    /**
     * 验证字符串是否为空
     *
     * @param obj
     * @return
     */
    public static boolean isNull(String... obj) {
        for (String s : obj) {
            if (s == null || "".equals(s)) {
                return true;
            }
        }
        return false;
    }

    /**
     * 是否是手机
     *
     * @param num
     * @return
     */
    public static boolean isMobileNum(String num) {
        Pattern p = Pattern.compile("1[0-9]{10}$");
        Matcher m = p.matcher(num);
        return m.matches();
    }

    /**
     * 电子邮件
     */
    public static boolean checkEmail(String email) {
        String check = "^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*$";
        Pattern regex = Pattern.compile(check);
        Matcher matcher = regex.matcher(email);
        boolean isMatched = matcher.matches();
        return isMatched;

    }

    public static boolean isIDCcard(String str) {
        Pattern pattern = Pattern.compile("([0-9]{17}([0-9]|X))|([0-9]{15})");
        return pattern.matcher(str).matches();
    }

    /**
     * 防止按钮重复点击
     *
     * @return
     */
    public static boolean isFastDoubleClick() {
        long time = System.currentTimeMillis();
        if (time - lastClickTime < 1000) {
            return true;
        }
        lastClickTime = time;
        return false;
    }

    /**
     * 防止按钮重复点击
     *
     * @return
     */
    public static boolean isFastDoubleClick3000() {
        long time = System.currentTimeMillis();
        if (time - lastClickTime < 8000) {
            return true;
        }
        lastClickTime = time;
        return false;
    }

    /**
     * 动态计算listview高度
     *
     * @param listView
     */
    public static void setListViewHeightBasedOnChildren(ListView listView) {
        // 获取ListView对应的Adapter
        ListAdapter listAdapter = listView.getAdapter();
        if (listAdapter == null) {
            return;
        }
        int totalHeight = 0;
        for (int i = 0, len = listAdapter.getCount(); i < len; i++) { // listAdapter.getCount()返回数据项的数目
            View listItem = listAdapter.getView(i, null, listView);
            listItem.measure(0, 0); // 计算子项View 的宽高
            totalHeight += listItem.getMeasuredHeight(); // 统计所有子项的总高度
        }
        ViewGroup.LayoutParams params = listView.getLayoutParams();
        params.height = totalHeight
                + (listView.getDividerHeight() * (listAdapter.getCount()));
        // listView.getDividerHeight()获取子项间分隔符占用的高度
        // params.height最后得到整个ListView完整显示需要的高度
        listView.setLayoutParams(params);

    }

    public static void setListViewHeight(ExpandableListView listView) {
        ListAdapter listAdapter = listView.getAdapter();
        int totalHeight = 0;
        int count = listAdapter.getCount();
        for (int i = 0; i < listAdapter.getCount(); i++) {
            View listItem = listAdapter.getView(i, null, listView);
            listItem.measure(0, 0);
            totalHeight += listItem.getMeasuredHeight();
        }

        ViewGroup.LayoutParams params = listView.getLayoutParams();
        params.height = totalHeight
                + (listView.getDividerHeight() * (listAdapter.getCount() - 1));
        listView.setLayoutParams(params);
        listView.requestLayout();
    }

    /**
     * 动态计算listview高度
     *
     * @param listView
     */
    public static void setAccountListViewHeight(ListView listView, int screenHeight) {
        // 获取ListView对应的Adapter
        int height = 0;
        ListAdapter listAdapter = listView.getAdapter();
        if (listAdapter == null) {
            return;
        }
        int totalHeight = 0;
        for (int i = 0, len = listAdapter.getCount(); i < len; i++) { // listAdapter.getCount()返回数据项的数目
            View listItem = listAdapter.getView(i, null, listView);
            listItem.measure(0, 0); // 计算子项View 的宽高
            totalHeight += listItem.getMeasuredHeight(); // 统计所有子项的总高度
        }
        ViewGroup.LayoutParams params = listView.getLayoutParams();
        height = totalHeight + (listView.getDividerHeight() * (listAdapter.getCount()));
        if (height < screenHeight) {
            height = screenHeight;
        }
        params.height = height;
        LUtils.e(height + "---------height---------------" + screenHeight);
        // listView.getDividerHeight()获取子项间分隔符占用的高度
        // params.height最后得到整个ListView完整显示需要的高度
        listView.setLayoutParams(params);

    }

    public static String doubleTrans(double d) {
        if (Math.round(d) - d == 0) {
            return String.valueOf((long) d);
        }
        return String.valueOf(d);
    }

    public static int setListViewHeightBasedOnChildren(ListView listView, Context context) {
        ListAdapter listAdapter = listView.getAdapter();
        if (listAdapter == null) {
            return 0;
        }
        int totalHeight = 0;
        int listViewWidth = DensityUtils.getScreenWidth(context);
//        ConstValue.screenWidth - Tool.convertDpToPx(this, 12);//listView在布局时的宽度  ，screenWidth - 左右的padding - 左右的margin
//        int listViewWidth = ConstValue.screenWidth - Tool.convertDpToPx(this, 12);//listView在布局时的宽度  ，screenWidth - 左右的padding - 左右的margin
        int widthSpec = View.MeasureSpec.makeMeasureSpec(listViewWidth, View.MeasureSpec.AT_MOST);
        for (int i = 0; i < listAdapter.getCount(); i++) {
            View listItem = listAdapter.getView(i, null, listView);
            listItem.measure(widthSpec, 0);

            int itemHeight = listItem.getMeasuredHeight();
            totalHeight += itemHeight;

            System.out.println("listView.totalHeight: " + totalHeight + " itemHeight: " + itemHeight);
        }
        int historyHeight = totalHeight + (listView.getDividerHeight() * listAdapter.getCount() - 1);
        LUtils.e(listViewWidth + "------------------:" + historyHeight);
        return historyHeight;
    }

    /**
     * 获取Mac
     *
     * @param context
     * @return
     */
    public static String getLocalMacAddress(Context context) {

        WifiManager wifi = (WifiManager) context
                .getSystemService(Context.WIFI_SERVICE);
        WifiInfo info = wifi.getConnectionInfo();
        return info.getMacAddress();

    }

    /**
     * 获取小数点后两位
     *
     * @param f
     * @return
     */
//    public static String m2(double f) {
//        DecimalFormat df = new DecimalFormat("0.00");
//        df.setRoundingMode(RoundingMode.HALF_UP);
//        String ff = df.format(f);
//        return ff;
//    }

    /**
     * 小数计算（四舍五入）：解决DecimalFormat("#.00")使用时小数点后第三位值为5，第二位为偶数时无法进位的问题
     *
     * @param
     * @return
     */
    public static String m2(double startVal) {
        try {
            DecimalFormat df = new DecimalFormat("#,##0.00");
            df.setRoundingMode(RoundingMode.HALF_UP);
            LUtils.e(startVal + "------11-------" + df.format(startVal));
            return df.format(df.format(startVal));
        } catch (Exception e) {
            DecimalFormat df = new DecimalFormat("0.00");
            df.setRoundingMode(RoundingMode.HALF_UP);
            String ff = df.format(startVal);
//        return ff;
            LUtils.e("------------------" + e.getMessage());
            LUtils.e(startVal + "------22-------" + ff);
            return ff;
        }

    }

    /**
     * 获取小数点后两位
     *
     * @param f
     * @return
     */
    public static String m2NorZero(double f) {
        DecimalFormat df = new DecimalFormat("0.00");
        String ff = df.format(f);
        return ff;
    }

    /**
     * 获取小数点后两位
     *
     * @param f
     * @return
     */
    public static String m6(double f) {
        DecimalFormat df = new DecimalFormat("0.000000");
        String ff = df.format(f);
        return ff;
    }

    /**
     * 获取字符串中数字
     *
     * @param str
     * @return
     */
    public static double getNumber(String str) {
        String regEx = "[^0-9|.]";
        Pattern p = Pattern.compile(regEx);
        Matcher m = p.matcher(str);
        Double num = Double.parseDouble(m.replaceAll("").trim());
        return num;

    }

    public static String getCityStr(String str) {
        if (null != str && !str.equals("") && str.length() >= 5) {
            str = str.substring(0, 4) + ".";
        }
        return str;

    }

    //
    // /**
    // * 使用java正则表达式去掉多余的.与0
    // *
    // * @param s
    // * @return
    // */
    // public static String subZeroAndDot(String s) {
    // if (s.indexOf(".") > 0) {
    // s = s.replaceAll("0+?$", "");// 去掉多余的0
    // s = s.replaceAll("[.]$", "");// 如最后一位是.则去掉
    // }
    // return s;
    // }

    public static void setBind(Context context, boolean flag) {
        String flagStr = "not";
        if (flag) {
            flagStr = "ok";
        }
        SharedPreferences sp = PreferenceManager
                .getDefaultSharedPreferences(context);
        Editor editor = sp.edit();
        editor.putString("bind_flag", flagStr);
        editor.commit();
    }

    // 获取ApiKey
    public static String getMetaValue(Context context, String metaKey) {
        Bundle metaData = null;
        String apiKey = null;
        if (context == null || metaKey == null) {
            return null;
        }
        try {
            ApplicationInfo ai = context.getPackageManager()
                    .getApplicationInfo(context.getPackageName(),
                            PackageManager.GET_META_DATA);
            if (null != ai) {
                metaData = ai.metaData;
            }
            if (null != metaData) {
                apiKey = metaData.getString(metaKey);
            }
        } catch (NameNotFoundException e) {

        }
        return apiKey;
    }

    /**
     * 查询应用是否打开
     *
     * @param context
     * @return
     */
    public static boolean isOpenMyApp(Context context) {
        boolean isAppRunning = false;
        String MY_PKG_NAME = getAppPacKageName(context);
        ActivityManager am = (ActivityManager) context
                .getSystemService(Context.ACTIVITY_SERVICE);
        List<RunningTaskInfo> list = am.getRunningTasks(100);
        for (RunningTaskInfo info : list) {
            if (info.topActivity.getPackageName().equals(MY_PKG_NAME)
                    && info.baseActivity.getPackageName().equals(MY_PKG_NAME)) {
                isAppRunning = true;
                break;
            } else {
                isAppRunning = false;
            }
        }
        return isAppRunning;
    }

    /**
     * 查询应用后台运行
     *
     * @param context
     * @return
     */
    public static boolean isBackground(Context context) {
        ActivityManager activityManager = (ActivityManager) context
                .getSystemService(Context.ACTIVITY_SERVICE);
        List<RunningAppProcessInfo> appProcesses = activityManager
                .getRunningAppProcesses();
        for (RunningAppProcessInfo appProcess : appProcesses) {
            if (appProcess.processName.equals(context.getPackageName())) {
                if (appProcess.importance == RunningAppProcessInfo.IMPORTANCE_BACKGROUND) {
                    LUtils.e("后台", appProcess.processName);
                    return true;
                } else {
                    LUtils.e("前台");
                    return false;
                }
            }
        }
        return false;
    }


    /**
     * 判断Android程序是否在后台运行
     * true： 后台或者已经关闭
     * false：前台
     *
     * @param context
     * @return
     */
    public static boolean isApplicationBroughtToBackground(Context context) {
        ActivityManager am = (ActivityManager) context
                .getSystemService(Context.ACTIVITY_SERVICE);
        List<RunningTaskInfo> tasks = am.getRunningTasks(1);
        if (tasks != null && !tasks.isEmpty()) {
            ComponentName topActivity = tasks.get(0).topActivity;
            if (!topActivity.getPackageName().equals(context.getPackageName())) {
                return true;
            }
        }
        return false;
    }

    public static boolean isTopActivity(Context context) {
        String packageName = getAppPacKageName(context);
        ActivityManager activityManager = (ActivityManager) context.getSystemService(Context.ACTIVITY_SERVICE);
        List<RunningTaskInfo> tasksInfo = activityManager.getRunningTasks(1);
        if (tasksInfo.size() > 0) {
            // 应用程序位于堆栈的顶层
            if (packageName.equals(tasksInfo.get(0).topActivity.getPackageName())) {
                return true;
            }
        }
        return false;
    }

    public static boolean isTopActivity(Context context, String className) {
        List<RunningTaskInfo> rTasks = getRunningTask(context, 1);
        for (RunningTaskInfo task : rTasks) {
            LUtils.e("top:" + task.topActivity.getClassName());
            if (task.topActivity.getClassName().equals(className)) {
                return true;
            }
        }
        return false;
    }

    public static boolean isForeground(Context context, String className) {
        if (context == null || TextUtils.isEmpty(className)) {
            return false;
        }
        ActivityManager am = (ActivityManager) context.getSystemService(Context.ACTIVITY_SERVICE);
        List<ActivityManager.RunningTaskInfo> list = am.getRunningTasks(1);
        if (list != null && list.size() > 0) {
            ComponentName cpn = list.get(0).topActivity;
            if (className.equals(cpn.getClassName())) {
                return true;
            }
        }
        return false;
    }


    public static List<RunningTaskInfo> getRunningTask(Context context, int num) {
        if (context != null) {
            ActivityManager am = (ActivityManager) context
                    .getSystemService(Context.ACTIVITY_SERVICE);
            List<RunningTaskInfo> rTasks = am.getRunningTasks(1);
            return rTasks;
        }
        return null;
    }

    /**
     * 获取应用包名
     *
     * @param context
     * @return
     */
    public static String getAppPacKageName(Context context) {
        String pkName = context.getPackageName();
        LUtils.i("packageName---->" + pkName);
        return pkName;

    }

    /**
     * 手机号码中间4为替换为*
     */
    public static String mobileReplace(String mobile) {
        String m = mobile.substring(0,
                mobile.length() - (mobile.substring(3)).length())
                + "****" + mobile.substring(7);
        return m;
    }

    public static String changeTime(int time) {
        int hour = time / 60;
        int minute = time % 60;
        StringBuffer buffer = new StringBuffer();

        if (hour != 0) {
            buffer.append(hour + "小时");
        }
        if (minute != 0) {
            buffer.append(minute + "分钟");
        }
        return buffer.toString();

    }

    private static double rad(double d) {
        return d * Math.PI / 180.0;
    }

    /**
     * 根据两点间经纬度坐标（double值），计算两点间距离，
     *
     * @param lat1
     * @param lng1
     * @param lat2
     * @param lng2
     * @return 距离：单位为米
     */
    public static double DistanceOfTwoPoints(double lat1, double lng1,
                                             double lat2, double lng2) {
        double radLat1 = rad(lat1);
        double radLat2 = rad(lat2);
        double a = radLat1 - radLat2;
        double b = rad(lng1) - rad(lng2);
        double s = 2 * Math.asin(Math.sqrt(Math.pow(Math.sin(a / 2), 2)
                + Math.cos(radLat1) * Math.cos(radLat2)
                * Math.pow(Math.sin(b / 2), 2)));
        s = s * EARTH_RADIUS;
        s = Math.round(s * 10000) / 10000;
        return s;
    }

    /**
     * 电子邮件
     */
    public boolean checkEmail() {

        String check = "^([a-z0-9A-Z]+[-|\\.]?)+[a-z0-9A-Z]@([a-z0-9A-Z]+(-[a-z0-9A-Z]+)?\\.)+[a-zA-Z]{2,}$";
        Pattern regex = Pattern.compile(check);
        Matcher matcher = regex.matcher("dffdfdf@qq.com");
        boolean isMatched = matcher.matches();
        return isMatched;

    }

    public static List<WorkType> getWt(Activity activity, String name,
                                       String tableName) {
        BaseInfoService baseInfoService = BaseInfoService.getInstance(activity.getApplicationContext());
        List<WorkType> list = null;
        try {
            AssetManager asset = activity.getAssets();
            InputStream input = asset.open(name);
            SAXParseXML saxParseXML = new SAXParseXML();
            android.util.Xml.parse(input, Xml.Encoding.UTF_8, saxParseXML);
            list = saxParseXML.getProducts();
            for (int i = 0; i < list.size(); i++) {
                WorkType workType = new WorkType(list.get(i).getWorktype(), list.get(i).getWorkName());
                boolean isAdd = baseInfoService.isInsertInfo(
                        workType.getWorkName(), tableName);
                // 如果之前没有添加过在添加
                if (!isAdd) {
                    baseInfoService.insertBaseInfo(workType, tableName);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();

        }
        return list;
    }

    public static String removeEnd1(String str) {
        if (null == str || str.equals("") || str.length() < 1) {
            return "";
        } else {
            return str.toString().substring(0, str.toString().length() - 1);
        }
    }

    @SuppressLint("NewApi")
    public static void setBackGround(View view, Drawable drawble) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN) {
            view.setBackground(drawble);
        } else {
            view.setBackgroundDrawable(drawble);
        }
    }

    @SuppressLint("NewApi")
    public static void setTextColor(TextView textView, int color) {

    }

    /**
     * 根据包名 判断是否在栈里
     */
    public static boolean checkApplication(Context context, String packageName) {
        if (TextUtils.isEmpty(packageName)) {
            return false;
        }
        try {
            ApplicationInfo info = context.getPackageManager().getApplicationInfo(packageName, PackageManager.GET_UNINSTALLED_PACKAGES);
            return true;
        } catch (NameNotFoundException e) {
            return false;
        }
    }


    public static boolean isExsitMianActivity(Activity activity, Class cls) {
        Intent intent = new Intent(activity, cls);
        ComponentName cmpName = intent.resolveActivity(activity.getPackageManager());
        boolean flag = false;
        if (cmpName != null) { // 说明系统中存在这个activity
            ActivityManager am = (ActivityManager) activity.getSystemService(Context.ACTIVITY_SERVICE);
            List<RunningTaskInfo> taskInfoList = am.getRunningTasks(10);
            for (RunningTaskInfo taskInfo : taskInfoList) {
                if (taskInfo.baseActivity.equals(cmpName)) { // 说明它已经启动了
                    flag = true;
                    break; // 跳出循环，优化效率
                }
            }
        }
        return flag;
    }

    /**
     * 比较时间的大小
     *
     * @param oldtime 比较的时间
     * @return
     */
    public static boolean compare_date(String oldtime) {
        String nowtime = LocalDate.now().getYear() + "-" + LocalDate.now().getMonthOfYear() + "-" + LocalDate.now().getDayOfMonth();
        DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
        try {
            Date dt1 = df.parse(nowtime);
            Date dt2 = df.parse(oldtime);
            if (dt1.getTime() >= dt2.getTime()) {
                return false;
            } else if (dt1.getTime() < dt2.getTime()) {
                return true;
            } else {
                return false;
            }
        } catch (Exception exception) {
            exception.printStackTrace();
        }
        return false;
    }

    /**
     * 比较时间是否相等
     *
     * @param oldtime 比较的时间
     * @return
     */
    public static boolean compare_equaldate(String oldtime) {
        String nowtime = LocalDate.now().getYear() + "-" + LocalDate.now().getMonthOfYear() + "-" + LocalDate.now().getDayOfMonth();
        DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
        try {
            Date dt1 = df.parse(nowtime);
            Date dt2 = df.parse(oldtime);
            if (nowtime.trim().equals(oldtime.trim())) {
                return true;
            }

        } catch (Exception exception) {
            exception.printStackTrace();
        }
        return false;
    }

    /**
     * 获取小数点后一位
     *
     * @param f
     * @return
     */
    public static String m1(double f) {
        DecimalFormat df = new DecimalFormat("0.0");
        String ff = df.format(f);
        return ff;
    }

    /**
     * 大小写转换
     *
     * @param date
     * @return
     */
    public static String chiaDate(String date) {
        StringBuffer sb = new StringBuffer();
        if (date.equals("10")) {
            return "十";
        } else if (date.equals("11")) {
            return "十一";
        } else if (date.equals("12")) {
            return "十二";
        }
        String[] number = {"零", "一", "二", "三", "四", "五", "六", "七", "八", "九"};
        char[] arr = date.toCharArray();
        for (int i = 0; i < arr.length; i++) {
            char index = arr[i];
            sb.append(number[Integer.parseInt(index + "")]);
        }
        return sb.toString();
    }

    /**
     * 大小写转换
     *
     * @param week
     * @return
     */
    public static String chiaWeek(int week) {
        StringBuffer sb = new StringBuffer();

        switch (week) {
            case 0:
                return "周一";
            case 1:
                return "周二";
            case 2:
                return "周三";
            case 3:
                return "周四";
            case 4:
                return "周五";
            case 5:
                return "周六";
            case 6:
                return "周日";
            default:
                return "";
        }
    }

    public static Map<String, String> signMap(WebSocketBaseParameter requestServer) {
        Map<String, String> par = new HashMap<>();
        Class c = requestServer.getClass();
        Field[] publicFields = c.getFields();
//        LUtils.e("--------publiclength---" + publicFields.length);
        for (int i = 0; i < publicFields.length; i++) {
            Field f = publicFields[i];
            try {
                Object val = f.get(requestServer);// 得到此属性的值
//                LUtils.e("--------i---" + i + ",," + f.getName() + ",,," + f.getType().toString());
                String type = f.getType().toString();// 得到此属性的类型
                if (null != val && !TextUtils.isEmpty(val.toString()) && !type.equals("boolean") && !type.equals("interface java.util.List")) {
                    par.put(f.getName(), val.toString());
                }

            } catch (IllegalAccessException e) {
                e.printStackTrace();
            }
        }
        Field[] privateFirleds = c.getDeclaredFields();
//        LUtils.e("--------privatelength---" + privateFirleds.length);
        for (int i = 0; i < privateFirleds.length; i++) {
            Field f = privateFirleds[i];
            f.setAccessible(true); // 设置些属性是可以访问的
            try {
                Object val = f.get(requestServer);// 得到此属性的值
//                LUtils.e("--------i---" + i + ",," + f.getName() + ",,," + f.getType().toString());
                String type = f.getType().toString();// 得到此属性的类型
                if (null != val && !TextUtils.isEmpty(val.toString()) && !type.equals("boolean") && !type.equals("interface java.util.List")) {
                    par.put(f.getName(), val.toString());
                }

            } catch (IllegalAccessException e) {
                e.printStackTrace();
            }
        }
        return par;
    }

    public interface UpdateAppListener {
        public void isUpdate(boolean update);
    }


    /**
     * 版本检测
     */
    public static void checkVersion(final Activity activity, final UpdateAppListener listener, final DialogInterface.OnDismissListener onDismissListener) {
        RequestParams params = RequestParamsToken.getExpandRequestParams(activity);
        params.addBodyParameter("os", "A");// 密码
        params.addBodyParameter("version", String.valueOf(AppUtils.getVersionName(activity)));// 版本号
        params.addBodyParameter("client_type", "person");// 客户端 为个人版
        params.addBodyParameter("device_id", AppUtils.getImei(activity));// imei
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.CHECK_VERSION, params, new RequestCallBack<String>() {
            @Override
            public void onSuccess(ResponseInfo<String> responseInfo) {
                try {
                    CommonJson<Version> base = CommonJson.fromJson(responseInfo.result, Version.class);
                    if (base.getState() != 0) {
                        Version version = base.getValues();
                        if (!TextUtils.isEmpty(version.getDownloadLink())) {
                            if (listener != null) {
                                listener.isUpdate(true);
                            }
                            IsSupplementary.downNewVersions(activity, version.getDownloadLink(), version.getVer(), version.getUpinfo(), onDismissListener);
                        } else {
                            if (listener != null) {
                                listener.isUpdate(false);
                            }
                        }
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }

            @Override
            public void onFailure(HttpException arg0, String arg1) {
                if (listener != null) {
                    listener.isUpdate(false);
                }
            }
        });
    }

    /**
     * 版本检测
     */
    public static void checkVersionNeedDiaLog(final BaseActivity activity) {
        RequestParams params = RequestParamsToken.getExpandRequestParams(activity);
        params.addBodyParameter("os", "A");// 密码
        params.addBodyParameter("version", String.valueOf(AppUtils.getVersionName(activity)));// 版本号
        params.addBodyParameter("device_id", AppUtils.getImei(activity));// imei
        HttpUtils http = SingsHttpUtils.getHttp();
        http.send(HttpRequest.HttpMethod.POST, NetWorkRequest.CHECK_VERSION,
                params, activity.new RequestCallBackExpand<String>() {
                    @Override
                    public void onSuccess(ResponseInfo<String> responseInfo) {
                        try {
                            CommonJson<Version> base = CommonJson.fromJson(responseInfo.result, Version.class);
                            if (base.getState() != 0) {
                                Version version = base.getValues();
                                if (!TextUtils.isEmpty(version.getDownloadLink())) {
                                    IsSupplementary.downNewVersions(activity, version.getDownloadLink(), version.getVer(), version.getUpinfo(), null);
                                } else {
                                    DiaLogNoMoreProject diaLogNoMoreProject = new DiaLogNoMoreProject(activity, "已是最新版本", true);
                                    diaLogNoMoreProject.show();
                                }
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                        } finally {
                            activity.closeDialog();
                        }
                    }

                });
    }


    public static void setDownloadPermission(final Activity activity, final String downloadpath) {
        Acp.getInstance(activity).request(new AcpOptions.Builder()
                        .setPermissions(Manifest.permission.WRITE_EXTERNAL_STORAGE, Manifest.permission.READ_EXTERNAL_STORAGE)
                        .build(),
                new AcpListener() {
                    @Override
                    public void onGranted() {
                        DownLoadingApkUtil down = new DownLoadingApkUtil(activity, downloadpath);
                        down.checkUpdateInfo();
                    }

                    @Override
                    public void onDenied(List<String> permissions) {
                        CommonMethod.makeNoticeShort(activity, activity.getResources().getString(R.string.permission_close), CommonMethod.ERROR);
                    }
                });
    }


    /**
     * 设置拼音
     *
     * @param lists
     */
    public static void setPinYinAndSortPerson(List<PersonBean> lists) {
        try {
            if (lists != null && lists.size() > 0) {
                String rule = "[a-zA-Z]";
                for (PersonBean info : lists) {
                    if (TextUtils.isEmpty(info.getSortLetters()) && !TextUtils.isEmpty(info.getName())) { //设置首字母拼音
                        String firstHeadChars = PinYin2Abbreviation.getPingYin(info.getName().substring(0, 1));
                        info.setSortLetters(firstHeadChars.matches(rule) ? firstHeadChars : "#");
                        info.setPinYin(PinYin2Abbreviation.getPinYinHeadChar(info.getName()));
                    }
                }
                Collections.sort(lists, new Comparator<PersonBean>() {
                    @Override
                    public int compare(PersonBean lhs, PersonBean rhs) {
                        if (TextUtils.isEmpty(lhs.getPinYin()) || TextUtils.isEmpty(rhs.getPinYin())) {
                            return -1;
                        }
                        /**
                         * compareTo()的返回值是int,它是先比较对应字符的大小(ASCII码顺序)
                         1、如果字符串相等返回值0
                         2、如果第一个字符和参数的第一个字符不等,结束比较,返回他们之间的差值（ascii码值）（负值代表：前字符串的值小于后字符串，正值代表：前字符串大于后字符串）
                         3、如果第一个字符和参数的第一个字符相等,则以第二个字符和参数的第二个字符做比较,以此类推,直至比较的字符或被比较的字符有一方全比较完,这时就比较字符的长度. 
                         compareToIgnoreCase()方法是不区分大小写，返回值是int，比较方式与compareTo()相同
                         */
                        return lhs.getPinYin().compareToIgnoreCase(rhs.getPinYin());
                    }
                });
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 设置拼音
     *
     * @param lists
     */
    public static void setPinYinAndSortPersonAddr(List<QualitySafeLocation> lists) {
        try {
            if (lists != null && lists.size() > 0) {
                String rule = "[a-zA-Z]";
                for (QualitySafeLocation info : lists) {
                    if (TextUtils.isEmpty(info.getSortLetters()) && !TextUtils.isEmpty(info.getText())) { //设置首字母拼音
                        String firstHeadChars = PinYin2Abbreviation.getPingYin(info.getText().substring(0, 1));
                        info.setSortLetters(firstHeadChars.matches(rule) ? firstHeadChars : "#");
                        info.setPinYin(PinYin2Abbreviation.getPinYinHeadChar(info.getText()));
                    }
                }
                Collections.sort(lists, new Comparator<QualitySafeLocation>() {
                    @Override
                    public int compare(QualitySafeLocation lhs, QualitySafeLocation rhs) {
                        if (TextUtils.isEmpty(lhs.getPinYin()) || TextUtils.isEmpty(rhs.getPinYin())) {
                            return -1;
                        }
                        /**
                         * compareTo()的返回值是int,它是先比较对应字符的大小(ASCII码顺序)
                         1、如果字符串相等返回值0
                         2、如果第一个字符和参数的第一个字符不等,结束比较,返回他们之间的差值（ascii码值）（负值代表：前字符串的值小于后字符串，正值代表：前字符串大于后字符串）
                         3、如果第一个字符和参数的第一个字符相等,则以第二个字符和参数的第二个字符做比较,以此类推,直至比较的字符或被比较的字符有一方全比较完,这时就比较字符的长度. 
                         compareToIgnoreCase()方法是不区分大小写，返回值是int，比较方式与compareTo()相同
                         */
                        return lhs.getPinYin().compareToIgnoreCase(rhs.getPinYin());
                    }
                });
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 设置拼音
     *
     * @param lists
     */
    public static void setPinYinAndSort(List<GroupMemberInfo> lists) {
        try {
            if (lists != null && lists.size() > 0) {
                String rule = "[a-zA-Z]";
                for (GroupMemberInfo info : lists) {
                    if (TextUtils.isEmpty(info.getSortLetters()) && !TextUtils.isEmpty(info.getReal_name())) { //设置首字母拼音
                        String firstHeadChars = PinYin2Abbreviation.getPingYin(info.getReal_name().substring(0, 1));
                        info.setSortLetters(firstHeadChars.matches(rule) ? firstHeadChars : "#");
                        info.setPinYin(PinYin2Abbreviation.getPinYinHeadChar(info.getReal_name()));
                    }
                }
                Collections.sort(lists, new Comparator<GroupMemberInfo>() {
                    @Override
                    public int compare(GroupMemberInfo lhs, GroupMemberInfo rhs) {
                        if (TextUtils.isEmpty(lhs.getPinYin()) || TextUtils.isEmpty(rhs.getPinYin())) {
                            return -1;
                        }
                        /**
                         * compareTo()的返回值是int,它是先比较对应字符的大小(ASCII码顺序)
                         1、如果字符串相等返回值0
                         2、如果第一个字符和参数的第一个字符不等,结束比较,返回他们之间的差值（ascii码值）（负值代表：前字符串的值小于后字符串，正值代表：前字符串大于后字符串）
                         3、如果第一个字符和参数的第一个字符相等,则以第二个字符和参数的第二个字符做比较,以此类推,直至比较的字符或被比较的字符有一方全比较完,这时就比较字符的长度. 
                         compareToIgnoreCase()方法是不区分大小写，返回值是int，比较方式与compareTo()相同
                         */
                        return lhs.getPinYin().compareToIgnoreCase(rhs.getPinYin());
                    }
                });
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 设置拼音
     *
     * @param lists
     */
    public static void setPinYinAndSortRember(List<RemberInfoTargetNameBean> lists) {
        try {
            if (lists != null && lists.size() > 0) {
                String rule = "[a-zA-Z]";
                for (RemberInfoTargetNameBean info : lists) {
                    if (TextUtils.isEmpty(info.getSortLetters()) && !TextUtils.isEmpty(info.getName())) { //设置首字母拼音
                        String firstHeadChars = PinYin2Abbreviation.getPingYin(info.getName().substring(0, 1));
                        info.setSortLetters(firstHeadChars.matches(rule) ? firstHeadChars : "#");
                        info.setPinYin(PinYin2Abbreviation.getPinYinHeadChar(info.getName()));
                    }
                }
                Collections.sort(lists, new Comparator<RemberInfoTargetNameBean>() {
                    @Override
                    public int compare(RemberInfoTargetNameBean lhs, RemberInfoTargetNameBean rhs) {
                        if (TextUtils.isEmpty(lhs.getPinYin()) || TextUtils.isEmpty(rhs.getPinYin())) {
                            return -1;
                        }
                        /**
                         * compareTo()的返回值是int,它是先比较对应字符的大小(ASCII码顺序)
                         1、如果字符串相等返回值0
                         2、如果第一个字符和参数的第一个字符不等,结束比较,返回他们之间的差值（ascii码值）（负值代表：前字符串的值小于后字符串，正值代表：前字符串大于后字符串）
                         3、如果第一个字符和参数的第一个字符相等,则以第二个字符和参数的第二个字符做比较,以此类推,直至比较的字符或被比较的字符有一方全比较完,这时就比较字符的长度. 
                         compareToIgnoreCase()方法是不区分大小写，返回值是int，比较方式与compareTo()相同
                         */
                        return lhs.getPinYin().compareToIgnoreCase(rhs.getPinYin());
                    }
                });
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 设置拼音
     *
     * @param lists
     */
    public static void setPinYinAndSortSynch(List<SynBill> lists) {
        try {
            if (lists != null && lists.size() > 0) {
                String rule = "[a-zA-Z]";
                for (SynBill info : lists) {
                    if (TextUtils.isEmpty(info.getSortLetters()) && !TextUtils.isEmpty(info.getReal_name())) { //设置首字母拼音
                        String firstHeadChars = PinYin2Abbreviation.getPingYin(info.getReal_name().substring(0, 1));
                        info.setSortLetters(firstHeadChars.matches(rule) ? firstHeadChars : "#");
                        info.setPinYin(PinYin2Abbreviation.getPinYinHeadChar(info.getReal_name()));
                    }
                }
                Collections.sort(lists, new Comparator<SynBill>() {
                    @Override
                    public int compare(SynBill lhs, SynBill rhs) {
                        if (TextUtils.isEmpty(lhs.getPinYin()) || TextUtils.isEmpty(rhs.getPinYin())) {
                            return -1;
                        }
                        /**
                         * compareTo()的返回值是int,它是先比较对应字符的大小(ASCII码顺序)
                         1、如果字符串相等返回值0
                         2、如果第一个字符和参数的第一个字符不等,结束比较,返回他们之间的差值（ascii码值）（负值代表：前字符串的值小于后字符串，正值代表：前字符串大于后字符串）
                         3、如果第一个字符和参数的第一个字符相等,则以第二个字符和参数的第二个字符做比较,以此类推,直至比较的字符或被比较的字符有一方全比较完,这时就比较字符的长度. 
                         compareToIgnoreCase()方法是不区分大小写，返回值是int，比较方式与compareTo()相同
                         */
                        return lhs.getPinYin().compareToIgnoreCase(rhs.getPinYin());
                    }
                });
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 改变一行字体的颜色
     *
     * @param completeString 完整的字符
     * @param changeString   需要变化的字符
     * @param textColor      需要将字体涂成某种颜色的值
     * @param isSetBold      是否
     */
    public static SpannableStringBuilder setSelectedFontChangeColor(String completeString, String changeString, int textColor, boolean isSetBold) {
        Pattern p = Pattern.compile(changeString);
        SpannableStringBuilder builder = new SpannableStringBuilder(completeString);
        Matcher telMatch = p.matcher(completeString);
        while (telMatch.find()) {
            if (isSetBold) {
                builder.setSpan(new ForegroundColorSpan(textColor), telMatch.start(), telMatch.end(), Spannable.SPAN_INCLUSIVE_INCLUSIVE);
                builder.setSpan(new StyleSpan(android.graphics.Typeface.BOLD), telMatch.start(), telMatch.end(), Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);  //粗体
            } else {
                builder.setSpan(new ForegroundColorSpan(textColor), telMatch.start(), telMatch.end(), Spannable.SPAN_INCLUSIVE_INCLUSIVE);
            }
        }
        return builder;
    }


    public static String subFloat(String unit) {
        if (TextUtils.isEmpty(unit)) {
            return "";
        }
        if (unit.contains(".0")) {
            unit = unit.replace(".0", "");
        }
        return unit;
    }

    /**
     * 获取文件大小
     *
     * @param fileSize
     * @return
     */
    public static String getFileSizeString(long fileSize) {
        String fileSizeString;
        if (fileSize == 0) {
            return "0B";
        }
        DecimalFormat df = new DecimalFormat("#.00");
        if (fileSize < 1024) { //字节
            fileSizeString = df.format((double) fileSize) + "B";
        } else if (fileSize < 1048576) { //KB
            fileSizeString = df.format((double) fileSize / 1024) + "K";
        } else if (fileSize < 1073741824) { //MB
            fileSizeString = df.format((double) fileSize / 1048576) + "M";
        } else { //GB
            fileSizeString = df.format((double) fileSize / 1073741824) + "G";
        }
        return fileSizeString;
    }

    /**
     * 设置消息大于99条时的转换
     *
     * @param count
     * @return
     */
    public static String setMessageCount(int count) {
        return count > 99 ? "99+" : count + "";
    }


    /**
     * 弹出键盘
     *
     * @param activity
     * @param telEdit
     */
    public static void showSoftKeyboard(Activity activity, EditText telEdit) {
        if (activity.getWindow().getAttributes().softInputMode != WindowManager.LayoutParams.SOFT_INPUT_STATE_HIDDEN) {
            if (activity.getCurrentFocus() != null) {
                InputMethodManager inputMethodManager = (InputMethodManager) activity.getSystemService(Context.INPUT_METHOD_SERVICE);
                inputMethodManager.showSoftInput(telEdit, 0);
            }
        }
    }

    /**
     * 内容
     *
     * @param text 内容
     * @return
     */
    public static boolean workAndOverTimeText(String text) {
        if (TextUtils.isEmpty(text) || text.equals("0") || text.equals("0.0") || text.equals("0.00")) {
            return true;

        }
        return false;
    }

    /**
     * 删除.0
     *
     * @param text 内容
     * @return
     */
    public static String deleteZero(String text) {
        if (TextUtils.isEmpty(text)) {
            return text;

        } else if (text.contains(".0")) {
            return text.replace(".0", "");

        } else if (text.contains(".00")) {
            return text.replace(".00", "");

        }
        return text;
    }

    public static View getHeadBackgroundView(Context context) {
        View backgroundView = new View(context);
        AbsListView.LayoutParams params = new AbsListView.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, DensityUtils.dp2px(context, 10));
        backgroundView.setLayoutParams(params);
        return backgroundView;
    }

    /**
     * 设置同一个TexrView 字体不同的大小
     *
     * @param context
     * @param completeText 完整字体
     * @param changeText   需要变化的文字
     * @param textSize     需要变化的文字大小 单位是SP
     * @return
     */
    public static SpannableStringBuilder setTextDifferentSize(Context context, String
            completeText, String changeText, int textSize) {
        SpannableStringBuilder builder = new SpannableStringBuilder(completeText);
        if (TextUtils.isEmpty(changeText)) {
            return builder;
        }
        Matcher nameMatch = Pattern.compile(changeText).matcher(completeText);
        while (nameMatch.find()) {
            AbsoluteSizeSpan textSizeSpan = new AbsoluteSizeSpan(DensityUtils.sp2px(context, textSize));
            builder.setSpan(textSizeSpan, nameMatch.start(), nameMatch.end(), Spannable.SPAN_INCLUSIVE_INCLUSIVE);
        }
        return builder;
    }

    public static Bitmap compressBitmap(Bitmap bitmap, float size) {
        if (bitmap == null) {
            LUtils.e("---------compressBitmap-------11------------");
            return null;//缩
        }
        if (getBitmapSize(bitmap) <= size) {
            LUtils.e("---------compressBitmap-------22------------");
            return bitmap;//如果图片本身的大小已经小于这个大小了，就没必要进行压缩
        }
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        bitmap.compress(Bitmap.CompressFormat.JPEG, 50, baos);//如果签名是png的话，则不管quality是多少，都不会进行质量的压缩
        int quality = 100;
        LUtils.e("---------compressBitmap-------33-----------");
        while (baos.toByteArray().length / 1024f > size) {
            quality = quality - 4;// 每次都减少4
            baos.reset();// 重置baos即清空baos
            if (quality <= 0) {
                LUtils.e("---------compressBitmap------44------------");
                break;
            }
            bitmap.compress(Bitmap.CompressFormat.JPEG, quality, baos);
            LUtils.e("------质量--------" + baos.toByteArray().length / 1024f);
        }
        return bitmap;
    }

    /**
     * 得到bitmap的大小
     */
    public static int getBitmapSize(Bitmap bitmap) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {    //API 19
            return bitmap.getAllocationByteCount();
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB_MR1) {//API 12
            return bitmap.getByteCount();
        }
        // 在低版本中用一行的字节x高度
        return bitmap.getRowBytes() * bitmap.getHeight();                //earlier version
    }

    public static List<String> getWaterList(Activity activity) {
        List<String> list = new ArrayList<>();
        String address = SPUtils.get(activity, Constance.ADDRESS, "", Constance.JLONGG).toString();
        String name = SPUtils.get(activity, Constance.USERNAME, "", Constance.JLONGG).toString();
        String time = TimesUtils.getNowTime();
        list.add(address);
        list.add(name);
        list.add(time);
        return list;
    }

    /**
     * 查看是否有拍照返回的图片
     *
     * @param mSelected
     * @param cameraList
     */
    public static List<ImageItem> getImages(List<String> mSelected, List<String> cameraList) {
        List<ImageItem> tempList = new ArrayList<ImageItem>();
        if (mSelected != null && mSelected.size() > 0) { //遍历添加本地选中图片
            for (String localpath : mSelected) {
                ImageItem item = new ImageItem();
                item.imagePath = localpath;
                item.isNetPicture = false;
                item.isCamenrPicture = (null == cameraList ? false : cameraList.contains(localpath));
                tempList.add(item);
            }
        }
        return tempList;
    }

    public static List<String> getMsgTypeList() {
        List<String> msgTypeList = new ArrayList<>();
        msgTypeList.add(MessageType.MSG_TEXT_STRING);
        msgTypeList.add(MessageType.MSG_PIC_STRING);
        msgTypeList.add(MessageType.MSG_RECALL_STRING);
        msgTypeList.add(MessageType.MSG_NOTICE_STRING);
        msgTypeList.add(MessageType.MSG_VOICE_STRING);
        msgTypeList.add(MessageType.MSG_SIGNIN_STRING);
        msgTypeList.add(MessageType.MSG_SAFE_STRING);
        msgTypeList.add(MessageType.MSG_QUALITY_STRING);
        msgTypeList.add(MessageType.MSG_LOG_STRING);
        return msgTypeList;
    }

    /**
     * 消息是否包含提示关键字
     *
     * @param text
     * @return
     */
    public static boolean isHintText(String text) {
        //汇款、金额、钱、转账、回款、红包、中奖
        List<String> list = new ArrayList<>();
        list.add("汇款");
        list.add("金额");
        list.add("钱");
        list.add("转账");
        list.add("回款");
        list.add("红包");
        list.add("中奖");
        if (TextUtils.isEmpty(text.trim())) {
            return false;
        } else {
            if (text.contains("汇款") || text.contains("金额") || text.contains("钱") || text.contains("转账") || text.contains("回款") || text.contains("红包") || text.contains("中奖")) {
                return true;
            }
            return false;
        }

    }

    /**
     * 消息是否包含提示关键字
     *
     * @param text
     * @return
     */
    public static boolean isFraudHintText(String text) {
        //找工作、招聘、招工、找活、包工
        List<String> list = new ArrayList<>();
        list.add("找工作");
        list.add("招聘");
        list.add("招工");
        list.add("找活");
        list.add("包工");
        if (TextUtils.isEmpty(text.trim())) {
            return false;
        } else {
            if (text.contains("找工作") || text.contains("招聘") || text.contains("招工") || text.contains("找活") || text.contains("包工")) {
                return true;
            }
            return false;
        }
    }


    public static String getHtmlColor000000(String str) {
        return "<font color='#000000'>" + str + "</font>";
    }

    public static String getHtmlColor666666(String str) {
        return "<font color='#666666'>" + str + "</font>";
    }

    /**
     * 跳转到微信
     */
    public static void OPenWXAPP(Activity activity) {
        try {
            Intent intent = new Intent(Intent.ACTION_MAIN);
            ComponentName cmp = new ComponentName("com.tencent.mm", "com.tencent.mm.ui.LauncherUI");
            intent.addCategory(Intent.CATEGORY_LAUNCHER);
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            intent.setComponent(cmp);
            activity.startActivity(intent);
        } catch (ActivityNotFoundException e) {
            CommonMethod.makeNoticeShort(activity, "检查到您手机没有安装微信，请安装后使用该功能", false);
        }
    }

    /**
     * 设置edittext小数位数
     *
     * @param editText
     * @param length        小数点前面位数
     * @param decimal_place 小数点后面位数
     */
    public static void setEditTextDecimalNumberLength(EditText editText, int length, int decimal_place) {
        if (0 != decimal_place) {
            editText.setFilters(new InputFilter[]{new DecimalInputFilter(length, decimal_place)});
            editText.setInputType(InputType.TYPE_CLASS_NUMBER | InputType.TYPE_NUMBER_FLAG_DECIMAL);
        } else {
            editText.setInputType(InputType.TYPE_CLASS_NUMBER);
        }
    }

    /**
     * 打开建工计算器
     *
     * @param context
     */
    public static void openCalender(Context context) {
        String appPackgeName = "com.glodon.constructioncalculators";
        //如果App已安装则直接打开
        if (checkAppInstalled(context, appPackgeName)) {
            Intent intent = context.getPackageManager().getLaunchIntentForPackage(appPackgeName);
            context.startActivity(intent);
        } else {
            //未安装则跳转到应用app
            try {
                Uri uri = Uri.parse("market://details?id=" + appPackgeName);
                Intent intent = new Intent(Intent.ACTION_VIEW, uri);
                intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                context.startActivity(intent);
            } catch (Exception e) {
//                        CommonMethod.makeNoticeLong(getApplicationContext(), "您的手机没有安装Android应用市场", CommonMethod.ERROR);
                e.printStackTrace();
            }
        }
    }


    private static boolean checkAppInstalled(Context context, String pkgName) {
        if (pkgName == null || pkgName.isEmpty()) {
            return false;
        }
        PackageInfo packageInfo;
        try {
            packageInfo = context.getPackageManager().getPackageInfo(pkgName, 0);
        } catch (PackageManager.NameNotFoundException e) {
            packageInfo = null;
            e.printStackTrace();
        }
        if (packageInfo == null) {
            return false;
        } else {
            return true;//true为安装了，false为未安装
        }
    }

    /**
     * 关闭Android 9。0使用非系统方法弹窗
     */
    public static void closeAndroidPDialog() {
        try {
            Class aClass = Class.forName("android.content.pm.PackageParser$Package");
            Constructor declaredConstructor = aClass.getDeclaredConstructor(String.class);
            declaredConstructor.setAccessible(true);
        } catch (Exception e) {
            e.printStackTrace();
        }
        try {
            Class cls = Class.forName("android.app.ActivityThread");
            Method declaredMethod = cls.getDeclaredMethod("currentActivityThread");
            declaredMethod.setAccessible(true);
            Object activityThread = declaredMethod.invoke(null);
            Field mHiddenApiWarningShown = cls.getDeclaredField("mHiddenApiWarningShown");
            mHiddenApiWarningShown.setAccessible(true);
            mHiddenApiWarningShown.setBoolean(activityThread, true);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 判断是否是浮点数
     *
     * @param str
     * @return
     */
    public static boolean isDouble(String str) {
        if (null == str || "".equals(str)) {
            return false;
        }
        Pattern pattern = Pattern.compile("^[-\\+]?[.\\d]*$");
        return pattern.matcher(str).matches();
    }

    /**
     * EditText获取焦点并显示软键盘
     */
    public static void showSoftInputFromWindow(Activity activity, EditText editText) {
        editText.setFocusable(true);
        editText.setFocusableInTouchMode(true);
        editText.requestFocus();
        //显示软键盘
//        activity.getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_ALWAYS_VISIBLE);
        //如果上面的代码没有弹出软键盘 可以使用下面另一种方式
        InputMethodManager imm = (InputMethodManager) activity.getSystemService(Context.INPUT_METHOD_SERVICE);
        imm.showSoftInput(editText, 0);
    }

    /**
     * 发送更新个人资料广播
     *
     * @pa activity
     */
    public static void sendBroadCastToUpdateInfo(BaseActivity activity) {
        DataUtil.UpdateLoginver(activity);
        Intent intent = new Intent();
        intent.setAction(WebSocketConstance.ACTION_UPDATEUSERINFO);
        activity.broadcastManager.sendBroadcast(intent);
    }

}
