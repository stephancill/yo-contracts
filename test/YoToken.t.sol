// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {YoToken} from "../src/YoToken.sol";

contract YoTest is Test {
    event YoEvent(
        address indexed from,
        address indexed to,
        uint256 indexed amount,
        bytes data
    );

    YoToken public yo;
    address alice = makeAddr("alice");
    address bob = makeAddr("bob");

    function setUp() public {
        yo = new YoToken();

        // Fund alice with some ETH for gas
        vm.deal(alice, 1 ether);
    }

    function test_InitialState() public {
        assertEq(yo.yoAmount(), 0);
        assertEq(yo.owner(), address(this));
    }

    function test_SetYoAmount() public {
        uint256 amount = 100;
        yo.setYoAmount(amount);
        assertEq(yo.yoAmount(), amount);
    }

    function test_RevertSetYoAmount_NonOwner() public {
        vm.prank(alice);
        vm.expectRevert();
        yo.setYoAmount(100);
    }

    function test_YoEmitsEvent() public {
        vm.expectEmit(true, true, true, true);
        emit YoEvent(address(this), bob, 0, "");
        yo.yo(bob, "");
    }

    function test_YoWithData() public {
        bytes memory data = "gm";
        vm.expectEmit(true, true, true, true);
        emit YoEvent(address(this), bob, 0, data);
        yo.yo(bob, data);
    }

    function test_YoWithTokenTransfer() public {
        // Setup token balance and approval
        uint256 amount = 100;
        yo.setYoAmount(amount);
        deal(address(yo), alice, amount);

        vm.startPrank(alice);
        yo.approve(address(yo), amount);

        vm.expectEmit(true, true, true, true);
        emit YoEvent(alice, bob, amount, "");
        yo.yo(bob, "");
        vm.stopPrank();

        assertEq(yo.balanceOf(bob), amount);
        assertEq(yo.balanceOf(alice), 0);
    }

    function testFuzz_SetYoAmount(uint256 amount) public {
        yo.setYoAmount(amount);
        assertEq(yo.yoAmount(), amount);
    }

    function test_BatchYo() public {
        // Setup recipients and data
        address[] memory recipients = new address[](3);
        recipients[0] = makeAddr("recipient1");
        recipients[1] = makeAddr("recipient2");
        recipients[2] = makeAddr("recipient3");

        bytes[] memory datas = new bytes[](3);
        datas[0] = "gm";
        datas[1] = "wagmi";
        datas[2] = "gn";

        // Set amount and fund sender
        uint256 amount = 100;
        yo.setYoAmount(amount);
        deal(address(yo), alice, amount * 3);

        vm.startPrank(alice);
        yo.approve(address(yo), amount * 3);

        // Expect all three events
        vm.expectEmit(true, true, true, true);
        emit YoEvent(alice, recipients[0], amount, datas[0]);
        vm.expectEmit(true, true, true, true);
        emit YoEvent(alice, recipients[1], amount, datas[1]);
        vm.expectEmit(true, true, true, true);
        emit YoEvent(alice, recipients[2], amount, datas[2]);

        yo.batchYo(recipients, datas);
        vm.stopPrank();

        // Verify token transfers
        assertEq(yo.balanceOf(recipients[0]), amount);
        assertEq(yo.balanceOf(recipients[1]), amount);
        assertEq(yo.balanceOf(recipients[2]), amount);
        assertEq(yo.balanceOf(alice), 0);
    }
}
