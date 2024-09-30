# Hypoxia driven by Caribbean Sargassum accumulation events

GitHub repository containing code accompanying the Hypoxia driven by caribbean sargassum accumulation events manuscript ()

**Data Repository DOI:** 
https://doi.org/


**Authors:** Jose A Martinez Ortiz, Travis A Courtney, Jenniffer Perez Perez, Roy Armstrong, Juan J Cruz Motta

**Abstract:** Climate change is predicted to increase the frequency and intensity of coastal hypoxia and sargassum accumulation events across the Caribbean. While Sargassum accumulation events have been linked as a probable cause of localized hypoxia especially in areas of persistent accumulation, these types of events have rarely been continuously monitored for oxygen. Here we combine timeseries of directly measured dissolved oxygen (DO) with remotely sensed areal coverage by fresh Sargassum to explore the role of Sargassum accumulation events on coastal hypoxia in late summer and late winter at Isla Magueyes, Puerto Rico. We observed severe hypoxia (< 2 mg L-1) for several days following two anomalous accumulations of Sargassum around Isla Magueyes in both early and mid-September 2023. While mild to moderate hypoxia was more severe during the warmer summer months, no severe hypoxia was observed without the presence of Sargassum. We paired these in situ observations with controlled, laboratory-based Sargassum incubation experiments to quantify biochemical oxygen demand rates of freshly collected decaying Sargassum. We applied this 4.95 mmol DO hr-1 kg Sargassum-1 rate to various amounts of Sargassum in a simple predictive DO box model to explore the relationship between seawater warming, residence time, and Sargassum biomass on coastal hypoxia. Modeled nightly minimum DO decreased with increasing Sargassum and was most extreme under the model scenario with warmer seawater and longer residence time. The combination of continuous measurements, remote sensing, laboratory incubations, and box modeling demonstrates that Sargassum accumulation can drive local hypoxia and that the frequency, intensity, and severity of Sargassum induced hypoxia events in the Caribbean will likely increase under ongoing climate change. These findings could be leveraged to provide an early warning system for future Sargassum accumulation induced hypoxia events across the Caribbean while efforts are made on a global scale to reduce greenhouse gas emissions.

### Repository contains the following:

1. [Raw_Data](https://github.com/apezner/GlobalReefOxygen/tree/master/Raw_Data) 
2. [code](https://github.com/apezner/GlobalReefOxygen/tree/master/code)
  * ***MartinezMS.Rmd*** - R Code used to analyze the dissolved oxygen (DO), temperature, current, wind, water level, and remote sensing dataset  (creates Figures 1, 2, and 4, Supplemental Figures 1 and 3, and statistics)
  * ***Study_Map.R*** - R Code used to create map of the areas of interest for this study done with googlemaps API (creates Figures S2).
  * ***calcDOatsat.R*** - R Function used to calculate dissolved oxygen solubility in seawater (required for ***box_model_sarg.R***)
  * ***box_model_sarg.R*** - R code used to create and run a simple box model to assess the impact of sargassum biomass on oxygen dynamics using a oxygen uptake rat from biochemical oxygen demand Sargassum incubation experiments ***MartinezMS.R*** (creates Figure 4B); requires ***calcDOatsat.R*** and ***reefo2dif_JM.R*** functions.
  * ***reefo2dif_JM.R*** - R function with differential equations required by box model (required for ***box_model_sarg.m***)