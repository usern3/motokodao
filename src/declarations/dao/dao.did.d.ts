import type { Principal } from '@dfinity/principal';
import type { ActorMethod } from '@dfinity/agent';

export type List = [] | [[Principal, List]];
export type ProposalState = { 'open' : null } |
  { 'rejected' : null } |
  { 'accepted' : null } |
  { 'failed' : string };
export type Result = { 'ok' : string } |
  { 'err' : string };
export type Result_1 = { 'ok' : StaticProposal } |
  { 'err' : string };
export type Result_2 = { 'ok' : Array<StaticProposal> } |
  { 'err' : string };
export interface StaticProposal {
  'id' : bigint,
  'title' : string,
  'content' : string,
  'votes_no' : Tokens,
  'voters' : List,
  'state' : ProposalState,
  'timestamp' : bigint,
  'proposer' : Principal,
  'votes_yes' : Tokens,
}
export type Tokens = bigint;
export interface _SERVICE {
  'get_all_proposals' : ActorMethod<[], Result_2>,
  'get_mb_balance' : ActorMethod<[Principal], bigint>,
  'get_proposal' : ActorMethod<[bigint], Result_1>,
  'submit_proposal' : ActorMethod<[string, string], Result>,
  'vote' : ActorMethod<[bigint, boolean], Result>,
}
