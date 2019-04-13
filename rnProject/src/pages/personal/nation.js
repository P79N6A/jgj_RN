/*
 * @Author: stl
 * @Date: 2019-03-18 11:25:16 
 * @Module:名族
 * @Last Modified time: 2019-03-18 11:25:16 
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
                { key: 0, name: '汉族' },
                { key: 1, name: '壮族' },
                { key: 2, name: '满族' },
                { key: 3, name: '回族' },
                { key: 4, name: '苗族' },
                { key: 5, name: '维吾尔族' },
                { key: 6, name: '土家族' },
                { key: 7, name: '彝族' },
                { key: 8, name: '蒙古族' },
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
            selected: [],//选择的民族
        }
    }
    // 顶部导航
    static navigationOptions = ({ navigation, screenProps }) => ({
        header: null
    });
    componentWillMount() {
        let arr = []
        GLOBAL.editbasic.nation.map((item, index) => {
            arr.push(item)
        })
        this.setState({
            selected: arr
        })
    }
    render() {
        let obj = {}
        obj.type = '民族'
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
                        <Text style={{ fontSize: 17, color: '#3d4145', fontWeight: '400', }}>选择名族</Text>
                    </View>
                    <TouchableOpacity style={{ width: '25%', height: '100%', marginRight: 10, flexDirection: 'row', alignItems: 'center', justifyContent: 'flex-end' }}>
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
    // 选择名族
    clicktype(e) {
        GLOBAL.editbasic.nation = [e]
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