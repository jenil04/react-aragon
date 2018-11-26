pragma solidity ^0.4.18;

import "@aragon/os/contracts/apps/AragonApp.sol";

contract Voting is AragonApp {

  bytes32 constant public CREATE_VOTES_ROLE = keccak256("CREATE_VOTES_ROLE");
  bytes32 constant public CAST_VOTES_ROLE = keccak256("CAST_VOTES_ROLE");

  event VoteCreated(uint256 voteId);
  event VoteCast(uint256 voteId);

  enum VoteStates {Absent, Yes, No}

  struct Vote {
    address creator;
    string question;
    uint256 yes;
    uint256 no;
    mapping (address => VoteStates) voterStates;
  }

  Vote[] public votes;

  function newVote(string _question) auth(CREATE_VOTES_ROLE) external {
    uint voteId = votes.push(Vote(msg.sender, _question, 0, 0)) - 1;
    VoteCreated(voteId);
  }

  function castVote(uint256 _voteId, bool _supportsProposal) auth(CAST_VOTES_ROLE) public {
      
    VoteStates voterState = votes[_voteId].voterStates[msg.sender];
    
    if (voterState != VoteStates.Absent) {
      if (voterState == VoteStates.Yes) {
        votes[_voteId].yes--;
      }
      else {
        votes[_voteId].no--;
      }
    }
    
    if (_supportsProposal) {
      votes[_voteId].yes++;
      votes[_voteId].voterStates[msg.sender] = VoteStates.Yes;
    }
    else {
      votes[_voteId].no++;
      votes[_voteId].voterStates[msg.sender] = VoteStates.No;
    }

    VoteCast(_voteId);
  }
}