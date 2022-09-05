//SPDX-license-identifier: MIT
pragma solidity ^0.5.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/emission/AllowanceCrowdsale.sol";

contract Chocoico is Crowdsale, AllowanceCrowdsale {

    uint256 private minPurchase;
    uint256 private _rate;
    uint256 private decimals;

    constructor(
        uint256 rate, // 16000000
        address payable wallet,
        IERC20 token,
        address tokenWallet,  // <- new argument
        uint256 _minPurchase, // 10000000000000000
        uint256 _decimals
    )
        AllowanceCrowdsale(tokenWallet)  // <- used here
        Crowdsale(rate, wallet, token)
        public
    {
        minPurchase = _minPurchase;
        _rate = rate;
        decimals = _decimals;
    }

    function _getTokenAmount(uint256 weiAmount) internal view returns (uint256) {
        return (weiAmount.mul(_rate).div(10 ** decimals));
    }

    function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
        require(beneficiary != address(0), "Crowdsale: beneficiary is the zero address");
        require(weiAmount != 0, "Crowdsale: weiAmount is 0");
        require(weiAmount % minPurchase == 0, "Invalid Amount");
        this;
    }


}