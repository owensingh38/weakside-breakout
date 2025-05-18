---
title: Team Stats
---

```sql team_stats
SELECT 
	"Season"::INT,
    info.teamLogo,
	*
FROM team
RIGHT JOIN info
   ON info.triCode=team.Team AND info.seasonId=team.Season
WHERE
	Season IN ${inputs.season_options.value}
AND
	Strength IN ${inputs.strength_options.value}
```

```sql seasons
SELECT DISTINCT 
	SUBSTRING(Season::STRING,1,8) as "Season"
FROM team
```

```sql strengths
SELECT DISTINCT 
	Strength
FROM team
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

<Dropdown name=type title=Type defaultValue=1>
	<DropdownOption valueLabel="On-Ice" value=1 />
	<DropdownOption valueLabel="Goal Impact" value=2 />
</Dropdown>

{#if inputs.display.value == 1}

{#if inputs.type.value == 1}
<DataTable data={team_stats} rows=50 search=true rowShading=true headerColor=#0000ff headerFontColor=white downloadable=false>
    <Column id=teamLogo align=center contentType="image" height=20px title="Logo"/>
    <Column id=Team align=center />
    <Column id=Season align=center fmt='####-####' />
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
    <Column id=GA/xGA align=center title="GA/xGA"/>
    <Column id=Give align=center />
    <Column id=Take align=center />	
    <Column id=GF% align=center title="GF%" fmt='##.00%' />
	<Column id=FF% align=center title="FF%" fmt='##.00%' />
    <Column id=xGF% align=center title="xGF%" fmt='##.00%' />
</DataTable>
{:else }
<DataTable data={team_stats} rows=50 search=true rowShading=true headerColor=#0000ff headerFontColor=white downloadable=false>
    <Column id=teamLogo align=center contentType="image" height=20px title="Logo"/>
    <Column id=Team align=center />
    <Column id=Season align=center fmt='####-####' />
	<Column id=GP align=center title="GP"/>
    <Column id=TOI align=center title="TOI" fmt='#,###.#0' />
    <Column id=OOFF-SRI-T align=center title="On-Ice Shot Rate Impact For" fmt='#0.####' />
    <Column id=OOFF-SQI-T align=center title="On-Ice Shot Quality Impact For" fmt='#0.####' />
	<Column id=OOFF-FNI-T align=center title="On-Ice Finishing Impact For" fmt='#0.####' />
	<Column id=ODEF-SRI-T align=center title="On-Ice Shot Rate Impact Against" fmt='#0.####' />
    <Column id=ODEF-SQI-T align=center title="On-Ice Shot Quality Impact Against" fmt='#0.####' />
	<Column id=ODEF-FNI-T align=center title="On-Ice Finishing Impact Against" fmt='#0.####' />
    <Column id=EGF-T align=center title="Extraneous GF" fmt='#0.####' />
	<Column id=EGA-T align=center title="Extraneous GA" fmt='#0.####' />
    <Column id=ExGF-T align=center title="Extraneous xGF" fmt='#0.####' />
	<Column id=ExGA-T align=center title="Extraneous xGA" fmt='#0.####' />
</DataTable>
{/if}

{:else }
{#if inputs.type.value == 1}
<DataTable data={team_stats} rows=50 search=true rowShading=true headerColor=#0000ff headerFontColor=white downloadable=false>
    <Column id=teamLogo align=center contentType="image" height=20px title="Logo"/>
    <Column id=Team align=center />
    <Column id=Season align=center fmt='####-####' />
	<Column id=GP align=center title="GP"/>
    <Column id=TOI align=center title="TOI" fmt='#,###.#0' />
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
    <Column id=GF% align=center title="GF%" fmt='##.00%' />
	<Column id=FF% align=center title="FF%" fmt='##.00%' />
    <Column id=xGF% align=center title="xGF%" fmt='##.00%' />
</DataTable>
{:else }
<DataTable data={team_stats} rows=50 search=true rowShading=true headerColor=#0000ff headerFontColor=white downloadable=false>
    <Column id=teamLogo align=center contentType="image" height=20px title="Logo"/>
    <Column id=Team align=center />
    <Column id=Season align=center fmt='####-####' />
	<Column id=GP align=center title="GP"/>
    <Column id=TOI align=center title="TOI" fmt='#,###.#0' />
    <Column id=OOFF-SRI align=center title="On-Ice Shot Rate Impact For" fmt='#0.####' />
    <Column id=OOFF-SQI align=center title="On-Ice Shot Quality Impact For" fmt='#0.####' />
	<Column id=OOFF-FNI align=center title="On-Ice Finishing Impact For" fmt='#0.####' />
	<Column id=ODEF-SRI align=center title="On-Ice Shot Rate Impact Against" fmt='#0.####' />
    <Column id=ODEF-SQI align=center title="On-Ice Shot Quality Impact Against" fmt='#0.####' />
	<Column id=ODEF-FNI align=center title="On-Ice Finishing Impact Against" fmt='#0.####' />
    <Column id=EGF align=center title="Extraneous GF" fmt='#0.####' />
	<Column id=EGA align=center title="Extraneous GA" fmt='#0.####' />
    <Column id=ExGF align=center title="Extraneous xGF" fmt='#0.####' />
	<Column id=ExGA align=center title="Extraneous xGA" fmt='#0.####' />
</DataTable>
{/if}
{/if}