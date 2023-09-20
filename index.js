const { utf8ToBytes } = require("ethereum-cryptography/utils");  
const { bytesToHex } = require("ethereum-cryptography/utils");
const { sha256 } = require("ethereum-cryptography/sha256");
const { getRandomBytesSync} = require("ethereum-cryptography/random.js");
const fs = require("fs").promises;
const express = require("express");
const cors = require("cors");

const app = express();

app.get("/get_accessCode", (req,res) => {
    res.send(getRandomBytesSync(3));
});

app.listen(5000, () => console.log("server is running"));
