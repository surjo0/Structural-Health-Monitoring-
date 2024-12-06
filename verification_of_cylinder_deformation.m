% Parameters for the half-cylinder
cylinder_radius = 1; % Radius of the half-cylinder
cylinder_height = 4; % Height of the cylinder
num_cylinder_points = 10000; % Number of points on the cylinder

% Parameters for the wall (filling the cut part)
wall_width = 2; % Width of the wall
wall_height = 4; % Height of the wall
num_wall_points = 5000; % Number of points on the wall

% Generate points for the half-cylinder
theta = pi * rand(num_cylinder_points, 1); % Half-circle (0 to pi)
Z_cylinder = cylinder_height * rand(num_cylinder_points, 1); % Random height
X_cylinder = cylinder_radius * cos(theta);
Y_cylinder = cylinder_radius * sin(theta);

% Introduce deformations to the cylinder (3 deformation zones)
deformation_zones_cylinder = [1.5, 2.5, 3.5]; % Z positions with deformations
deformation_sizes_cylinder = [0.02, 0.03, 0.04]; % Deformation magnitudes

for i = 1:length(deformation_zones_cylinder)
    indices = abs(Z_cylinder - deformation_zones_cylinder(i)) < 0.2; % Points near deformation zones
    X_cylinder(indices) = X_cylinder(indices) + deformation_sizes_cylinder(i) * cos(theta(indices));
    Y_cylinder(indices) = Y_cylinder(indices) + deformation_sizes_cylinder(i) * sin(theta(indices));
end

% Generate points for the wall to fill the cut part
X_wall = wall_width * (rand(num_wall_points, 1) - 0.5); % Random points in X
Y_wall = zeros(num_wall_points, 1); % Wall lies in Y = 0
Z_wall = wall_height * rand(num_wall_points, 1); % Random points in Z

% Introduce deformations to the wall (3 deformation zones)
deformation_zones_wall = [1, 2, 3]; % Z positions with deformations on the wall
deformation_sizes_wall = [0.01, 0.02, 0.03]; % Deformation magnitudes for the wall

for i = 1:length(deformation_zones_wall)
    indices = abs(Z_wall - deformation_zones_wall(i)) < 0.2; % Points near deformation zones
    X_wall(indices) = X_wall(indices) + deformation_sizes_wall(i) * cos(deformation_zones_wall(i));
    Z_wall(indices) = Z_wall(indices) + deformation_sizes_wall(i) * sin(deformation_zones_wall(i));
end

% Combine cylinder and wall points into a single point cloud
X = [X_cylinder; X_wall];
Y = [Y_cylinder; Y_wall];
Z = [Z_cylinder; Z_wall];

% Separation logic: wall vs. cylinder
cylinder_indices = sqrt(X.^2 + Y.^2) <= cylinder_radius + 0.1; % Cylinder points
wall_indices = Y == 0 & X > -wall_width/2 & X < wall_width/2; % Wall points detected near Y=0

% Ensure the wall points are detected correctly
X_cylinder_detected = X(cylinder_indices);
Y_cylinder_detected = Y(cylinder_indices);
Z_cylinder_detected = Z(cylinder_indices);

X_wall_detected = X(wall_indices);
Y_wall_detected = Y(wall_indices);
Z_wall_detected = Z(wall_indices);

% Check if wall points are detected
if isempty(X_wall_detected)
    error('Wall points are empty. Check the wall detection logic.');
end

% Fit a cylinder to the cylinder points
xc_init = mean(X_cylinder_detected);
yc_init = mean(Y_cylinder_detected);
r_init = mean(sqrt(X_cylinder_detected.^2 + Y_cylinder_detected.^2));

cylinder_fit = @(params) sum((sqrt((X_cylinder_detected - params(1)).^2 + ...
                                   (Y_cylinder_detected - params(2)).^2) - params(3)).^2);
options = optimset('Display', 'off');
optimized_params = fminsearch(cylinder_fit, [xc_init, yc_init, r_init], options);

xc_opt = optimized_params(1);
yc_opt = optimized_params(2);
r_opt = optimized_params(3);

% Calculate cylinder deformations
deformations_cylinder = abs(sqrt((X_cylinder_detected - xc_opt).^2 + ...
                                  (Y_cylinder_detected - yc_opt).^2) - r_opt);

% Fit a plane to the wall using least squares
A_wall = [X_wall_detected, Z_wall_detected, ones(size(X_wall_detected))]; % Design matrix for plane
b_wall = Y_wall_detected; % Target values (Y-coordinates)
plane_coeffs_wall = A_wall \ b_wall; % Least squares solution

% Extract plane parameters
A_plane_wall = plane_coeffs_wall(1);
C_plane_wall = plane_coeffs_wall(2);
D_plane_wall = plane_coeffs_wall(3);

% Calculate wall deformations
deformations_wall = abs(Y_wall_detected - (A_plane_wall * X_wall_detected + C_plane_wall * Z_wall_detected + D_plane_wall));

% Visualization: All outputs in one plot
figure;

subplot(3, 1, 1);
hold on;
scatter3(X_cylinder_detected, Y_cylinder_detected, Z_cylinder_detected, 10, 'filled'); % Half-cylinder points
scatter3(X_wall_detected, Y_wall_detected, Z_wall_detected, 10, 'filled'); % Wall points
title('Virtual Structure: Half-Cylinder with Wall');
xlabel('X-axis');
ylabel('Y-axis');
zlabel('Z-axis');
axis equal;
grid on;
view(3); % Set 3D view
hold off;


% Plot Cylinder Deformation Graph
subplot(3, 1, 2);
plot(Z_cylinder_detected, deformations_cylinder * 100, 'r-', 'LineWidth', 2);
hold on;
% Mark the deformation zones on the cylinder
for i = 1:length(deformation_zones_cylinder)
    plot(deformation_zones_cylinder(i), deformation_sizes_cylinder(i) * 100, 'ko', 'MarkerSize', 10, 'LineWidth', 2);
end
xlabel('Height (Z) of Cylinder');
ylabel('Deformation Size (cm)');
title('Cylinder Deformation');
grid on;
hold off;

% Plot Wall Deformation Graph
subplot(3, 1, 3);
plot(Z_wall_detected, deformations_wall * 100, 'b-', 'LineWidth', 2);
hold on;
% Mark the deformation zones on the wall
for i = 1:length(deformation_zones_wall)
    plot(deformation_zones_wall(i), deformation_sizes_wall(i) * 100, 'ko', 'MarkerSize', 10, 'LineWidth', 2);
end
xlabel('Height (Z) of Wall');
ylabel('Deformation Size (cm)');
title('Wall Deformation');
grid on;
hold off;
