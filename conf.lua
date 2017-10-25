function love.conf(t)
tblArea = {}
tblBase = {}
tblLane = {}

NoPlayer = 4                      --Anzahl der Spielerfarben (keine Variable!)
NoBase = 4                       --Anzahl der Basisfelder
NoRows = 11                       --Anzahl der Zeilen des Spielbretts
NoColumns = NoRows                --Anzahl der Spalten des Spielbretts
WidthPattern = 32                 --Breite eines Feldes
HeigthPattern = 32                --Höhe eines Feldes

colourPlayer1 = {255, 0, 0}
areaPNG = "assets/area.png"       --Bilddatei für den Hintergrund
base1PNG = "assets/base1.png"     --Bilddatei für Basis Spieler 1
base2PNG = "assets/base2.png"     --Bilddatei für Basis Spieler 2
base3PNG = "assets/base3.png"     --Bilddatei für Basis Spieler 3
base4PNG = "assets/base4.png"     --Bilddatei für Basis Spieler 4
lanePNG = "assets/lane.png"       --Bilddatei für Spielpfad
start1PNG = "assets/start1.png"   --Startfeld Spieler 1


--Anordnung der Basisfelder
  --Anzahl der Felder in der Breite mit Rundung auf eine ganze Zahl
  widthBase = NoBase^(1 / 2) + 0.999
  widthBase = widthBase - (widthBase % 1)
  --Anzahl der Felder in der Höhe mit Rundung auf eine ganze Zahl
  heightBase = NoBase / widthBase + 0.999
  heightBase = heightBase - (heightBase % 1)

t.window.width = NoColumns * WidthPattern
t.window.height = NoRows * HeigthPattern
t.window.title = "Mensch mich nicht"
end

-- Funktion zur Positionierung der Basisfelder
function posBasePatter (leftPos, topPos, img)
  j=1
  i=1
  for c=1, NoBase do
    if i>= widthBase+1 then
      j=j+1
      i=1
    end
    tblArea[(leftPos+i)+((j+topPos-1)*NoColumns)]=img
    i=i+1
  end
end

--Funktion zur Positionierung des Hintergrunds
function posAreaPattern ()
  areaWidth = area:getWidth()            --Breite der Grafik
  areaHeight = area:getHeight()          --Höhe der Grafik
  z = 0
  for j=1, NoRows do                        --Schleife für die Zeilen
    for i=1,NoColumns  do                   --Schleife für die Spalten
      z = z + 1                             --Zähler für die Tabellenzeilen
      tblArea [z] = {
                      img = area,
                      left =(i - 1) * areaWidth ,
                      top = (j - 1) * areaHeight,
                    }
    end
  end
end

--Funktion zur Positionierung der Basisfelder
function posBasePattern (dia, posLeft, posTop, PlayerNumber, col)
  --pic = Bilddatei
  --startLeft = linke Position des ersten Feldes
  --startTop = obere Position des ersten Feldes
  --directionLeft = 1 oder -1, gibt an in welcher Spalte das nächste Feld liegt -> 1 = nach recht
  --directionTop = 1 oder -1, gibt an in welcher Zeile das nächste Feld liegt -> 1 = nach unten
  --PlayerNumber = Spielernummer
  --baseWidth = pic:getWidth()
  --baseHeight = pic:getHeight()
  --r, g, b = unpack(col)
  j = 0
  i = 0
  posLeft =posLeft + (dia * 1.08) / 2
  posTop = posTop + (dia * 1.08) / 2
  for c = NoBase * (PlayerNumber - 1) + 1, NoBase * PlayerNumber do
    if i * posLeft >= widthBase  then
      j = j + (1.5 * dia)
      i = 0
    end
    tblBase [c] = {
                    posX =posLeft + i * dia,
                    posY = posTop + j * dia,
                    diameter = dia,
                    --colour = {r, g, b}
                  }
    i = i + (1.5 * dia)
  end
end


--Funktion zur Positionierung des Spielpfads
function posLanePattern (windowWidth, windowHeight)
  laneWidth = lane:getWidth()
  laneHeight = laneWidth--lane:getHeight()
  directionLeft= 1
  directionTop = -1

  --Anzahl der Felder des kurzen Abschnitts mit Abrundung
  NoShortLanePattern = (windowWidth / 2 - widthBase * baseWidth - laneWidth/2) / laneWidth
  NoShortLanePattern = NoShortLanePattern - (NoShortLanePattern % 1) - 1
  --Anzahl der Felder des langen Abschnitts mit Abrundung
  NoLongLanePattern = (windowWidth / 2) / laneWidth - NoShortLanePattern / 2
  NoLongLanePattern = NoLongLanePattern - (NoLongLanePattern % 1)
  --Startposition des ersten Feldes für den Pfad
  leftPosPattern = windowWidth / 2 - ((NoLongLanePattern + (NoShortLanePattern +1) / 2) * laneWidth) --+ laneWidth
  topPosPattern = windowHeight / 2 - (NoShortLanePattern + 1) / 2 * laneHeight
  --Anzahl der Felder pro Spielabschnitt
  NoLanePattern = 2 * NoLongLanePattern + NoShortLanePattern

  rotation = 270
  patternX = NoLongLanePattern
  patternY = NoLongLanePattern
  drawX = true
  drawY = false

  i = 1
  j = 0
  z = 0
  for c = 1, NoPlayer * NoLanePattern do
    z = z + 1

   if z == NoLanePattern then
     if math.abs(topPosPattern) <= laneHeight then
       directionTop = directionTop * -1
     end
     if math.abs(topPosPattern) >=  windowWidth - laneHeight then
       directionTop = directionTop * -1
       patternY = NoLongLanePattern
     end
     if math.abs(leftPosPattern) <= laneWidth then
       directionLeft = directionLeft * -1
     end
     if math.abs(leftPosPattern) >= windowWidth - laneWidth then
       directionLeft = directionLeft * -1
       patternX = NoLongLanePattern
     end
     z = 0
   end

    if drawX then
      leftPosPattern = leftPosPattern + laneWidth * directionLeft
      i = i + 1
    end

    if drawY then
      topPosPattern = topPosPattern + laneHeight * directionTop
      j = j + 1
    end

    if i > patternX and i ~= 0 then
      drawX = false
      drawY = true
      rotation = rotation - 90
      if patternX == NoLongLanePattern then
        patternX = NoShortLanePattern
      else
        patternX = NoLongLanePattern
      end
      j = 1
      i = 0
    end

    if j > patternY and j ~= 0 then
      drawX = true
      drawY = false
      rotation = rotation - 90
      if patternY == NoLongLanePattern and directionTop == 1 then
        patternY = NoShortLanePattern
      else
        patternY = NoLongLanePattern
      end
      j = 0
      i = 1
    end

    tblLane [c] = {
                    img = lane,
                    left =leftPosPattern,
                    top = topPosPattern,
                    rota = rotation
                  }
  end


  --maxLanePatternHeight = topPosPattern - areaHeight + windowHeight - (2 * heightBase * baseHeight) - (4 * areaHeight)
  --maxLanePatternLen =  leftPosPattern + windowWidth / 2 - laneWidth / 2 - laneWidth

  --for c = 1, NoPlayer * (maxLanePatternHeight / laneHeight + maxLanePatternLen / laneWidth) do
  --  tblLane [c] = {
  --                  img = lane,
  --                  left =leftPosPattern,
  --                  top = topPosPattern,
  --                }

  --  if topPosPattern <  maxLanePatternHeight  then
  --    topPosPattern = topPosPattern + (laneHeight * directionTop)
  --  elseif leftPosPattern < maxLanePatternLen then
  --    leftPosPattern = leftPosPattern + (laneWidth * directionLeft)
  --  end

  --  if topPosPattern == maxLanePatternHeight  then
  --    directionTop = directionTop * - 1
  --  end
    --else
    --  directionLeft = directionLeft * - 1
    --end

    --i = i + 1
  --end
end
