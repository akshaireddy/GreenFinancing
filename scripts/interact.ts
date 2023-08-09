import { ethers } from 'ethers';
import * as dotenv from 'dotenv';

// Load environment variables from .env file
dotenv.config();

async function main() {
  const contractAddress = "0x9BC95cbfD09c624D1fb0b3CeecDdfE288ACB2b1c"; // Address of the deployed contract
  const provider = new ethers.providers.JsonRpcProvider(process.env.RPC_NODE_URL); // Use your preferred provider
  const privateKey = process.env.PRIVATE_KEY || ''; // Your private key
  const signer = new ethers.Wallet(privateKey, provider);
  const contract = new ethers.Contract(contractAddress, ['function createProject(string, uint256, uint256)', 'function contribute(uint256)'], signer);

  // Interact with the contract here
  const tx = await contract.createProject('Project 1', ethers.utils.parseEther('10'), Math.floor(Date.now() / 1000) + 3600);
  await tx.wait();

  console.log('Project created.');
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
