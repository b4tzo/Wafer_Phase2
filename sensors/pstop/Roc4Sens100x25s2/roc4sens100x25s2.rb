module Roc4Sens100x25s2
  
  include RBA

  # Creates a sensor with a pitch of 25x100 µm² for the roc4sens pattern
  # @return [cell] Returns the cell with all structures

  def Roc4Sens100x25s2.create()
  
    load "Wafer_Phase2/sensors/pstop/Roc4Sens100x25s2/roc4sens100x25s2_para.rb"
        
    $roc4Sens100x25s2 = $layout.create_cell("Roc4Sens100x25s2")
    
    innerPixelCell = $layout.create_cell("InnerPixel")      
    Pixel.init(innerPixelCell)
    Pixel.createImplant($layerNp,InnerImplant['sizeX'],InnerImplant['sizeY'],$layerAlu,InnerImplant['metalOH'],0,0,InnerImplant['radius'])
    Pixel.createVia($layerAluVia, Via['sizeX'],Via['sizeY'],-25e3)
    Pixel.createBumpPad($layerAlu,BumpPad['dia'])
    Pixel.createPStop($layerPp, InnerImplant['sizeX']+2*InnerPStop['distX'], InnerImplant['sizeY']+2*InnerPStop['distY'], InnerPStop['width'], InnerPStop['rOut'] , InnerPStop['rIn'])

    outerPixelCell = $layout.create_cell("OuterCell")
    Pixel.init(outerPixelCell)
    Pixel.createImplant($layerNp,OuterImplant['sizeX'],OuterImplant['sizeY'],$layerAlu,OuterImplant['metalOH'],0,0,OuterImplant['radius'])
    Pixel.createVia($layerAluVia, Via['sizeX'],Via['sizeY'],-25e3)
    Pixel.createBumpPad($layerAlu,BumpPad['dia'],25e3)
    Pixel.createPStop($layerPp, OuterImplant['sizeX']+2*InnerPStop['distX'], OuterImplant['sizeY']+2*InnerPStop['distY'], InnerPStop['width'], InnerPStop['rOut'] , InnerPStop['rIn'])

    pixelGridCell = $layout.create_cell("PixelGrid")
    Pixel.init(pixelGridCell)
    Pixel.createGrid(innerPixelCell,InnerPixelGrid['nX'], InnerPixelGrid['nY'], InnerPixelGrid['dX'], InnerPixelGrid['dY'], -PixelGrid['sizeX']/2+(InnerPixelGrid['sizeX']/2), -PixelGrid['sizeY']/2+(InnerPixelGrid['sizeY']/2))
    Pixel.createGrid(innerPixelCell,InnerPixelGrid['nX'], InnerPixelGrid['nY'], InnerPixelGrid['dX'], InnerPixelGrid['dY'], -PixelGrid['sizeX']/2+2*InnerPixelGrid['sizeX'], -PixelGrid['sizeY']/2+(3*InnerPixelGrid['sizeY']/2))
    Pixel.createGrid(outerPixelCell,OuterPixelGrid['nX'], OuterPixelGrid['nY'], OuterPixelGrid['dX'], OuterPixelGrid['dY'], -PixelGrid['sizeX']/2+OuterPixelGrid['sizeX']/2, -PixelGrid['sizeY']/2+(3*OuterPixelGrid['sizeY']/2))
    Pixel.createGrid(outerPixelCell,OuterPixelGrid['nX'], OuterPixelGrid['nY'], OuterPixelGrid['dX'], OuterPixelGrid['dY'], PixelGrid['sizeX']/2-OuterPixelGrid['sizeX']/2, -PixelGrid['sizeY']/2+(OuterPixelGrid['sizeY']/2),180)
 
    Merge.cells($roc4Sens100x25s2, pixelGridCell)

    periCell = $layout.create_cell("Periphery")
    Periphery.init(periCell)
    Periphery.create($layerNp,$layerAlu,$layerPpe19,PixelGrid,BiasRing,GuardRing,PixelEdge)

    Merge.cells($roc4Sens100x25s2, periCell)

    return $roc4Sens100x25s2
  end
end
