# thalamic_arousal_sequence_repository

#7T_arousal_traces.mat and 3T_arousal_traces
# 1. all_arousals: 3-D matrix, time x ROIs x behavioral arousals
# 2. t : time vector
# 3. rois_hdr : hdr file of the name of each ROI
# 4. (7T only) transient_sustained: 1 if corresponding index of arousal was transient, 2 if sustained, 0 otherwise


#bootstrap_code
# loads 7T arousal traces, finds the lag of the mean arousal traces, and then computes a bootstrap to get 95% confidence intervals.
