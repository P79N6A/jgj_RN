/*
 * @Author: mikey.zhaopeng 
 * @Date: 2019-03-21 10:42:42 
 * @Module：找工人
 * @Last Modified time: 2019-03-21 11:16:20
 */
import React, { Component } from 'react';
import {
    StyleSheet,
    Text,
    View,
    ActivityIndicator,
    ListView,
    Image,
    ScrollView,
    Dimensions,
    TouchableOpacity,
    StatusBar,
    Platform,
    FlatList,
    RefreshControl
} from 'react-native';
import Icon from "react-native-vector-icons/Ionicons";

export default class lookworker extends Component {
    constructor(props) {
        super(props)
        this.state = {
            lookworker: true,//找工人还是找工作，true为招工组
        }
    }
    // 顶部导航
    static navigationOptions = ({ navigation, screenProps }) => ({
        header: null
    });
    render() {
        return (
            <View style={styles.main}>
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
                        <Text style={{ fontSize: 17, color: '#3d4145', fontWeight: '400', }}>找工人</Text>
                    </View>
                    <TouchableOpacity
                        style={{ width: '25%', height: '100%', marginRight: 10, flexDirection: 'row', alignItems: 'center', justifyContent: 'flex-end' }}>
                    </TouchableOpacity>
                </View>
                {/* 找工人/招工组 */}
                <View style={styles.bg}>
                    <TouchableOpacity
                        onPress={() => this.selectFunworker()}
                        style={{ width: '50%', flexDirection: 'row', alignItems: 'center', justifyContent: 'center' }}>
                        {
                            this.state.lookworker ? (
                                <Icon name="xuanzeyixuan" size={18} color="#eb4e4e" />
                            ) : (
                                    <Icon name="weixuanze" size={18} color="#666666" />
                                )
                        }
                        <Text style={{ color: '#000', fontSize: 17.6, fontWeight: '700', marginLeft: 11 }}>找工人</Text>
                    </TouchableOpacity>
                    <TouchableOpacity
                        onPress={() => this.selectFunworkerNo()}
                        style={{ width: '50%', flexDirection: 'row', alignItems: 'center', justifyContent: 'center' }}>
                        {
                            !this.state.lookworker ? (
                                <Icon name="xuanzeyixuan" size={18} color="#eb4e4e" />
                            ) : (
                                <Icon name="weixuanze" size={18} color="#666666" />
                                )
                        }
                        <Text style={{ color: '#000', fontSize: 17.6, fontWeight: '700', marginLeft: 11 }}>找班组</Text>
                    </TouchableOpacity>
                </View>
                {/* 所需工种 */}
                <TouchableOpacity onPress={() => this.props.navigation.navigate('Zgrtype', {
                    callback: (() => {
                        this.setState({})
                    })
                })} style={styles.bgs}>
                    <Text style={{ color: '#000', fontSize: 17.6, fontWeight: '700' }}>所需工种</Text>
                    <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                        <Text style={{ color: "#000", fontSize: 15.4 }}>{GLOBAL.zgrtype}</Text>
                        <Icon style={{ marginLeft: 7 }} name="r-arrow" size={12} color="#000" />
                    </View>
                </TouchableOpacity>
                {/* 项目所在地 */}
                <TouchableOpacity onPress={() => this.props.navigation.navigate('Zgraddress', {
                    callback: (() => {
                        this.setState({})
                    })
                })} style={styles.bgs}>
                    <Text style={{ color: '#000', fontSize: 17.6, fontWeight: '700' }}>项目所在地</Text>
                    <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                        <Text style={{ color: "#000", fontSize: 15.4 }}>{GLOBAL.zgraddress.zgroneName}  {GLOBAL.zgraddress.zgrtwoName}</Text>
                        <Icon style={{ marginLeft: 7 }} name="r-arrow" size={12} color="#000" />
                    </View>
                </TouchableOpacity>
                {/* 立即去搜索 */}
                <TouchableOpacity
                    onPress={() => this.props.navigation.navigate('Zgrlist')}
                    style={{
                        marginTop: 33, marginBottom: 33, marginLeft: 11, marginRight: 11,
                        flexDirection: 'row', alignItems: 'center', justifyContent: 'center', backgroundColor: '#eb4e4e',
                        paddingTop: 11, paddingBottom: 11, borderRadius: 5.5
                    }}>
                    <Text style={{ color: '#fff', fontSize: 17.6 }}>立即去搜索</Text>
                </TouchableOpacity>
                {/* 搜索过的历史 */}
                <View style={{ flexDirection: 'row', alignItems: 'center', marginLeft: 11, marginRight: 11 }}>
                    <Text style={{ fontSize: 15.4, color: '#000' }}>你搜索过的历史</Text>
                    <Text style={{ fontSize: 13.2, color: '#666' }}>（点击搜索记录可以快速找人）</Text>
                </View>
                {/* 历史内容 */}
                <View style={{ paddingTop: 5.5, paddingLeft: 11, paddingRight: 11, flexDirection: 'row', flexWarp: 'warp' }}>
                    <View style={{
                        marginTop: 13, marginRight: 11, backgroundColor: '#fff', paddingLeft: 11, paddingRight: 11, paddingTop: 3.3, paddingBottom: 3.3,
                        borderRadius: 17.6, flexDirection: 'row', alignItems: 'center', justifyContent: 'center'
                    }}>
                        <Text style={{ color: '#666', fontSize: 15.4 }}>找班组-钢筋工</Text>
                    </View>
                    <View style={{
                        marginTop: 13, marginRight: 11, backgroundColor: '#fff', paddingLeft: 11, paddingRight: 11, paddingTop: 3.3, paddingBottom: 3.3,
                        borderRadius: 17.6, flexDirection: 'row', alignItems: 'center', justifyContent: 'center'
                    }}>
                        <Text style={{ color: '#666', fontSize: 15.4 }}>找工人-木工</Text>
                    </View>
                </View>
            </View>
        )
    }
    //找工人
    selectFunworker() {
        this.setState({
            lookworker: true
        })
    }
    // 找班组
    selectFunworkerNo() {
        this.setState({
            lookworker: false
        })
    }
}
const styles = StyleSheet.create({
    main: {
        backgroundColor: '#ebebeb',
        flex: 1
    },
    bg: {
        marginTop: 11,
        paddingTop: 22,
        paddingBottom: 22,
        backgroundColor: '#fff',
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'space-between'
    },
    bgs: {
        marginTop: 11,
        paddingTop: 11,
        paddingBottom: 11,
        paddingLeft: 22,
        paddingRight: 22,
        backgroundColor: '#fff',
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'space-between'
    },
})