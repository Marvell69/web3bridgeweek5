// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from"../lib/forge-std/src/Script.sol";
import {SaveAsset} from "../src/SaveAsset.sol";

contract SaveAssetScript is Script {
    SaveAsset public saveAsset;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        saveAsset = new SaveAsset(address(0xd9fabD5E3B542D72dE50Cd42459bef745e6D7a1a));

        vm.stopBroadcast();
    }
}
