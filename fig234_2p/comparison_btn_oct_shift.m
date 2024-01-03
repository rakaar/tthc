all_oct_shift = zeros(13,3);

% 1 - Thy, 2 - PV, 3 - SOM
neuron_types = {'Thy', 'PV', 'SOM'};

all_oct_shift(:,1) = load('all_Thy_octave_shift.mat').shift_vec;
all_oct_shift(:,2) = load('all_PV_octave_shift.mat').shift_vec;
all_oct_shift(:,3) = load('all_SOM_octave_shift.mat').shift_vec;


% for loop to compare btn each possible pair
disp('Thy and PV')
i = 1; j = 2;
data = [all_oct_shift(:,i)'; all_oct_shift(:,j)'];

[h,p] = chi_sq_test_of_ind(data)

disp('Thy and SOM')
i = 1; j = 3;
data = [all_oct_shift(:,i)'; all_oct_shift(:,j)'];

[h,p] = chi_sq_test_of_ind(data)


disp('PV and SOM')
i = 2; j = 3;
data = [all_oct_shift(:,i)'; all_oct_shift(:,j)'];

[h,p] = chi_sq_test_of_ind(data)