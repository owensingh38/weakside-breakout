<svelte:head>
  <link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&display=swap" rel="stylesheet">
</svelte:head>

<script>
	import '@evidence-dev/tailwind/fonts.css';
	import '../app.css';
	import { EvidenceDefaultLayout } from '@evidence-dev/core-components';
	import {base} from '$app/paths';
	export let data;
</script>

<EvidenceDefaultLayout {data}
	hideHeader=true
	hideSidebar=true
	hideBreadcrumbs=true
	logo='{base}/wsba.png'
	homePageName=WSBA
	neverShowQueries=true 
	githubRepo=https://github.com/owensingh38/ 
	fullWidth=true
	builtWithEvidence=false>
	<style>
		html, body {
			font-family: 'Bebas Neue', sans-serif !important;
			font-size: 110%;
		}

		.navbar a {
		float: left;
		font-size: 22px;
		color: white;
		text-align: center;
		padding: 14px 16px;
		text-decoration: none;
		}

		.dropdown {
		float: left;
		overflow: hidden;
		}

		.dropdown .dropbtn {
		font-size: 22px;  
		border: none;
		outline: none;
		color: white;
		padding: 14px 16px;
		background-color: inherit;
		font-family: inherit;
		margin: 0;
		}

		.dropdown-content {
		display: none;
		position: absolute;
		background-color: #f9f9f9;
		min-width: 160px;
		box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2);
		z-index: 1;
		}

		.dropdown-content a {
		float: none;
		color: black;
		padding: 12px 16px;
		text-decoration: none;
		display: block;
		text-align: left;
		}

		.dropdown-content a:hover {
		background-color: #ddd;
		}

		.dropdown:hover .dropdown-content {
		display: block;
		}
	</style>

	<nav class="text-white p-4 flex justify-between items-center border-b border-white">
	<div class="text-xl font-bold">
		<a href="/"><img src='{base}/wsba_header.png' alt='wsba' style='width:300px;'/></a>
	</div>

	<div class="navbar">
		<a href="https://wsba.substack.com" target="_blank">Articles</a>
		<a href="/games/game_metrics/">Games</a>
		<div class="dropdown">
			<button class="dropbtn">Stats
			<i class="fa fa-caret-down"></i>
			</button>
			<div class="dropdown-content">
				<a href="/players/skater_stats">Skater Stats</a>
				<a href="/teams/team_stats">Team Stats</a>
			</div>
		</div>
		<div class="dropdown">
			<button class="dropbtn">Resources
			<i class="fa fa-caret-down"></i>
			</button>
			<div class="dropdown-content">
				<a href="/about/resources">Links</a>
				<a href="/about/xg_model">xG Model</a>
			</div>
		</div>
	</div>
	</nav>

	<main class="flex-grow max-w-7xl mx-auto py-8">
		<slot />
	</main>

	<footer class="text-white p-4 flex justify-between items-center border-t border-white">
		<p>WeakSide Breakout Analysis</p>
		<p>Built with Evidence and Shiny</p>
	</footer>
</EvidenceDefaultLayout>
