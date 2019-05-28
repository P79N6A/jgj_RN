import React, { Component } from 'react';
import {
    Image,
    Text,
    TouchableOpacity,
    View,
    Modal,
} from 'react-native';
import Icon from "react-native-vector-icons/iconfont";

export default class alert extends Component {
    constructor(props) {
        super(props)
        this.state = {
        }
    }
    render() {
        // this.props.alertValue: '',//弹框内容
        // this.props.ifError: false,//弹框图标为正确类型还是错误类型
        // this.props.openAlert: false,//控制弹框关闭打开
        return (
            <Modal visible={this.props.openAlert}
                animationType="none"//从底部划出
                transparent={true}//透明蒙层
                onRequestClose={() => this.props.openAlertFun()}//点击返回的回调函数
                style={{ height: '100%' }}
                onShow={()=>setTimeout(()=>{
                    this.props.closeAlertFun()
                },3000)}
            >
                <TouchableOpacity activeOpacity={.7}
                onPress={()=>this.props.openAlertFun()}
                style={{flex:1,flexDirection:'row',alignItems:'center',justifyContent:'center',}}>
                    <View style={{backgroundColor:'rgba(0,0,0,0.7)',width:222,borderRadius:5,padding:20}}>
                        {
                            this.props.ifError?(
                                <View style={{flexDirection:'row',justifyContent:'center',marginBottom:20}}>
                                    <Icon name="success" size={36} color="#fff" />
                                </View>
                                ):(
                                    <View style={{flexDirection:'row',justifyContent:'center',marginTop:24,marginBottom:20}}>
                                        <Icon name="delete" size={36} color="#fff" />
                                    </View>
                                )
                        }
                        <Text style={{color:'#fff',fontSize:16,textAlign:'center',lineHeight:24}}>{this.props.alertValue}</Text>
                    </View>
                </TouchableOpacity>
            </Modal>
        )
    }
}