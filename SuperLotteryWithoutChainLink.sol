// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import './SLToken.sol';

contract SuperLottery {

    bool lotteryClosed;

    SLToken SLT;

    mapping(uint => address) public winners;
    uint idLottery;

    address payable[] public players;

    address payable owner;

    constructor(SLToken _SLT) {
        SLT = _SLT;
        owner = payable(msg.sender);
    }

    function pickWinner() external onlyOwner {
        require(lotteryClosed, "Lottery is not closed");
        uint winner = uint(keccak256(abi.encodePacked(
            block.timestamp, block.difficulty, msg.sender
        ))) % players.length;

        players[winner].transfer(address(this).balance / 100 * 90);
        owner.transfer(address(this).balance);
        

        SLT.mint(players[winner], 10 * 10**18);

        winners[idLottery] = players[winner];
        idLottery++;
        
        players = new address payable[](0);
    }

    function toggleLottery() external onlyOwner {
        lotteryClosed = !lotteryClosed;
    }

    function enter() external payable {
        require(!lotteryClosed, "Lottery is closed");
        require(msg.value == 1 ether, "Not enought funds provided");
        players.push(payable(msg.sender));
    }

    function getBalance() external view returns(uint) {
        return address(this).balance;
    }

    function getWinner(uint _idLottery) external view returns(address) {
        return winners[_idLottery];
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }


}