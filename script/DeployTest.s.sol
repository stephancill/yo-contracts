// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {YoToken} from "../src/YoToken.sol";

contract DeployTestScript is Script {
    YoToken public yo;
    // address constant RECIPIENT = 0x8d25687829D6b85d9e0020B8c89e3Ca24dE20a89;
    address constant RECIPIENT = 0x8d25687829D6b85d9e0020B8c89e3Ca24dE20a89;

    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        yo = new YoToken();
        yo.setYoAmount(1 ether);
        yo.transfer(RECIPIENT, 100 ether);

        vm.stopBroadcast();
    }
}
