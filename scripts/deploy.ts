const { ethers } = require('hardhat');
require("dotenv").config();

async function main() {
  const GreenFinancing = await ethers.getContractFactory('GreenFinancing');
  const greenFinancing = await GreenFinancing.deploy();
  
  await greenFinancing.deployed();
  console.log('GreenFinancing deployed to:', greenFinancing.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
