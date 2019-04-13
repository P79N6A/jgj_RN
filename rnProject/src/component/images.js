
import React, { Component } from 'react';
import {
    StyleSheet,
    Text,
    View,
    Image,
    TouchableOpacity,
} from 'react-native';

export default class hiriingrecord extends Component {
    constructor(props) {
        super(props)
        this.state = {
            isImg: true,
        }
    }
    onError() {
        this.setState({
            isImg: false
        })
    }
    render() {
        
        let lengths = this.props.lengths
        let index = this.props.index
        let modalNum = parseInt(this.props.modalNum)
        // http://test.cdn.jgjapp.com/media/simages/m/media/images/proimgs/20170205/081554078155.JPEG
        let pic
        if(this.props.userPic.indexOf('media') == -1){
            pic = GLOBAL.apiUrl.replace(/([\w]):\/\/[\w]+\.([\w]+\.)?(\w+)\.(.+)/gi, "$1://$2cdn.$3.$4") + 'media/simages/m/' + this.props.userPic
        }else if(this.props.userPic.indexOf('simages') == -1){
            pic=this.props.userPic.split("media/images/"); //字符分割
            pic = pic[0]+pic[1]
            pic = GLOBAL.apiUrl.replace(/([\w]):\/\/[\w]+\.([\w]+\.)?(\w+)\.(.+)/gi, "$1://$2cdn.$3.$4") + 'media/simages/m/' + pic
        }
        return (
            <View>
                {
                    this.state.isImg ? (
                        index < modalNum ? (
                            <Image
                                style={{ width: parseInt(this.props.width), 
                                    height: parseInt(this.props.height), 
                                    marginRight: parseInt(this.props.marginRight), 
                                    marginBottom: parseInt(this.props.marginBottom) }}
                                source={{ uri: pic }}
                                onError={(error) => this.onError()}
                            ></Image>
                        ) : (
                                index == modalNum ? (
                                    <View
                                        key={index}
                                        style={{ position: 'relative' }}>
                                        <Image
                                            style={{ width: parseInt(this.props.width), 
                                                height: parseInt(this.props.height), 
                                                marginRight: parseInt(this.props.marginRight), 
                                                marginBottom: parseInt(this.props.marginBottom) }}
                                            source={{ uri: pic }}
                                            onError={(error) => this.onError()}
                                        ></Image>
                                        {/* 蒙层 */}
                                        <View
                                            style={{
                                                backgroundColor: 'rgba(0,0,0,.5)', width: parseInt(this.props.width), 
                                                height: parseInt(this.props.height), 
                                                position: 'absolute', flexDirection: 'row', alignItems: 'center', justifyContent: 'center'
                                            }}>
                                            <Text
                                                style={{ color: '#fffefe', fontSize: 14 }}>+{lengths - modalNum-1}</Text>
                                        </View>
                                    </View>
                                ) : (
                                        <View key={index}></View>
                                    )
                            )
                    ) : (
                            // 图片加载错误显示
                            index < modalNum ? (
                                <Image
                                    source={require('../assets/recruit/imgerror.png')}
                                    style={{ width: parseInt(this.props.width), 
                                        height: parseInt(this.props.height), 
                                        marginRight: parseInt(this.props.marginRight), 
                                        marginBottom: parseInt(this.props.marginBottom) }}></Image>
                            ) : (
                                    index == modalNum ? (
                                        <View
                                            key={index}
                                            style={{ position: 'relative' }}>
                                            <Image
                                                source={require('../assets/recruit/imgerror.png')}
                                                style={{ width: parseInt(this.props.width), 
                                                    height: parseInt(this.props.height), 
                                                    marginRight: parseInt(this.props.marginRight), 
                                                    marginBottom: parseInt(this.props.marginBottom) }}></Image>
                                            {/* 蒙层 */}
                                            {
                                                lengths - 4 > 0?(
                                                    <View
                                                style={{
                                                    backgroundColor: 'rgba(0,0,0,.5)', width: parseInt(this.props.width), 
                                                    height: parseInt(this.props.height), 
                                                    position: 'absolute', flexDirection: 'row', alignItems: 'center', justifyContent: 'center'
                                                }}>
                                                <Text
                                                    style={{ color: '#fffefe', fontSize: 14 }}>+{lengths - modalNum-1}
                                                </Text>
                                            </View>
                                                ):(<Text></Text>)
                                            }
                                        </View>
                                    ) : (
                                            <View key={index}></View>
                                        )
                                )
                        )
                }
            </View>
        )
    }
}