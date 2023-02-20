# Sample Hardhat Project

This project demonstrates a basic Hardhat use case. It comes with a sample contract, a test for that contract, and a script that deploys that contract.

Try running some of the following tasks:

```shell
npx hardhat help
npx hardhat test
REPORT_GAS=true npx hardhat test
npx hardhat node
npx hardhat run scripts/deploy.ts
```

# Requirements
1. Funds take the form of a custom ERC20 token
2. Crowdfunded projects have a funding goal
3. When a funding goal is not met, customers are be able to get a refund of their pledged funds
4. dApps using the contract can observe state changes in transaction logs
5. Optional bonus: contract is upgradeable

# Contracts
Crowdfund: https://goerli.etherscan.io/address/0x91C33580F5D83eCA44FCe7322Fb3F73b24f486A8
Token: https://goerli.etherscan.io/address/0xd8acf0CFa3F70e8f111551FfE8E613C97A649510