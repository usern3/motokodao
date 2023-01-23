import Principal "mo:base/Principal";
import Http "./helpers/Http";
import Text "mo:base/Text";

actor {
  public type HttpRequest = Http.HttpRequest;
  public type HttpResponse = Http.HttpResponse;

  let dao_canister_principal : Principal = Principal.fromText("bnmyt-3iaaa-aaaal-qbsja-cai");
  var last_proposal_id : Nat = 0;

  public query func http_request(req : HttpRequest) : async HttpResponse {
    return ({
      body = Text.encodeUtf8("This is a cool page");
      headers = [];
      status_code = 200;
      streaming_strategy = null;
    });
  };


  public query func last_proposal() : async Nat {
    return last_proposal_id;
  };

  public shared ({caller}) func set_last_proposal(id: Nat) : () {
    if (caller != dao_canister_principal) {
      return;
    };
    last_proposal_id := id;
  };
};
