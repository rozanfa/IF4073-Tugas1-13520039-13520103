function res = histogram_equalization(r)
    r = double(r);
    image_size = get_image_size(r);
    value_count_map = zeros(image_size(3), 256, "uint32");
    pixel_count = image_size(1) * image_size(2);
    res = zeros(image_size);
    for k = 1:image_size(3)
        value_count_map(k, 1) = sum(sum(r(:,:,k) == 0));
        for n = 1:255
            value_count_map(k, n+1) = sum(sum(r(:,:,k) == n)) + value_count_map(k, n);
        end
    
        for i = 1:image_size(1)
            for j = 1:image_size(2)
                res(i,j,k) = value_count_map(k, r(i,j,k)+1) * 255 / pixel_count;
            end
        end
    end
    res = uint8(res);
end