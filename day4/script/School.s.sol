// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from"../lib/forge-std/src/Script.sol";
import {School} from "../src/School.sol";

contract SchoolScript is Script {
    School public school        ;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        school = new School(0xd9fabD5E3B542D72dE50Cd42459bef745e6D7a1a);

        vm.stopBroadcast();
    }
}
