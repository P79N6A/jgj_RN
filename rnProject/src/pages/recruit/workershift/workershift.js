/*
 * @Author: mikey.zhaopeng 
 * @Date: 2019-03-25 11:05:05 
 * @Module:工人/班组（优质劳务）
 * @Last Modified time: 2019-03-25 11:05:05 
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
    RefreshControl
} from 'react-native';
import ModalDropdown from 'react-native-modal-dropdown';
import Brandteam from './brandteam'
import Highquaworker from './highquaworker'
import Icon from "react-native-vector-icons/Ionicons";

export default class hiriingrecord extends Component {
    constructor(props) {
        super(props)
        this.state = {
            TabChoose: 'a',
            sja: true,
            sjb: false,
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
                        <Icon style={{marginRight: 3}} name="l-arrow" size={19} color="#eb4e4e" />
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
            })
        } else if (e == 'b') {
            this.setState({
                sja: false,
                sjb: true,
            })
        }
    }
    // 选项卡面板
    TabChooseTogglePanelFunWrap() {
        if (this.state.TabChoose === 'a') {
            return (
                <View style={{ flex: 1, backgroundColor: '#fff' }}>
                    <Brandteam navigation={this.props.navigation} />
                </View>
            )
        } else if (this.state.TabChoose === 'b') {
            return (
                <View style={{ flex: 1, backgroundColor: '#fff' }}>
                    <Highquaworker navigation={this.props.navigation} />
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