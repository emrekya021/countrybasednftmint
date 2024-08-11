// akıllı kontratı remixde deployladım buraya sadece kodu incelemek isteyenler için ekliyorum

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CountryBasedNFT is ERC721, Ownable {
    uint256 public nextTokenId;
    uint256 public productPrice = 1 ether; // Ürün fiyatı 1 ETH
    mapping(string => uint256) public shippingCosts;

    constructor() ERC721("CountryNFT", "CNFT") Ownable(msg.sender) {}

    function mintNFT(string memory country) public payable {
        uint256 shippingCost = shippingCosts[country];
        uint256 totalCost = productPrice + shippingCost;

        require(msg.value >= totalCost, "Insufficient ETH sent");

        _safeMint(msg.sender, nextTokenId);
        nextTokenId++;

        if (msg.value > totalCost) {
            payable(msg.sender).transfer(msg.value - totalCost);
        }
    }

    function setShippingCost(string memory country, uint256 costInEth) public onlyOwner {
        shippingCosts[country] = costInEth;
    }

    function updateProductPrice(uint256 newPriceInEth) public onlyOwner {
        productPrice = newPriceInEth;
    }

    function withdrawETH() public onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No ETH to withdraw");
        payable(owner()).transfer(balance);
    }
}

