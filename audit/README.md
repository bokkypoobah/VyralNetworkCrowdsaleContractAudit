# Vyral Network Crowdsale Contract Audit

Status: Work in progress

## Summary

Commits [1306a68](https://github.com/vyralnetwork/vyral/commit/1306a688cddba31cce19b0cb149b2f4e38aa54bb).

<br />

<hr />

## Table Of Contents

<br />

<hr />

## Recommendations

* **LOW IMPORTANCE** *SafeMath* could use `require(...)` instead of `assert(...)` to save on gas in the case of an error
* **LOW IMPORTANCE** *Ownable* could be improved by using the `acceptOwnership(...)` [pattern](https://github.com/openanx/OpenANXToken/blob/master/contracts/Owned.sol#L51-L55)

<br />

<hr />

## Code Review

* [ ] [code-review/math/SafeMath.md](code-review/math/SafeMath.md)
  * [ ] library SafeMath
* [ ] [code-review/referral/Referral.md](code-review/referral/Referral.md)
  * [ ] library Referral
* [ ] [code-review/referral/TieredPayoff.md](code-review/referral/TieredPayoff.md)
  * [ ] library TieredPayoff
* [ ] [code-review/traits/Ownable.md](code-review/traits/Ownable.md)
  * [ ] contract Ownable
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

### Not Reviewed

The following files are for the testing framekwork:

* [ ] [../contracts/Migrations.sol](../contracts/Migrations.sol)
  * [ ] contract Migrations
