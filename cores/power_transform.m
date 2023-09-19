function res = power_transform(r, args)
    c = args{1};
    g = args{2};
    res = uint8(c * (double(r) ^ g));
end