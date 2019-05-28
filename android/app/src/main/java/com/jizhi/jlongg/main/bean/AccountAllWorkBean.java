package com.jizhi.jlongg.main.bean;

import com.jizhi.jlongg.main.adpter.NewAllAccountAdapter;

import java.io.Serializable;
import java.util.List;

/**
 * 包工记账分享实体类
 */
public class AccountAllWorkBean implements Serializable {
    private int id;
    private String sub_pro_name; //分项目名称
    private String units="平方米"; //包工数量单位名称
    private String set_unitprice; //单价
    private String sub_count;//数量
    private int type=NewAllAccountAdapter.TYPE_CENTER;
    //总价
    private String price;
    private String roleName;
    private int uid;
    private String date;
    private String pro_name;
    private int pid;
    // 开工时间, 完工时间
    public int startWorkTime, endWorkTime;
    private String remark;
    private List<ImageItem> imageItems;
    private String rightValues;
    // 1:表示承包；2:表示分包
    private int contractor_type= 1;
    //是否可以点击
    private boolean clickRole;
    //是否可以点击
    private boolean clickProject;
    //是否隐藏选中记账对象箭头
    private boolean hintRoleArrow;
    //是否隐藏选中项目对象箭头
    private boolean hintProjectArrow;
    private int tpl_id;
    //聊天工头进入记账
    private boolean isTOMsgFM;

    public int getTpl_id() {
        return tpl_id;
    }

    public void setTpl_id(int tpl_id) {
        this.tpl_id = tpl_id;
    }

    public AccountAllWorkBean(int type){
        this.type=type;

    }
    public AccountAllWorkBean(){

    }
    public String getPrice() {
        return price;
    }

    public void setPrice(String price) {
        this.price = price;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getSub_pro_name() {
        return sub_pro_name;
    }

    public void setSub_pro_name(String sub_pro_name) {
        this.sub_pro_name = sub_pro_name;
    }

    public String getUnits() {
        return units;
    }

    public void setUnits(String units) {
        this.units = units;
    }

    public String getSet_unitprice() {
        return set_unitprice;
    }

    public void setSet_unitprice(String set_unitprice) {
        this.set_unitprice = set_unitprice;
    }

    public String getSub_count() {
        return sub_count;
    }

    public void setSub_count(String sub_count) {
        this.sub_count = sub_count;
    }

    public int getType() {
        return type;
    }

    public void setType(int type) {
        this.type = type;
    }

    public String getRoleName() {
        return roleName;
    }

    public void setRoleName(String roleName) {
        this.roleName = roleName;
    }

    public int getUid() {
        return uid;
    }

    public void setUid(int uid) {
        this.uid = uid;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public String getPro_name() {
        return pro_name;
    }

    public void setPro_name(String pro_name) {
        this.pro_name = pro_name;
    }

    public int getStartWorkTime() {
        return startWorkTime;
    }

    public void setStartWorkTime(int startWorkTime) {
        this.startWorkTime = startWorkTime;
    }

    public int getEndWorkTime() {
        return endWorkTime;
    }

    public void setEndWorkTime(int endWorkTime) {
        this.endWorkTime = endWorkTime;
    }

    public String getRemark() {
        return remark;
    }

    public void setRemark(String remark) {
        this.remark = remark;
    }

    public List<ImageItem> getImageItems() {
        return imageItems;
    }

    public void setImageItems(List<ImageItem> imageItems) {
        this.imageItems = imageItems;
    }

    public int getPid() {
        return pid;
    }

    public void setPid(int pid) {
        this.pid = pid;
    }

    public String getRightValues() {
        return rightValues;
    }

    public void setRightValues(String rightValues) {
        this.rightValues = rightValues;
    }

    public int getContractor_type() {
        return contractor_type;
    }

    public void setContractor_type(int contractor_type) {
        this.contractor_type = contractor_type;
    }

    public boolean isClickRole() {
        return clickRole;
    }

    public void setClickRole(boolean clickRole) {
        this.clickRole = clickRole;
    }

    public boolean isClickProject() {
        return clickProject;
    }

    public void setClickProject(boolean clickProject) {
        this.clickProject = clickProject;
    }

    public boolean isHintRoleArrow() {
        return hintRoleArrow;
    }

    public void setHintRoleArrow(boolean hintRoleArrow) {
        this.hintRoleArrow = hintRoleArrow;
    }

    public boolean isHintProjectArrow() {
        return hintProjectArrow;
    }

    public void setHintProjectArrow(boolean hintProjectArrow) {
        this.hintProjectArrow = hintProjectArrow;
    }

    public boolean isTOMsgFM() {
        return isTOMsgFM;
    }

    public void setTOMsgFM(boolean TOMsgFM) {
        isTOMsgFM = TOMsgFM;
    }
}
