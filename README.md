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
|Black Sock Test Reward Token|[0x5a86c39322c972607b2080F67BEe46D2F1e37869](https://explorer.goerli.linea.build/address/0x5a86c39322c972607b2080F67BEe46D2F1e37869/contracts#address-tabs)|Token for user rewards|
|BKS Profile Register|[0x85DA54b234D90B9007400108f1c48eA10c508e6d](https://explorer.goerli.linea.build/address/0x85DA54b234D90B9007400108f1c48eA10c508e6d/contracts#address-tabs)|Profile Register registers all profiles created by users|
|Black Sock|[0xfB6239a551CD7D068Be37AcFc38D524840273082](https://explorer.goerli.linea.build/address/0xfB6239a551CD7D068Be37AcFc38D524840273082/contracts#address-tabs)|Main Entry Point into the Black Sock protocol |
||**BACK OFFICE CONTRACTS**|||
|BKS Ops Register|[0xb717E2043F36Cb5BBB60CDD73D4B531018b3Dfea](https://explorer.goerli.linea.build/address/0xb717E2043F36Cb5BBB60CDD73D4B531018b3Dfea/contracts#address-tabs)|**BACK END CONTRACT** Main operational contract register|
|BKS Reward Service|[0x5c895D381a18F4Dd8ea01069b139c14b85EB9bd0](https://explorer.goerli.linea.build/address/0x5c895D381a18F4Dd8ea01069b139c14b85EB9bd0/contracts#address-tabs)|**BACK END (DEVELOPER) CONTRACT** Reward issuance service|
|BKS Directory|[0xb93d77aCBe0A4a9d1C9C0fe3Fb65F32578c8d530](https://explorer.goerli.linea.build/address/0xb93d77aCBe0A4a9d1C9C0fe3Fb65F32578c8d530/contracts#address-tabs)|**BACK END CONTRACT** Main estate directory|
|BKS Media Module Factory|[0x26e57Db8EbEc157817Dacc051B7749050B3D2bb4](https://explorer.goerli.linea.build/address/0x26e57Db8EbEc157817Dacc051B7749050B3D2bb4/contracts#address-tabs)|**BACK END CONTRACT** Produces user Media Modules for upload and share|
|BKS Minted Media Contract Factory|[0x4053F9A009B8b3afaFD8C83ed8Fb804B629fFbE2](https://explorer.goerli.linea.build/address/0x4053F9A009B8b3afaFD8C83ed8Fb804B629fFbE2/contracts#address-tabs)|**BACK END CONTRACT** Produces NFT contracts which users use to mint media|
|BKS Money Module Factory|[0x960b11f46df9c76f6303E2b3C62435ED5Db175F9](https://explorer.goerli.linea.build/address/0x960b11f46df9c76f6303E2b3C62435ED5Db175F9/contracts#address-tabs)|**BACK END CONTRACT** Produces Money modules enabling users to manage payments and set prices|
|BKS People Module Factory|[0xF34b3151E7bbb772a0A65C990a45A4761e3A94c5](https://explorer.goerli.linea.build/address/0xF34b3151E7bbb772a0A65C990a45A4761e3A94c5/contracts#address-tabs)|**BACK END CONTRACT** Produces People modules that enable users to connect and moderate their connections |
|BKS Profile Factory|[0x46DD782566673DF8BC3a867bba26b938252B4EC2](https://explorer.goerli.linea.build/address/0x46DD782566673DF8BC3a867bba26b938252B4EC2/contracts#address-tabs)|**BACK END CONTRACT** Creates user profiles  |
|BKS Reward Module Factory|[0x296724acbad4D2440a259528d13d542f37A7C153](https://explorer.goerli.linea.build/address/0x296724acbad4D2440a259528d13d542f37A7C153/contracts#address-tabs)|**BACK END CONTRACT** Produces Reward Modules that enable users to manage their rewards|
|BKS Stream Module Factory|[0xABBD4228Fd397946E08656f05B3A83f8C37323f7](https://explorer.goerli.linea.build/address/0xABBD4228Fd397946E08656f05B3A83f8C37323f7)|**BACK END CONTRACT** Produces Stream Modules that enable users to manage their Black Sock media streams|
|BKS Module Register Factory|[0xb94573Ab9D9Bf05201D7340B8d7A25dDc2e0497C](https://explorer.goerli.linea.build/address/0xb94573Ab9D9Bf05201D7340B8d7A25dDc2e0497C/contracts#address-tabs)|**BACK END CONTRACT** Creates a user's personal module register where they can access new functions|