var path = require("path");
var webpack = require("webpack");
var HtmlWebpackPlugin = require("html-webpack-plugin");

var localPort = "3000";

module.exports = {
    entry: [
        "webpack-dev-server/client?http://localhost:" + localPort,
        "webpack/hot/only-dev-server",
        "./js-example/index"
    ],
     devServer: {
         contentBase: "."
     },
    devtool: "source-map",
    output: {
        path: path.join(__dirname, "js-example"),
        //filename: "bundle.js"
        filename: "[hash].exampleBundle.js" // for cache busting
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
            { test: /\.js$/, loaders: ["babel"], include: path.join(__dirname, "js-example") }
        ]
    }
};
