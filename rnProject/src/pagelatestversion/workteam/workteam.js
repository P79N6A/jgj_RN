/*
 * @Author: mikey.zhaopeng 
 * @Date: 2019-03-29 16:45:13 
 * @Last Modified by: mikey.zhaopeng
 * @Last Modified time: 2019-04-11 17:30:56
 * Module:工人/班组
 */

import React, { Component } from 'react';
import {
    StyleSheet,
    Text,
    View,
    TouchableOpacity,
} from 'react-native';
import ModalDropdown from 'react-native-modal-dropdown';
import Brandteam from './workteam_brand'
import Highquaworker from './workteam_highqua'
import Highqua from './workteam_yz'
import Icon from "react-native-vector-icons/Ionicons";

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
        header: null
    });
    render() {
        return (
            <View style={{ backgroundColor: '#fff', flex: 1 }}>
                {/* 导航条 */}
                <View style={{
                    height: 48, backgroundColor: '#FAFAFA', position: 'relative',
                    flexDirection: 'row', alignItems: 'center', justifyContent: "space-between",
                    borderBottomWidth: 1, borderBottomColor: '#ebebeb'
                }}>
                    <TouchableOpacity style={{ flexDirection: 'row', alignItems: 'center', marginLeft: 10, marginBottom: 1, width: '25%' }}
                        onPress={() => this.props.navigation.goBack()}>
                        <Icon style={{ marginRight: 3 }} name="l-arrow" size={19} color="#eb4e4e" />
                        <Text style={{ marginRight: 10, color: '#eb4e4e', fontWeight: '400', fontSize: 17 }}>返回</Text>
                    </TouchableOpacity>
                    <View style={{ flex: 1, flexDirection: 'row', justifyContent: 'center', alignItems: 'center' }}>
                        <Text style={{ fontSize: 17, color: '#3d4145', fontWeight: '400', }}>优质劳务</Text>
                    </View>
                    <TouchableOpacity style={{ width: '25%', height: '100%', marginRight: 10, flexDirection: 'row', alignItems: 'center', justifyContent: 'flex-end' }}>
                    </TouchableOpacity>
                </View>

                {/* 选项卡 */}
                <View style={styles.TabControl}>
                    <TouchableOpacity style={styles.TabControlItema} onPress={() => this.TabChooseToggleFun('a')}>
                        <Text style={{ color: this.state.TabChoose === 'LianXi' ? '#eb4e4e' : '#000', fontSize: 16.5 }}>品牌班组</Text>
                        {this.showfuna()}
                    </TouchableOpacity>
                    
                    <TouchableOpacity style={styles.TabControlItemb} onPress={() => this.TabChooseToggleFun('b')}>
                        <Text style={{ color: this.state.TabChoose === 'ZhenTi' ? '#eb4e4e' : '#000', fontSize: 16.5 }}>优质工人</Text>
                        {this.showfunb()}
                    </TouchableOpacity>
                    
                    <TouchableOpacity style={styles.TabControlItemc} onPress={() => this.TabChooseToggleFun('c')}>
                        <Text style={{ color: this.state.TabChoose === 'Tujidui' ? '#eb4e4e' : '#000', fontSize: 16.5 }}>优质突击队</Text>
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
        }else if (e == 'c') {
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
        }else if (this.state.TabChoose === 'c') {
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
        flex:1,
        position: 'relative',
        borderRightWidth: 1,
        borderRightColor: '#ebebeb',
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