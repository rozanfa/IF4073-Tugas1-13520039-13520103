r = double(r);
reference = double(reference);
image_histograms = get_histogram_maps(r);
image_size = get_image_size(r);
value_count_map = zeros(image_size(3), 256, "uint32");
pixel_count = image_size(1) * image_size(2);


reference_image_histograms = get_histogram_maps(reference);
reference_image_size = get_image_size(reference);
reference_value_count_map = zeros(reference_image_size(3), 256, "uint32");
reference_pixel_count = reference_image_size(1) * reference_image_size(2);

for k = 1:image_size(3)
    value_count_map(k, 1) = sum(sum(r(:,:,k) == 0));
    for n = 1:255
        reference_value_count_map(k, n+1) = sum(sum(reference(:,:,k) == n)) + reference_value_count_map(k, n);
    end
end

equalization_map = zeros(image_size(3), 256, "uint32");
specification_map = zeros(image_size(3), 256, "uint32");
res = zeros(image_size);
for k = 1:image_size(3)
    disp(k);
    value_count_map(k, 1) = sum(sum(r(:,:,k) == 0));
    for n = 1:255
        value_count_map(k, n+1) = sum(sum(r(:,:,k) == n)) + value_count_map(k, n);
    end

    for i = 1:256
        equalization_map(k, i) = value_count_map(k, i) * 255 / pixel_count;
    end

    for v = equalization_map
        % disp(get_nearest_value(v, equalization_map(k, :)));
        disp(size(equalization_map(k, :)));
        specification_map(k, v+1) = get_nearest_value(v, equalization_map(k, :));
    end

    for i = 1:image_size(1)
        for j = 1:image_size(2)
            res(i,j,k) = specification_map(k, equalization_map(k, r(i,j,k) + 1) + 1);
        end
    end
end