// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Ownable} from "solady/auth/Ownable.sol";
import {ERC20} from "solady/tokens/ERC20.sol";

/**
 *  ___    ___ ________
 *  |\  \  /  /|\   __  \
 *  \ \  \/  / | \  \|\  \
 *   \ \    / / \ \  \\\  \
 *    \/  /  /   \ \  \\\  \
 *  __/  / /      \ \_______\
 * |\___/ /        \|_______|
 * \|___|/
 */

contract YoToken is ERC20, Ownable {
    event YoEvent(
        address indexed from,
        address indexed to,
        uint256 indexed amount,
        bytes data
    );

    uint256 public yoAmount;
    uint256 public feeBasisPoints;

    constructor() Ownable() {
        _initializeOwner(msg.sender);
        _mint(msg.sender, 1e9 ether);
    }

    function name() public pure override returns (string memory) {
        return "Yo";
    }

    function symbol() public pure override returns (string memory) {
        return "YO";
    }

    function burn(uint256 amount) public {
        _burn(msg.sender, amount);
    }

    function yo(address to, bytes calldata data) public {
        if (yoAmount > 0) {
            uint256 fee = (yoAmount * feeBasisPoints) / 10000;
            transfer(to, yoAmount - fee);
            transfer(address(this), fee);
        }
        emit YoEvent(msg.sender, to, yoAmount, data);
    }

    function batchYo(address[] calldata tos, bytes[] calldata datas) public {
        for (uint256 i = 0; i < tos.length; i++) {
            yo(tos[i], datas[i]);
        }
    }

    function setYoAmount(uint256 _amount) public onlyOwner {
        yoAmount = _amount;
    }

    function setFeeBasisPoints(uint256 _basisPoints) public onlyOwner {
        feeBasisPoints = _basisPoints;
    }

    function withdraw() public onlyOwner {
        transfer(msg.sender, balanceOf(address(this)));
    }
}
