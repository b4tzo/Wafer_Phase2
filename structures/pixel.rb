module Pixel

  include RBA
  
  # Initialize cell in which the structures are created 
  
  def Pixel.init(cell)
    $Cell = cell
  end

  # Creates an implant 
  # @param layer [layer] Used material
  # @param x [int] Size in x direction
  # @param y [int] Size in y direction
  # @param layerM [layer] Material for contact metal
  # @param metalOH [int] Metal overhang
  # @param x0 [int] X postion of the center of the implant
  # @param y0 [int] Y postion of the center of the implant
  # return [Nill]

  def Pixel.createImplant(layer,x,y,layerM=nil,metalOH=0,x0=0,y0=0,r=5000)
    implant = Basic.createRoundBox(x,y,x0,y0,r)
    metal = Basic.createRoundBox(x+2*metalOH, y+2*metalOH, x0, y0, r)
    $Cell.shapes(layer).insert(implant)
    $Cell.shapes(layerM).insert(metal)
  end
  
  # Create a punch through implant (implant with hole)
  # @param layer [layer] Used material
  # @param x [int] Size in x direction
  # @param y [int] Size in y direction
  # @param x0PT [int] x position of PT
  # @param y0PT [int] y position of PT
  # @param d [int] diameter of PT hole
  # @param x0 [int] center of the implant
  # @param y0 [int] center of the implant
  
  def Pixel.createPTImplant(layer,x,y,x0PT,y0PT,dHole,dImplant=0,x0=0,y0=0)
  
    implant = Basic.createRoundBox(x,y,x0,y0)
    ptHole = Basic.createCircle(dHole,x0PT,y0PT)
    implantHole = Cut.polyVector([implant,ptHole])
    ptImplant = Basic.createCircle(dImplant,x0PT,y0PT)
    
    $Cell.shapes(layer).insert(ptImplant)
    $Cell.shapes(layer).insert(implantHole)
      
  end
  
  # Creates the punch through metal 
  # @param layer [layer] Used material
  # @param x [int] Size in x direction
  # @param y [int] Size in y direction
  # @param x0PT [int] x position of PT
  # @param y0PT [int] y position of PT
  # @param d [int] diameter of PT hole
  # @param blHoleWidth [int] Width of the cut in the metal layer for the bias line
  # @param x0 [int] center of the implant
  # @param y0 [int] center of the implant
  
  def Pixel.createPTMetal(layer,x,y,x0PT,y0PT,d,blHoleWidth,x0=0,y0=0)
    
#     the implant
    implantPoly = Polygon.new(Box.new(-x/2,-y/2,x/2,y/2))
    
#     create box to cut a path in the implant for the bias line
    if x0PT < 0
      biasLineHole = Polygon.new(Box.new(-x/2,y0PT-blHoleWidth/2,x0PT,y0PT+blHoleWidth/2.0))
    else
      biasLineHole = Polygon.new(Box.new(x0PT,y0PT-blHoleWidth/2,x/2,y0PT+blHoleWidth/2.0))
    end
    
#     create hole in implant for the actual punch through
    ptHole = Basic.createCircle(d,x0PT,y0PT,40)
    
    tmp = Merge.polyVector([biasLineHole,ptHole])
    implant = Cut.polyVector([implantPoly,tmp])
#     round corners (does not always work in transition from pt hole to bias line hole)
#     diameter of corners 
#     PUT IN PARAMETER FILE???
    outercornerdia = 5e3
    implantBLPT = implant.round_corners(0,outercornerdia,32)
    
    
    
#     make transition from pt hole to bias line hole round

#     define starting values for iteration
#     dy is the depth of the transition in y direction from the edge of the bias line window
    dy = 2e3
#     depth of the transition in x direction
#     needs to be smaller than the value in implantBLPT = implant.round_corners() => while
    dx = outercornerdia + 1e3
    
#     iteration for asin()
    while ((blHoleWidth/2.0+dy)/(d/2.0)).abs > 0.99 do
      dy -= 1e1
      
      if dy < 0.0
	puts ERROR! change dy
	break
      end
    end
    
#     iteration for dx
    while dx > outercornerdia/2.0 do
#       angle between (d/2, 0) and transition start with (0, 0) depicting the pt hole origin
      alpha = Math.asin((blHoleWidth/2.0+dy)/(d/2.0))
#       radius of transition
      rTrans = dy/(1.0-Math.sin(alpha))
#       depth of the transition in x direction
#       needs to be smaller than the value in implantBLPT = implant.round_corners() (currently 5e3)
      dx = Math.cos(alpha)*rTrans
      dy -= 1e2
    end
    
#     strange extra size to be larger than hole diameter needed for cut and merge routines to work
    spar = 1e0
    
#     parameters
    x0ucp = Math.cos(alpha)*(d/2.0)+dx
    x1ucp = Math.cos(alpha)*(d/2.0)
    y1ucp = (blHoleWidth/2.0)+dy
    yuc = (blHoleWidth/2.0)+rTrans
    x0ubc = x0ucp-rTrans-spar
    x1ubc = x0ucp+rTrans+spar
    y0ubc = (blHoleWidth/2.0)-spar
    y1ubc = (blHoleWidth/2.0)+2.0*rTrans+spar
    y1ulc = (blHoleWidth/2.0)+1.5*dy
    
    if x0PT > 0
      x0ucp *= -1.0
      x1ucp *= -1.0
      y1ucp *= -1.0
      yuc *= -1.0
      x0ubc *= -1.0
      x1ubc *= -1.0
      y1ubc *= -1.0
      y1ulc *= -1.0
    end
    
#     create objects for rounding transitions
#     to be removed from implant
    upperCutPoly = Polygon.new(Box.new(x0PT-x0ucp,y0PT,x0PT-x1ucp,y0PT+y1ucp))
    lowerCutPoly = Polygon.new(Box.new(x0PT-x0ucp,y0PT,x0PT-x1ucp,y0PT-y1ucp))
    tmp = Merge.polyVector([lowerCutPoly,implantBLPT,upperCutPoly])
    tmpImplant = Cut.polyVector([lowerCutPoly,tmp,upperCutPoly])
#     the transition
    upperCirc = Basic.createCircle(2.0*rTrans,x0PT-x0ucp,y0PT+yuc,60)
    lowerCirc = Basic.createCircle(2.0*rTrans,x0PT-x0ucp,y0PT-yuc,60)
    upperBoxCirc = Polygon.new(Box.new(x0PT-x0ubc,y0PT+y0ubc,x0PT-x1ubc,y0PT+y1ubc))
    upperLeaveCirc = Polygon.new(Box.new(x0PT-x0ucp,y0PT+y0ubc,x0PT-x0ubc,y0PT+y1ulc))
    lowerBoxCirc = Polygon.new(Box.new(x0PT-x0ubc,y0PT+y0ubc,x0PT-x1ubc,y0PT-y1ubc))
    lowerLeaveCirc = Polygon.new(Box.new(x0PT-x0ucp,y0PT+y0ubc,x0PT-x0ubc,y0PT-y1ulc))
    
    tmpu = Cut.polyVector([upperBoxCirc,upperLeaveCirc])
    pmtu = Merge.polyVector([tmpu,upperCirc])
    mtpu = Cut.polyVector([tmpu,pmtu])
    tmpl = Cut.polyVector([lowerBoxCirc,lowerLeaveCirc])
    pmtl = Merge.polyVector([tmpl,lowerCirc])
    mtpl = Cut.polyVector([tmpl,pmtl])
    
    implant = Merge.polyVector([tmpImplant,mtpu,mtpl])
    
    $Cell.shapes(layer).insert(implant)
  end
  
  # Creates the bias structure for the punch throughs
  # @param layer [layer] Used material
  # @param pixSizeX [int] Pixel cell size in X
  # @param pixSizeY [int] Pixel cell size in Y
  # @param x0PT [int] x position of PT
  # @param y0PT [int] y position of PT
  # @param dDot [int] Diameter of PT connection dot
  # @param blWidth [int] Width of the bias line 
  # @param x0 [int] center of the implant
  # @param y0 [int] center of the implant
  
  def Pixel.createPTBiasLine(layer,pixSizeX,pixSizeY,x0PT,y0PT,dDot,blWidth,x0=0,y0=0)
  
    dot = Basic.createCircle(dDot,x0PT,y0PT)
    
    if x0PT < 0
      blLength = pixSizeX/2.0 - blWidth/2.0 + x0PT
      biasLine = Polygon.new(Box.new(x0PT-blLength,y0PT-blWidth/2.0,x0PT,y0PT+blWidth/2.0)) 
    else
      blLength = pixSizeX/2.0 - blWidth/2.0 - x0PT
      biasLine = Polygon.new(Box.new(x0PT,y0PT-blWidth/2.0,x0PT+blLength,y0PT+blWidth/2.0)) 
    end
    biasBase = Merge.polyVector([dot,biasLine])
    
#     diameter of transition between bias dot and bias line (should be <(dDot-blWidth)/3.0))
    dy = (dDot-blWidth)/4.0
    
    alpha = Math.asin((blWidth/2.0+dy)/(dDot/2.0))
    rTrans = dy/(1.0-Math.sin(alpha))
    dx = Math.cos(alpha)*rTrans
    
    if x0PT < 0
      upperPoly = Polygon.new(Box.new(x0PT-Math.cos(alpha)*(dDot/2.0)-dx,y0PT,x0PT-Math.cos(alpha)*(dDot/2.0),y0PT+(blWidth/2.0)+dy))  
      lowerPoly = Polygon.new(Box.new(x0PT-Math.cos(alpha)*(dDot/2.0)-dx,y0PT,x0PT-Math.cos(alpha)*(dDot/2.0),y0PT-(blWidth/2.0)-dy)) 
      upperCirc = Basic.createCircle(2*rTrans,x0PT-Math.cos(alpha)*(dDot/2.0)-dx,y0PT+(blWidth/2.0)+rTrans,60)
      lowerCirc = Basic.createCircle(2*rTrans,x0PT-Math.cos(alpha)*(dDot/2.0)-dx,y0PT-(blWidth/2.0)-rTrans,60)
    else
      upperPoly = Polygon.new(Box.new(x0PT+Math.cos(alpha)*(dDot/2.0),y0PT,x0PT+Math.cos(alpha)*(dDot/2.0)+dx,y0PT+(blWidth/2.0)+dy))  
      lowerPoly = Polygon.new(Box.new(x0PT+Math.cos(alpha)*(dDot/2.0),y0PT,x0PT+Math.cos(alpha)*(dDot/2.0)+dx,y0PT-(blWidth/2.0)-dy)) 
      upperCirc = Basic.createCircle(2*rTrans,x0PT+Math.cos(alpha)*(dDot/2.0)+dx,y0PT+(blWidth/2.0)+rTrans,60)
      lowerCirc = Basic.createCircle(2*rTrans,x0PT+Math.cos(alpha)*(dDot/2.0)+dx,y0PT-(blWidth/2.0)-rTrans,60)
    end
    
    biasTmp = Merge.polyVector([lowerPoly,biasBase,upperPoly])
    biasTmp2 = Merge.polyVector([upperCirc,biasTmp,lowerCirc])    
    biasTmp3 = Cut.polyVector([upperCirc,biasTmp2,lowerCirc])
    
#     overlap of biasline into upper and lower pixel (defined by the distance of last pixel to the current collection ring)
    distY = 10e3
    
    if x0PT < 0
      globalBiasLine = Polygon.new(Box.new(x0PT-blLength-blWidth/2.0,-pixSizeY/2.0-distY,x0PT-blLength,pixSizeY/2.0+distY))
      biasTmp4 = Merge.polyVector([biasTmp3,globalBiasLine])
    else
      globalBiasLine = Polygon.new(Box.new(x0PT+blLength,-pixSizeY/2.0-distY,x0PT+blLength+blWidth,pixSizeY/2.0+distY))
      biasTmp4 = Merge.polyVector([biasTmp3,globalBiasLine])
    end
    
#     diameter of transition between horizontal and vertical ("global") biasline
    rTrans = 1.0e3
    
    if x0PT < 0
      upperPoly = Polygon.new(Box.new(x0PT-blLength,y0PT+blWidth/2.0,x0PT-blLength+rTrans,y0PT+blWidth/2.0+rTrans))
      lowerPoly = Polygon.new(Box.new(x0PT-blLength,y0PT-blWidth/2.0,x0PT-blLength+rTrans,y0PT-blWidth/2.0-rTrans))
      upperCirc = Basic.createCircle(2*rTrans,x0PT-blLength+rTrans,y0PT+blWidth/2.0+rTrans)
      lowerCirc = Basic.createCircle(2*rTrans,x0PT-blLength+rTrans,y0PT-blWidth/2.0-rTrans)
    else
      upperPoly = Polygon.new(Box.new(x0PT+blLength,y0PT+blWidth/2.0,x0PT+blLength-rTrans,y0PT+blWidth/2.0+rTrans))
      lowerPoly = Polygon.new(Box.new(x0PT+blLength,y0PT-blWidth/2.0,x0PT+blLength-rTrans,y0PT-blWidth/2.0-rTrans))
      upperCirc = Basic.createCircle(2*rTrans,x0PT+blLength-rTrans,y0PT+blWidth/2.0+rTrans)
      lowerCirc = Basic.createCircle(2*rTrans,x0PT+blLength-rTrans,y0PT-blWidth/2.0-rTrans)
    end
    biasTmp = Merge.polyVector([lowerPoly,biasTmp4,upperPoly])
    biasTmp2 = Merge.polyVector([upperCirc,biasTmp,lowerCirc])    
    bias = Cut.polyVector([upperCirc,biasTmp2,lowerCirc])
      
    $Cell.shapes(layer).insert(bias)
  end

  # Creates the pstop ring in the punch through bias scheme
  # @param layer [layer] Material
  # @param x0PT [int] X Position of the punch through center
  # @param y0PT [int] Y Position of the punch through center
  # @param dIn [int] Inner diameter of the pstop ring
  # @param dOut [int] Outer diameter of the pstop ring
  
  def Pixel.createPTPStop(layer, x0PT, y0PT, dIn, dOut)
    
    pStop = Basic.createCircRing(dIn,dOut,x0PT,y0PT)    
    $Cell.shapes(layer).insert(pStop) 
  end


  # Creates the via in the punch through bias scheme
  # @param layer [layer] Material
  # @param x0PT [int] X Position of the punch through center
  # @param y0PT [int] Y Position of the punch through center
  # @param d [int] Diameter of the via

  def Pixel.createPTVia(layer, x0PT, y0PT, d)

    via = Basic.createCircle(d,x0PT,y0PT)
    $Cell.shapes(layer).insert(via)    
  end
  
  # Creates a grid
  # @param pixel [cell] Base structure cell
  # @param nx [int] Number of pixels in x direction
  # @param ny [int] Number of pixels in y direction
  # @param distX [int] Distance between two pixel cells in x direction
  # @param distY [int] Distance between two pixel cells in y direction
  # @param x0 [int] X position of the center of the first pixel
  # @param y0 [int] Y position of the center of the first pixel
  # @param rot [deg] Angle of rotation in degree
  # @param mir [bool] Mirror the cell on the x axis
  # @return [Nill]

  def Pixel.createGrid(pixel,nx=1,ny=1,distX=0,distY=0,x0=0,y0=0,rot=0,mir=false) 
  
    for i in 0..nx-1
      for j in 0..ny-1
        Merge.cells($Cell,pixel,x0+(i*distX),y0+(j*distY),rot,mir)
      end
    end    
  end

  # Creates a via
  # @param layer [layer] Used material 
  # @param x [int] Size in x direction
  # @param y [int] Size in y direction
  # @param x0 [int] X postion of the center of the via
  # @param y0 [int] Y postion of the center of the via  
  # @return [Nill]

  def Pixel.createVia(layer,x,y,x0=0,y0=0)
    box = Polygon.new(Box.new(-x/2,-y/2,x/2,y/2))
    box.move(x0,y0)
    $Cell.shapes(layer).insert(box)
  end

  # Creates a via grid (WILL BE EDITED!!!)
  # @param layer [layer] Used material
  # @param x [int] Size in x direction
  # @param y [int] Size in y direction
  # @param nx [int] Number of vias in x direction
  # @param ny [int] Number of vias in y direction
  # @param distX [int] Distance between two vias in x direction
  # @param distY [int] Distance between two vias in y direction
  # @param x0 [int] X postion of the center of the first via
  # @param y0 [int] Y postion of the center of the first via  
  # @return [Nill]
  
  def Pixel.createViaGrid(layer,x,y,nx,ny,distX,distY,x0=0,y0=0)
    
    for i in 0..nx-1
      for j in 0..ny-1
        box = Polygon.new(Box.new((i*distX),(j*distY),(i*distX)+x,(j*distY)+y))
        box.move(x0,y0)
        $Cell.shapes(layer).insert(box)
      end
    end

  end

  # Creates a BumpPad
  # @param layer [layer] Used material
  # @param dia [int] Diameter of the BumpPad
  # @param x0 [int] X postion of the center of the BumpPad
  # @param y0 [int] Y postion of the center of the BumpPad
  # @param layerPass [layer] passivation window
  # @param diaPass [int] Diameter of the passivation window
  # @return [Nill]

  def Pixel.createBumpPad(layer,dia,x0=0,y0=0,layerPass=0,diaPass=0)

    bump = Basic.createOctagon(dia,x0,y0)
    $Cell.shapes(layer).insert(bump)
    
    if (layerPass!=0)
      bumpPass = Basic.createOctagon(diaPass,x0,y0)
    $Cell.shapes(layerPass).insert(bumpPass)
    end
  end

  # Creates a open/closed pStop
  # @param layer [layer] Used material
  # @param x [int] Size x of the inner edge of the ring
  # @param y [int] Size y of the inner edge of the ring
  # @param width [int] Width of the ring
  # @param rOut [int] Outer radius of the corner
  # @param rIn [int] Inner radius of the corner
  # @param oX [int] X position of the lower left corner of the opening
  # @param oY [int] Y position of the lower left corner of the opening
  # @param oW [int] Size of the opening
  # @param horizontal [bool] Is the opening horizontal or vertical?
  # @param x0 [int] X position of the center of the ring
  # @param y0 [int] Y position of the center of the ring
  # @return [Nill]

  def Pixel.createPStop(layer, x, y, width, rOut, rIn, oX=0, oY=0, oW=0, horizontal=true ,x0=0, y0=0)
        
    ring = Basic.createRing(x,y,width,rIn,rOut)

    if horizontal
    
      openBox = Polygon.new(Box.new(oX,oY,oX+oW,oY+width))
      ringOpen = Cut.polyVector([ring,openBox])
    
      endPoly1 = Polygon.new(Box.new(oX-(width/2.0),oY,oX+(width/2.0),oY+width))
      endCirc1 = endPoly1.round_corners(0,(width/2.0),32)
    
      endPoly2 = Polygon.new(Box.new(oX+oW-(width/2.0),oY,oX+oW+(width/2.0),oY+width))
      endCirc2 = endPoly2.round_corners(0,(width/2.0),32)
      
    else
      
      openBox = Polygon.new(Box.new(oX,oY,oX+width,oY+oW))
      ringOpen = Cut.polyVector([ring,openBox])
    
      endPoly1 = Polygon.new(Box.new(oX,oY-(width/2.0),oX+width,oY+(width/2.0)))
      endCirc1 = endPoly1.round_corners(0,(width/2.0),32)
    
      endPoly2 = Polygon.new(Box.new(oX,oY+oW-(width/2.0),oX+width,oY+oW+(width/2.0)))
      endCirc2 = endPoly2.round_corners(0,(width/2.0),32)      
         
    end
     
    pStop = Merge.polyVector([ringOpen,endCirc1,endCirc2])
    pStop.move(x0,y0)
    
    $Cell.shapes(layer).insert(pStop)  
  end
  
end