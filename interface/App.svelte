<style global>
@tailwind utilities;
@tailwind components;
@tailwind base;
</style>

<script>
import * as dao from "../src/declarations/dao";
import Header from "./components/shared/Header.svelte";
import { view } from "./stores.js";
import Home from "./components/Home.svelte";
import View from "./components/View.svelte";
import Create from "./components/Create.svelte";
</script>

<div class="App">
  <Header />

  <div
    class="min-w-3xl container mx-auto flex max-w-3xl flex-wrap justify-center">
    {#if $view.current === $view.home}
      <Home />
    {:else if $view.current === $view.view}
      <View />
    {:else if $view.current === $view.create}
      <Create />
    {/if}
  </div>

  <footer></footer>
</div>
