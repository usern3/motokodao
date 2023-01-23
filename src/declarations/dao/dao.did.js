export const idlFactory = ({ IDL }) => {
  const List = IDL.Rec();
  const Tokens = IDL.Nat;
  List.fill(IDL.Opt(IDL.Tuple(IDL.Principal, List)));
  const ProposalState = IDL.Variant({
    'open' : IDL.Null,
    'rejected' : IDL.Null,
    'accepted' : IDL.Null,
    'failed' : IDL.Text,
  });
  const StaticProposal = IDL.Record({
    'id' : IDL.Nat,
    'title' : IDL.Text,
    'content' : IDL.Text,
    'votes_no' : Tokens,
    'voters' : List,
    'state' : ProposalState,
    'timestamp' : IDL.Int,
    'proposer' : IDL.Principal,
    'votes_yes' : Tokens,
  });
  const Result_2 = IDL.Variant({
    'ok' : IDL.Vec(StaticProposal),
    'err' : IDL.Text,
  });
  const Result_1 = IDL.Variant({ 'ok' : StaticProposal, 'err' : IDL.Text });
  const Result = IDL.Variant({ 'ok' : IDL.Text, 'err' : IDL.Text });
  return IDL.Service({
    'get_all_proposals' : IDL.Func([], [Result_2], ['query']),
    'get_mb_balance' : IDL.Func([IDL.Principal], [IDL.Nat], []),
    'get_proposal' : IDL.Func([IDL.Nat], [Result_1], ['query']),
    'submit_proposal' : IDL.Func([IDL.Text, IDL.Text], [Result], []),
    'vote' : IDL.Func([IDL.Nat, IDL.Bool], [Result], []),
  });
};
export const init = ({ IDL }) => { return []; };
