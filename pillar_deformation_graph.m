data = load('pillar.xyz');

X = data(:, 1);
Y = data(:, 2);
Z = data(:, 3);

% Change height to 20 meters
Z_normalized = (Z - min(Z)) / (max(Z) - min(Z)) * 20; % Assuming height is 20 meters

xc_init = mean(X);
yc_init = mean(Y);
r_init = mean(sqrt((X - xc_init).^2 + (Y - yc_init).^2));

% least squares fitting
cylinder_fit = @(params) sum((sqrt((X - params(1)).^2 + (Y - params(2)).^2) - params(3)).^2);

options = optimset('Display','off');
optimized_params = fminsearch(cylinder_fit, [xc_init, yc_init, r_init], options);

xc_opt = optimized_params(1);
yc_opt = optimized_params(2);
r_opt = optimized_params(3);

deformations = abs(sqrt((X - xc_opt).^2 + (Y - yc_opt).^2) - r_opt);

% Set threshold(5mm)
threshold = 5 / 1000; 

deformation_indices = find(deformations > threshold);

Z_deformation = Z_normalized(deformation_indices);
deformation_sizes = deformations(deformation_indices);

% Adjust binning for 20 meters height
bin_edges = linspace(0, 20, 100); 

mean_deformations = zeros(length(bin_edges) - 1, 1);

for i = 1:length(bin_edges) - 1
    in_bin = Z_deformation >= bin_edges(i) & Z_deformation < bin_edges(i + 1);
    
    if any(in_bin)
        mean_deformations(i) = mean(deformation_sizes(in_bin));
    end
end

bin_centers = bin_edges(1:end-1) + diff(bin_edges) / 2;

figure;
plot(bin_centers, mean_deformations * 100, '-', 'LineWidth', 2, 'Color', 'blue'); % Convert to centimeters
xlabel('Height (meters)', 'FontSize', 16); % Increase font size for x-axis
ylabel('Mean Deformation Size (cm)', 'FontSize', 16); % Increase font size for y-axis
title('Deformation Size Along the Height of the Cylinder', 'FontSize', 18); % Increase font size for title
grid on;
