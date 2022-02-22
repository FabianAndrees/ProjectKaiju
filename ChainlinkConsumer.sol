pragma solidity ^0.8.7;

import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./RandomNumberProvider.sol";
import "./KaijuBreeding.sol";

contract RandomNumberConsumer is VRFConsumerBase, RandomNumberProvider, Ownable {
    KaijuBreeding private _breedingContract;
    bytes32 internal keyHash;
    uint256 internal fee;
    
    constructor(address breedingContract, address vrfCoordinator, address linkToken, bytes32 khash) 
        VRFConsumerBase(vrfCoordinator, linkToken)
    {
        _breedingContract = KaijuBreeding(breedingContract);
        keyHash = khash;
        fee = 0.1 * 10 ** 18; 
    }
    
    function getRandomNumberCallback() external onlyOwner returns(uint256){
        return uint256(getRandomNumber());
    }
    
    function getRandomNumber() internal returns (bytes32 requestId) {
        require(LINK.balanceOf(address(this)) >= fee, "Not enough LINK - fill contract with faucet");
        return requestRandomness(keyHash, fee);
    }

    /**
     * Callback function used by VRF Coordinator
     */
    function fulfillRandomness(bytes32 requestId, uint256 randomness) internal override {
        _breedingContract.finishBreed(uint256(requestId), randomness);
    }

    function withdrawLink() onlyOwner external {
        LINK.transfer(owner(), LINK.balanceOf(address(this)));
    }
}
