import React, { Component } from 'react';
import {
    Image,
    Text,
    TouchableOpacity,
    View,
    Modal,
} from 'react-native';
import Icon from "react-native-vector-icons/Ionicons";

export default class alert extends Component {
    constructor(props) {
        super(props)
        this.state = {
        }
    }
    render() {
        return (
            <Modal visible={this.props.openAlert}
                animationType="none"//从底部划出
                transparent={true}//透明蒙层
                onRequestClose={() => this.props.openAlertFun()}//点击返回的回调函数
                style={{ height: '100%' }}
            >
                <TouchableOpacity
                onPress={()=>this.props.openAlertFun()}
                style={{flex:1,flexDirection:'row',alignItems:'center',justifyContent:'center',}}>
                    <View style={{backgroundColor:'rgba(0,0,0,0.7)',width:222,borderRadius:5,padding:25}}>
                        <View style={{flexDirection:'row',justifyContent:'center',marginTop:24,marginBottom:24}}>
                            {
                                this.props.icon == 'loading'?(
                                    <Icon name="refresh" size={36} color="#fff" />
                                ):this.props.icon == 'warning'?(
                                    <Icon name="warning" size={36} color="#fff" />
                                ):false
                            }
                        </View>
                        <Text style={{color:'#fff',fontSize:16,textAlign:'center',lineHeight:24}}>{this.props.font}</Text>
                    </View>
                </TouchableOpacity>
            </Modal>
        )
    }
}