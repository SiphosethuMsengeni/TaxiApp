const { Web3 } = require('web3');
const rpcURL = "https://alfajores-forno.celo-testnet.org";
const web3 = new Web3(rpcURL);
 
let myWallet = "0x3199ac028922cc955b80928fc5a4e5d5fd6c6f0e";

let ABI = [
    {
      "constant":true,
      "inputs":[{"name":"_owner","type":"address"}],
      "name":"balanceOf",
      "outputs":[{"name":"balance","type":"uint256"}],
      "type":"function"
    }
]

async function getBalance() {

    let contract = new web3.eth.Contract(ABI,fzarAddress);

    let myBalance = await contract.methods.balanceOf(myWallet).call();

    let readableBalance = web3.utils.fromWei(myBalance, 'ether');

    console.log('My balance is R', readableBalance)
}

getBalance()