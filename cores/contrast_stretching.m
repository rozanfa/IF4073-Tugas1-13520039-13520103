function res = contrast_stretching(r)
    image_histograms = Histogram.calc(r);
    image_size = get_image_size(r);
    res = zeros(image_size);
    for i = 1:image_size(3)
        max_val = Histogram.get_max_pixel(image_histograms(i, :)) - 1;
        min_val = Histogram.get_min_pixel(image_histograms(i, :)) - 1;
        res(:, :, i) = (r(:, :, i) - min_val) .* (255/(max_val - min_val));
    end
    res = uint8(res);
end