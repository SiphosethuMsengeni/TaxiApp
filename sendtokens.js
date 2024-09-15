const { Web3 } = require('web3');
const rpcURL = "https://alfajores-forno.celo-testnet.org"; 
const web3 = new Web3(rpcURL);
let pvtKey = 'YOUR_64_CHAR_HEX_PRIVATE_KEY'; //enter your private key
let accountFrom = "0x3199ac028922cc955b80928fc5a4e5d5fd6c6f0e"; //enter your address
let addressTo = ""; // enter address of wallet to send t

async function send() {
    const gasPrice = await web3.eth.getGasPrice();
    
    const nonce = await web3.eth.getTransactionCount(accountFrom);

    const tx = {
        gas: 21000,
        to: addressTo,
        value: web3.utils.toWei('1', 'ether'),
        gasPrice: gasPrice,
        nonce: nonce,
    };

    const signedTx = await web3.eth.accounts.signTransaction(tx, pvtKey);

    const receipt = await web3.eth.sendSignedTransaction(signedTx.rawTransaction);
    
    console.log('Transaction receipt:', receipt);
}

send();
