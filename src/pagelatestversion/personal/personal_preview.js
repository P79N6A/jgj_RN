/*
 * @Author: mikey.zhaopeng 
 * @Date: 2019-03-29 16:59:12 
 * @Last Modified by: mikey.zhaopeng
 * @Last Modified time: 2019-04-18 16:21:21
 * Module:名片预览
 */

import React, { Component } from 'react';
import {
    Image,
    StyleSheet,
    Text,
    TouchableOpacity,
    View,
    Modal,
    DeviceEventEmitter,
    NativeModules,
    Platform
} from 'react-native';
import LinearGradient from 'react-native-linear-gradient';
import Icon from "react-native-vector-icons/iconfont";
import ListItem from '../../component/listitem'
import fetchFun from '../../fetch/fetch'
import ImageCom from '../../component/imagecom';
import Images from '../../component/images';
import Alert from '../../component/alert'
import AlertUser from '../../component/alertuser'
import Thelabel from '../../component/thelabel'
import { createChat, openWebView } from '../../utils'
import InfoModal from '../../component/InfoModal'
import * as _ from "lodash";

export default class readme extends Component {
    constructor(props) {
        super(props);
        //当前页
        this.page = 1
        this.pagesize = 10
        this.isFresh = false
        //状态
        this.state = {
            fromTo: '',
            uid: '',//id
            role_type: '',//1，工人，2工头
            ifOperation: false,//是否被收藏
            ifmore: false,
            // 列表数据结构
            dataSource: [],
            headerData: {},
            // 下拉刷新
            isRefresh: false,
            // 加载更多
            isLoadMore: false,
            // 控制foot  1：正在加载   2 ：无更多数据
            showFoot: 1,

            ifError: true,
            alertValue: '',
            openAlert: false,

            ifOpenAlert: false,//是否打开弹框
            param: '',//实名or认证、突击

            ifFetch: false,//是否已经请求完成

            grorbz: '',
            showInfoModal: false
        }
        this.loadMoreDataThrottled = _.throttle(this._onLoadMore, 3000, { trailing: false });
    }
    // 顶部导航
    static navigationOptions = ({ navigation, screenProps }) => ({
        header: null, gesturesEnabled: false,
    });
    componentWillMount() {
        console.log(this.props.navigation)
        let uid = [this.props.navigation.getParam('uid')]
        let fromTo = [this.props.navigation.getParam('fromTo')]
        let role_type = [this.props.navigation.getParam('role_type')]
        this.setState({
            fromTo: fromTo,
            uid: uid,
            role_type: role_type,
            grorbz: this.props.navigation.getParam('grorbz')
        }, () => {
            this.getData(uid)//获取该人名片数据
        })

    }
    //获取个人名片数据
    getData(uid) {
        fetchFun.load({
            url: 'v2/workday/getResumeInfo',
            data: {
                uid: uid[0],
                role: this.state.role_type[0],//默认当前角色 (只能工人角色)
                flag: 1,//默认为0 （浏览简历标识 浏览：1）
                share: 0//默认为0 （分享后浏览简历标识 浏览：1）
            },
            success: (res) => {
                console.log('---名片数据---', res)
                this.setState({
                    headerData: res,
                    ifFetch: true
                })
                if (res.is_collection == 1) {//已被收藏
                    this.setState({
                        ifOperation: true
                    })
                }
                this.projectList(uid)//获取项目经验数据
            }
        });
    }
    // 获取项目经验数据
    projectList(uid) {
        fetchFun.load({
            url: 'jlwork/getproexperience',
            data: {
                pg: this.page,
                pagesize: this.pagesize,
                uid: uid[0]
            },
            success: (res) => {
                console.log('---项目经验---', res)
                this.setState({
                    dataSource: res
                })
            }
        });
    }
    render() {
        let headerObj = {
            fromTo: this.state.fromTo,
            uid: this.state.uid,
            role_type: this.state.role_type,
            ifOperation: this.state.ifOperation,
        }
        return (
            <View style={styles.container}>
                {/* 导航条 */}
                <View style={{
                    height: 48, backgroundColor: '#FAFAFA', position: 'relative',
                    flexDirection: 'row', alignItems: 'center', justifyContent: "space-between",
                    borderBottomWidth: 1, borderBottomColor: '#ebebeb'
                }}>
                    <TouchableOpacity activeOpacity={.7} style={{ flexDirection: 'row', alignItems: 'center', marginLeft: 10, marginBottom: 1, width: '25%' }}
                        onPress={() => this.props.navigation.goBack()}>
                        <Icon style={{ marginRight: 3 }} name="l-arrow" size={19} color="#eb4e4e" />
                        <Text style={{ marginRight: 10, color: '#eb4e4e', fontWeight: '400', fontSize: 17 }}>返回</Text>
                    </TouchableOpacity>
                    <View style={{ flex: 1, flexDirection: 'row', justifyContent: 'center', alignItems: 'center' }}>
                        {
                            this.state.headerData !== '{}' ? (
                                GLOBAL.userinfo.real_name == this.state.headerData.realname ? (
                                    <Text style={{ fontSize: 17, color: '#000000', fontWeight: '400', }}>
                                        我的找活名片
                                    </Text>
                                ) : (
                                        <Text style={{ fontSize: 17, color: '#000000', fontWeight: '400', }}>
                                            {this.state.headerData.realname}的找活名片
                                    </Text>
                                    )
                            ) : (<View></View>)
                        }

                    </View>
                    <TouchableOpacity activeOpacity={.7}
                        style={{
                            width: '25%', height: '100%', marginRight: 10,
                            flexDirection: 'row', alignItems: 'center',
                            justifyContent: 'flex-end'
                        }}>
                        {
                            this.state.fromTo == 'yzlw' ? (
                                GLOBAL.userinfo.real_name == this.state.headerData.realname ? (
                                    <TouchableOpacity activeOpacity={.7}
                                        activeOpacity={1}
                                        onPress={() => this.shareTab()}>
                                        <Text style={{ fontSize: 17, color: '#eb4e4e', fontWeight: '400', }}>
                                            分享
                                        </Text>
                                    </TouchableOpacity>
                                ) : (
                                        <TouchableOpacity activeOpacity={.7}
                                            activeOpacity={1}
                                            onPress={() => this.moreFun()}>
                                            <Text style={{ fontSize: 17, color: '#eb4e4e', fontWeight: '400', }}>
                                                更多
                                        </Text>
                                        </TouchableOpacity>
                                    )
                            ) : false
                        }
                    </TouchableOpacity>
                </View>

                {/* 举报按钮弹框 */}
                <Modal
                    animationType="none"
                    transparent={true}
                    visible={this.state.ifmore}
                    onRequestClose={() => {
                        this.setState({
                            ifmore: !this.state.ifmore
                        })
                    }}>
                    <TouchableOpacity activeOpacity={.7}
                        activeOpacity={1}
                        style={{ width: '100%', height: '100%' }}
                        onPress={() => this.setState({
                            ifmore: !this.state.ifmore
                        })}>
                        <View style={{ position: 'absolute', right: 11, top: 62, }}>
                            <View style={{
                                position: 'absolute',
                                right: 10, top: -10,
                                width: 0,
                                height: 0,
                                borderWidth: 12,
                                borderTopWidth: 0,
                                borderColor: 'rgba(74,74,74,0)',
                                borderBottomColor: 'rgb(74,74,74)'
                            }}></View>

                            <TouchableOpacity activeOpacity={.7}
                                activeOpacity={1}
                                onPress={() => this.ShareFun()}
                                style={{
                                    width: 101, paddingLeft: 17.6, paddingRight: 17.6, paddingTop: 10, paddingBottom: 10,
                                    backgroundColor: "rgb(74,74,74)", flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between',
                                    borderTopLeftRadius: 4, borderTopRightRadius: 4
                                }}>
                                <Icon name="share1" size={17} color="#fff" />
                                <Text style={{ color: "#fff", fontSize: 16 }}>分享</Text>
                            </TouchableOpacity>

                            <TouchableOpacity activeOpacity={.7}
                                activeOpacity={1}
                                onPress={() => this.toReport()}
                                style={{
                                    width: 101, paddingLeft: 17.6, paddingRight: 17.6, paddingTop: 10, paddingBottom: 10,
                                    borderTopColor: 'gray', borderTopWidth: .5,
                                    backgroundColor: "rgb(74,74,74)", flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between',
                                    borderBottomLeftRadius: 4, borderBottomRightRadius: 4
                                }}>
                                <Icon name="shield" size={17} color="#fff" />
                                <Text style={{ color: "#fff", fontSize: 16 }}>举报</Text>
                            </TouchableOpacity>
                        </View>
                    </TouchableOpacity>
                </Modal>

                {/* 列表组件 */}
                {
                    this.state.ifFetch ? (
                        <ListItem
                            data={this.state.dataSource}
                            ListHeaderComponent={() => <Header grorbz={this.state.grorbz} headerData={this.state.headerData} headerObj={headerObj} updateOperation={this.updateOperation.bind(this)} alertFun={this.alertFun.bind(this)} />}//头布局
                            renderItem={({ item }) => <List data={item} lastItemId={this.state.dataSource[this.state.dataSource.length - 1].id} />}//item显示的布局
                            ListFooterComponent={() => <Footer data={this.state.headerData} />}//尾布局
                            ListEmptyComponent={() => <Empty />}// 空布局
                            onEndReached={() => setTimeout(() => { this._onLoadMore() }, 500)}//加载更多
                            onRefresh={() => this._onRefresh()}//下拉刷新相关
                            onContentSizeChange={() => this.onContentSizeChange}
                        />
                    ) : false
                }

                {/* 弹框 */}
                <Alert
                    alertValue={this.state.alertValue}
                    ifError={this.state.ifError}
                    openAlert={this.state.openAlert}
                    closeAlertFun={this.closeAlertFun.bind(this)}
                    openAlertFun={this.openAlertFun.bind(this)} />

                {/* 按钮 */}
                <View style={{
                    position: 'absolute', bottom: 0, height: 66, width: '100%',
                    backgroundColor: "#fff", padding: 11, flexDirection: 'row',
                    borderTopWidth: .5, borderTopColor: '#cccccc'
                }}>
                    <TouchableOpacity activeOpacity={.7}
                        onPress={() => this.createChat()}
                        style={{
                            flexDirection: 'row', alignItems: 'center', justifyContent: 'center', flex: 1,
                            borderWidth: 1, borderColor: 'rgb(235, 78, 78)', borderRadius: 4, marginRight: 11
                        }}
                    >
                        <Text style={{ color: '#eb4e4e', fontSize: 20 }}>和他聊聊</Text>
                    </TouchableOpacity>
                    <TouchableOpacity activeOpacity={.7}
                        onPress={() => this.call_button()}
                        style={{
                            flexDirection: 'row', alignItems: 'center', justifyContent: 'center', flex: 1,
                            backgroundColor: 'rgb(235, 78, 78)', borderRadius: 4, position: 'relative'
                        }}>
                        <Text style={{ color: '#fff', fontSize: 20 }}>拨打电话</Text>
                        <Icon style={{ position: 'absolute', right: 8, top: -10 }} name="gtgk" size={40} color="#fff" />
                    </TouchableOpacity>
                </View>

                {/* 弹框-实名、认证、突击 */}
                <AlertUser
                    shopping={this.shopping.bind(this)}//status==2购买套餐
                    shareFriendEnd={this.shareFriendEnd.bind(this)}//分享成功，获得拨打电话次数
                    gows={this.gows.bind(this)}//去完善资料
                    ifOpenAlert={this.state.ifOpenAlert}
                    alertFunr={this.alertFunr.bind(this)}
                    param={this.state.param} />
                <InfoModal
                    visible={this.state.showInfoModal}
                    cancelFn={() => this.toggleShowInfoModal()}
                    sureFn={() => { openWebView('my/info?perfect=1'); this.toggleShowInfoModal() }}
                />
            </View>
        );
    }
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
    // 打开弹框
    // openFun() {
    //     this.setState({
    //         openAlert: true,
    //         alertValue: '该微信号：g918010已复制，请在微信中添加朋友时粘贴搜索'
    //     }, () => {
    //         setTimeout(() => {
    //             this.setState({
    //                 openAlert: !this.state.openAlert
    //             })
    //         }, 1000)
    //     })
    // }
    //点击举报
    toReport() {
        this.setState({
            ifmore: !this.state.ifmore
        })
        this.props.navigation.navigate('Personal_report', { uid: this.state.uid })
    }
    // 个人名片-直接分享
    ShareFun() {
        // 关闭更多弹窗选项
        this.setState({
            ifmore: !this.state.ifmore
        })

        let summary = "";
        if (this.state.headerData.work_year)
            summary += `从业${this.state.headerData.work_year}年`;
        this.state.headerData.worktype && this.state.headerData.worktype.map((val, index) => {
            summary += (index ? "、" : "主要干") + val.name;
        })
        let shareData = {
            type: 0,
            title: `${this.state.headerData.realname}的找活名片`,
            url: `${GLOBAL.server}job/userinfo?share=1&role_type=${GLOBAL.userinfo.role}&uid=${this.props.navigation.getParam('uid')}&plat=${GLOBAL.client_type}`,
            imgUrl: `${GLOBAL.shareHttp}/media/default_imgs/logo.jpg`,
            describe: summary,
            wxMini: {
                appId: GLOBAL.miniJobAppId,
                path: `/pages/job/team/info?share=1&uid=${this.props.navigation.getParam('uid')}&role_type=${GLOBAL.userinfo.role}&suid=${GLOBAL.userinfo.uid}`
            },

            // type:0,
            // title:"董明安的找活名片",
            // url:"http://nm.test.jgjapp.com/job/userinfo?share=1&role_type=2&uid=100239864&plat=person",
            // imgUrl:"http://test.cdn.jgjapp.com/media/default_imgs/logo.jpg",
            // describe:"从业25年主要干抹灰工,在土建行业",
            // wxMini:{
            //     appId:"gh_dc82dfffc292",
            //     path:"/pages/job/team/info?share=1&uid=100239864&role_type=2&suid=100894379"
            // }
        }

        console.log(JSON.stringify(shareData))
        if (Platform.OS == 'android' && GLOBAL.client_type == 'person') {//android个人端
            NativeModules.MyNativeModule.showShareMenu(JSON.stringify(shareData), (result) => {
                console.log(result)
            });//调用原生方法
        }
        if (Platform.OS == 'ios' && GLOBAL.client_type == 'person') {//android个人端
            NativeModules.JGJRecruitmentController.showShareMenu(shareData, (result) => {
                console.log(result)
            });//调用原生方法
        }
    }
    //更改是否已收藏状态
    updateOperation() {
        this.setState({
            ifOperation: !this.state.ifOperation
        }, () => {
            if (this.state.ifOperation) {
                this.setState({
                    openAlert: !this.state.openAlert,
                    alertValue: '收藏成功'
                })
            } else {
                this.setState({
                    openAlert: !this.state.openAlert,
                    alertValue: '已取消收藏'
                })
            }
        })
    }
    // 点击导航栏的分享
    shareTab() {
        let summary = "";
        if (this.state.headerData.work_year)
            summary += `从业${this.state.headerData.work_year}年`;
        this.state.headerData.worktype && this.state.headerData.worktype.map((val, index) => {
            summary += (index ? "、" : "主要干") + val.name;
        })
        let shareData = {
            type: 0,
            title: `${this.state.headerData.realname}的找活名片`,
            url: `${GLOBAL.server}job/userinfo?share=1&role_type=${GLOBAL.userinfo.role}&uid=${this.props.navigation.getParam('uid')}&plat=${GLOBAL.client_type}`,
            imgUrl: `${GLOBAL.shareHttp}/media/default_imgs/logo.jpg`,
            describe: summary,
            wxMini: {
                appId: GLOBAL.miniJobAppId,
                path: `/pages/job/team/info?share=1&uid=${this.props.navigation.getParam('uid')}&role_type=${GLOBAL.userinfo.role}&suid=${GLOBAL.userinfo.uid}`
            },
        }

        console.log(JSON.stringify(shareData))
        if (Platform.OS == 'android' && GLOBAL.client_type == 'person') {//android个人端
            NativeModules.MyNativeModule.showShareMenu(JSON.stringify(shareData), (result) => {
                console.log(result)
            });//调用原生方法
        }
        if (Platform.OS == 'ios' && GLOBAL.client_type == 'person') {//android个人端
            NativeModules.JGJRecruitmentController.showShareMenu(shareData, (result) => {
                console.log(result)
            });//调用原生方法
        }
    }
    // 点击更多
    moreFun() {
        this.setState({
            ifmore: !this.state.ifmore
        })
    }
    // 下拉刷新
    _onRefresh = () => {
        // 不处于 下拉刷新
        if (!this.state.isRefresh) {
            this.page = 1
            let uid = [this.props.navigation.getParam('uid')]
            // this.getData(uid)
        }
    };
    onContentSizeChange = () => {
        this.isFresh = true;
    }
    // 加载更多
    _onLoadMore() {
        // 不处于正在加载更多 && 有下拉刷新过，因为没数据的时候 会触发加载
        if (!this.state.isLoadMore && this.state.dataSource.length > 0 && this.state.showFoot !== 2) {
            // this.pagesize = this.pagesize + 10
            let uid = [this.props.navigation.getParam('uid')]
            // this.getData(uid)
        }
    }
    componentWillUnmount() {
        this.loadMoreDataThrottled.cancel();
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
                // console.log(this.props.navigation.getParam('nameTo') ? this.props.navigation.getParam('uid') : GLOBAL.otherUser.uid)
                // console.log(this.props.navigation.getParam('nameTo') ? this.props.navigation.getParam('pid') : GLOBAL.otherUser.pid)
                // console.log(this.props.navigation.getParam('nameTo') ? 1 : 0)
                fetchFun.load({
                    url: 'jlforemanwork/tocontactbysnapshot',
                    data: {
                        uid: this.props.navigation.getParam('nameTo') ? this.props.navigation.getParam('uid') : GLOBAL.otherUser.uid,
                        pid: this.props.navigation.getParam('nameTo') ? this.props.navigation.getParam('pid') : GLOBAL.otherUser.pid,
                        // role_type: this.props.navigation.getParam('nameTo')?this.props.navigation.getParam('role_type'):GLOBAL.otherUser.role_type,
                        is_resume: this.props.navigation.getParam('nameTo') ? 1 : 0
                    },
                    success: (res) => {
                        console.log('---拨打电话---', res)
                        if (res.telephone) {//正常返回电话
                            if (Platform.OS == 'android' && GLOBAL.client_type == 'person') {//android个人端
                                NativeModules.MyNativeModule.appCall(res.telephone);//调用原生方法
                            }
                            if (Platform.OS == 'ios' && GLOBAL.client_type == 'person') {//android个人端
                                NativeModules.JGJRecruitmentController.appCall(res.telephone);//调用原生方法
                            }
                        } else {
                            this.setState({
                                ifOpenAlert: !this.state.ifOpenAlert,
                                param: 'status2'
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
    toggleShowInfoModal() {
        let { showInfoModal } = this.state
        this.setState({
            showInfoModal: !showInfoModal
        })
    }
    // 和他聊聊
    async createChat() {
        if (GLOBAL.userinfo.is_info == 0) {//未完善资料
            this.toggleShowInfoModal()
            return
        }
        let { item } = this.state,
            { uid, pid } = this.props.navigation.state.params
        chatData = {
            chatData: {
                is_find_job: 1,
                is_resume: 1//#20021【找活招工】在招工信息和他聊天后 在找活记录里面没有 跑到找人记录里面去了
            },
            data: {
                uid,
                is_find_job: 1
            }
        }
        console.log(item)

        // if (!isUserInfo(this.props, {perfect: true})) {
        // 	return false;
        // }
        // let values = await fetchFun.load({
        //     newApi: true,
        //     url: 'user/get-work-info-pro-info',
        //     data: {
        //         kind: 'recruit',
        //         pid: this.props.navigation.state.params.pid,
        //         contacted: '0'
        //     }
        // })
        // console.log('values', values)
        if (pid) {
            // queryData = findData.spaceQuery;
            let queryData = GLOBAL.getselfproliststandard.filter((item) => {
                if (item.pid == pid) {
                    return item
                }
            })
            queryData = queryData[0]
            chatData.chatData = {
                click_type: 2,
                pro_title: queryData.pro_title,
                role_type: role_type,
                classes: queryData.classes[0]
            };

            chatData.chatData.pid = pid
        }
        chatData.chatData.verified = GLOBAL.userinfo.verified
        createChat(chatData);
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

    getPhoneNum() {
        fetchFun.load({
            url: 'v2/workday/shareToGetPhone',
            data: {
            },
            success: (res) => {
                console.log('---分享获取拨打电话次数---', res)
                this.setState({
                    ifOpenAlert: !this.state.ifOpenAlert,
                    param: 'status3end'
                })

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
// 头布局
class Header extends React.Component {
    constructor(props) {
        super(props)
        this.state = {}
    }
    render() {
        let item = this.props.headerData
        let fromTo = this.props.headerObj.fromTo
        // console.log(item)
        if (JSON.stringify(item) !== '{}') {
            return (
                <View style={{ backgroundColor: '#fff' }}>
                    {/* 背景盒子 */}
                    <LinearGradient colors={['#2e16b2', '#fff',]} style={styles.bg}>
                        <View style={{
                            marginLeft: 11, marginRight: 11, marginTop: 22, marginBottom: 22,
                            borderRadius: 11, backgroundColor: '#fff', position: 'relative'
                        }}>
                            {/* 收藏 */}
                            {
                                fromTo == 'yzlw' ? (
                                    GLOBAL.userinfo.real_name == item.realname ? false : (
                                        this.props.headerObj.ifOperation ? (
                                            <TouchableOpacity activeOpacity={.7} onPress={() => this.operatingFun()} style={{
                                                backgroundColor: 'rgb(253, 232, 232)',
                                                width: 88, height: 38, flexDirection: 'row', alignItems: 'center', justifyContent: 'center',
                                                borderBottomLeftRadius: 24.8, borderTopRightRadius: 8.8, position: 'absolute', right: 0, top: 0, zIndex: 99
                                            }}>
                                                <Icon name="heart" size={22} color="#eb4e4e" />
                                                <Text style={{ color: '#eb4e4e', fontSize: 14.3, fontWeight: '400', marginLeft: 5.5 }}>已收藏</Text>
                                            </TouchableOpacity>
                                        ) : (
                                                <TouchableOpacity activeOpacity={.7} onPress={() => this.operatingFun()} style={{
                                                    backgroundColor: 'rgb(229, 229, 229)',
                                                    width: 88, height: 38, flexDirection: 'row', alignItems: 'center', justifyContent: 'center',
                                                    borderBottomLeftRadius: 24.8, borderTopRightRadius: 8.8, position: 'absolute', right: 0, top: 0, zIndex: 99
                                                }}>
                                                    <Icon name="heart" size={22} color="#999999" />
                                                    <Text style={{ color: '#999', fontSize: 14.3, fontWeight: '400', marginLeft: 5.5 }}>收藏</Text>
                                                </TouchableOpacity>
                                            )
                                    )
                                ) : false
                            }

                            {/* 基本信息 */}
                            <View style={{ paddingLeft: 22, paddingRight: 22, paddingBottom: 22, paddingTop: 22, flexDirection: 'row', alignItems: 'center' }}>
                                <View style={{ marginRight: 20, marginLeft: -10 }}>
                                    <ImageCom
                                        style={{ borderRadius: 4.4, width: 66, height: 66, }}
                                        fontSize='19.8'
                                        userPic={item.head_pic}
                                        userName={item.realname}
                                    />
                                    <Text style={{ fontSize: 18.7, color: '#000', fontWeight: '400', textAlign: 'center', marginTop: 6.6 }}>
                                        {item.realname}
                                    </Text>
                                </View>

                                <View>
                                    <Text
                                        style={{
                                            fontSize: 18.7, color: '#000',
                                            fontWeight: '400', textAlign: 'left',
                                            height: 24, marginBottom: 10
                                        }}>
                                        {
                                            item.gender ? (<Text>{item.gender}&nbsp;&nbsp;</Text>) : (false)
                                        }
                                        {
                                            item.age ? (<Text>{item.age}岁&nbsp;&nbsp;</Text>) : (false)
                                        }
                                        {
                                            item.nation ? (<Text>{item.nation}</Text>) : (false)
                                        }
                                    </Text>

                                    {/* 工作状态（op为m时传：0没工作、1已开工、2已开工也找新工作） */}
                                    {
                                        item.work_status == '0' ? (
                                            <Text style={{ color: '#eb4e4e', fontSize: 15.4, height: 23, marginBottom: 10 }}>
                                                未开工正在找工作
                                        </Text>
                                        ) : (
                                                item.work_status == '1' ? (
                                                    <Text style={{ color: '#eb4e4e', fontSize: 15.4, height: 23, marginBottom: 10 }}>
                                                        暂时不需要找工作
                                            </Text>
                                                ) : (
                                                        item.work_status == '2' ? (
                                                            <Text style={{ color: '#eb4e4e', fontSize: 15.4, height: 23, marginBottom: 10 }}>
                                                                已开工也在找工作
                                                </Text>
                                                        ) : false
                                                    )
                                            )
                                    }

                                    <View style={{ flexDirection: 'row' }}>
                                        {
                                            item.idverified !== '0' ? (
                                                <TouchableOpacity activeOpacity={.7}
                                                    onPress={() => this.props.alertFun('user-sm')}>
                                                    <Image style={{ width: 46, height: 16, marginLeft: 5 }} source={{ uri: `${GLOBAL.server}public/imgs/icon/verified.png` }}></Image>
                                                </TouchableOpacity>
                                            ) : (false)
                                        }
                                        {
                                            this.props.grorbz && item.group_verified == '1' ? (
                                                this.props.grorbz == '1' ? (
                                                    <TouchableOpacity activeOpacity={.7}
                                                        onPress={() => this.props.alertFun('user-rz-bz')}
                                                    >
                                                        <Image style={{ width: 46, height: 16, marginLeft: 5 }} source={{ uri: `${GLOBAL.server}public/imgs/icon/group-verified.png` }}></Image>
                                                    </TouchableOpacity>
                                                ) : (
                                                        <TouchableOpacity activeOpacity={.7}
                                                            onPress={() => this.props.alertFun('user-rz-gr')}
                                                        >
                                                            <Image style={{ width: 46, height: 16, marginLeft: 5 }} source={{ uri: `${GLOBAL.server}public/imgs/icon/group-verified.png` }}></Image>
                                                        </TouchableOpacity>
                                                    )
                                            ) : (false)
                                        }
                                        {
                                            item.is_commando == '1' ? (
                                                <TouchableOpacity activeOpacity={.7}
                                                    onPress={() => this.props.alertFun('user-tj')}
                                                >
                                                    <Image style={{ width: 46, height: 16, marginLeft: 5 }} source={{ uri: `${GLOBAL.server}public/imgs/icon/commando-verified.png` }}></Image>
                                                </TouchableOpacity>
                                            ) : (false)
                                        }
                                    </View>
                                    {/* <Thelabel name = 'user' idverified={item.idverified} group_verified={item.group_verified} is_commando={item.is_commando} /> */}

                                </View>
                            </View>
                            {/* 个人情况 */}
                            <View style={{ paddingLeft: 22, paddingRight: 22, paddingBottom: 22 }}>
                                {/* 工龄 */}
                                {
                                    item.work_year ? (
                                        <View style={styles.lanmu}>
                                            <Text style={styles.fontl}>工        龄：</Text>
                                            <Text style={styles.fontr}>{item.work_year}年</Text>
                                        </View>
                                    ) : (false)
                                }

                                {/* 家乡 */}
                                {
                                    item.hometown.name ? (
                                        <View style={styles.lanmu}>
                                            <Text style={styles.fontl}>家        乡：</Text>
                                            <Text style={styles.fontr}>{item.hometown.name}</Text>
                                        </View>
                                    ) : false
                                }

                                {/* 期望工作地 */}
                                {
                                    item.expectaddr.name && item.expectaddr.name.trim() ? (
                                        <View style={styles.lanmu}>
                                            <Text style={styles.fontl}>期望工作地：</Text>
                                            <Text style={styles.fontr}>{item.expectaddr.name}</Text>
                                        </View>
                                    ) : (false)
                                }
                                {/* 所在城市 */}
                                {
                                    item.current_addr.name ? (
                                        <View style={styles.lanmu}>
                                            <Text style={styles.fontl}>所在城市：</Text>
                                            <Text style={styles.fontr}>{item.current_addr.name}</Text>
                                        </View>
                                    ) : (false)
                                }

                                {
                                    item.foreman_info.worktype.length == 0 ? null : (
                                        <View>
                                            {/* 我是班组长 */}
                                            <Text style={{ color: "#000", fontSize: 15.4, marginTop: 22, marginBottom: 11 }}>我是班组长:</Text>
                                            {/* 工程类别 */}
                                            {
                                                item.foreman_info.protype && item.foreman_info.protype.length > 0 ? (
                                                    <View style={styles.lanmu}>
                                                        <Text style={styles.fontl}>工程类别：</Text>
                                                        <View
                                                            style={{ flexWrap: 'wrap', width: 280, flexDirection: 'row' }}>
                                                            {
                                                                item.foreman_info.protype.map((val, indexs) => {
                                                                    if (indexs == item.foreman_info.protype.length - 1) {
                                                                        return (
                                                                            <Text key={indexs}
                                                                                style={{
                                                                                    color: "#000",
                                                                                    fontSize: 15.4,
                                                                                }}>{val.name}</Text>
                                                                        )
                                                                    } else {
                                                                        return (
                                                                            <Text key={indexs}
                                                                                style={{
                                                                                    color: "#000",
                                                                                    fontSize: 15.4,
                                                                                }}>{val.name}  |  </Text>
                                                                        )
                                                                    }
                                                                })
                                                            }
                                                        </View>
                                                    </View>
                                                ) : null
                                            }
                                            {/* 工种 */}
                                            {
                                                item.foreman_info.worktype && item.foreman_info.worktype.length > 0 ? (
                                                    <View style={styles.lanmu}>
                                                        <Text style={styles.fontl}>工        种：</Text>
                                                        <View
                                                            style={{ flexWrap: 'wrap', width: 280, flexDirection: 'row', flex: 1 }}>
                                                            {
                                                                item.foreman_info.worktype.map((val, indexs) => {
                                                                    if (indexs == item.foreman_info.worktype.length - 1) {
                                                                        return (
                                                                            <Text key={indexs}
                                                                                style={{
                                                                                    color: "#000",
                                                                                    fontSize: 15.4,
                                                                                }}>{val.name}</Text>
                                                                        )
                                                                    } else {
                                                                        return (
                                                                            <Text key={indexs}
                                                                                style={{
                                                                                    color: "#000",
                                                                                    fontSize: 15.4,
                                                                                }}>{val.name}  |  </Text>
                                                                        )
                                                                    }
                                                                })
                                                            }
                                                        </View>
                                                    </View>
                                                ) : null
                                            }
                                            {/* 队伍人数：*/}
                                            {
                                                item.foreman_info.scale ? (
                                                    <View style={styles.lanmu}>
                                                        <Text style={styles.fontl}>队伍人数：</Text>
                                                        <Text style={styles.fontrs}>{item.foreman_info.scale}人</Text>
                                                    </View>
                                                ) : null
                                            }
                                        </View>
                                    )
                                }

                                {
                                    item.worker_info.worktype.length == 0 ? null : (
                                        <View>
                                            {/* 我是工人 */}
                                            <Text style={{ color: "#000", fontSize: 15.4, marginTop: 22, marginBottom: 11 }}>我是工人:</Text>
                                            {/* 工程类别 */}
                                            {
                                                item.worker_info.protype && item.worker_info.protype.length > 0 ? (
                                                    <View style={styles.lanmu}>
                                                        <Text style={styles.fontl}>工程类别：</Text>
                                                        <View
                                                            style={{ flexWrap: 'wrap', width: 280, flexDirection: 'row', flex: 1 }}>
                                                            {
                                                                item.worker_info.protype.map((val, indexs) => {
                                                                    if (indexs == item.worker_info.protype.length - 1) {
                                                                        return (
                                                                            <Text key={indexs}
                                                                                style={{
                                                                                    color: "#000",
                                                                                    fontSize: 15.4,
                                                                                }}>{val.name}</Text>
                                                                        )
                                                                    } else {
                                                                        return (
                                                                            <Text key={indexs}
                                                                                style={{
                                                                                    color: "#000",
                                                                                    fontSize: 15.4,
                                                                                }}>{val.name}  |  </Text>
                                                                        )
                                                                    }
                                                                })
                                                            }
                                                        </View>
                                                    </View>
                                                ) : null
                                            }
                                            {/* 工种 */}
                                            {
                                                item.worker_info.worktype && item.worker_info.worktype.length > 0 ? (
                                                    <View style={styles.lanmu}>
                                                        <Text style={styles.fontl}>工        种：</Text>
                                                        <View
                                                            style={{ flexWrap: 'wrap', width: 280, flexDirection: 'row', flex: 1 }}>
                                                            {
                                                                item.worker_info.worktype.map((val, indexs) => {
                                                                    if (indexs == item.worker_info.worktype.length - 1) {
                                                                        return (
                                                                            <Text key={indexs}
                                                                                style={{
                                                                                    color: "#000",
                                                                                    fontSize: 15.4,
                                                                                }}>{val.name}</Text>
                                                                        )
                                                                    } else {
                                                                        return (
                                                                            <Text key={indexs}
                                                                                style={{
                                                                                    color: "#000",
                                                                                    fontSize: 15.4,
                                                                                }}>{val.name}  |  </Text>
                                                                        )
                                                                    }
                                                                })
                                                            }
                                                        </View>
                                                    </View>
                                                ) : null
                                            }
                                            {/* 熟练度 */}
                                            {
                                                item.worker_info.worklevel ? (
                                                    <View style={styles.lanmu}>
                                                        <Text style={styles.fontl}>熟  练  度：</Text>
                                                        <Text style={styles.fontrs}>{item.worker_info.worklevel}</Text>
                                                    </View>
                                                ) : null
                                            }
                                        </View>
                                    )
                                }
                            </View>
                        </View>
                    </LinearGradient>

                    {/* 自我介绍 */}
                    <View style={styles.tit}>
                        <View style={styles.a}></View>
                        <View style={styles.b}></View>
                        <Text style={styles.titfont}>自我介绍</Text>
                        <View style={styles.a}></View>
                        <View style={styles.b}></View>
                    </View>
                    <View style={styles.viewfont}>
                        {
                            !item.introduce || item.introduce == '' ? (
                                <Text style={styles.font}>这家伙很懒，啥都没写</Text>
                            ) : (
                                    <Text style={styles.font}>{item.introduce}</Text>
                                )
                        }
                    </View>

                    {/* 职业技能 */}
                    {
                        item.cerification && item.cerification.length ? (
                            <View>
                                <View style={styles.tit}>
                                    <View style={styles.a}></View>
                                    <View style={styles.b}></View>
                                    <Text style={styles.titfont}>职业技能</Text>
                                    <View style={styles.a}></View>
                                    <View style={styles.b}></View>
                                </View>
                                <View style={styles.viewfont}>
                                    {
                                        item.cerification.map((val, index) => {
                                            return (
                                                <Text key={index} style={styles.font}>{(index ? " | " : "") + val.certificate_name}</Text>
                                            )
                                        })
                                    }
                                </View>
                            </View>
                        ) : false
                    }
                    {/* 项目经验 */}
                    <View style={{
                        marginLeft: 22,
                        marginRight: 22,
                        marginTop: 11,
                        marginBottom: 30,
                        flexDirection: 'row',
                        justifyContent: 'center',
                        alignItems: 'center'
                    }}>
                        <View style={styles.a}></View>
                        <View style={styles.b}></View>
                        <Text style={styles.titfont}>项目经验</Text>
                        <View style={styles.a}></View>
                        <View style={styles.b}></View>
                    </View>

                </View>
            )
        } else {
            return false
        }
    }
    // 收藏按钮
    operatingFun() {
        fetchFun.load({
            url: 'v2/project/serviceOperating',
            data: {
                type: this.props.headerObj.ifOperation ? '2' : '1',
                uid: this.props.headerObj.uid[0],
                role_type: this.props.headerObj.role_type[0],//1，工人，2工头
                kind: 'recruit'
            },
            success: (res) => {
                console.log('---劳务收藏，取消---', res)
                this.props.updateOperation()//更改是否收藏状态
                // 更新"我收藏的"列表
                // DeviceEventEmitter.emit('update', '')
            }
        });
    }
}
// 尾布局
class Footer extends React.Component {
    constructor(props) {
        super(props)
        this.state = {}
    }
    render() {
        return (
            <View>
                {/* 公告 */}
                <View style={{ paddingTop: 11, paddingBottom: 11, backgroundColor: '#ebebeb', marginBottom: 66 }}>
                    <View style={{ padding: 11, backgroundColor: "#fdf1e0", flexDirection: 'row' }}>
                        <View style={{
                            width: 24, height: 18, backgroundColor: "rgb(255, 104, 3)", borderRadius: 2.2,
                            flexDirection: 'row', alignItems: 'center', justifyContent: 'center',
                            marginRight: 5, marginTop: 2
                        }}>
                            <Text style={{
                                color: '#fff',
                                fontSize: 12
                            }}>公告</Text>
                        </View>
                        <View style={{ flex: 1 }}>
                            <View style={{ flexDirection: "row", alignItems: "center", marginBottom: 5, flexWrap: 'wrap' }}>
                                <Text style={{ color: '#666', fontSize: 14 }}>加客服微信号</Text>
                                <Text style={{ color: '#4193df', fontSize: 14, fontWeight: '400' }}>{this.props.data.wechat_customer}</Text>
                                <TouchableOpacity activeOpacity={.7}
                                    onPress={() => this.copyWechatNumber()}
                                    style={{
                                        borderWidth: 0.5, borderColor: '#999', borderRadius: 2.2,
                                        flexDirection: 'row', alignItems: 'center', justifyContent: 'center',
                                        paddingLeft: 4, paddingRight: 4, marginLeft: 3
                                    }}>
                                    <Text style={{ color: '#666', fontSize: 13.2 }}>点击复制</Text>
                                </TouchableOpacity>
                                <Text style={{ color: '#666', fontSize: 14 }}>，拉你进工友群</Text>
                            </View>
                            <View style={{ flexDirection: "row", alignItems: "center", flexWrap: 'wrap' }}>
                                <Text style={{ color: '#666', fontSize: 14 }}>关注“吉工家”微信公众号接收新工作提醒 </Text>
                                <Text style={{ color: '#4193df', fontSize: 14, fontWeight: '400' }}>如何关注</Text>
                            </View>
                        </View>
                    </View>
                </View>
            </View>
        )
    }
    // 复制微信号
    copyWechatNumber() {
        if (Platform.OS == 'android' && GLOBAL.client_type == 'person') {//android个人端
            NativeModules.MyNativeModule.copyWechatNumber(this.props.data.wechat_customer);//调用原生方法
        }
        if (Platform.OS == 'ios' && GLOBAL.client_type == 'person') {//android个人端
            NativeModules.JGJRecruitmentController.copyWechatNumber(this.props.data.wechat_customer);//调用原生方法
        }
    }
}
// 空布局
class Empty extends React.Component {
    constructor(props) {
        super(props)
        this.state = {}
    }
    render() {
        return (
            <View style={{ backgroundColor: '#fff', paddingTop: 33, paddingBottom: 33 }}>
                <Text style={{ textAlign: 'center' }}>暂无记录哦~</Text>
            </View>
        )
    }
}
// item布局
class List extends React.Component {
    constructor(props) {
        super(props)
        this.state = {}
    }
    // 点击图片调用原生方法全屏查看-图片数组item.imgs
    onClickImage(image, indexs) {
        // GLOBAL.apiUrl.replace(/([\w]):\/\/[\w]+\.([\w]+\.)?(\w+)\.(.+)/gi, "$1://$2cdn.$3.$4")
        let shareData = {}
        // shareData.imgData = this.props.data.imgs
        shareData.imgDiv = GLOBAL.apiUrl.replace(/([\w]):\/\/[\w]+\.([\w]+\.)?(\w+)\.(.+)/gi, "$1://$2cdn.$3.$4")
        shareData.imgIndex = indexs

        let arr = []
        this.props.data.imgs.map((v, i) => {
            let pic
            if (v.indexOf('media') == -1) {
                pic = 'media/simages/m/' + v
            } else if (v.indexOf('simages') == -1) {
                pic = v.split("media/images/"); //字符分割
                pic = pic[0] + pic[1]
                pic = 'media/simages/m/' + pic
            }
            arr.push(pic)
        })
        shareData.imgData = arr

        console.log(shareData)

        if (Platform.OS == 'android' && GLOBAL.client_type == 'person') {
            NativeModules.MyNativeModule.previewImage(JSON.stringify(shareData))
        }
        if (Platform.OS == 'ios' && GLOBAL.client_type == 'person') {
            NativeModules.JGJRecruitmentController.previewImage(shareData)
        }
    }
    render() {
        const item = this.props.data
        const id = this.props.lastItemId
        return (
            <View style={{ backgroundColor: '#fff' }}>
                {/* 具体项目经验内容 */}
                <View style={{ paddingLeft: 26, paddingRight: 26 }}>

                    <View>
                        <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                            <Image style={{ width: 14, height: 14, marginRight: 14 }} source={require('../../assets/personal/sj.png')}></Image>

                            {/* 时间 */}
                            <Text style={{ color: '#999', fontSize: 13.2, marginRight: 13.2 }}>
                                {item.ctime}
                            </Text>

                            {/* 地址 */}
                            <Text style={{ color: '#999', fontSize: 13.2, marginRight: 13.2 }}>
                                {item.proaddress}
                            </Text>
                        </View>
                        <View style={{ borderLeftWidth: 2, borderLeftColor: 'rgb(245,245,245)', marginTop: 7, marginBottom: 7, paddingLeft: 17, marginLeft: 7 }}>

                            {/* 项目名称 */}
                            <Text
                                style={{
                                    color: '#333', fontSize: 17.6, height: 26,
                                    marginTop: 5.5, marginBottom: 5.5, marginLeft: 5, fontWeight: '400'
                                }}>
                                {item.proname}
                            </Text>

                            {/* 项目情况 */}
                            {
                                item.desc && item.desc !== '' ? (
                                    <Text
                                        style={{
                                            color: '#999', fontSize: 15.4, height: 22,
                                            marginBottom: 15.5, marginLeft: 5
                                        }}>
                                        {item.desc}
                                    </Text>
                                ) : false
                            }

                            <View style={{ flexWrap: 'wrap', marginLeft: 5.2, marginTop: 5.2, flexDirection: 'row', marginBottom: 20 }}>
                                {
                                    item.imgs && item.imgs.length > 0 ? (
                                        item.imgs.map((items, indexs) => {
                                            return (
                                                <TouchableOpacity activeOpacity={.7}
                                                    key={indexs}
                                                    activeOpacity={1}
                                                    onPress={() => this.onClickImage(items, indexs)}
                                                >
                                                    <Images
                                                        key={indexs}
                                                        userPic={items}
                                                        index={indexs}
                                                        lengths={item.imgs.length}
                                                        modalNum='100'
                                                        width='90'
                                                        height='90'
                                                        marginRight='5'
                                                        marginBottom='5'
                                                    />
                                                </TouchableOpacity>
                                            )
                                        })
                                    ) : (false)
                                }
                            </View>
                        </View>
                    </View>

                    {/* 没有更多了 */}
                    {
                        id == item.id ? (
                            <View>
                                <View style={{ flexDirection: 'row', alignItems: 'center', marginBottom: 20 }}>
                                    <View style={{ width: 12, height: 12, marginRight: 16, marginLeft: 3, backgroundColor: 'rgb(245,245,245)', borderRadius: 14 }}></View>
                                    <Text style={{ color: '#999', fontSize: 13.2, marginRight: 13.2 }}>没有更多了</Text>
                                </View>
                            </View>
                        ) : false
                    }
                </View>

            </View>
        )
    }
}
const styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: '#fff',
    },
    bg: {
        backgroundColor: 'rgb(85,65,190)'
    },
    lanmu: {
        marginTop: 4.5,
        marginBottom: 4.5,
        flexDirection: 'row',
        alignItems: 'flex-start',

    },
    fontl: {
        color: "#999",
        fontSize: 15.4
    },
    fontr: {
        color: "#000",
        fontSize: 15.4
    },
    fontrs: {
        color: "#000",
        fontSize: 15.4,
        flexWrap: 'wrap',
        width: 280,
    },
    tit: {
        marginLeft: 22,
        marginRight: 22,
        marginTop: 11,
        marginBottom: 4.5,
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center'
    },
    titfont: {
        color: '#000',
        fontSize: 18.7,
        fontWeight: '400',
        marginLeft: 11,
        marginRight: 11,
    },
    a: {
        width: 3,
        height: 13,
        borderRadius: 2,
        marginRight: 2,
        backgroundColor: '#fa6ba2',
        transform: [{ rotate: '15deg' }]
    },
    b: {
        width: 3,
        height: 13,
        borderRadius: 2,
        marginRight: 2,
        backgroundColor: '#efbb59',
        transform: [{ rotate: '15deg' }]
    },
    viewfont: {
        paddingLeft: 22,
        paddingRight: 22,
        paddingTop: 11,
        paddingBottom: 11,
        flexDirection: 'row',
        justifyContent: "center",
        flexWrap: 'wrap',
    },
    font: {
        color: '#000',
        fontSize: 15.4,
        lineHeight: 20
    },
});