// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {YoToken} from "../src/YoToken.sol";

contract DeployScript is Script {
    YoToken public yo;

    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        yo = new YoToken();
        yo.setYoAmount(1 ether);

        vm.stopBroadcast();
    }
}
