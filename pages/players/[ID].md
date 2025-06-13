---
title: Skater Stats
hide_title: true
---

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

```sql player
SELECT *
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
   p.*
FROM ${player} as p
RIGHT JOIN info
   ON info.triCode=p.Team AND info.seasonId=p.Season
WHERE
   Strength = '${inputs.strength_options.value}'
AND
   Span IN ${inputs.span_options.value}
```

```sql log
SELECT info.teamLogo as oppLogo, pre_log.*
FROM (SELECT
         SUBSTRING(t.game_title,1,9) as game_title,
         t.date as game_date,
         info.teamLogo,
         (A1+A2) as "A",
         CASE WHEN
            t.home_team_abbr=game_log.Team THEN away_team_abbr ELSE home_team_abbr
         END as Opp,
         game_log.*
      FROM game_log
      LEFT JOIN schedule as t
         ON game_log.Game=t.id
      LEFT JOIN info
         ON game_log.Team=info.triCode AND game_log.Season=info.seasonId
      WHERE
         game_log.ID = '${params.ID}'
         AND Strength = '${inputs.strength_options.value}'
         AND Span IN ${inputs.span_options.value}
         AND game_log.Season = '${inputs.season_options.value}'
   ) as pre_log
LEFT JOIN info
   ON pre_log.Opp=info.triCode AND pre_log.Season=info.seasonId
```

```sql shot_types   
SELECT name, sum(value) as value
FROM (
      (
         SELECT 
            'wrist' as name,
            WristFi as value,
         FROM skater
         WHERE
            ID = '${params.ID}'
            AND Season = '${inputs.shot_season.value}'
            AND Team = '${inputs.shot_team.value}'
            AND Strength IN ${inputs.strength_options_2.value}
            AND Span = '${inputs.span_options_2.value}'
      )
      UNION ALL
      (
         SELECT 
            'deflected' as name,
            DeflectedFi as value,
         FROM skater
         WHERE
            ID = '${params.ID}'
            AND Season = '${inputs.shot_season.value}'
            AND Team = '${inputs.shot_team.value}'
            AND Strength IN ${inputs.strength_options_2.value}
            AND Span = '${inputs.span_options_2.value}'
      )
      UNION ALL
      (
         SELECT 
            'tip-in' as name,
            "Tip-inFi" as value,
         FROM skater
         WHERE
            ID = '${params.ID}'
            AND Season = '${inputs.shot_season.value}'
            AND Team = '${inputs.shot_team.value}'
            AND Strength IN ${inputs.strength_options_2.value}
            AND Span = '${inputs.span_options_2.value}'
      )
      UNION ALL
      (
         SELECT 
            'slap' as name,
            SlapFi as value,
         FROM skater
         WHERE
            ID = '${params.ID}'
            AND Season = '${inputs.shot_season.value}'
            AND Team = '${inputs.shot_team.value}'
            AND Strength IN ${inputs.strength_options_2.value}
            AND Span = '${inputs.span_options_2.value}'
      )
      UNION ALL
      (
         SELECT 
            'backhand' as name,
            BackhandFi as value,
         FROM skater
         WHERE
            ID = '${params.ID}'
            AND Season = '${inputs.shot_season.value}'
            AND Team = '${inputs.shot_team.value}'
            AND Strength IN ${inputs.strength_options_2.value}
            AND Span = '${inputs.span_options_2.value}'
      )
      UNION ALL
      (
         SELECT 
            'snap' as name,
            SnapFi as value,
         FROM skater
         WHERE
            ID = '${params.ID}'
            AND Season = '${inputs.shot_season.value}'
            AND Team = '${inputs.shot_team.value}'
            AND Strength IN ${inputs.strength_options_2.value}
            AND Span = '${inputs.span_options_2.value}'
      )
      UNION ALL
      (
         SELECT 
            'wrap-around' as name,
            "Wrap-AroundFi" as value,
         FROM skater
         WHERE
            ID = '${params.ID}'
            AND Season = '${inputs.shot_season.value}'
            AND Team = '${inputs.shot_team.value}'
            AND Strength IN ${inputs.strength_options_2.value}
            AND Span = '${inputs.span_options_2.value}'
      )
      UNION ALL
      (
         SELECT 
            'poke' as name,
            PokeFi as value,
         FROM skater
         WHERE
            ID = '${params.ID}'
            AND Season = '${inputs.shot_season.value}'
            AND Team = '${inputs.shot_team.value}'
            AND Strength IN ${inputs.strength_options_2.value}
            AND Span = '${inputs.span_options_2.value}'
      )
      UNION ALL
      (
         SELECT 
            'bat' as name,
            BatFi as value,
         FROM skater
         WHERE
            ID = '${params.ID}'
            AND Season = '${inputs.shot_season.value}'
            AND Team = '${inputs.shot_team.value}'
            AND Strength IN ${inputs.strength_options_2.value}
            AND Span = '${inputs.span_options_2.value}'
      )
      UNION ALL
      (
         SELECT 
            'cradle' as name,
            CradleFi as value,
         FROM skater
         WHERE
            ID = '${params.ID}'
            AND Season = '${inputs.shot_season.value}'
            AND Team = '${inputs.shot_team.value}'
            AND Strength IN ${inputs.strength_options_2.value}
            AND Span = '${inputs.span_options_2.value}'
      )
      UNION ALL
      (
         SELECT 
            'between-legs' as name,
            "Between-legsFi" as value,
         FROM skater
         WHERE
            ID = '${params.ID}'
            AND Season = '${inputs.shot_season.value}'
            AND Team = '${inputs.shot_team.value}'
            AND Strength IN ${inputs.strength_options_2.value}
            AND Span = '${inputs.span_options_2.value}'
      )
   )
WHERE
   value > 0
GROUP BY "name"
```

```sql event_string
SELECT
    STRING_AGG(event_type, ',') as string
FROM
    (SELECT DISTINCT event_type FROM events WHERE event_type IN ${inputs.event_options.value})
```

```sql strength_string
SELECT
    STRING_AGG(strength_state, ',') as string
FROM
   (SELECT DISTINCT
      CASE WHEN
         strength_state IN ('5v5','5v4','4v5') THEN strength_state ELSE 'Other' END as strength_state
   FROM strengths
   )
WHERE 
   strength_state IN ${inputs.strength_options_2.value}
```

<div style="margin: 10px;">
   <div style="text-align: center;">
		<b><h1 style="font-size:50px">{stats[0].Player}</h1></b>
	</div>
   <center><img src={headshot[0].head} class="h-50" /></center>

   <DataTable data={bio} sortable=False/>

   <h1>Player Metrics Viewer</h1>
   <br>
   <h1 style="font-size:90%;">Season Stats</h1>

   <Dropdown
      data={player}
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
   <Dropdown
      data={player}
      name=season_options
      value=Season
      title=Season
      defaultValue={20242025}
   />
   {#if inputs.type.value == 1}
   <DataTable data={log} rows=10 search=true rowShading=true headerColor=#0000ff headerFontColor=white sort=game_date downloadable=false>
      <Column id=game_title title='Game'/>
      <Column id=game_date title='Date'/>
      <Column id=teamLogo title='Logo' contentType='image' height=20px/>
      <Column id=Team/>
      <Column id=oppLogo title='Opp.Logo' contentType='image' height=20px/>
      <Column id=Opp title='Opponent'/>
      <Column id=TOI title='TOI'/>
      <Column id=Gi align=center title="G"/>
      <Column id=A1 align=center />
      <Column id=A2 align=center />
      <Column id=A align=center />
      <Column id=P align=center />
      <Column id=Fi align=center title="iFF"/>
      <Column id=xGi align=center title="ixG"/>
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
      <Column id=teamLogo title='Logo' contentType='image' height=20px/>
      <Column id=Team/>
      <Column id=oppLogo title='Opp.Logo' contentType='image' height=20px/>
      <Column id=Opp title='Opponent'/>
      <Column id=TOI title='TOI'/>
      <Column id=GF align=center title="GF"/>
      <Column id=GA align=center title="GA"/>
      <Column id=FF align=center title="FF"/>
      <Column id=FA align=center title="FA"/>
      <Column id=xGF align=center title="xGF"/>
      <Column id=xGA align=center title="xGA"/>
      <Column id=GF% align=center title="GF%" fmt='##.00%' />
      <Column id=FF% align=center title="FF%" fmt='##.00%' />
      <Column id=xGF% align=center title="xGF%" fmt='##.00%' />
   </DataTable>
   {/if}

   <br>
   <h1 style="font-size:90%;">Shot Profile</h1>

   <Dropdown
      data={player}
      name=strength_options_2
      value=Strength
      title=Strength
      defaultValue="5v5"
      multiple=true
   />

   <Dropdown
      data={player}
      name=shot_season
      value=Season
      title=Season
      defaultValue={20242025}
   />

   <Dropdown
      data={player.where(`Season = '${inputs.shot_season.value}'`)}
      name=shot_team
      value=Team
      title=Team
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

   <Dropdown name=span_options_2 title=Span defaultValue=2>
      <DropdownOption valueLabel="Regular" value=2 />
      <DropdownOption valueLabel="Playoffs" value=3 />
   </Dropdown>

   <div style="display:flex; justify-content: space-between;">
      <div style="width:500px;">
         <iframe height="300" width="100%" frameborder="no" src="https://019705fe-b231-f422-21c2-b5de4097884e.share.connect.posit.cloud?skater={params.ID.slice(0,7)}&season={inputs.shot_season.value}&team={inputs.shot_team.value}&event_type={event_string[0].string}&strength_state={strength_string[0].string}&strength_state={strength_string[0].string}&season_type={inputs.span_options_2.value}"></iframe>
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
   </div>
   <br>
   <h1 style="font-size:90%;">On-Ice Shot Heatmaps</h1>
   <h1 style="font-size:70%;">Left-to-Right is Defense-to-Offense for fenwick shots that occur with skater on the ice (weighted by xG).  Blue represents higher xG in that location compared to league average, while Red represents fewer xG in that location compared to league average.</h1>
   <iframe height="400" width="100%" frameborder="no" src="https://01970a6d-a49b-7316-dc75-dcf146792524.share.connect.posit.cloud/?skater={params.ID.slice(0,7)}&season={inputs.shot_season.value}&team={inputs.shot_team.value}&strength_state={strength_string[0].string}&season_type={inputs.span_options_2.value}"></iframe>
   <h1 style="font-size:70%;">If heatmap content fails to load with selected filters refresh the page.</h1>
</div>