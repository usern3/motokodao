<script>
export let proposal;
console.log(proposal);
</script>

<div class="flex flex-wrap gap-y-4">
  <div class="w-full mb-2">
    <h2 class="flex items-center gap-y-2 text-3xl">
      <span class="mr-2 align-baseline text-xs font-black uppercase"
        >Title:
      </span>{proposal.payload.title}
    </h2>
    <div class="flex items-center gap-y-2 gap-x-2">
      <div class="flex items-center">
        <span class="mr-2 align-baseline text-xs font-black uppercase"
          >By:
        </span><span class="rounded-full bg-lime-400 px-2 text-sm text-black"
          >{proposal.proposer}</span>
      </div>
      <div class="flex items-center">
        <span class="mr-2 align-baseline text-xs font-black uppercase"
          >Status:
        </span><span class="rounded-full bg-lime-400 px-2 text-sm text-black"
          >{Object.keys(proposal.state)[0]}</span>
      </div>
    </div>
  </div>
  <div class="flex flex-wrap gap-y-2 mb-2">
    <h3 class="w-full text-xs font-black uppercase">Body:</h3>
    <p class="w-full">{proposal.payload.body}</p>
  </div>
  <div class="flex flex-wrap w-full gap-y-2">
    <h3 class="w-full text-xs font-black uppercase">Vote</h3>
    <div class="w-full flex gap-x-2">
      <div class="w-1/2 flex gap-x-2"><button class="w-full bg-red-200 hover:bg-red-500 text-black hover:text-black px-4 py-2 hover:shadow-hard text-sm hover:uppercase hover:font-black">Reject</button></div>
      <div class="w-1/2"><button class="w-full bg-lime-200 hover:bg-lime-400 text-black hover:text-black px-4 py-2 hover:shadow-hard text-sm hover:uppercase hover:font-black">Approve</button></div>
    </div>
  </div>
</div>
<!-- <p>
    Yes: {(proposal[1].votes[0] / BigInt(100000000)).toString()}, No: {(
      proposal[1].votes[1] / BigInt(100000000)
    ).toString()}
  </p> -->
