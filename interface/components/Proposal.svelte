<script>
export let proposal;
</script>

<div class="proposal-preview">
  <h2>{proposal.payload.title}</h2>
  <p>{proposal.proposer}</p>
  <p>{proposal.payload.body}</p>
  <!-- <p>
    Yes: {(proposal[1].votes[0] / BigInt(100000000)).toString()}, No: {(
      proposal[1].votes[1] / BigInt(100000000)
    ).toString()}
  </p> -->
</div>
