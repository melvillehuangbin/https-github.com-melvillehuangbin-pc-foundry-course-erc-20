// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {BasicNft} from "../src/BasicNft.sol";
import {Script} from "../lib/forge-std/src/Script.sol";

contract DeployBasicNft is Script {
    function run() external returns (BasicNft) {
        vm.startBroadcast();
        BasicNft basicNft = new BasicNft();
        vm.stopBroadcast();
        return basicNft;
    }
}
