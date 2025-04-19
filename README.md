# Credit Risk Prediction Modelling

This group project aims to predict the likelihood of loan default using generalized linear models with binomial regression. We explored predictors using logistic regression and compared several models based on various performance metrics such as AUC, Gini Index, accuracy, and sensitivity. Our goal is to **maximize the detection of potential loan defaulters** while maintaining balanced overall performance. 

We first visualized the data the data to understand the effect of each covariate on the response variable. Based on the insights found, we tested different combinations of covariates to evaluate model performance and selected the most suitable models for different use cases - 1. maximised sensitivity for default detection; 2. balanced performance across all metrics

## Problem Statement
Banks face significant risks when customers default on loans. The challenge lies in:
- Accurately predicting which applicants are most likely to default
- Balancing false positives (flagging good customers) vs. false negatives (missing customers that are proned to default)
- Building models that align with real-world banking criteria

## Tools and Technologies
- **Language**: R
- **Environment**: RStudio
- **Report Format**: R Markdown (`.Rmd`) for visualizations and model comparisons

## Project Structure
- Master.Rmd (data exploration, modelling, model evaluation)
- data_cleanup.R (data cleaning and preprocessing)

## Credits
This project was completed as part of a coursework. This repository is maintained individually for portfolio purposes. 
- Authors: Ka Long Arnald Shek, Morgan Ellis, Ian Daniel



