
import React, { Component } from 'react';
import {
    StyleSheet,
    Text,
    View,
    ScrollView,
    TouchableOpacity,
    TouchableWithoutFeedback,
    Image,
    ListView,
    Modal,
    ImageBackground,
    TextInput,
} from 'react-native';
var Dimensions = require('Dimensions');
const { width, height } = Dimensions.get('window');
export default class Select extends Component {
    constructor(props) {
        super(props);
        this.state = ({
            showModal: false,
            course: "语文",
            refreshing: false,
        });
    }
    selCourse(course) {
        this.setState({
            showModal: false,
            course: course,
        });
    }
    render() {
        return (
            <View style={styles.container}>
                <View style={styles.headStyle}>
                    <Text style={styles.headText} onPress={() => { this.setState({ showModal: true }) }}>
                        {this.state.course}
                    </Text>
                    <TouchableOpacity style={{ marginLeft: 10 }}
                        onPress={() => { this.setState({ showModal: true }) }}>
                    </TouchableOpacity>
                </View>
                {/* Modal 组件是一种简单的覆盖在其他视图之上显示内容的方式 */}
                <Modal
                    visible={this.state.showModal}//是否显示
                    transparent={true}//指背景是否透明
                    animationType='fade'//出现的动画效果
                    style={{ flex: 1 }}
                    ref="modal"  >
                    <TouchableWithoutFeedback onPress={() => { this.setState({ showModal: false }) }} >
                        <View style={{ flex: 1, alignItems: 'center', backgroundColor: 'rgba(0, 0, 0, 0.5)', }}

                        >
                            <TouchableWithoutFeedback>
                                <View style={{
                                    backgroundColor: '#fff', width: width,
                                    justifyContent: 'center',

                                }}

                                >
                                    <View style={styles.headStyle}>
                                        <Text style={styles.headText} onPress={() => { this.setState({ showModal: false }) }}>
                                            {this.state.course}
                                        </Text>
                                        <TouchableOpacity style={{ marginLeft: 10 }}
                                            onPress={() => { this.setState({ showModal: false }) }}>
                                        </TouchableOpacity>
                                    </View>
                                    <View style={styles.courseWrap}>
                                        <CourseItem course="语文" onPress={() => { this.selCourse('语文') }} />
                                        <CourseItem course="数学" onPress={() => { this.selCourse('数学') }} />
                                        <CourseItem course="英语" onPress={() => { this.selCourse('英语') }} />
                                        <CourseItem course="物理" onPress={() => { this.selCourse('物理') }} />
                                        <CourseItem course="化学" onPress={() => { this.selCourse('化学') }} />
                                    </View>
                                </View>
                            </TouchableWithoutFeedback>
                        </View>
                    </TouchableWithoutFeedback>
                </Modal>
                {/* 背景图片 */}
                <ImageBackground style={styles.div} source={require('../../../assets/test/img.jpg')}>
                    <Image style={styles.img} source={require('../../../assets/test/wd.png')}></Image>
                </ImageBackground>
                {/* 输入框 */}
                <TextInput style={styles.input} placeholder='请输入信息...'></TextInput>
                <ScrollView>
                    <Text>ScrollView</Text>
                    <Text>ScrollView</Text>
                    <Text>ScrollView</Text>
                    <Text>ScrollView</Text>
                    <Text>ScrollView</Text>
                    <Text>ScrollView</Text>
                    <Text>ScrollView</Text>
                    <Text>ScrollView</Text>
                    <Text>ScrollView</Text>
                </ScrollView>
                <ScrollView
                    refreshControl={
                    <RefreshControl
                        refreshing={this.state.refreshing}
                        onRefresh={this._onRefresh}
                    />
                    }
                />
            </View>
        );
    }
    _onRefresh = () => {
        this.setState({refreshing: true});
        fetchData().then(() => {
          this.setState({refreshing: false});
        });
      }
}
class RefreshControl extends Component{
    render(){
        return(
            <View>
                 <Text>ScrollView</Text>
                    <Text>ScrollView</Text>
            </View>
        )
    }
}
// 单个下拉选项组件
class CourseItem extends Component {
    render() {
        return (
            <TouchableOpacity style={styles.boxView} onPress={this.props.onPress}>
                <View style={styles.divs}>
                    <Text style={{ fontSize: 12 }}>{this.props.course}</Text>
                </View>
            </TouchableOpacity>
        )
    }
}
var cols = 3;
var boxW = 70;
var vMargin = (width - cols * boxW) / (cols + 1);
var hMargin = 25;
const styles = StyleSheet.create({
    boxView: {
        justifyContent: 'center',
        alignItems: 'center',
        width: 60,
        height: 30,
        borderWidth: 1,
        borderColor: '#999',
        borderRadius: 5,
    },
    courseWrap: {
        flexDirection: 'row',
        justifyContent:'space-between',
        borderWidth: 0,
        borderColor: 'orange',
        paddingLeft:10,
        paddingRight:10,
        paddingTop:10,
        paddingBottom:10,
    },
    headText: {
        fontSize: 12,
    },
    headStyle: {
        flexDirection: 'row',
        width: width,
        justifyContent: "center",
        alignItems: 'center',
        backgroundColor: '#F2F2F2',
        paddingTop: 15,
        paddingBottom: 15,
    },
    container: {
        flex: 1,
        alignItems: 'center',
        backgroundColor:'#ebebeb'
    },
    div:{
        height:400,
        width:'100%',
        backgroundColor:'gray',
        flexDirection:'row',
        alignItems:'center',
        justifyContent:'center',
    },
    img:{
        width:50,
        height:50,
    },
    input:{
        width:150,
        height:40,
        borderWidth:1,
        borderColor:'gray',
    },
});
