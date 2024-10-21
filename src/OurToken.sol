// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract OurToken is ERC20 {
    constructor(uint256 initialSupply) ERC20("Base Island", "BIS") {
        _mint(msg.sender, initialSupply);
    }
}
