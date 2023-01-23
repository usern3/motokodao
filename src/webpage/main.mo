import Http "helpers/Http";
import Text "mo:base/Text";
import CertifiedData "mo:base/CertifiedData";
import HashTree "helpers/HashTree";
import Principal "mo:base/Principal";

actor {
  let dao_canister_principal : Principal = Principal.fromText("bnmyt-3iaaa-aaaal-qbsja-cai");
  
  stable var current_text : Blob = Text.encodeUtf8("");

  public shared ({ caller }) func set_text(new_text : Text) : async () {
    assert (caller == dao_canister_principal);

    current_text := Text.encodeUtf8(new_text);
    update_verified_vars();
  };

  /// HTTP request handler
  public query func http_request(req : Http.HttpRequest) : async Http.HttpResponse {
    return ({
      body = current_text;
      headers = [
        ("content-type", "text/plain"),
        HashTree.certification_header(current_text),
      ];
      status_code = 200;
      streaming_strategy = null;
    });
  };

  /// verify vars after each upgrade
  system func postupgrade() {
    update_verified_vars();
  };

  /// call function to update verification of vars
  private func update_verified_vars() {
    HashTree.update_asset_hash(current_text);
  };
};
