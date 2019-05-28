
import React, { Component } from 'React'
import { View, Text, Image, StyleSheet, TouchableOpacity, Modal } from 'react-native'
import Icon from "react-native-vector-icons/iconfont";
import { openWebView } from '../utils'
export default class bottomalert extends Component {
    constructor(props) {
        super(props)
        this.state = {
            selectarr: [
                { key: 0, name: '工人认证', url: 'my/attest?role=1' },
                { key: 1, name: '班组认证', url: 'my/attest?role=2' },
            ],
            djarr:[
                {key:1,name:'元/米'},
                {key:2,name:'元/吨'},
                {key:3,name:'元/平方米'},
                {key:4,name:'元/立方米'},
                {key:5,name:'元/栋楼'},
                {key:6,name:'元/点位'},
                {key:7,name:'元/根'},
            ],
            selectValue:'',
        }
    }
    componentDidMount(){
        this.setState({
            selectValue:this.props.valueDefau
        })
    }
    render() {
        return (
            <View>
                {/* <Modal visible={this.props.orbottomalert}
                    animationType="fade"
                    transparent={true}//透明蒙层
                    onRequestClose={() => this.props.selectwork()}//点击返回的回调函数
                >
                    <TouchableOpacity activeOpacity={.7} onPress={() => this.props.closeModal()} style={{ flex: 1, backgroundColor: 'rgba(0,0,0,.5)' }} >
                    </TouchableOpacity>
                </Modal> */}

                <Modal visible={this.props.orbottomalert}
                    animationType="fade"//从底部划出
                    transparent={true}//透明蒙层
                    onRequestClose={() => this.props.selectwork()}//点击返回的回调函数
                >
                    <TouchableOpacity activeOpacity={1} onPress={() => this.props.closeModal()} style={{ flex: 1, backgroundColor: 'rgba(0,0,0,.75)' }} >
                    </TouchableOpacity>
                    {
                        this.props.name=='dj'?(
                            // 单价选择弹框
                            <TouchableOpacity activeOpacity={.7}  style={{ backgroundColor: '#ebebeb' }}>
                                {/* title */}
                                <View style={{ height: 45, backgroundColor: '#eb4e4e', flexDirection: 'row', alignItems: 'center', justifyContent:'space-between',paddingLeft:25,paddingRight:25 }}>
                                    <TouchableOpacity activeOpacity={.7} onPress={()=>this.props.closeModal()}>
                                        <Text style={{ fontSize: 15, color: '#fff' }}>取消</Text>
                                    </TouchableOpacity>
                                    <Text style={{ fontSize: 15, color: '#fff' }}>选择单位</Text>
                                    <View>
                                        <Text style={{ fontSize: 15, color: '#eb4e4e', }}>确定</Text>
                                    </View>
                                </View>
                                {/* 选项 */}
                                {/* <View style={{width:'100%',height:225,backgroundColor:"white",paddingLeft:10,paddingRight:10,paddingTop:15,flexDirection:"row",flexWrap:'wrap'}}>
                                    {
                                        this.state.djarr.map((item, key) => {
                                            return (
                                                    <TouchableOpacity activeOpacity={.7}
                                                    onPress={()=>this.props.selectFun(item)}
                                                    key={key}
                                                    style={{
                                                        width:80,
                                                        height:40,
                                                        backgroundColor:'#f1f1f1',
                                                        flexDirection:"row",
                                                        justifyContent:'center',
                                                        alignItems:'center',
                                                        marginRight:12,
                                                        marginBottom:12.5,
                                                        borderRadius:2.5,
                                                        borderWidth:.5,
                                                        borderColor:'#cccccc',
                                                    }}
                                                    >
                                                        <Text style={{ fontSize: 14, color: '#000000' }}>{item.name}</Text>
                                                    </TouchableOpacity>
                                            )
                                        })
                                    }
                                </View> */}

                                <View style={{width:'100%',height:225,backgroundColor:"white",paddingLeft:10,paddingRight:10,paddingTop:15,}}>
                                    <View style={{flexDirection:'row',alignItems:'center',justifyContent:'space-between'}}>
                                        <TouchableOpacity activeOpacity={.7}
                                        onPress={()=>this.props.selectFun({key:1,name:'元/米'})}
                                        style={{
                                            width:80,
                                            height:40,
                                            backgroundColor:'#f1f1f1',
                                            flexDirection:"row",
                                            justifyContent:'center',
                                            alignItems:'center',
                                            marginBottom:12.5,
                                            borderRadius:2.5,
                                            borderWidth:.5,
                                            borderColor:'#cccccc',
                                        }}
                                        >
                                        <Text style={{ fontSize: 14, color: '#000000' }}>元/米</Text>
                                        </TouchableOpacity>
                                        <TouchableOpacity activeOpacity={.7}
                                        onPress={()=>this.props.selectFun({key:2,name:'元/吨'})}
                                        style={{
                                            width:80,
                                            height:40,
                                            backgroundColor:'#f1f1f1',
                                            flexDirection:"row",
                                            justifyContent:'center',
                                            alignItems:'center',
                                            marginBottom:12.5,
                                            borderRadius:2.5,
                                            borderWidth:.5,
                                            borderColor:'#cccccc',
                                        }}
                                        >
                                        <Text style={{ fontSize: 14, color: '#000000' }}>元/吨</Text>
                                        </TouchableOpacity>
                                        <TouchableOpacity activeOpacity={.7}
                                        onPress={()=>this.props.selectFun({key:3,name:'元/平方米'})}
                                        style={{
                                            width:80,
                                            height:40,
                                            backgroundColor:'#f1f1f1',
                                            flexDirection:"row",
                                            justifyContent:'center',
                                            alignItems:'center',
                                            marginBottom:12.5,
                                            borderRadius:2.5,
                                            borderWidth:.5,
                                            borderColor:'#cccccc',
                                        }}
                                        >
                                        <Text style={{ fontSize: 14, color: '#000000' }}>元/平方米</Text>
                                        </TouchableOpacity>
                                        <TouchableOpacity activeOpacity={.7}
                                        onPress={()=>this.props.selectFun({key:4,name:'元/立方米'})}
                                        style={{
                                            width:80,
                                            height:40,
                                            backgroundColor:'#f1f1f1',
                                            flexDirection:"row",
                                            justifyContent:'center',
                                            alignItems:'center',
                                            marginBottom:12.5,
                                            borderRadius:2.5,
                                            borderWidth:.5,
                                            borderColor:'#cccccc',
                                        }}
                                        >
                                        <Text style={{ fontSize: 14, color: '#000000' }}>元/立方米</Text>
                                        </TouchableOpacity>
                                    </View>

                                    <View style={{flexDirection:'row',alignItems:'center',justifyContent:'space-between'}}>
                                        <TouchableOpacity activeOpacity={.7}
                                        onPress={()=>this.props.selectFun({key:5,name:'元/栋楼'})}
                                        style={{
                                            width:80,
                                            height:40,
                                            backgroundColor:'#f1f1f1',
                                            flexDirection:"row",
                                            justifyContent:'center',
                                            alignItems:'center',
                                            marginBottom:12.5,
                                            borderRadius:2.5,
                                            borderWidth:.5,
                                            borderColor:'#cccccc',
                                        }}
                                        >
                                        <Text style={{ fontSize: 14, color: '#000000' }}>元/栋楼</Text>
                                        </TouchableOpacity>
                                        <TouchableOpacity activeOpacity={.7}
                                        onPress={()=>this.props.selectFun({key:6,name:'元/点位'})}
                                        style={{
                                            width:80,
                                            height:40,
                                            backgroundColor:'#f1f1f1',
                                            flexDirection:"row",
                                            justifyContent:'center',
                                            alignItems:'center',
                                            marginBottom:12.5,
                                            borderRadius:2.5,
                                            borderWidth:.5,
                                            borderColor:'#cccccc',
                                        }}
                                        >
                                        <Text style={{ fontSize: 14, color: '#000000' }}>元/点位</Text>
                                        </TouchableOpacity>
                                        <TouchableOpacity activeOpacity={.7}
                                        onPress={()=>this.props.selectFun({key:7,name:'元/根'})}
                                        style={{
                                            width:80,
                                            height:40,
                                            backgroundColor:'#f1f1f1',
                                            flexDirection:"row",
                                            justifyContent:'center',
                                            alignItems:'center',
                                            marginBottom:12.5,
                                            borderRadius:2.5,
                                            borderWidth:.5,
                                            borderColor:'#cccccc',
                                        }}
                                        >
                                        <Text style={{ fontSize: 14, color: '#000000' }}>元/根</Text>
                                        </TouchableOpacity>
                                        <TouchableOpacity activeOpacity={.7}

                                        style={{
                                            width:80,
                                            height:40,
                                            backgroundColor:'white',
                                            flexDirection:"row",
                                            justifyContent:'center',
                                            alignItems:'center',
                                            marginBottom:12.5,
                                            borderRadius:2.5,
                                            borderWidth:.5,
                                            borderColor:'white',
                                        }}
                                        >
                                        <Text style={{ fontSize: 14, color: 'white' }}></Text>
                                        </TouchableOpacity>
                                    </View>

                                </View>
                            </TouchableOpacity>
                        ):(
                            // 工人认证、班组认证
                            <TouchableOpacity activeOpacity={.7}  style={{ backgroundColor: '#ebebeb' }}>
                                {/* title */}
                                <View style={{ height: 45, backgroundColor: '#eb4e4e', flexDirection: 'row', alignItems: 'center', justifyContent: 'center' }}>
                                    <Text style={{ fontSize: 15, color: '#fff' }}>请选择角色认证</Text>
                                </View>
                                {/* 选项 */}
                                {
                                    this.state.selectarr.map((item, key) => {
                                        return (
                                            <TouchableOpacity activeOpacity={.7} onPress={() => { openWebView(item.url); this.props.selectwork() }} key={key} style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'center', height: 53, backgroundColor: "#fff", marginBottom: 1 }}>
                                                <Text style={{ fontSize: 17, color: '#333' }}>{item.name}</Text>
                                            </TouchableOpacity>
                                        )
                                    })
                                }
                                {/* 取消按钮 */}
                                <TouchableOpacity activeOpacity={.7} onPress={() => this.props.selectwork()} style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'center', height: 53, backgroundColor: "#fff", marginTop: 4 }}>
                                    <Text style={{ fontSize: 17, color: '#333' }}>取消</Text>
                                </TouchableOpacity>
                            </TouchableOpacity>
                        )
                    }
                </Modal>
            </View>
        )
    }
}