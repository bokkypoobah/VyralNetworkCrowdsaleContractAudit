#!/bin/bash
# ----------------------------------------------------------------------------------------------
# Testing the smart contract
#
# Enjoy. (c) BokkyPooBah / Bok Consulting Pty Ltd 2017. The MIT Licence.
# ----------------------------------------------------------------------------------------------

MODE=${1:-test}

GETHATTACHPOINT=`grep ^IPCFILE= settings.txt | sed "s/^.*=//"`
PASSWORD=`grep ^PASSWORD= settings.txt | sed "s/^.*=//"`

SOURCEDIR=`grep ^SOURCEDIR= settings.txt | sed "s/^.*=//"`

CAMPAIGNSOL=`grep ^CAMPAIGNSOL= settings.txt | sed "s/^.*=//"`
CAMPAIGNJS=`grep ^CAMPAIGNJS= settings.txt | sed "s/^.*=//"`
DATETIMESOL=`grep ^DATETIMESOL= settings.txt | sed "s/^.*=//"`
DATETIMEJS=`grep ^DATETIMEJS= settings.txt | sed "s/^.*=//"`
PRESALEBONUSESSOL=`grep ^PRESALEBONUSESSOL= settings.txt | sed "s/^.*=//"`
PRESALEBONUSESJS=`grep ^PRESALEBONUSESJS= settings.txt | sed "s/^.*=//"`
REFERRALSOL=`grep ^REFERRALSOL= settings.txt | sed "s/^.*=//"`
REFERRALJS=`grep ^REFERRALJS= settings.txt | sed "s/^.*=//"`
SAFEMATHSOL=`grep ^SAFEMATHSOL= settings.txt | sed "s/^.*=//"`
SAFEMATHJS=`grep ^SAFEMATHJS= settings.txt | sed "s/^.*=//"`
SHARESOL=`grep ^SHARESOL= settings.txt | sed "s/^.*=//"`
SHAREJS=`grep ^SHAREJS= settings.txt | sed "s/^.*=//"`
TIEREDPAYOFFSOL=`grep ^TIEREDPAYOFFSOL= settings.txt | sed "s/^.*=//"`
TIEREDPAYOFFJS=`grep ^TIEREDPAYOFFJS= settings.txt | sed "s/^.*=//"`
VESTINGSOL=`grep ^VESTINGSOL= settings.txt | sed "s/^.*=//"`
VESTINGJS=`grep ^VESTINGJS= settings.txt | sed "s/^.*=//"`
VYRALSALESOL=`grep ^VYRALSALESOL= settings.txt | sed "s/^.*=//"`
VYRALSALEJS=`grep ^VYRALSALEJS= settings.txt | sed "s/^.*=//"`

DEPLOYMENTDATA=`grep ^DEPLOYMENTDATA= settings.txt | sed "s/^.*=//"`

INCLUDEJS=`grep ^INCLUDEJS= settings.txt | sed "s/^.*=//"`
TEST1OUTPUT=`grep ^TEST1OUTPUT= settings.txt | sed "s/^.*=//"`
TEST1RESULTS=`grep ^TEST1RESULTS= settings.txt | sed "s/^.*=//"`

CURRENTTIME=`date +%s`
CURRENTTIMES=`date -r $CURRENTTIME -u`

START_DATE=`echo "$CURRENTTIME+90" | bc`
START_DATE_S=`date -r $START_DATE -u`
END_DATE=`echo "$CURRENTTIME+150" | bc`
END_DATE_S=`date -r $END_DATE -u`

printf "MODE               = '$MODE'\n" | tee $TEST1OUTPUT
printf "GETHATTACHPOINT    = '$GETHATTACHPOINT'\n" | tee -a $TEST1OUTPUT
printf "PASSWORD           = '$PASSWORD'\n" | tee -a $TEST1OUTPUT
printf "SOURCEDIR          = '$SOURCEDIR'\n" | tee -a $TEST1OUTPUT
printf "CAMPAIGNSOL        = '$CAMPAIGNSOL'\n" | tee -a $TEST1OUTPUT
printf "CAMPAIGNJS         = '$CAMPAIGNJS'\n" | tee -a $TEST1OUTPUT
printf "DATETIMESOL        = '$DATETIMESOL'\n" | tee -a $TEST1OUTPUT
printf "DATETIMEJS         = '$DATETIMEJS'\n" | tee -a $TEST1OUTPUT
printf "PRESALEBONUSESSOL  = '$PRESALEBONUSESSOL'\n" | tee -a $TEST1OUTPUT
printf "PRESALEBONUSESJS   = '$PRESALEBONUSESJS'\n" | tee -a $TEST1OUTPUT
printf "REFERRALSOL        = '$REFERRALSOL'\n" | tee -a $TEST1OUTPUT
printf "REFERRALJS         = '$REFERRALJS'\n" | tee -a $TEST1OUTPUT
printf "SAFEMATHSOL        = '$SAFEMATHSOL'\n" | tee -a $TEST1OUTPUT
printf "SAFEMATHJS         = '$SAFEMATHJS'\n" | tee -a $TEST1OUTPUT
printf "SHARESOL           = '$SHARESOL'\n" | tee -a $TEST1OUTPUT
printf "SHAREJS            = '$SHAREJS'\n" | tee -a $TEST1OUTPUT
printf "TIEREDPAYOFFSOL    = '$TIEREDPAYOFFSOL'\n" | tee -a $TEST1OUTPUT
printf "TIEREDPAYOFFJS     = '$TIEREDPAYOFFJS'\n" | tee -a $TEST1OUTPUT
printf "VESTINGSOL         = '$VESTINGSOL'\n" | tee -a $TEST1OUTPUT
printf "VESTINGJS          = '$VESTINGJS'\n" | tee -a $TEST1OUTPUT
printf "VYRALSALESOL       = '$VYRALSALESOL'\n" | tee -a $TEST1OUTPUT
printf "VYRALSALEJS        = '$VYRALSALEJS'\n" | tee -a $TEST1OUTPUT
printf "DEPLOYMENTDATA     = '$DEPLOYMENTDATA'\n" | tee -a $TEST1OUTPUT
printf "INCLUDEJS          = '$INCLUDEJS'\n" | tee -a $TEST1OUTPUT
printf "TEST1OUTPUT        = '$TEST1OUTPUT'\n" | tee -a $TEST1OUTPUT
printf "TEST1RESULTS       = '$TEST1RESULTS'\n" | tee -a $TEST1OUTPUT
printf "CURRENTTIME        = '$CURRENTTIME' '$CURRENTTIMES'\n" | tee -a $TEST1OUTPUT
printf "START_DATE         = '$START_DATE' '$START_DATE_S'\n" | tee -a $TEST1OUTPUT
printf "END_DATE           = '$END_DATE' '$END_DATE_S'\n" | tee -a $TEST1OUTPUT

# Make copy of SOL file and modify start and end times ---
# `cp modifiedContracts/SnipCoin.sol .`
`cp -rp $SOURCEDIR/* .`
`cp -rp ../ethereum-datetime-contracts/* .`
`cp -rp ../../installed_contracts/tokens/contracts/HumanStandardToken.sol .`
`cp -rp ../../installed_contracts/tokens/contracts/StandardToken.sol .`
`cp -rp ../../installed_contracts/tokens/contracts/Token.sol .`

# --- Modify parameters ---

`perl -pi -e "s/installed_contracts\/tokens\/contracts\//\.\//" *.sol`
`perl -pi -e "s/\.\.\/lib\/ethereum-datetime\/contracts\//\.\//" *.sol`
`perl -pi -e "s/contracts\/math\//math\//" *.sol`
`perl -pi -e "s/contracts\/traits\//traits\//" *.sol`

#`perl -pi -e "s/zeppelin-solidity\/contracts\///" *.sol`
#`perl -pi -e "s/saleStartDate \= 1510416000;.*$/saleStartDate \= $START_DATE; \/\/ $START_DATE_S/" $CROWDSALESOL`
#`perl -pi -e "s/saleEndDate \= 1513008000;.*$/saleEndDate \= $END_DATE; \/\/ $END_DATE_S/" $CROWDSALESOL`
#`perl -pi -e "s/uint256 etherRateUsd/uint256 public etherRateUsd/" $CROWDSALESOL`
#`perl -pi -e "s/uint256 hourLimitByAddressUsd/uint256 public hourLimitByAddressUsd/" $CROWDSALESOL`
#`perl -pi -e "s/getCurrentState\(\) internal returns/getCurrentState\(\) public returns/" $CROWDSALESOL`
#`perl -pi -e "s/weiToBuy \= min\(weiToBuy\, getWeiAllowedFromAddress\(recipient\)\);/\/\/ weiToBuy \= min\(weiToBuy\, getWeiAllowedFromAddress\(recipient\)\);/" $CROWDSALESOL`
#`perl -pi -e "s/getOwners\(\) public returns/getOwners\(\) public constant returns/" MultiOwnable.sol`
#`perl -pi -e "s/address\[\] owners;/address\[\] public owners;/" MultiOwnable.sol`
#`perl -pi -e "s/address multiOwnableCreator \= 0x0;/address public multiOwnableCreator \= 0x0;/" MultiOwnable.sol`


#for FILE in Ballot.sol EthearnalRepTokenCrowdsale.sol LockableToken.sol MultiOwnable.sol Treasury.sol EthearnalRepToken.sol IBallot.sol RefundInvestorsBallot.sol VotingProxy.sol
#do
  #  DIFFS1=`diff $SOURCEDIR/$FILE $FILE`
  #echo "--- Differences $SOURCEDIR/$FILE $FILE ---" | tee -a $TEST1OUTPUT
  #echo "$DIFFS1" | tee -a $TEST1OUTPUT
#done

solc_0.4.18 --version | tee -a $TEST1OUTPUT

echo "Compiling ---------- $CAMPAIGNSOL ----------"
echo "var campaignOutput=`solc_0.4.18 --optimize --pretty-json --combined-json abi,bin,interface $CAMPAIGNSOL`;" > $CAMPAIGNJS
echo "Compiling ---------- $DATETIMESOL ----------"
echo "var dateTimeOutput=`solc_0.4.18 --optimize --pretty-json --combined-json abi,bin,interface $DATETIMESOL`;" > $DATETIMEJS
echo "Compiling ---------- $PRESALEBONUSESSOL ----------"
echo "var presaleBonusesOutput=`solc_0.4.18 --optimize --pretty-json --combined-json abi,bin,interface $PRESALEBONUSESSOL`;" > $PRESALEBONUSESJS
echo "Compiling ---------- referral/$REFERRALSOL ----------"
echo "var referralOutput=`solc_0.4.18 --optimize --pretty-json --combined-json abi,bin,interface referral/$REFERRALSOL`;" > $REFERRALJS
echo "Compiling ---------- $SAFEMATHSOL ----------"
echo "var safeMathOutput=`solc_0.4.18 --optimize --pretty-json --combined-json abi,bin,interface math/$SAFEMATHSOL`;" > $SAFEMATHJS
echo "Compiling ---------- $SHARESOL ----------"
echo "var shareOutput=`solc_0.4.18 --optimize --pretty-json --combined-json abi,bin,interface $SHARESOL`;" > $SHAREJS
echo "Compiling ---------- referral/$TIEREDPAYOFFSOL ----------"
echo "var tieredPayoffOutput=`solc_0.4.18 --allow-paths . --optimize --pretty-json --combined-json abi,bin,interface referral/$TIEREDPAYOFFSOL`;" > $TIEREDPAYOFFJS
echo "Compiling ---------- $VESTINGSOL ----------"
echo "var vestingOutput=`solc_0.4.18 --optimize --pretty-json --combined-json abi,bin,interface $VESTINGSOL`;" > $VESTINGJS
echo "Compiling ---------- $VYRALSALESOL ----------"
echo "var vyralSaleOutput=`solc_0.4.18 --optimize --pretty-json --combined-json abi,bin,interface $VYRALSALESOL`;" > $VYRALSALEJS

exit;

echo "var tokenOutput=`solc_0.4.18 --optimize --pretty-json --combined-json abi,bin,interface $TOKENSOL`;" > $TOKENJS
echo "var treasuryOutput=`solc_0.4.18 --optimize --pretty-json --combined-json abi,bin,interface $TREASURYSOL`;" > $TREASURYJS
echo "var votingProxyOutput=`solc_0.4.18 --optimize --pretty-json --combined-json abi,bin,interface $VOTINGPROXYSOL`;" > $VOTINGPROXYJS
echo "var crowdsaleOutput=`solc_0.4.18 --optimize --pretty-json --combined-json abi,bin,interface $CROWDSALESOL`;" > $CROWDSALEJS



geth --verbosity 3 attach $GETHATTACHPOINT << EOF | tee -a $TEST1OUTPUT
loadScript("$TOKENJS");
loadScript("$TREASURYJS");
loadScript("$VOTINGPROXYJS");
loadScript("$CROWDSALEJS");
loadScript("functions.js");

var tokenAbi = JSON.parse(tokenOutput.contracts["$TOKENSOL:EthearnalRepToken"].abi);
var tokenBin = "0x" + tokenOutput.contracts["$TOKENSOL:EthearnalRepToken"].bin;
var treasuryAbi = JSON.parse(treasuryOutput.contracts["$TREASURYSOL:Treasury"].abi);
var treasuryBin = "0x" + treasuryOutput.contracts["$TREASURYSOL:Treasury"].bin;
var votingProxyAbi = JSON.parse(votingProxyOutput.contracts["$VOTINGPROXYSOL:VotingProxy"].abi);
var votingProxyBin = "0x" + votingProxyOutput.contracts["$VOTINGPROXYSOL:VotingProxy"].bin;
var crowdsaleAbi = JSON.parse(crowdsaleOutput.contracts["$CROWDSALESOL:EthearnalRepTokenCrowdsale"].abi);
var crowdsaleBin = "0x" + crowdsaleOutput.contracts["$CROWDSALESOL:EthearnalRepTokenCrowdsale"].bin;
var refundInvestorsBallotAbi = JSON.parse(votingProxyOutput.contracts["RefundInvestorsBallot.sol:RefundInvestorsBallot"].abi);

// console.log("DATA: tokenAbi=" + JSON.stringify(tokenAbi));
// console.log("DATA: tokenBin=" + JSON.stringify(tokenBin));
// console.log("DATA: treasuryAbi=" + JSON.stringify(treasuryAbi));
// console.log("DATA: treasuryBin=" + JSON.stringify(treasuryBin));
// console.log("DATA: votingProxyAbi=" + JSON.stringify(votingProxyAbi));
// console.log("DATA: votingProxyBin=" + JSON.stringify(votingProxyBin));
// console.log("DATA: crowdsaleAbi=" + JSON.stringify(crowdsaleAbi));
// console.log("DATA: crowdsaleBin=" + JSON.stringify(crowdsaleBin));
// console.log("DATA: refundInvestorsBallotAbi=" + JSON.stringify(refundInvestorsBallotAbi));

unlockAccounts("$PASSWORD");
printBalances();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var tokenMessage = "Deploy Token Contract";
// -----------------------------------------------------------------------------
console.log("RESULT: --- " + tokenMessage + " ---");
var tokenContract = web3.eth.contract(tokenAbi);
// console.log(JSON.stringify(tokenContract));
var tokenTx = null;
var tokenAddress = null;
var token = tokenContract.new({from: contractOwnerAccount, data: tokenBin, gas: 6000000, gasPrice: defaultGasPrice},
  function(e, contract) {
    if (!e) {
      if (!contract.address) {
        tokenTx = contract.transactionHash;
      } else {
        tokenAddress = contract.address;
        addAccount(tokenAddress, "Token '" + token.symbol() + "' '" + token.name() + "'");
        addTokenContractAddressAndAbi(tokenAddress, tokenAbi);
        console.log("DATA: tokenAddress=" + tokenAddress);
      }
    }
  }
);
while (txpool.status.pending > 0) {
}
printBalances();
failIfTxStatusError(tokenTx, tokenMessage);
printTxData("tokenAddress=" + tokenAddress, tokenTx);
printTokenContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var treasuryMessage = "Deploy Treasury Contract";
// -----------------------------------------------------------------------------
console.log("RESULT: --- " + treasuryMessage + " ---");
var treasuryContract = web3.eth.contract(treasuryAbi);
// console.log(JSON.stringify(treasuryContract));
var treasuryTx = null;
var treasuryAddress = null;
var treasury = treasuryContract.new(teamWallet, {from: contractOwnerAccount, data: treasuryBin, gas: 6000000, gasPrice: defaultGasPrice},
  function(e, contract) {
    if (!e) {
      if (!contract.address) {
        treasuryTx = contract.transactionHash;
      } else {
        treasuryAddress = contract.address;
        addAccount(treasuryAddress, "Treasury");
        addTreasuryContractAddressAndAbi(treasuryAddress, treasuryAbi);
        console.log("DATA: treasuryAddress=" + treasuryAddress);
      }
    }
  }
);
while (txpool.status.pending > 0) {
}
printBalances();
failIfTxStatusError(treasuryTx, treasuryMessage);
printTxData("treasuryAddress=" + treasuryAddress, treasuryTx);
printTreasuryContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var votingProxyMessage = "Deploy Voting Proxy Contract";
// -----------------------------------------------------------------------------
console.log("RESULT: --- " + votingProxyMessage + " ---");
var votingProxyContract = web3.eth.contract(votingProxyAbi);
// console.log(JSON.stringify(votingProxyContract));
var votingProxyTx = null;
var votingProxyAddress = null;
var votingProxy = votingProxyContract.new(treasuryAddress, tokenAddress, {from: contractOwnerAccount, data: votingProxyBin, gas: 6000000, gasPrice: defaultGasPrice},
  function(e, contract) {
    if (!e) {
      if (!contract.address) {
        votingProxyTx = contract.transactionHash;
      } else {
        votingProxyAddress = contract.address;
        addAccount(votingProxyAddress, "VotingProxy");
        addVotingProxyContractAddressAndAbi(votingProxyAddress, votingProxyAbi);
        console.log("DATA: votingProxyAddress=" + votingProxyAddress);
      }
    }
  }
);
while (txpool.status.pending > 0) {
}
printBalances();
printTxData("votingProxyAddress=" + votingProxyAddress, votingProxyTx);
failIfTxStatusError(votingProxyTx, votingProxyMessage);
printVotingProxyContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var setup1_Message = "Setup #1";
// -----------------------------------------------------------------------------
console.log("RESULT: --- " + setup1_Message + " ---");
var setup1_1Tx = treasury.setupOwners([owner1, owner2], {from: contractOwnerAccount, gas: 400000, gasPrice: defaultGasPrice});
while (txpool.status.pending > 0) {
}
var setup1_2Tx = treasury.setTokenContract(tokenAddress, {from: owner1, gas: 400000, gasPrice: defaultGasPrice});
var setup1_3Tx = treasury.setVotingProxy(votingProxyAddress, {from: owner2, gas: 400000, gasPrice: defaultGasPrice});
while (txpool.status.pending > 0) {
}
printBalances();
failIfTxStatusError(setup1_1Tx, setup1_Message + " - treasury.setupOwners([owner1, owner2])");
failIfTxStatusError(setup1_2Tx, setup1_Message + " - treasury.setTokenContract(token)");
failIfTxStatusError(setup1_3Tx, setup1_Message + " - treasury.setVotingProxy(votingProxy)");
printTxData("setup1_1Tx", setup1_1Tx);
printTxData("setup1_2Tx", setup1_2Tx);
printTxData("setup1_3Tx", setup1_3Tx);
printTreasuryContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var crowdsaleMessage = "Deploy Crowdsale Contract";
// -----------------------------------------------------------------------------
console.log("RESULT: --- " + crowdsaleMessage + " ---");
var crowdsaleContract = web3.eth.contract(crowdsaleAbi);
// console.log(JSON.stringify(crowdsaleContract));
var crowdsaleTx = null;
var crowdsaleAddress = null;
var crowdsale = crowdsaleContract.new([owner1, owner2], treasuryAddress, teamWallet, {from: contractOwnerAccount, data: crowdsaleBin, gas: 6000000, gasPrice: defaultGasPrice},
  function(e, contract) {
    if (!e) {
      if (!contract.address) {
        crowdsaleTx = contract.transactionHash;
      } else {
        crowdsaleAddress = contract.address;
        addAccount(crowdsaleAddress, "Crowdsale");
        addCrowdsaleContractAddressAndAbi(crowdsaleAddress, crowdsaleAbi);
        console.log("DATA: crowdsaleAddress=" + crowdsaleAddress);
      }
    }
  }
);
while (txpool.status.pending > 0) {
}
printBalances();
failIfTxStatusError(crowdsaleTx, crowdsaleMessage);
printTxData("crowdsaleAddress=" + crowdsaleAddress, crowdsaleTx);
printCrowdsaleContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var setup2_Message = "Setup #2";
// -----------------------------------------------------------------------------
console.log("RESULT: --- " + setup2_Message + " ---");
var setup2_1Tx = treasury.setCrowdsaleContract(crowdsaleAddress, {from: owner1, gas: 400000, gasPrice: defaultGasPrice});
var setup2_2Tx = token.transferOwnership(crowdsaleAddress, {from: contractOwnerAccount, gas: 400000, gasPrice: defaultGasPrice});
while (txpool.status.pending > 0) {
}
var setup2_3Tx = crowdsale.setTokenContract(tokenAddress, {from: owner1, gas: 400000, gasPrice: defaultGasPrice});
while (txpool.status.pending > 0) {
}
printBalances();
failIfTxStatusError(setup2_1Tx, setup2_Message + " - treasury.setCrowdsaleContract(crowdsale)");
failIfTxStatusError(setup2_2Tx, setup2_Message + " - token.transferOwnership(crowdsale)");
failIfTxStatusError(setup2_3Tx, setup2_Message + " - crowdsale.setTokenContract(token)");
printTxData("setup2_1Tx", setup2_1Tx);
printTxData("setup2_2Tx", setup2_2Tx);
printTxData("setup2_3Tx", setup2_3Tx);
printCrowdsaleContractDetails();
printTreasuryContractDetails();
printTokenContractDetails();
console.log("RESULT: ");


waitUntil("crowdsale.saleStartDate()", crowdsale.saleStartDate(), 0);


// -----------------------------------------------------------------------------
var sendContribution1Message = "Send Contribution #1";
// -----------------------------------------------------------------------------
console.log("RESULT: " + sendContribution1Message);
var sendContribution1_1Tx = eth.sendTransaction({from: account3, to: crowdsaleAddress, gas: 400000, value: web3.toWei("25000", "ether")});
var sendContribution1_2Tx = eth.sendTransaction({from: account4, to: crowdsaleAddress, gas: 400000, value: web3.toWei("25000", "ether")});
var sendContribution1_3Tx = eth.sendTransaction({from: account5, to: crowdsaleAddress, gas: 400000, value: web3.toWei("25000", "ether")});
var sendContribution1_4Tx = eth.sendTransaction({from: account6, to: crowdsaleAddress, gas: 400000, value: web3.toWei("25001", "ether")});
while (txpool.status.pending > 0) {
}
printBalances();
printTxData("sendContribution1_1Tx", sendContribution1_1Tx);
printTxData("sendContribution1_2Tx", sendContribution1_2Tx);
printTxData("sendContribution1_3Tx", sendContribution1_3Tx);
printTxData("sendContribution1_4Tx", sendContribution1_4Tx);
failIfTxStatusError(sendContribution1_1Tx, sendContribution1Message + " - ac3 25000 ETH");
failIfTxStatusError(sendContribution1_2Tx, sendContribution1Message + " - ac4 25000 ETH");
failIfTxStatusError(sendContribution1_3Tx, sendContribution1Message + " - ac5 25000 ETH");
failIfTxStatusError(sendContribution1_4Tx, sendContribution1Message + " - ac5 25001 ETH");
printCrowdsaleContractDetails();
printTreasuryContractDetails();
printTokenContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var finalise_Message = "Finalise";
// -----------------------------------------------------------------------------
console.log("RESULT: --- " + finalise_Message + " ---");
var finalise_1Tx = crowdsale.finalizeByAdmin({from: owner1, gas: 1000000, gasPrice: defaultGasPrice});
while (txpool.status.pending > 0) {
}
printBalances();
failIfTxStatusError(finalise_1Tx, finalise_Message + " - crowdsale.finalize()");
printTxData("finalise_1Tx", finalise_1Tx);
printCrowdsaleContractDetails();
printTreasuryContractDetails();
printTokenContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var withdrawTeamFunds_Message = "Withdraw Refunds";
// -----------------------------------------------------------------------------
console.log("RESULT: --- " + withdrawTeamFunds_Message + " ---");
var withdrawTeamFunds_1Tx = treasury.withdrawTeamFunds({from: owner1, gas: 1000000, gasPrice: defaultGasPrice});
while (txpool.status.pending > 0) {
}
printBalances();
failIfTxStatusError(withdrawTeamFunds_1Tx, withdrawTeamFunds_Message + " - treasury.withdrawTeamFunds()");
printTxData("withdrawTeamFunds_1Tx", withdrawTeamFunds_1Tx);
printCrowdsaleContractDetails();
printTreasuryContractDetails();
printTokenContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var refundVote_Message = "Refund Vote";
// -----------------------------------------------------------------------------
console.log("RESULT: --- " + refundVote_Message + " ---");
var refundVote_1Tx = votingProxy.startRefundInvestorsBallot({from: owner1, gas: 1000000, gasPrice: defaultGasPrice});
while (txpool.status.pending > 0) {
}
var refundInvestorsBallot = eth.contract(refundInvestorsBallotAbi).at(votingProxy.currentRefundInvestorsBallot());
var refundVote_2Tx = refundInvestorsBallot.vote("yes", {from: account3, gas: 1000000, gasPrice: defaultGasPrice});
var refundVote_3Tx = refundInvestorsBallot.vote("yes", {from: account4, gas: 1000000, gasPrice: defaultGasPrice});
var refundVote_4Tx = refundInvestorsBallot.vote("yes", {from: account5, gas: 1000000, gasPrice: defaultGasPrice});
 while (txpool.status.pending > 0) {
}
var refundVote_5Tx = refundInvestorsBallot.vote("yes", {from: account6, gas: 1000000, gasPrice: defaultGasPrice});
while (txpool.status.pending > 0) {
}
printBalances();
failIfTxStatusError(refundVote_1Tx, refundVote_Message + " - votingProxy.startRefundInvestorsBallot()");
failIfTxStatusError(refundVote_2Tx, refundVote_Message + " - refundInvestorsBallot.vote(yes) ac3");
failIfTxStatusError(refundVote_3Tx, refundVote_Message + " - refundInvestorsBallot.vote(yes) ac4");
failIfTxStatusError(refundVote_4Tx, refundVote_Message + " - refundInvestorsBallot.vote(yes) ac5");
passIfTxStatusError(refundVote_5Tx, refundVote_Message + " - refundInvestorsBallot.vote(yes) ac6. Expecting failure as vote closed");
printTxData("refundVote_1Tx", refundVote_1Tx);
printTxData("refundVote_2Tx", refundVote_2Tx);
printTxData("refundVote_3Tx", refundVote_3Tx);
printTxData("refundVote_4Tx", refundVote_4Tx);
printTxData("refundVote_5Tx", refundVote_5Tx);
printCrowdsaleContractDetails();
printTreasuryContractDetails();
printTokenContractDetails();
printVotingProxyContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var refundInvestor_Message = "Withdraw Team Funds";
// -----------------------------------------------------------------------------
console.log("RESULT: --- " + refundInvestor_Message + " ---");
var refundInvestor_1Tx = token.approve(treasuryAddress, "30000000000000000000", {from: account3, gas: 100000});
while (txpool.status.pending > 0) {
}
var refundInvestor_2Tx = treasury.refundInvestor("30000000000000000000", {from: account3, gas: 1000000, gasPrice: defaultGasPrice});
while (txpool.status.pending > 0) {
}
printBalances();
failIfTxStatusError(refundInvestor_1Tx, refundInvestor_Message + " - token.approve(treasuryAddress, 30) by account3");
failIfTxStatusError(refundInvestor_2Tx, refundInvestor_Message + " - treasury.refundInvestor() by account3");
printTxData("refundInvestor_1Tx", refundInvestor_1Tx);
printTxData("refundInvestor_2Tx", refundInvestor_2Tx);
printCrowdsaleContractDetails();
printTreasuryContractDetails();
printTokenContractDetails();
printVotingProxyContractDetails();
console.log("RESULT: ");


exit;

// -----------------------------------------------------------------------------
var deployLibraryMessage = "Deploy SafeMath Library";
// -----------------------------------------------------------------------------
console.log("RESULT: " + deployLibraryMessage);
var libContract = web3.eth.contract(libAbi);
var libTx = null;
var libAddress = null;
var lib = libContract.new({from: contractOwnerAccount, data: libBin, gas: 6000000, gasPrice: defaultGasPrice},
  function(e, contract) {
    if (!e) {
      if (!contract.address) {
        libTx = contract.transactionHash;
      } else {
        libAddress = contract.address;
        addAccount(libAddress, "Lib SafeMath");
        console.log("DATA: libAddress=" + libAddress);
      }
    }
  }
);
while (txpool.status.pending > 0) {
}
printBalances();
printTxData("libAddress=" + libAddress, libTx);
failIfTxStatusError(libTx, deployLibraryMessage);
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var tokenMessage = "Deploy Crowdsale/Token Contract";
// -----------------------------------------------------------------------------
console.log("RESULT: " + tokenMessage);
// console.log("RESULT: old='" + tokenBin + "'");
var newTokenBin = tokenBin.replace(/__GizerTokenPresale\.sol\:SafeMath________/g, libAddress.substring(2, 42));
// console.log("RESULT: new='" + newTokenBin + "'");
var tokenContract = web3.eth.contract(tokenAbi);
// console.log(JSON.stringify(tokenContract));
var tokenTx = null;
var tokenAddress = null;
var token = tokenContract.new({from: contractOwnerAccount, data: newTokenBin, gas: 6000000, gasPrice: defaultGasPrice},
  function(e, contract) {
    if (!e) {
      if (!contract.address) {
        tokenTx = contract.transactionHash;
      } else {
        tokenAddress = contract.address;
        addAccount(tokenAddress, "Token '" + token.symbol() + "' '" + token.name() + "'");
        addTokenContractAddressAndAbi(tokenAddress, tokenAbi);
        console.log("DATA: tokenAddress=" + tokenAddress);
      }
    }
  }
);
while (txpool.status.pending > 0) {
}
printBalances();
printTxData("tokenAddress=" + tokenAddress, tokenTx);
failIfTxStatusError(tokenTx, tokenMessage);
printTokenContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var setupMessage = "Setup";
// -----------------------------------------------------------------------------
console.log("RESULT: " + setupMessage);
var setup1Tx = token.setWallet(wallet, {from: contractOwnerAccount, gas: 400000, gasPrice: defaultGasPrice});
var setup2Tx = token.setRedemptionWallet(redemptionWallet, {from: contractOwnerAccount, gas: 400000, gasPrice: defaultGasPrice});
while (txpool.status.pending > 0) {
}
printBalances();
printTxData("setup1Tx", setup1Tx);
printTxData("setup2Tx", setup2Tx);
failIfTxStatusError(setup1Tx, setupMessage + " - setWallet(...)");
failIfTxStatusError(setup2Tx, setupMessage + " - setRedemptionWallet(...)");
printTokenContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var sendPrivateSaleContrib1Message = "Send Private Sale Contribution";
// -----------------------------------------------------------------------------
console.log("RESULT: " + sendPrivateSaleContrib1Message);
var sendPrivateSaleContrib1_1Tx = token.privateSaleContribution(account3, web3.toWei("100", "ether"), {from: contractOwnerAccount, gas: 400000, gasPrice: defaultGasPrice});
var sendPrivateSaleContrib1_2Tx = token.privateSaleContribution(account4, web3.toWei("200", "ether"), {from: contractOwnerAccount, gas: 400000, gasPrice: defaultGasPrice});
while (txpool.status.pending > 0) {
}
printBalances();
printTxData("sendPrivateSaleContrib1_1Tx", sendPrivateSaleContrib1_1Tx);
printTxData("sendPrivateSaleContrib1_2Tx", sendPrivateSaleContrib1_2Tx);
failIfTxStatusError(sendPrivateSaleContrib1_1Tx, sendPrivateSaleContrib1Message + " - ac3 100 ETH");
failIfTxStatusError(sendPrivateSaleContrib1_2Tx, sendPrivateSaleContrib1Message + " - ac4 200 ETH");
printTokenContractDetails();
console.log("RESULT: ");


waitUntil("DATE_PRESALE_START", token.DATE_PRESALE_START(), 0);


// -----------------------------------------------------------------------------
var sendContribution1Message = "Send Contribution In Presale";
// -----------------------------------------------------------------------------
console.log("RESULT: " + sendContribution1Message);
var sendContribution1_1Tx = eth.sendTransaction({from: account3, to: tokenAddress, gas: 400000, value: web3.toWei("100", "ether")});
var sendContribution1_2Tx = eth.sendTransaction({from: account4, to: tokenAddress, gas: 400000, value: web3.toWei("100", "ether")});
var sendContribution1_3Tx = eth.sendTransaction({from: account5, to: tokenAddress, gas: 400000, value: web3.toWei("100", "ether")});
var sendContribution1_4Tx = eth.sendTransaction({from: account6, to: tokenAddress, gas: 400000, value: web3.toWei("100.01", "ether")});
while (txpool.status.pending > 0) {
}
printBalances();
printTxData("sendContribution1_1Tx", sendContribution1_1Tx);
printTxData("sendContribution1_2Tx", sendContribution1_2Tx);
printTxData("sendContribution1_3Tx", sendContribution1_3Tx);
printTxData("sendContribution1_4Tx", sendContribution1_4Tx);
failIfTxStatusError(sendContribution1_1Tx, sendContribution1Message + " - ac3 100 ETH");
failIfTxStatusError(sendContribution1_2Tx, sendContribution1Message + " - ac4 100 ETH");
failIfTxStatusError(sendContribution1_3Tx, sendContribution1Message + " - ac5 100 ETH");
passIfTxStatusError(sendContribution1_4Tx, sendContribution1Message + " - ac5 100.01 ETH - Expecting failure as over the contrib limit");
printTokenContractDetails();
console.log("RESULT: ");


waitUntil("DATE_PRESALE_END", token.DATE_PRESALE_END(), 0);


// -----------------------------------------------------------------------------
var sendContribution1Message = "Send Contribution After Presale";
// -----------------------------------------------------------------------------
console.log("RESULT: " + sendContribution1Message);
var sendContribution1_1Tx = eth.sendTransaction({from: account3, to: tokenAddress, gas: 400000, value: web3.toWei("1", "ether")});
while (txpool.status.pending > 0) {
}
printBalances();
printTxData("sendContribution1_1Tx", sendContribution1_1Tx);
passIfTxStatusError(sendContribution1_1Tx, sendContribution1Message + " - ac3 1 ETH - Expecting failure as sale over");
printTokenContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var moveToken1_Message = "Move Tokens After Presale - To Redemption Wallet";
// -----------------------------------------------------------------------------
console.log("RESULT: " + moveToken1_Message);
var moveToken1_1Tx = token.transfer(redemptionWallet, "1000000", {from: account3, gas: 100000});
var moveToken1_2Tx = token.approve(account6,  "30000000", {from: account4, gas: 100000});
while (txpool.status.pending > 0) {
}
var moveToken1_3Tx = token.transferFrom(account4, redemptionWallet, "30000000", {from: account6, gas: 100000});
while (txpool.status.pending > 0) {
}
printBalances();
printTxData("moveToken1_1Tx", moveToken1_1Tx);
printTxData("moveToken1_2Tx", moveToken1_2Tx);
printTxData("moveToken1_3Tx", moveToken1_3Tx);
failIfTxStatusError(moveToken1_1Tx, moveToken1_Message + " - transfer 1 token ac3 -> redemptionWallet. CHECK for movement");
failIfTxStatusError(moveToken1_2Tx, moveToken1_Message + " - approve 30 tokens ac4 -> ac6");
failIfTxStatusError(moveToken1_3Tx, moveToken1_Message + " - transferFrom 30 tokens ac4 -> redemptionWallet by ac6. CHECK for movement");
printTokenContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var moveToken2_Message = "Move Tokens After Presale - Not To Redemption Wallet";
// -----------------------------------------------------------------------------
console.log("RESULT: " + moveToken2_Message);
var moveToken2_1Tx = token.transfer(account5, "1000000", {from: account3, gas: 100000});
var moveToken2_2Tx = token.approve(account6,  "30000000", {from: account4, gas: 100000});
while (txpool.status.pending > 0) {
}
var moveToken2_3Tx = token.transferFrom(account4, account7, "30000000", {from: account6, gas: 100000});
while (txpool.status.pending > 0) {
}
printBalances();
printTxData("moveToken2_1Tx", moveToken2_1Tx);
printTxData("moveToken2_2Tx", moveToken2_2Tx);
printTxData("moveToken2_3Tx", moveToken2_3Tx);
passIfTxStatusError(moveToken2_1Tx, moveToken2_Message + " - transfer 1 token ac3 -> ac5. Expecting failure");
failIfTxStatusError(moveToken2_2Tx, moveToken2_Message + " - approve 30 tokens ac4 -> ac6");
passIfTxStatusError(moveToken2_3Tx, moveToken2_Message + " - transferFrom 30 tokens ac4 -> ac7 by ac6. Expecting failure");
printTokenContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var freezeMessage = "Freeze Tokens";
// -----------------------------------------------------------------------------
console.log("RESULT: " + freezeMessage);
var freeze1Tx = token.freezeTokens({from: contractOwnerAccount, gas: 400000, gasPrice: defaultGasPrice});
while (txpool.status.pending > 0) {
}
printBalances();
printTxData("freeze1Tx", freeze1Tx);
failIfTxStatusError(freeze1Tx, freezeMessage + " - freezeTokens()");
printTokenContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var moveToken3_Message = "Move Tokens After Presale - To Redemption Wallet";
// -----------------------------------------------------------------------------
console.log("RESULT: " + moveToken3_Message);
var moveToken3_1Tx = token.transfer(redemptionWallet, "1000000", {from: account3, gas: 100000});
var moveToken3_2Tx = token.approve(account6,  "30000000", {from: account4, gas: 100000});
while (txpool.status.pending > 0) {
}
var moveToken3_3Tx = token.transferFrom(account4, redemptionWallet, "30000000", {from: account6, gas: 100000});
while (txpool.status.pending > 0) {
}
printBalances();
printTxData("moveToken3_1Tx", moveToken3_1Tx);
printTxData("moveToken3_2Tx", moveToken3_2Tx);
printTxData("moveToken3_3Tx", moveToken3_3Tx);
passIfTxStatusError(moveToken3_1Tx, moveToken3_Message + " - transfer 1 token ac3 -> redemptionWallet. Expecting failure as tokens frozen");
failIfTxStatusError(moveToken3_2Tx, moveToken3_Message + " - approve 30 tokens ac4 -> ac6");
passIfTxStatusError(moveToken3_3Tx, moveToken3_Message + " - transferFrom 30 tokens ac4 -> redemptionWallet by ac6. Expecting failure as tokens frozen");
printTokenContractDetails();
console.log("RESULT: ");


EOF
grep "DATA: " $TEST1OUTPUT | sed "s/DATA: //" > $DEPLOYMENTDATA
cat $DEPLOYMENTDATA
grep "RESULT: " $TEST1OUTPUT | sed "s/RESULT: //" > $TEST1RESULTS
cat $TEST1RESULTS
