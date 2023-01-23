import Types "./Types";
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
import Proposal "helpers/Proposal";

actor {
  stable var next_proposal_id : Nat = 0;
  stable var proposalEntries : [(Nat, Types.Proposal)] = [];
  stable var neuron_entries : [(Principal, Types.Neuron)] = [];
  
  let Ledger : actor { 
        icrc1_balance_of: (Types.Account) -> async Nat;
    } = actor("db3eq-6iaaa-aaaah-abz6a-cai");

  let Webpage : actor { set_last_proposal: (Nat) -> async ();} = actor("b7kpk-xyaaa-aaaal-qbska-cai");

  let neurons = HashMap
    .fromIter<Principal, Types.Neuron>(neuron_entries.vals(), Iter.size(neuron_entries.vals()), Principal.equal, Principal.hash);

  func natHash(n : Nat) : Hash.Hash { 
    Text.hash(Nat.toText(n));
  };

  let proposals = HashMap.fromIter<Nat, Types.Proposal>(proposalEntries.vals(), Iter.size(proposalEntries.vals()), Nat.equal, natHash);
  let threshold_acceptance: Float = 100;
  let threshold_rejection: Float = -threshold_acceptance;

  func proposal_get(id : Nat) : ?Types.Proposal = proposals.get(id);
  
  func proposal_put(proposal : Types.Proposal) {
    proposals.put(proposal.id, proposal);
  };

  public func get_mb_balance(id : Principal) : async Nat {
    return await Ledger.icrc1_balance_of({ owner = id; });
  };

  public shared ({ caller }) func submit_proposal(payload : Types.ProposalPayload) : async Types.Result<Text, Text> {
    var voting_power = await Ledger.icrc1_balance_of({ owner = caller; });
    if(voting_power < Types.one_hundred_tokens){
      return #err("You must hold at least 1 MB token to create a proposal.");
    };
    let proposal_id = next_proposal_id;
    next_proposal_id += 1;

    let proposal : Types.Proposal = {
      id = proposal_id;
      timestamp = Time.now();
      proposer = caller;
      payload;
      state = #open;
      votes_yes = Types.zero_token;
      votes_no = Types.zero_token;
      voters = List.nil();
    };

    proposal_put(proposal);
    return #ok("Proposal ID " # Nat.toText(proposal_id) # " created successfully.");
  };

  public shared ({ caller }) func vote(proposal_id : Nat, yes_or_no : Bool) : async Types.Result<Bool, Text> {
    if(Principal.isAnonymous(caller)) {
      return #err("Anonymous caller");
    };

    // let neuron = neurons.get(caller);
    let proposal : ?Types.Proposal = proposal_get(proposal_id);

    switch(proposal) {
      case(null){
        return #err("Proposal does not exist");
      };
      case(?proposal) {
        switch(Proposal.hasVoted(caller, proposal)){
          case(null){};
          case(?hasVoted){
            return #err("User already voted on this proposal");
          };
        };

        var voting_power = await Ledger.icrc1_balance_of({ owner = caller; });

        var new_vote_count : Nat = 0;
        var votes_yes : Types.Tokens = proposal.votes_yes;
        var votes_no : Types.Tokens = proposal.votes_no;
        var state : Types.ProposalState = proposal.state;
        
        if (proposal.state != #open) {
          return #err("Proposal is not open for voring");
        };

        if (yes_or_no){
          votes_yes := proposal.votes_yes  + voting_power;
          if(votes_yes > Types.one_hundred_tokens){
            state := #accepted;
            await Webpage.set_last_proposal(proposal.id);
          }
        } else {
          votes_no := proposal.votes_no  + voting_power;
          if(votes_no > Types.one_hundred_tokens){
            state := #accepted;
          }
        };
        
        let new_voters : List.List<Principal> = List.push(caller, proposal.voters);
        
        let updated_proposal = {
          id = proposal.id; 
          payload = proposal.payload; 
          voters = new_voters; 
          votes_yes = votes_yes; 
          votes_no = votes_no; 
          proposer = proposal.proposer; 
          state = state; 
          timestamp = proposal.timestamp
        };
        proposals.put(proposal.id, updated_proposal);
        return #ok(true);
      }
    };
    // get MB token balance then vote.
    return #err("Not implemented yet");
  };

  public query func get_proposal(id : Nat) : async Types.Result<?Types.Proposal, Text> {
    return #ok(proposals.get(id));
  };

  public query func get_all_proposals() : async Types.Result<[Types.Proposal], Text> {
    return #ok(Iter.toArray(proposals.vals()));
  };

  system func preupgrade() {
    proposalEntries := Iter.toArray(proposals.entries());
  };

  system func postupgrade() {
    proposalEntries := [];
  };
}
