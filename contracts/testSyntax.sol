// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./HelperFunction.sol";

contract TestSyntax {
    // function for_test(uint256 _i) external view returns (uint256) {
    //     uint256 time;
    //     for (time; time < 10; time++) {
    //         _i++;
    //     }
    //     return _i;
    // }

    enum Store {
        Backery,
        Butcher
    }
    mapping(Store => uint256[2]) public stores;

    function getStoreData(uint256 _i)
        external
        view
        returns (uint256[2] memory)
    {
        return stores[Store(_i)];
    }

    constructor() {
        uint256 i;
        for (i = 0; i < 2; i++) {
            stores[Store(i)][0] = 10;
            stores[Store(i)][1] = 15;
        }
    }

    // function _random() public returns (uint256) {
    //     return copy();
    // }

    // function _copy() external pure returns (uint256) {
    //     return copy();
    // }
}
