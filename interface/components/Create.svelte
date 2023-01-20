<script>
import { daoActor, principal } from "../stores";
import { get } from "svelte/store";
import icpLogo from "../assets/icplogo.gif";

let proposalBody = "Input your proposal body here";
let proposalTitle = "Proposal title";

let summary;

async function create_proposal(summarypayload) {
  let dao = get(daoActor);
  if (!dao) {
    return;
  }
  let res = await dao.submit_proposal(summarypayload);
  if (res.Ok) {
    return res.Ok;
  } else {
    throw new Error(res.Err);
  }
}

let promise = create_proposal(summary);

function handleCreateClick(title, body) {
  summary = { title: title, body: body };
  promise = create_proposal(summary);
}
</script>

<div class="mt-10 flex gap-x-4">
  <div class="flex items-center justify-center">
    <img class="w-62" src="{icpLogo}" alt="icplogo" />
  </div>
  <div class="flex flex-wrap items-center gap-y-8">
    {#if $principal}
      <h1 class="slogan w-full text-3xl font-bold">New Proposal</h1>

      {#await promise}
        <p class="w-full" style="color: white">...waiting</p>
      {:then proposal}
        {#if proposal}
          <p class="w-full" style="color: white">
            Proposal created with payload {proposal}
          </p>
        {/if}
      {:catch error}
        <p class="w-full" style="color: red">{error.message}</p>
      {/await}

      <div class="flex w-full flex-wrap gap-y-4">
        <input
          bind:value="{proposalTitle}"
          class="w-full border border-black px-2 py-2"
          placeholder="Proposal title" />
        <textarea
          bind:value="{proposalBody}"
          class="w-full border border-black px-2 py-2"
          placeholder="Input your proposal summary here"></textarea>
        <button
          class="w-full border bg-white px-4 py-2 text-black hover:border-none hover:bg-lime-400 hover:shadow-hard"
          on:click="{handleCreateClick(proposalTitle, proposalBody)}"
          >Create</button>
      </div>
    {:else}
      <p class="example-disabled">
        Connect with a wallet to create a new proposal.
      </p>
    {/if}
  </div>
</div>
