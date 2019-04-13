import React, { Component } from 'react'
import { StyleSheet, Text, View, TouchableOpacity, Platform, Image, ScrollView, TextInput, AsyncStorage } from 'react-native';
import Icon from "react-native-vector-icons/Ionicons";
import fetchFun from '../../fetch/fetch'

export default class selectaddress extends Component {
    constructor(props) {
        super(props)
        this.state = {
            listArr:[]
        }
    }
    // 顶部导航
    static navigationOptions = ({ navigation, screenProps }) => ({
        header: null
    });
    render() {
        return (
            <View style={styles.containermain}>
                {/* 导航条 */}
                <View style={{
                    height: 48, backgroundColor: '#FAFAFA', position: 'relative',
                    flexDirection: 'row', alignItems: 'center', justifyContent: "space-between",
                    borderBottomWidth: 1, borderBottomColor: '#ebebeb'
                }}>
                    <TouchableOpacity style={{ flexDirection: 'row', alignItems: 'center', marginLeft: 10, marginBottom: 1, width: '25%' }}
                        onPress={() => this.props.navigation.goBack()}>
                        <Icon style={{ marginRight: 3 }} name="l-arrow" size={19} color="#eb4e4e" />
                        <Text style={{ marginRight: 10, color: '#eb4e4e', fontWeight: '400', fontSize: 17 }}>返回</Text>
                    </TouchableOpacity>
                    <View style={{ flex: 1, flexDirection: 'row', justifyContent: 'center', alignItems: 'center' }}>
                        <Text style={{ fontSize: 17, color: '#3d4145', fontWeight: '400', }}>选择项目地址</Text>
                    </View>
                    <TouchableOpacity
                        style={{ width: '25%', height: '100%', marginRight: 10, flexDirection: 'row', alignItems: 'center', justifyContent: 'flex-end' }}>
                    </TouchableOpacity>
                </View>

                <View style={{
                    backgroundColor: 'white', borderBottomWidth: .6,
                    borderBottomColor: '#ebebeb',
                }}>
                    <View style={{
                        marginLeft: 10, marginRight: 10, marginTop: 5, marginBottom: 5,
                        backgroundColor: "#eee", height: 32, borderRadius: 6, flexDirection: 'row', alignItems: 'center'
                    }}>
                        <Icon style={{ marginLeft: 5 }} name="search" size={20} color="#999999" />
                        <TextInput
                            style={{ fontSize: 12, padding: 2 }}
                            placeholder={'请输入项目地址关键词搜索'}
                            onChangeText={this.addressFun.bind(this)}
                        ></TextInput>
                    </View>
                </View>
            
                {/* 列表数据 */}
                <ScrollView style={{paddingLeft:10,paddingRight:10}}>
                    {
                        this.state.listArr.map((v,index)=>{
                            return(
                                <TouchableOpacity key={index}
                                onPress={()=>this.click(v.name)}
                                style={{borderBottomWidth:1,borderBottomColor:'#ebebeb',paddingTop:15,paddingBottom:15}}>
                                    <Text style={{color:'#333',fontSize:18.1,lineHeight:27.2}}>{v.name}</Text>
                                    <Text style={{color:'#999',fontSize:16,lineHeight:24}}>{v.city}{v.district}</Text>
                                </TouchableOpacity>
                            )
                        })
                    }
                </ScrollView>
            </View>
        )
    }
    addressFun(e) {
        fetchFun.load({
            url: 'http://api.map.baidu.com/place/v2/suggestion',
            completeUrl: true,//是否是完整URL
            type:'GET',
            data: {
                query: e,
                region: this.props.navigation.getParam('fbzgAddressTwoName'),
                // region: '成都市',
                output: 'json',
                ak: 'vaVH6Ls3Tisndi940ma2keNeGSm0UvH4',
            },
            success: (res) => {
                console.log('---具体地址---',res)
                if(res.message == 'ok'){
                    this.setState({
                        listArr:res.result
                    })
                }
            }
        });
    }
    click(name){
        GLOBAL.fbzgAddress.detailAddress = name
        this.props.navigation.state.params.callback()
        this.props.navigation.goBack()
    }
}
const styles = StyleSheet.create({
    containermain: {
        flex: 1,
        width: '100%',
        backgroundColor: 'white',
    },
})