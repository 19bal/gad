function d = shownormimage2(data)

d = data - min(min(min(data)));
t = max(makelinear(d));
if (t ~= 0)
    d = d * (1/t);
end

if (size(d,3) > 1)
    image(d);
else
    image(d*64);
end

title(sprintf('min=%f max=%f', min(min(min(data))), max(max(max(data)))));
