package com.jizhi.jlongg.main.bean;

/**
 * 同步项目
 *
 * @author xuj
 * @version 1.0
 * @time 2016年10月8日 18:50:47
 */
public class SynchMerge {
    /* 源项目名 */
    private String from_pro_name;
    /* 	源讨论组名 */
    private String from_team_name;
    /* 目标项目名 */
    private String to_pro_name;


    public SynchMerge() {

    }

    public SynchMerge(String from_pro_name, String from_team_name, String to_pro_name) {
        this.from_pro_name = from_pro_name;
        this.from_team_name = from_team_name;
        this.to_pro_name = to_pro_name;
    }

    public String getFrom_pro_name() {
        return from_pro_name;
    }

    public void setFrom_pro_name(String from_pro_name) {
        this.from_pro_name = from_pro_name;
    }

    public String getFrom_team_name() {
        return from_team_name;
    }

    public void setFrom_team_name(String from_team_name) {
        this.from_team_name = from_team_name;
    }

    public String getTo_pro_name() {
        return to_pro_name;
    }

    public void setTo_pro_name(String to_pro_name) {
        this.to_pro_name = to_pro_name;
    }
}
