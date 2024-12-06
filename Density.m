load("ab2_ab1_LQ.mat");

xCoordinates = matrix(:, 1);
yCoordinates = matrix(:, 2);
zCoordinates = matrix(:, 3);

lowest_height = 82.2621;
highest_height = 119.5618;

% Dividing the Z-range into five parts
z_divisions = linspace(lowest_height, highest_height, 6); % Creates five division points

% Create arrays to store the volume for each section
section_volumes = zeros(1, numel(z_divisions)-1);

% Calculate and display the volume of each section
figure;
for i = 1:numel(z_divisions)-1
    z_lower = z_divisions(i);
    z_upper = z_divisions(i+1);
    
    % Find indices within the specified z-range for each section
    section_indices = find(zCoordinates >= z_lower & zCoordinates <= z_upper);
    
    % Extract points for each section
    section_points = matrix(section_indices, :);
    
    % Calculate extents in X, Y, and Z dimensions
    x_extent = max(section_points(:, 1)) - min(section_points(:, 1));
    y_extent = max(section_points(:, 2)) - min(section_points(:, 2));
    z_extent = max(section_points(:, 3)) - min(section_points(:, 3));
    
    % Calculate volume (x * y * z)
    section_volumes(i) = x_extent * y_extent * z_extent;
    
    subplot(1, numel(z_divisions)-1, i); % Adjust subplot layout if needed
    pcshow(section_points);
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    title(['Section ', num2str(i), ', Volume: ', num2str(section_volumes(i))]);
end

