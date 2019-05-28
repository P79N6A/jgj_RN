/**
 * approx distance between two points on earth ellipsoid
 * @param {Object} lat1
 * @param {Object} lng1
 * @param {Object} lat2
 * @param {Object} lng2
 */

var EARTH_RADIUS = 6378.0;    //单位公里
var PI = Math.PI;
var x_pi = 3.14159265358979324 * 3000.0 / 180.0;

function getRad(d) {
    return d * PI / 180.0;
}

function getFlatternDistance(lat1, lng1, lat2, lng2) {
    var f = getRad((lat1 + lat2) / 2);
    var g = getRad((lat1 - lat2) / 2);
    var l = getRad((lng1 - lng2) / 2);

    var sg = Math.sin(g);
    var sl = Math.sin(l);
    var sf = Math.sin(f);

    var s, c, w, r, d, h1, h2;
    var a = EARTH_RADIUS;
    var fl = 1 / 298.257;

    sg = sg * sg;
    sl = sl * sl;
    sf = sf * sf;

    s = sg * (1 - sl) + (1 - sf) * sl;
    c = (1 - sg) * (1 - sl) + sf * sl;

    w = Math.atan(Math.sqrt(s / c));
    r = Math.sqrt(s * c) / w;
    d = 2 * w * a;
    h1 = (3 * r - 1) / 2 / c;
    h2 = (3 * r + 1) / 2 / s;

    return d * (1 + fl * (h1 * sf * (1 - sg) - h2 * (1 - sf) * sg));
};

function bd_encrypt(gcjLat, gcjLon) {//腾讯坐标转百度坐标
    var x = gcjLon, y = gcjLat;
    var z = Math.sqrt(x * x + y * y) + 0.00002 * Math.sin(y * x_pi);
    var theta = Math.atan2(y, x) + 0.000003 * Math.cos(x * x_pi);
    var bdLon = z * Math.cos(theta) + 0.0065;
    var bdLat = z * Math.sin(theta) + 0.006;
    return {'lat': bdLat, 'lon': bdLon};
};

function bd_decrypt(bdLat, bdLon) {//百度转腾讯
    var x = bdLon - 0.0065, y = bdLat - 0.006;
    var z = Math.sqrt(x * x + y * y) - 0.00002 * Math.sin(y * x_pi);
    var theta = Math.atan2(y, x) - 0.000003 * Math.cos(x * x_pi);
    var gcjLon = z * Math.cos(theta);
    var gcjLat = z * Math.sin(theta);
    return {'lat': gcjLat, 'lon': gcjLon};
}

export {bd_encrypt, bd_decrypt, getFlatternDistance};