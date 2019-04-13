import React, { Component } from 'React'
import { View, Text, AppRegistry,TouchableOpacity,StyleSheet,Image } from 'react-native'

import Icon from "react-native-vector-icons/Ionicons";

var photoOptions = {
    //底部弹出框选项
    title:'请选择',
    cancelButtonTitle:'取消',
    takePhotoButtonTitle:'拍照',
    chooseFromLibraryButtonTitle:'选择相册',
    quality:0.75,
    allowsEditing:true,
    noData:false,
    storageOptions:{
        skipBackup:true,
        path:'images'
    }
}

export default class CameraButton extends Component {
    constructor(props) {
        super(props);
        this.state = {
            uri:'',
        }
    }
    render() {
        return (
            <View>
                <TouchableOpacity onPress={()=>this.openMycamera()} style={styles.lanmu}>
                        {/* 左 */}
                        <View>
                            <Text style={styles.font}>头像</Text>
                        </View>
                        {/* 右 */}
                        <View style={styles.right}>
                            <View style={{ width: 53, height: 53, borderRadius: 2, borderWidth: 1, borderColor: '#eee', flexDirection: 'row', alignItems: 'center', justifyContent: 'center', marginRight: 10 }}>
                                <Image style={{ width: 51, height: 51 }} source={require('../assets/recruit/header.png')}></Image>
                            </View>
                            <Icon name="r-arrow" size={12} color="#000" />
                        </View>
                    </TouchableOpacity>
            </View>
        )
    }
    openMycamera(){
    }
    uploadImage(uri){
        let formData = new FormData();
        let file = {uri:uri,type:'multipart/form-data',name:'image.png'};
        formData.append('file',file);
        fetch('url',{
            method:'POST',
            headers:{
                'Content-Type':'multipart/form-data'
            },
            body:formData,
        }).then((response)=>response.text())
            .then((responseData)=>{
                alert('上传成功')
            }).catch((error)=>{
                alert('上传失败')
            })
    }
}
const styles = StyleSheet.create({
    lanmu: {
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'space-between',
        paddingTop: 16,
        paddingBottom: 16,
        borderBottomWidth: 1,
        borderBottomColor: '#ebebeb',
    },
    font: {
        color: '#000',
        fontSize: 15,
        marginRight: 10,
    },
    right: {
        flexDirection: 'row',
        alignItems: 'center',
    },
    img: {
        width: 8,
        height: 12,
    },
})