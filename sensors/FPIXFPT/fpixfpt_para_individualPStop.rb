Defaults = {

    # Parameters
  
    'implantSizeX' => 114e3,
    'implantSizeY' => 64e3,
    
    'bumpPadDiameter' => 30000,
    
    #actually the cell size. pstop size is pStopSizeX/Y - 2*distedgetopspray -> CHANGE NAME
    'pStopSizeX' => 150e3,
    'pStopSizeY' => 100e3,
    # for pspray design remember outerpstopring and pstopwidth for punch through
    'pStopWidth' => 2e3,
    #cornerrout should be ==0 for common pstop and 2*Rin for individual pstop
    #TODO: remove parameter and automatize
    'pStopCornerRout' => 4e3,
    'pStopCornerRin' => 2e3,
    
    #TODO: calculate position automatically from width -> make independent of pixel geometry
    'pStopOpenX0' => 59e3,# = pStopSizeX/2 - pStopOpenWidth/2 + distedgetopspray
    'pStopOpenY0' => 98e3, # = pStopSizeY - distedgetopspray or pStopSizeY - pStopWidth? 
    
    'pStopOpenWidth' => 28e3, 
    
    'pixelGridnX' => 25,
    'pixelGridnY' => 79,
    'pixelGriddX' => 300000,
    'pixelGriddY' => 100000,
    
    'pixelViaSizeX' => 12000,
    'pixelViaSizeY' => 24000,
  
    
  ###############
  #####ADDED#####
  ###############
  
    # half of the distance between individual pstops (if ==0 common pstop)
    'distedgetopspray' => 2e3,
  
    'distancebumppadtoedgeSTD' => 50e3,
    'distancebumppadtoedgeOUTER' => 100e3,
  
    'pStopSizeOuterX' => 300e3,
  
    'pStopSizeUpperY' => 200e3,
  
    'viadia' => 3e3,
  
  
    'thicknessofremainingpadimplant' => 0e3,
    'implantptdia' => 0e3,
    'viaptdia' => 0e3,
    'pstopptwidth' => 0e3,
    'distmetaltopstopwidth' => 0e3,
	# used not only for punch through
    'metaloverhang' => 2e3,
	
    'biaslinewidth' => 0e3,
    'distbetweenbiaslineandpad' => 0e3,
    'biaslineoverlap' => 10e3,
    
    'createouterpstopring' => false

}