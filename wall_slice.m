% Load the filtered point cloud from the sample_wall.mat file
load("sample_wall.mat");

% Determine the range of the Z-axis
z_min = min(filtered_pc.Location(:, 3));
z_max = max(filtered_pc.Location(:, 3));

% Define the number of divisions along the Z-axis
num_slices = 15;

% Calculate the step size for slicing
z_step = (z_max - z_min) / num_slices;

% Initialize a cell array to store the sliced point clouds
sliced_point_clouds = cell(1, num_slices);

% Slice the point cloud into 15 parts along the Z-axis
for i = 1:num_slices
    z_lower = z_min + (i - 1) * z_step;
    z_upper = z_min + i * z_step;
    
    % Find the points within the current slice
    slice_indices = find(filtered_pc.Location(:, 3) >= z_lower & filtered_pc.Location(:, 3) < z_upper);
    sliced_point_clouds{i} = select(filtered_pc, slice_indices);
end

% Visualize all the sliced point clouds in one vertical line
figure;
for i = 1:num_slices
    subplot(num_slices, 1, i);
    pcshow(sliced_point_clouds{i});
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    title(['Slice ', num2str(i)]);
end
