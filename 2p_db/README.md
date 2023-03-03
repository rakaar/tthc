To make 2p DB
1. In `make_2p_stage1_db.m`, change stim as per tone and hc and Run it
2. Run `check_stage1_db.m`
3. Run `check_no_of_cells_stage1.m` to ensure tone and hc cells numbered match
4. If they don't, delete files accordingly
5. Repeat 1-4 till Step 3 is good
6. Run `make_rms_match.m` to make RMS db