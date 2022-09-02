<p align=center>
<a target="_blank" href="https://reactjs.org/" title="React"><img src="https://img.shields.io/badge/react-%3E%2016.1.1-brightgreen.svg"></a>
<a target="_blank" href="http://nodejs.org/download/" title="Node version"><img src="https://img.shields.io/badge/node-%3E%3D%208.0.0-brightgreen.svg"></a>
<img src="https://img.shields.io/hackage-deps/v/lens.svg"/>
<a target="_blank" href="#"><img src="https://img.shields.io/github/license/mashape/apistatus.svg"/></a>
</p> 

# LotterSmartContract
## ERC-721 Token 

ERC-721 non-fungible token：
    非同质化代币，拥有独一无二的token ID，与ERC-20相比，ERC-20的token可以彼此互换的，使用者A的50个token与使用者B的50个token是沒有差別的，但如果是ERC-721的因为每个token ID都不一样，所以不可以互换，视为独立的资产。

## Contracts
合約內容存放在`contracts/`下：
- `Utils`：
    执行合约所有工具类
- `Lotter.sol`：
    执行所有业务层合约

## Technical stack

### Frontend
- React
- Redux
- Saga
- Web3(MetaMask)

### Smart contract/Solidity
- Truffle

### Test environment/Private chain
- ganache

## Requirements

* NodeJS 8.0以上.
* Windows, Linux 或 Mac OS X.

## How To Install Dependencies

安装所需的相关组件：  
  
需要在local端起一个以太坊的节点，推荐使用 `ganache-cli`，你可以通过 npm install來安裝。

```
npm install -g ganache-cli
```

安裝truffle：

```
npm install -g truffle
```

安裝其余所需的套件:  

```
npm install
```
