/*
 * @Author: stl
 * @Date: 2019-03-18 11:25:16 
 * @Module:工程类别-工人
 * @Last Modified time: 2019-03-18 11:25:16 
 */
import React, { Component } from 'react'
import { StyleSheet, Text, View, TouchableOpacity, Platform, Image, ScrollView, ImageBackground, ProgressBarAndroid, TextInput } from 'react-native';
import Typeselects from '../../component/typeselects'
import Icon from "react-native-vector-icons/iconfont";

export default class basic extends Component {
    constructor(props) {
        super(props)
        this.state = {
            type: [
                { key: 0, name: '土建' },
                { key: 1, name: '工程装饰' },
                { key: 2, name: '强电' },
                { key: 3, name: '消防' },
                { key: 4, name: '假装' },
                { key: 5, name: '刚结构' },
                { key: 6, name: '只能及弱点' },
                { key: 7, name: '水利及电站' },
                { key: 8, name: '桥梁' },
                { key: 9, name: '藏族' },
                { key: 10, name: '布依族' },
                { key: 11, name: '侗族' },
                { key: 12, name: '瑶族' },
                { key: 13, name: '朝鲜族' },
                { key: 14, name: '白族' },
                { key: 15, name: '哈尼族' },
                { key: 16, name: '哈萨克族' },
                { key: 17, name: '黎族' },
                { key: 18, name: '傣族' },
                { key: 19, name: '高山族' },
                { key: 20, name: '拉祜族' },
                { key: 21, name: '水族' },
            ],
            maxnum: 3,//可选工程类别个数
            selected: [],//已选工程类别
        }
    }
    // 顶部导航
    static navigationOptions = ({ navigation, screenProps }) => ({
        header: null, gesturesEnabled: false,
    });
    componentWillMount() {
        let arr = []
        GLOBAL.editbasic.worktypelb.map((item, index) => {
            arr.push(item)
        })
        this.setState({
            selected: arr
        })
    }
    render() {
        let obj = {}
        obj.type = '工程类别'
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
                        onPress={() => this.assign()}
                        style={{ width: '25%', height: '100%', marginRight: 10, flexDirection: 'row', alignItems: 'center', justifyContent: 'flex-end' }}>
                        <Text style={{ color: '#eb4e4e', fontWeight: '400', fontSize: 17 }}>确定</Text>
                    </TouchableOpacity>
                </View>
                {/* 剩余个数提醒 */}
                <View style={{ backgroundColor: "#ebebeb", paddingLeft: 10, paddingTop: 5, paddingBottom: 5, flexDirection: 'row', alignItems: 'center' }}>
                    <Text style={{ color: '#999', fontSize: 12.8 }}>你最多可选择3个工程类别(还剩下</Text>
                    <Text style={{ color: '#eb4e4e', fontSize: 12.8 }}>{this.state.maxnum - this.state.selected.length}</Text>
                    <Text style={{ color: '#999', fontSize: 12.8 }}>个)</Text>
                </View>
                <Typeselects
                    obj={obj}
                    maxnum={this.state.maxnum}
                    type={this.state.type}
                    selected={this.state.selected}
                    add={this.add.bind(this)}
                    splice={this.splice.bind(this)}
                />
            </View>
        )
    }
    // componentDidMount(){
    //     this.props.navigation.setParams({navigatePress:this.assign.bind(this)})
    // }
    // 确定
    assign() {
        GLOBAL.editbasic.worktypelb = this.state.selected
        this.props.navigation.state.params.callback()//回调刷新函数，改变全局变量后需要手动刷新
        this.props.navigation.goBack()
    }
    //增加
    add(e) {
        this.state.selected.push(e)
        this.setState({})
    }
    //删除
    splice(e) {
        this.state.selected.map((item, index) => {
            if (item == e) {
                this.state.selected.splice(index, 1)
                this.setState({})
            }
        })
    }
}
const styles = StyleSheet.create({
    main: {
        flex: 1,
        backgroundColor: '#ebebeb',
    },
})