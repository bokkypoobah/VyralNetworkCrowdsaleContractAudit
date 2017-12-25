# Vyral Network Crowdsale Contract Audit

Status: Work in progress

## Summary

Commits [1306a68](https://github.com/vyralnetwork/vyral/commit/1306a688cddba31cce19b0cb149b2f4e38aa54bb).

### Deployed Contracts

The following contracts were deployed to the Ethereum mainnet, but the source code was not verified at the addresses except for the MultiSig:

https://etherscan.io/address/0x3bbc4826daf4ac26c4365e83299db54015341512#code

* Campaign:      [0x1f204b70832b0df002ff7500e7b2fac62b5dbe33](https://etherscan.io/address/0x1f204b70832b0df002ff7500e7b2fac62b5dbe33#code)
* DateTime:      [0x3bbc4826daf4ac26c4365e83299db54015341512](https://etherscan.io/address/0x3bbc4826daf4ac26c4365e83299db54015341512#code)
* MultiSig:      [0x4e4aE4B72c960Ad91fab1e18253D16cDAc6a091c](https://etherscan.io/address/0x4e4aE4B72c960Ad91fab1e18253D16cDAc6a091c#code)
* PresaleBonuses:[0x9cd2a58a1c700c5cc13f04c4fddc215b7af89c7e](https://etherscan.io/address/0x9cd2a58a1c700c5cc13f04c4fddc215b7af89c7e#code)
* Referral:      [0x94f6ced94445ef07a0e8d5e7394c365a7b43bf62](https://etherscan.io/address/0x94f6ced94445ef07a0e8d5e7394c365a7b43bf62#code)
* SafeMath:      [0x84bfc103e575cc4f3f5b24437cccef4ee93c309b](https://etherscan.io/address/0x84bfc103e575cc4f3f5b24437cccef4ee93c309b#code)
* Share:         [0x6f69ef58ddec9cd6ee428253c607a0acd13da05f](https://etherscan.io/address/0x6f69ef58ddec9cd6ee428253c607a0acd13da05f#code)
* TieredPayoff:  [0x57efbaf2e135ad73018aed5f07273b7a0bb2ab54](https://etherscan.io/address/0x57efbaf2e135ad73018aed5f07273b7a0bb2ab54#code)
* Vesting:       [0x6dfbeaf92d8d4455d74bc56bd37a165c5970a4d7](https://etherscan.io/address/0x6dfbeaf92d8d4455d74bc56bd37a165c5970a4d7#code)
* VyralSale:     [0x708352cd28ea06e6bbd5c1a9408b4966ac1226e4](https://etherscan.io/address/0x708352cd28ea06e6bbd5c1a9408b4966ac1226e4#code)


<br />

<hr />

## Table Of Contents

<br />

<hr />

## Testing

[ethereum-datetime-contracts/api.sol](ethereum-datetime-contracts/api.sol) and [ethereum-datetime-contracts/DateTime.sol](ethereum-datetime-contracts/DateTime.sol) commit
[1c8e514](https://github.com/pipermerriam/ethereum-datetime/commit/1c8e514adc57673d367ab91af4fd86186f1ea7f4).

<br />

<hr />

## Recommendations

* **LOW IMPORTANCE** *SafeMath* could possibly use `require(...)` instead of `assert(...)` to save on gas in the case of an error
* **LOW IMPORTANCE** *Ownable* could be improved by using the `acceptOwnership(...)` [pattern](https://github.com/openanx/OpenANXToken/blob/master/contracts/Owned.sol#L51-L55)
* **LOW IMPORTANCE** *HumanStandardToken* should have a `Transfer(address(0), msg.sender, _initialAmount)` event logged in the constructor

<br />

<hr />

## Code Review

* [x] [code-review/math/SafeMath.md](code-review/math/SafeMath.md)
  * [x] library SafeMath
* [x] [code-review/traits/Ownable.md](code-review/traits/Ownable.md)
  * [x] contract Ownable
* [ ] [code-review/referral/Referral.md](code-review/referral/Referral.md)
  * [ ] library Referral
* [ ] [code-review/referral/TieredPayoff.md](code-review/referral/TieredPayoff.md)
  * [ ] library TieredPayoff
* [ ] [code-review/Campaign.md](code-review/Campaign.md)
  * [ ] contract Campaign is Ownable
* [ ] [code-review/PresaleBonuses.md](code-review/PresaleBonuses.md)
  * [ ] library PresaleBonuses
* [ ] [code-review/Share.md](code-review/Share.md)
  * [ ] contract Share is HumanStandardToken, Ownable
* [ ] [code-review/Vesting.md](code-review/Vesting.md)
  * [ ] contract Vesting is Ownable
* [ ] [code-review/VyralSale.md](code-review/VyralSale.md)
  * [ ] contract VyralSale is Ownable

<br />

### Tokens

* [x] [code-review-tokens/Token.md](code-review-tokens/Token.md)
  * [x] contract Token
* [x] [code-review-tokens/StandardToken.md](code-review-tokens/StandardToken.md)
  * [x] contract StandardToken is Token
* [x] [code-review-tokens/HumanStandardToken.md](code-review-tokens/HumanStandardToken.md)
  * [x] contract HumanStandardToken is StandardToken


<br />

### Not Reviewed

The following files are for the testing framekwork:

* [ ] [../contracts/Migrations.sol](../contracts/Migrations.sol)
  * [ ] contract Migrations
