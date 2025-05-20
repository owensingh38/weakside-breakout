---
title: Player Stats
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
   info.teamLogo,
   *
FROM skater
RIGHT JOIN info
   ON info.triCode=skater.Team AND info.seasonId=skater.Season
WHERE
   ID = '${params.ID}'
AND
   Strength IN ${inputs.strength_options.value}
```

```sql shot_profile
SELECT
    'Shot Rate' as metric, ("INDV-SR"*100) as value
FROM skater
WHERE
   ID = '${params.ID}' 
AND
   Season = '${inputs.shot_season.value}'
AND
   Team = '${inputs.shot_team.value}'
UNION ALL
SELECT
    'Shot Quality' as metric, ("INDV-SQ"*100) as value
FROM skater
WHERE
   ID = '${params.ID}' 
AND
   Season = '${inputs.shot_season.value}'
AND
   Team = '${inputs.shot_team.value}'
UNION ALL
SELECT
    'Finishing' as metric, ("INDV-FN"*100) as value
FROM skater
WHERE
   ID = '${params.ID}' 
AND
   Season = '${inputs.shot_season.value}'
AND
   Team = '${inputs.shot_team.value}'
UNION ALL
SELECT
    'Goal Induction' as metric, ("LiGIn-P"*100) as value
FROM skater
WHERE
   ID = '${params.ID}' 
AND
   Season = '${inputs.shot_season.value}'
AND
   Team = '${inputs.shot_team.value}'
UNION ALL
SELECT
    'Goals' as metric, ("Gi/60-P"*100) as value
FROM skater
WHERE
   ID = '${params.ID}' 
AND
   Season = '${inputs.shot_season.value}'
AND
   Team = '${inputs.shot_team.value}'
UNION ALL
SELECT
    'xGoals' as metric, ("xGi/60-P"*100) as value
FROM skater
WHERE
   ID = '${params.ID}' 
AND
   Season = '${inputs.shot_season.value}'
AND
   Team = '${inputs.shot_team.value}'
```

```sql timeline
SELECT
    Age, 'Shot Rate' as metric, "INDV-SRI" as value
FROM skater
WHERE
   ID = '${params.ID}' 
AND
   TOI >= 150
UNION ALL
SELECT
    Age, 'Shot Quality' as metric, "INDV-SQI" as value
FROM skater
WHERE
   ID = '${params.ID}' 
AND
   TOI >= 150
UNION ALL
SELECT
    Age, 'Finishing' as metric, "INDV-FNI" as value
FROM skater
WHERE
   ID = '${params.ID}'
AND
   TOI >= 150 
UNION ALL
SELECT
    Age, 'Goal Induction' as metric, "LiGIn" as value
FROM skater
WHERE
   ID = '${params.ID}' 
AND
   TOI >= 150
UNION ALL
SELECT
    Age, 'Goals' as metric, "Gi/60" as value
FROM skater
WHERE
   ID = '${params.ID}' 
AND
   TOI >= 150
UNION ALL
SELECT
    Age, 'xGoals' as metric, "xGi/60" as value
FROM skater
WHERE
   ID = '${params.ID}' 
AND
   TOI >= 150
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

```sql plays
SELECT
   season,
   game_id,
   game_date,
   game_title,
   event_num,
   "period",
   seconds_elapsed,
   event_type,
   CASE
      WHEN event_type IN ('missed-shot','shot-on-goal','goal') THEN "description" || ' - xG: ' || SUBSTRING(("xG"*100),1,5) || '%'
      ELSE "description"
   END as "description",
   '/players/' || skater_id as playerLink,
   strength_state,
   team,
   skater_id,
   skater_id_2,
   skater_id_3,
   shot_type,
   zone_code,
   -(y_fixed) as x,
   (x_fixed) as y,
   away_score,
   home_score,
   away_on_1_id,away_on_2_id,away_on_3_id,away_on_4_id,away_on_5_id,away_on_6_id,away_goalie_id,
   home_on_1_id,home_on_2_id,home_on_3_id,home_on_4_id,home_on_5_id,home_on_6_id,home_goalie_id,
   seconds_since_last,
   xG,
   CASE
      WHEN xG IS NULL THEN 1
      WHEN xG <.1 THEN 0.25
      ELSE (xG*3)
   END as size
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
   strength_state IN ${inputs.strength_options.value}
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

# <center> <Value data={stats} column=Player /> </center>
<center><img src={headshot[0].head} class="h-50" /></center>

<DataTable data={bio}/>

<h1>Player Metrics Viewer</h1>
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
	<DropdownOption valueLabel="Individual" value=1 />
	<DropdownOption valueLabel="On-Ice" value=2 />
	<DropdownOption valueLabel="Goal Impact" value=3 />
</Dropdown>

{#if inputs.display.value == 1}

{#if inputs.type.value == 1}
<DataTable data={stats} rows=50 search=true rowShading=true headerColor=#0000ff headerFontColor=white>
   <Column id=Season align=center fmt='####-####' />
	<Column id=teamLogo align=center contentType="image" height=20px title="Logo"/>
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
	<Column id=Block align=center title="Blocks"/>
</DataTable>
{:else if inputs.type.value == 2}
<DataTable data={stats} rows=50 search=true rowShading=true headerColor=#0000ff headerFontColor=white>
   <Column id=Season align=center fmt='####-####' />
	<Column id=teamLogo align=center contentType="image" height=20px title="Logo"/>
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
   <Column id=teamLogo align=center contentType="image" height=20px title="Logo"/>
   <Column id=Team align=center />
   <Column id=Position align=center />
   <Column id=Age align=center />
   <Column id=Nationality align=center />
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
   <Column id=teamLogo align=center contentType="image" height=20px title="Logo"/>
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
   <Column id=Block/60 align=center title="Blocks/60"/>	
</DataTable>
{:else if inputs.type.value == 2}
<DataTable data={stats} rows=50 search=true rowShading=true headerColor=#0000ff headerFontColor=white>
   <Column id=Season align=center fmt='####-####' />
   <Column id=teamLogo align=center contentType="image" height=20px title="Logo"/>
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
<DataTable data={stats} rows=50 search=true rowShading=true headerColor=#0000ff headerFontColor=white>
   <Column id=Season align=center fmt='####-####' />
   <Column id=teamLogo align=center contentType="image" height=20px title="Logo"/>
   <Column id=Team align=center />
   <Column id=Position align=center />
   <Column id=Age align=center />
   <Column id=Nationality align=center />
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

<br>
<h1 style="font-size:90%;">Shot Profile</h1>
<h1 style="font-size:70%;">Percentiles at 5v5 and relative to player position (minimum TOI is 150 minutes at 5v5)</h1>

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
    yMax=100
    swapXY=true
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
      <BubbleChart
         data={plays}
         x=x
         y=y
         size=size
         title="Shot Chart"
         tooltipTitle=description
         outlineWidth = 2
         outlineColor = #FFFFFF
         xMin = -42.5
         xMax = 42.5
         yMin = 0
         yMax = 100
         xAxisLabels=False
         yAxisLabels=False
         xGridlines=False
         yGridlines=False
         xTickMarks=False
         yTickMarks=False
         xBaseline=False
         yBaseline=False
         emptySet=warn
         emptyMessage='Select a season and a team...'
         downloadableImage=true
         downloadableData=false
         chartAreaHeight=320
         colorPalette={[color[0].PC]}
      >
         <ReferenceLine
            x=-42.5
            y=0
            x2=42.5
            color=red
            hideValue=true
            lineWidth=3 lineType=solid/
            opacity=0.25
         />
         <ReferenceLine
            x=-42.5
            y=89
            x2=42.5
            color=red
            hideValue=true
            lineWidth=3 lineType=solid/
            opacity=0.25
         />
         <ReferenceLine
            x=-42.5
            y=24
            x2=42.5
            color=blue
            hideValue=true
            lineWidth=3 lineType=solid/
         />
         <ReferencePoint
            x=22.5
            y=14
            color=red
            symbolSize=15
            symbolOpacity=0.25
         />
         <ReferencePoint
            x=-22.5
            y=14
            color=red
            symbolSize=15
            symbolOpacity=0.25
         />
         <ReferencePoint
            x=22.5
            y=70
            color=red
            symbolSize=40
            symbolOpacity=0.25
                  />
         <ReferencePoint
            x=-22.5
            y=70
            color=red
            symbolSize=40
            symbolOpacity=0.25
         />
         <ReferenceLine
            x=3
            y=89
            x2=3
            y2=96
            color=red
            hideValue=true
            lineWidth=3 lineType=solid/
         />
         <ReferenceLine
            x=-3
            y=89
            x2=-3
            y2=96
            color=red
            hideValue=true
            lineWidth=3 lineType=solid/
         />
         <ReferenceLine
            x=3
            y=96
            x2=-3
            y2=96
            color=red
            hideValue=true
            lineWidth=3 lineType=solid/
         />
         <ReferenceLine
            x=-4
            y=89
            x2=-4
            y2=83
            color=red
            hideValue=true
            lineWidth=3 lineType=solid/
         />
         <ReferenceLine
            x=4
            y=89
            x2=4
            y2=83
            color=red
            hideValue=true
            lineWidth=3 lineType=solid/
         />
         <ReferenceLine
            x=4
            y=83
            x2=-4
            y2=83
            color=red
            hideValue=true
            lineWidth=3 lineType=solid/
         />
         <ReferenceArea xMin=-3 xMax=3 areaColor=blue yMin=83 yMax=89 opacity=0.25/>
      </BubbleChart>
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

