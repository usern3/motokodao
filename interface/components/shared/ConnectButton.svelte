<script>
  import { plugConnection } from "../connexion"
  import { principal } from "../../stores";
  export let message = "Sign in"
</script>

{#if $principal}
{$principal.id}
{:else}
<button on:click={() => plugConnection()}> {message} </button>
{/if}