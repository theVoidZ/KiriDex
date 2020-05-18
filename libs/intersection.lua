-- poly1 and poly2 are arrays of VELatlongs that represent polygons
function ArePolygonsOverlapped(poly1, poly2,check_inside) -- poly = {{x, y}, {x, y}, {x, y}, ...}
    if(#poly1 >= 3 and #poly2 >= 3) then
        -- close polygons
        
		for i = 1 , #poly1-1 do
			for k = 1 , #poly2-1 do
				if doLinesIntersect(poly1[i],poly1[i+1],poly2[k],poly2[k+1]) then
					return true
				end
			end
        end
		if check_inside then
		------------- check if poly1 is inside poly2
			for i = 1 , #poly1 do
				if pointInPolygon(poly2, poly1[i]) then
					return true
				end
			end
			------------- now check if poly2 is inside poly1
			for i = 1 , #poly2 do
				if pointInPolygon(poly1, poly2[i]) then
					return true
				end
			end
        end
        return false;
    end
    
    return nil;
end

-- Returns true if the dot { x,y } is within the polygon defined by points table { {x,y},{x,y},{x,y},... }
function pointInPolygon( points, dot )
	local i, j = #points, #points
	local oddNodes = false

	for i=1, #points do
			if ((points[i].y < dot.y and points[j].y>=dot.y
					or points[j].y< dot.y and points[i].y>=dot.y) and (points[i].x<=dot.x
					or points[j].x<=dot.x)) then
					if (points[i].x+(dot.y-points[i].y)/(points[j].y-points[i].y)*(points[j].x-points[i].x)<dot.x) then
						oddNodes = not oddNodes
					end
			end
			j = i
	end

	return oddNodes
end

function doLinesIntersect( a, b, c, d )
	-- parameter conversion
	local L1 = {X1=a.x,Y1=a.y,X2=b.x,Y2=b.y}
	local L2 = {X1=c.x,Y1=c.y,X2=d.x,Y2=d.y}
	
	-- Denominator for ua and ub are the same, so store this calculation
	local d = (L2.Y2 - L2.Y1) * (L1.X2 - L1.X1) - (L2.X2 - L2.X1) * (L1.Y2 - L1.Y1)
	
	-- Make sure there is not a division by zero - this also indicates that the lines are parallel.
	-- If n_a and n_b were both equal to zero the lines would be on top of each
	-- other (coincidental).  This check is not done because it is not
	-- necessary for this implementation (the parallel check accounts for this).
	if (d == 0) then
			return false
	end
	
	-- n_a and n_b are calculated as seperate values for readability
	local n_a = (L2.X2 - L2.X1) * (L1.Y1 - L2.Y1) - (L2.Y2 - L2.Y1) * (L1.X1 - L2.X1)
	local n_b = (L1.X2 - L1.X1) * (L1.Y1 - L2.Y1) - (L1.Y2 - L1.Y1) * (L1.X1 - L2.X1)
	
	-- Calculate the intermediate fractional point that the lines potentially intersect.
	local ua = n_a / d
	local ub = n_b / d
	
	-- The fractional point will be between 0 and 1 inclusive if the lines
	-- intersect.  If the fractional calculation is larger than 1 or smaller
	-- than 0 the lines would need to be longer to intersect.
	if (ua >= 0 and ua <= 1 and ub >= 0 and ub <= 1) then
			local x = L1.X1 + (ua * (L1.X2 - L1.X1))
			local y = L1.Y1 + (ua * (L1.Y2 - L1.Y1))
			return true, {x=x, y=y}
	end
	
	return false
end