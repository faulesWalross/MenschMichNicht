
-- load start
  function love.load()

  -- Laden der Bilddateien
  area = love.graphics.newImage(areaPNG)
  base1 = love.graphics.newImage(base1PNG)
  base2 = love.graphics.newImage(base2PNG)
  base3 = love.graphics.newImage(base3PNG)
  base4 = love.graphics.newImage(base4PNG)
  lane  = love.graphics.newImage(lanePNG)

  start1 = love.graphics.newImage(start1PNG)

  --Tabelle für das Spielbrett mit Hintergrund füllen
  posAreaPattern()

  --Basisfelder für Spieler 1 (links oben)
  --posBasePattern(base1,0,0,1,1,1)
  --posBasePattern(32,0,0,1,1,1,colourPlayer1)
  --Basisfelder für Spieler 2 (rechts oben)
  --posBasePattern(base2,love.graphics.getWidth() - base2:getWidth(),0,-1,1,2)
  --Basisfelder für Spieler 3 (links unten)
  --posBasePattern(base3,0,love.graphics.getHeight() - base3:getHeight(),1,-1,3)
  --Basisfelder für Spieler 4 (rechts unten)
  --posBasePattern(base4,love.graphics.getWidth() - base4:getWidth(),love.graphics.getHeight() - base4:getHeight(),-1,-1,4)

  --Spielfeld Laden
  --posLanePattern (love.graphics.getWidth(), love.graphics.getHeight())

end -- load end

--##############################################################################

-- update start
function love.update(dt)
  if love.keyboard.isDown("escape") then
    love.event.push("quit")
  end
end -- update end

--##############################################################################

-- draw start
function love.draw()
  love.graphics.setColor(255, 255, 255)
  --Zeichnen des Hintergrunds
  for z,pattern in ipairs(tblArea) do
    love.graphics.draw(pattern.img, pattern.left, pattern.top)                                              --Graphic ausgeben
    --love.graphics.printf(pattern.left..","..pattern.top, pattern.left, pattern.top,pattern.img:getWidth(),"center")   --Koordinaten ausgeben
  end

  love.graphics.setColor(0, 100, 140)
  love.graphics.circle("fill", 100, 100, 50)
love.graphics.setColor(0, 0, 0)
  love.graphics.circle("line", 100, 100, 50)


  --Zeichnen der Basisfelder
  for z,pattern in ipairs(tblBase) do
      love.graphics.setColor(unpack(pattern.colour))
      love.graphics.circle("fill", pattern.posX, pattern.posY, pattern.diameter*1.08)
      love.graphics.setColor(0, 255, 0)
      love.graphics.circle("fill", 100, 100, 32, segments)
    --love.graphics.draw(pattern.img, pattern.left, pattern.top)                                              --Graphic ausgeben
    --love.graphics.printf(pattern.left..","..pattern.top, pattern.left, pattern.top,pattern.img:getWidth(),"center")   --Koordinaten ausgeben
  end

  --Zeichnen der Spielpfads
  for z,pattern in ipairs(tblLane) do
    love.graphics.draw(pattern.img, pattern.left, pattern.top)--, math.rad(pattern.rota), 1, 1, laneWidth/2, laneHeight/2)                                              --Graphic ausgeben
    --love.graphics.printf(pattern.left..","..pattern.top, pattern.left, pattern.top,pattern.img:getWidth(),"center")   --Koordinaten ausgeben
  end

  --love.graphics.printf(NoShortLanePattern..","..NoLongLanePattern, 0, love.graphics.getHeight()/2, love.graphics.getWidth(), "center")
end -- draw end
