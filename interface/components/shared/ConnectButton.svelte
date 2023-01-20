<script>
  import { plugConnection } from "../connexion"
  import { principal } from "../../stores"
  export let message = "Sign in"
</script>

{#if $principal}
  <p style="float: right; color: white">{$principal.id}</p>
{:else}
  <button on:click={() => plugConnection()}> {message} </button>
{/if}
