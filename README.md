# Black Sock
The Black Sock protocol has been created to bring the social experience on chain. The Black Sock protocol enables users to connect, share and mint media rewarding all actions on chain in real time. The platform enables users to moderate their personal networks and also target their connections for specific shares. Users are also able to monetize actions such as being shared to or being advertised to directly, democratising and decentralizing the social experience. 

## How it's Built 
The Black Sock protocol consists of solidity contracts deployed on the Linea L2 ZK roll up with a ReactJS front end. Media storage is achieved through the use of IPFS with stream assembly operating through the browser.

### Architecture 
At the smart contract level the Black Sock protocol relies on a modular architecture which allows for new social modules to be added at a later date 

### Security
Security is achieved through the use of a directory and register architecture which enables a strong separation of concerns whilst ensuring that the user has full control over dynamic contracts they generate when using the protocol 

## How to Use


## Linea Goerli Testnet Deployment 
The addresses below are for the Linea Goerli Testnet 
|Contract | Address | Description| 
|----------|-----------|---------|
|BKS Register|[0x58CffF5FC7Ec84aDAa91753516A71E997df616Ed](https://explorer.goerli.linea.build/address/0x58CffF5FC7Ec84aDAa91753516A71E997df616Ed)|**BACK END CONTRACT** Main operational contract register|
|BKS Directory|[0x74D4ccb33E80E9A79d8aC1D1880dA9E66Da91c2e](https://explorer.goerli.linea.build/address/0x74D4ccb33E80E9A79d8aC1D1880dA9E66Da91c2e)|**BACK END CONTRACT** Main estate directory|
|Black Sock Test Reward Token|[0xFd7aB9E7f4f51a6Be45257CC14e45481FB535986](https://explorer.goerli.linea.build/address/0xFd7aB9E7f4f51a6Be45257CC14e45481FB535986)|Token for user rewards|
|BKS Reward Service|[0xbE0503E7430BAEb4A673945b2E0D1db9777C44D1](https://explorer.goerli.linea.build/address/0xbE0503E7430BAEb4A673945b2E0D1db9777C44D1)|**BACK END CONTRACT** Reward issuance service|
|BKS Profile Register|[0x38872A6AfD9a2Ea0d027920679F8110f0155d1fC](https://explorer.goerli.linea.build/address/0x38872A6AfD9a2Ea0d027920679F8110f0155d1fC)|Profile Register registers all profiles created by users|
|Black Sock|[0x0EDb0587D806a58cF4f1246849e3c2fE8dE53017](https://explorer.goerli.linea.build/address/0x0EDb0587D806a58cF4f1246849e3c2fE8dE53017)|Main Entry Point into the Black Sock protocol |
|BKS Media Module Factory|[0x37763B7bC86E683B0E134Ce39bF2A160894Fddc2](https://explorer.goerli.linea.build/address/0x37763B7bC86E683B0E134Ce39bF2A160894Fddc2)|**BACK END CONTRACT** Produces user Media Modules for upload and share|
|BKS Minted Media Contract Factory|[0x54EeE06C073C8838fA59b858018B913649e896d4](https://explorer.goerli.linea.build/address/0x54EeE06C073C8838fA59b858018B913649e896d4)|**BACK END CONTRACT** Produces NFT contracts which users use to mint media|
|BKS Money Module Factory|[0xA68E9f0fA58434A3659a1e5b3A3FE88016E7ca7f](https://explorer.goerli.linea.build/address/0xA68E9f0fA58434A3659a1e5b3A3FE88016E7ca7f)|**BACK END CONTRACT** Produces Money modules enabling users to manage payments and set prices|
|BKS People Module Factory|[0x7Ec49C3549Dc642BB17E6BbA6242C88E40549654](https://explorer.goerli.linea.build/address/0x7Ec49C3549Dc642BB17E6BbA6242C88E40549654)|**BACK END CONTRACT** Produces People modules that enable users to connect and moderate their connections |
|BKS Profile Factory|[0x729A3b74BEC81C89defBedFd90F41C53dA966D23](https://explorer.goerli.linea.build/address/0x729A3b74BEC81C89defBedFd90F41C53dA966D23)|**BACK END CONTRACT** Creates user profiles  |
|BKS Reward Module Factory|[0x796726e6a6821c6988A22C9a665A7323798a0321](https://explorer.goerli.linea.build/address/0x796726e6a6821c6988A22C9a665A7323798a0321)|**BACK END CONTRACT** Produces Reward Modules that enable users to manage their rewards|
|BKS Stream Module Factory|[0xABBD4228Fd397946E08656f05B3A83f8C37323f7](https://explorer.goerli.linea.build/address/0xABBD4228Fd397946E08656f05B3A83f8C37323f7)|**BACK END CONTRACT** Produces Stream Modules that enable users to manage their Black Sock media streams|
|BKS Module Register Factory|[0xa7898B80483d3E942ec30A1F68Dca600AF790af3](https://explorer.goerli.linea.build/address/0xa7898B80483d3E942ec30A1F68Dca600AF790af3)|**BACK END CONTRACT** Creates a user's personal module register where they can access new functions|

## How to Deploy
The steps to deploy the Black Sock 