---
title: xG Model
---

<h1>Expected goals is a foundational component to modern hockey analytics.  Despite the increasing distance between private and public models,
the latter still contributes analytical value higher than that of any other shot metric between Corsi, Fenwick, and itself.  Expected Goals remains the best predictor of future goals and wins among these metrics as well.														</h1>

<br>
<h1>The WSBA xG Model was developed with the XGBoost (Extreme Gradient Boosting) library in Python and was trained on shots from 2018-19 to 2022-23.</h1>
<br>
<h1>Model Features:</h1>
<br>
<ol style="font-size:90%">
    <li>Shot Distance to Net</li>
    <li>Shot Angle toward Net</li>
    <li>Seconds Elapsed in Game</li>
    <li>Period in Game</li>
    <li>X and Y Coordinates of Shot</li>
    <li>Distance from last Event</li>
    <li>Angle from Last Event</li>
    <li>Seconds Since Last Event</li>
    <li>Seconds from Last Event</li>
    <li>Speed from Last Event</li>
    <li>Speed of Angle Change from Last Event</li>
    <li>Score State (Score differential in game between event team and opposing team)</li>
    <li>Strength Differential</li>
    <li>Shot Type (Includes all shot-types used in NHL play-by-play data as of the 2024-25 season)
    <li>Prior Event (Same or opposite to event team)</li>
    <li>Season Type (Regular Season or Playoffs)</li>
    <li>Shot is on Empty Net</li>
    <li>Offwing</li>
    <li>Rush</li>
    <li>Rebound</li>
</ol>

<br>
<h1>Model Metrics:</h1>
<br>
<h1 style="font-size:90%">ROC Curve</h1>
<h1 style="font-size:80%">The AUC displayed in the plot is calculated on shot data from the 2024-25 season (Slightly overfit from the testing data - AUC of 0.8482).</h1>
<img src="/roc_auc_curve.png"/>
<br>
<h1 style="font-size:90%">Reliability</h1>
<img src="/reliability.png"/>
<br>
<h1 style="font-size:90%">Feature Importance</h1>
<img src="/feature_importance.png"/>
<br>