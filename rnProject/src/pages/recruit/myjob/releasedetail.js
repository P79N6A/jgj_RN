/*
 * @Author: mikey.zhaopeng 
 * @Date: 2019-03-22 09:24:36 
 * @Module:发布招工-招聘详情
 * @Last Modified time: 2019-03-22 09:24:36 
 */
import React, { Component } from 'react';
import {
    StyleSheet,
    Text,
    View,
    Image,
    TouchableOpacity,
    Platform,
    TextInput,
    ScrollView,
} from 'react-native';
import ModalDropdown from 'react-native-modal-dropdown';
import Icon from "react-native-vector-icons/Ionicons";

export default class releasedetail extends Component {
    constructor(props) {
        super(props)
        this.state = {
            dgorbg: true,//点工、包工
            rxoryx: '日薪',
            dj: '元/米',//单价单位
        }
    }
    // 顶部导航
    static navigationOptions = ({ navigation, screenProps }) => ({
        header: null
    });
    render() {
        return (
            <View style={{ backgroundColor: '#ebebeb', flex: 1 }}>
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
                        <Text style={{ fontSize: 17, color: '#3d4145', fontWeight: '400', }}>招工人(水泥工)</Text>
                    </View>
                    <TouchableOpacity
                        style={{ width: '25%', height: '100%', marginRight: 10, flexDirection: 'row', alignItems: 'center', justifyContent: 'flex-end' }}>
                    </TouchableOpacity>
                </View>
                <ScrollView style={{ marginBottom: 50 }}>
                    {/* 用工类型 */}
                    <View style={{
                        paddingLeft: 13, paddingRight: 13, marginBottom: 11, backgroundColor: '#fff', paddingTop: 17, paddingBottom: 17,
                        flexDirection: 'row'
                    }}>
                        <Text style={{ color: '#000', fontSize: 15.4, marginRight: 60 }}>用工类型</Text>
                        <View style={{ flexDirection: 'row' }}>
                            {/* 点工 */}
                            <TouchableOpacity onPress={() => this.dgFun()} style={{ marginRight: 44, flexDirection: 'row', alignItems: 'center' }}>
                                {
                                    this.state.dgorbg ? (
                                        <View style={{
                                            borderColor: '#eb4e4e', borderWidth: 1, borderRadius: 17, width: 17, height: 17,
                                            flexDirection: 'row', alignItems: 'center', justifyContent: 'center'
                                        }}>
                                            <View style={{ backgroundColor: '#eb4e4e', width: 11, height: 11, borderRadius: 11 }}></View>
                                        </View>
                                    ) : (
                                            <View style={{ borderColor: 'rgb(204, 204, 204)', borderWidth: 1, borderRadius: 17, width: 17, height: 17 }}></View>
                                        )
                                }
                                <Text style={{ color: "#3d4145", fontSize: 15.4, marginLeft: 5 }}>点工</Text>
                            </TouchableOpacity>
                            {/* 包工 */}
                            <TouchableOpacity onPress={() => this.bgFun()} style={{ flexDirection: 'row', alignItems: 'center' }}>
                                {
                                    !this.state.dgorbg ? (
                                        <View style={{
                                            borderColor: '#eb4e4e', borderWidth: 1, borderRadius: 17, width: 17, height: 17,
                                            flexDirection: 'row', alignItems: 'center', justifyContent: 'center'
                                        }}>
                                            <View style={{ backgroundColor: '#eb4e4e', width: 11, height: 11, borderRadius: 11 }}></View>
                                        </View>
                                    ) : (
                                            <View style={{ borderColor: 'rgb(204, 204, 204)', borderWidth: 1, borderRadius: 17, width: 17, height: 17 }}></View>
                                        )
                                }
                                <Text style={{ color: "#3d4145", fontSize: 15.4, marginLeft: 5 }}>包工</Text>
                            </TouchableOpacity>
                        </View>
                    </View>

                    {/* 点工or包工变化内容 */}
                    {
                        this.state.dgorbg ? (
                            // 点工内容
                            <View style={{ padding: 11, marginBottom: 11, backgroundColor: '#fff' }}>
                                {/* 计薪方式 */}
                                <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                                    <Text style={{ color: '#000', fontSize: 15.4, marginRight: 15 }}>计薪方式：</Text>

                                    <ModalDropdown style={{
                                        borderWidth: 1, borderColor: '#999', borderRadius: 4.4,
                                        flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between',
                                        paddingLeft: 6, paddingRight: 10, height: 40, width: 100
                                    }}
                                        textStyle={{ color: '#3d4145', fontSize: 15.4 }}
                                        dropdownStyle={{ width: 100, marginLeft: -7, marginTop: 7, height: 72 }}
                                        onSelect={(value, index) => this.xzselectFun(index)}
                                        defaultValue={this.state.rxoryx} options={['日薪', '月薪']} >
                                    </ModalDropdown>
                                    <Icon style={{position: 'relative', left: -20}} name="rd-arrow" size={13} color="#999999" />
                                </View>

                                {/* waning */}
                                <Text style={{ color: '#eb4e4e', fontSize: 13.2, marginLeft: 94, marginTop: 5, }}>较高的工价更容易找到想要的人哦~</Text>

                                {/* 工资标准 */}
                                <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                                    <Text style={{ color: '#000', fontSize: 15.4, marginRight: 15 }}>工资标准：</Text>
                                    <TextInput style={{
                                        borderWidth: 1, borderColor: '#999', borderRadius: 4.4,
                                        paddingLeft: 10, height: 38, width: 100, marginTop: 5, color: 'red'
                                    }}>
                                    </TextInput>
                                    <Text style={{ color: '#000', fontSize: 15.4, marginRight: 15, marginLeft: 10 }}>至</Text>
                                    <TextInput style={{
                                        borderWidth: 1, borderColor: '#999', borderRadius: 4.4,
                                        paddingLeft: 10, height: 38, width: 100, marginTop: 5, color: 'red'
                                    }}>
                                    </TextInput>
                                    <Text style={{ color: '#000', fontSize: 15.4, marginRight: 15, marginLeft: 10 }}>元/{this.state.rxoryx.substr(0, 1)}</Text>
                                </View>

                                {/* 所需人数 */}
                                <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                                    <Text style={{ color: '#000', fontSize: 15.4, marginRight: 15 }}>所需人数：</Text>
                                    <View style={{ position: 'relative' }}>
                                        <TextInput style={{
                                            borderWidth: 1, borderColor: '#999', borderRadius: 4.4,
                                            paddingLeft: 10, height: 38, width: 100, marginTop: 5, color: 'red'
                                        }}>
                                        </TextInput>
                                        <Text style={{ color: '#000', fontSize: 15.4, position: 'absolute', right: 10, top: 12 }}>人</Text>
                                    </View>
                                </View>

                            </View>
                        ) : (
                                // 包工内容
                                <View style={{ padding: 11, marginBottom: 11, backgroundColor: '#fff' }}>
                                    {/* waning */}
                                    <Text style={{ color: '#eb4e4e', fontSize: 13.2, marginLeft: 94, marginTop: 5, }}>较高的工价更容易找到想要的人哦~</Text>

                                    {/* 单价 */}
                                    <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                                        <Text style={{ color: '#000', fontSize: 15.4, marginRight: 15 }}>单价：        </Text>
                                        <TextInput style={{
                                            borderWidth: 1, borderColor: '#999', borderRadius: 4.4,
                                            paddingLeft: 10, height: 38, width: 100, marginTop: 5, color: 'red'
                                        }}>
                                        </TextInput>
                                        <ModalDropdown style={{
                                            borderWidth: 1, borderColor: '#999', borderRadius: 4.4, marginLeft: 10, marginTop: 4,
                                            flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between',
                                            paddingLeft: 6, paddingRight: 10, height: 38, width: 100
                                        }}
                                            textStyle={{ color: '#3d4145', fontSize: 15.4 }}
                                            dropdownStyle={{ width: 100, marginLeft: -7, marginTop: 7, }}
                                            onSelect={(value, index) => this.djselectFun(index)}
                                            defaultValue={this.state.dj} options={['元/米', '元/吨', '元/平方米', '元/立方米', '元/栋楼']} >
                                        </ModalDropdown>
                                        <Icon style={{position: 'relative', left: -20}} name="rd-arrow" size={13} color="#999999" />
                                    </View>

                                    {/* 工程规模 */}
                                    <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                                        <Text style={{ color: '#000', fontSize: 15.4, marginRight: 15 }}>工程规模：</Text>
                                        <View style={{ position: 'relative' }}>
                                            <TextInput style={{
                                                borderWidth: 1, borderColor: '#999', borderRadius: 4.4,
                                                paddingLeft: 10, height: 38, width: 210, marginTop: 5, color: 'red',
                                            }}>
                                            </TextInput>
                                            <Text style={{ color: '#000', fontSize: 15.4, position: 'absolute', right: 10, top: 12 }}>{this.state.dj.split('/')[1]}</Text>
                                        </View>
                                    </View>

                                    {/* 总价 */}
                                    <View style={{ flexDirection: 'row', alignItems: 'center' }}>
                                        <Text style={{ color: '#000', fontSize: 15.4, marginRight: 15 }}>总价：        </Text>
                                        <View style={{ position: 'relative' }}>
                                            <TextInput style={{
                                                borderWidth: 1, borderColor: '#999', borderRadius: 4.4,
                                                paddingLeft: 10, height: 38, width: 210, marginTop: 5, color: 'red'
                                            }}>
                                            </TextInput>
                                            <Text style={{ color: '#000', fontSize: 15.4, position: 'absolute', right: 10, top: 12 }}>元</Text>
                                        </View>
                                    </View>

                                </View>
                            )
                    }

                    {/* 选择待遇 */}
                    <View style={{ paddingLeft: 13, paddingRight: 13, paddingTop: 15, paddingBottom: 15, marginBottom: 11, backgroundColor: '#fff' }}>
                        <View style={{ flexDirection: "row", alignItems: 'center' }}>
                            <Text style={{ color: '#000', fontSize: 15.4 }}>选择待遇</Text>
                            <Text style={{ color: '#999', fontSize: 13.2, marginLeft: 3 }}>(点击标签即可选中)</Text>
                        </View>
                        {/* 待遇选项 */}
                        <View style={{ flexDirection: 'row', flexWarp: 'warp' }}>
                            <View style={{
                                paddingLeft: 6.6, paddingRight: 6.6,
                                paddingTop: 3.3, paddingBottom: 3.3, marginTop: 6.6,
                                marginRight: 5.5, backgroundColor: '#e6e6e6',
                                borderRadius: 3.3
                            }}>
                                <Text style={{ color: '#3d4145', fontSize: 13.2 }}>包吃住</Text>
                            </View>
                        </View>
                        {/* 添加待遇 */}
                        <View style={{ flexDirection: "row", alignItems: 'center', justifyContent: 'space-between', marginTop: 15 }}>
                            <TextInput style={{
                                borderWidth: 1, borderColor: '#999', borderRadius: 4.4,
                                paddingLeft: 10, height: 38, marginTop: 5, color: 'red', flex: 1, marginRight: 10
                            }}
                                placeholder='输入你能提供的待遇(最多8个字)'>
                            </TextInput>
                            <View style={{
                                backgroundColor: '#eb4e4e', width: 88, height: 38, flexDirection: 'row', alignItems: 'center',
                                justifyContent: 'center', borderRadius: 3, marginTop: 2
                            }}>
                                <Text style={{ color: '#fff', fontSize: 15.4 }}>添加</Text>
                            </View>
                        </View>
                    </View>

                    {/* 项目名称、施工单位 */}
                    <View style={{ padding: 11, backgroundColor: '#fff' }}>
                        <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between' }}>
                            <Text style={{ color: '#000', fontSize: 15.4, marginRight: 15 }}>项目名称：</Text>
                            <TextInput style={{
                                borderWidth: 1, borderColor: '#999', borderRadius: 4.4,
                                paddingLeft: 10, height: 38, flex: 1, marginTop: 5, color: 'red'
                            }}
                                placeholder='输入招工项目的名称(最多15个字)'>
                            </TextInput>
                        </View>
                        <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between' }}>
                            <Text style={{ color: '#000', fontSize: 15.4, marginRight: 15 }}>施工单位：</Text>
                            <TextInput style={{
                                borderWidth: 1, borderColor: '#999', borderRadius: 4.4,
                                paddingLeft: 10, height: 38, flex: 1, marginTop: 5, color: 'red'
                            }}
                                placeholder='输入施工单位的名称(最多15个字)'>
                            </TextInput>
                        </View>
                    </View>

                    {/* 项目所在地 */}
                    <Text style={{ marginLeft: 13.2, marginRight: 13.2, marginTop: 8.8, marginBottom: 8.8, color: '#3d4145', fontSize: 15.4 }}>项目所在地：四川省 成都市</Text>

                    {/* 详细地址 */}
                    <View style={{ padding: 13, backgroundColor: '#fff', flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', marginBottom: 10 }}>
                        <Text style={{ color: '#3d4145', fontSize: 15.4 }}>详细地址：</Text>
                        <View style={{ flexDirection: "row", alignItems: 'center' }}>
                            <Text style={{ color: '#999', fontSize: 15.4 }}>请选择所在地</Text>
                            <Icon style={{marginLeft: 10}} name="r-arrow" size={12} color="#000" />
                        </View>
                    </View>

                    {/* 项目描述 */}
                    <View style={{ backgroundColor: '#fff', paddingLeft: 13, paddingRight: 13, paddingTop: 15.4, paddingBottom: 15.4 }}>
                        <Text style={{ color: '#3d4145', fontSize: 15.4 }}>项目描述</Text>
                        <TextInput multiline={true}
                            placeholder='填写具体的项目介绍，例如项目所需市场、工资发放方式等，能让找活方更多地了解工作详情。'
                            style={{
                                height: 88,
                                padding: 5, margin: 0, fontSize: 15,
                                borderWidth: 1, borderColor: 'rgb(153, 153, 153)', borderRadius: 4.4, marginTop: 10
                            }}
                            textAlignVertical='top'></TextInput>
                    </View>

                    <Text style={{ color: '#999', fontSize: 15.4, marginTop: 11, marginBottom: 50, textAlign: 'center' }}>你的招工信息会在平台展示50天</Text>

                </ScrollView>
                {/* 底部按钮 */}
                <View style={{ padding: 11, backgroundColor: '#fafafa', position: 'absolute', bottom: 0, width: '100%', }}>
                    <TouchableOpacity
                        onPress={() => this.props.navigation.navigate('Mysuit')}
                        style={{ borderRadius: 4.4, backgroundColor: '#eb4e4e', height: 44, flexDirection: 'row', alignItems: 'center', justifyContent: 'center' }}>
                        <Text style={{ fontSize: 18.7, color: '#fff' }}>立即发布</Text>
                    </TouchableOpacity>
                </View>
            </View>
        )
    }
    //选择点工
    dgFun() {
        this.setState({
            dgorbg: true
        })
    }
    //选择包工
    bgFun() {
        this.setState({
            dgorbg: false
        })
    }
    // 选择日薪、月薪
    xzselectFun(e) {
        this.setState({
            rxoryx: e
        })
    }
    // 选择单价单位
    djselectFun(e) {
        this.setState({
            dj: e
        })
    }

}