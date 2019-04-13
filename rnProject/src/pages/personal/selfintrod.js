/*
 * @Author: stl
 * @Date: 2019-03-18 17:16:56 
 * @Module:自我介绍
 * @Last Modified time: 2019-03-18 17:16:56 
 */
import React, { Component } from 'react'
import { StyleSheet, Text, View, TouchableOpacity, Platform, Image, ScrollView, ImageBackground, ProgressBarAndroid, TextInput } from 'react-native';
import BottomAlert from '../../component/selfintalert'
import Icon from "react-native-vector-icons/Ionicons";

export default class basic extends Component {
    constructor(props) {
        super(props)
        this.state = {
            orbottomalert: false//控制弹框
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
                        <Text style={{ fontSize: 17, color: '#3d4145', fontWeight: '400', }}>自我介绍</Text>
                    </View>
                    <TouchableOpacity
                        style={{ width: '25%', height: '100%', marginRight: 10, flexDirection: 'row', alignItems: 'center', justifyContent: 'flex-end' }}>
                        <Text style={{ marginRight: 10, color: '#eb4e4e', fontWeight: '400', fontSize: 17 }}>保存</Text>
                    </TouchableOpacity>
                </View>
                {/* 多行文本输入框 */}
                <View style={{ padding: 15, height: 270 }}>
                    <TextInput multiline={true}
                        placeholder='主要说说在你擅长领域取得的成绩和自己总结的一些工作经验'
                        style={{
                            height: '100%',
                            padding: 0, margin: 0, fontSize: 15
                        }}
                        textAlignVertical='top'></TextInput>
                </View>
                {/* 我该怎么写 */}
                <View style={{ flexDirection: 'row', justifyContent: 'flex-end', paddingRight: 10 }}>
                    <View style={{
                        width: 112, height: 30, borderWidth: 1, borderColor: 'rgb(235, 78, 78)', borderRadius: 40,
                        flexDirection: 'row', alignItems: 'center', justifyContent: 'center'
                    }}>
                        <TouchableOpacity onPress={() => this.close()}>
                            <Text style={{ color: '#eb4e4e', fontSize: 16.5 }}>我该怎么写?</Text>
                        </TouchableOpacity>
                    </View>
                </View>
                {/* 提示弹框 */}
                <BottomAlert orbottomalert={this.state.orbottomalert} close={this.close.bind(this)} />
            </View>
        )
    }
    close() {
        this.setState({
            orbottomalert: !this.state.orbottomalert
        })
    }

}
const styles = StyleSheet.create({
    main: {
        flex: 1,
        backgroundColor: '#fff',
    },
})