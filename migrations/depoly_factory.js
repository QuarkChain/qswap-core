const QuarkChain = require('quarkchain-web3');
const Web3 = require('web3');
const dotenv = require("dotenv");
dotenv.config();
const Factory = require('../build/UniswapV2Factory.json');

const web3 = new Web3();
QuarkChain.injectWeb3(web3, 'http://jrpc.devnet.quarkchain.io:38391');

const mainnetNetworkId = '0x1';
const devnetNetworkId = '0xff';

// Needed in nodejs environment, otherwise would require MetaMask.
web3.qkc.setPrivateKey(process.env.PK);
// const fullShardKey = QuarkChain.getFullShardIdFromEthAddress(web3.qkc.address);
const fullShardKey = process.env.FULLSHARDKEY;
console.log('QKC Address', web3.qkc.address);

// creation of contract object
var contract = web3.qkc.contract(Factory.abi);

// deploy
var instance = contract.new(web3.qkc.address, {
  data: '0x'+Factory.bytecode,
  gas: 5000000,
  gasPrice: 1e9,
  networkId: devnetNetworkId,
  fromFullShardKey: fullShardKey,
  toFullShardKey: fullShardKey}, function(err, myContract){
   if(!err) {
      // NOTE: The callback will fire twice!
      // Once the contract has the transactionId property set and once its deployed on an address.

      // e.g. check tx hash on the first call (transaction send)
      if(!myContract.address) {
          console.log(myContract.transactionId); // The id of the transaction, which deploys the contract

      // check address on the second call (contract deployed)
      } else {
          console.log(myContract.address); // the contract address
      }

      // Note that the returned "myContractReturned" === "myContract",
      // so the returned "myContractReturned" object will also get the address set.
   } else {
     console.log(err);
   }
 });
