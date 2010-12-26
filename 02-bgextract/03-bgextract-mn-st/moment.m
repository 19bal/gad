function m = Moment(image,p,q)

	m = 0;
	[sizey,sizex] = size(image);
	
	for i=1:sizex
		for j=1:sizey
			if (image(j,i) > 0)
				m = m + (i^p * j^q);
			end
		end
	end
