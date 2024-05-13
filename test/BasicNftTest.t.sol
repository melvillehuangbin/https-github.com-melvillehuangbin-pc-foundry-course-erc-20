// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test, console} from "../lib/forge-std/src/Test.sol";
import {DeployBasicNft} from "../script/DeployBasicNft.s.sol";
import {BasicNft} from "../src/BasicNft.sol";

contract BasicNftTest is Test {
    DeployBasicNft public deployer;
    BasicNft public basicNft;
    string public constant PUG_URI =
        "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";
    address public USER = makeAddr("USER");

    /* test to check name of Nft deployed is correct */
    function setUp() public {
        deployer = new DeployBasicNft();
        basicNft = deployer.run();
    }

    /* 
        Note: we cannot compare strings in solidity as they are though of as arrays. Only primitive types like uint256, address etc can be compared

        To compare strings we can use the functions abi.encodePacked() & keccak256()
    */

    function testNameIsCorrect() public view {
        string memory expectedName = "Dogie";
        string memory actualName = basicNft.name();
        assert(
            keccak256(abi.encodePacked(expectedName)) ==
                keccak256(abi.encodePacked(actualName))
        );
    }

    function testCanMintNft() public {
        vm.prank(USER);
        basicNft.mintNft(PUG_URI);

        assert(basicNft.balanceOf(USER) == 1);
    }

    function testTokenUriIsCorrect() public {
        vm.prank(USER);
        basicNft.mintNft(PUG_URI);

        assert(
            keccak256(abi.encodePacked(basicNft.tokenURI(0))) ==
                keccak256(abi.encodePacked(PUG_URI))
        );
    }
}
