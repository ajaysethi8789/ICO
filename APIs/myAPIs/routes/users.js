var express = require('express');
var router = express.Router();
var Web3 = require('web3');
var multipart = require('connect-multiparty');
var multipartMiddleware = multipart();


/* GET users listing. */
router.get('/', function(req, res, next) {
  res.send('respond with a resource');
});

var web3 = new Web3(new Web3.providers.HttpProvider('http://localhost:8545'));
/*
 Function to create Account 
*/
router.post("/createAccount", multipartMiddleware, async (req, res, next) => {
  try {
         console.log("Inside createAccount");
            
            web3.eth.personal.newAccount('tranxit')  // creating New Account
              .then(function (response, err) {
                if (err) {
                  console.log("ERROR Occured in Account CReation == ",err);
                }
                console.log(response);  // Account Address generated
                
                console.log("Account Created Successfully = ",account);
              }         
        )
      }
  catch (err) {
    console.log(err);
    res.sendStatus(500);
    return;
  }
});


module.exports = router;
