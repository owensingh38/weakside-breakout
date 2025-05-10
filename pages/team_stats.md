---
title: Team Stats
---

```sql team_stats
SELECT 
	SUBSTRING(Season::STRING,1,8) as "Season", 
	*
FROM team s
WHERE
	Season IN ${inputs.season_options.value}
AND
	Strength IN ${inputs.strength_options.value}
```

```sql seasons
SELECT DISTINCT 
	SUBSTRING(Season::STRING,1,8) as "Season"
FROM team s
```

```sql strengths
SELECT DISTINCT 
	Strength
FROM team s
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

<Dropdown name=display title=Display defaultValue=1>
	<DropdownOption valueLabel="Total" value=1 />
	<DropdownOption valueLabel="Rates" value=2 />
</Dropdown>

{#if inputs.display.value == 1}

<DataTable data={team_stats} rows=50 search=true rowShading=true headerColor=#0000ff headerFontColor=white link=playerLink>
    <Column id=Team align=center />
    <Column id=Season align=center />	
	<Column id=GP align=center title="GP"/>
    <Column id=TOI align=center title="TOI"/>
	<Column id=GF align=center title="GF"/>
    <Column id=GA align=center title="GA"/>
	<Column id=FF align=center title="FF"/>
    <Column id=FA align=center title="FA"/>
    <Column id=xGF align=center title="FF"/>
    <Column id=xGA align=center title="xGA"/>
    <Column id=xGF/FF align=center title="xGF/FF"/>
    <Column id=xGA/FA align=center title="xGA/FA"/>
    <Column id=GF/xGF align=center title="GF/xGF"/>
    <Column id=GA/xGA align=center title="GA/xGA"/>
    <Column id=Give align=center />
    <Column id=Take align=center />	
</DataTable>

{:else }

<DataTable data={team_stats} rows=50 search=true rowShading=true headerColor=#0000ff headerFontColor=white link=playerLink>
    <Column id=Team align=center />
    <Column id=Season align=center />	
	<Column id=GP align=center title="GP"/>
    <Column id=TOI align=center title="TOI"/>
	<Column id=GF/60 align=center title="GF/60"/>
    <Column id=GA/60 align=center title="GA/60"/>
	<Column id=FF/60 align=center title="FF/60"/>
    <Column id=FA/60 align=center title="FA/60"/>
    <Column id=xGF/60 align=center title="FF/60"/>
    <Column id=xGA/60 align=center title="xGA/60"/>
    <Column id=xGF/FF align=center title="xGF/FF"/>
    <Column id=xGA/FA align=center title="xGA/FA"/>
    <Column id=GF/xGF align=center title="GF/xGF"/>
    <Column id=GA/xGA align=center title="GA/xGA"/>
    <Column id=Give/60 align=center />
    <Column id=Take/60 align=center />	
</DataTable>

{/if}