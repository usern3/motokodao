<script>
import Proposal from "./Proposal.svelte";
import { get } from "svelte/store";
import { daoActor, principal } from "../stores";

async function get_all_proposals() {
  let dao = get(daoActor);
  if (!dao) {
    return;
  }
  let res = await dao.get_all_proposals();
  console.log("Proposals", res);
  return res;
}
let promise = get_all_proposals();
</script>

<div class="text-black">
  {#if $principal}
    {#await promise}
      <p>Loading...</p>
    {:then proposals}
      <div class="flex flex-col gap-y-8">
        <h1 class="text-black mb-4 text-xl uppercase font-black">Proposals</h1>
        {#each proposals.ok as proposal(proposal.id)}
          <Proposal proposal={proposal} />
          <div class="w-full border border-b" />
        {/each}
      </div>
    {:catch error}
      <p style="color: red">{error.message}</p>
    {/await}
  {:else}
    <p class="example-disabled">Connect with a wallet to view proposals</p>
  {/if}
</div>
