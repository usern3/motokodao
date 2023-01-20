<script>
  export let proposal
</script>

<div class="proposal-preview">
  <h2>{proposal.payload.title}</h2>
  <p>{proposal.proposer}</p>
  <p>{proposal.payload.body} </p>
  <!-- <p>
    Yes: {(proposal[1].votes[0] / BigInt(100000000)).toString()}, No: {(
      proposal[1].votes[1] / BigInt(100000000)
    ).toString()}
  </p> -->
</div>

<style>
  .post-preview {
    border: 1px solid white;
    border-radius: 10px;
    margin-bottom: 2vmin;
    padding: 2vmin;
  }
  h2 {
    color: white;
  }

  p {
    color: white;
  }
</style>
