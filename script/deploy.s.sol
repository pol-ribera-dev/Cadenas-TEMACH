// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.24;

import {Script} from "forge-std/Script.sol";
import {CadenaTM} from "../src/CadenaTM.sol";

contract DeployTMNFT is Script {

    function run() external returns(CadenaTM){
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY"); 
        vm.startBroadcast(deployerPrivateKey); 

        string memory name_ = "Cadena TEMACH";
        string memory symbol_ = "TM"; 
        uint256 totalSupply_ = 400;
        string memory baseUri_ = "ipfs://bafybeigehs2otkbzipneb47bxi3jyzuc3glh7wg6enbior25352w3kmhkq/";
        uint96 royalty_ = 100;
        CadenaTM nft = new CadenaTM(name_, symbol_, totalSupply_, baseUri_, royalty_);

        vm.stopBroadcast();
        return nft;
    }

}