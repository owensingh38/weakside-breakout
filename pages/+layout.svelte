<script>
	import '@evidence-dev/tailwind/fonts.css';
	import '../app.css';
	import { EvidenceDefaultLayout } from '@evidence-dev/core-components';
	export let data;
</script>

<EvidenceDefaultLayout {data} 
	logo=/wsba.png 
	neverShowQueries=true 
	githubRepo=https://github.com/owensingh38/wsba_hockey 
	xProfile=https://twitter.com/OS_v_38 fullWidth=true >
	<slot slot="content" />
</EvidenceDefaultLayout>
