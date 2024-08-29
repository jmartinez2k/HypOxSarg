

# provides difequations for oxygen assessment

reefo2dif_JM <- function(t, y, parms) {
  
  # Residence time (tau) and input/output flow
  Flow <- reefvol / tau  # L/h
  
  # Input (Fi) and output (Fo) fluxes
  Fi <- oceanO2 * 1e-06 * Flow  # Oxygen input mol/h
  Fo <- y[1] / reefvol * Flow
  
  # Photosynthesis
  Pf <- 0.04  # Max rate: 40 mmol/m2/h
  PS <- Pf * (sin(pi * t / 12) ^ 1.2) 
  
  if (!is.na(PS) && PS > 0) {
    Fp <- PS
  } else {
    Fp <- 0
  }
  

  # Respiration
  Fr <- resp  # 12 mmol/m2/hr in base scenario
  
  # Differential equations
  #Fp = Fp *2
  yp <- Fi - Fo + Fp - Fr  
  
return(list(yp))
  
  
  
  
}