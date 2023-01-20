import Types "./Types";
import Result "mo:base/Result";
import Trie "mo:base/Trie";
import Principal "mo:base/Principal";
import Nat "mo:base/Nat";
import Time "mo:base/Time";
import List "mo:base/List";
import Iter "mo:base/Iter";
import Buffer "mo:base/Buffer";

actor {
  stable var next_proposal_id : Nat = 0;
  stable var proposals : [Types.Proposal] = [];
  var proposal_buff = Buffer.fromArray<Types.Proposal>(proposals);

  func proposal_put(id : Nat, proposal : Types.Proposal) {
    proposal_buff.add(proposal);
    proposals := Buffer.toArray(proposal_buff);
  };

  public shared ({ caller }) func submit_proposal(payload : Types.ProposalPayload) : async Types.Result<Nat, Text> {
    let proposal_id = next_proposal_id;
    next_proposal_id += 1;

    let proposal : Types.Proposal = {
      id = proposal_id;
      timestamp = Time.now();
      proposer = caller;
      payload;
      state = #open;
      votes_yes = Types.zeroToken;
      votes_no = Types.zeroToken;
      voters = List.nil()
    };

    proposal_put(proposal_id, proposal);
    #ok(proposal_id)
  };

  public shared ({ caller }) func vote(proposal_id : Int, yes_or_no : Bool) : async Types.Result<(Nat, Nat), Text> {
    return #err("Not implemented yet")
  };

  public query func get_proposal(id : Nat) : async Types.Result<Types.Proposal, Text> {
    let p = proposal_buff.get(id - 1);
    return #ok(p);
  };

  public query func get_all_proposals() : async Types.Result<[Types.Proposal], Text> {
    return #ok(proposals);
  };

  system func preupgrade() {
    proposals := Buffer.toArray(proposal_buff);
  };

  system func postupgrade() {
    proposals := Buffer.toArray(proposal_buff);
  };
}
