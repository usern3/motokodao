actor {
  stable var siteMessage : Text = "Hello world!";

  public query func getSiteMessage() : async Text {
    return siteMessage;
  };

  public func setSiteMessage(msg : Text) : async Text {
    siteMessage := msg;
    return siteMessage;
  }
};
