// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract NFTMarketplace is ERC721URIStorage, Ownable {
    using Strings for uint256;

    uint256 private nextTokenId;

    struct NFTListing {
        uint256 price;
        address seller;
    }

    mapping(uint256 => NFTListing) private listings;

    event NFTListed(uint256 _tokenId, uint256 _price, address _seller);
    event NFTSold(
        uint256 _tokenId,
        uint256 _price,
        address _seller,
        address _buyer
    );

    constructor() ERC721("Jiggy", "JGY") Ownable(msg.sender) {}

    function mint(string memory _tokenURI) public returns (uint256) {
        uint256 tokenId = nextTokenId++;
        _safeMint(msg.sender, tokenId);
        _setTokenURI(tokenId, _tokenURI);
        return tokenId;
    }

    function listNFT(uint256 _tokenId, uint256 _price) public {
        require(ownerOf(_tokenId) == msg.sender, "Not the owner");
        require(_price > 0, "Price must be greater than zero");

        listings[_tokenId] = NFTListing(_price, msg.sender);
        emit NFTListed(_tokenId, _price, msg.sender);
    }

    function buyNFT(uint256 _tokenId) public payable {
        NFTListing memory listing = listings[_tokenId];
        require(listing.price > 0, "NFT not for sale");
        require(msg.value >= listing.price, "Insufficient payment");

        address seller = listing.seller;
        uint256 price = listing.price;

        delete listings[_tokenId];
        _transfer(seller, msg.sender, _tokenId);

        payable(seller).transfer(price);
        if (msg.value > price) {
            payable(msg.sender).transfer(msg.value - price);
        }

        emit NFTSold(_tokenId, price, seller, msg.sender);
    }

    function cancelListing(uint256 _tokenId) public {
        require(listings[_tokenId].seller == msg.sender, "Not the seller");
        delete listings[_tokenId];
    }

    function getListing(
        uint256 _tokenId
    ) public view returns (NFTListing memory) {
        return listings[_tokenId];
    }

    function withdraw() public onlyOwner {
        uint256 balance = address(this).balance;
        payable(owner()).transfer(balance);
    }
}
