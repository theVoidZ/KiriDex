function glowShape(r, g, b, type, intensity, ...)
	love.graphics.setColor(r, g, b, 15/255)
	intensity = math.max(intensity,7)
	for i = intensity, 2, -1 do
		if i == 2 then
			i = 1
			love.graphics.setColor(r, g, b, 1)    
		end

		love.graphics.setLineWidth(i)

		if type == "line" then
			love.graphics[type](...)
		else
			love.graphics[type]("line", ...)
		end
	end
end

function PolygonFromCenter(cx,cy,radius,segments,rot,isList) -- if isList is true then the output is {{x=x,y=y},{x=x,y=y},....} else {x,y,x,y,...}
	local poly = {}
	local angle_step = 2*math.pi/segments
	rot = rot or 0
	local mod = 0
	for i = 1,segments do
		if i == segments then
			mod = radius*0.6
		else
			mod = 0
		end
		local ang = rot + angle_step * i - math.pi/2
		local x = cx + math.cos(ang)*(radius+mod)
		local y = cy + math.sin(ang)*(radius+mod)
		if isList then
			poly[#poly+1] = {x=x,y=y}
		else
			poly[#poly+1] = x
			poly[#poly+1] = y
		end
	end
	return poly
end