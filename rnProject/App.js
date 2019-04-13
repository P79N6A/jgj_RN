/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 * @flow
 * @lint-ignore-every XPLATJSCOPYRIGHT1
 */

import React, { Component } from 'react';
import { Platform, StyleSheet, Text, View, Image, TouchableOpacity } from 'react-native';
import { StackNavigator, createStackNavigator, createBottomTabNavigator, createAppContainer } from 'react-navigation'

// import Tab from './src/pages/test/tab/tab'
// import TabPageTop from './src/pages/test/tabPageTop/tabPageTop'
// import Options from './src/pages/test/options/options'
// import Time from './src/pages/test/time/time'
// import Upload from './src/pages/test/uploadImg/uploadImg'
// import PullList from './src/pages/test/pullList/pullList'
// import Flatlist from './src/pages/test/flatList/flatList'
// import Inputbg from './src/pages/test/inputbg/inputbg'
// import Counter from './src/pages/test/counter/counter'

// import Personal from './src/pages/personal/personal'//个人中心
// import Mycard from './src/pages/personal/mycard'//我的找活名片
// import Readme from './src/pages/personal/readme'//谁看过我
// import Basic from './src/pages/personal/basic'//基本信息
// import Editname from './src/pages/personal/editname'//编辑姓名
// import Editsex from './src/pages/personal/editsex'//编辑性别
// import Nation from './src/pages/personal/nation'//选择名族
// import Workingyears from './src/pages/personal/workingyears'//选择工龄
// import Hometown from './src/pages/personal/hometown'//选择家乡地址
// import Hopeaddress from './src/pages/personal/hopeaddress'//期望工作地址
// import Workcate from './src/pages/personal/grworkcate'//选择工程类别
// import Typework from './src/pages/personal/grtypework'//选择工种
// import Mastery from './src/pages/personal/grmastery'//选择熟练度
// import Selfintrod from './src/pages/personal/selfintrod'//自我介绍
// import Addproject from './src/pages/personal/addproject'//新增项目经验
// import Vocationskill from './src/pages/personal/vocationskill'//职业技能
// import Addproress from './src/pages/personal/addproress'//新增项目所在城市
// import Preview from './src/pages/personal/preview'//名片预览
// import Proexper from './src/pages/personal/proexper'//项目经验

// import Recruit from './src/pages/recruit/recruit'//招聘页面
// import Doubt from './src/pages/recruit/doubt'//帮助中心
// import Cheat from './src/pages/recruit/cheat'//防骗指南
// import Jobhunting from './src/pages/recruit/jobhunting/jobhunting'//找工作
// import Authen from './src/pages/recruit/jobhunting/authen'//去认证
// import Authenpay from './src/pages/recruit/jobhunting/authenpay'//工人认证服务支付
// import Updateproject from './src/pages/personal/updateproject'//编辑项目经验
// import Addsikll from './src/pages/personal/addsikll'//正在添加职业技能证书
// import Updateskill from './src/pages/personal/updateskill'//正在编辑职业技能证书
// import Jobdetails from './src/pages/recruit/jobhunting/jobdetails'//招工详情
// import Lookworker from './src/pages/recruit/lookworker'//找工人
// import Zgrtype from './src/pages/recruit/zgrtype'//找工人-选择工种
// import Zgraddress from './src/pages/recruit/zgraddress'//找工人-项目所在地
// import Zgrlist from './src/pages/recruit/zgrlist'//找工人-列表
// import Myjob from './src/pages/recruit/myjob/myjob'//我的招工
// import Releasement from './src/pages/recruit/myjob/releasement'//发布招工
// import Releasetype from './src/pages/recruit/myjob/releasetype'//发布招工-选择工种
// import Releaseworktype from './src/pages/recruit/myjob/releaseworktype'//发布招工-选择工程类别
// import Releaseaddres from './src/pages/recruit/myjob/releaseaddres'//发布招工-项目所在地
// import Releasedetail from './src/pages/recruit/myjob/releasedetail'//发布招工-招聘详情
// import Mysuit from './src/pages/recruit/myjob/mysuit'//发布招工-可能合适你的人
// import Fbjobdetails from './src/pages/recruit/myjob/fbjobdetails'//发布招工-项目详情
// import Recomtact from './src/pages/recruit/myjob/recomtact'//系统推荐 or 联系过我
// import Hiringrecord from './src/pages/recruit/hiringrecord/hiringrecord'//招聘记录
// import Workershift from './src/pages/recruit/workershift/workershift'//工人 or 班组
// import Recruitplan from './src/pages/recruit/recruitplan/recruitplan'//招聘套餐
// import Buyalivecall from './src/pages/recruit/recruitplan/buyalivecall'//购买找活招工电话
// import Servicewater from './src/pages/recruit/recruitplan/servicewater'//服务流水
// import Joborder from './src/pages/recruit/recruitplan/joborder'//招聘订单
// import Commandos from './src/pages/recruit/commandos/commandos'//突击队
// import Tjdaddress from './src/pages/recruit/commandos/tjdaddress'//招突击队选择城市
// import Qualitycom from './src/pages/recruit/commandos/qualitycom'//优质突击队

// import Login from './src/pages/login/login'//登录

// ---4.0.2版本---
import Login from './src/pagelatestversion/login/login'//登录

import Recruit_homepage from './src/pagelatestversion/recruit_homepage/recruit_homepage'//找活招工首页
import Recruit_authen from './src/pagelatestversion/recruit_homepage/recruit_authen'//去认证
import Recruit_authenpay from './src/pagelatestversion/recruit_homepage/recruit_authenpay'//工人认证服务支付
import Recruit_doubt from './src/pagelatestversion/recruit_homepage/recruit_doubt'//帮助中心
import Recruit_cheat from './src/pagelatestversion/recruit_homepage/recruit_cheat'//防骗指南
import Recruit_jobdetails from './src/pagelatestversion/recruit_homepage/recruit_jobdetails'//招工详情

import Recruit_play from './src/pagelatestversion/recruit_plan/recruit_play'//招聘套餐
import Recruit_joborder from './src/pagelatestversion/recruit_plan/recruit_joborder'//招聘订单
import Recruit_servicewater from './src/pagelatestversion/recruit_plan/recruit_servicewater'//服务流水
import Recruit_buyalivecall from './src/pagelatestversion/recruit_plan/recruit_buyalivecall'//购买找活招工电话

import Workteam from './src/pagelatestversion/workteam/workteam'//工人 or 班组

import Personal_preview from './src/pagelatestversion/personal/personal_preview'//名片预览
import Personal_report from './src/pagelatestversion/personal/personal_report'//举报


import Lookingworker from './src/pagelatestversion/lookingworker/lookingworker'//找工人
import Lookingworker_list from './src/pagelatestversion/lookingworker/lookingworker_list'//找工人-列表

import Address from './src/pagelatestversion/address/address'//选择地址
import Typeworker from './src/pagelatestversion/typeworker/typeworker'//选择工种
import Typeproject from './src/pagelatestversion/typeproject/typeproject'//选择工程类别

import Myrecruit from './src/pagelatestversion/myrecruit/myrecruit'//发布招工
import Myrecruit_detail from './src/pagelatestversion/myrecruit/myrecruit_detail'//招聘信息详情填写
import Myrecruit_suit from './src/pagelatestversion/myrecruit/myrecruit_suit'//发布招工-可能合适你的人
import Myrecruit_detailshow from './src/pagelatestversion/myrecruit/myrecruit_detailshow'//发布招工-项目详情
import Myrecruit_address from './src/pagelatestversion/myrecruit/myrecruit_address'//发布招工-选择项目地址

import Myhistory from './src/pagelatestversion/myhistory/myhistory'//我的招聘
import My_contact from './src/pagelatestversion/myhistory/my_contact'//我的联系
import My_conllection from './src/pagelatestversion/myhistory/my_conllection'//我的收藏

//非导航页面注册
const HomeNavigator = createStackNavigator({
  // ---4.0.2版本---
  // 工人 or 班组
  Workteam: {
    screen: Workteam,
  },
  // 找活招工首页
  Recruit_homepage: {
    screen: Recruit_homepage,
  },
  // 我的招聘-发布招工
  Myrecruit: {
    screen: Myrecruit,
  },
  // 发布招工-可能合适你的人
  Myrecruit_suit: {
    screen: Myrecruit_suit,
  },
  // 招聘信息详情填写
  Myrecruit_detail: {
    screen: Myrecruit_detail,
  },
  // 发布招工-选择项目地址
  Myrecruit_address: {
    screen: Myrecruit_address,
  },
  // 我的招聘
  Myhistory: {
    screen: Myhistory,
  },
  // 我的收藏
  My_conllection: {
    screen: My_conllection,
  },
  // 我的联系
  My_contact: {
    screen: My_contact,
  },
  // 找工人
  Lookingworker: {
    screen: Lookingworker,
  },
  // 找工人-列表
  Lookingworker_list: {
    screen: Lookingworker_list,
  },
  // 举报
  Personal_report: {
    screen: Personal_report,
  },
  // 登录
  Login: {
    screen: Login,
  },
  // 发布招工-项目详情
  Myrecruit_detailshow: {
    screen: Myrecruit_detailshow,
  },
  
  // 选择工程类别
  Typeproject: {
    screen: Typeproject,
  },
  // 选择工种
  Typeworker: {
    screen: Typeworker,
  },
  // 选择地址
  Address: {
    screen: Address,
  },
  // 名片预览
  Personal_preview: {
    screen: Personal_preview,
  },
  
  // 招聘套餐
  Recruit_play: {
    screen: Recruit_play,
  },
  // 购买找活招工电话
  Recruit_buyalivecall: {
    screen: Recruit_buyalivecall,
  },
  // 服务流水
  Recruit_servicewater: {
    screen: Recruit_servicewater,
  },
  // 招聘订单
  Recruit_joborder: {
    screen: Recruit_joborder,
  },
  // 招工详情
  Recruit_jobdetails: {
    screen: Recruit_jobdetails,
  },
  // 去认证
  Recruit_authen: {
    screen: Recruit_authen,
  },
  // 工人认证服务支付
  Recruit_authenpay: {
    screen: Recruit_authenpay,
  },
  // 帮助中心
  Recruit_doubt: {
    screen: Recruit_doubt,
  },
  // 防骗指南
  Recruit_cheat: {
    screen: Recruit_cheat,
  },

  // ---------------
  // // 招聘页面
  // Recruit: {
  //   screen: Recruit,
  // },
  // // 登录
  // Login: {
  //   screen: Login,
  // },
  // // 突击队
  // Commandos: {
  //   screen: Commandos,
  // },
  // // 我的找活名片
  // Mycard: {
  //   screen: Mycard,
  // },
  // // 优质突击队
  // Qualitycom: {
  //   screen: Qualitycom,
  // },
  // // 招突击队选择城市
  // Tjdaddress: {
  //   screen: Tjdaddress,
  // },
  // // 招聘套餐
  // Recruitplan: {
  //   screen: Recruitplan,
  // },
  // // 服务流水
  // Servicewater: {
  //   screen: Servicewater,
  // },
  // // 招聘订单
  // Joborder: {
  //   screen: Joborder,
  // },
  // // 购买找活招工电话
  // Buyalivecall: {
  //   screen: Buyalivecall,
  // },
  // // 工人 or 班组
  // Workershift: {
  //   screen: Workershift,
  // },
  // // 招聘记录
  // Hiringrecord: {
  //   screen: Hiringrecord,
  // },
  // // 我的招工
  // Myjob: {
  //   screen: Myjob,
  // },
  // // 发布招工-招工详情
  // Fbjobdetails: {
  //   screen: Fbjobdetails,
  // },
  // // 系统推荐 or 联系过我
  // Recomtact: {
  //   screen: Recomtact,
  // },
  // // 发布招工-可能合适你的人
  // Mysuit: {
  //   screen: Mysuit,
  // },
  // // 招工详情
  // Jobdetails: {
  //   screen: Jobdetails,
  // },
  // // 发布招工-招聘详情
  // Releasedetail: {
  //   screen: Releasedetail,
  // },
  // // 发布招工
  // Releasement: {
  //   screen: Releasement,
  // },
  // // 发布招工-选择工种
  // Releasetype: {
  //   screen: Releasetype,
  // },
  // // 发布招工-选择工程类别
  // Releaseworktype: {
  //   screen: Releaseworktype,
  // },
  // // 发布招工-项目所在地
  // Releaseaddres: {
  //   screen: Releaseaddres,
  // },
  // // 找工人-列表
  // Zgrlist: {
  //   screen: Zgrlist,
  // },
  
  // // 找工作
  // Jobhunting: {
  //   screen: Jobhunting,
  // },
  // // 找工人
  // Lookworker: {
  //   screen: Lookworker,
  // },
  // // 找工人-选择工种
  // Zgrtype: {
  //   screen: Zgrtype,
  // },
  // // 找工人-项目所在地
  // Zgraddress: {
  //   screen: Zgraddress,
  // },
  // // 基本信息
  // Basic: {
  //   screen: Basic,
  // },
  // // 名片预览
  // Preview: {
  //   screen: Preview,
  // },
  // // 正在添加职业技能证书
  // Addsikll: {
  //   screen: Addsikll,
  // },
  // // 正在编辑职业技能证书
  // Updateskill: {
  //   screen: Updateskill,
  // },
  // // 项目经验
  // Proexper: {
  //   screen: Proexper,
  // },
  // // 编辑项目经验
  // Updateproject: {
  //   screen: Updateproject,
  // },
  // // 新增项目经验
  // Addproject: {
  //   screen: Addproject,
  // },
  // // 新增项目所在城市
  // Addproress: {
  //   screen: Addproress,
  // },
  // // 自我介绍
  // Selfintrod: {
  //   screen: Selfintrod,
  // },
  // // 职业技能
  // Vocationskill: {
  //   screen: Vocationskill,
  // },
  // // 选择工种
  // Typework: {
  //   screen: Typework,
  // },
  // // 选择熟练度
  // Mastery: {
  //   screen: Mastery,
  // },
  // // 选择工程类别
  // Workcate: {
  //   screen: Workcate,
  // },
  
  // // 期望工作地址
  // Hopeaddress: {
  //   screen: Hopeaddress,
  // },
  
  // // 选择工龄
  // Workingyears: {
  //   screen: Workingyears,
  // },
  // // 选择家乡地址
  // Hometown: {
  //   screen: Hometown,
  // },
  // // 编辑姓名
  // Editname: {
  //   screen: Editname,
  // },
  // // 选择名族
  // Nation: {
  //   screen: Nation,
  // },
  // // 编辑性别
  // Editsex: {
  //   screen: Editsex,
  // },
  // // 谁看过我
  // Readme: {
  //   screen: Readme,
  // },
  // // 去认证
  // Authen: {
  //   screen: Authen,
  // },
  // // 工人认证服务支付
  // Authenpay: {
  //   screen: Authenpay,
  // },
  // // 帮助中心
  // Doubt: {
  //   screen: Doubt,
  // },
  // // 防骗指南
  // Cheat: {
  //   screen: Cheat,
  // },

  
  
  // // 个人中心
  // Personal: {
  //   screen: Personal,
  //   navigationOptions: {
  //     header: null//通过 header:null去除界面的标题栏
  //   }
  // },
  // // Test
  // // 导航页面tab
  // Home: {
  //   screen: Tab,
  //   navigationOptions: {
  //     header: null//通过 header:null去除界面的标题栏
  //   }
  // },
  // TabPageTop: {
  //   screen: TabPageTop,
  //   navigationOptions: () => ({
  //     headerTitle: 'TabPageTop',//导航栏标题
  //     headerTitleStyle: {//导航栏文字样式
  //       color: '#101010',
  //       fontSize: 14,
  //       flex: 1,
  //       textAlign: 'center'//标题居中
  //     },
  //     headerRight: <View><Text style={styles.more}>更多</Text></View>,//保证左边返回箭头与文字不会影响标题居中
  //     headerBackTitle: '返回'//左侧返回箭头后面的文字
  //   })
  // },
  // Options: {
  //   screen: Options,
  //   navigationOptions: () => ({
  //     headerTitle: 'Options',//导航栏标题
  //     headerTitleStyle: {//导航栏文字样式
  //       color: '#101010',
  //       fontSize: 14,
  //       flex: 1,
  //       textAlign: 'center'//标题居中
  //     },
  //     headerRight: <View><Text style={styles.more}>更多</Text></View>,//保证左边返回箭头与文字不会影响标题居中
  //     headerBackTitle: '返回'//左侧返回箭头后面的文字
  //   })
  // },
  // Time: {
  //   screen: Time,
  //   navigationOptions: () => ({
  //     headerTitle: 'Time',//导航栏标题
  //     headerTitleStyle: {//导航栏文字样式
  //       color: '#101010',
  //       fontSize: 14,
  //       flex: 1,
  //       textAlign: 'center'//标题居中
  //     },
  //     headerRight: <View><Text style={styles.more}>更多</Text></View>,//保证左边返回箭头与文字不会影响标题居中
  //     headerBackTitle: '返回'//左侧返回箭头后面的文字
  //   })
  // },
  // Upload: {
  //   screen: Upload,
  //   navigationOptions: () => ({
  //     headerTitle: 'Upload',//导航栏标题
  //     headerTitleStyle: {//导航栏文字样式
  //       color: '#101010',
  //       fontSize: 14,
  //       flex: 1,
  //       textAlign: 'center'//标题居中
  //     },
  //     headerRight: <View><Text style={styles.more}>更多</Text></View>,//保证左边返回箭头与文字不会影响标题居中
  //     headerBackTitle: '返回'//左侧返回箭头后面的文字
  //   })
  // },
  // PullList: {
  //   screen: PullList,
  //   navigationOptions: () => ({
  //     headerTitle: 'PullList',//导航栏标题
  //     headerTitleStyle: {//导航栏文字样式
  //       color: '#101010',
  //       fontSize: 14,
  //       flex: 1,
  //       textAlign: 'center'//标题居中
  //     },
  //     headerRight: <View><Text style={styles.more}>更多</Text></View>,//保证左边返回箭头与文字不会影响标题居中
  //     headerBackTitle: '返回'//左侧返回箭头后面的文字
  //   })
  // },
  // Flatlist: {
  //   screen: Flatlist,
  //   navigationOptions: () => ({
  //     headerTitle: 'Flatlist',//导航栏标题
  //     headerTitleStyle: {//导航栏文字样式
  //       color: '#101010',
  //       fontSize: 14,
  //       flex: 1,
  //       textAlign: 'center'//标题居中
  //     },
  //     headerRight: <View><Text style={styles.more}>更多</Text></View>,//保证左边返回箭头与文字不会影响标题居中
  //     headerBackTitle: '返回'//左侧返回箭头后面的文字
  //   })
  // },
  // Inputbg: {
  //   screen: Inputbg,
  //   navigationOptions: () => ({
  //     headerTitle: 'Test',//导航栏标题
  //     headerTitleStyle: {//导航栏文字样式
  //       color: '#101010',
  //       fontSize: 14,
  //       flex: 1,
  //       textAlign: 'center'//标题居中
  //     },
  //     headerRight: <View><Text style={styles.more}>更多</Text></View>,//保证左边返回箭头与文字不会影响标题居中
  //     headerBackTitle: '返回'//左侧返回箭头后面的文字
  //   })
  // },
  // Counter: {
  //   screen: Counter,
  //   navigationOptions: () => ({
  //     headerTitle: '计数器',//导航栏标题
  //     headerTitleStyle: {//导航栏文字样式
  //       color: '#101010',
  //       fontSize: 14,
  //       flex: 1,
  //       textAlign: 'center'//标题居中
  //     },
  //     headerRight: <View><Text style={styles.more}>更多</Text></View>,//保证左边返回箭头与文字不会影响标题居中
  //     headerBackTitle: '返回'//左侧返回箭头后面的文字
  //   })
  // },
})
const HomeStack = createAppContainer(HomeNavigator)

export default class App extends Component {
  render() {
    return (
      <HomeStack />
    );
  }
}

const styles = StyleSheet.create({
  more: {
    color: '#eb4e4e',
    marginRight: 10,
    fontWeight: '400',
  }
})

