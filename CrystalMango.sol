pragma solidity >= 0.8;

import "@openzeppelin/contracts/token/ERC777/ERC777.sol";


contract CrystalMango is ERC777{
    
    constructor(address[] memory _defaultOperators) ERC777("CrystalMango", "CM", _defaultOperators){
        _mint(msg.sender, 100000000 * 10**18 , "Initial mint", "");
    }
}