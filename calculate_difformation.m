% Load the filtered point cloud from the wall7.mat file
load("tangentpillar.mat");

% Define the number of divisions along the Z-axis
num_slices = 15;

% Define the total height range
z_min = 0; % Minimum height (0 feet)
z_max = 110.5232; % Maximum height (120 feet)

% Calculate the step size for slicing
z_step = (z_max - z_min) / num_slices;

% Initialize arrays to store slope and intercept values for each slice
slope_values = zeros(num_slices, 1);
intercept_values = zeros(num_slices, 1);

% Initialize arrays to store squared difference values for each slice
squared_diffs = zeros(num_slices, 1);

% Fit a linear regression line to the entire point cloud
[x_all, y_all] = deal(filtered_pc.Location(:, 1), filtered_pc.Location(:, 2));
coeffs_all = polyfit(x_all, y_all, 1);
sum_y_all_sq = sum(y_all.^2);

% Calculate the slope and intercept values for each slice
for i = 1:num_slices
    z_lower = z_min + (i - 1) * z_step;
    z_upper = z_min + i * z_step;
    
    % Find the points within the current slice
    slice_indices = find(filtered_pc.Location(:, 3) >= z_lower & filtered_pc.Location(:, 3) < z_upper);
    sliced_point_cloud = select(filtered_pc, slice_indices);
    
    [x, y] = deal(sliced_point_cloud.Location(:, 1), sliced_point_cloud.Location(:, 2));
    coeffs = polyfit(x, y, 1);
    slope_values(i) = coeffs(1);
    intercept_values(i) = coeffs(2);
    
    sum_slice_sq = sum(y.^2);
    
    % Calculate the squared difference and store it
    squared_diffs(i) = (sum_y_all_sq - sum_slice_sq)^2;
end

% Define the unit conversion factor
unit_conversion = 0.9625; % 1 unit in the y-axis corresponds to 0.9625 meters

% Calculate the differences between consecutive squared difference values
diff_squared_diffs = diff(squared_diffs);

% Convert the differences to meters
diff_squared_diffs_meters = diff_squared_diffs * unit_conversion;

diff_squared_diffs_meters = diff_squared_diffs_meters ;

% Display the differences
disp('Defformation(meters): side');
disp(diff_squared_diffs_meters);
