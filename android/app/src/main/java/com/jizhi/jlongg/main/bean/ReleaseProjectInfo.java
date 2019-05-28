package com.jizhi.jlongg.main.bean;

import java.io.Serializable;
import java.util.List;

/**
 * 发布项目相关信息
 *
 * @author huChangSheng
 * @version 1.0
 * @time 2015-11-30 下午4:52:48
 */
public class ReleaseProjectInfo implements Serializable {
    private static final long serialVersionUID = 1L;
    /**
     * 项目id
     */
    private int pid;
    /**
     * 项目标题
     */
    private String protitle;
    /**
     * 项目名称
     */
    private String proname;
    /**
     * 项目名称
     */
    private String pro_name;
    /**
     * 是否需要垫资 1需要 0 不需要
     */
    private int prepay;
    /**
     * 工期
     */
    private int timelimit;
    /**
     * 项目描述
     */
    private String prodescrip;
    /**
     * 项目面积
     */
    private int total_area;
    /**
     * 项目所在城市
     */
    private Region region;
    /**
     * 详细地址
     */
    private String proaddress;
    /**
     * 1工友 2 工头
     */
    private int find_role = 1;
    /**
     * 项目类型
     */
    private Protype protype;
    /**
     * 项目过期时间
     */
    private int valid_date;
    /**
     * 福利
     */
    private List<String> welfares;
    /** ----------------------------------------------------------- */
    /**
     * 总包的价格
     */
    private String money;
    /**
     * 自己定位的坐标
     */
    private String prolocation;
    /**
     * 工种
     */
    private List<WorkType> classes;
    private String homeaver;
    private String protypeId;
    /**
     * 地址坐标
     * 1.纬度
     * 2.经度
     */
    private double[] pro_location;
    private boolean isSelected;
    private int tag_id;//包ID（调用关闭包接口 时使用）
    private int sync_id;//项目同步信息的ID（（调用关闭包接口 时使用））

    private String team_id;

    public int getTag_id() {
        return tag_id;
    }

    public void setTag_id(int tag_id) {
        this.tag_id = tag_id;
    }

    public int getSync_id() {
        return sync_id;
    }

    public void setSync_id(int sync_id) {
        this.sync_id = sync_id;
    }

    public String getProtypeId() {
        return protypeId;
    }

    public boolean isSelected() {
        return isSelected;
    }

    public void setSelected(boolean selected) {
        isSelected = selected;
    }

    public void setProtypeId(String protypeId) {
        this.protypeId = protypeId;
    }

    public String getHomeaver() {
        return homeaver;
    }

    public void setHomeaver(String homeaver) {
        this.homeaver = homeaver;
    }

    public int getPid() {
        return pid;
    }

    public void setPid(int pid) {
        this.pid = pid;
    }

    public String getProtitle() {
        return protitle;
    }

    public void setProtitle(String protitle) {
        this.protitle = protitle;
    }

    public int getPrepay() {
        return prepay;
    }

    public void setPrepay(int prepay) {
        this.prepay = prepay;
    }

    public int getTimelimit() {
        return timelimit;
    }

    public void setTimelimit(int timelimit) {
        this.timelimit = timelimit;
    }

    public String getProdescrip() {
        return prodescrip;
    }

    public void setProdescrip(String prodescrip) {
        this.prodescrip = prodescrip;
    }

    public int getTotal_area() {
        return total_area;
    }

    public void setTotal_area(int total_area) {
        this.total_area = total_area;
    }

    public Region getRegion() {
        return region;
    }

    public void setRegion(Region region) {
        this.region = region;
    }

    public String getProaddress() {
        return proaddress;
    }

    public void setProaddress(String proaddress) {
        this.proaddress = proaddress;
    }

    public int getFind_role() {
        return find_role;
    }

    public void setFind_role(int find_role) {
        this.find_role = find_role;
    }

    public static long getSerialversionuid() {
        return serialVersionUID;
    }

    public Protype getProtype() {
        return protype;
    }

    public void setProtype(Protype protype) {
        this.protype = protype;
    }

    public String getProname() {
        return proname;
    }

    public void setProname(String proname) {
        this.proname = proname;
    }

    public String getMoney() {
        return money;
    }

    public void setMoney(String money) {
        this.money = money;
    }

    public String getProlocation() {
        return prolocation;
    }

    public void setProlocation(String prolocation) {
        this.prolocation = prolocation;
    }

    public int getValid_date() {
        return valid_date;
    }

    public void setValid_date(int valid_date) {
        this.valid_date = valid_date;
    }

    public List<String> getWelfares() {
        return welfares;
    }

    public void setWelfares(List<String> welfares) {
        this.welfares = welfares;
    }

    public List<WorkType> getClasses() {
        return classes;
    }

    public void setClasses(List<WorkType> classes) {
        this.classes = classes;
    }

    // /** 工种 */
    // private List<WorkType> classes = new ArrayList<WorkType>();
    // /** 项目过期时间 */
    // private int valid_date;
    // /** 工价 */
    // private String pro_totalmoney;
    // /** 工种 */
    // private String worktypeId;
    // private long ctime;
    // /** 1.2分包 3 总包 **/
    private int cooperate_type = 3;

//     private String pro_location;
    // private String prolocation;

    public int getCooperate_type() {
        return cooperate_type;
    }

    public void setCooperate_type(int cooperate_type) {
        this.cooperate_type = cooperate_type;
    }

    public String getPro_name() {
        return pro_name;
    }

    public void setPro_name(String pro_name) {
        this.pro_name = pro_name;
    }

    public double[] getPro_location() {
        return pro_location;
    }

    public void setPro_location(double[] pro_location) {
        this.pro_location = pro_location;
    }

    public String getTeam_id() {
        return team_id;
    }

    public void setTeam_id(String team_id) {
        this.team_id = team_id;
    }
}
