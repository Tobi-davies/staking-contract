// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Stake.sol";
import "../src/Simba.sol";

contract StakingTest is Test {
    Simba public simba;
    Stake public stake;
    address admin=0xB6E63c79B4dF12DF083f6Ca8AD56D655b63653b7;
    address public staker = 0x758c32B770d656248BA3cC222951cF1aC1DdDAaA;

    function setUp() public {
         simba = new Simba(admin);
        stake = new Stake(address(simba));
        vm.startPrank(admin);
        ERC20(address(simba)).transfer(address(stake), 50000e18);
        ERC20(address(simba)).transfer(staker, 1000e18);
        vm.stopPrank();

    }

    function testStaking() public {
        vm.startPrank(staker);
        ERC20(address(simba)).approve(address(stake), 1000e18);
        uint totalbalanceBefore = getB();
        stake.stake(500e18);
        assertEq(getB(), totalbalanceBefore-500e18);
        totalbalanceBefore-=500e18;
        vm.warp(block.timestamp + 30 days);
        stake.unstake(100e18);
        // assertEq(getB(), totalbalanceBefore + 150e18);
         assertApproxEqAbs(getB(), totalbalanceBefore + 150e18, 1e18);
        stake.getUser(staker);
        // assertEq(getB(), totalbalanceBefore + 150e18);
        vm.stopPrank();
    }

    function getB()internal view returns(uint) {
       return ERC20(address(simba)).balanceOf(staker);
    }
}