package com.hcs.uclient.utils;

/**
 * CName:节日
 * User: hcs
 * Date: 2016-07-07
 * Time: 17:41
 */
public class Festival {


    // 公历节日 *表示放假日
    public String sFtv[] = {"元旦", // 0 1月1日
            "情人节", // 6 2月14日
            "妇女节", // 15 3月8日
            "劳动节", // 33 5月1日
            "青年节", // 35 5月4日
            "儿童节", // 46 6月1日
            "建党节", // 57 7月1日
            "建军节", // 63 8月1日
            "教师节", // 71 9月10日
            "国庆节", // 78 10月1日
            "圣诞节", // 113 12月25日

    };
    // 农历节日
    public String lFtv[] = {"春节", // 0 正月初一
            "元宵节", // 1 正月十五
            "端午节", // 2 五月初五
            "七夕节", // 3 七月初七
            "中秋节", // 4 八月十五
            "重阳节", // 5 九月初九
            "除夕", // 6 腊月最后一天
            "腊八节", // 7 腊月初八
            "小年", // 8 腊月二十三、二十四
    };

    // 返回公历节日.
    public String showSFtv(int month, int day) {
        if (month == 1 && day == 1)
            return sFtv[0];
        else if (month == 2 && day == 14)
            return sFtv[1];
        else if (month == 3 && day == 8)
            return sFtv[2];
        else if (month == 5 && day == 1)
            return sFtv[3];
        else if (month == 5 && day == 3)
            return sFtv[4];
        else if (month == 5 && day == 4)
            return sFtv[5];
        else if (month == 6 && day == 1)
            return sFtv[6];
        else if (month == 7 && day == 1)
            return sFtv[7];
        else if (month == 9 && day == 10)
            return sFtv[8];
        else if (month == 10 && day == 1)
            return sFtv[9];
        else if (month == 12 && day == 25)
            return sFtv[10];
        else
            return "";// 不是节日则返回"祝你天天开心!".

    }


    // 返回农历节日.
    public String showLFtv(int month, int day, int dayOfmonth) {
        if (month == 1 && day == 1)
            return lFtv[0];// 春节
        else if (month == 1 && day == 15)
            return lFtv[1];// 正月十五
        else if (month == 5 && day == 5)// 端午节
            return lFtv[2];
        else if (month == 7 && day == 7)// 七夕节
            return lFtv[3];
        else if (month == 8 && day == 15)// 中秋节
            return lFtv[4];
        else if (month == 9 && day == 9)// 重阳节
            return lFtv[5];
        else if (month == 12 && day == 29 && dayOfmonth == 29)
            return lFtv[6];// 判断农历最后一个月是否是29天,是则这一天显示除夕.
        else if (month == 12 && day == 30 && dayOfmonth == 30)
            return lFtv[6];// 判断农历最后一个月是否是30天,是则这一天显示除夕.
        else if (month == 12 && day == 8)
            return lFtv[7];// 腊八节
        else if (month == 12 && day == 23)
            return lFtv[8];// 小年

        return "";
    }
}
