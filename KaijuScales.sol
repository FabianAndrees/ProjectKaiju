pragma solidity >= 0.8;

import "@openzeppelin/contracts/token/ERC777/ERC777.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract KaijuScales is ERC777, Ownable {
    event SentToServer(address user, uint256 amount);
    constructor(address[] memory _defaultOperators) ERC777("Kaiju Scales", "KS", _defaultOperators){
    }

    function mint(address user, uint256 amount) external onlyOwner{
        _mint(user, amount, "transferred from the game", "");
    }

    function sendToGame(uint256 amount) external{
        require(balanceOf(msg.sender) >= amount, "Not enought Kaiju Scales");
        burn(amount, "burned to use on server");
        emit SentToServer(msg.sender, amount);
    }
}