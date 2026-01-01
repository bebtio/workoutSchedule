util = {}

util.print = function(text, color, x, y, r, sx ,sy, ox, oy, kx, ky)

    love.graphics.setColor(color)
    love.graphics.print(text, x,y,r,sx,sy,ox,oy,kx,ky)
    love.graphics.setColor(1,1,1)
end