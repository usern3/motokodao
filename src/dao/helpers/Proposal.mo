import Types "../Types";
import List "mo:base/List";
import Principal "mo:base/Principal";

module Proposal {
  public func hasVoted(caller : Principal, proposal : Types.Proposal) : ?Principal {
    List.find<Principal>(proposal.voters, func x = Principal.toText(x) == Principal.toText(caller));
  }

}