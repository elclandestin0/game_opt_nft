// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "hardhat/console.sol";

contract SharpshooterPass is ERC1155, Ownable {
    using Strings for uint256;
    using ECDSA for bytes32;

    string public name = "SharpshooterPass";
    string public symbol = "SHARP";

    bytes32 private secretKey;

    constructor(address initialOwner, string memory uri, bytes32 _secretKey) ERC1155(uri) Ownable(initialOwner) {
        secretKey = _secretKey;
    }

    function mintNFT(uint256 tokenId, bytes32 proof) public {
        require(verifyNFTProof(tokenId, proof), "Invalid proof.");
        string memory tokenURI = "";

        _mint(msg.sender, tokenId, 1, "");
        _setURI(tokenURI);
    }

    // Function to generate a more secure hash proof for a given tokenId
    function generateNFTProof(uint256 tokenId) public view onlyOwner returns (bytes32) {
        return keccak256(abi.encodePacked(tokenId, secretKey));
    }

    // Helper function to convert bytes32 to string
    function bytes32ToString(bytes32 _bytes) internal pure returns (string memory) {
        bytes memory alphabet = "0123456789abcdef";
        bytes memory str = new bytes(64);
        for (uint256 i = 0; i < 32; i++) {
            str[i * 2] = alphabet[uint8(_bytes[i] >> 4)];
            str[1 + i * 2] = alphabet[uint8(_bytes[i] & 0x0f)];
        }
        return string(str);
    }

    // Function to verify the NFT proof
    function verifyNFTProof(uint256 tokenId, bytes32 proof) public view returns (bool) {
        bytes32 generatedProof = keccak256(abi.encodePacked(tokenId, secretKey));
        return generatedProof == proof;
    }

    function _numberToColorHex(uint256 number, uint256 length) private pure returns (string memory) {
        bytes memory buffer = new bytes(length);
        bytes16 hexCharacters = "0123456789abcdef"; // Use bytes16 for hex characters
        for (uint256 i = length; i > 0; --i) {
            buffer[i - 1] = hexCharacters[number & 0xf];
            number >>= 4;
        }
        return string(buffer);
    }

    function _base64Encode(bytes memory data) internal pure returns (string memory) {
        // Placeholder for the base64 encoding logic
        // In practice, you would replace this with actual base64 encoding
        return "base64EncodedString";
    }

    // This code is meant to generate html directly onto the Token URi
    function _generateArtWithAnimation(uint256 tokenId) internal view returns (string memory) {
        uint256 seed = uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender, tokenId)));
        string memory svg = '<svg xmlns="http://www.w3.org/2000/svg" width="320" height="320">';
        string memory styles = '<style>@keyframes blink { 50% { opacity: 0; } } rect { animation: blink 1s infinite; }</style>';

        svg = string(abi.encodePacked(svg, styles));

        for (uint256 i = 0; i < 32; i++) {
            for (uint256 j = 0; j < 32; j++) {
                string memory colorValue = _numberToColorHex((uint256(keccak256(abi.encodePacked(seed, i, j))) % 16777215), 6);
                uint256 x = i * 10;
                uint256 y = j * 10;
                svg = string(abi.encodePacked(svg, '<rect x="', x.toString(), '" y="', y.toString(), '" width="10" height="10" fill="#', colorValue, '"/>'));
            }
        }

        svg = string(abi.encodePacked(svg, '</svg>'));

        string memory base64EncodedSVG = _base64Encode(bytes(svg));
        return string(abi.encodePacked("data:image/svg+xml;base64,", base64EncodedSVG));
    }
}
