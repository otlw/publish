var forumAddress = '0x9C9253320969dAA501cCf07321CB952c2763d162';
var forumABI = [ { "constant": false, "inputs": [ { "name": "title", "type": "string" }, { "name": "data", "type": "string" }, { "name": "replyTo", "type": "address" }, { "name": "weight", "type": "uint256" } ], "name": "makeReply", "outputs": [], "type": "function" }, { "constant": false, "inputs": [ { "name": "post", "type": "address" }, { "name": "tagToAdd", "type": "string" } ], "name": "addTag", "outputs": [], "type": "function" }, { "constant": true, "inputs": [ { "name": "post", "type": "address" } ], "name": "getNumberOfTags", "outputs": [ { "name": "", "type": "uint256", "value": "0" } ], "type": "function" }, { "constant": false, "inputs": [ { "name": "title", "type": "string" }, { "name": "data", "type": "string" } ], "name": "makePost", "outputs": [ { "name": "", "type": "address" } ], "type": "function" }, { "constant": true, "inputs": [ { "name": "tagName", "type": "string" } ], "name": "getPostsFromTag", "outputs": [ { "name": "", "type": "address[]", "value": [] } ], "type": "function" }, { "constant": true, "inputs": [ { "name": "post", "type": "address" }, { "name": "i", "type": "uint256" } ], "name": "getTagFromPosts", "outputs": [ { "name": "", "type": "string" } ], "type": "function" }, { "constant": true, "inputs": [ { "name": "post", "type": "address" } ], "name": "getTitle", "outputs": [ { "name": "", "type": "string", "value": "" } ], "type": "function" }, { "constant": true, "inputs": [ { "name": "post", "type": "address" } ], "name": "getReplies", "outputs": [ { "name": "", "type": "address[]", "value": [] } ], "type": "function" }, { "inputs": [ { "name": "forumName", "type": "string", "index": 0, "typeShort": "string", "bits": "", "displayName": "forum Name", "template": "elements_input_string", "value": "test" }, { "name": "cost", "type": "uint256", "index": 1, "typeShort": "uint", "bits": "256", "displayName": "cost", "template": "elements_input_uint", "value": "100" } ], "type": "constructor" }, { "anonymous": false, "inputs": [ { "indexed": false, "name": "_postAddress", "type": "address" } ], "name": "PostMade", "type": "event" } ];
var documentABI =  [{"constant":false,"inputs":[],"name":"getTotalWeight","outputs":[{"name":"","type":"uint256"}],"type":"function"},{"constant":false,"inputs":[],"name":"pay","outputs":[],"type":"function"},{"constant":true,"inputs":[],"name":"getData","outputs":[{"name":"","type":"string"}],"type":"function"},{"constant":false,"inputs":[{"name":"weight","type":"uint256"}],"name":"setAuthorWeight","outputs":[],"type":"function"},{"constant":false,"inputs":[{"name":"source","type":"address"},{"name":"weight","type":"uint256"}],"name":"addSource","outputs":[],"type":"function"},{"constant":false,"inputs":[{"name":"source","type":"address"},{"name":"newValue","type":"uint256"}],"name":"modifySourceWeight","outputs":[],"type":"function"},{"constant":false,"inputs":[],"name":"payout","outputs":[],"type":"function"},{"constant":false,"inputs":[{"name":"source","type":"address"}],"name":"removeSource","outputs":[],"type":"function"},{"constant":false,"inputs":[{"name":"newAuthor","type":"address"}],"name":"modifyAuthor","outputs":[],"type":"function"},{"constant":true,"inputs":[],"name":"getAuthor","outputs":[{"name":"","type":"address"}],"type":"function"},{"constant":true,"inputs":[{"name":"requestedAddress","type":"address"}],"name":"getWeight","outputs":[{"name":"","type":"uint256"}],"type":"function"},{"inputs":[{"name":"dataHash","type":"string"}],"type":"constructor"}];
var textContent
function init() {
  postAddress = decodeURI(getParameterByName('post'));
  tag = decodeURI(getParameterByName('tag'));
  document.getElementById('title').textContent = title;

  // IPFS Initialization
  ipfs = window.IpfsApi('localhost', '5001');

  // Web3 Initialization
  if(typeof web3 !== 'undefined' && typeof Web3 !== 'undefined') {
      // If there's a web3 library loaded, then make your own web3
      web3 = new Web3(web3.currentProvider);
  } else if (typeof Web3 !== 'undefined') {
      // If there isn't then set a provider
      web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
  } else if(typeof web3 == 'undefined') {
    // Alert the user he is not in a web3 compatible browser
    console.log("not web3 compatible");
    return;
  }

  // Loading the contracts
  documentContract = web3.eth.contract(documentABI);
  forum = web3.eth.contract(forumABI).at(forumAddress);

  if (typeof postAddress == 'undefined' || postAddress == 'null' || postAddress === '') {
    document.getElementById("proposal").textContent = "Give Stakers a Voice";
  }
  else {
    document.getElementById("title").textContent = getTitle(postAddress);
    document.getElementById("bodyContent").textContent = getIPFS(postAddress);
  }
}

function getReplies (address){

  var replies = forum.getReplies(address);
  if (replies.length === 0) {
    document.getElementById('status').textContent = "No comments";
  }
}
function getIPFS (address) {
  console.log(address);
  var ipfsContent = documentContract.at(address).getData();
  var dataString = ipfs.block.get(ipfsContent, function (err, data) {
    return data;
  });
  return dataString;
}

function getTitle (address) {
  var title = forum.getTitle(address);
  return title;
}
function getParameterByName(name, url) {
    if (!url) url = window.location.href;
    name = name.replace(/[\[\]]/g, "\\$&");
    var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
        results = regex.exec(url);
    if (!results) return null;
    if (!results[2]) return '';
    return decodeURIComponent(results[2].replace(/\+/g, " "));
}
