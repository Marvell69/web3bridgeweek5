// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "../lib/forge-std/src/Script.sol";
import {Todo} from "../src/Todo.sol";

contract TodoScript is Script {
    Todo public todo;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        todo = new Todo ();

        vm.stopBroadcast();
    }
}
