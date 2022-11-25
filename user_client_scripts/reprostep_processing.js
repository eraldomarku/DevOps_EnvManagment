const fs = require('fs');

const fileName = "reprosteps.test.js";
const fileData = fs.readFileSync(fileName, "utf-8");

// Split in lines

var lines = fileData.split("\n");
var urls = [];

lines.forEach(function(line) {
    if (line.includes("await")) {
        if (line.includes("https://")){
            urls.push(line);
        }
    }
})

var fields = [];

// Retrieve all query strings (after the question mark)

urls.forEach(function(url) {
    if(url.includes("/?")){
        var parameters = url.split("/?");
        var body = parameters[1];
        if(body.includes("%26")){
            var str = body.split("%26");
        }
        else {
            var str = body.split("&");
        }
        str.forEach(function(s){
            var value = s.split("=")[1];
            fields.push(value.replace(/\W/g, ''));
        })
    }
})

// This structure will host table names that can be retrieven from the urls.

let uniqueFields = [...new Set(fields)];

// Each type of accessed element: let's start from the buttons.

var treeItems = [];

lines.forEach(function(line) {
    if (line.includes("await")) {
        if (line.includes("getByRole")){
            if(line.includes('treeitem')){ // Treeitems
                treeItems.push(line);
            }
        }
    }
})

var regExp = /\{([^)]+)\}/;
var accessed_treeItemElements = []

treeItems.forEach(function(treeItem) {
    var info_item = regExp.exec(treeItem);
    var info_item_name = info_item[1].split(":")[1];
    var raw_info_item_name = info_item_name.replace(/["'"]/g, "").trim().replace(/[^\p{L}][ ]/gu, '').toLowerCase().replaceAll(' ', "_");
    if(raw_info_item_name != "modules"){
        accessed_treeItemElements.push(raw_info_item_name);
    }
})

let unique_treeItemElements = [...new Set(accessed_treeItemElements)];
let features = uniqueFields.concat(unique_treeItemElements);

features.forEach(function(feature) {
    fs.appendFile('reprosteps.txt', feature + ",", (err) => {
        if (err) throw err;
    })
})