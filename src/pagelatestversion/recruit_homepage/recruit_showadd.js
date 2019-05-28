import React, { Component, PropTypes } from 'react'
import { StyleSheet, Text, View, TouchableOpacity, Platform, Image, ScrollView } from 'react-native';
import Icon from "react-native-vector-icons/iconfont";
import fetchFun from '../../fetch/fetch'

// import {
//     MapView,
//     MapTypes,
//     Geolocation,
// } from 'react-native-baidu-map';


export default class jobdetails extends Component {
    constructor(props) {
        super(props)
        this.state = {
            // mayType: MapTypes.NORMAL,
            // zoom: 15,
            // trafficEnabled: false,
            // baiduHeatMapEnabled: false,
        };

    }
    // 顶部导航
    static navigationOptions = ({ navigation, screenProps }) => ({
        header: null,gesturesEnabled: false,
    });

    componentDidMount() { // 获取位置
        // Geolocation.getCurrentPosition().then(
        //     (data) => {
        //         this.setState({
        //             zoom: 18,
        //             markers: [{
        //                 latitude: data.latitude,
        //                 longitude: data.longitude,
        //                 title: '我的位置'
        //             }],
        //             center: {
        //                 latitude: data.latitude,
        //                 longitude: data.longitude,
        //             }
        //         })
        //     }
        // ).catch(error => {
        //     console.warn(error, 'error')
        // })
    }

    render() {
        return (
            <View style={{ flex: 1 }}>
                {/* 导航条 */}
                <View style={{
                    height: 48, backgroundColor: '#FAFAFA', position: 'relative',
                    flexDirection: 'row', alignItems: 'center', justifyContent: "space-between",
                    borderBottomWidth: 1, borderBottomColor: '#ebebeb'
                }}>
                    <TouchableOpacity activeOpacity={.7} style={{ flexDirection: 'row', alignItems: 'center', marginLeft: 10, marginBottom: 1, width: '25%' }}
                        onPress={() => this.props.navigation.goBack()}>
                        <Icon style={{ marginRight: 3 }} name="l-arrow" size={19} color="#eb4e4e" />
                        <Text style={{ marginRight: 10, color: '#eb4e4e', fontWeight: '400', fontSize: 17 }}>返回</Text>
                    </TouchableOpacity>
                    <View style={{ flex: 1, flexDirection: 'row', justifyContent: 'center', alignItems: 'center' }}>
                        <Text style={{ fontSize: 17, color: '#000000', fontWeight: '400', }}>查看位置</Text>
                    </View>
                    <TouchableOpacity activeOpacity={.7} style={{ width: '25%', height: '100%', marginRight: 10, flexDirection: 'row', alignItems: 'center', justifyContent: 'flex-end' }}>
                    </TouchableOpacity>
                </View>

                <View style={styles.container}>
                    {/* <MapView
                    trafficEnabled={this.state.trafficEnabled}
                    baiduHeatMapEnabled={this.state.baiduHeatMapEnabled}
                    zoom={this.state.zoom}
                    mapType={this.state.mapType}
                    center={this.state.center}
                    marker={this.state.marker}
                    markers={this.state.markers}
                    style={styles.map}
                    onMapClick={(e) => {
                    }}
                    >
                    </MapView> */}
                </View>

            </View>
        )
    }
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        height: 400,
        flexDirection: 'row',
        justifyContent: 'flex-start',
        alignItems: 'center',
        backgroundColor: '#F5FCFF',
    },
    map: {
        flex: 1,
        height: 400,
    }

})