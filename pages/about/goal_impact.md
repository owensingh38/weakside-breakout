---
title: xG Model
hide_title: true
---

<style>
    h1 br {
        display: block;
        content: "";
        margin-bottom: 2em;
    }
    .image {
        display: block; 
        margin-left: auto; 
        margin-right: auto; 
        width: auto;
    }
    .subhead {
        font-size: 30px;
    }
</style>

<div style="text-align: center; margin: 10px; align: center;">
    <img src="/wsba.png" alt="wsba" class="image" style="height:100px"/>
    <div>
        <b><h1 style="font-size:50px">Goal Impact Calculations</h1></b>
    </div>
    <div>
        <h1>First introduced by Andrew C. Thomas in the WAR model for War-On-Ice.com and explained in the Evolving Hockey glossary, the idea that the composition of goals over time 
        is filled by different but heavily related components has existed for some time.</h1>
        <br>
        <h1 class="subhead">Baseline Calculation</h1>
        <h1 style="font-size:80%">Goals = G   Fenwick = F   League Average Fenwick Shot % = Fsh   xGoals = xG</h1>
        <h1><i>G = (F*Fsh)+((xG/F)-Fsh)+(G-xG)</i></h1>
        <h1 style="font-size:80%">F*Fsh = Shot Rate Component (xG/F)-Fsh = Shot Quality Component G-xG = Finishing Component</h1>
        <br>
        <h1>
            Each of these components converts a shot metric value to a comparable goal value. If a player's raw shot metric totals are calculated with this formula 
            it will equal their observed goal total in the assessed time frame.
            The above idea is applicable to either raw totals or per 60 values as well as any area of analysis (individual, on-ice offense, and on-ice defense).
            <br>
            Typically, this calculation is the underlying construct of the above-replacement metrics formulated by the aforementioned War-On-Ice and Evolving Hockey.
            However, the calculation is additionally useful for analyzing component-specific impacts and develops insight into the logic of a player's play involvement, 
            which is the underlying construct of the data provided on this website.<br>
            Firstly, measuring the impact of a single component on a goal output requires relativity to the league average and exploring the impact of 
            goal output when its inputs (shot components) are modified
            <br>
            For each component (shot rate, shot quality, and finishing) as well as groupings (individual, on-ice offense, and on-ice defense),
            a player's (or team's) goal output is differentiated from their output when the evaluated metric is average. 
            <br>
            For example, individual shot quality impact is calculated as:
            <i>Goals - ((F*Fsh)+((League Average xG/F)-Fsh)+(G-xG))</i>
            <br>
            After these are all applied, the impact values of each component are combined into different composites.
            <br>
            Some are as simple as Extraneous Goals, which is a measure of overall goal impact value
            provided above an average skater, while others utilize metrics to determine skater contribution to their
            linemate's goal impacts
            <br>
            While vaguely similar to RAPM and, subsequently WAR models (as described previously), the approach utilized (how data is displayed and presented)
            prioritizes a mediation between macroanalysis (pace-of-play and General Output) and microanalysis (decision-making, systematic elements of play, etc).
            </h1>
    </div>
</div>