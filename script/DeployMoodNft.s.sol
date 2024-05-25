// SPDX-License-Identifier: MIT

/* 
    1. deploy the MoodNft contract
    2. convert SVG to uri using a function in the deploy script then pass the URI to create the new MoodNft
*/

pragma solidity ^0.8.19;

import {Script, console} from "../lib/forge-std/src/Script.sol";
import {MoodNft} from "../src/MoodNft.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract DeployMoodNft is Script {
    uint256 public DEFAULT_ANVIL_KEY =
        0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80; // ONLY DO this for anvil chain

    function run() external returns (MoodNft) {
        string memory sadSvg = vm.readFile("./images/sad.svg");
        string memory happySvg = vm.readFile("./images/happy.svg");

        vm.startBroadcast(DEFAULT_ANVIL_KEY);
        MoodNft moodNft = new MoodNft(
            svgToImageUri(sadSvg),
            svgToImageUri(happySvg)
        );
        vm.stopBroadcast();
        return moodNft;
    }

    // convert svg to URI string
    function svgToImageUri(
        string memory svgPath
    ) public pure returns (string memory) {
        string memory baseURI = "data:image/svg+xml;base64,";
        string memory svgBase64Encoded = Base64.encode(
            bytes(string(abi.encodePacked(svgPath)))
        );
        return string(abi.encodePacked(baseURI, svgBase64Encoded));
    }
}
