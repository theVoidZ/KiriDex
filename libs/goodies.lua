function Angle(x1,y1,x2,y2)
	return (math.atan2(y2 - y1,x2 - x1))
end
function Distance(x1,y1,x2,y2)
	return (math.sqrt((x1-x2)^2+(y1-y2)^2))
end
function Distance2(x1,y1,x2,y2)
	return ((x1-x2)^2+(y1-y2)^2)
end
function math.clamp(x, min, max)
	return x < min and min or (x > max and max or x)
end
function math.round(num, numDecimalPlaces)
  return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end
function pointInsideRect(x,y,bx,by,bw,bh)
	return (x>bx and x<=bx+bw and y>by and y<=by+bh)
end
function CheckCircleOverlap(cx,cy,r,x,y,width,height)
	x = x + width/2
	y = y + height/2
	local circleDistance_x = math.abs(cx - x);
	local circleDistance_y = math.abs(cy - y);

	if (circleDistance_x > (width/2 + r)) then return false end
	if (circleDistance_y > (height/2 + r)) then return false end

	if (circleDistance_x <= (width/2)) then return true end
	if (circleDistance_y <= (height/2)) then return true end

	local cornerDistance_sq = (circleDistance_x - width/2)^2 +
						(circleDistance_y - height/2)^2;

	return (cornerDistance_sq <= (r^2));
end
function contains(tab,element)
	for _, value in pairs(tab) do
			  if value == element then
			  return true
			  end
		 end
	return false
end
function string:split(sep)
	local sep, fields = sep or ":", {}
	local pattern = string.format("([^%s]+)", sep)
	self:gsub(pattern, function(c) fields[#fields+1] = c end)
	return fields
end
function sign(x)
	if x == 0 then 
		return 0
	else
		return math.abs(x)/x
	end
end
function SecondsToClock(seconds)
  local seconds = tonumber(seconds)

  if seconds <= 0 then
    return "00:00:00";
  else
    hours = string.format("%02.f", math.floor(seconds/3600));
    mins = string.format("%02.f", math.floor(seconds/60 - (hours*60)));
    secs = string.format("%02.f", math.floor(seconds - hours*3600 - mins *60));
    return hours..":"..mins..":"..secs
  end
end

function MSecondsToClock2(mseconds)
	local seconds = tonumber(mseconds/1000)

	if seconds <= 0 then
		return "00:00:00";
	else
		-- hours = string.format("%02.f", math.floor(seconds/3600));
		local mins = string.format("%02.f", math.floor(seconds/60));
		local secs = string.format("%02.f", math.floor(seconds - mins *60));
		local ms = string.format("%.1f", (seconds-math.floor(seconds))*60)
		return mins..":"..secs..":"..ms
	end
end
function doOverlap(x1,y1,x2,y2,x3,y3,x4,y4,eq)
	if eq then
		if (x1 >= x4 or x3 >= x2) then
			return false
		end
	 
		-- If one rectangle is above other
		if (y1 >= y4 or y3 >= y2) then
			return false
		end
		return true
	else
		if (x1 > x4 or x3 > x2) then
			return false
		end
	 
		-- If one rectangle is above other
		if (y1 > y4 or y3 > y2) then
			return false
		end
		return true
	end
end

function lerp(a, b, x) return a + (b - a)*x end
function csnap(v, x) return math.ceil(v/x)*x - x/2 end