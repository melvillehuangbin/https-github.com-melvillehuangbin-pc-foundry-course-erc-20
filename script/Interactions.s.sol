// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Script} from "../lib/forge-std/src/Script.sol";
import {DevOpsTools} from "../lib/foundry-devops/src/DevOpsTools.sol";
import {BasicNft} from "../src/BasicNft.sol";

contract Interactions is Script {
    string public constant PUG_URI =
        "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";
    /* get most recently deployed Nft using DevOpsTools library */
    function run() external {
        address mostRecentlyDeployedNftAddress = DevOpsTools
            .get_most_recent_deployment("BasicNft", block.chainid);
        return mintNftOnContract(mostRecentlyDeployedNftAddress);
    }

    /* mint an NFT using an instance of a Nft contract address */
    function mintNftOnContract(address contractAddress) public {
        vm.startBroadcast();
        BasicNft(contractAddress).mintNft(PUG_URI);
        vm.stopBroadcast();
    }
}
