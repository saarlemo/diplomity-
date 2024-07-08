


              SIMIND Monte Carlo Simulation Program    V8.0  
------------------------------------------------------------------------------
 Phantom S : h2o       Crystal...: nai       InputFile.: cbf               
 Phantom B : bone      BackScatt.: pmt       OutputFile: cbf1              
 Collimator: pb_sb2    SourceRout: smap      SourceImg.: vox_brn           
 Cover.....: al        ScoreRout.: none      DensityImg: vox_brn           
------------------------------------------------------------------------------
 PhotonEnergy.......: 140          Matrix    PhotonsPerProj....: 9102759        
 EnergyResolution...: 9            Spectra   Activity..........: 1              
 MaxScatterOrder....: 0            gi-lehr   DetectorLenght....: 25             
 DetectorWidth......: 20           SPECT     DetectorHeight....: 0.9525         
 UpperEneWindowTresh: 150.5        Random    Distance to det...: 20.15          
 LowerEneWindowTresh: 129.5        Resolut   ShiftSource X.....: 0              
 PixelSize  I.......: 0.4664       Forced    ShiftSource Y.....: 0              
 PixelSize  J.......: 0.4664       Header    ShiftSource Z.....: 0              
 HalfLength S.......: 9.6          SaveMap   HalfLength P......: 9.6            
 HalfWidth  S.......: 19.2                   HalfWidth  P......: 15             
 HalfHeight S.......: 2                      HalfHeight P......: 10             
 SourceType.........: ZubalVoxBrn            PhantomType.......: ZubalVoxBrn  
------------------------------------------------------------------------------
 GENERAL DATA
 keV/channel........: 0.5                    CutoffEnergy......: 0              
 Photons/Bq.........: 0.891                  StartingAngle.....: 0              
 CameraOffset X.....: 0                      CoverThickness....: 0              
 CameraOffset Y.....: 0                      BackscatterThickn.: 0              
 MatrixSize I.......: 128                    IntrinsicResolut..: 0.38           
 MatrixSize J.......: 128                    AcceptanceAngle...: 2.4432         
 Emission type......: 2                      Initial Weight....: 0.09788        
 NN ScalingFactor...: 1                      Energy Channels...: 512            
                                                                              
 SPECT DATA
 RotationMode.......: -360                   Nr of Projections.: 64             
 RotationAngle......: 5.625                  Projection.[start]: 1              
 Orbital fraction...: 0                      Projection...[end]: 64             
 Center of Rotation File: cbf1.cor
                                                                              
 COLLIMATOR DATA FOR ROUTINE: Analytical          
 CollimatorCode.....: gi-lehr                CollimatorType....: Parallel 
 HoleSize X.........: 0.1212                 Distance X........: 0.012          
 HoleSize Y.........: 0.13995                Distance Y........: 0.08037        
 CenterShift X......: 0.0666                 X-Ray flag........: F              
 CenterShift Y......: 0.11535                CollimThickness...: 3.28           
 HoleShape..........: Hexagonal              Space Coll2Det....: 0              
 CollDepValue [57]..: 0                      CollDepValue [58].: 0              
 CollDepValue [59]..: 0                      CollDepValue [60].: 0              
                                                                              
 PHANTOM DATA FROM FILE: phantom.zub section: 2

 Code Volume          Density   Voxels Volume(mL)        MBq     MBq/mL   Value
   1: skin              1.040   139785  0.472E+03  0.307E-01  0.651E-01   2.000
   2: brain             1.040   130250  0.440E+03  0.143E-01  0.326E-01   1.000
   3: spinal cord       1.040     1733  0.585E+01  0.381E-03  0.651E-01   2.000
   4: skull             1.300   271508  0.916E+03  0.298E-01  0.326E-01   1.000
   5: spine             1.300    15832  0.534E+02  0.174E-02  0.326E-01   1.000
   9: skeletal muscle   1.040   213325  0.720E+03  0.469E-01  0.651E-01   2.000
  15: pharynx           1.040     2707  0.914E+01  0.595E-03  0.651E-01   2.000
  22: fat               1.040    31096  0.105E+03  0.342E-02  0.326E-01   1.000
  23: blood pool        1.040    14348  0.484E+02  0.315E-02  0.651E-01   2.000
  26: bone marrow       1.040      575  0.194E+01  0.126E-03  0.651E-01   2.000
  30: cartilage         1.040    30174  0.102E+03  0.331E-02  0.326E-01   1.000
  70: dens of axis      1.300      788  0.266E+01  0.866E-04  0.326E-01   1.000
  71: jaw bone          1.300     3276  0.111E+02  0.360E-03  0.326E-01   1.000
  72: parotid gland     1.040    18522  0.625E+02  0.163E-01  0.260E+00   8.000
  74: lacrimal glands   1.040     1488  0.502E+01  0.327E-03  0.651E-01   2.000
  75: spinal canal      1.040     4550  0.154E+02  0.500E-03  0.326E-01   1.000
  76: hard palate       1.300    14110  0.476E+02  0.155E-02  0.326E-01   1.000
  77: cerebellum        1.040    82339  0.278E+03  0.109E+00  0.391E+00  12.000
  78: tongue            1.040    14222  0.480E+02  0.312E-02  0.651E-01   2.000
  81: horn of mandibl   1.300     8813  0.297E+02  0.968E-03  0.326E-01   1.000
  82: nasal septum      0.600     3420  0.115E+02  0.376E-03  0.326E-01   1.000
  83: white matter      1.040   301514  0.102E+04  0.132E+00  0.130E+00   4.000
  84: superior sagita   1.040     8379  0.283E+02  0.920E-03  0.326E-01   1.000
  85: medulla oblongo   1.040     2355  0.795E+01  0.103E-02  0.130E+00   4.000
  88: artificial lesi   1.040     2783  0.939E+01  0.367E-02  0.391E+00  12.000
  89: frontal lobes     1.040    66601  0.225E+03  0.878E-01  0.391E+00  12.000
  91: pons              1.040    13232  0.447E+02  0.174E-01  0.391E+00  12.000
  92: third ventricle   1.040     5270  0.178E+02  0.579E-03  0.326E-01   1.000
  95: occipital lobes   1.040    41438  0.140E+03  0.546E-01  0.391E+00  12.000
  96: hippocampus       1.040     4218  0.142E+02  0.556E-02  0.391E+00  12.000
  97: pituitary gland   1.040       51  0.172E+00  0.672E-04  0.391E+00  12.000
  98: cerebral fluid    1.040   295805  0.998E+03  0.325E-01  0.326E-01   1.000
  99: uncus(ear bones   1.300      473  0.160E+01  0.520E-04  0.326E-01   1.000
 100: turbinates        0.600     3820  0.129E+02  0.420E-03  0.326E-01   1.000
 101: caudate nucleus   1.040     6239  0.211E+02  0.822E-02  0.391E+00  12.000
 102: zygoma            1.040     5585  0.188E+02  0.123E-02  0.651E-01   2.000
 103: insula cortex     1.040     7749  0.262E+02  0.102E-01  0.391E+00  12.000
 104: sinuses/mouth c   0.600   101924  0.344E+03  0.224E-01  0.651E-01   2.000
 105: putamen           1.040     6129  0.207E+02  0.808E-02  0.391E+00  12.000
 106: optic nerve       1.040      936  0.316E+01  0.411E-03  0.130E+00   4.000
 107: internal capsul   1.040     5478  0.185E+02  0.241E-02  0.130E+00   4.000
 108: septum pellucid   1.040      528  0.178E+01  0.232E-03  0.130E+00   4.000
 109: thalamus          1.040     7306  0.247E+02  0.963E-02  0.391E+00  12.000
 110: eyeball           1.040     7644  0.258E+02  0.840E-03  0.326E-01   1.000
 111: corpus collosum   1.040     6458  0.218E+02  0.284E-02  0.130E+00   4.000
 112: special region    1.040     3874  0.131E+02  0.511E-02  0.391E+00  12.000
 113: cerebral falx     1.040     2657  0.897E+01  0.117E-02  0.130E+00   4.000
 114: temporal lobes    1.040   136441  0.460E+03  0.180E+00  0.391E+00  12.000
 115: fourth ventricl   1.040     1123  0.379E+01  0.123E-03  0.326E-01   1.000
 116: frontal portion   1.040     3109  0.105E+02  0.683E-03  0.651E-01   2.000
 117: parietal lobes    1.040    70899  0.239E+03  0.935E-01  0.391E+00  12.000
 118: amygdala          1.040     2347  0.792E+01  0.309E-02  0.391E+00  12.000
 119: eye               1.040     7930  0.268E+02  0.871E-03  0.326E-01   1.000
 120: globus pallidus   1.040     2471  0.834E+01  0.326E-02  0.391E+00  12.000
 121: lens              1.040      360  0.121E+01  0.395E-04  0.326E-01   1.000
 122: cerebral aquadu   1.040      312  0.105E+01  0.343E-04  0.326E-01   1.000
 123: lateral ventric   1.040     5648  0.191E+02  0.620E-03  0.326E-01   1.000
 124: prefrontal lobe   1.040    31441  0.106E+03  0.414E-01  0.391E+00  12.000
                                                                              
 INTERACTIONS IN THE CRYSTAL
 MaxValue spectrum..: 148.2          
 MaxValue projection: 0.7986E-01     
 CountRate spectrum.: 62.86          
 CountRate E-Window.: 58.13          
                                                                              
 CALCULATED DETECTOR PARAMETERS
 Efficiency E-window: 0.8379         
 Efficiency spectrum: 0.9061         
 Sensitivity Cps/MBq: 58.1282        
 Sensitivity Cpm/uCi: 129.0446       
                                                                              
 Simulation started.: 2024:07:05 10:34:55
 Simulation stopped.: 2024:07:05 10:41:08
 Elapsed time.......: 0 h, 6 m and 13 s
 DetectorHits.......: 8280653        
 DetectorHits/CPUsec: 30346          
                                                                              
 OTHER INFORMATION
 Compiled 2024:05:03 with INTEL Win   
 Random number generator: ranmar
 Comment:EMISSION VBRN
 Energy resolution as function of 1/sqrt(E)
 Header file: cbf1.h00
 Linear angle sampling within acceptance angle
 Inifile: simind.ini
 Command: cbf cbf1/fz:phantom/45:2/fa:11/tr:15
