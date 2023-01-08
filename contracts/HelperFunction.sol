// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract HelperFunction {
    uint256 seed = 0;

    function random() external {
        seed = uint256(
            keccak256(abi.encodePacked(msg.sender, block.timestamp, seed))
        );
        seed %= 5;
        seed += 1;
        // return seed;
    }

    function getseed() external view returns (uint256) {
        return seed;
    }

    function copy() internal pure returns (uint256) {
        return 1;
    }
}
