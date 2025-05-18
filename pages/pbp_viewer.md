---
title: PBP Viewer
---

```sql plays
SELECT 
    event_num,
    "period",
    seconds_elapsed,
    event_type,
    CASE
        WHEN event_type IN ('missed-shot','shot-on-goal','goal') THEN "description" || ' - xG: ' || SUBSTRING(("xG"*100),1,5) || '%'
        ELSE "description"
    END as "description",
    strength_state,
    team,
    skater,
    skater_2,
    skater_3,
    shot_type,
    zone_code,
    x_adj as x,
    y_adj as y,
    away_score,
    home_score,
    away_on_1,away_on_2,away_on_3,away_on_4,away_on_5,away_on_6,away_goalie,away_coach,
    home_on_1,home_on_2,home_on_3,home_on_4,home_on_5,home_on_6,home_goalie,home_coach,
    seconds_since_last,
    offwing,
    xG,
    CASE
        WHEN xG IS NULL THEN 1
        WHEN xG <.1 THEN 0.25
        ELSE (xG*3)
    END as size
FROM 
    pbp
WHERE
    game_title = '${inputs.game_options.value}'
AND
    event_type IN ${inputs.event_options.value}
AND
    strength_state IN ${inputs.strength_options.value}
AND
    team IS NOT NULL
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
    team as Team, 
    SUM(CASE WHEN event_type IN ('goal') THEN 1 ELSE 0 END) as Goals,
    SUM(CASE WHEN event_type IN ('shot-on-goal','goal') THEN 1 ELSE 0 END) as Shots,
    SUM(CASE WHEN event_type IN ('missed-shot','shot-on-goal','goal') THEN 1 ELSE 0 END) as Fenwick,
    SUM(xG) as xG,
    SUM(CASE WHEN event_type IN ('giveaway') THEN 1 ELSE 0 END) as Giveaways,
    SUM(CASE WHEN event_type IN ('takeaway') THEN 1 ELSE 0 END) as Takeaways,
    SUM(CASE WHEN event_type IN ('hit') THEN 1 ELSE 0 END) as Hits
FROM ${plays}
GROUP BY team
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

<div style="position: relative; width: 100%; height: 230px;">
    <div style="position: absolute; top: 0; left: 0; width: 100%; height: 100%; background: none !important; z-index: 1; transform: translateY(-10px);">
        
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
            yMin = -45
            yMax = 45
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
                color=red
                symbolSize=40
                symbolOpacity=0.25
            />
            <ReferencePoint
                x=-18
                y=22.5
                color=red
                symbolSize=15
                symbolOpacity=0.25
            />
            <ReferencePoint
                x=-18
                y=-22.5
                color=red
                symbolSize=15
                symbolOpacity=0.25
            />
            <ReferencePoint
                x=18
                y=22.5
                color=red
                symbolSize=15
                symbolOpacity=0.25
            />
            <ReferencePoint
                x=18
                y=-22.5
                color=red
                symbolSize=15
                symbolOpacity=0.25
            />
            <ReferencePoint
                x=-70
                y=22.5
                color=red
                symbolSize=40
                symbolOpacity=0.25
            />
            <ReferencePoint
                x=-70
                y=-22.5
                color=red
                symbolSize=40
                symbolOpacity=0.25
            />
            <ReferencePoint
                x=70
                y=22.5
                color=red
                symbolSize=40
                symbolOpacity=0.25
            />
            <ReferencePoint
                x=70
                y=-22.5
                color=red
                symbolSize=40
                symbolOpacity=0.25
            />
        </BubbleChart>
    </div>
</div>
<br><br>
<DataTable data={team_summary}>
    <Column id=Team align=center />
    <Column id=Goals align=center/>
    <Column id=Shots align=center/>
	<Column id=Fenwick align=center/>
    <Column id=xG align=center title="xG"/>
    <Column id=Giveaways align=center/>
    <Column id=Takeaways align=center/>
    <Column id=Hits align=center/>
</DataTable>

<DataTable data={plays}>
    <Column id=event_num align=center title="#"/>
    <Column id=period align=center/>
    <Column id=seconds_elapsed align=center title="Seconds"/>
	<Column id=event_type align=center title="Event"/>
    <Column id=description align=center/>
    <Column id=strength_state align=center title="Strength"/>
    <Column id=team align=center/>
    <Column id=skater align=center/>
    <Column id=skater_2 align=center/>
    <Column id=skater_3 align=center/>
    <Column id=shot_type align=center/>
    <Column id=zone_code align=center/>
    <Column id=x align=center title="x"/>
	<Column id=y align=center title="y"/>
    <Column id=away_score align=center/>
	<Column id=home_score align=center/>
    <Column id=away_on_1 align=center/>
    <Column id=away_on_2 align=center/>
    <Column id=away_on_3 align=center/>
    <Column id=away_on_4 align=center/>
    <Column id=away_on_5 align=center/>
    <Column id=away_on_6 align=center/>
    <Column id=away_goalie align=center/>
    <Column id=away_coach align=center/>
    <Column id=home_on_1 align=center/>
    <Column id=home_on_2 align=center/>
    <Column id=home_on_3 align=center/>
    <Column id=home_on_4 align=center/>
    <Column id=home_on_5 align=center/>
    <Column id=home_on_6 align=center/>
    <Column id=home_goalie align=center/>
    <Column id=home_coach align=center/>
    <Column id=offwing align=center/>
    <Column id=xG align=center title="xG"/>
</DataTable>
