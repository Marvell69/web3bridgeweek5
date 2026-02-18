// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

contract SaveEther {
  mapping(address => uint256) public balances;
  receive() external payable {}
  fallback() external {}
}