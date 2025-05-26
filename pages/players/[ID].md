---
title: Skater Stats
hide_title: true
---

```sql color
SELECT DISTINCT
   s.Team, i."Primary Color" as PC, i."Secondary Color" as SC
FROM
   skater s, info i
INNER JOIN info
   ON s.Team=i.triCode
WHERE
   s.ID = '${params.ID}'
AND
   s.Team = '${inputs.shot_team.value}'
```

```sql bio
SELECT DISTINCT
   Position,
   Handedness as Hand,
   "Height (in)",
   "Weight (lbs)",
   SUBSTRING(Birthday,1,10) as Birthdate,
   Nationality
FROM skater
WHERE
   ID = '${params.ID}'
LIMIT
   1
```

```sql headshot
SELECT DISTINCT
   'https://assets.nhle.com/mugs/nhl/latest/' || SUBSTRING(ID,1,8) || 'png' as head
FROM skater
WHERE
   ID = '${params.ID}'
```

```sql stats
SELECT
   Season::INT as "Season",
   (A1+A2) as "A",
   ((A1+A2)/TOI)*60 as "A/60",
   '/players/' || ID as playerLink,
   CASE 
      WHEN Span = 2 THEN 'Regular' ELSE 'Playoffs'
   END as SpanText,
   info.teamLogo,
   *
FROM skater
RIGHT JOIN info
   ON info.triCode=skater.Team AND info.seasonId=skater.Season
WHERE
   ID = '${params.ID}'
AND
   Strength = '${inputs.strength_options.value}'
AND
   Span IN ${inputs.span_options.value}
```

```sql game_titles
SELECT DISTINCT
   game_id,game_date,game_title
FROM pbp
```

```sql log
SELECT
   SUBSTRING(t.game_title,1,9) as game_title,
   t.game_date,
   info.teamLogo,
   (A1+A2) as "A",
	*
FROM game_log
LEFT JOIN ${game_titles} as t
   ON game_log.Game=t.game_id
LEFT JOIN info
   ON game_log.Team=info.triCode AND game_log.Season=info.seasonId
WHERE
   ID = '${params.ID}'
AND
   Strength = '${inputs.strength_options.value}'
AND
   Span IN ${inputs.span_options.value}
```

```sql shot_profile
SELECT *
FROM(
   SELECT
      'Shot Rate' as metric, ("INDV-SR"*100) as value, Strength
   FROM skater
   WHERE
      ID = '${params.ID}' 
   AND
      Season = '${inputs.shot_season.value}'
   AND
      Team = '${inputs.shot_team.value}'
   UNION ALL
   SELECT
      'Shot Quality' as metric, ("INDV-SQ"*100) as value, Strength
   FROM skater
   WHERE
      ID = '${params.ID}' 
   AND
      Season = '${inputs.shot_season.value}'
   AND
      Team = '${inputs.shot_team.value}'
   UNION ALL
   SELECT
      'Finishing' as metric, ("INDV-FN"*100) as value, Strength
   FROM skater
   WHERE
      ID = '${params.ID}' 
   AND
      Season = '${inputs.shot_season.value}'
   AND
      Team = '${inputs.shot_team.value}'
   UNION ALL
   SELECT
      'Goal Induction' as metric, ("LiGIn-P"*100) as value, Strength
   FROM skater
   WHERE
      ID = '${params.ID}' 
   AND
      Season = '${inputs.shot_season.value}'
   AND
      Team = '${inputs.shot_team.value}'
   UNION ALL
   SELECT
      'Goals' as metric, ("Gi/60-P"*100) as value, Strength
   FROM skater
   WHERE
      ID = '${params.ID}' 
   AND
      Season = '${inputs.shot_season.value}'
   AND
      Team = '${inputs.shot_team.value}'
   UNION ALL
   SELECT
      'xGoals' as metric, ("xGi/60-P"*100) as value, Strength
   FROM skater
   WHERE
      ID = '${params.ID}' 
   AND
      Season = '${inputs.shot_season.value}'
   AND
      Team = '${inputs.shot_team.value}'
   )
WHERE
   Strength IN ${inputs.strength_options_2.value}
```

```sql seasons
SELECT DISTINCT 
	SUBSTRING("Season",1,8) as "Season"
FROM skater s
WHERE
   ID = '${params.ID}' 
AND
   TOI >= 150
```

```sql teams
SELECT DISTINCT 
	Team
FROM skater s
WHERE
   ID = '${params.ID}' 
AND
   Season = '${inputs.shot_season.value}'
AND
   TOI >= 150
```

```sql strengths
SELECT DISTINCT 
	Strength
FROM skater
WHERE
   ID = '${params.ID}' 
```

```sql strengths_multiple
SELECT DISTINCT 
	Strength
FROM skater
WHERE
   ID = '${params.ID}' 
AND
   Strength != 'All'
```

```sql plays
SELECT
   CASE
      WHEN event_type IN ('missed-shot','shot-on-goal','goal') THEN "description" || ' - xG: ' || SUBSTRING(("xG"*100),1,5) || '%'
      ELSE "description"
   END as "description",
   CASE 
      WHEN strength_state NOT IN ('5v5','5v4','4v5') THEN 'Other' ELSE strength_state
   END as strength_state,
   CASE WHEN
      x_adj < 0 THEN y_adj ELSE y_adj
   END as x,
   ABS(x_adj) as y,
   CASE
      WHEN xG IS NULL THEN 1
      WHEN xG <.1 THEN 0.25
      ELSE (xG*3)
   END as size,
   *
FROM pbp
WHERE
   skater_id = '${params.ID}'
AND
   season = '${inputs.shot_season.value}'
AND
   event_type IN ${inputs.event_options.value}
AND
   team = '${inputs.shot_team.value}'
AND
   strength_state IN ${inputs.strength_options_2.value}
ORDER BY
   game_date asc, event_num asc
```

```sql shot_types   
SELECT 
   shot_type as "name",
   COUNT(event_type) as "value"
FROM ${plays} 
GROUP BY
   shot_type
```

```sql event_string
SELECT
    STRING_AGG(event_type, ',') as string
FROM
    (SELECT DISTINCT event_type FROM pbp WHERE event_type IN ${inputs.event_options.value})
```

```sql strength_string
SELECT
    STRING_AGG(strength_state, ',') as string
FROM
    (SELECT DISTINCT strength_state FROM pbp WHERE strength_state IN ${inputs.strength_options_2.value})
```

# <center> <Value data={stats} column=Player /> </center>
<center><img src={headshot[0].head} class="h-50" /></center>

<DataTable data={bio} sortable=False/>

<h1>Player Metrics Viewer</h1>
<br>
<h1 style="font-size:90%;">Season Stats</h1>

<Dropdown
   data={strengths}
   name=strength_options
   value=Strength
   title=Strength
   defaultValue="All"
/>

<Dropdown name=span_options title=Span multiple=true defaultValue=2>
	<DropdownOption valueLabel="Regular" value=2 />
	<DropdownOption valueLabel="Playoffs" value=3 />
</Dropdown>

<Dropdown name=display title=Display defaultValue=1>
	<DropdownOption valueLabel="Total" value=1 />
	<DropdownOption valueLabel="Rates" value=2 />
</Dropdown>

<Dropdown name=type title=Type defaultValue=1>
	<DropdownOption valueLabel="Individual" value=1 />
	<DropdownOption valueLabel="On-Ice" value=2 />
	<DropdownOption valueLabel="Goal Impact" value=3 />
</Dropdown>

{#if inputs.display.value == 1}

{#if inputs.type.value == 1}
<DataTable data={stats} rows=50 search=true rowShading=true headerColor=#0000ff headerFontColor=white>
   <Column id=Season align=center fmt='####-####' />
   <Column id=SpanText align=center title="Span"/>
	<Column id=teamLogo align=center contentType="image" height=20px title="Logo"/>
	<Column id=Team align=center />
   <Column id=Age align=center />
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
	<Column id=Block align=center title="Blocks"/>
</DataTable>
{:else if inputs.type.value == 2}
<DataTable data={stats} rows=50 search=true rowShading=true headerColor=#0000ff headerFontColor=white>
   <Column id=Season align=center fmt='####-####' />
   <Column id=SpanText align=center title="Span"/>
	<Column id=teamLogo align=center contentType="image" height=20px title="Logo"/>
	<Column id=Team align=center />
   <Column id=Age align=center />
	<Column id=GP align=center title="GP"/>
   <Column id=TOI align=center title="TOI" fmt='#,###.#0' />
	<Column id=GF align=center title="GF"/>
   <Column id=GA align=center title="GA"/>
	<Column id=FF align=center title="FF"/>
   <Column id=FA align=center title="FA"/>
   <Column id=xGF align=center title="xGF"/>
   <Column id=xGA align=center title="xGA"/>
   <Column id=xGF/FF align=center title="xGF/FF"/>
   <Column id=xGA/FA align=center title="xGA/FA"/>
   <Column id=GF/xGF align=center title="GF/xGF"/>
   <Column id=GF% align=center title="GF%" fmt='##.00%' />
   <Column id=FF% align=center title="FF%" fmt='##.00%' />
   <Column id=xGF% align=center title="xGF%" fmt='##.00%' />
</DataTable>
{:else }
<DataTable data={stats} rows=50 search=true rowShading=true headerColor=#0000ff headerFontColor=white>
   <Column id=Season align=center fmt='####-####' />
   <Column id=SpanText align=center title="Span"/>
	<Column id=teamLogo align=center contentType="image" height=20px title="Logo"/>
	<Column id=Team align=center />
   <Column id=Age align=center />
   <Column id=GP align=center title="GP"/>
   <Column id=TOI align=center title="TOI" fmt='#,###.#0' />
   <Column id=INDV-SRI-T align=center title="Shot Rate Impact" fmt='#0.####' />
   <Column id=INDV-SQI-T align=center title="Shot Quality Impact" fmt='#0.####' />
   <Column id=INDV-FNI-T align=center title="Finishing Impact" fmt='#0.####' />
   <Column id=OOFF-SRI-T align=center title="On-Ice Shot Rate Impact For" fmt='#0.####' />
   <Column id=OOFF-SQI-T align=center title="On-Ice Shot Quality Impact For" fmt='#0.####' />
   <Column id=OOFF-FNI-T align=center title="On-Ice Finishing Impact For" fmt='#0.####' />
   <Column id=ODEF-SRI-T align=center title="On-Ice Shot Rate Impact Against" fmt='#0.####' />
   <Column id=ODEF-SQI-T align=center title="On-Ice Shot Quality Impact Against" fmt='#0.####' />
   <Column id=ODEF-FNI-T align=center title="On-Ice Finishing Impact Against" fmt='#0.####' />
   <Column id=EGi-T align=center title="Extraneous G" fmt='#0.####' />
   <Column id=EGF-T align=center title="Extraneous GF" fmt='#0.####' />
   <Column id=EGA-T align=center title="Extraneous GA" fmt='#0.####' />
   <Column id=ExGi-T align=center title="Extraneous ixG" fmt='#0.####' />
   <Column id=ExGF-T align=center title="Extraneous xGF" fmt='#0.####' />
   <Column id=ExGA-T align=center title="Extraneous xGA" fmt='#0.####' />
   <Column id=LiEG-T align=center title="Linemate Extraneous GF" fmt='#0.####' />
   <Column id=LiGIn-T align=center title="Goal Induction" fmt='#0.####' />
   <Column id=CompGI-T align=center title="Composite Goal Impact" fmt='#0.####' />
   <Column id=LiRelGI-T align=center title="Linemate Rel. Goal Impact" fmt='#0.####' />
</DataTable>
{/if}


{:else }
{#if inputs.type.value == 1}
<DataTable data={stats} rows=50 search=true rowShading=true headerColor=#0000ff headerFontColor=white>
   <Column id=Season align=center fmt='####-####' />
   <Column id=SpanText align=center title="Span"/>
	<Column id=teamLogo align=center contentType="image" height=20px title="Logo"/>
	<Column id=Team align=center />
   <Column id=Age align=center />
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
   <Column id=Block/60 align=center title="Blocks/60"/>	
</DataTable>
{:else if inputs.type.value == 2}
<DataTable data={stats} rows=50 search=true rowShading=true headerColor=#0000ff headerFontColor=white>
   <Column id=Season align=center fmt='####-####' />
   <Column id=SpanText align=center title="Span"/>
	<Column id=teamLogo align=center contentType="image" height=20px title="Logo"/>
	<Column id=Team align=center />
   <Column id=Age align=center />
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
<DataTable data={stats} rows=50 search=true rowShading=true headerColor=#0000ff headerFontColor=white>
   <Column id=Season align=center fmt='####-####' />
   <Column id=SpanText align=center title="Span"/>
	<Column id=teamLogo align=center contentType="image" height=20px title="Logo"/>
	<Column id=Team align=center />
   <Column id=Age align=center />
   <Column id=GP align=center title="GP"/>
   <Column id=TOI align=center title="TOI" fmt='#,###.#0' />
   <Column id=INDV-SRI align=center title="Shot Rate Impact" fmt='#0.####' />
   <Column id=INDV-SQI align=center title="Shot Quality Impact" fmt='#0.####' />
   <Column id=INDV-FNI align=center title="Finishing Impact" fmt='#0.####' />
   <Column id=OOFF-SRI align=center title="On-Ice Shot Rate Impact For" fmt='#0.####' />
   <Column id=OOFF-SQI align=center title="On-Ice Shot Quality Impact For" fmt='#0.####' />
   <Column id=OOFF-FNI align=center title="On-Ice Finishing Impact For" fmt='#0.####' />
   <Column id=ODEF-SRI align=center title="On-Ice Shot Rate Impact Against" fmt='#0.####' />
   <Column id=ODEF-SQI align=center title="On-Ice Shot Quality Impact Against" fmt='#0.####' />
   <Column id=ODEF-FNI align=center title="On-Ice Finishing Impact Against" fmt='#0.####' />
   <Column id=EGi align=center title="Extraneous G" fmt='#0.####' />
   <Column id=EGF align=center title="Extraneous GF" fmt='#0.####' />
   <Column id=EGA align=center title="Extraneous GA" fmt='#0.####' />
   <Column id=ExGi align=center title="Extraneous ixG" fmt='#0.####' />
   <Column id=ExGF align=center title="Extraneous xGF" fmt='#0.####' />
   <Column id=ExGA align=center title="Extraneous xGA" fmt='#0.####' />
   <Column id=LiEG align=center title="Linemate Extraneous GF" fmt='#0.####' />
   <Column id=LiGIn align=center title="Goal Induction" fmt='#0.####' />
   <Column id=CompGI align=center title="Composite Goal Impact" fmt='#0.####' />
   <Column id=LiRelGI align=center title="Linemate Rel. Goal Impact" fmt='#0.####' />
</DataTable>
{/if}

{/if}

<h1 style="font-size:90%;">Game Log</h1>
{#if inputs.type.value == 1}
<DataTable data={log} rows=10 search=true rowShading=true headerColor=#0000ff headerFontColor=white sort=game_date downloadable=false>
   <Column id=game_title title='Game'/>
   <Column id=game_date title='Date'/>
   <Column id=teamLogo title='Logo' contentType='image'/>
   <Column id=Team/>
   <Column id=TOI title='TOI'/>
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
   <Column id=Block align=center title="Blocks"/>
</DataTable>
{:else }
<DataTable data={log} rows=10 search=true rowShading=true headerColor=#0000ff headerFontColor=white sort=game_date downloadable=false>
   <Column id=game_title title='Game'/>
   <Column id=game_date title='Date'/>
   <Column id=teamLogo title='Logo' contentType='image'/>
   <Column id=Team/>
   <Column id=TOI title='TOI'/>
   <Column id=GF align=center title="GF"/>
   <Column id=GA align=center title="GA"/>
   <Column id=FF align=center title="FF"/>
   <Column id=FA align=center title="FA"/>
   <Column id=xGF align=center title="xGF"/>
   <Column id=xGA align=center title="xGA"/>
   <Column id=xGF/FF align=center title="xGF/FF"/>
   <Column id=xGA/FA align=center title="xGA/FA"/>
   <Column id=GF/xGF align=center title="GF/xGF"/>
   <Column id=GF% align=center title="GF%" fmt='##.00%' />
   <Column id=FF% align=center title="FF%" fmt='##.00%' />
   <Column id=xGF% align=center title="xGF%" fmt='##.00%' />
</DataTable>
{/if}

<br>
<h1 style="font-size:90%;">Shot Profile</h1>
<h1 style="font-size:70%;">Percentiles at 5v5 and relative to player position (minimum TOI is 150 minutes at 5v5)</h1>

<Dropdown
   data={strengths_multiple}
   name=strength_options_2
   value=Strength
   title=Strength
   defaultValue="5v5"
	multiple=true
/>

<Dropdown
    data={seasons}
    name=shot_season
    value=Season
	 title=Season
    defaultValue="20242025"
/>

<Dropdown
    data={teams}
    name=shot_team
    value=Team
	 title=Team
/>

<BarChart 
    data={shot_profile}
    x=metric
    y=value
    series=Strength
    yMax=100
    swapXY=true
    type=grouped
    downloadableData=False
    colorPalette={[color[0].PC]}
/>

<Dropdown
      name=event_options
      value=event_type
      title=Event
      multiple=true
      selectAllByDefault=true
   >
      <DropdownOption valueLabel="missed-shot" value="missed-shot" />
      <DropdownOption valueLabel="shot-on-goal" value="shot-on-goal" />
      <DropdownOption valueLabel="goal" value="goal" />
   </Dropdown>

<div style="display:flex; justify-content: space-between;">
   <div style="width:500px;">
      <iframe height="300" width="100%" frameborder="no" src="https://019705fe-b231-f422-21c2-b5de4097884e.share.connect.posit.cloud?skater={params.ID.slice(0,7)}&season={inputs.shot_season.value}&team={inputs.shot_team.value}&event_type={event_string[0].string}&strength_state={strength_string[0].string}"></iframe>
   </div>
   <div style="width:400px; align:center;">
      <ECharts config={
         {
            title:{
               text: "Shot Type Composition"
            },
            tooltip: {
                  formatter: '{b}: {c} ({d}%)'
            },
            series: [
            {
               type: 'pie',
               radius: ['40%', '70%'],
               data: [...shot_types],
            }
            ]
            }
         }
      />
   </div>
   <div style="width:550px">
      <DataTable data={plays} rows=10 search=true rowShading=true headerColor=#0000ff headerFontColor=white compact=true downloadable=false title="Shot Table">
      <Column id=game_date align=center title="Date"/>
      <Column id=game_title align=center title="Game"/>
      <Column id=period align=center/>
      <Column id=seconds_elapsed align=center title="Seconds"/>
      <Column id=strength_state align=center/>
      <Column id=event_type align=center title="Event"/>
      <Column id=description align=center/>
      <Column id=shot_type align=center/>
      <Column id=away_score align=center/>
      <Column id=home_score align=center/>
      <Column id=xG align=center title="xG"/>
   </DataTable>
   </div>
</div>
<br>
<h1 style="font-size:90%;">On-Ice Shot Heatmaps</h1>
<h1 style="font-size:70%;">Left-to-Right is Defense-to-Offense for fenwick shots that occur with skater on the ice (weighted by xG).  Blue represents more shots, while red represents fewer.</h1>

<iframe height="400" width="100%" frameborder="no" src="https://01970a6d-a49b-7316-dc75-dcf146792524.share.connect.posit.cloud/?skater={params.ID.slice(0,7)}&season={inputs.shot_season.value}&team={inputs.shot_team.value}&strength_state={strength_string[0].string}"></iframe>

<h1 style="font-size:70%;">If heatmap content fails to load with selected filters refresh the page.</h1>