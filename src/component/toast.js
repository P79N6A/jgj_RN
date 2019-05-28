import React, {Component} from 'react'
import RootToast from 'react-native-root-toast'
import {View, Text, StyleSheet, Dimensions, ActivityIndicator} from 'react-native';
import RootSiblings from 'react-native-root-siblings';

const Toast = {
    show: msg => {
        RootToast.show(msg, {
            position: 0,
            duration: 2000
        })
    },
    longShow: msg => {
        RootToast.show(msg, {
            position: 0,
            duration: 4000
        })
    }
}


let sibling = undefined;
const width = Dimensions.get('window').width;
const height = Dimensions.get('window').height;

const Loading = {

    show: () => {
        sibling = new RootSiblings(
            <View style={styles.maskStyle}>
                <View style={styles.backViewStyle}>
                    <ActivityIndicator size="large" color="white"/>
                </View>
            </View>
        )
    },

    hidden: () => {
        if (sibling instanceof RootSiblings) {
            sibling.destroy()
        }
    }

}

const styles = StyleSheet.create({
        maskStyle: {
            position: 'absolute',
            backgroundColor: 'rgba(0, 0, 0, 0.1)',
            width: width,
            height: height,
            alignItems: 'center',
            justifyContent: 'center'
        },
        backViewStyle: {
            backgroundColor: 'rgba(0, 0, 0, 0.6)',
            width: 120,
            height: 100,
            justifyContent: 'center',
            alignItems: 'center',
            borderRadius: 5,
        }
    }
)
export {Toast, Loading}