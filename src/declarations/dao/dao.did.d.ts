import type { Principal } from '@dfinity/principal';
import type { ActorMethod } from '@dfinity/agent';

export type List = [] | [[Principal, List]];
export interface Proposal {
  'id' : bigint,
  'votes_no' : Tokens,
  'voters' : List,
  'state' : ProposalState,
  'timestamp' : bigint,
  'proposer' : Principal,
  'votes_yes' : Tokens,
  'payload' : ProposalPayload,
}
export interface ProposalPayload { 'title' : string, 'body' : string }
export type ProposalState = { 'open' : null } |
  { 'rejected' : null } |
  { 'accepted' : null } |
  { 'failed' : string };
export type Result = { 'ok' : [bigint, bigint] } |
  { 'err' : string };
export type Result_1 = { 'ok' : bigint } |
  { 'err' : string };
export type Result_2 = { 'ok' : Proposal } |
  { 'err' : string };
export type Result_3 = { 'ok' : Array<Proposal> } |
  { 'err' : string };
export interface Tokens { 'amount_e8s' : bigint }
export interface _SERVICE {
  'get_all_proposals' : ActorMethod<[], Result_3>,
  'get_proposal' : ActorMethod<[bigint], Result_2>,
  'submit_proposal' : ActorMethod<[ProposalPayload], Result_1>,
  'vote' : ActorMethod<[bigint, boolean], Result>,
}
