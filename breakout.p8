pico-8 cartridge // http://www.pico-8.com
version 15
__lua__
function _init()
 cls()
 --globals for the ball
 ball_x=1
 ball_dx=2 --how much x changes over time
 ball_y=10
 ball_dy=2 --how much y changes over time
 ball_r=2
 --globals for the padle
 pad_x=52
 pad_dx=0
 pad_y=120
 pad_w=24
 pad_h=3
 pad_c=7
 --globals for the input
 c_left=0
 c_right=1
 c_up=2
 c_down=3
end

function _update()
 local buttpress=false
 local next_x,next_y
 
 if btn(c_left) then
  pad_dx=-5
  buttpress=true
 end
 if btn(c_right) then
 	pad_dx=5
 	buttpress=true
 end
 if not(buttpress) then
  -- slow down
  pad_dx=pad_dx/1.7
 end

 pad_x+=pad_dx
 
 next_x=ball_x+ball_dx
 next_y=ball_y+ball_dy

	-- handle collision with walls 
 if next_x > 127 or next_x < 0 then
  next_x=mid(0,next_x,127)
  -- invert ball direction
  ball_dx=-ball_dx
  sfx(0)
 end
 if next_y > 127 or next_y < 0 then
  next_y=mid(0,next_y,127)
  -- invert ball direction
  ball_dy=-ball_dy
  sfx(0)
 end

 pad_c=7
 -- check if the ball hits the padle
 if ball_box(next_x,next_y,pad_x,pad_y,pad_w,pad_h) then
  -- find direction to deflect
  if deflx_ball_box(ball_x,ball_y,ball_dx,ball_dy,pad_x,pad_y,pad_w,pad_h) then
   -- invert ball direction in x
   ball_dx=-ball_dx
  else
   -- invert ball direction in y
   ball_dy=-ball_dy
  end
  -- feedback stuff
  pad_c=8
  sfx(0)
 end
 
 -- set the new position of the ball
 ball_x=next_x
 ball_y=next_y
end

function _draw()
 rectfill(0,0,127,127,1)
 circfill(ball_x,ball_y,ball_r,10)
 rectfill(pad_x,pad_y,pad_x+pad_w,pad_y+pad_h,pad_c)
end
-- *-*-*-*
-- physics
-- *-*-*-*

-- check collision with a box
function ball_box(bx,by,box_x,box_y,box_w,box_h)
 if by-ball_r>box_y+box_h then return false end
 if by+ball_r<box_y then return false end
 if bx-ball_r>box_x+box_w then return false end
 if bx+ball_r<box_x then return false end 
 return true
end

-- check collisions between the
-- ball and a box
function deflx_ball_box(b_x,b_y,b_dx,b_dy,t_x,t_y,t_w,t_h)
 -- calculate wether to deflect the ball
 -- horizontally or vertically when it hits a box
 if b_dx == 0 then
  -- moving vertically
  return false
 elseif b_dy == 0 then
  -- moving horizontally
  return true
 else
  -- moving diagonally
  -- calculate slope
  local slp = b_dy / b_dx
  local cx, cy
  -- check variants
  if slp > 0 and b_dx > 0 then
   -- moving down right
   debug1="q1"
   cx = t_x-b_x
   cy = t_y-b_y
   if cx<=0 then
    return false
   elseif cy/cx < slp then
    return true
   else
    return false
   end
  elseif slp < 0 and b_dx > 0 then
   debug1="q2"
   -- moving up right
   cx = t_x-b_x
   cy = t_y+t_h-b_y
   if cx<=0 then
    return false
   elseif cy/cx < slp then
    return false
   else
    return true
   end
  elseif slp > 0 and b_dx < 0 then
   debug1="q3"
   -- moving left up
   cx = t_x+t_w-b_x
   cy = t_y+t_h-b_y
   if cx>=0 then
    return false
   elseif cy/cx > slp then
    return false
   else
    return true
   end
  else
   -- moving left down
   debug1="q4"
   cx = t_x+t_w-b_x
   cy = t_y-b_y
   if cx>=0 then
    return false
   elseif cy/cx < slp then
    return false
   else
    return true
   end
  end
 end
 return false
end
__sfx__
000100001536015360153501533015320153100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
