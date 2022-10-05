// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "solmate/tokens/ERC20.sol";

// import "../lib/solmate/src/tokens/ERC20.sol";

contract Simba is ERC20("Simba", "SMB", 18) {
    constructor(address user) {
        _mint(user, 2000000*10**18);
    }
}
