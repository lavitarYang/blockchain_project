// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./TestSyntax.sol";

contract Runner {
    address testsyntax_interface;

    function depotestsyntax(address _a) external {
        testsyntax_interface = _a;
    }

    function testsyntax_getvalue() external pure returns (uint256) {
        // TestSyntax instance = TestSyntax(testsyntax_interface);
    }
}
