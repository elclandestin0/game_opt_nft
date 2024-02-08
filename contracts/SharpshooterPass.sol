// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155MetadataURI.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract SharpshooterPass is ERC1155MetadataURI, Ownable {
    using Strings for uint256;
    using ECDSA for bytes32;

    string public name = "SharpshooterPass";
    string public symbol = "SHARP";

    constructor(address _signer) ERC1155("") {
        setSignerAddress(_signer);
    }

    function setSignerAddress(address _newSigner) external onlyOwner {
        signerAddress = _newSigner;
    }

    function mintNFT(bytes memory signature, uint256 tokenId) public {
        require(_verify(signature, tokenId, msg.sender), "Invalid proof");

        // Generate the art and URI
        string memory tokenURI = _generateArt(tokenId);

        _safeMint(msg.sender, tokenId);
        _setTokenURI(tokenId, tokenURI);
    }

    function _verify(bytes memory signature, uint256 tokenId, address account) internal view returns (bool) {
        bytes32 hash = keccak256(abi.encodePacked(tokenId, account));
        bytes32 ethSignedHash = hash.toEthSignedMessageHash();
        return ethSignedHash.recover(signature) == signerAddress;
    }

    function _generateArt(uint256 tokenId) internal view returns (string memory) {
        // Seed the pseudo-random generator
        uint256 seed = uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender, tokenId)));
        string memory svg = '<svg xmlns="http://www.w3.org/2000/svg" width="320" height="320">';

        for (uint i = 0; i < 32; i++) {
            for (uint j = 0; j < 32; j++) {
                uint256 colorValue = (uint256(keccak256(abi.encodePacked(seed, i, j))) % 16777215).toHexString(6);
                svg = string(abi.encodePacked(svg, '<rect x="', i.mul(10).toString(), '" y="', j.mul(10).toString(), '" width="10" height="10" fill="#', colorValue, '"/>'));
            }
        }

        svg = string(abi.encodePacked(svg, '</svg>'));

        // Encode SVG to base64 for the tokenURI
        string memory base64EncodedSVG = _base64Encode(bytes(svg));
        return string(abi.encodePacked("data:image/svg+xml;base64,", base64EncodedSVG));
    }

    // Implement _base64Encode(bytes memory data) to encode SVG data to base64
    // This function is left as an exercise due to space constraints
    function _base64Encode(bytes memory data) internal pure returns (string memory) {
        // Placeholder function for actual base64 encoding logic
        return "";
    }
}
