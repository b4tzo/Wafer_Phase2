module Periphery

  include RBA

  def Periphery.init(cell)
    $Cell = cell
  end


  def Periphery.create(layerImp, layerMet, layerPassOpen, layerEdge, pixelGrid, biasRing, guardRing, pixelEdge)
  
    Periphery.ring(layerImp,pixelGrid['sizeX']+2*biasRing['distX'],pixelGrid['sizeY']+2*biasRing['distY'],biasRing['width'],biasRing['rIn'],biasRing['rOut'])
    Periphery.ring(layerMet,pixelGrid['sizeX']+2*biasRing['aluDistX'],pixelGrid['sizeY']+2*biasRing['aluDistY'],biasRing['aluWidth'],biasRing['aluRIn'],biasRing['aluROut'])
              
    Pixel.viaGrid(layerMet,6e3,6e3,(pixelGrid['sizeX']/74.5e3).round,1,74.5e3,0,-pixelGrid['sizeX']/2,-pixelGrid['sizeY']/2-biasRing['width']/2)
    Pixel.viaGrid(layerMet,6e3,6e3,(pixelGrid['sizeX']/74.5e3).round,1,74.5e3,0,-pixelGrid['sizeX']/2,pixelGrid['sizeY']/2+biasRing['width']/2)    
    Pixel.viaGrid(layerMet,6e3,6e3,1,(pixelGrid['sizeY']/74.5e3).round,0,74.5e3,-pixelGrid['sizeX']/2-biasRing['width']/2,-pixelGrid['sizeY']/2)   
    Pixel.viaGrid(layerMet,6e3,6e3,1,(pixelGrid['sizeY']/74.5e3).round,0,74.5e3,pixelGrid['sizeX']/2+biasRing['width']/2,-pixelGrid['sizeY']/2)             
    Periphery.passOpening(layerPassOpen,pixelGrid['sizeX'],biasRing['width']-10e3,0,-pixelGrid['sizeY']/2-biasRing['distY']-biasRing['width']/2) 
              
    Periphery.ring(layerImp,pixelGrid['sizeX']+2*guardRing['distX'],pixelGrid['sizeY']+2*guardRing['distY'],guardRing['width'],guardRing['rIn'],guardRing['rOut'])
    Periphery.ring(layerMet,pixelGrid['sizeX']+2*guardRing['aluDistX'],pixelGrid['sizeY']+2*guardRing['aluDistY'],guardRing['aluWidth'],guardRing['aluRIn'],guardRing['aluROut'])
  
    Pixel.viaGrid(layerMet,6e3,6e3,(pixelGrid['sizeX']/74.5e3).round,1,74.5e3,0,-pixelGrid['sizeX']/2,-pixelGrid['sizeY']/2-guardRing['distY']-guardRing['width']/2)
    Pixel.viaGrid(layerMet,6e3,6e3,(pixelGrid['sizeX']/74.5e3).round,1,74.5e3,0,-pixelGrid['sizeX']/2,pixelGrid['sizeY']/2+guardRing['distY']+guardRing['width']/2)
    Pixel.viaGrid(layerMet,6e3,6e3,1,(pixelGrid['sizeY']/74.5e3).round,0,74.5e3,-pixelGrid['sizeX']/2-guardRing['distX']-guardRing['width']/2,-pixelGrid['sizeY']/2)
    Pixel.viaGrid(layerMet,6e3,6e3,1,(pixelGrid['sizeY']/74.5e3).round,0,74.5e3,pixelGrid['sizeX']/2+guardRing['distX']+guardRing['width']/2,-pixelGrid['sizeY']/2)
    Periphery.passOpening(layerPassOpen,pixelGrid['sizeX'],guardRing['aluWidth']-10e3,0,-pixelGrid['sizeY']/2-guardRing['aluDistY']-guardRing['aluWidth']/2)
  
    Periphery.edge(layerEdge,pixelGrid['sizeX']+2*pixelEdge['distX'],pixelGrid['sizeY']+2*pixelEdge['distY'],pixelEdge['sizeX'],pixelEdge['sizeY'],pixelEdge['outerX0'],pixelEdge['outerY0'])
    Periphery.edge(layerMet,pixelGrid['sizeX']+2*pixelEdge['aluDistX'],pixelGrid['sizeY']+2*pixelEdge['aluDistY'],pixelEdge['aluSizeX'],pixelEdge['aluSizeY'],pixelEdge['outerX0'],pixelEdge['outerY0'])
  end


  def Periphery.ring(layer,x,y,width,rIn,rOut,x0=0,y0=0)

    ring = Basic.ring(x,y,width,rIn,rOut,x0,y0)
    $Cell.shapes(layer).insert(ring)
  end


  def Periphery.edge(layer,xi,yi,xo,yo,x0=0,y0=0)
    innerBox = Polygon.new(Box.new(-xi/2,-yi/2,xi/2,yi/2))
    outerBox = Polygon.new(Box.new(-xo/2,-yo/2,xo/2,yo/2))
    outerBox.move(x0,y0)
    
    edge = Cut.polyVector([outerBox,innerBox])
    $Cell.shapes(layer).insert(edge)
  end

  def Periphery.passOpening(layer,x,y,x0=0,y0=0,r=10e3)
    opening = Basic.roundBox(x,y,x0,y0,r)
    $Cell.shapes(layer).insert(opening)
  end

end