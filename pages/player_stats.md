---
title: Player Stats
---

```sql skater_stats
SELECT 
	SUBSTRING(Season::STRING,1,8) as "Season", 
	(A1+A2) as "A",
	((A1+A2)/TOI)*60 as "A/60",
	"Extraneous Gi" as "ext_gi",
	"Extraneous GF" as "ext_gf",
	"Extraneous GA" as "ext_ga",
	"Extraneous xGi" as "ext_xgi",
	"Extraneous xGF" as "ext_xgf",
	"Extraneous xGA" as "ext_xga",
	"Linemate Extraneous Goals" as "line-ex_g",
	"Linemate Goal Induction" as "line-in",
	"Composite Goal Impact" as "comp_goal",
	"Linemate Rel. Goal Impact" as "line-rel",
	*
FROM skater s
WHERE
	Season IN ${inputs.season_options.value}
AND
	Age >= ${inputs.age_options}
AND
	TOI >= ${inputs.toi_options}
AND
	Strength IN ${inputs.strength_options.value}
AND
	Position IN ${inputs.position_options.value}
```

```sql seasons
SELECT DISTINCT 
	SUBSTRING(Season::STRING,1,8) as "Season"
FROM skater s
```

```sql strengths
SELECT DISTINCT 
	Strength
FROM skater s
```

```sql positions
SELECT DISTINCT 
	Position
FROM skater s
```

<Dropdown
    data={seasons}
    name=season_options
    value=Season
	title=Season
    defaultValue="20242025"
	multiple=true
/>

<Dropdown
    data={strengths}
    name=strength_options
    value=Strength
	title=Strength
    defaultValue="5v5"
	multiple=true
/>

<Dropdown
    data={positions}
    name=position_options
    value=Position
	title=Position
	selectAllByDefault=true
	multiple=true
/>

<Dropdown name=display title=Display defaultValue=1>
	<DropdownOption valueLabel="Total" value=1 />
	<DropdownOption valueLabel="Rates" value=2 />
</Dropdown>

<Dropdown name=type title=Type defaultValue=1>
	<DropdownOption valueLabel="Individual" value=1 />
	<DropdownOption valueLabel="On-Ice" value=2 />
	<DropdownOption valueLabel="Goal Impact" value=3 />
</Dropdown>


<TextInput
    name=age_options
    title="Age"
	defaultValue=17
/>

<TextInput
    name=toi_options
    title="TOI"
	defaultValue=150
/>

{#if inputs.display.value == 1}

{#if inputs.type.value == 1}
<DataTable data={skater_stats} rows=50 search=true rowShading=true headerColor=#0000ff headerFontColor=white link=playerLink>
    <Column id=Player align=center />
	<Column id=ID align=center title="ID"/>
    <Column id=Season align=center />
	<Column id=Team align=center />
	<Column id=Position align=center />
    <Column id=Age align=center />
	<Column id=Nationality align=center />
	<Column id=GP align=center title="GP"/>
    <Column id=TOI align=center title="TOI" fmt='#,###.#0' />
	<Column id=Gi align=center title="G"/>
	<Column id=A1 align=center />
	<Column id=A2 align=center />
    <Column id=A align=center />
	<Column id=P align=center />
	<Column id=Fi align=center title="iFF"/>
	<Column id=xGi align=center title="ixG"/>
	<Column id=xGi/Fi align=center title="ixG/iFF"/>
	<Column id=Gi/xGi align=center title="G/ixG"/>
    <Column id=Give align=center />
    <Column id=Take align=center />	
	<Column id=Penl align=center />
    <Column id=Draw align=center />	
	<Column id=PIM align=center title="PIM"/>	
</DataTable>
{:else if inputs.type.value == 2}
<DataTable data={skater_stats} rows=50 search=true rowShading=true headerColor=#0000ff headerFontColor=white link=playerLink>
    <Column id=Player align=center />
	<Column id=ID align=center title="ID"/>
    <Column id=Season align=center />
	<Column id=Team align=center />
	<Column id=Position align=center />
    <Column id=Age align=center />
	<Column id=Nationality align=center />
	<Column id=GP align=center title="GP"/>
    <Column id=TOI align=center title="TOI" fmt='#,###.#0' />
	<Column id=GF align=center title="GF"/>
    <Column id=GA align=center title="GA"/>
	<Column id=FF align=center title="FF"/>
    <Column id=FA align=center title="FA"/>
    <Column id=xGF align=center title="FF"/>
    <Column id=xGA align=center title="xGA"/>
    <Column id=xGF/FF align=center title="xGF/FF"/>
    <Column id=xGA/FA align=center title="xGA/FA"/>
    <Column id=GF/xGF align=center title="GF/xGF"/>
    <Column id=GF% align=center title="GF%" fmt='##.00%' />
	<Column id=FF% align=center title="FF%" fmt='##.00%' />
    <Column id=xGF% align=center title="xGF%" fmt='##.00%' />
</DataTable>
{:else }
<DataTable data={skater_stats} rows=50 search=true rowShading=true headerColor=#0000ff headerFontColor=white link=playerLink>
    <Column id=Player align=center />
	<Column id=ID align=center title="ID"/>
    <Column id=Season align=center />
	<Column id=Team align=center />
	<Column id=Position align=center />
    <Column id=Age align=center />
	<Column id=Nationality align=center />
	<Column id=GP align=center title="GP"/>
    <Column id=TOI align=center title="TOI" fmt='#,###.#0' />
	<Column id=INDV-SRI align=center title="Shot Rate Impact" fmt='#0.####' />
    <Column id=INDV-SQI align=center title="Shot Quality Impact" fmt='#0.####' />
	<Column id=INDV-FN align=center title="Finishing Impact" fmt='#0.####' />
    <Column id=OOFF-SRI align=center title="On-Ice Shot Rate Impact For" fmt='#0.####' />
    <Column id=OOFF-SQI align=center title="On-Ice Shot Quality Impact For" fmt='#0.####' />
	<Column id=OOFF-FN align=center title="On-Ice Finishing Impact For" fmt='#0.####' />
	<Column id=ODEF-SRI align=center title="On-Ice Shot Rate Impact Against" fmt='#0.####' />
    <Column id=ODEF-SQI align=center title="On-Ice Shot Quality Impact Against" fmt='#0.####' />
	<Column id=ODEF-FN align=center title="On-Ice Finishing Impact Against" fmt='#0.####' />
	<Column id=ext_gi align=center title="Extraneous G" fmt='#0.####' />
    <Column id=ext_gf align=center title="Extraneous GF" fmt='#0.####' />
	<Column id=ext_ga align=center title="Extraneous GA" fmt='#0.####' />
	<Column id=ext_xgi align=center title="Extraneous ixG" fmt='#0.####' />
    <Column id=ext_xgf align=center title="Extraneous xGF" fmt='#0.####' />
	<Column id=ext_xga align=center title="Extraneous xGA" fmt='#0.####' />
	<Column id=line-ex_g align=center title="Linemate Extraneous GF" fmt='#0.####' />
	<Column id=line-in align=center title="Goal Induction" fmt='#0.####' />
    <Column id=comp_goal align=center title="Composite Goal Impact" fmt='#0.####' />
	<Column id=line-rel align=center title="Linemate Rel. Goal Impact" fmt='#0.####' />
</DataTable>
{/if}


{:else }
{#if inputs.type.value == 1}
<DataTable data={skater_stats} rows=50 search=true rowShading=true headerColor=#0000ff headerFontColor=white link=playerLink>
    <Column id=Player align=center />
	<Column id=ID align=center title="ID"/>
    <Column id=Season align=center />
	<Column id=Team align=center />
	<Column id=Position align=center />
    <Column id=Age align=center />
	<Column id=Nationality align=center />
	<Column id=GP align=center title="GP"/>
    <Column id=TOI align=center title="TOI" fmt='#,###.#0' />
	<Column id=Gi/60 align=center title="G/60"/>
	<Column id=A1/60 align=center />
	<Column id=A2/60 align=center />
    <Column id=A/60 align=center />
	<Column id=P/60 align=center />
	<Column id=Fi/60 align=center title="iFF/60"/>
	<Column id=xGi/60 align=center title="ixG/60"/>
	<Column id=xGi/Fi align=center title="ixG/iFF"/>
	<Column id=Gi/xGi align=center title="G/ixG"/>
    <Column id=Give/60 align=center />
    <Column id=Take/60 align=center />	
	<Column id=Penl/60 align=center />
    <Column id=Draw/60 align=center />	
	<Column id=PIM align=center title="PIM"/>	
</DataTable>
{:else if inputs.type.value == 2}
<DataTable data={skater_stats} rows=50 search=true rowShading=true headerColor=#0000ff headerFontColor=white link=playerLink>
    <Column id=Player align=center />
	<Column id=ID align=center title="ID"/>
    <Column id=Season align=center />
	<Column id=Team align=center />
	<Column id=Position align=center />
    <Column id=Age align=center />
	<Column id=Nationality align=center />
	<Column id=GP align=center title="GP"/>
    <Column id=TOI align=center title="TOI" fmt='#,###.#0' />
	<Column id=GF/60 align=center title="GF/60"/>
    <Column id=GA/60 align=center title="GA/60"/>
	<Column id=FF/60 align=center title="FF/60"/>
    <Column id=FA/60 align=center title="FA/60"/>
    <Column id=xGF/60 align=center title="xGF/60"/>
    <Column id=xGA/60 align=center title="xGA/60"/>
    <Column id=xGF/FF align=center title="xGF/FF"/>
    <Column id=xGA/FA align=center title="xGA/FA"/>
    <Column id=GF/xGF align=center title="GF/xGF"/>
    <Column id=GF% align=center title="GF%" fmt='##.00%' />
	<Column id=FF% align=center title="FF%" fmt='##.00%' />
    <Column id=xGF% align=center title="xGF%" fmt='##.00%' />
</DataTable>
{:else }
<DataTable data={skater_stats} rows=50 search=true rowShading=true headerColor=#0000ff headerFontColor=white link=playerLink>
    <Column id=Player align=center />
	<Column id=ID align=center title="ID"/>
    <Column id=Season align=center />
	<Column id=Team align=center />
	<Column id=Position align=center />
    <Column id=Age align=center />
	<Column id=Nationality align=center />
	<Column id=GP align=center title="GP"/>
    <Column id=TOI align=center title="TOI" fmt='#,###.#0' />
	<Column id=INDV-SRI align=center title="Shot Rate Impact" fmt='#0.####' />
    <Column id=INDV-SQI align=center title="Shot Quality Impact" fmt='#0.####' />
	<Column id=INDV-FN align=center title="Finishing Impact" fmt='#0.####' />
    <Column id=OOFF-SRI align=center title="On-Ice Shot Rate Impact For" fmt='#0.####' />
    <Column id=OOFF-SQI align=center title="On-Ice Shot Quality Impact For" fmt='#0.####' />
	<Column id=OOFF-FN align=center title="On-Ice Finishing Impact For" fmt='#0.####' />
	<Column id=ODEF-SRI align=center title="On-Ice Shot Rate Impact Against" fmt='#0.####' />
    <Column id=ODEF-SQI align=center title="On-Ice Shot Quality Impact Against" fmt='#0.####' />
	<Column id=ODEF-FN align=center title="On-Ice Finishing Impact Against" fmt='#0.####' />
	<Column id=ext_gi align=center title="Extraneous G" fmt='#0.####' />
    <Column id=ext_gf align=center title="Extraneous GF" fmt='#0.####' />
	<Column id=ext_ga align=center title="Extraneous GA" fmt='#0.####' />
	<Column id=ext_xgi align=center title="Extraneous ixG" fmt='#0.####' />
    <Column id=ext_xgf align=center title="Extraneous xGF" fmt='#0.####' />
	<Column id=ext_xga align=center title="Extraneous xGA" fmt='#0.####' />
	<Column id=line-ex_g align=center title="Linemate Extraneous GF" fmt='#0.####' />
	<Column id=line-in align=center title="Goal Induction" fmt='#0.####' />
    <Column id=comp_goal align=center title="Composite Goal Impact" fmt='#0.####' />
	<Column id=line-rel align=center title="Linemate Rel. Goal Impact" fmt='#0.####' />
</DataTable>
{/if}

{/if}