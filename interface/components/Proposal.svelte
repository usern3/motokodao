<script>
import Vote from "./Vote.svelte";
export let proposal;

function statusClass(state) {
  let base = "rounded-full bg-lime-400 px-2 text-sm text-black "
  let fmtdState = Object.keys(state)[0]

  if (fmtdState === "rejected") {
    return base + "bg-red-200 text-red-800"
  } else if (fmtdState === "accepted") {
    return base + "bg-lime-400"
  } else {
    return base + "bg-gray-200"
  }
}
</script>

<div class="w-full flex flex-wrap gap-y-4">
  <div class="w-full">
    <h2 class="flex items-center gap-y-2 font-bold">
      <span class="mr-2 align-baseline text-xs font-black uppercase"
        >Title:
      </span>{proposal.title}
    </h2>
    
  </div>
  <div class="w-full flex gap-y-2 items-center">
    <h3 class="text-xs font-black uppercase mr-2">Update to:</h3>
    <p class="">{proposal.content}</p>
  </div>
  <div class="flex flex-wrap items-center gap-y-4 gap-x-2">
    <div class="w-full flex items-center">
      <span class="mr-2 align-baseline text-xs font-black uppercase"
        >By:
      </span><span class="rounded-full bg-lime-400 px-2 text-sm text-black"
        >{proposal.proposer}</span>
    </div>
    <div class="flex items-center">
      <span class="mr-2 align-baseline text-xs font-black uppercase"
        >Status:
      </span><span class={statusClass(proposal.state)}
        >{Object.keys(proposal.state)[0]}</span>
    </div>
  </div>
    <Vote proposal={proposal} />
</div>
<!-- <p>
    Yes: {(proposal[1].votes[0] / BigInt(100000000)).toString()}, No: {(
      proposal[1].votes[1] / BigInt(100000000)
    ).toString()}
  </p> -->
