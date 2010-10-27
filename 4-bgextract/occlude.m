function Ralpha = Occlude(image, alpha)

	[sizey,sizex] = size(image);
	[a,b] = CentreOfMass(image);
	moo = Moment(image,0,0);
	
	Ralpha = zeros(sizey,sizex);
	
	for x=1:sizex
		for y=1:sizey
			if (image(y,x) > 0)
				temp = ((x - a)^2 + (y - b)^2);
				temp2 = (alpha * moo) / pi;
				if (temp > temp2)
					Ralpha(y,x) = 1;
				end
			end
		end
	end
	
