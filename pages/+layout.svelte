<script>
	import '@evidence-dev/tailwind/fonts.css';
	import '../app.css';
	import { EvidenceDefaultLayout } from '@evidence-dev/core-components';
	import {base} from '$app/paths';
	export let data;
</script>

<EvidenceDefaultLayout {data} 
	logo='{base}/wsba.png'
	neverShowQueries=true 
	githubRepo=https://github.com/owensingh38/ 
	fullWidth=true
	builtWithEvidence=false>
	<slot slot="content" />
</EvidenceDefaultLayout>
