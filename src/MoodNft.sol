// SPDX-License-Identifier

/* 
    Basic Concepts
        - An NFT needs a `mint` function. minting an NFT to a user means giving the user a token a specific token id
        - An NFT is uniquely identified by a tokenId
        - URI: generic identifier for a resource
        - URL: points to the exact location of the resource
*/

/* 
    Goal: Write a MoodNft contract
    1. Follows ERC721 NFT standard
    2. constructor
    3. mintNft
    4. flip the mood of the NFT
    5. return the tokenURI
    6. getter functions for Happy SVG, Sad SVG, token counter
*/

pragma solidity ^0.8.19;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract MoodNft is ERC721, Ownable {
    // errors
    error MoodNft__CannotFlipMoodIfNotOwner();
    error ERC721Metadata__URI_QueryFor_NonExistentToken();

    event CreatedNft(uint256 indexed tokenId);

    uint256 private s_tokenCounter;
    string private s_sadSvg;
    string private s_happySvg;

    mapping(uint256 => NftState) private s_tokenIdToState;

    enum NftState {
        HAPPY,
        SAD
    }

    constructor(
        string memory sadSvgImageUri,
        string memory happySvgImageUri
    ) ERC721("MoodNft", "MD") Ownable(msg.sender) {
        s_tokenCounter = 0;
        s_sadSvg = sadSvgImageUri;
        s_happySvg = happySvgImageUri;
    }

    /* give a NFT with a certain tokenId to a user */
    function mintNft() public {
        uint256 tokenCounter = s_tokenCounter; // set tokenId to current tokenId
        _safeMint(msg.sender, tokenCounter); // mint nft for user
        s_tokenCounter = tokenCounter + 1; // count new tokenId
        emit CreatedNft(tokenCounter); // emit event when nft is minted (created)
    }

    /* flip the mood of the nft */
    function flipMood(uint256 tokenId) public view {
        // only flip when owner requests for it
        if (
            _getApproved(tokenId) != msg.sender &&
            _ownerOf(tokenId) != msg.sender
        ) {
            revert MoodNft__CannotFlipMoodIfNotOwner();
        }
        // flip to happy when sad
        // else flip to sad
        if (s_tokenIdToState[tokenId] == NftState.SAD) {
            s_tokenIdToState[tokenId] == NftState.HAPPY;
        } else {
            s_tokenIdToState[tokenId] == NftState.SAD;
        }
    }

    /* override baseURI */
    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }

    /* get the tokenURI of the token */
    function tokenURI(
        uint256 tokenId
    ) public view virtual override returns (string memory) {
        if (ownerOf(tokenId) == address(0)) {
            revert ERC721Metadata__URI_QueryFor_NonExistentToken();
        } // check owner of token is not 0 address

        string memory imageURI = s_happySvg;

        // set the ImageURI of the NFT depending on the NftState
        if (s_tokenIdToState[tokenId] == NftState.HAPPY) {
            imageURI = s_sadSvg;
        }

        // return the tokenURI by encoding the relevant information

        return
            string(
                abi.encodePacked(
                    _baseURI(),
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name":"',
                                "MoodNft", // You can add whatever name here
                                '", "description":"An NFT that reflects the mood of the owner, 100% on Chain!", ',
                                '"attributes": [{"trait_type": "moodiness", "value": 100}], "image":"',
                                imageURI,
                                '"}'
                            )
                        )
                    )
                )
            );
    }

    function getHappySvgUri() external view returns (string memory) {
        return s_happySvg;
    }

    function getSadSvgUri() external view returns (string memory) {
        return s_sadSvg;
    }

    function getTokenCounter() external view returns (uint256) {
        return s_tokenCounter;
    }
}
