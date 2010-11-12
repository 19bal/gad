function [a,b] = CentreOfMass(image)

	a = 0;
	b = 0;
	count = 0;
	[sizey,sizex] = size(image);
	
	for i=1:sizex
		for j=1:sizey
			if (image(j,i) > 0)
				a = a + i;
				b = b + j;
				count = count + 1;
			end
		end
	end
	
	a = floor(a/count);
	b = floor(b/count);
