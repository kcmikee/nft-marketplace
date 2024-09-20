# NFT Marketplace Smart Contract

This smart contract implements a basic NFT marketplace using the ERC721 standard. It allows users to mint, list, buy, and sell NFTs.

## Features

- Mint new NFTs with custom URIs
- List NFTs for sale
- Buy listed NFTs
- Cancel NFT listings
- Withdraw accumulated fees (owner only)

## Requirements

- Solidity version: ^0.8.20
- OpenZeppelin Contracts: 5.x
- ERC Standard: ERC721

## Installation

1. Install dependencies:
   ```
   npm install @openzeppelin/contracts@^5.0.2
   ```

2. Deploy the contract, providing the initial owner address.

## Usage

### Minting NFTs

function mint(string memory tokenURI) public returns (uint256)


### Listing NFTs

function listNFT(uint256 _tokenId, uint256 _price) public

### Buying NFTs

function buyNFT(uint256 _tokenId) public payable

### Cancelling Listings

function cancelListing(uint256 _tokenId) public

### Getting Listings

function getListing(uint256 _tokenId) public view returns (NFTListing memory)

## Security Considerations

- This contract has not been audited. Use at your own risk.
- Consider implementing additional access controls for production use.
- Thoroughly test all functions before deploying with real value.

## License

This project is licensed under the MIT License.