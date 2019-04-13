/*
 * @Author: mikey.zhaopeng 
 * @Date: 2019-03-22 08:49:51 
 * @Module:发布招工-选择工程类别
 * @Last Modified time: 2019-03-22 08:49:51 
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
import Typeselects from '../../../component/typeselects'
import Icon from "react-native-vector-icons/Ionicons";

export default class lookworker extends Component {
    constructor(props) {
        super(props)
        this.state = {
            type: [
                { key: 0, name: '土建' },
                { key: 1, name: '工程装饰' },
                { key: 2, name: '强电及给排水' },
                { key: 3, name: '消防' },
                { key: 4, name: '家装' },
                { key: 5, name: '钢结构' },
                { key: 6, name: '智能及弱电' },
                { key: 7, name: '水利及电站' },
                { key: 8, name: '暖通空调' },
                { key: 9, name: '市政' },
                { key: 10, name: '地基及基础' },
                { key: 11, name: '幕墙' },
                { key: 12, name: '桥梁' },
                { key: 13, name: '道路' },
                { key: 14, name: '门窗' },
                { key: 15, name: '机械操作' },
                { key: 16, name: '园林绿化' },
                { key: 17, name: '隧道' },
                { key: 18, name: '其他' },
            ],
            selected: [],//选择的民族
        }
    }
    // 顶部导航
    static navigationOptions = ({ navigation, screenProps }) => ({
        header: null
    });
    componentWillMount() {
        let arr = []
        GLOBAL.fbworklb.map((item, index) => {
            arr.push(item)
        })
        this.setState({
            selected: arr
        })
    }
    render() {
        let obj = {}
        obj.type = '找工人工种'
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
                        <Text style={{ fontSize: 17, color: '#3d4145', fontWeight: '400', }}>选择工程类别</Text>
                    </View>
                    <TouchableOpacity
                        style={{ width: '25%', height: '100%', marginRight: 10, flexDirection: 'row', alignItems: 'center', justifyContent: 'flex-end' }}>
                    </TouchableOpacity>
                </View>
                <Typeselects
                    obj={obj}
                    type={this.state.type}
                    selected={this.state.selected}
                    clicktype={this.clicktype.bind(this)}
                />
            </View>
        )
    }
    // 选择工种
    clicktype(e) {
        GLOBAL.fbworklb = [e]
        this.props.navigation.state.params.callback()//回调刷新函数，改变全局变量后需要手动刷新
        this.props.navigation.goBack()
    }

}
const styles = StyleSheet.create({
    main: {
        backgroundColor: '#ebebeb',
        flex: 1
    },
})