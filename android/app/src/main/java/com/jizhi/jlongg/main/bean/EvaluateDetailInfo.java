package com.jizhi.jlongg.main.bean;

import java.util.List;

/**
 * 评价人详情信息
 */

public class EvaluateDetailInfo extends BaseNetBean {
    /**
     * 评价日期
     */
    private String pub_date;
    /**
     * 评价内容
     */
    private String content;
    /**
     * 评价人信息
     */
    private UserInfo user_info;
    /**
     * 评价标签
     */
    private List<EvaluateTag> tag_list;

    public String getPub_date() {
        return pub_date;
    }

    public void setPub_date(String pub_date) {
        this.pub_date = pub_date;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public UserInfo getUser_info() {
        return user_info;
    }

    public void setUser_info(UserInfo user_info) {
        this.user_info = user_info;
    }

    public List<EvaluateTag> getTag_list() {
        return tag_list;
    }

    public void setTag_list(List<EvaluateTag> tag_list) {
        this.tag_list = tag_list;
    }
}
