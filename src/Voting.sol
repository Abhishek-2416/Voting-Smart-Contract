// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Voting {
    enum VoteStates {Absent, Yes, No}

    struct Proposal {
        address target;
        bytes data;
        uint yesCount;
        uint noCount;
        mapping (address => VoteStates) voteStates;
    }

    Proposal[] public proposals;

    event ProposalCreated(uint);
    event VoteCast(uint, address indexed);

    mapping(address => bool) public members;

    address immutable owner;

    constructor(address[] memory addresses)payable{
        owner = msg.sender;
        uint256 length = addresses.length;
        for(uint i = 0; i < length; i++){
            members[addresses[i]] = true;
        }
    }

    function newProposal(address _target, bytes calldata _data) external {
        require(members[msg.sender] || msg.sender == owner);
        emit ProposalCreated(proposals.length);
        Proposal storage proposal = proposals.push();
        proposal.target = _target;
        proposal.data = _data;
    }

    function castVote(uint _proposalId, bool _supports) external {
        require(members[msg.sender] || msg.sender == owner);
        Proposal storage proposal = proposals[_proposalId];

        // clear out previous vote
        if(proposal.voteStates[msg.sender] == VoteStates.Yes) {
            proposal.yesCount--;
        }
        if(proposal.voteStates[msg.sender] == VoteStates.No) {
            proposal.noCount--;
        }

        // add new vote
        if(_supports) {
            proposal.yesCount++;
        }
        else {
            proposal.noCount++;
        }

        // we're tracking whether or not someone has already voted
        // and we're keeping track as well of what they voted
        proposal.voteStates[msg.sender] = _supports ? VoteStates.Yes : VoteStates.No;

        if(proposal.yesCount >= 10){
            (bool s,) = proposal.target.call(proposal.data);
            require(s);
        }

        emit VoteCast(_proposalId, msg.sender);
    }
}
