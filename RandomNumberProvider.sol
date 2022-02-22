pragma solidity >= 0.8;

interface RandomNumberProvider{
    function getRandomNumberCallback() external returns(uint256);
}