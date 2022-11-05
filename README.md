# Multi Signature Ethereum Wallet System

With this system you can create unlimited multiSig wallets with unlimited signatures for each of them.You can access to your wallet with your password and your personal wallet address.you can charge your wallet and submit a transaction, confirm it and execute.

Transactions are executed only when all those who have the right to sign in that wallet sign that transaction.

After that, the transaction is executed and the money is transferred from the multi-signature wallet to the destination and an amount is sent as a fee to the contract maker.

## Installtion
1. Run Ganache
2. Edit `truffle-config.js` to your ganache RPC SERVER
3. Download source code and go to source code path
4. run `truffle test` for run test script or `truffle migrate` for access to truffle console.

## Functions
<table>
   <tr>
      <th>Name</th>
      <th>Description</th>
      <th>Input Parameters</th>
      <th>Returns</th>
   </tr>
   <tr>
      <td>addMultiSig</td>
      <td>Add a new multi signiture wallet</td>
      <td>password, multi signiture wallet addresses as an array</td>
      <td>-</td>
   </tr>
   <tr>
      <td>submitTransaction</td>
      <td>Submit a transaction</td>
      <td>password, destination address, amount</td>
      <td>-</td>
   </tr>
   <tr>
      <td>confirmTransaction</td>
      <td>confirm a transaction</td>
      <td>password, transaction id</td>
      <td>-</td>
   </tr>
   <tr>
      <td>revokeTransaction</td>
      <td>revoke a transaction</td>
      <td>password, transaction id</td>
      <td>-</td>
   </tr>
   <tr>
      <td>executeTransaction</td>
      <td>execute a transaction</td>
      <td>password, transaction id</td>
      <td>-</td>
   </tr>
   <tr>
      <td>getOwners</td>
      <td>Get multi signature wallet owners address</td>
      <td>password</td>
      <td>owners addresses</td>
   </tr>
   <tr>
      <td>getTransaction</td>
      <td>Get transcation information</td>
      <td>password, transaction id</td>
      <td>transcation information</td>
   </tr>
   <tr>
      <td>getBalance</td>
      <td>Get multi signature wallet balance</td>
      <td>password</td>
      <td>multi signature wallet balance</td>
   </tr>
   <tr>
      <td>getAddress</td>
      <td>Get multi signature wallet address</td>
      <td>password</td>
      <td>multi signature wallet address</td>
   </tr>
   <tr>
      <td>chargeWallet</td>
      <td>Send money to your multi signature wallet</td>
      <td>password</td>
      <td>-</td>
   </tr>
</table>