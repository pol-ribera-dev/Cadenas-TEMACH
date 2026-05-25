// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import "forge-std/Test.sol";
import "../src/CadenaTM.sol";
import "solady/utils/LibString.sol";

// Test of CadenaTM.sol

contract TMTest is Test {

    CadenaTM nft;

    address owner = address(1);
    address user = address(2);
    address user2 = address(3);

    string name_ = "Cadena TeMach";
    string symbol_ = "TM"; 
    uint amount_ = 400;
    string baseURI_ = "ipfs://bafybeigehs2otkbzipneb47bxi3jyzuc3glh7wg6enbior25352w3kmhkq/";
    uint96 royalty_ = 100;


    function setUp() public {
        vm.prank(owner);
        nft = new CadenaTM(name_, symbol_, amount_, baseURI_, royalty_);
    }

    function testDeployCorrect() view public {
        assertEq(nft.owner(), owner);
        assertEq(nft.name(), name_);
        assertEq(nft.totalSupply(), amount_);
        assertEq(nft.baseUri(), baseURI_);
        assertEq(nft.symbol(), symbol_);
    }

    function testMintCorrect() public {
        vm.prank(user);
        nft.mint();
        assertEq(nft.ownerOf(0), user);
    }

    function testJustOneMintPerAddress() public {
        vm.startPrank(user);
        nft.mint();
        vm.expectRevert("Already minted");
        nft.mint();
        vm.stopPrank();
    }

    function testNoMoreTokensAvaible() public {
        
        for (uint256 i = 0; i < 400; i++) {
            vm.prank(address(uint160(i+1)));
            nft.mint();
        }

        vm.expectRevert("Sold out");
        vm.prank(address(999));
        nft.mint();
    }

    function testAllUrisAreCorrect() public {
        
        for (uint256 i = 0; i < 400; i++) {
            vm.prank(address(uint160(i+1)));
            nft.mint();
        }

        for (uint256 i = 0; i < 400; i++) {
            assertEq(nft.ownerOf(i), address(uint160(i+1)));
            assertEq(nft.balanceOf(address(uint160(i+1))), 1);
            assertEq((nft.tokenURI(i)), string.concat("ipfs://bafybeigehs2otkbzipneb47bxi3jyzuc3glh7wg6enbior25352w3kmhkq/", vm.toString(i),".json"));
        }
    }

    function testGetUriWithoutMinting() public {
        vm.expectRevert();
        nft.tokenURI(1);
    }

    function testRoyaltyCorrect() public {
        vm.prank(user);
        nft.mint();

        uint256 salePrice = 1 ether;

        (address receiver, uint256 royaltyAmount) = nft.royaltyInfo(0, salePrice);

        assertEq(receiver, owner);
        assertEq(royaltyAmount, salePrice*royalty_/10000);
    }
}