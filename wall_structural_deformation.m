
load('wall3.mat');

X = filtered_pc.Location(:, 1);
Y = filtered_pc.Location(:, 2);
Z = filtered_pc.Location(:, 3);

Z_normalized = (Z - min(Z)) / (max(Z) - min(Z)) * 30;


y_center = mean(Y);

deformations = abs(Y - y_center);

threshold = 1 / 100; % 1 cm in meters

deformation_indices = find(deformations > threshold);

Z_deformation = Z_normalized(deformation_indices);
deformation_sizes = deformations(deformation_indices);

bin_edges = linspace(0, 30, 100);

mean_deformations = zeros(length(bin_edges) - 1, 1);

for i = 1:length(bin_edges) - 1
    in_bin = Z_deformation >= bin_edges(i) & Z_deformation < bin_edges(i + 1);
    
    if any(in_bin)
        mean_deformations(i) = mean(deformation_sizes(in_bin));
    end
end

% Convert bin centers to their corresponding height values
bin_centers = bin_edges(1:end-1) + diff(bin_edges) / 2;

figure;
plot(bin_centers, mean_deformations * 10, '-', 'LineWidth', 2, 'Color', 'blue'); 
xlabel('Height (meters)','FontSize', 16);
ylabel('Mean Deformation Size (cm)', 'FontSize', 16);
title('Deformation Size Along the Height of the Wall','FontSize', 18);
grid on;
