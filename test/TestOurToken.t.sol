// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import {Test, console2} from "forge-std/Test.sol";
import {DeployOurToken} from "../script/DeployOurToken.s.sol";
import {OurToken} from "../src/OurToken.sol";

interface MintableToken {
    function mint(address, uint256) external;
}

contract OurTokenTest is Test {
    uint256 public constant INITIAL_SUPPLY = 10000000 ether;
    uint256 public constant STARTING_BALANCE = 1000 ether;
    //uint256 BOB_STARTING_BALANCE = 100 ether;

    OurToken public ourToken;
    DeployOurToken public deployer;

    address bob = makeAddr("bob");
    address alice = makeAddr("alice");

    function setUp() public {
        deployer = new DeployOurToken();
        ourToken = deployer.run();

        vm.prank(address(msg.sender));
        ourToken.transfer(bob, STARTING_BALANCE);
    }

    function testBobBalance() public view {
        assertEq(STARTING_BALANCE, ourToken.balanceOf(bob));
        console2.log("Bob's balance is", ourToken.balanceOf(bob));
    }

    function testInitialSupply() public view {
        assertEq(INITIAL_SUPPLY, ourToken.totalSupply());
        console2.log("Total supply is", ourToken.totalSupply());
    }

    function testUsersCanMint() public {
        vm.expectRevert();
        MintableToken(address(ourToken)).mint(address(this), 1);

        //vm.prank(bob);
        //ourToken.mint(bob, 420);      IF ADD MINT FUNCTION IN OURTOKEN.sol
        //console2.log(
        //"Bob was able to mint",
        //bool(ourToken.balanceOf(bob) == STARTING_BALANCE + 420)
        //);
    }

    function testAllowances() public {
        uint256 initialAllowance = 1000;

        vm.prank(bob);
        ourToken.approve(alice, initialAllowance);
        uint256 transferAmount = 500;

        vm.prank(alice);
        ourToken.transferFrom(bob, alice, transferAmount);
        assertEq(ourToken.balanceOf(alice), transferAmount);
        assertEq(ourToken.balanceOf(bob), STARTING_BALANCE - transferAmount);
        console2.log("Bob transferred:", uint256(ourToken.balanceOf(alice)));
    }
}
