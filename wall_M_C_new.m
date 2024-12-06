% Load the .mat file
matFileName = 'tangentpillar.mat';
dataStruct = load(matFileName);

% Assuming the point cloud data is stored in a variable named 'flat_surface_points'
points = dataStruct.flat_surface_points;

% Visualize the distribution of z-values
figure;
histogram(points(:, 2), 30); % Adjust the number of bins as needed
xlabel('Z Value');
ylabel('Frequency');
title('Distribution of Z-Values');
grid on;

% Define the parameters for slicing based on the z-value distribution
num_slices = 5; % Adjust this based on the data distribution
z_min = min(points(:, 2)); % Use the minimum z-value in your data
z_max = max(points(:, 2)); % Use the maximum z-value in your data
z_step = (z_max - z_min) / num_slices;

% Initialize arrays to store results
slope_values = zeros(num_slices, 1);
intercept_values = zeros(num_slices, 1);
squared_diffs = zeros(num_slices, 1);

% Extract all x and y coordinates
[x_all, y_all] = deal(points(:, 1), points(:, 2));
coeffs_all = polyfit(x_all, y_all, 1);
sum_y_all_sq = sum(y_all.^2);

% Loop through each slice
for i = 1:num_slices
    z_lower = z_min + (i - 1) * z_step;
    z_upper = z_min + i * z_step;
    
    % Find indices of points within the current slice
    slice_indices = find(points(:, 2) >= z_lower & points(:, 2) < z_upper);
    sliced_points = points(slice_indices, :);
    
    % Extract x and y coordinates of the slice
    [x, y] = deal(sliced_points(:, 1), sliced_points(:, 2));
    
    if length(x) < 2
        % If less than 2 points, skip this slice
        warning('Slice %d has fewer than 2 points and will be skipped.', i);
        continue;
    end
    
    % Fit a line to the points in the slice
    coeffs = polyfit(x, y, 1);
    slope_values(i) = coeffs(1);
    intercept_values(i) = coeffs(2);
    
    sum_slice_sq = sum(y.^2);
    squared_diffs(i) = (sum_y_all_sq - sum_slice_sq)^2;
end

% Plot the squared differences
subplot(2, 1, 1);
plot(z_min + z_step*(0:num_slices-1), squared_diffs, 'o-', 'LineWidth', 2);
xlabel('Height (feet)');
ylabel('(Sum(Y_{all}^2) - Sum(Y_{slice}^2))^2');
title('Average quality TLS Data');
grid on;
set(gca, 'XTickLabel', []);
set(gca, 'YTickLabel', []);
