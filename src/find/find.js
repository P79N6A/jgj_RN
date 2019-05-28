

import React, { Component } from 'react';
import {
    Text,
    View,
    Image,
    TouchableOpacity,
} from 'react-native';
import Icon from "react-native-vector-icons/iconfont";

export default class recruitplan extends Component {
    constructor(props) {
        super(props)
        this.state = {}
    }
    // 顶部导航
    static navigationOptions = ({ navigation, screenProps }) => ({
        header: null,gesturesEnabled: false,
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
                    <TouchableOpacity activeOpacity={.7} 
                    style={{ flexDirection: 'row', alignItems: 'center', marginLeft: 10, 
                    marginBottom: 1, width: '25%' }}>
                    </TouchableOpacity>
                    <View style={{ flex: 1, flexDirection: 'row', justifyContent: 'center', alignItems: 'center' }}>
                        <Text style={{ fontSize: 17, color: '#3d4145', fontWeight: '400', }}>发现</Text>
                    </View>
                    <TouchableOpacity activeOpacity={.7} style={{ width: '25%', height: '100%', marginRight: 10, flexDirection: 'row', alignItems: 'center', justifyContent: 'flex-end' }}>
                    </TouchableOpacity>
                </View>
            
                {/* 内容 */}
                <View style={{marginTop:22,marginBottom:22,paddingTop:15,paddingBottom:15,paddingRight:15,
                flexDirection:"row",justifyContent:'space-between',alignItems:'center',backgroundColor:'#fff'}}>
                    <View style={{marginLeft:22,flexDirection:'row',alignItems:"center"}}>
                        <Icon name="r-arrow" size={12} color="#000" />
                        <Text style={{marginLeft:13}}>共有圈</Text>
                    </View>
                    <Icon name="r-arrow" size={12} color="#000" />
                </View>
            </View>
        )
    }
}