pragma solidity >= 0.8;

interface BreedingCostCalculator{
    function calculateBreedingCost(address issuer, uint256 kaiju1, uint256 kaiju2) external returns(uint256 ks, uint256 cm);
    function canBreed(address issuer, uint256 kaiju1, uint256 kaiju2) external;
}