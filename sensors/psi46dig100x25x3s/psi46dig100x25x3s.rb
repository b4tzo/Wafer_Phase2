module PSI46DIG100x25x3noedge
  
  include RBA

  # Creates 100x30 FCP130 pattern sensor with common punch-thru
  # @return [cell] Returns the cell with all structures

  def PSI46DIG100x25x3noedge.create(layout,sensor)
    
    $sensor = layout.create_cell("PSI46DIG100x25")
    
    innerPixelCell1 = layout.create_cell("InnerPixel1")      
    Pixel.init(innerPixelCell1)
    Pixel.ptImplant($layerNp,InnerPixel['implantSizeX'],InnerPixel['implantSizeY'],InnerPixel['PTX0'],InnerPixel['PTY0'],InnerPixel['PTholeDia'],InnerPixel['PTimplantDia'],0,-InnerPixel['shiftX'])
    Pixel.ptImplant($layerAlu,InnerPixel['implantSizeX']+2.0*InnerPixel['metalOH'],InnerPixel['implantSizeY']+2.0*InnerPixel['metalOH'],InnerPixel['PTX0'],InnerPixel['PTY0'],InnerPixel['PTholeDia']-2.0*InnerPixel['innerPTmetalOH'],-InnerPixel['shiftX'])
    Pixel.bumpPad($layerPassOpen,BumpPad['bPDiaPassivation']-2e3,InnerPixel['bPX0'],InnerPixel['bPY0'])
    Pixel.bumpPad($layerAlu,BumpPad['bPDia'],InnerPixel['bPX0'],InnerPixel['bPY0'])
    Pixel.ptVia($layerAluVia,InnerPixel['viaX0'],InnerPixel['viaY0'],InnerPixel['viaDia'])
    Pixel.ptVia($layerAluVia,InnerPixel['viaX0'],-InnerPixel['viaY0'],InnerPixel['viaDia'])
    Pixel.pStop($layerPp, InnerPixel['implantSizeX']+2*InnerPixel['PSdistX'], InnerPixel['implantSizeY']+2*InnerPixel['PSdistY'], InnerPixel['PSwidth'], InnerPixel['PSrOut'] , InnerPixel['PSrIn'], InnerPixel['PSopenX0'], InnerPixel['PSopenY0'], InnerPixel['PSopenWidth'],true)
    
    innerPixelCell2 = layout.create_cell("InnerPixel2")      
    Pixel.init(innerPixelCell2)
    Pixel.ptImplant($layerNp,InnerPixel['implantSizeX'],InnerPixel['implantSizeY'],InnerPixel['PTX0'],InnerPixel['PTY0'],InnerPixel['PTholeDia'],InnerPixel['PTimplantDia'],0,-InnerPixel['shiftX'])
    Pixel.ptImplant($layerAlu,InnerPixel['implantSizeX']+2.0*InnerPixel['metalOH'],InnerPixel['implantSizeY']+2.0*InnerPixel['metalOH'],InnerPixel['PTX0'],InnerPixel['PTY0'],InnerPixel['PTholeDia']-2.0*InnerPixel['innerPTmetalOH'],-InnerPixel['shiftX'])
    Pixel.ptVia($layerAluVia,InnerPixel['viaX0'],InnerPixel['viaY0'],InnerPixel['viaDia'])
    Pixel.ptVia($layerAluVia,InnerPixel['viaX0'],-InnerPixel['viaY0'],InnerPixel['viaDia'])
    Pixel.pStop($layerPp, InnerPixel['implantSizeX']+2*InnerPixel['PSdistX'], InnerPixel['implantSizeY']+2*InnerPixel['PSdistY'], InnerPixel['PSwidth'], InnerPixel['PSrOut'] , InnerPixel['PSrIn'], InnerPixel['PSopenX0'], InnerPixel['PSopenY0'], InnerPixel['PSopenWidth'],true)    
    
    largePixelCell = layout.create_cell("LargePixel")      
    Pixel.init(largePixelCell)
    Pixel.routingImplant($layerNp,LargePixel['implantSizeX'],LargePixel['implantSizeY'], LargePixel['routingdist'], LargePixel['routingwidth'], BumpPad['bPDia'], LargePixelBPPar, false)
    Pixel.routingImplant($layerAlu,LargePixel['implantSizeX']+2.0*LargePixel['metalOH'],LargePixel['implantSizeY']+2.0*LargePixel['metalOH'], LargePixel['routingdist']-LargePixel['metalOH'], LargePixel['routingwidth'], BumpPad['bPDia'], LargePixelBPPar, true)
    Pixel.bumpPad($layerPassOpen,BumpPad['bPDiaPassivation'],LargePixelBP['bPX0'],LargePixelBP['bPY0'])
    Pixel.bumpPad($layerAlu,BumpPad['bPDia'],LargePixelBP['bPX0'],LargePixelBP['bPY0'])
    Pixel.bumpPad($layerPassOpen,BumpPad['bPDiaPassivation'],LargePixelBPPar[0],LargePixelBPPar[1])
    Pixel.bumpPad($layerAlu,BumpPad['bPDia'],LargePixelBPPar[0],LargePixelBPPar[1])
    Pixel.bumpPad($layerPassOpen,BumpPad['bPDiaPassivation'],LargePixelBPPar[4],LargePixelBPPar[5])
    Pixel.bumpPad($layerAlu,BumpPad['bPDia'],LargePixelBPPar[4],LargePixelBPPar[5])
    # create via grid
    i = 0
    sign = 1
    # distance between vias
    dist = 50e3
    while i*dist<=LargePixel['implantSizeX']-2*LargePixel['viaX0'] do 
      Pixel.ptVia($layerAluVia,LargePixel['viaX0']+i*dist-LargePixel['implantSizeX']/2,sign*LargePixel['viaY0'],LargePixel['viaDia'])
      i+=1
      if sign==1 && i*dist>LargePixel['implantSizeX']-2*LargePixel['viaX0']
        sign = -1
        i = 0
      end
    end
    Pixel.pStop($layerPp, LargePixel['implantSizeX']+2*LargePixel['PSdistX'], LargePixel['implantSizeY']+2*LargePixel['PSdistY'], LargePixel['PSwidth'], LargePixel['PSrOut'] , LargePixel['PSrIn'], LargePixel['PSopenX0'], LargePixel['PSopenY0'], LargePixel['PSopenWidth'],true)
    
    leftPixelCell = layout.create_cell("LeftPixel")
    Pixel.init(leftPixelCell)
    Pixel.routingImplant($layerNp,LeftPixel['implantSizeX'],LargePixel['implantSizeY'], LargePixel['routingdist'], LargePixel['routingwidth'], BumpPad['bPDia'], LeftPixelBPPar, false)
    Pixel.routingImplant($layerAlu,LeftPixel['implantSizeX']+2.0*LargePixel['metalOH'],LargePixel['implantSizeY']+2.0*LargePixel['metalOH'], LargePixel['routingdist']-LargePixel['metalOH'], LargePixel['routingwidth'], BumpPad['bPDia'], LeftPixelBPPar, true)
    Pixel.bumpPad($layerPassOpen,BumpPad['bPDiaPassivation'],LeftPixel['bPX0'],LeftPixel['bPY0'])
    Pixel.bumpPad($layerAlu,BumpPad['bPDia'],LeftPixel['bPX0'],LargePixel['bPY0'])
    Pixel.bumpPad($layerPassOpen,BumpPad['bPDiaPassivation'],LeftPixelBPPar[0],LeftPixelBPPar[1])
    Pixel.bumpPad($layerAlu,BumpPad['bPDia'],LeftPixelBPPar[0],LeftPixelBPPar[1])
    # create via grid
    i = 0
    sign = 1
    # distance between vias
    dist = 50e3
    while i*dist<=LeftPixel['implantSizeX']-2*LargePixel['viaX0'] do 
      Pixel.ptVia($layerAluVia,LargePixel['viaX0']+i*dist-LeftPixel['implantSizeX']/2,sign*LargePixel['viaY0'],LargePixel['viaDia'])
      i+=1
      if sign==1 && i*dist>LeftPixel['implantSizeX']-2*LargePixel['viaX0']
        sign = -1
        i = 0
      end
    end
    Pixel.pStop($layerPp, LeftPixel['implantSizeX']+2*LargePixel['PSdistX'], LargePixel['implantSizeY']+2*LargePixel['PSdistY'], LargePixel['PSwidth'], LargePixel['PSrOut'] , LargePixel['PSrIn'], LargePixel['PSopenX0'], LargePixel['PSopenY0'], LargePixel['PSopenWidth'],true)
    
    
    rightPixelCell = layout.create_cell("RightPixel")
    Pixel.init(rightPixelCell)
    Pixel.routingImplant($layerNp,RightPixel['implantSizeX'],LargePixel['implantSizeY'], LargePixel['routingdist'], LargePixel['routingwidth'], BumpPad['bPDia'])
    Pixel.routingImplant($layerAlu,RightPixel['implantSizeX']+2.0*LargePixel['metalOH'],LargePixel['implantSizeY']+2.0*LargePixel['metalOH'], LargePixel['routingdist']-LargePixel['metalOH'], LargePixel['routingwidth'], BumpPad['bPDia'])
    Pixel.bumpPad($layerPassOpen,BumpPad['bPDiaPassivation'],RightPixel['bPX0'],LargePixel['bPY0'])
    Pixel.bumpPad($layerAlu,BumpPad['bPDia'],RightPixel['bPX0'],LargePixel['bPY0'])
    # create via grid
    i = 0
    sign = 1
    # distance between vias
    dist = 50e3
    while i*dist<=RightPixel['implantSizeX']-2*LargePixel['viaX0'] do 
      Pixel.ptVia($layerAluVia,LargePixel['viaX0']+i*dist-RightPixel['implantSizeX']/2,sign*LargePixel['viaY0'],LargePixel['viaDia'])
      i+=1
      if sign==1 && i*dist>RightPixel['implantSizeX']-2*LargePixel['viaX0']
        sign = -1
        i = 0
      end
    end
    Pixel.pStop($layerPp, RightPixel['implantSizeX']+2*LargePixel['PSdistX'], LargePixel['implantSizeY']+2*LargePixel['PSdistY'], LargePixel['PSwidth'], LargePixel['PSrOut'] , LargePixel['PSrIn'], LargePixel['PSopenX0'], LargePixel['PSopenY0'], LargePixel['PSopenWidth'],true)
    
    
    
    
    
    #     upper pixel row
#     uinnerPixelCell1 = layout.create_cell("UpperInnerPixel1")      
#     Pixel.init(uinnerPixelCell1)
#     Pixel.ptImplant($layerNp,InnerPixel['implantSizeX'],InnerPixel['implantSizeY']+UpperRow['Yplus'],InnerPixel['PTX0'],InnerPixel['PTY0'],InnerPixel['PTholeDia'],InnerPixel['PTimplantDia'],0,-InnerPixel['shiftX'])
#     Pixel.ptImplant($layerAlu,InnerPixel['implantSizeX']+2.0*InnerPixel['metalOH'],InnerPixel['implantSizeY']+UpperRow['Yplus']+2.0*InnerPixel['metalOH'],InnerPixel['PTX0'],InnerPixel['PTY0'],InnerPixel['PTholeDia']-2.0*InnerPixel['innerPTmetalOH'],-InnerPixel['shiftX'])
#     Pixel.bumpPad($layerPassOpen,BumpPad['bPDiaPassivation']-2e3,InnerPixel['bPX0'],InnerPixel['bPY0']-UpperRow['Yplus']/2)
#     Pixel.bumpPad($layerAlu,BumpPad['bPDia'],InnerPixel['bPX0'],InnerPixel['bPY0']-UpperRow['Yplus']/2)
#     Pixel.ptVia($layerAluVia,InnerPixel['viaX0'],InnerPixel['viaY0']-UpperRow['Yplus']/2,InnerPixel['viaDia'])
#     Pixel.ptVia($layerAluVia,InnerPixel['viaX0'],-InnerPixel['viaY0']-UpperRow['Yplus']/2,InnerPixel['viaDia'])
#     Pixel.pStop($layerPp, InnerPixel['implantSizeX']+2*InnerPixel['PSdistX'], InnerPixel['implantSizeY']+UpperRow['Yplus']+2*InnerPixel['PSdistY'], InnerPixel['PSwidth'], InnerPixel['PSrOut'] , InnerPixel['PSrIn'], InnerPixel['PSopenX0'], InnerPixel['PSopenY0'], InnerPixel['PSopenWidth'],true)
#     
#     uinnerPixelCell2 = layout.create_cell("UpperInnerPixel2")      
#     Pixel.init(uinnerPixelCell2)
#     Pixel.ptImplant($layerNp,InnerPixel['implantSizeX'],InnerPixel['implantSizeY']+UpperRow['Yplus'],InnerPixel['PTX0'],InnerPixel['PTY0'],InnerPixel['PTholeDia'],InnerPixel['PTimplantDia'],0,-InnerPixel['shiftX'])
#     Pixel.ptImplant($layerAlu,InnerPixel['implantSizeX']+2.0*InnerPixel['metalOH'],InnerPixel['implantSizeY']+UpperRow['Yplus']+2.0*InnerPixel['metalOH'],InnerPixel['PTX0'],InnerPixel['PTY0'],InnerPixel['PTholeDia']-2.0*InnerPixel['innerPTmetalOH'],-InnerPixel['shiftX'])
#     Pixel.ptVia($layerAluVia,InnerPixel['viaX0'],InnerPixel['viaY0']-UpperRow['Yplus']/2,InnerPixel['viaDia'])
#     Pixel.ptVia($layerAluVia,InnerPixel['viaX0'],-InnerPixel['viaY0']-UpperRow['Yplus']/2,InnerPixel['viaDia'])
#     Pixel.pStop($layerPp, InnerPixel['implantSizeX']+2*InnerPixel['PSdistX'], InnerPixel['implantSizeY']+2*InnerPixel['PSdistY'], InnerPixel['PSwidth'], InnerPixel['PSrOut'] , InnerPixel['PSrIn'], InnerPixel['PSopenX0'], InnerPixel['PSopenY0'], InnerPixel['PSopenWidth'],true)    
#     
#     ulargePixelCell = layout.create_cell("UpperLargePixel")      
#     Pixel.init(ulargePixelCell)
#     i=1
#     while i<8 do
#       LargePixelBPPar[i] -= UpperRow['Yplus']/2
#       i +=2
#     end
#     Pixel.routingImplant($layerNp,LargePixel['implantSizeX'],LargePixel['implantSizeY']+UpperRow['Yplus'], LargePixel['routingdist'], LargePixel['routingwidth'], BumpPad['bPDia'], LargePixelBPPar, false)
#     Pixel.routingImplant($layerAlu,LargePixel['implantSizeX']+2.0*LargePixel['metalOH'],LargePixel['implantSizeY']+UpperRow['Yplus']+2.0*LargePixel['metalOH'], LargePixel['routingdist']-LargePixel['metalOH'], LargePixel['routingwidth'], BumpPad['bPDia'], LargePixelBPPar, true)
#     Pixel.bumpPad($layerPassOpen,BumpPad['bPDiaPassivation'],LargePixelBP['bPX0'],LargePixelBP['bPY0']-UpperRow['Yplus']/2)
#     Pixel.bumpPad($layerAlu,BumpPad['bPDia'],LargePixelBP['bPX0'],LargePixelBP['bPY0']-UpperRow['Yplus']/2)
#     Pixel.bumpPad($layerPassOpen,BumpPad['bPDiaPassivation'],LargePixelBPPar[0],LargePixelBPPar[1]-UpperRow['Yplus']/2)
#     Pixel.bumpPad($layerAlu,BumpPad['bPDia'],LargePixelBPPar[0],LargePixelBPPar[1]-UpperRow['Yplus']/2)
#     Pixel.bumpPad($layerPassOpen,BumpPad['bPDiaPassivation'],LargePixelBPPar[4],LargePixelBPPar[5]-UpperRow['Yplus']/2)
#     Pixel.bumpPad($layerAlu,BumpPad['bPDia'],LargePixelBPPar[4],LargePixelBPPar[5]-UpperRow['Yplus']/2)
#     # create via grid
#     i = 0
#     sign = 1
#     # distance between vias
#     dist = 50e3
#     while i*dist<=LargePixel['implantSizeX']-2*LargePixel['viaX0'] do 
#       Pixel.ptVia($layerAluVia,LargePixel['viaX0']+i*dist-LargePixel['implantSizeX']/2,sign*(LargePixel['viaY0']-UpperRow['Yplus']/2),LargePixel['viaDia'])
#       i+=1
#       if sign==1 && i*dist>LargePixel['implantSizeX']-2*LargePixel['viaX0']
#         sign = -1
#         i = 0
#       end
#     end
#     Pixel.pStop($layerPp, LargePixel['implantSizeX']+2*LargePixel['PSdistX'], LargePixel['implantSizeY']+UpperRow['Yplus']+2*LargePixel['PSdistY'], LargePixel['PSwidth'], LargePixel['PSrOut'] , LargePixel['PSrIn'], LargePixel['PSopenX0'], LargePixel['PSopenY0'], LargePixel['PSopenWidth'],true)
#     
#     uleftPixelCell = layout.create_cell("UpperLeftPixel")
#     Pixel.init(uleftPixelCell)
#     Pixel.ptImplant($layerNp,LeftPixel['implantSizeX'],InnerPixel['implantSizeY']+UpperRow['Yplus'],InnerPixel['PTX0'],InnerPixel['PTY0'],InnerPixel['PTholeDia'],InnerPixel['PTimplantDia'],0,-InnerPixel['shiftX'])
#     Pixel.ptImplant($layerAlu,LeftPixel['implantSizeX']+2.0*InnerPixel['metalOH'],InnerPixel['implantSizeY']+UpperRow['Yplus']+2.0*InnerPixel['metalOH'],InnerPixel['PTX0'],InnerPixel['PTY0'],InnerPixel['PTholeDia']-2.0*InnerPixel['innerPTmetalOH'],-InnerPixel['shiftX'])
#     Pixel.ptVia($layerAluVia,InnerPixel['viaX0'],InnerPixel['viaY0']-UpperRow['Yplus']/2,InnerPixel['viaDia'])
#     Pixel.ptVia($layerAluVia,InnerPixel['viaX0'],-InnerPixel['viaY0']-UpperRow['Yplus']/2,InnerPixel['viaDia'])
#     Pixel.pStop($layerPp, LeftPixel['implantSizeX']+2*InnerPixel['PSdistX'], InnerPixel['implantSizeY']+UpperRow['Yplus']+2*InnerPixel['PSdistY'], InnerPixel['PSwidth'], InnerPixel['PSrOut'] , InnerPixel['PSrIn'], InnerPixel['PSopenX0'], InnerPixel['PSopenY0'], InnerPixel['PSopenWidth'],true)
#     
#     
#     urightPixelCell = layout.create_cell("UpperRightPixel")
#     Pixel.init(urightPixelCell)
#     Pixel.ptImplant($layerNp,RightPixel['implantSizeX'],InnerPixel['implantSizeY']+UpperRow['Yplus'],InnerPixel['PTX0'],InnerPixel['PTY0'],InnerPixel['PTholeDia'],InnerPixel['PTimplantDia'],0,-InnerPixel['shiftX'])
#     Pixel.ptImplant($layerAlu,RightPixel['implantSizeX']+2.0*InnerPixel['metalOH'],InnerPixel['implantSizeY']+UpperRow['Yplus']+2.0*InnerPixel['metalOH'],InnerPixel['PTX0'],InnerPixel['PTY0'],InnerPixel['PTholeDia']-2.0*InnerPixel['innerPTmetalOH'],-InnerPixel['shiftX'])
#     Pixel.bumpPad($layerPassOpen,BumpPad['bPDiaPassivation'],RightPixel['bPX0'],LargePixelBP['bPY0']-UpperRow['Yplus']/2)
#     Pixel.bumpPad($layerAlu,BumpPad['bPDia'],RightPixel['bPX0'],LargePixelBP['bPY0']-UpperRow['Yplus']/2)
#     Pixel.ptVia($layerAluVia,InnerPixel['viaX0'],InnerPixel['viaY0']-UpperRow['Yplus']/2,InnerPixel['viaDia'])
#     Pixel.ptVia($layerAluVia,InnerPixel['viaX0'],-InnerPixel['viaY0']-UpperRow['Yplus']/2,InnerPixel['viaDia'])
#     Pixel.pStop($layerPp, RightPixel['implantSizeX']+2*InnerPixel['PSdistX'], InnerPixel['implantSizeY']+UpperRow['Yplus']+2*InnerPixel['PSdistY'], InnerPixel['PSwidth'], InnerPixel['PSrOut'] , InnerPixel['PSrIn'], InnerPixel['PSopenX0'], InnerPixel['PSopenY0'], InnerPixel['PSopenWidth'],true)
    
    
#     create pixel grid
    pixelGridCell = layout.create_cell("PixelGrid")
    Pixel.init(pixelGridCell)
#     pixels are created from left to right
    Pixel.grid(leftPixelCell,LeftPixel['nX'], InnerPixel['nY'], InnerPixel['dX'], InnerPixel['dY'], -PixelGrid['sizeX']/2+LeftPixel['cellSizeX']/2, -PixelGrid['sizeY']/2+InnerPixel['cellSizeY']/2)
    
    Pixel.grid(innerPixelCell2,InnerPixel['nX1'], InnerPixel['nY'], InnerPixel['dX'], InnerPixel['dY'], -PixelGrid['sizeX']/2+LeftPixel['cellSizeX']+InnerPixel['cellSizeX']/2, -PixelGrid['sizeY']/2+LargePixel['cellSizeY']/2)
    
    Pixel.grid(innerPixelCell1,InnerPixel['nX1'], InnerPixel['nY'], InnerPixel['dX'], InnerPixel['dY'], -PixelGrid['sizeX']/2+LeftPixel['cellSizeX']+3*InnerPixel['cellSizeX']/2, -PixelGrid['sizeY']/2+LargePixel['cellSizeY']/2)
    
    Pixel.grid(innerPixelCell2,InnerPixel['nX2'], InnerPixel['nY'], InnerPixel['dX'], InnerPixel['dY'], -PixelGrid['sizeX']/2+LeftPixel['cellSizeX']+5*InnerPixel['cellSizeX']/2, -PixelGrid['sizeY']/2+LargePixel['cellSizeY']/2)
    
    Pixel.grid(largePixelCell,LargePixel['nX'], LargePixel['nY'], LargePixel['dX'], LargePixel['dY'], -PixelGrid['sizeX']/2+LeftPixel['cellSizeX']+3*InnerPixel['cellSizeX']+LargePixel['cellSizeX']/2, -PixelGrid['sizeY']/2+LargePixel['cellSizeY']/2)
    
    Pixel.grid(rightPixelCell,RightPixel['nX'], InnerPixel['nY'], InnerPixel['dX'], InnerPixel['dY'], -PixelGrid['sizeX']/2+LeftPixel['cellSizeX']+RightPixel['cellSizeX']/2+(InnerPixel['nX1']-1)*InnerPixel['dX']+2*InnerPixel['cellSizeX'], -PixelGrid['sizeY']/2+LargePixel['cellSizeY']/2)
    
    
#    upper pixel row
    
#     Pixel.grid(uleftPixelCell,LeftPixel['nX'], UpperRow['nY'], InnerPixel['dX'], InnerPixel['dY'], -PixelGrid['sizeX']/2+LeftPixel['cellSizeX']/2, -PixelGrid['sizeY']/2+InnerPixel['nY']*InnerPixel['cellSizeY']+(UpperRow['Yplus']+InnerPixel['cellSizeY'])/2)
#     
#     Pixel.grid(ulargePixelCell,LargePixel['nX'], UpperRow['nY'], LargePixel['dX'], LargePixel['dY'], -PixelGrid['sizeX']/2+LeftPixel['cellSizeX']+LargePixel['cellSizeX']/2, -PixelGrid['sizeY']/2+InnerPixel['nY']*InnerPixel['cellSizeY']+(UpperRow['Yplus']+InnerPixel['cellSizeY'])/2)
#     
#     Pixel.grid(uinnerPixelCell2,InnerPixel['nX1'], UpperRow['nY'], InnerPixel['dX'], InnerPixel['dY'], -PixelGrid['sizeX']/2+LeftPixel['cellSizeX']+LargePixel['cellSizeX']+InnerPixel['cellSizeX']/2, -PixelGrid['sizeY']/2+InnerPixel['nY']*InnerPixel['cellSizeY']+(UpperRow['Yplus']+InnerPixel['cellSizeY'])/2)
#     
#     Pixel.grid(uinnerPixelCell1,InnerPixel['nX1'], UpperRow['nY'], InnerPixel['dX'], InnerPixel['dY'], -PixelGrid['sizeX']/2+LeftPixel['cellSizeX']+LargePixel['cellSizeX']+3*InnerPixel['cellSizeX']/2, -PixelGrid['sizeY']/2+InnerPixel['nY']*InnerPixel['cellSizeY']+(UpperRow['Yplus']+InnerPixel['cellSizeY'])/2)
#     
#     Pixel.grid(uinnerPixelCell2,InnerPixel['nX2'], UpperRow['nY'], InnerPixel['dX'], InnerPixel['dY'], -PixelGrid['sizeX']/2+LeftPixel['cellSizeX']+LargePixel['cellSizeX']+5*InnerPixel['cellSizeX']/2, -PixelGrid['sizeY']/2+InnerPixel['nY']*InnerPixel['cellSizeY']+(UpperRow['Yplus']+InnerPixel['cellSizeY'])/2)
#     
#     Pixel.grid(urightPixelCell,RightPixel['nX'], UpperRow['nY'], InnerPixel['dX'], InnerPixel['dY'], -PixelGrid['sizeX']/2+LeftPixel['cellSizeX']+RightPixel['cellSizeX']/2+(InnerPixel['nX1']-1)*InnerPixel['dX']+LargePixel['cellSizeX']+2*InnerPixel['cellSizeX'], -PixelGrid['sizeY']/2+InnerPixel['nY']*InnerPixel['cellSizeY']+(UpperRow['Yplus']+InnerPixel['cellSizeY'])/2)
    
    
    Merge.cells($sensor, pixelGridCell)

    periCell = layout.create_cell("Periphery")
    Periphery.init(periCell)
    Periphery.create($layerNp,$layerAlu,$layerPassOpen,$layerPpe19,PixelGrid,BiasRing,GuardRing,PixelEdge)
    
    textCell = Text.create(layout, $layerPassOpen, sensor , -4000e3, 4500e3)
    Merge.cells(periCell, textCell)
    
    Merge.cells($sensor, periCell)

    return $sensor
  end
end