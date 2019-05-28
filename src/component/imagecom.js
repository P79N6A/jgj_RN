
import React, { Component } from 'react';
import {
    StyleSheet,
    Text,
    View,
    Image,
    TouchableOpacity,
} from 'react-native';
import {nameCode} from '../com'

export default class hiriingrecord extends Component{
    constructor(props){
        super(props)
        this.state={
            isImg:true,
        }
    }
    onError(){
        this.setState({
            isImg:false
        })
    }
    componentWillMount(){
        if(this.props.userPic && this.props.userPic.indexOf('headpic_m') == -1 && this.props.userPic.indexOf('headpic_f') == -1 && this.props.userPic.indexOf('nopic=1') == -1){
            this.setState({
                isImg:true
            })
        }else{
            this.setState({
                isImg:false
            })
        }
    }

    render(){
        let pic
        if(this.props.userPic.indexOf('media/images/') == -1){
            pic  = GLOBAL.apiUrl.replace(/([\w]):\/\/[\w]+\.([\w]+\.)?(\w+)\.(.+)/gi, "$1://$2cdn.$3.$4") +'media/images/'+ this.props.userPic
        }else{
            pic  = GLOBAL.apiUrl.replace(/([\w]):\/\/[\w]+\.([\w]+\.)?(\w+)\.(.+)/gi, "$1://$2cdn.$3.$4") + this.props.userPic
        }
        
        // 用户头像背景色计算
        let newUserName = this.props.userName.substring(this.props.userName.length - 2, this.props.userName.length)//取名字最后两位
        let headColorArr = ['#e6884f', '#ffae2f', '#99bb4f', '#56c2c5', '#62b1da', '#5990d4', '#7266ca', '#bf67cf', '#da63af', '#df5e5e']
        let userName = this.props.userName.replace(/[^0-9a-zA-z\u4e00-\u9fa5]*/g, "");
        let headColor = headColorArr[nameCode(userName)]
        return(
            <View>
                {
                    this.state.isImg?(
                        <Image 
                        style={this.props.style}
                        source={{ uri:pic }}
                        onError={(error)=>this.onError()}
                        ></Image>
                    ):(
                        <View style={{
                            backgroundColor: headColor, 
                            flexDirection: 'row', alignItems: 'center',
                            justifyContent: 'center',
                            borderRadius: this.props.style.borderRadius, 
                            width: this.props.style.width, 
                            height: this.props.style.height,
                            // marginLeft: 10,marginRight:10, overFlow: 'hidden'
                        }}>
                            <Text style={{color:'#fff',fontSize:parseInt(this.props.fontSize)}}>{newUserName}</Text>
                        </View>
                    )
                }
            </View>
        )
    }
}