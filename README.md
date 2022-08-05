# Thalamic Arousal Sequence

This repository contains the preprocessed arousal data from our paper "A
temporal sequence of thalamic activity unfolds prior to transitions in behaviour
arousal state".

?
Make a note to insert:
If you use this data or code, please cite:
?

# Data

The two .mat files in this repository contains four structures:


1. *all_arousals*
A 3D matrix of dimension time x ROIs x normalized response amplitude

2. *t*
A time vector indicating the sampling points in all_arousals

3. *rois_hdr*
The name of each ROI in all_arousals

4. (7T only) transient_sustained
An int vector where 1 corresponds to transient and 2 to sustained arousals.

Zero corresponds to the moment of behavioral arousal.

# Code

The code in `bootstrap_code.m` loads 7T arousal traces, finds the lag of the mean arousal traces, and then
computes a bootstrap to get 95% confidence intervals.

The code was tested under Matlab.

