dataset = load("ab2_ab1_LQ.mat");
pc = pointCloud(dataset.matrix);

maxZ = 50.0;  % Set the threshold for the z-value

xyz = pc.Location;
zValues = xyz(:, 3);

groundMask = zValues <= maxZ;

groundPointCloud = select(pc, find(groundMask));

figure;
pcshow(groundPointCloud);
title('Ground Points with z <= 50');





