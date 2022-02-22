pragma solidity >= 0.8;

import "./KaijuEggContract.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract KaijuICO {
    KaijuEggContract private eggContract;
    IERC20 public erc20Token;
    uint256 public costPerEgg;
    uint256 public cap;

    constructor(uint256 capacity, address token, uint256 costPerUnit, address eggCon){
        cap = capacity;
        erc20Token = IERC20(token);
        costPerEgg = costPerUnit;
        eggContract = KaijuEggContract(eggCon);
    }

    function buy() external {
        require(erc20Token.balanceOf(msg.sender) > costPerEgg);
        require(erc20Token.allowance(msg.sender, address(this)) > costPerEgg);
        bool success = erc20Token.transferFrom(msg.sender, address(this), costPerEgg);
        require(success);
        uint256 id = eggContract.tokenOfOwnerByIndex(address(this), 0);
        eggContract.safeTransferFrom(address(this), msg.sender, id);
    }

    function mintEggs() external{
        uint8 amount = uint8(cap >= 250 ? 250 : cap);
        eggContract.mintIco(amount);
    }

    function withdraw() external{
        require(eggContract.owner() == msg.sender);
        bool success = erc20Token.transfer(eggContract.owner(), erc20Token.balanceOf(address(this)));
        require(success, "Transfer failed");
    }
}