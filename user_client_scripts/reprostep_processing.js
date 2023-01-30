const fs = require('fs');

const fileName = "reprosteps.test.js";
const fileData = fs.readFileSync(fileName, "utf-8");

var lines = fileData.split("\n");
var urls = [];
var timestamp;

lines.forEach(function(line) {
if (line.includes("await")) {
if (line.includes("https://")){
urls.push(line);
}
}
if (line.includes("console.log")) {
if (line.includes("Timestamp")) {
timestamp = line.split("Timestamp: ")[1].replace("\r", "");
}
}
})

var fields = [];

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

let uniqueFields = [...new Set(fields)];

var treeItems = [];

lines.forEach(function(line) {
if (line.includes("await")) {
if (line.includes("getByRole")){
if(line.includes('treeitem')){
treeItems.push(line);
}
}
}
})

var regExp = /{([^)]+)}/;
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
fs.appendFile('reprosteps.txt', feature + "," + timestamp + "\n", (err) => {
if (err) throw err;
})
})