import Types "./Types";
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
import Proposal "Proposal";

actor {
  stable var next_proposal_id : Nat = 0;
  stable var proposal_entries : [(Nat, Proposal.StaticProposal)] = [];
  stable var neuron_entries : [(Principal, Types.Neuron)] = [];
  
  let Ledger : actor { 
        icrc1_balance_of: (Types.Account) -> async Nat;
    } = actor("db3eq-6iaaa-aaaah-abz6a-cai");

  let Webpage : actor { set_text: (Text) -> async ();} = actor("b7kpk-xyaaa-aaaal-qbska-cai");

  let neurons = HashMap
    .fromIter<Principal, Types.Neuron>(neuron_entries.vals(), Iter.size(neuron_entries.vals()), Principal.equal, Principal.hash);

  func natHash(n : Nat) : Hash.Hash { Text.hash(Nat.toText(n)); };

  let proposals = HashMap.fromIter<Nat, Proposal.StaticProposal>(proposal_entries.vals(), Iter.size(proposal_entries.vals()), Nat.equal, natHash);
  let threshold_acceptance: Float = 100;
  let threshold_rejection: Float = -threshold_acceptance;

  func proposal_get(id : Nat) : Types.Result<Proposal.StaticProposal, Text> { 
    let proposal = proposals.get(id);
    switch(proposal){
      case(null){
        return #err("proposal not found");
      };
      case(?proposal){
        return #ok(proposal);
      };
    };
  };
  
  func proposal_put(proposal : Proposal.Proposal) {
    proposals.put(proposal.id, Proposal.to_static(proposal));
  };

  public func get_mb_balance(id : Principal) : async Nat {
    return await Ledger.icrc1_balance_of({ owner = id; });
  };

  public shared ({ caller }) func submit_proposal(title : Text, content : Text) : async Types.Result<Text, Text> {
    var voting_power = await Ledger.icrc1_balance_of({ owner = caller; });
    if(voting_power < Proposal.one_token){
      return #err("You must hold at least 1 MB token to create a proposal.");
    };
    let proposal_id = next_proposal_id;
    next_proposal_id += 1;

    let proposal : Proposal.Proposal = Proposal.new(
      proposal_id,
      caller,
      content,
      title,
    );

    proposal_put(proposal);
    return #ok("Proposal ID " # Nat.toText(proposal_id) # " created successfully.");
  };

  public shared ({ caller }) func vote(proposal_id : Nat, yes_or_no : Bool) : async Types.Result<Text, Text> {
    if(Principal.isAnonymous(caller)) { return #err("Anonymous caller"); };
    
    var voting_power = await Ledger.icrc1_balance_of({ owner = caller; });
    
    if(voting_power < Proposal.one_token) { return #err("You must hold at least 1 MB token to vote."); };
    
    let voting_on = proposal_get(proposal_id);
    switch(voting_on){
      case(#err(e)){
        return #err(e);
      };
      case(#ok(prop)){
        let updated_proposal : Types.Result<Proposal.Proposal, Proposal.VotingError> = Proposal.add_vote(prop, caller, voting_power, yes_or_no);
        
        switch(updated_proposal){
          case(#err(e)){
            return #err("Error");
          };
          case(#ok(prop)){
            if(prop.state == #accepted){
              await Webpage.set_text(prop.content);
            };
            proposal_put(prop);
            return #ok("Vote successful");
          };
        };
      };
    };
  };

  public query func get_proposal(id : Nat) : async Types.Result<Proposal.StaticProposal, Text> {
    let proposal = proposals.get(id);
    switch(proposal){
      case(null){
        #err("proposal not found");
      };
      case(?proposal){
        return #ok(proposal);
      };
    };
  };

  public query func get_all_proposals() : async Types.Result<[Proposal.StaticProposal], Text> {
    return #ok(Iter.toArray(proposals.vals()));
  };

  system func preupgrade() {
    proposal_entries := Iter.toArray(proposals.entries());
  };

  system func postupgrade() {
    proposal_entries := [];
  };
}
