var path = require("path");
var webpack = require("webpack");
var HtmlWebpackPlugin = require("html-webpack-plugin");

var localPort = "9090";

module.exports = {
    entry: [
        "webpack-dev-server/client?http://localhost:" + localPort,
        "webpack/hot/only-dev-server",
        "./static/hookup",
        "./js-build/frontend"
    ],
     devServer: {
         contentBase: "./js-build"
     },
    devtool: "source-map",
    output: {
        path: path.join(__dirname, "js-build"),
        //filename: "bundle.js"
        filename: "[hash].bundle.js" // for cache busting
    },
    plugins: [
        new webpack.HotModuleReplacementPlugin(),
        // modifies index.html to include bundle.js:
        new HtmlWebpackPlugin({
            template: "./index.html"
        }),
        new webpack.DefinePlugin({
            "process.env": {
                IS_IN_WEBPACK: true,
                NODE_ENV: '"development"'
            }
        })
    ],
    devtool: "source-map",
    module: {
        loaders: [
        ]
    }
};
