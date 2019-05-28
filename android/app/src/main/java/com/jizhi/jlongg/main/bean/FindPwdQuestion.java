package com.jizhi.jlongg.main.bean;

import java.util.ArrayList;

/**
 * Created by Administrator on 2018-6-11.
 */

public class FindPwdQuestion {
    /**
     * 1验证通过，0不通过
     */
    private int is_pass;
    /**
     * 问题3 Token
     */
    private String token;
    /**
     * 问题标题
     */
    private String ques_title;
    /**
     * 问题列表
     */
    private ArrayList<FindPwdQuestion> answer_list;
    /**
     * 选项名称
     */
    private String options;
    /**
     * 选项id
     */
    private String cid;
    /**
     * true表示已选中
     */
    private boolean is_selected;

    public FindPwdQuestion(String options, String cid) {
        this.options = options;
        this.cid = cid;
    }

    public FindPwdQuestion() {
    }

    public String getOptions() {
        return options;
    }

    public void setOptions(String options) {
        this.options = options;
    }

    public String getCid() {
        return cid;
    }

    public void setCid(String cid) {
        this.cid = cid;
    }

    public boolean is_selected() {
        return is_selected;
    }

    public void setIs_selected(boolean is_selected) {
        this.is_selected = is_selected;
    }

    public String getQues_title() {
        return ques_title;
    }

    public void setQues_title(String ques_title) {
        this.ques_title = ques_title;
    }

    public ArrayList<FindPwdQuestion> getAnswer_list() {
        return answer_list;
    }

    public void setAnswer_list(ArrayList<FindPwdQuestion> answer_list) {
        this.answer_list = answer_list;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public int getIs_pass() {
        return is_pass;
    }

    public void setIs_pass(int is_pass) {
        this.is_pass = is_pass;
    }
}
