/*
 * @Author: stl
 * @Date: 2019-03-18 17:05:36 
 * @Module:熟练度-工人
 * @Last Modified time: 2019-03-18 17:05:36 
 */

import React, { Component } from 'react'
import { StyleSheet, Text, View, TouchableOpacity, Platform, Image, ScrollView, ImageBackground, ProgressBarAndroid, TextInput } from 'react-native';
import Typeselects from '../../component/typeselects'
import Icon from "react-native-vector-icons/Ionicons";

export default class basic extends Component {
    constructor(props) {
        super(props)
        this.state = {
            type: [
                { key: 0, name: '学徒工（小工）' },
                { key: 1, name: '中级工（中工）' },
                { key: 2, name: '高级工（大工）' },
                { key: 3, name: '无' },
            ],
            selected: [],//选择的熟练度
        }
    }
    // 顶部导航
    static navigationOptions = ({ navigation, screenProps }) => ({
        header: null
    });
    componentWillMount() {
        let arr = []
        GLOBAL.editbasic.mastery.map((item, index) => {
            arr.push(item)
        })
        this.setState({
            selected: arr
        })
    }
    render() {
        let obj = {}
        obj.type = '熟练度'
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
                        <Text style={{ fontSize: 17, color: '#3d4145', fontWeight: '400', }}>选择熟练度</Text>
                    </View>
                    <TouchableOpacity
                        style={{ width: '25%', height: '100%', marginRight: 10, flexDirection: 'row', alignItems: 'center', justifyContent: 'flex-end' }}>
                    </TouchableOpacity>
                </View>
                {/* <Type obj = {obj} type={this.state.type} clicktypeNum={GLOBAL.mastery} clicktype={this.clicktype.bind(this)} /> */}
                <Typeselects
                    obj={obj}
                    type={this.state.type}
                    selected={this.state.selected}
                    clicktype={this.clicktype.bind(this)}
                />
            </View>
        )
    }
    // 选择名族
    clicktype(e) {
        GLOBAL.editbasic.mastery = [e]
        this.props.navigation.state.params.callback()//回调刷新函数，改变全局变量后需要手动刷新
        this.props.navigation.goBack()
    }
}
const styles = StyleSheet.create({
    main: {
        flex: 1,
        backgroundColor: '#ebebeb',
    },
})