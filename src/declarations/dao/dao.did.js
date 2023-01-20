export const idlFactory = ({ IDL }) => {
  const List = IDL.Rec();
  const Tokens = IDL.Record({ 'amount_e8s' : IDL.Nat });
  List.fill(IDL.Opt(IDL.Tuple(IDL.Principal, List)));
  const ProposalState = IDL.Variant({
    'open' : IDL.Null,
    'rejected' : IDL.Null,
    'accepted' : IDL.Null,
    'failed' : IDL.Text,
  });
  const ProposalPayload = IDL.Record({ 'title' : IDL.Text, 'body' : IDL.Text });
  const Proposal = IDL.Record({
    'id' : IDL.Nat,
    'votes_no' : Tokens,
    'voters' : List,
    'state' : ProposalState,
    'timestamp' : IDL.Int,
    'proposer' : IDL.Principal,
    'votes_yes' : Tokens,
    'payload' : ProposalPayload,
  });
  const Result_3 = IDL.Variant({ 'ok' : IDL.Vec(Proposal), 'err' : IDL.Text });
  const Result_2 = IDL.Variant({ 'ok' : Proposal, 'err' : IDL.Text });
  const Result_1 = IDL.Variant({ 'ok' : IDL.Nat, 'err' : IDL.Text });
  const Result = IDL.Variant({
    'ok' : IDL.Tuple(IDL.Nat, IDL.Nat),
    'err' : IDL.Text,
  });
  return IDL.Service({
    'get_all_proposals' : IDL.Func([], [Result_3], ['query']),
    'get_proposal' : IDL.Func([IDL.Nat], [Result_2], ['query']),
    'submit_proposal' : IDL.Func([ProposalPayload], [Result_1], []),
    'vote' : IDL.Func([IDL.Int, IDL.Bool], [Result], []),
  });
};
export const init = ({ IDL }) => { return []; };
