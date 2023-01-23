import Result "mo:base/Result";
import Int "mo:base/Int";
import Nat "mo:base/Nat";
import List "mo:base/List";
import Principal "mo:base/Principal";
import Buffer "mo:base/Buffer";
import HashMap "mo:base/HashMap";
import Proposal "./Proposal";

module {
  public type Result<T, E> = Result.Result<T, E>;
  public type Account = { owner : Principal; };
  public type Tokens = Nat;

  public type SystemParams = {
    // The amount of tokens needed to vote "yes" to accept, or "no" to reject, a proposal
    proposal_vote_threshold : Tokens;

    // The amount of tokens that will be temporarily deducted from the account of
    // a user that submits a proposal. If the proposal is Accepted, this deposit is returned,
    // otherwise it is lost. This prevents users from submitting superfluous proposals.
    proposal_submission_deposit : Tokens
  };

  public type NeuronState = {
    #Locked;
    #Dissolving;
    #Dissolved;
  };

  public type Neuron = {
    owner: Principal;
    amount: Nat;
    dissolveDelay: Int;
    neuronState: NeuronState;
    createdAt: Int;
    dissolvedAt: Int;
    depositSubaccount: Subaccount;
  };

  public type Subaccount = Blob;
}
