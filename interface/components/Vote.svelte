<script>
import { get } from "svelte/store";
import { daoActor, principal } from "../stores";

let yesOrNo = "";
export let proposal;
let hasVoted = false;

async function vote(votepayload) {
  let dao = get(daoActor);
  if (!dao) {
    return;
  }
  let res = await dao.vote(BigInt(proposal.id), votepayload);
  if (res.ok) {
    return res.ok;
  } else {
    throw new Error(res.err);
  }
}

let promise = vote(yesOrNo);

function handleVoteClick(payload) {
  yesOrNo = payload;
  promise = vote(yesOrNo);
  hasVoted = true;
}
</script>

<div class="flex w-full flex-wrap items-center gap-x-2 gap-y-2">
  <h3 class="w-full text-xs font-black uppercase">Vote</h3>
  <div class="flex w-full gap-x-2">
    <button
      on:click="{() => handleVoteClick(false)}"
      class="w-full bg-red-200 px-4 py-2 text-sm text-black hover:bg-red-500 hover:font-black hover:uppercase hover:text-black hover:shadow-hard"
      >Reject</button>
    <button
      on:click="{() => handleVoteClick(true)}"
      class="w-full bg-lime-200 px-4 py-2 text-sm text-black hover:bg-lime-400 hover:font-black hover:uppercase hover:text-black hover:shadow-hard"
      >Approve</button>
  </div>
  <div class="w-10/12">
    {#if hasVoted === true}
      {#await promise}
        <h1 class="slogan">Loading...</h1>
      {:then res2}
        <p style="text-black">
          Voted successfully! Current votes: {res2}
        </p>
      {:catch error}
        <p class="text-red-600">{error.message}</p>
      {/await}
    {/if}
  </div>
</div>
