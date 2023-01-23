import Result "mo:base/Result";
import Principal "mo:base/Principal";
import Nat "mo:base/Nat";
import Time "mo:base/Time";
import List "mo:base/List";
import Iter "mo:base/Iter";
import Buffer "mo:base/Buffer";
import Debug "mo:base/Debug";
import HashMap "mo:base/HashMap";
import Blob "mo:base/Blob";
import Array "mo:base/Array";
import Hash "mo:base/Hash";
import Text "mo:base/Text";

module {
  public type Tokens = Nat;

  public type VotingError = { #notOpen; #alreadyVoted; #notEnoughVotingPower; #doesNotExist };

  public type Proposal = {
    id : Nat;
    var voters : List.List<Principal>;
    var state : ProposalState;
    timestamp : Int;
    proposer : Principal;
    var votes_yes : Tokens;
    var votes_no : Tokens;
    content : Text;
    title : Text;
  };

  public type StaticProposal = {
    id : Nat;
    voters : List.List<Principal>;
    state : ProposalState;
    timestamp : Int;
    proposer : Principal;
    votes_yes : Tokens;
    votes_no : Tokens;
    content : Text;
    title : Text;
  };

  public type ProposalState = {
    #failed : Text;
    #open;
    #rejected;
    #accepted
  };

  public type ProposalPayload = {
    title : Text;
    button_text : Text;
  };

  public let one_token : Tokens = 100_000_000;
  public let one_hundred_tokens : Tokens = 10_000_000_000;
  public let zero_token : Tokens = 0;

  public func new(id : Nat, proposer : Principal, title : Text, content : Text) : Proposal {
    return {
      id;
      title;
      content;
      proposer;
      timestamp = Time.now();
      var state = #open;
      var votes_yes = 0;
      var votes_no = 0;
      var voters = List.nil();
    };
  };

  public func is_active(proposal : Proposal) : Bool {
    return proposal.state == #open;
  };

  public func has_voted(caller : Principal, proposal : StaticProposal) : ?Principal {
    List.find<Principal>(proposal.voters, func x = Principal.toText(x) == Principal.toText(caller));
  };

  public func add_vote(proposal : StaticProposal, voter : Principal, voting_power : Nat, yes_or_no : Bool) : Result.Result<Proposal, VotingError> {
    if (proposal.state != #open) { return #err(#notOpen); };

    switch(has_voted(voter, proposal)){
      case(null){};
      case(?has_voted){
        return #err(#alreadyVoted);
      };
    };

    var new_vote_count : Nat = 0;
    var votes_yes : Tokens = proposal.votes_yes;
    var votes_no : Tokens = proposal.votes_no;
    var state : ProposalState = proposal.state;
    
    if (yes_or_no){
      votes_yes := proposal.votes_yes  + voting_power;
      if(votes_yes > one_hundred_tokens){
        state := #accepted;
      }
    } else {
      votes_no := proposal.votes_no  + voting_power;
      if(votes_no > one_hundred_tokens){
        state := #rejected;
      }
    };
    
    let new_voters = List.push(voter, proposal.voters);
    
    let updated_proposal = {
      id = proposal.id; 
      title = proposal.title; 
      content = proposal.content; 
      proposer = proposal.proposer; 
      timestamp = proposal.timestamp;
      var voters = new_voters; 
      var votes_yes = votes_yes; 
      var votes_no = votes_no; 
      var state = state; 
    };
    return #ok(updated_proposal);
  };

  public func to_static(p : Proposal) : StaticProposal {
    return {
      id = p.id; 
      title = p.title; 
      content = p.content; 
      proposer = p.proposer; 
      timestamp = p.timestamp;
      voters = p.voters; 
      votes_yes = p.votes_yes; 
      votes_no = p.votes_no; 
      state = p.state; 
    };
  };

  /// Restore a proposal from stable memory
  public func from_static(p : StaticProposal) : Proposal {
    return {
      id = p.id; 
      title = p.title; 
      content = p.content; 
      proposer = p.proposer; 
      timestamp = p.timestamp;
      var voters = p.voters; 
      var votes_yes = p.votes_yes; 
      var votes_no = p.votes_no; 
      var state = p.state; 
    };
  };
}
