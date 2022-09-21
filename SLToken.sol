// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract SLToken is ERC20 {

    address approvedContract;
    address owner;

    constructor() ERC20("SuperLottery Token", "SLT") {
        owner = msg.sender;
    }

    function setApprovedContract(address _approvedContract) 
    external onlyOwner {
        approvedContract = _approvedContract;
    }

    function mint(address _to, uint _numberOfTokens) external {
        require(msg.sender == approvedContract, "Not approved");
        _mint(_to, _numberOfTokens);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

}