function M = CentralisedMoment(image,p,q,a,b)

	M = 0;
	[sizey,sizex] = size(image);
	
	for i=1:sizex
		for j=1:sizey
			if (image(j,i) > 0)
				M = M + ((i-a)^p * (j-b)^q);
			end
		end
	end
