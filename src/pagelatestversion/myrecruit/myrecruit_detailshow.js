/*
 * @Author: mikey.zhaopeng 
 * @Date: 2019-03-29 18:26:49 
 * @Last Modified by: mikey.zhaopeng
 * @Last Modified time: 2019-04-17 14:37:11
 * Module:发布招工-招工详情
 */

import React, { Component } from 'react'
import {
    StyleSheet, Text, View, TouchableOpacity, Image, ScrollView, Modal, DeviceEventEmitter,
    Platform, NativeModules
} from 'react-native';
import Icon from "react-native-vector-icons/iconfont";
import fetchFun from '../../fetch/fetch'
import { Toast } from '../../component/toast'
import LinearGradient from 'react-native-linear-gradient'

import Info from '../recruit_homepage/detail'

export default class jobdetails extends Component {
    constructor(props) {
        super(props)
        this.state = {
            //     list: {},
            //     showModal: false,
            //     is_closed:0
            // }
            // this.getList = this.getList.bind(this)
            list: {},
            showModal: false,
            is_closed: this.props.navigation.state.params.is_closed
        }
		this.getList = this.getList.bind(this)
    }
    // 顶部导航
    static navigationOptions = ({ navigation, screenProps }) => ({
        header: null, gesturesEnabled: false,
    });
    componentWillMount() {
        this.getList()
        // this.setState({
        //     is_closed:this.props.navigation.getParam('is_closed')?this.props.navigation.getParam('is_closed'):0
        // })
    }
    getList() {
        // console.log(this.props.navigation.state.params)
        let { pid, work_type } = this.props.navigation.state.params
        // 兼容下面的GLOBAL参数
        if (pid) {
            GLOBAL.pid = pid
            GLOBAL.fbzgType.fbzgTypeNum = work_type
        }
        fetchFun.load({
            url: 'jlwork/prodetailactive',
            data: {
                pid: GLOBAL.pid,
                work_type: GLOBAL.fbzgType.fbzgTypeNum,//工种编号
                kind: 'recruit'
            },
            success: (res) => {
                console.log('---项目详情---', res)
                this.setState({
                    list: res,
                    item: res //share 方法用的是item,所以这里多写一个
                })
            }
        });
    }
    stateProject(type, actData) {
        // if (type != "search") {
        //     if (!isUserInfo(this.props, {perfect: true})) {
        //         return false;
        //     }
        // }
        // const {rPara1} = this.props;
        console.log(actData)
        switch (type) {
			case 'handle':
				let { is_closed } = this.state
                fetchFun.load({
                    url: 'jlforemanwork/operateProject',
                    data: {
                        pwd_id: actData.pwd_id,
                        pid: actData.pid,
                        status: +!is_closed
                    },
                    success: (res) => {
                        Toast.show(!is_closed ? '招工已停止' : '招工已重新发布')

                        this.getList()
                        this.setState({
                            is_closed: is_closed == 0 ? 1 : 0
						})
                    }
                })

                // case 'handle':
                // 	fetchFun.load({
                // 		url: 'jlforemanwork/operateProject',
                // 		data: {
                // 			pwd_id: this.props.navigation.state.params.pwd_id,
                // 			pid: actData.pid,
                // 			status: actData.is_closed || 0	,
                // 			kind:'recruit'
                // 		},
                // 		success: (res) => {
                // 			Toast.show(actData.is_closed ? '招工已停止' : '招工已重新发布')
                // 			this.setState({
                // 				is_closed:actData.is_closed
                // 			})
                // 			this.getList()
                // 		}
                // 	})

                break;
            case 'fresh':
                fetchFun.load({
                    url: 'jlwork/refresh',
                    data: {
                        pid: actData.pid
                    },
                    success: (res) => {
                        Toast.show('刷新成功')
                        this.getList()
                    }
                })
                break;
            case 'remove':
                this.toggleModal()
                fetchFun.load({
                    url: 'jlforemanwork/sliceproject',
                    data: {
                        pid: actData.pid
                    },
                    success: (res) => {
                        Toast.show('删除成功')
						// this.getList()
						this.props.navigation.state.params.callback()
                        this.props.navigation.goBack()
                    }
                })
                break;
            case 'remove_confirm':
                this.toggleModal()
                // this.props.SynData({
                //     isShow: true,
                //     text: '确定要删除该招工信息吗？',
                //     callback: this.StateProject.bind(this, 'remove', actData),
                //     mold: "confirm"
                // }, "SYN_REMINDER");
                break;
            case 'edit':
                // this.props.navigation.navigate('Myrecruit', { work_type: actData.work_type })
                console.log(this.props.navigation.getParam('item'))
                this.props.navigation.navigate('Myrecruit_detail', { item: this.props.navigation.getParam('item')?this.props.navigation.getParam('item'):this.state.list,edit:'edit' })//跳转到招工详情页执行修改操作
                break;
            case 'search':
                this.props.navigation.navigate('Myrecruit_suit', {
                    role_type: actData.role_type,
                    work_type: actData.classes[0].work_type.type_id,
                    work_name: actData.classes[0].work_type.type_name,
                    city_no: actData.city_no,
                    city_name: actData.city_name,
                    pid: actData.pid,
                    isProject: 1
                })
                break;
            default:
                return false
        }
    }
    toggleModal() {
        let { showModal } = this.state
        this.setState({
            showModal: !showModal
        })
    }
    render() {
        let item = this.state.list,
        // let item = this.state.list
        { is_closed } = this.state
        if(this.props.navigation.getParam('item')){
            item = this.props.navigation.getParam('item')
        }
        return (
            <View style={styles.main}>
                {/* 导航条 */}
                <View style={{
                    height: 48, backgroundColor: '#FAFAFA', position: 'relative',
                    flexDirection: 'row', alignItems: 'center', justifyContent: "space-between",
                    borderBottomWidth: 1, borderBottomColor: '#ebebeb'
                }}>
                    <TouchableOpacity activeOpacity={.7} style={{ flexDirection: 'row', alignItems: 'center', marginLeft: 10, marginBottom: 1, width: '25%' }}
                        // onPress={() => { this.props.navigation.navigate('Recruit_homepage'), DeviceEventEmitter.emit("EventType", param) }}
                        onPress={() => { this.props.navigation.goBack(), this.props.navigation.state.params.callback() }}
                    >
                        <Icon style={{ marginRight: 3 }} name="l-arrow" size={19} color="#eb4e4e" />
                        <Text style={{ marginRight: 10, color: '#eb4e4e', fontWeight: '400', fontSize: 17 }}>返回</Text>
                    </TouchableOpacity>
                    <View style={{ flex: 1, flexDirection: 'row', justifyContent: 'center', alignItems: 'center' }}>
                        <Text style={{ fontSize: 17, color: '#000000', fontWeight: '400', }}>项目详情</Text>
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

                {item ?
                    <Info
                        item={item}
                        isMy
                        style={{
                            flex: 1, backgroundColor: '#fff'
                        }}
                    /> :
                    null
                }

                {/* 底部固定按钮 */}
                <View style={{
                    height: 64, backgroundColor: '#fff', flexDirection: 'row', justifyContent: 'space-between',
                    padding: 10, position: 'absolute', bottom: 0, width: '100%',borderTopWidth:1,borderTopColor:'#dbdbdb'
                }}>
                    {/* <TouchableOpacity activeOpacity={.7}
                        onPress={
                            () => this.stateProject('handle', {
                                pid: item.pid,
                                pwd_id: item.classes[0].pwd_id,
                                is_closed: item.is_closed == 1 ? 0 : 1
                            })
                        }
                        style={{
                            borderColor: '#eb4e4e', borderWidth: 1, borderRadius: 4, paddingTop: 3,
                            flexDirection: 'row', alignItems: 'center', justifyContent: 'center', flex: 1, marginRight: 10
                        }}
                    >
                    {
                        this.state.is_closed == 0 ? (
                            <Text style={{ color: '#eb4e4e', fontSize: 15, textAlign: 'center', lineHeight: 20 }}>重新发布</Text>
                        ) : (
                            <Text style={{ color: '#eb4e4e', fontSize: 15, textAlign: 'center', lineHeight: 20 }}>停止</Text>
                        )
                    }
                    </TouchableOpacity>
                    
                    {
                        this.state.is_closed == 0 ? false: (
                            <TouchableOpacity activeOpacity={.7}
                                onPress={
                                    () => this.stateProject('fresh', {
                                        pid: item.pid
                                    })
                                }
                                style={{
                                    borderColor: '#eb4e4e', borderWidth: 1, borderRadius: 4, paddingTop: 3,
                                    flexDirection: 'row', alignItems: 'center', justifyContent: 'center', flex: 1, marginRight: 10
                                }}
                            >
                            <Text style={{ color: '#eb4e4e', fontSize: 15, textAlign: 'center', lineHeight: 20 }}>刷新</Text>
                            </TouchableOpacity>
                        )
                    }
                    
                    <TouchableOpacity activeOpacity={.7}
                        onPress={() => {
                            this.stateProject('edit', {
                                item: item
                            })
                        }}
                        style={{
                            borderColor: '#eb4e4e', borderWidth: 1, borderRadius: 4, paddingTop: 3,
                            flexDirection: 'row', alignItems: 'center', justifyContent: 'center', flex: 1, marginRight: 10
                        }}
                    > */}
                    <TouchableOpacity activeOpacity={.7}
                        onPress={
                            () => this.stateProject('handle', {
                                pid: item.pid,
                                pwd_id: item.classes[0].pwd_id,
                                is_closed: is_closed == 1 ? 0 : 1
                            })
                        }
                        style={{
                            borderColor: '#eb4e4e', borderWidth: 1, borderRadius: 4, paddingTop: 3,
                            flexDirection: 'row', alignItems: 'center', justifyContent: 'center', flex: 1, marginRight: 10
                        }}
                    >
                        <Text style={{ color: '#eb4e4e', fontSize: 15, textAlign: 'center', lineHeight: 20 }}>{is_closed == 1 ? '重新发布' : '停止'}</Text>
                    </TouchableOpacity>
                    {is_closed == 1 ?
                        null :
                        <TouchableOpacity activeOpacity={.7}
                            onPress={
                                () => this.stateProject('fresh', {
                                    pid: item.pid
                                })
                            }
                            style={{
                                borderColor: '#eb4e4e', borderWidth: 1, borderRadius: 4, paddingTop: 3,
                                flexDirection: 'row', alignItems: 'center', justifyContent: 'center', flex: 1, marginRight: 10
                            }}
                        >
                            <Text style={{ color: '#eb4e4e', fontSize: 15, textAlign: 'center', lineHeight: 20 }}>刷新</Text>
                        </TouchableOpacity>
                    }
                    <TouchableOpacity activeOpacity={.7}
                        onPress={() => {
                            this.stateProject('edit', {
                                pid: item.pid,
                                work_type: item.classes[0].work_type.type_id
                            })
                        }}
                        style={{
                            borderColor: '#eb4e4e', borderWidth: 1, borderRadius: 4, paddingTop: 3,
                            flexDirection: 'row', alignItems: 'center', justifyContent: 'center', flex: 1, marginRight: 10
                        }}
                    >
                        <Text style={{ color: '#eb4e4e', fontSize: 15, textAlign: 'center', lineHeight: 20 }}>修改</Text>
                    </TouchableOpacity>
                    <TouchableOpacity activeOpacity={.7}
                        onPress={() => this.stateProject('remove_confirm', {
                            pid: item.pid
                        })}
                        style={{
                            borderColor: '#eb4e4e', borderWidth: 1, borderRadius: 4, paddingTop: 3,
                            flexDirection: 'row', alignItems: 'center', justifyContent: 'center', flex: 1
                        }}
                    >
                        <Text style={{ color: '#eb4e4e', fontSize: 15, textAlign: 'center', lineHeight: 20 }}>删除</Text>
                    </TouchableOpacity>
                </View>
                <Modal
                    visible={this.state.showModal}
                    animationType="none"//从底部划出
                    transparent={true}//透明蒙层
                    onRequestClose={() => this.toggleModal()}//点击返回的回调函数
                    style={{ height: '100%' }}
                >
                    <TouchableOpacity activeOpacity={.7}
                        onPress={() => this.toggleModal()}
                        style={{ flex: 1, backgroundColor: 'rgba(0,0,0,.5)', flexDirection: 'row', justifyContent: 'center', alignItems: 'center' }}>
                        {/* 弹窗内容 */}
                        <View style={{ backgroundColor: '#fff', borderRadius: 7.7, overflow: 'hidden', width: 300 }}>
                            <View style={{ padding: 16.5, minHeight: 100, justifyContent: 'center', alignItems: 'center' }}>
                                <Text>确定要删除该招工信息吗？</Text>
                            </View>
                            {/* 按钮 */}
                            <View style={{
                                flexDirection: 'row', alignItems: 'center',
                                borderTopWidth: 1.5, borderTopColor: '#ebebeb', height: 48, backgroundColor: '#fafafa',
                            }}>
                                <TouchableOpacity activeOpacity={.7}
                                    onPress={() => this.toggleModal()}
                                    style={{
                                        flexDirection: 'row', alignItems: 'center', justifyContent: 'center',
                                        borderRightWidth: 1, borderRightColor: '#ebebeb', width: '50%', height: '100%'
                                    }}>
                                    <Text style={{ color: '#000', fontSize: 16.5 }}>取消</Text>
                                </TouchableOpacity>
                                <TouchableOpacity activeOpacity={.7}
                                    onPress={() => this.stateProject('remove', {
                                        pid: item.pid
                                    })}
                                    style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'center', flex: 1, height: '100%' }}>
                                    <Text style={{ color: '#eb4e4e', fontSize: 16.5 }}>确定</Text>
                                </TouchableOpacity>
                            </View>
                        </View>
                    </TouchableOpacity>
                </Modal>
            </View>
        )
    }
    //分享
    share() {
        // let shareSuid = "";
        // if (this.state.item && this.state.item.uid) {
        //     shareSuid = "&suid=" + this.state.item.uid;
        // }
        // let shareData = {
        //     type: 0,
        //     title: this.state.item.pro_title,
        //     url: this.state.item.share.wxshare_uri,
        //     imgUrl: this.state.item.share.wxshare_img,
        //     describe: this.state.item.share.wxshare_desc,
        //     wxMini: {
        //         appId: GLOBAL.miniJobAppId,
        //         path: `/pages/job/work/info?pid=${this.state.item.pid}&share=1${shareSuid}`,
        //     }
        // };
        let shareSuid = "";
        if (this.state.item && this.state.item.uid) {
            shareSuid = "&suid=" + this.state.item.uid;
        }
        let imgUrl = ''
        if (this.state.item.share.wxshare_img.indexOf('http://api.yzgong.com') != -1) {
            imgUrl = this.state.item.share.wxshare_img.replace('http://api.yzgong.com', 'http://test.cdn.jgjapp.com')
        } else {
            imgUrl = this.state.item.share.wxshare_img
        }
        let shareData = {
            appId: GLOBAL.miniJobAppId,
            describe: this.state.item.share.wxshare_desc,
            imgUrl: imgUrl,
            path: `/pages/job/work/info?pid=${this.state.item.pid}&share=1${shareSuid}`,
            title: this.state.item.pro_title,
            topdisplay: 0,
            type: 0,
            typeImg: '',
            // url:this.state.item.share.wxshare_uri,
            url: `${GLOBAL.server}work/${this.state.item.pid}?plat=${this.state.item.pid}person`,
            wxMiniDrawable: 0,
            state: 0,
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
        marginBottom: 11,
    },
})