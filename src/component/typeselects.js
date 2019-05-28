import React, { Component } from 'react'
import { StyleSheet, Text, View, TouchableOpacity, Platform, Image, ScrollView } from 'react-native';
import Icon from "react-native-vector-icons/iconfont";
export default class selecttype extends Component {
    constructor(props) {
        super(props)
        this.state = {
            typeBz: false
        }
    }
    //点击事件
    clickli(code, name) {
        if (this.props.addressType == '找工作') {
            GLOBAL.zgzType.zgzTypeName = name
            GLOBAL.zgzType.zgzTypeNum = code
            this.setState({})
            this.props.offType()
        } else if (this.props.addressType == '找工人工种') {
            GLOBAL.zgrType.zgrTypeName = name
            GLOBAL.zgrType.zgrTypeNum = code
            this.setState({})
            this.props.offType()
        } else if (this.props.addressType == '发布招工工种') {
            GLOBAL.fbzgType.fbzgTypeName = name
            GLOBAL.fbzgType.fbzgTypeNum = code
            this.setState({})
            this.props.offType()
        } else if (this.props.addressType == '发布招工工程类别') {
            GLOBAL.fbzgProject.fbzgProjectName = name
            GLOBAL.fbzgProject.fbzgProjectNum = code
            this.setState({})
            this.props.offType()
        }
    }
    // 选择全部工种
    alltypeFun() {
        GLOBAL.zgzType.zgzTypeName = '全部工种',
            GLOBAL.zgzType.zgzTypeNum = -1,
            this.setState({})
        this.props.offType()
    }
    // 选择我的工种
    mytypeFun() {
        GLOBAL.zgzType.zgzTypeName = '我的工种',
            GLOBAL.zgzType.zgzTypeNum = 0,
            this.setState({})
        this.props.offType()
    }
    // 总包
    totalPackage() {
        GLOBAL.fbzgType.fbzgTypeName = '总包'
        GLOBAL.fbzgType.fbzgTypeNum = 0
        this.setState({})
        this.props.offType()
    }
    // 找工人总包
    totalPackageZgr() {
        GLOBAL.zgrType.zgrTypeName = '总包'
        GLOBAL.zgrType.zgrTypeNum = 0
        this.setState({})
        this.props.offType()
    }
    render() {
        let arr = []
        if(this.props.addressType == '发布招工工程类别'){
            arr = GLOBAL.projectArr//工程类别
        }else{
            arr = GLOBAL.typeArr//工种
        }
        return (
            <View style={styles.containermain}>
                <ScrollView style={{ width: '100%', }}>
                    {
                        this.props.addressType == '找工作' ? (
                            <View>
                                <TouchableOpacity activeOpacity={.7}
                                    onPress={() => this.alltypeFun()}
                                    style={{
                                        height: 46,
                                        backgroundColor: 'white',
                                        borderBottomWidth: .5,
                                        borderBottomColor: '#dbdbdb',
                                        paddingLeft: 16,
                                        paddingRight: 16,
                                        flexDirection: 'row',
                                        alignItems: 'center',
                                        justifyContent: "space-between"
                                    }}>
                                    <Text style={{ fontSize: 15, color: '#666' }}>全部工种</Text>
                                </TouchableOpacity>
                                <TouchableOpacity activeOpacity={.7}
                                    onPress={() => this.mytypeFun()}
                                    style={{
                                        height: 46,
                                        backgroundColor: 'white',
                                        borderBottomWidth: .5,
                                        borderBottomColor: '#dbdbdb',
                                        paddingLeft: 16,
                                        paddingRight: 16,
                                        flexDirection: 'row',
                                        alignItems: 'center',
                                        justifyContent: "space-between"
                                    }}>
                                    <Text style={{ fontSize: 15, color: '#666' }}>我的工种</Text>
                                </TouchableOpacity>
                            </View>
                        ) : false
                    }
                    {/* 总包 */}
                    {
                        this.props.typeBz ? (
                            <View>
                                <TouchableOpacity activeOpacity={.7}
                                    onPress={() => this.totalPackage()}
                                    style={{
                                        height: 46,
                                        backgroundColor: 'white',
                                        borderBottomWidth: .5,
                                        borderBottomColor: '#dbdbdb',
                                        paddingLeft: 16,
                                        paddingRight: 16,
                                        flexDirection: 'row',
                                        alignItems: 'center',
                                        justifyContent: "space-between"
                                    }}>
                                    <Text style={{ fontSize: 15, color: '#666' }}>总包</Text>
                                    {
                                        GLOBAL.fbzgType.fbzgTypeName == '总包' ? (
                                            <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                                                <Icon style={{ marginRight: 3 }} name="sure" size={15} color="#eb4e4e" />
                                                <Text style={{ color: '#999', fontSize: 12 }}>已选择</Text>
                                            </View>
                                        ) : false
                                    }
                                </TouchableOpacity>
                            </View>
                        ) : false
                    }
                    {
                        this.props.zgrBz ? (
                            <View>
                                <TouchableOpacity activeOpacity={.7}
                                    onPress={() => this.totalPackageZgr()}
                                    style={{
                                        height: 46,
                                        backgroundColor: 'white',
                                        borderBottomWidth: .5,
                                        borderBottomColor: '#dbdbdb',
                                        paddingLeft: 16,
                                        paddingRight: 16,
                                        flexDirection: 'row',
                                        alignItems: 'center',
                                        justifyContent: "space-between"
                                    }}>
                                    <Text style={{ fontSize: 15, color: '#666' }}>总包</Text>
                                    {
                                        GLOBAL.zgrType.zgrTypeName == '总包' ? (
                                            <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                                                <Icon style={{ marginRight: 3 }} name="sure" size={15} color="#eb4e4e" />
                                                <Text style={{ color: '#999', fontSize: 12 }}>已选择</Text>
                                            </View>
                                        ) : false
                                    }
                                </TouchableOpacity>
                            </View>
                        ) : false
                    }
                    {
                        arr.map((item, key) => {
                            return (
                                <TouchableOpacity activeOpacity={.7} key={key} onPress={() => this.clickli(item.code, item.name)} style={{
                                    height: 46,
                                    backgroundColor: 'white',
                                    borderBottomWidth: .5,
                                    borderBottomColor: '#dbdbdb',
                                    paddingLeft: 16,
                                    paddingRight: 16,
                                    flexDirection: 'row',
                                    alignItems: 'center',
                                    justifyContent: "space-between"
                                }}>
                                    {
                                        item.name == '其它工种' || item.name == '其它' ? (
                                            <Text style={{ fontSize: 15, color: 'rgb(235, 170, 78)' }}>{item.name}</Text>
                                        ) : (
                                                this.props.addressType == '找工作' ? (
                                                    <Text style={{ fontSize: 15, color: GLOBAL.zgzType.zgzTypeName == item.name ? "#eb4e4e" : '#666' }}>{item.name}</Text>
                                                ) : (
                                                        this.props.addressType == '找工人工种' ? (
                                                            <Text style={{ fontSize: 15, color: GLOBAL.zgrType.zgrTypeName == item.name ? "#eb4e4e" : '#666' }}>{item.name}</Text>
                                                        ) : this.props.addressType == '发布招工工种' ? (
                                                            <Text style={{ fontSize: 15, color: GLOBAL.fbzgType.fbzgTypeName == item.name ? "#eb4e4e" : '#666' }}>{item.name}</Text>
                                                        ) : this.props.addressType == '发布招工工程类别' ? (
                                                            <Text style={{ fontSize: 15, color: GLOBAL.fbzgProject.fbzgProjectName == item.name ? "#eb4e4e" : '#666' }}>{item.name}</Text>
                                                        ) : false
                                                    )
                                            )
                                    }

                                    {
                                        this.props.addressType == '找工作' ? (
                                            GLOBAL.zgzType.zgzTypeName == item.name ? (
                                                <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                                                    <Icon style={{ marginRight: 3 }} name="sure" size={15} color="#eb4e4e" />
                                                    <Text style={{ color: '#999', fontSize: 12 }}>已选择</Text>
                                                </View>
                                            ) : false
                                        ) : (
                                                this.props.addressType == '找工人工种' ? (
                                                    GLOBAL.zgrType.zgrTypeName == item.name ? (
                                                        <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                                                            <Icon style={{ marginRight: 3 }} name="sure" size={15} color="#eb4e4e" />
                                                            <Text style={{ color: '#999', fontSize: 12 }}>已选择</Text>
                                                        </View>
                                                    ) : false
                                                ) : this.props.addressType == '发布招工工种' ? (
                                                    GLOBAL.fbzgType.fbzgTypeName == item.name ? (
                                                        <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                                                            <Icon style={{ marginRight: 3 }} name="sure" size={15} color="#eb4e4e" />
                                                            <Text style={{ color: '#999', fontSize: 12 }}>已选择</Text>
                                                        </View>
                                                    ) : false
                                                ) : this.props.addressType == '发布招工工程类别' ? (
                                                    GLOBAL.fbzgProject.fbzgProjectName == item.name ? (
                                                        <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                                                            <Icon style={{ marginRight: 3 }} name="sure" size={15} color="#eb4e4e" />
                                                            <Text style={{ color: '#999', fontSize: 12 }}>已选择</Text>
                                                        </View>
                                                    ) : false
                                                ) : false
                                            )
                                    }


                                </TouchableOpacity>
                            )
                        })
                    }
                </ScrollView>
            </View>
        )
    }
}
const styles = StyleSheet.create({
    containermain: {
        flex: 1,
        width: '100%',
        backgroundColor: '#ebebeb',
        alignItems: 'center',
    },
})