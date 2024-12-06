% Load the filtered point cloud from the wall7.mat file
load("guestwall.mat");

% Define the number of divisions along the Z-axis
num_slices = 15;

% Define the total height range
z_min = 0; % Minimum height (0 feet)
z_max = 120; % Maximum height (120 feet)

% Calculate the step size for slicing
z_step = (z_max - z_min) / num_slices;

% Slice the point cloud into 15 parts along the Z-axis
for i = 1:num_slices
    z_lower = z_min + (i - 1) * z_step;
    z_upper = z_min + i * z_step;
    
    % Find the points within the current slice
    slice_indices = find(filtered_pc.Location(:, 3) >= z_lower & filtered_pc.Location(:, 3) < z_upper);
    sliced_point_clouds{i} = select(filtered_pc, slice_indices);
end

% Extract y values for slice 12
y_values_slice12 = sliced_point_clouds{13}.Location(:, 2);

% Calculate mod of y values for slice 12
mod_y_values_slice12 = mod(y_values_slice12, 0.9625);

% Calculate min, max, and average of mod y values for slice 12
min_mod_y_slice12 = min(mod_y_values_slice12);
max_mod_y_slice12 = max(mod_y_values_slice12);
avg_mod_y_slice12 = mean(mod_y_values_slice12);

% Display min, max, and average mod y values for slice 12
%disp("For Difformation Slice:");
%disp("Min Mod Y Value: " + min_mod_y_slice12);
%disp("Max Mod Y Value: " + max_mod_y_slice12);
disp("Deformation: " + avg_mod_y_slice12);
