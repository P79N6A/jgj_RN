/*
 * @Author: mikey.zhaopeng 
 * @Date: 2019-03-29 16:45:13 
 * @Last Modified by: stl
 * @Last Modified time: 2019-05-20 14:25:46
 * Module:工人/班组
 */

import React, { Component } from 'react';
import {
    StyleSheet,
    Text,
    View,
    TouchableOpacity,
    NativeModules,
    DeviceEventEmitter,
    Platform,
    BackHandler
} from 'react-native';
import ModalDropdown from 'react-native-modal-dropdown';
import Brandteam from './workteam_brand'
import Highquaworker from './workteam_highqua'
import Highqua from './workteam_yz'
import Icon from "react-native-vector-icons/iconfont";

export default class hiriingrecord extends Component {
    constructor(props) {
        super(props)
        this.state = {
            TabChoose: 'a',
            sja: true,
            sjb: false,
            sjc: false,
        }
    }
    // 顶部导航
    static navigationOptions = ({ navigation, screenProps }) => ({
        header: null, gesturesEnabled: false,
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
                        <Text style={{ fontSize: 17, color: '#000000', fontWeight: '400', }}>优质劳务</Text>
                    </View>
                    <TouchableOpacity activeOpacity={.7} style={{ width: '25%', height: '100%', marginRight: 10, flexDirection: 'row', alignItems: 'center', justifyContent: 'flex-end' }}>
                    </TouchableOpacity>
                </View>

                {/* 选项卡 */}
                <View style={styles.TabControl}>
                    <TouchableOpacity activeOpacity={.7} style={styles.TabControlItema} onPress={() => this.TabChooseToggleFun('a')}>
                        <Text style={{ color: this.state.TabChoose === 'a' ? '#eb4e4e' : '#000', fontSize: 16.5 }}>品牌班组</Text>
                        {this.showfuna()}
                    </TouchableOpacity>

                    <TouchableOpacity activeOpacity={.7} style={styles.TabControlItemb} onPress={() => this.TabChooseToggleFun('b')}>
                        <Text style={{ color: this.state.TabChoose === 'b' ? '#eb4e4e' : '#000', fontSize: 16.5 }}>优质工人</Text>
                        {this.showfunb()}
                    </TouchableOpacity>

                    <TouchableOpacity activeOpacity={.7} style={styles.TabControlItemc} onPress={() => this.TabChooseToggleFun('c')}>
                        <Text style={{ color: this.state.TabChoose === 'c' ? '#eb4e4e' : '#000', fontSize: 16.5 }}>优质突击队</Text>
                        {this.showfunc()}
                    </TouchableOpacity>
                </View>
                {/* 选项卡面板 */}
                {this.TabChooseTogglePanelFunWrap()}
            </View>
        )
    }
    showfuna() {
        if (this.state.sja) {
            return (
                <View>
                    <View style={styles.sj}><View style={styles.tabsj}></View></View>
                    <View style={styles.tabbot}></View>
                </View>
            )
        }
    }
    showfunb() {
        if (this.state.sjb) {
            return (
                <View>
                    <View style={styles.sj}><View style={styles.tabsj}></View></View>
                    <View style={styles.tabbot}></View>
                </View>
            )
        }
    }
    showfunc() {
        if (this.state.sjc) {
            return (
                <View>
                    <View style={styles.sj}><View style={styles.tabsj}></View></View>
                    <View style={styles.tabbot}></View>
                </View>
            )
        }
    }
    TabChooseToggleFun(e) {
        if (e != this.state.TabChoose) {
            this.setState({
                TabChoose: e,
            })
        }
        if (e == 'a') {
            this.setState({
                sja: true,
                sjb: false,
                sjc: false,
            })
        } else if (e == 'b') {
            this.setState({
                sja: false,
                sjb: true,
                sjc: false,
            })
        } else if (e == 'c') {
            this.setState({
                sja: false,
                sjb: false,
                sjc: true,
            })
        }
    }
    // 选项卡面板
    TabChooseTogglePanelFunWrap() {
        if (this.state.TabChoose === 'a') {
            return (
                <View style={{ flex: 1, backgroundColor: '#fff' }}>
                    <Brandteam navigate={this.props.navigation} />
                </View>
            )
        } else if (this.state.TabChoose === 'b') {
            return (
                <View style={{ flex: 1, backgroundColor: '#fff' }}>
                    <Highquaworker navigate={this.props.navigation} />
                </View>
            )
        } else if (this.state.TabChoose === 'c') {
            return (
                <View style={{ flex: 1, backgroundColor: '#fff' }}>
                    <Highqua navigate={this.props.navigation} />
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
        width: '33.33%',
        position: 'relative',
        borderRightWidth: 1,
        borderRightColor: '#ebebeb',
    },
    TabControlItemb: {
        height: 47,
        alignItems: 'center',
        justifyContent: 'center',
        width: '33.33%',
        position: 'relative',
        borderRightWidth: 1,
        borderRightColor: '#ebebeb',
    },
    TabControlItemc: {
        height: 47,
        alignItems: 'center',
        justifyContent: 'center',
        flex: 1,
        position: 'relative',
        borderRightWidth: 1,
        borderRightColor: '#ebebeb',
    },
    sj: {
        flexDirection: 'row',
        justifyContent: 'center',
        position: 'absolute',
        bottom: -9,
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