/*
 * @Author: mikey.zhaopeng 
 * @Date: 2019-04-08 15:44:54 
 * @Last Modified by: mikey.zhaopeng
 * @Last Modified time: 2019-04-09 11:06:08
 * Module：我的招聘
 */

import React, { Component } from 'react';
import {
    StyleSheet,
    Text,
    View,
    Image,
    ScrollView,
    TouchableOpacity,
    Platform,
    FlatList,
    RefreshControl,
    Modal,
    NativeModules,
    DeviceEventEmitter,
    BackHandler
} from 'react-native';
import ModalDropdown from 'react-native-modal-dropdown';
import HiringrecordA from './hiringrecorda'
import HiringrecordB from './hiringrecordb'
import Icon from "react-native-vector-icons/iconfont";

export default class hiriingrecord extends Component {
    constructor(props) {
        super(props)
        this.state = {

            ifModal: false// 弹框
        }
    }
    // 顶部导航
    static navigationOptions = ({ navigation, screenProps }) => ({
        header: null,gesturesEnabled: false,
    });
    componentDidMount() {
        // 底部导航控制
        this.bottomTab()

        // android返回start==================================
        BackHandler.addEventListener('hardwareBackPress', this.onBackButtonPressAndroid);
    }
    componentWillUnmount() {
        BackHandler.removeEventListener('hardwareBackPress', this.onBackButtonPressAndroid);
    }
    onBackButtonPressAndroid = () => {
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
    // android返回end====================================================

    bottomTab() {
        if (Platform.OS == 'android' && GLOBAL.client_type == 'person') {//android个人端
            NativeModules.MyNativeModule.footerController('{state:"hide"}');//调用原生方法
        }
        if (Platform.OS == 'ios' && GLOBAL.client_type == 'person') {//android个人端
            NativeModules.JGJRecruitmentController.footerController({ state: "hide" });//调用原生方法
        }
    }
    render() {
        return (
            <View style={{ backgroundColor: '#fff', flex: 1 }}>
                {/* 导航条 */}
                <View style={{
                    height: 48, backgroundColor: '#FAFAFA', position: 'relative',
                    flexDirection: 'row', alignItems: 'center', justifyContent: "space-between",
                    borderBottomWidth: 1, borderBottomColor: '#ebebeb'
                }}>
                    <TouchableOpacity activeOpacity={.7} style={{ flexDirection: 'row', alignItems: 'center', marginLeft: 10, marginBottom: 1, width: '25%' }}
                        onPress={() => { this.props.navigation.goBack(), DeviceEventEmitter.emit("EventType", param) }}>
                        <Icon style={{ marginRight: 3 }} name="l-arrow" size={19} color="#eb4e4e" />
                        <Text style={{ marginRight: 10, color: '#eb4e4e', fontWeight: '400', fontSize: 17 }}>返回</Text>
                    </TouchableOpacity>
                    <View style={{ flex: 1, flexDirection: 'row', justifyContent: 'center', alignItems: 'center' }}>
                        <Text style={{ fontSize: 17, color: '#000000', fontWeight: '400', }}>我的招聘</Text>
                    </View>
                    <TouchableOpacity activeOpacity={.7}
                        onPress={() => this.ifModalFun()}
                        style={{
                            width: '25%', height: '100%', marginRight: 10,
                            flexDirection: 'row', alignItems: 'center', justifyContent: 'flex-end'
                        }}>
                        <Text style={{ fontSize: 17, color: '#eb4e4e', fontWeight: '400', }}>
                            找人记录
                        </Text>
                    </TouchableOpacity>
                </View>

                {/* 找人记录弹框 */}
                <Modal
                    animationType="none"
                    transparent={true}
                    visible={this.state.ifModal}
                    onRequestClose={() => {
                        this.setState({
                            ifModal: !this.state.ifModal
                        })
                    }}>
                    <TouchableOpacity activeOpacity={.7} style={{ width: '100%', height: '100%' }}
                        onPress={() => this.setState({
                            ifModal: !this.state.ifModal
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

                            <View
                                style={{
                                    width: 101,
                                    backgroundColor: "rgb(74,74,74)", borderRadius: 4
                                }}>
                                <TouchableOpacity activeOpacity={.7}
                                    onPress={() => this.contactFun()}
                                    style={{
                                        paddingLeft: 17.6, paddingRight: 17.6, paddingTop: 15.4, paddingBottom: 15.4,
                                        borderBottomWidth: .2, borderBottomColor: '#ebebeb'
                                    }}>
                                    <Text style={{ color: "#fff", fontSize: 16 }}>我联系的</Text>
                                </TouchableOpacity>
                                <TouchableOpacity activeOpacity={.7}
                                    onPress={() => this.conllectionFun()}
                                    style={{ paddingLeft: 17.6, paddingRight: 17.6, paddingTop: 15.4, paddingBottom: 15.4, }}>
                                    <Text style={{ color: "#fff", fontSize: 16 }}>我收藏的</Text>
                                </TouchableOpacity>
                            </View>
                        </View>
                    </TouchableOpacity>
                </Modal>

                {/* 选项卡 */}
                <View style={styles.TabControl}>
                    <TouchableOpacity activeOpacity={.7} style={styles.TabControlItema} onPress={() => this.TabChooseToggleFun('a')}>
                        <Text style={{ color: GLOBAL.TabChoose === 'a' ? '#eb4e4e' : '#000', fontSize: 16.5 }}>我的招工</Text>
                        {this.showfuna()}
                    </TouchableOpacity>
                    <View style={styles.borders}></View>
                    <TouchableOpacity activeOpacity={.7} style={styles.TabControlItemb} onPress={() => this.TabChooseToggleFun('b')}>
                        <Text style={{ color: GLOBAL.TabChoose === 'b' ? '#eb4e4e' : '#000', fontSize: 16.5 }}>我的找活</Text>
                        {this.showfunb()}
                    </TouchableOpacity>

                </View>
                <View style={styles.bgsty}></View>
                {/* 选项卡面板 */}
                {this.TabChooseTogglePanelFunWrap()}
            </View>
        )
    }
    // 跳转到我联系的页面
    contactFun() {
        this.setState({
            ifModal: !this.state.ifModal
        }, () => {
            this.props.navigation.navigate('My_contact')
        })
    }
    // 跳转到我收藏的页面
    conllectionFun() {
        this.setState({
            ifModal: !this.state.ifModal
        }, () => {
            this.props.navigation.navigate('My_conllection')
        })
    }
    //弹框
    ifModalFun() {
        this.setState({
            ifModal: !this.state.ifModal
        })
    }
    showfuna() {
        if (GLOBAL.TabChoose == 'a') {
            return (
                <View>
                    <View style={styles.sj}><View style={styles.tabsj}></View></View>
                    <View style={styles.tabbot}></View>
                </View>
            )
        }
    }
    showfunb() {
        if (GLOBAL.TabChoose == 'b') {
            return (
                <View>
                    <View style={styles.sj}><View style={styles.tabsj}></View></View>
                    <View style={styles.tabbot}></View>
                </View>
            )
        }
    }
    TabChooseToggleFun(e) {
        if (e != GLOBAL.TabChoose) {
            GLOBAL.TabChoose = e
            this.setState({})
        }
    }
    // 选项卡面板
    TabChooseTogglePanelFunWrap() {
        if (GLOBAL.TabChoose === 'a') {
            return (
                <View style={{ flex: 1, backgroundColor: '#fff' }}>
                    <HiringrecordA navigation={this.props.navigation} />
                </View>
            )
        } else if (GLOBAL.TabChoose === 'b') {
            return (
                <View style={{ flex: 1, backgroundColor: '#fff' }}>
                    <HiringrecordB navigation={this.props.navigation} />
                </View>
            )
        }
    }
}
const styles = StyleSheet.create({
    TabControl: {
        flexDirection: 'row',
        alignItems: 'center',
        height: 47,
        width: '100%',
        justifyContent: 'space-between',
        borderBottomWidth: 1, borderBottomColor: '#ebebeb'
    },
    TabControlItema: {
        height: 47,
        alignItems: 'center',
        justifyContent: 'center',
        width: '50%',
        position: 'relative',
        borderRightWidth: 1,
        borderRightColor: '#ebebeb',
    },
    TabControlItemb: {
        height: 47,
        alignItems: 'center',
        justifyContent: 'center',
        width: '50%',
        position: 'relative',
        borderRightWidth: 1,
        borderRightColor: '#ebebeb',
    },
    TabControlItemc: {
        height: 47,
        alignItems: 'center',
        justifyContent: 'center',
        width: '33.33%',
        position: 'relative',
    },
    sj: {
        flexDirection: 'row',
        justifyContent: 'center',
        position: 'absolute',
        bottom: -8,
        left: -4
    },
    tabsj: {
        borderStyle: 'solid',
        borderWidth: 5,
        borderLeftColor: 'transparent',
        borderTopColor: 'transparent',
        borderRightColor: 'transparent',
        borderBottomColor: 'red',
        width: 0,
        height: 0,
    },
    tabbot: {
        width: 60,
        height: 3,
        backgroundColor: 'red',
        position: 'absolute',
        bottom: -10,
        left: -29,
        marginBottom: -1
    },
    textsty: {
        color: 'blue',
        fontSize: 20,
        fontWeight: '100',
        margin: 10
    },
})