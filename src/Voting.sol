// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Voting{
    enum VoteStates{Absent,Yes,No}

    event ProposalCreated(uint256 proposalId );

    struct Proposal{
        address target;
        bytes data;
        uint256 yesCount;
        uint256 noCount;
        mapping (address => VoteStates) voteStates;
    }

    Proposal[] public proposals;

    function newProposal(address _target, bytes calldata _data) external {
    Proposal storage proposal = proposals.push();
    proposal.target = _target;
    proposal.data = _data;
    proposal.yesCount = 0;
    proposal.noCount = 0;

    emit ProposalCreated(proposals.length);
}


    function castVote(uint proposalId , bool opinion) external{
        Proposal storage proposal = proposals[proposalId];

        //Here we are clearing out the previous vote
        if(proposal.voteStates[msg.sender] == VoteStates.Yes){
            proposal.yesCount--;
        }
        if(proposal.voteStates[msg.sender] == VoteStates.No){
            proposal.noCount--;
        }

        //Here we are adding new vote
        if(opinion){
            proposal.yesCount++;
        }else {
            proposal.noCount++;
        }

        // we're tracking whether or not someone has already voted 
        // and we're keeping track as well of what they voted
        proposal.voteStates[msg.sender] = opinion ? VoteStates.Yes : VoteStates.No;

    }
}