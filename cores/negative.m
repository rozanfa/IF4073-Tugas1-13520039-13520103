function res = negative(im)
    res = uint8(255 * ones(size(im), "uint8") - im);
end