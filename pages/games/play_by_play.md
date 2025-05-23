---
title: Play-by-Play
---

```sql plays
SELECT 
    season,
    game_id,
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
    venue,
    skater_id,
    skater_id_2,
    skater_id_3,
    shot_type,
    zone_code,
    x_adj as x,
    y_adj as y,
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
    END as size,
    info.teamLogo as logo,
    names.Player as "name",
FROM 
    pbp
LEFT JOIN info
    ON pbp.team=info.triCode AND pbp.season=info.seasonId
LEFT JOIN names
    ON pbp.skater_id=names.ID
WHERE
    game_title = '${inputs.game_options.value}'
AND
    event_type IN ${inputs.event_options.value}
AND
    strength_state IN ${inputs.strength_options.value}
AND
    team IS NOT NULL
```

```sql timelines
SELECT
    team,seconds_elapsed,
    SUM(CASE WHEN event_type='goal' THEN 1 ELSE 0 END) OVER (PARTITION by team ORDER BY seconds_elapsed) as Goals,
    SUM(CASE WHEN event_type IN ('shot-on-goal','goal') THEN 1 ELSE 0 END) OVER (PARTITION by team ORDER BY seconds_elapsed) as Shots,
    SUM(CASE WHEN event_type IN ('missed-shot','shot-on-goal','goal') THEN 1 ELSE 0 END) OVER (PARTITION by team ORDER BY seconds_elapsed) as Fenwick,
    SUM(xG) OVER (PARTITION by team ORDER BY seconds_elapsed) as xGoals
FROM ${plays} p
```

```sql link
SELECT DISTINCT
    '/games/' || game_id as link
FROM pbp
WHERE
    game_title = '${inputs.game_options.value}'
```

```sql dates
SELECT DISTINCT 
	game_date
FROM pbp
```

```sql games
SELECT DISTINCT 
	game_title
FROM pbp
WHERE
    game_date = '${inputs.date.value}'
```

```sql events
SELECT DISTINCT 
	event_type
FROM pbp
WHERE
    event_type NOT IN ('change','challenge','EGPID','delayed-penalty','shootout-complete')
AND
    team IS NOT NULL
```

```sql strengths
SELECT DISTINCT 
	strength_state
FROM pbp
WHERE strength_state IN (
    '0v1',
    '1v0',
    '3v3',
    '3v4',
    '3v5',
    '3v6',
    '4v3',
    '4v4',
    '4v5',
    '4v6',
    '5v3',
    '5v4',
    '5v5',
    '5v6',
    '6v3',
    '6v4',
    '6v5'
)
```

```sql team_summary
SELECT
    p.*,info.teamLogo as logo
FROM
    (SELECT
        team as Team, 
        venue,
        season,
        SUM(CASE WHEN event_type IN ('goal') THEN 1 ELSE 0 END) as Goals,
        SUM(CASE WHEN event_type IN ('shot-on-goal','goal') THEN 1 ELSE 0 END) as Shots,
        SUM(CASE WHEN event_type IN ('missed-shot','shot-on-goal','goal') THEN 1 ELSE 0 END) as Fenwick,
        SUM(xG) as xG,
        SUM(CASE WHEN event_type IN ('giveaway') THEN 1 ELSE 0 END) as Giveaways,
        SUM(CASE WHEN event_type IN ('takeaway') THEN 1 ELSE 0 END) as Takeaways,
        SUM(CASE WHEN event_type IN ('hit') THEN 1 ELSE 0 END) as Hits
    FROM pbp as p
    WHERE game_title = '${inputs.game_options.value}'
    AND strength_state IN ${inputs.strength_options.value}
    GROUP BY team, venue, season, game_id) as p
LEFT JOIN info
    ON p.team=info.triCode AND p.season=info.seasonId
ORDER BY
    venue asc
```

<DateInput
    name=date
    data={dates}
    dates=game_date
    defaultValue="2025-05-01"
/>

<Dropdown
    data={games}
    name=game_options
    value=game_title
	title=Game
/>

<Dropdown
    data={events}
    name=event_options
    value=event_type
	title=Event
    multiple=true
    selectAllByDefault=true
/>

<Dropdown
    data={strengths}
    name=strength_options
    value=strength_state
	title=Strength
    multiple=true
    selectAllByDefault=true
/>

<div style="position: relative; display: flex; flex-direction:row;align-itmes: center; height: 230px;">
    <Image url={team_summary[0].logo} width=400 height=200/>
    <div style="width: 600px; transform: translateY(-10px); ">
        <BubbleChart 
            data={plays}
            x=x
            y=y
            series=team
            size=size
            tooltipTitle=description
            outlineWidth = 2
            outlineColor = #FFFFFF
            xMin = -100
            xMax = 100
            yMin = -42.5
            yMax = 42.5
            xAxisLabels=False
            yAxisLabels=False
            xGridlines=False
            yGridlines=False
            xTickMarks=False
            yTickMarks=False
            xBaseline=False
            yBaseline=False
            emptySet=warn
            emptyMessage='Select a date(s) and a game(s)'
            downloadableImage=true
            downloadableData=false
            seriesColors={{'ANA': '#F47A38', 'ATL': '#5C88DA', 'BOS': '#FFB81C', 'BUF': '#003087', 'CGY': '#D2001C', 'CAR': '#CE1126', 'CHI': '#CF0A2C', 'COL': '#6F263D', 'CBJ': '#002654', 'DAL': '#006847', 'DET': '#CE1126', 'EDM': '#041E42', 'FLA': '#C8102E', 'LAK': '#A2AAAD', 'MIN': '#154734', 'MTL': '#AF1E2D', 'NSH': '#FFB81C', 'NJD': '#CE1126', 'NYI': '#00539B', 'NYR': '#0038A8', 'OTT': '#DA1A32', 'PHI': '#F74902', 'PHX': '#8C2633', 'PIT': '#FCB514', 'SJS': '#006D75', 'STL': '#002F87', 'TBL': '#002868', 'TOR': '#00205B', 'VAN': '#00205B', 'WSH': '#C8102E', 'WPG': '#041E42', 'ARI': '#8C2633', 'VGK': '#B4975A', 'SEA': '#001628', 'UTA': '#69B3E7'}}
            chartAreaHeight=230
            echartsOptions={{xAxis: {
                                type: 'value',
                                min: -100,    
                                max: 100, 
                            },
                            yAxis: {
                                type: 'value',
                                min: -45,
                                max: 45
                            }
                            }}
            >
            <ReferenceLine
                x=-89
                color=red
                hideValue=true
                lineWidth=3 lineType=solid/
            />
            <ReferenceLine
                x=-24
                color=blue
                hideValue=true
                lineWidth=3 lineType=solid/
            />
            <ReferenceLine
                x=0
                color=red
                hideValue=true
                lineWidth=3 lineType=solid/
                opacity=0.25
            />
            <ReferenceLine
                x=24
                color=blue
                hideValue=true
                lineWidth=3 lineType=solid/
            />
            <ReferenceLine
                x=89
                color=red
                hideValue=true
                lineWidth=3 lineType=solid/
            />
            <ReferenceLine
                x=-89
                y=-4
                x2=-83
                y2=-4
                color=red
                hideValue=true
                lineWidth=3 lineType=solid/
            />
            <ReferenceLine
                x=-89
                y=4
                x2=-83
                y2=4
                color=red
                hideValue=true
                lineWidth=3 lineType=solid/
            />
            <ReferenceLine
                x=-83
                y=4
                x2=-83
                y2=-4
                color=red
                hideValue=true
                lineWidth=3 lineType=solid/
            />
            <ReferenceLine
                x=89
                y=-4
                x2=83
                y2=-4
                color=red
                hideValue=true
                lineWidth=3 lineType=solid/
            />
            <ReferenceLine
                x=89
                y=4
                x2=83
                y2=4
                color=red
                hideValue=true
                lineWidth=3 lineType=solid/
            />
            <ReferenceLine
                x=83
                y=4
                x2=83
                y2=-4
                color=red
                hideValue=true
                lineWidth=3 lineType=solid/
            />
            <ReferenceLine
                x=-89
                y=3
                x2=-93
                y2=3
                color=red
                hideValue=true
                lineWidth=3 lineType=solid/
            />
            <ReferenceLine
                x=-89
                y=-3
                x2=-93
                y2=-3
                color=red
                hideValue=true
                lineWidth=3 lineType=solid/
            />
            <ReferenceLine
                x=-93
                y=3
                x2=-93
                y2=-3
                color=red
                hideValue=true
                lineWidth=3 lineType=solid/
            />
            <ReferenceLine
                x=89
                y=3
                x2=93
                y2=3
                color=red
                hideValue=true
                lineWidth=3 lineType=solid/
            />
            <ReferenceLine
                x=89
                y=-3
                x2=93
                y2=-3
                color=red
                hideValue=true
                lineWidth=3 lineType=solid/
            />
            <ReferenceLine
                x=93
                y=3
                x2=93
                y2=-3
                color=red
                hideValue=true
                lineWidth=3 lineType=solid/
            />
            <ReferenceArea xMin=-89 xMax=-83 areaColor=blue yMin=-3 yMax=3 opacity=0.25/>
            <ReferenceArea xMin=83 xMax=89 areaColor=blue yMin=-3 yMax=3 opacity=0.25/>
            <ReferencePoint
                x=0
                y=0
                symbolSize=75
                symbolOpacity=0.25
                symbolBorderColor=red
                symbolBorderWidth=5
            />
            <ReferencePoint
                x=0
                y=0
                color=red
                symbolSize=15
                symbolOpacity=0.25
            />
            <ReferencePoint
                x=-20
                y=22.5
                color=red
                symbolSize=15
                symbolOpacity=0.25
            />
            <ReferencePoint
                x=-20
                y=-22
                color=red
                symbolSize=15
                symbolOpacity=0.25
            />
            <ReferencePoint
                x=20
                y=22
                color=red
                symbolSize=15
                symbolOpacity=0.25
            />
            <ReferencePoint
                x=20
                y=-22
                color=red
                symbolSize=15
                symbolOpacity=0.25
            />
            <ReferencePoint
                x=-69
                y=22
                symbolSize=75
                symbolOpacity=0.25
                symbolBorderColor=red
                symbolBorderWidth=5
            />
            <ReferencePoint
                x=-69
                y=-22
                symbolSize=75
                symbolOpacity=0.25
                symbolBorderColor=red
                symbolBorderWidth=5
            />
            <ReferencePoint
                x=69
                y=22
                symbolSize=75
                symbolOpacity=0.25
                symbolBorderColor=red
                symbolBorderWidth=5
            />
            <ReferencePoint
                x=69
                y=-22
                symbolSize=75
                symbolOpacity=0.25
                symbolBorderColor=red
                symbolBorderWidth=5
            />
            <ReferencePoint
                x=-69
                y=22
                color=red
                symbolSize=15
                symbolOpacity=0.25
            />
            <ReferencePoint
                x=-69
                y=-22
                color=red
                symbolSize=15
                symbolOpacity=0.25
            />
            <ReferencePoint
                x=69
                y=22
                color=red
                symbolSize=15
                symbolOpacity=0.25
            />
            <ReferencePoint
                x=69
                y=-22
                color=red
                symbolSize=15
                symbolOpacity=0.25
            />
        </BubbleChart>
    </div>
    <Image url={team_summary[1].logo} height=200/>
</div>
<br><br>
<DataTable data={team_summary} rows=50 rowShading=true headerColor=#0000ff headerFontColor=white downloadable=false>
    <Column id=logo align=center contentType=image height=20px/>
    <Column id=Team align=center />
    <Column id=Goals align=center/>
    <Column id=Shots align=center/>
	<Column id=Fenwick align=center/>
    <Column id=xG align=center title="xG"/>
    <Column id=Giveaways align=center/>
    <Column id=Takeaways align=center/>
    <Column id=Hits align=center/>
</DataTable>

<LinkButton url={link[0].link}>
Full Game Stats
</LinkButton>

<Dropdown name=data_options defaultValue=1>
	<DropdownOption valueLabel="Plays" value=1 />
	<DropdownOption valueLabel="Timelines" value=2 />
</Dropdown>

{#if inputs.data_options.value==2}
    <Dropdown name=timeline_options defaultValue="Goals">
        <DropdownOption valueLabel="Goals" value="Goals" />
        <DropdownOption valueLabel="Shots" value="Shots"/>
        <DropdownOption valueLabel="Fenwick" value="Fenwick" />
        <DropdownOption valueLabel="xGoals" value="xGoals" />
    </Dropdown>

    <LineChart
        data={timelines}
        x=seconds_elapsed
        y={inputs.timeline_options.value}
        series=team
        handleMissing=connect
        xAxisTitle=true
        yAxisTitle={inputs.timeline_options.value}
        seriesColors={{'ANA': '#F47A38', 'ATL': '#5C88DA', 'BOS': '#FFB81C', 'BUF': '#003087', 'CGY': '#D2001C', 'CAR': '#CE1126', 'CHI': '#CF0A2C', 'COL': '#6F263D', 'CBJ': '#002654', 'DAL': '#006847', 'DET': '#CE1126', 'EDM': '#041E42', 'FLA': '#C8102E', 'LAK': '#A2AAAD', 'MIN': '#154734', 'MTL': '#AF1E2D', 'NSH': '#FFB81C', 'NJD': '#CE1126', 'NYI': '#00539B', 'NYR': '#0038A8', 'OTT': '#DA1A32', 'PHI': '#F74902', 'PHX': '#8C2633', 'PIT': '#FCB514', 'SJS': '#006D75', 'STL': '#002F87', 'TBL': '#002868', 'TOR': '#00205B', 'VAN': '#00205B', 'WSH': '#C8102E', 'WPG': '#041E42', 'ARI': '#8C2633', 'VGK': '#B4975A', 'SEA': '#001628', 'UTA': '#69B3E7'}}
    />
{:else }
    <DataTable data={plays} rows=50 search=true rowShading=true headerColor=#0000ff headerFontColor=white sort=event_num compact=true downloadable=false>
        <Column id=event_num align=center title="#"/>
        <Column id=period align=center/>
        <Column id=seconds_elapsed align=center title="Seconds"/>
        <Column id=strength_state align=center/>
        <Column id=event_type align=center title="Event"/>
        <Column id=description align=center/>
        <Column id=logo align=center contentType=image height=20px/>
        <Column id=team align=center/>
        <Column id=name align=center title="Player"/>
        <Column id=shot_type align=center/>
        <Column id=zone_code align=center/>
        <Column id=away_score align=center/>
        <Column id=home_score align=center/>
        <Column id=xG align=center title="xG"/>
    </DataTable>
{/if}