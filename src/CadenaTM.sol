// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.24;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/common/ERC2981.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import {Strings} from "../lib/openzeppelin-contracts/contracts/utils/Strings.sol";

contract CadenaTM is ERC721, ERC2981, Ownable {
    using Strings for uint256;

    uint256 public currentTokenId; 
    uint256 public totalSupply;
    string public baseUri;

    mapping(address => bool) public hasMinted;

    modifier canMint() {
        require(!hasMinted[msg.sender], "Already minted");
        _;
    }

    modifier tokensAvaible(){
        require(currentTokenId < totalSupply, "Sold out");
        _;
    }

    event MintNFT(address userAddress_, uint256 tokenId_);

    constructor(string memory name_, string memory symbol_, uint256 totalSupply_, string memory baseUri_, uint96 _royalty) ERC721(name_, symbol_) Ownable(msg.sender){
        totalSupply = totalSupply_;
        baseUri = baseUri_;
        _setDefaultRoyalty(msg.sender, _royalty);
    }

    function mint() external canMint tokensAvaible { 
        hasMinted[msg.sender] = true;
        _safeMint(msg.sender, currentTokenId);
        uint256 id = currentTokenId;
        currentTokenId++;
        emit MintNFT(msg.sender, id);
    }

    function _baseURI() internal override view virtual returns (string memory) {
        return baseUri;
    }

    function tokenURI(uint256 tokenId) public view override virtual returns (string memory) {
        _requireOwned(tokenId);

        string memory baseURI = _baseURI();
        return bytes(baseURI).length > 0 ? string.concat(baseURI, tokenId.toString(), ".json") : "";
    }  

    function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC2981) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

}