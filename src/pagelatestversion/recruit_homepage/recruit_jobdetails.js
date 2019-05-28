/*
 * @Author: mikey.zhaopeng 
 * @Date: 2019-03-29 16:14:41 
 * @Last Modified by: mikey.zhaopeng
 * @Last Modified time: 2019-04-18 14:45:07
 * Module:招工详情
 */

import React, { Component } from 'react'
import {
    StyleSheet, Text, View, TouchableOpacity, Platform,
    Image, ScrollView, NativeModules,
    DeviceEventEmitter,
    BackHandler, Modal
} from 'react-native';
import Icon from "react-native-vector-icons/iconfont";
import fetchFun from '../../fetch/fetch'
import AlertUser from '../../component/alertuser'
import ImageCom from '../../component/imagecom';
import { createChat } from '../../utils/index'
import { Global } from '@jest/types';
import Alert from '../../component/alert'
import LinearGradient from 'react-native-linear-gradient';
import sha1 from 'sha1';
import Thelabel from '../../component/thelabel'
import Info from '../recruit_homepage/detail'
import { openWebView } from '../../utils'
import InfoModal from '../../component/InfoModal'

export default class jobdetails extends Component {
    constructor(props) {
        super(props)
        this.state = {
            item: {},
            is_subscibe: true,//是否已订阅

            // ----------实名or认证、突击弹框----------
            ifOpenAlert: false,//是否打开弹框
            param: '',//实名or认证、突击
            // ---------------------------------------

            alertValue: '',//弹框内容
            ifError: true,//弹框图标为正确类型还是错误类型
            openAlert: false,//控制弹框关闭打开

            ifrender: false,

            ifshowll: 1,//是否显示聊一聊按钮
            showInfoModal: false
        }
    }
    // 顶部导航
    static navigationOptions = ({ navigation, screenProps }) => ({
        header: null, gesturesEnabled: false,
    });
    componentDidMount() {
        this.getlist()
        // 底部导航控制
        this.bottomTab()
        if (this.props.navigation.getParam('nameTo')) {
            // android返回start==================================
            BackHandler.addEventListener('hardwareBackPress', this.onBackButtonPressAndroid);
        }
    }
    componentWillUnmount() {
        if (this.props.navigation.getParam('nameTo')) {
            BackHandler.removeEventListener('hardwareBackPress', this.onBackButtonPressAndroid);
        }
    }
    onBackButtonPressAndroid = () => {
        if (this.props.navigation.getParam('nameTo')) {
            if (this.props.navigation.isFocused()) {
                if (this.lastBackPressed && this.lastBackPressed + 2000 >= Date.now()) {
                    //最近2秒内按过back键，可以退出应用。
                    return false;
                }
                this.lastBackPressed = Date.now();
                this.props.navigation.goBack(), DeviceEventEmitter.emit("EventType", param)
                return true;
            }
        }
    }
    // android返回end====================================================
    bottomTab() {
        if (Platform.OS == 'android' && GLOBAL.client_type == 'person') {//android个人端
            NativeModules.MyNativeModule.footerController('{state:"hide"}');//调用原生方法
        }
        if (Platform.OS == 'ios' && GLOBAL.client_type == 'person') {//android个人端
            NativeModules.JGJRecruitmentController.footerController({ state: "hide" });//调用原生方法
        }
    }
    getlist() {
        fetchFun.load({
            url: 'jlwork/prodetailactive',
            data: {
                pid: this.props.navigation.getParam('pid'),
                contacted: '0',
                kind: 'recruit'
            },
            success: (res) => {
                console.log('---招工详情---1', res)
                let ifshowll = 1//显示
                if (res.is_collect == 1) {//采集
                    if (res.is_reg != 1) {//未注册
                        ifshowll = 0//不显示
                    }
                }
                GLOBAL.otherUser.uid = res.uid,
                    GLOBAL.otherUser.pid = res.pid,
                    GLOBAL.otherUser.role_type = res.role_type,
                    GLOBAL.otherUser.lng = res.pro_location[0],
                    GLOBAL.otherUser.lat = res.pro_location[1],
                    GLOBAL.otherUser.city_name = res.city_name,
                    GLOBAL.otherUser.province_name = res.province_name,
                    GLOBAL.otherUser.pro_address = res.pro_address,
                    this.setState({
                        item: res,
                        is_subscibe: res.is_subscibe == '1' ? true : false,
                        ifrender: true,
                        ifshowll: ifshowll
                    })
            }
        });
    }
    // media\/images\/proImgs\/20190317\/222050545982.jpeg
    render() {
        let item = this.state.item
        return (
            <View style={styles.main}>
                {/* 导航条 */}
                <View style={{
                    height: 48, backgroundColor: '#FAFAFA', position: 'relative',
                    flexDirection: 'row', alignItems: 'center', justifyContent: "space-between",
                    borderBottomWidth: 1, borderBottomColor: '#ebebeb'
                }}>
                    <TouchableOpacity activeOpacity={.7} style={{ flexDirection: 'row', alignItems: 'center', marginLeft: 10, marginBottom: 1, width: '25%' }}
                        onPress={() => this.gobackFun()}>
                        <Icon style={{ marginRight: 3 }} name="l-arrow" size={19} color="#eb4e4e" />
                        <Text style={{ marginRight: 10, color: '#eb4e4e', fontWeight: '400', fontSize: 17 }}>返回</Text>
                    </TouchableOpacity>
                    <View style={{ flex: 1, flexDirection: 'row', justifyContent: 'center', alignItems: 'center' }}>
                        <Text style={{ fontSize: 17, color: '#000000', fontWeight: '400', }}>详情</Text>
                    </View>
                    <TouchableOpacity activeOpacity={.7}
                        onPress={() => this.share()}
                        style={{
                            width: '25%', height: '100%', marginRight: 10, flexDirection: 'row',
                            alignItems: 'center', justifyContent: 'flex-end'
                        }}>
                        <Text style={{ fontSize: 17, color: '#EB4E4E', fontWeight: '400', }}>分享</Text>
                    </TouchableOpacity>
                </View>

                {
                    this.state.ifrender ? (
                        item ?
                            <Info
                                ifshowll={this.state.ifshowll}
                                item={item}
                                alertFun={this.alertFun.bind(this)}//实名认证标签点击事件
                                acquaintance={this.acquaintance.bind(this)}//认识的朋友
                                call_button={this.call_button.bind(this)}//拨打电话
                                createChat={this.createChat.bind(this)}//和他聊聊
                                reportFun={this.reportFun.bind(this)}//我要举报
                                copyWechatNumber={this.copyWechatNumber.bind(this)}//复制微信号
                                startActivityFromJS={this.startActivityFromJS.bind(this)}//如何关注
                                style={{
                                    flex: 1, backgroundColor: '#fff'
                                }}
                            /> :
                            null
                    ) : false
                }


                {/* 按钮 */}
                {
                    this.state.ifrender ? (


                        <View style={{
                            position: 'relative', bottom: 0, height: 66, width: '100%',
                            backgroundColor: "#fff", padding: 11, flexDirection: 'row',
                            borderTopWidth: .5, borderTopColor: '#cccccc'
                        }}>
                            <View style={{
                                flexDirection: 'row', alignItems: 'center', justifyContent: 'center',
                                marginRight: 11
                            }}>
                                <TouchableOpacity activeOpacity={.7}
                                    onPress={() => this.alertFun('dy')}
                                    style={{
                                    }}>
                                    {
                                        item.uid == GLOBAL.userinfo.uid ? false : (
                                            <View style={{ flexDirection: 'row', justifyContent: 'center', paddingLeft: 30, paddingRight: 30 }}>
                                                {/* <Icon name="dingyue" size={23} color="#000000" /> */}
                                                {
                                                    this.state.is_subscibe ? (
                                                        // <Icon name="dingyue" size={23} color="#eb4e4e" />
                                                        <Image style={{ width: 19, height: 22 }} source={require('../../assets/recruit/yidingyue.png')} ></Image>
                                                    ) : (
                                                            <Image style={{ width: 19, height: 22 }} source={require('../../assets/recruit/dingyue.png')} ></Image>
                                                            // <Icon name="dingyue" size={23} color="#000000" />
                                                        )
                                                }
                                            </View>
                                        )
                                    }
                                    {
                                        item.uid == GLOBAL.userinfo.uid ? false : (
                                            this.state.is_subscibe ? (
                                                <Text style={{ color: '#eb4e4e', fontSize: 12, textAlign: 'center', width: 90 }}>已订阅他的招工</Text>
                                            ) : (
                                                    <Text style={{ color: '#000000', fontSize: 12, textAlign: 'center', width: 90 }}>订阅他的招工</Text>
                                                )
                                        )
                                    }

                                </TouchableOpacity>
                                {
                                    this.state.ifshowll == 1 ? (
                                        <TouchableOpacity activeOpacity={.7}
                                            onPress={() => this.createChat()}
                                            style={{
                                                // width: '40%'
                                            }}>
                                            <View style={{ flexDirection: 'row', justifyContent: 'center', paddingLeft: 40, paddingRight: 40 }}>
                                                <Icon name="liaoliao" size={25} color="#000000" />
                                            </View>
                                            <Text style={{ color: '#000000', fontSize: 12, textAlign: 'center' }}>和他聊聊</Text>
                                        </TouchableOpacity>
                                    ) : false
                                }
                            </View>
                            <TouchableOpacity activeOpacity={.7}
                                onPress={() => this.call_button()}
                                style={{
                                    flexDirection: 'row', alignItems: 'center', justifyContent: 'center', flex: 1,
                                    backgroundColor: 'rgb(235, 78, 78)', borderRadius: 4, position: 'relative',
                                }}>
                                <Text style={{ color: '#fff', fontSize: 20 }}>拨打电话</Text>
                            </TouchableOpacity>
                        </View>
                    ) : false
                }
                {/* 弹框 */}
                <AlertUser
                    useup={this.useup.bind(this)}//status==1免费套餐已经用完
                    shopping={this.shopping.bind(this)}//status==2购买套餐
                    shareFriend={this.shareFriend.bind(this)}//status==3分享
                    shareFriendEnd={this.shareFriendEnd.bind(this)}//分享成功，获得拨打电话次数
                    gows={this.gows.bind(this)}//去完善资料
                    ifOpenAlert={this.state.ifOpenAlert}
                    alertFunr={this.alertFunr.bind(this)}
                    param={this.state.param}
                    is_subscibe={this.state.is_subscibe}
                    name={item.fmname}
                    subscFun={this.subscFun.bind(this)} />

                <Alert
                    alertValue={this.state.alertValue}
                    ifError={this.state.ifError}
                    openAlert={this.state.openAlert}
                    closeAlertFun={this.closeAlertFun.bind(this)}
                    openAlertFun={this.openAlertFun.bind(this)}
                />

                <InfoModal
                    visible={this.state.showInfoModal}
                    cancelFn={() => this.toggleShowInfoModal()}
                    sureFn={() => { openWebView('my/info?perfect=1'); this.toggleShowInfoModal() }}
                />
            </View>
        )
    }
    // 认识的朋友this.state.item.friend_result
    acquaintance() {
        if (Platform.OS == 'android' && GLOBAL.client_type == 'person') {//android个人端
            NativeModules.MyNativeModule.openWebView('friend');//调用原生方法
        }
    }
    openAlertFun() {
        this.setState({
            openAlert: !this.state.openAlert
        })
    }
    closeAlertFun() {
        this.setState({
            openAlert: false
        })
    }
    gobackFun() {
        if (this.props.navigation.getParam('nameTo')) {
            DeviceEventEmitter.emit("EventType", param)
        }
        this.props.navigation.goBack()
    }
    // ----------实名or认证、突击弹框----------
    alertFun(e) {
        this.setState({
            ifOpenAlert: !this.state.ifOpenAlert,
            param: e,
        })
    }
    alertFunr() {
        this.setState({
            ifOpenAlert: false
        })
    }
    // --------------------------------------
    // 我要举报
    reportFun() {
        if (GLOBAL.userinfo.is_info == 0) {//未完善资料
            this.setState({
                ifOpenAlert: !this.state.ifOpenAlert,
                param: 'wszlandsmrz'
            })
        } else {
            //已实名
            if (GLOBAL.userinfo.verified == 3) {
                this.props.navigation.navigate('Recruit_report', { uid: [this.props.navigation.getParam('pid')] })
            } else {
                this.setState({
                    ifOpenAlert: !this.state.ifOpenAlert,
                    param: 'smrz'
                })
            }
        }
    }
    // 订阅
    subscFun() {
        this.setState({
            ifOpenAlert: false
        })
        fetchFun.load({
            url: 'jlwork/worksubscibe',
            data: {
                // pid: this.props.navigation.getParam('pid'),
                // contacted: '0'
                uid: GLOBAL.userinfo.uid,//当前用户UID
                buid: GLOBAL.otherUser.uid,//被订阅用户UID
                type: this.state.is_subscibe ? '0' : '1',//1为订阅,0为取消订阅(默认为1)
                kind: 'recruit'
            },
            success: (res) => {
                console.log('---订阅---', res)
                if (this.state.is_subscibe) {
                    this.setState({
                        alertValue: '取消订阅成功',
                        openAlert: true,
                        is_subscibe: !this.state.is_subscibe
                    })
                } else {
                    this.setState({
                        alertValue: '订阅成功',
                        openAlert: true,
                        is_subscibe: !this.state.is_subscibe
                    })
                }
            }
        });
    }
    // 拨打电话
    call_button() {
        if (GLOBAL.userinfo.is_info == 0) {//未完善资料
            this.setState({
                ifOpenAlert: !this.state.ifOpenAlert,
                param: 'wszlandsmrz-call'
            })
        } else {
            if (GLOBAL.userinfo.verified == 3) {//已实名
                fetchFun.load({
                    url: 'jlforemanwork/tocontactbysnapshot',
                    data: {
                        uid: this.state.item.uid,
                        pid: this.state.item.pid,
                        // role_type: this.state.item.role_type,
                        kind: 'recruit'
                    },
                    success: (res) => {
                        console.log('---拨打电话---', res)
                        if (res.status == 0) {//正常返回电话
                            if (Platform.OS == 'android' && GLOBAL.client_type == 'person') {//android个人端
                                NativeModules.MyNativeModule.appCall(res.telephone);//调用原生方法
                            }
                            if (Platform.OS == 'ios' && GLOBAL.client_type == 'person') {//android个人端
                                NativeModules.JGJRecruitmentController.appCall(res.telephone);//调用原生方法
                            }
                        } else if (res.status == 1) {//免费套餐已经用完
                            this.setState({
                                ifOpenAlert: !this.state.ifOpenAlert,
                                param: 'status1'
                            })
                        } else if (res.status == 2) {//购买过的套餐已经用完
                            this.setState({
                                ifOpenAlert: !this.state.ifOpenAlert,
                                param: 'status2'
                            })
                        } else if (res.status == 3) {//可以获取分享次数
                            this.setState({
                                ifOpenAlert: !this.state.ifOpenAlert,
                                param: 'status3'
                            })
                        }
                    }
                });
            } else {
                this.setState({
                    ifOpenAlert: !this.state.ifOpenAlert,
                    param: 'smrz-call'
                })
            }
        }

    }
    // 去完善资料
    gows() {
        this.setState({
            ifOpenAlert: !this.state.ifOpenAlert,
        })
        if (Platform.OS == 'android' && GLOBAL.client_type == 'person') {//android个人端
            NativeModules.MyNativeModule.openWebView('my/info?perfect=1&verified=1');//调用原生方法
        }
        if (Platform.OS == 'ios' && GLOBAL.client_type == 'person') {//ios个人端
            NativeModules.JGJRecruitmentController.openWebView('my/info?perfect=1&verified=1');//调用原生方法
        }
    }
    // 复制微信号
    copyWechatNumber() {
        if (Platform.OS == 'android' && GLOBAL.client_type == 'person') {//android个人端
            NativeModules.MyNativeModule.copyWechatNumber(this.state.item.wechat_customer);//调用原生方法
        }
        if (Platform.OS == 'ios' && GLOBAL.client_type == 'person') {//android个人端
            NativeModules.JGJRecruitmentController.copyWechatNumber(this.state.item.wechat_customer);//调用原生方法
        }
    }
    // 如何关注
    startActivityFromJS() {
        if (Platform.OS == 'android' && GLOBAL.client_type == 'person') {//android个人端
            NativeModules.MyNativeModule.openWebView(GLOBAL.pageAddress);//调用原生方法
        }
        if (Platform.OS == 'ios' && GLOBAL.client_type == 'person') {//android个人端
            NativeModules.JGJRecruitmentController.openWebView(GLOBAL.pageAddress);//调用原生方法
        }
    }
    // 查看位置
    addressShowFun(pro_location) {
        if (Platform.OS == 'android' && GLOBAL.client_type == 'person') {//android个人端
            NativeModules.MyNativeModule.startActivityFromJS('com.jizhi.jlongg.main.activity.map.LookAddrActivity', pro_location.join(','));//调用原生方法
        }
        if (Platform.OS == 'ios' && GLOBAL.client_type == 'person') {//android个人端
            NativeModules.JGJRecruitmentController.startActivityFromJS('com.jizhi.jlongg.main.activity.map.LookAddrActivity', pro_location.join(','));//调用原生方法
        }
    }
    //招工详情-直接分享
    share() {
        let shareSuid = "";
        if (this.state.item && this.state.item.uid) {
            shareSuid = "&suid=" + this.state.item.uid;
        }
        let imgUrl = ''
        if (this.state.item.share.wxshare_img.indexOf('http://api.yzgong.com') != -1) {
            imgUrl = this.state.item.share.wxshare_img.replace('http://api.yzgong.com', `${GLOBAL.shareHttp}`)
        } else {
            imgUrl = this.state.item.share.wxshare_img
        }
        // let shareData = {
        //     appId: GLOBAL.miniJobAppId,
        //     describe: this.state.item.share.wxshare_desc,
        //     imgUrl: imgUrl,
        //     path: `/pages/job/work/info?pid=${this.state.item.pid}&share=1${shareSuid}`,
        //     title: this.state.item.pro_title,
        //     topdisplay: 0,
        //     type: 0,
        //     typeImg: '',
        //     // url:this.state.item.share.wxshare_uri,
        //     url: `http://nm.test.jgjapp.com/work/${this.state.item.pid}?plat=${this.state.item.pid}person`,
        //     wxMiniDrawable: 0,
        //     state: 0,
        // }
        let shareData = {
            type: 0,
            title: this.state.item.pro_title,
            url: `${GLOBAL.server}work/${this.state.item.pid}?plat=${this.state.item.pid}person`,//详情
            imgUrl: imgUrl,
            describe: this.state.item.share.wxshare_desc,
            wxMini: {
                appId: GLOBAL.miniJobAppId,
                path: `/pages/job/work/info?pid=${this.state.item.pid}&share=1${shareSuid}`,//详情
            }
        }

        console.log(shareData)
        if (Platform.OS == 'android' && GLOBAL.client_type == 'person') {//android个人端
            NativeModules.MyNativeModule.showShareMenu(JSON.stringify(shareData), (result) => {
                console.log(result)
                this.getPhoneNum()// 获取拨打电话次数
            });//调用原生方法
        }
        if (Platform.OS == 'ios' && GLOBAL.client_type == 'person') {//android个人端
            NativeModules.JGJRecruitmentController.showShareMenu(shareData, (result) => {
                console.log(result)
                this.getPhoneNum()// 获取拨打电话次数
            });//调用原生方法
        }
    }
    toggleShowInfoModal() {
        let { showInfoModal } = this.state
        this.setState({
            showInfoModal: !showInfoModal
        })
    }
    // 和他聊聊
    async createChat() {
        let { item } = this.state
        // if (!isUserInfo(this.props, {perfect: true})) {
        // 	return false;
        // }
        if (GLOBAL.userinfo.is_info == 0) {//未完善资料
            this.toggleShowInfoModal()
            return
        }
        let values = await fetchFun.load({
            newApi: true,
            url: 'user/get-work-info-pro-info',
            data: {
                pid: this.props.navigation.state.params.pid,
                contacted: '0'
            }
        })
        console.log('values', values)
        createChat({
            data: {
                uid: item.contact_info[0].uid,
                is_find_job: 1
            },
            chatData: {
                page: 'job',
                is_find_job: 1,
                verified: GLOBAL.userinfo.verified,
                click_type: 1,
                pid: item.pid,
                pro_title: item.pro_title,
                role_type: item.role_type,
                classes: item.classes[0],
                ...values
            }
        })
		/*
		reduxLoad(this.props, {
			
			url: "",
			data: {},
			success: (values) => {
				createChat(this.props, {
					data: {
						uid: spaceData.contact_info[0].uid,
						is_find_job: 1
					},
					chatData: {
						page:'job',
						verified,
						click_type:1,
						pid: spaceData.pid,
						pro_title: spaceData.pro_title,
						role_type: spaceData.role_type,
						classes: spaceData.classes[0],
						...values
					}
				});
			},
			error: () => {}
		})
		*/
        //NativeModules.MyNativeModule.createChat('');//调用原生方法
    }
    // status==1
    useup() {
        this.setState({
            ifOpenAlert: !this.state.ifOpenAlert,
        })
        if (Platform.OS == 'android' && GLOBAL.client_type == 'person') {//android个人端
            NativeModules.MyNativeModule.openWebView('my/package?type=1');//调用原生方法
        }
        if (Platform.OS == 'ios' && GLOBAL.client_type == 'person') {//ios个人端
            NativeModules.JGJRecruitmentController.openWebView('my/package?type=1');//调用原生方法
        }
    }
    // 购买套餐status==2
    shopping() {
        this.setState({
            ifOpenAlert: !this.state.ifOpenAlert,
        })
        if (Platform.OS == 'android' && GLOBAL.client_type == 'person') {//android个人端
            NativeModules.MyNativeModule.openWebView('my/package?type=1');//调用原生方法
        }
        if (Platform.OS == 'ios' && GLOBAL.client_type == 'person') {//ios个人端
            NativeModules.JGJRecruitmentController.openWebView('my/package?type=1');//调用原生方法
        }
    }
    // 分享吉工家查看或拨打电话status==3-拨打电话分享
    shareFriend() {
        this.setState({
            ifOpenAlert: !this.state.ifOpenAlert,
        })
        let shareSuid = "";
        if (this.state.item && this.state.item.uid) {
            shareSuid = "&suid=" + this.state.item.uid;
        }
        let imgUrl = ''
        if (this.state.item.share.wxshare_img.indexOf('http://api.yzgong.com') != -1) {
            imgUrl = this.state.item.share.wxshare_img.replace('http://api.yzgong.com', `${GLOBAL.shareHttp}`)
        } else {
            imgUrl = this.state.item.share.wxshare_img
        }
        let shareData = {
            type: 0,
            title: this.state.item.pro_title,
            // url: `http://nm.test.jgjapp.com/work/${this.state.item.pid}?plat=${GLOBAL.client_type}`,//分享跳转的地址
            url: `${GLOBAL.server}job?plat=${GLOBAL.client_type}`,//分享跳转的地址-列表
            imgUrl: imgUrl,
            describe: this.state.item.share.wxshare_desc,
            wxMini: {
                appId: GLOBAL.miniJobAppId,
                // path: `/pages/job/work/info?pid=${this.state.item.pid}&share=1${shareSuid}`
                path: `pages/job/work/index`//列表
            },
            topdisplay: 1
        }
        console.log(shareData)
        if (Platform.OS == 'android' && GLOBAL.client_type == 'person') {//android个人端
            NativeModules.MyNativeModule.showShareMenu(JSON.stringify(shareData), (result) => {
                this.getPhoneNum()// 获取拨打电话次数
            });//调用原生方法
        }
        if (Platform.OS == 'ios' && GLOBAL.client_type == 'person') {//ios个人端
            NativeModules.JGJRecruitmentController.showShareMenu(shareData, (result) => {
                this.getPhoneNum()// 获取拨打电话次数
            });//调用原生方法
        }
    }
    getPhoneNum() {
        fetchFun.load({
            url: 'v2/workday/shareToGetPhone',
            data: {
            },
            success: (res) => {
                console.log('---分享获取拨打电话次数---', res)
                if (res.is_give == 1) {//1本次分享赠送了次数，0本次分享没有获得赠送
                    this.setState({
                        ifOpenAlert: !this.state.ifOpenAlert,
                        param: 'status3end'
                    })
                }

            }
        });
    }
    // 获得拨打电话次数弹框关闭
    shareFriendEnd() {
        this.setState({
            ifOpenAlert: !this.state.ifOpenAlert,
        })
    }
}

const styles = StyleSheet.create({
    main: {
        flex: 1,
        backgroundColor: '#ebebeb',
    },
    bg: {
        backgroundColor: '#fff',
        paddingLeft: 11,
        paddingRight: 11,
    },
})