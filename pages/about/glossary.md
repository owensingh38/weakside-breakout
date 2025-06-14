---
title: Glossary
hide_title: true
---

<style>
    .image {
        display: block; 
        margin-left: auto; 
        margin-right: auto; 
        width: auto;
    }
</style>

```sql basic
SELECT * FROM glossary
WHERE Category = 'Basic'
```

```sql mod
SELECT * FROM glossary
WHERE Category = 'Modifier'
```

```sql comp
SELECT * FROM glossary
WHERE Category = 'Composite'
```

<div style="text-align: center; margin: 10px; align: center;">
    <img src="/wsba.png" alt="wsba" class="image" style="height:100px"/>
    <div>
        <b><h1 style="font-size:50px">Glossary</h1></b>
    </div>
    <br>
    <div>
        <h1 style="text-align: left">Basic Components</h1>
        <DataTable data={basic} rowShading=true headerColor=#0000ff headerFontColor=white rows=20/>
    </div>
    <div>
        <h1 style="text-align: left">Modifiers</h1>
        <DataTable data={mod} rowShading=true headerColor=#0000ff headerFontColor=white rows=20/>
    </div>
    <br>
    <div>
        <h1>The modifiers adapt metrics in which "GF" is Goals For (goals that occur with player on the ice) and "iFF" is Individual Fenwick For (fenwick shots contributed by the individual player)</h1>
    </div>
    <br>
    <div>
        <h1 style="text-align: left">Modifiers</h1>
        <DataTable data={comp} rowShading=true headerColor=#0000ff headerFontColor=white rows=20/>
    </div>
    <div>
        <h1>Composites are a combination of goal impact values (Shot Rate, Shot Quality, and Finishing) which are found in the Skater and Team stats pages.  They are also included in the Google Sheets visualizations (see "Links" in the resources tab).</h1>
    </div>
</div>