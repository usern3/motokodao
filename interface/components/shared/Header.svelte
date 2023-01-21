<script>
import { plugConnection } from "../connexion";
import { principal } from "../../stores";
import { view } from "../../stores.js";
import plug from "../../assets/plug.png";

const handleView = () => {
  $view.current = $view.view;
};
const handleCreate = () => {
  $view.current = $view.create;
};
const handleVote = () => {
  $view.current = $view.vote;
};
const handleHome = () => {
  $view.current = $view.home;
};
</script>

<header class="mb-8 bg-gray-50 text-black">
  <nav class="mx-auto max-w-7xl px-6 lg:px-8" aria-label="Top">
    <div class="flex w-full items-center justify-between py-6 lg:border-none">
      <h1 class="text-4xl font-black">DAO</h1>
      <div class="flex items-center">
        <div class="ml-10 hidden space-x-8 lg:block">
          <button
            on:click="{() => handleHome()}"
            class="bg-transparent px-4 py-2 text-black hover:bg-lime-400 hover:text-black hover:shadow-hard"
            >Home</button>
          <button
            on:click="{() => handleView()}"
            class="bg-transparent px-4 py-2 text-black hover:bg-lime-400 hover:text-black hover:shadow-hard"
            >Proposals</button>
          <button
            on:click="{() => handleCreate()}"
            class="bg-transparent px-4 py-2 text-black hover:bg-lime-400 hover:text-black hover:shadow-hard"
            >Create</button>
          <button
            on:click="{() => handleVote()}"
            class="bg-transparent px-4 py-2 text-black hover:bg-lime-400 hover:text-black hover:shadow-hard"
            >Vote</button>
        </div>
      </div>
      <div>
        {#if $principal}
          <div
            class="ml-1 flex items-center gap-x-2 rounded-xl text-sm bg-gray-200 px-4 py-2 text-zinc-700">
            <svg
              class="h-4 w-4 fill-current"
              xmlns="http://www.w3.org/2000/svg"
              viewBox="0 0 512 512">
              <path
                d="M456 32C469.3 32 480 42.75 480 56C480 69.25 469.3 80 456 80H88C65.91 80 48 97.91 48 120V392C48 414.1 65.91 432 88 432H424C446.1 432 464 414.1 464 392V216C464 193.9 446.1 176 424 176H120C106.7 176 96 165.3 96 152C96 138.7 106.7 128 120 128H424C472.6 128 512 167.4 512 216V392C512 440.6 472.6 480 424 480H88C39.4 480 0 440.6 0 392V120C0 71.4 39.4 32 88 32H456zM352 304C352 286.3 366.3 272 384 272C401.7 272 416 286.3 416 304C416 321.7 401.7 336 384 336C366.3 336 352 321.7 352 304z"
              ></path
              ></svg>
            {$principal.id.substring($principal.id.length - 9)}
          </div>
        {:else}
          <button
            class="mr-1 flex items-center px-4 py-2 font-semibold text-black hover:bg-lime-400 hover:text-black hover:shadow-hard"
            on:click="{() => plugConnection()}">
            <img src="{plug}" alt="Login with Plug" class="mr-1 inline w-6" /> Sign
            in
          </button>
        {/if}
      </div>
    </div>
  </nav>
</header>
