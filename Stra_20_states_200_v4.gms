*Option LP=PATHNLP;

Option iterlim=1000000000;
Option reslim=1000000000;

Sets

g generators

t time increment of LDC

f fuel type

y years

s scenarios considered

map(g,f)

sce_id scenarios Adrien considers for robust decision making strategies

stra_id strategy considered
;


*display Adrien;



alias (y,y1);


Scalar

IncludeCO2Price /0/

IncludeEnergyEfficiency /1/
;

Scalar r discount rate /0.06/
*as per Bank's advice on climate resilient projects


;
*MaxCapital max gen investment in billion dollars /132.5/
*MAXCOALCAP  max GW of coal that can be built /200/

parameters LDC_growth,Maxcapital, MaxGwcoaladded,MaxGWgas,Der_factor, LNG_price_factor, Coal_import_price_factor, Electricity_import_price_factor,EE_feasible,Solar_capex_cost_factor, gas_ub, gas_lb, pv_lb, pv_ub, inter_lb, inter_ub
;



Parameters prob(s);
$Call GDXXRW   Bangladesh_InputsCO2.xlsx  set=s RDim=1 rng=probabilities!A2:A10 par=prob RDim=1  rng=probabilities!A2:B10
$GDXIN  Bangladesh_InputsCO2.gdx
$LOAD s
$LOAD prob
$GDXIN
;
display s, prob;
*note that if you want to include more scenarios you have to update the range in excel


parameters RDMun(sce_id,*);
*rdm uncertainties
$Call GDXXRW   Bangladesh_InputsCO2.xlsx  set=sce_id RDim=1 rng=state_new!a2:a52 par=RDMun RDim=1  CDim=1  rng=state_new!a1:k52
$GDXIN  Bangladesh_InputsCO2.gdx
$LOAD sce_id
$LOAD RDMun
$GDXIN

parameters Strategy(stra_id,*);
*20 strategies
$Call GDXXRW   Bangladesh_InputsCO2.xlsx  set=stra_id RDim=1 rng=stra_new!a2:a4 par=Strategy RDim=1  CDim=1  rng=stra_new!a1:g4
$GDXIN  Bangladesh_InputsCO2.gdx
$LOAD stra_id
$LOAD Strategy
$GDXIN


Parameters GenData(g,*),  FuelPrices(f,y), FuelLimit(f,y), Duration(t), EmisFactor(f,*), CO2Price(y,*), Import_power_price(g,t) ,growth_import, cap_multiplier(y),solar_cf(t),CFmax(g,s),FOM(g,s),interconnection_limit(y),include(g)
;


$Call GDXXRW   Bangladesh_InputsCO2.xlsx  set=g  RDim=1  rng=GenData!B12:B1000  par=GenData  RDim=1  CDim=1  rng=GenData!B11:aa1000 par=include RDim=1 rng=Hard_criterion!a2:b154
$GDXIN  Bangladesh_InputsCO2.gdx
$LOAD g
$LOAD GenData
$LOAD include
$GDXIN
* this is used to define the elements of set g and indicate the range of data defined at the g dimension

$Call GDXXRW  Bangladesh_InputsCO2.xlsx  set=t  RDim=1  rng=LDC!A4:A1000   set=y CDim=1 rng=LDC!j3:x3 par=Duration  RDim=1 rng=LDC!a4:b1000   par=interconnection_limit CDim=1  rng=Resource_potential_time!b3:Q4
$GDXIN  Bangladesh_InputsCO2.gdx
$LOAD t
$LOAD y
$LOAD Duration
$LOAD interconnection_limit
$GDXIN
*this is used to define the set of time blocks to be used in the model and load the load data

$Call GDXXRW  Bangladesh_InputsCO2.xlsx  set=f  RDim=1  rng=FuelPrices!A3:A20   par=FuelPrices RDim=1 CDim=1 rng=FuelPrices!A2:R20 par=CO2Price RDim=1 CDim=1 rng=Emission!E4:F1000
$GDXIN  Bangladesh_InputsCO2.gdx
$LOAD f
$LOAD FuelPrices
$LOAD CO2Price
$GDXIN

*this is used to define the set of fuels in the model and load their prices


$Call GDXXRW  Bangladesh_InputsCO2.xlsx  set=map  RDim=1 CDim=1  rng=map!A2:U990 par=FuelLimit RDim=1 CDim=1 rng=FuelLimit!A2:AA1000 par=EmisFactor RDim=1 CDim=1 rng=Emission!A4:B1000
$GDXIN  Bangladesh_InputsCO2.gdx
$LOAD map
$LOAD FuelLimit
$LOAD EmisFactor
$GDXIN

$Call GDXXRW  Bangladesh_InputsCO2.xlsx     par=Import_power_price  rng=Interconnection_price!A1:AE6  par=cap_multiplier RDim=1 rng=Capital_multipliers!A9:B23
$GDXIN  Bangladesh_InputsCO2.gdx
$LOAD Import_power_price
$LOAD cap_multiplier
$GDXIN
*note that if you intend to change the initial year of the model, capital multiplier has to change too.
$Call GDXXRW  Bangladesh_InputsCO2.xlsx     par=solar_cf RDim=1 rng=Solar_profile!A2:b31
$GDXIN  Bangladesh_InputsCO2.gdx
$LOAD solar_cf
$GDXIN

$Call GDXXRW  Bangladesh_InputsCO2.xlsx   par=CFmax  rng=CF!A3:J201
$GDXIN  Bangladesh_InputsCO2.gdx
$LOAD CFmax
$GDXIN

$Call GDXXRW  Bangladesh_InputsCO2.xlsx   par=FOM rng=FOM!A2:J200
$GDXIN  Bangladesh_InputsCO2.gdx
$LOAD FOM
$GDXIN



*display FOM;
*display CFmax;
*display cap_multiplier;
PARAMETER LDC(s,t,y)
/
$ondelim
$include demand_2016_no_growth_rate.txt
$offdelim
/;
* demand_stoch_old_2016 , demand_2016
*demand_stoch_old has the projection for LDC initially provided by the bank perturbed and the demand.txt has the one built by Elina




* Interconnection prices from adjacent markets/systems loaded

Parameter EEScalingFactor(y)
/

2016    0.89
2017    0.88
2018    0.87
2019    0.86
2020    0.85
2021    0.845
2022    0.84
2023    0.835
2024    0.83
2025    0.825
2026    0.82
2027    0.815
2028    0.81
2029    0.805
2030    0.80
/;
*2015    0.90
*2014    1.00
Parameter PSsaving(y)
/
2016    0.027
2017    0.03
2018    0.032
2019    0.035
2020    0.037
2021    0.039
2022    0.04
2023    0.041
2024    0.042
2025    0.044
2026    0.045
2027    0.046
2028    0.047
2029    0.049
2030    0.05
/;
*2014    0
*2015    0.025
*assumed based on the ratio of PS has been considered in the previous case
Parameter growth_import
/
0.02
/;

parameter VOM(g), PMIN(g), PDerated(g), CAPEX(g), Efficiency(g),  FCdom(g), FCimp(g), ng(g), Operation(g),Technology(g), Fuel_type(g),Overnight_CAPEX(g), Fuel_origin(g);

VOM(g)                   =GenData(g,"VOM");
PDerated(g)              =GenData(g,"PDerated");
Efficiency(g)            =GenData(g,"Efficiency");
FCdom(g)                 =GenData(g,"Fuel_Cost_Dom");
FCimp(g)                 =GenData(g,"Fuel_Cost_Imp");
Operation(g)             =GenData(g,"Operation");
ng(g)                    =YES$(Operation(g) = 3);
Technology(g)            =GenData(g,"Technology");
Fuel_type(g)             =GenData(g,"Fuel");
Fuel_origin(g)           =GenData(g,"Fuel_origin");

Parameter VC(g,y,f,t), GenEmis(g,f);




Parameter Initial_capacity(g) ;
Initial_capacity(g)$(GenData(g,"CapexperMW"))=0;
Initial_capacity(g)$(GenData(g,"CapexperMW")=0 and GenData(g,"StYr") <= 2015)=GenData(g,"Pderated");
Initial_capacity(g)$(GenData(g,"CapexperMW")=0 and GenData(g,"StYr") > 2015)=0;
*candidates have zero initial capacity same for already planned generators
*existing generators have the maximum capacity


*GenEmis is emission factor in tonne per MWhe
GenEmis(g,f)$map(g,f)    =(EmisFactor(f,"CO2")/(0.293071*Efficiency(g)))/1000;




Variables
Gen(s,g,f,y,t)          generation per unit per year per LDC point in MWh
Cap(s,g,y)              installed capacity in year y in MW
Build_1st_stage(g,y)    Build new capacity MW in year y
Build_2nd_stage(s,g,y)  Build new capacity MW in year y
USE(s,y,t)              unserved energy in MW
Unmetreserve(s,y)       reserve capacity shortfall
Surplus(s,y,t)          surplus power (to get around the min load constraint!)
Fuel(s,f,y)             fuel consumption in MMBTU
cost                    total system cost  in USD
Retire_1st_stage(g,y)   retirement
Retire_2nd_stage(s,g,y) retirement
;

$ontext
parameters
built_gas
retire_gas
built_pv
retire_pv
built_inter
retire_inter
built_coal
retire_coal
net_add_gas
net_add_pv
net_add_inter
net_add_coal
;

$offtext


Positive variables gen, cap,Build_1st_stage ,Build_2nd_stage, fuel, USE, Surplus, UnmetReserve,Retire_1st_stage,Retire_2nd_stage ;
*play with scenarios  (if scenario has zero probability do not include the decision variable for easier
Gen.fx(s,g,f,y,t)$(prob(s)=0)=0;
Cap.fx(s,g,y)$(prob(s)=0)=0;
USE.fx(s,y,t)$(prob(s)=0)=0;
Unmetreserve.fx(s,y)$(prob(s)=0)=0;
Surplus.fx(s,y,t)$(prob(s)=0)=0;
Fuel.fx(s,f,y)$(prob(s)=0)=0;
Retire_2nd_stage.fx(s,g,y)$(prob(s)=0)=0;
Build_2nd_stage.fx(s,g,y)$(prob(s)=0)=0;




*Generation can take positive values for the fuel that matches each of the generators
Gen.fx(s,g,f,y,t)$(NOT map(g,f))=0;

* Existing capacity i.e., anything with capex = 0 is given the opportunity to be built up to Pderated after its starting year before it is fixed to zero
Cap.up(s,g,y)$(GenData(g,"CapexperMW")=0 and GenData(g,"StYr") le Ord(y)+2015)=GenData(g,"Pderated");
Cap.fx(s,g,y)$(GenData(g,"CapexperMW")=0 and GenData(g,"StYr") > Ord(y)+2015)=0;

*No new build at existing sites- they can be built (the planned ones only in their starting year- we could relax that for later years too)
Build_1st_stage.fx(g,y)$(GenData(g,"CapexperMW")=0 and GenData(g,"StYr")-2015<>ord(y) )=0;
Build_2nd_stage.fx(s,g,y)$(GenData(g,"CapexperMW")=0 and GenData(g,"StYr")-2015<>ord(y))=0;

*for the existing ones, consider forced retirements within their horizon
*note that we do not consider rebuild since the number of variable would unnecessarily increase, the new candidates have better characteristics
*retirement at the end of the year (this adds one year if they differ by lifetime (minor for time being)
Cap.fx(s,g,y)$(GenData(g,"RtrYr") -2015< Ord(y))=0;


*by adjusting the year (for example now 17 we move the year when the uncertainty is resolved)
*we constraint the domain of the variables build_1st_stage and build_2nd_stage
Build_1st_stage.fx(g,y)$(ord(y)>17)=0;
Build_2nd_stage.fx(s,g,y)$(ord(y)<=17)=0;
Retire_1st_stage.fx(g,y)$(ord(y)>17)=0;
Retire_2nd_stage.fx(s,g,y)$(ord(y)<=17)=0;

* cannot build any new gen unit before its starting year (StYr
Build_1st_stage.fx(g,y)$(GenData(g,"CapexperMW") and GenData(g,"StYr") > Ord(y)+2015 )=0;
Build_2nd_stage.fx(s,g,y)$(GenData(g,"CapexperMW") and GenData(g,"StYr") > Ord(y)+2015 )=0;

*experiment 2 : do not provide any new import option
*Build_1st_stage.fx(g,y)$(Technology(g)=6 and ord(y)>1 )=0;
*Build_2nd_stage.fx(s,g,y)$(Technology(g)=6 and ord(y)>1 )=0;

* Peak shaving can only be implemented for limited hours every year. Initial assumption (v6) was that all first 10 blocks can use it
*but this assumption is equivalent to 3 hours every day of the year, seems a bit high. Assume again 3 hours but 30% of the year
*this is equivalent to the first 6 blocks  more or less
Gen.fx(s,"PS",f,y,t)$(ord(t)>6) = 0;
*to implement the hard criterion (I give flexibility up to 2020 for units to retire if needed
Gen.fx(s,g,f,y,t)$(include(g)=0 AND ord(y)>=5 )=0;
Cap.fx(s,g,y)$(include(g)=0 and ord(y)>=5)=0;
Build_1st_stage.fx(g,y)$(include(g)=0)=0;
Build_2nd_stage.fx(s,g,y)$(include(g)=0)=0;




Equations

Obj Objective function
Capacity(s,g,y,t)
Intermittent_capacity(s,g,y,t)

DemBal(s,y,t)


built_gas_lb
built_gas_ub
built_pv_lb
built_pv_ub
built_inter_lb
built_inter_ub

CapBal(s,g,y)              capacity balance
CapBal1st(s,g,y)           capacity balance 1st year

MaxBuild(s,g)

MinCapReserve(s,y)         minimum capacity reserve

*JointFuel(s,g,y,t)

MaxCF(s,g,y)               maximum capacity factor limit for each generator

*MinLoad(g,y,t)           minimum loading limit

FuelBal(s,f,y)             fuel balance

FuelLimitCon(s,f,y)        gas limits

CapitalConstraint(s)        total capital on new investment is constrained

CoalCapConstraint(s)        max coal capacity addition limited to MaxGwcoaladded GW
GasCapConstraint(s)         maximum gas capacity addition limited to MaxGWgas GW
Energyefficiency(y,s)       maximum capacity by EE every year
Peakshaving(y,s)            maximum capacity by PS every year
*the coal capital constraint applies to any scenario
Intercon(y,s)               maximum capacity of the interconnection to adjacent systems
Smooth_LNG_1(y,s)             constraint to make sure that smooth transitions from inter-annual variability in LNG use
Smooth_LNG_2(y,s)             constraint to make sure that smooth transitions from inter-annual variability in LNG use
;

Obj ..  cost =e=
* note that depending on the year it is build, cap_multiplier helps us to include all the annualized capital
*payments it would pay up to 2030 (note that everytime the r changes we have to update the excel or I can include it in the model)
Sum((y,g), Build_1st_stage(g,y)*CAPEX(g)*cap_multiplier(y) ) + Sum((y,g,s),prob(s)* Build_2nd_stage(s,g,y)*CAPEX(g)*cap_multiplier(y) )  +
Sum((s,y),prob(s)* (1/(1+r)**(ord(y)-1))*(
Sum((g), Cap(s,g,y)*FOM(g,s))

* dispatch cost - fuel in $
+   sum((g,f)$map(g,f), Sum((t), Gen(s,g,f,y,t)*Duration(t)*VC(g,y,f,t)))


* CO2 Cost in $
+   (sum((g,f)$map(g,f), Sum((t), Gen(s,g,f,y,t)*Duration(t)*GenEmis(g,f)*CO2Price(y,"CO2Price"))))$IncludeCO2Price

* VOM cost in $
+   sum((g,f)$map(g,f), Sum((t), Gen(s,g,f,y,t)*Duration(t)*GenData(g,"VOM")))

* unserved energy cost valued at USD 500 per MWh or 50 cents per kWh
+  Sum((t), USE(s,y,t)*Duration(t)*500  )

* Surplus energy cost valued at 100$ per MWh (not sure I am correct about this)
+  Sum((t), Surplus(s,y,t)*Duration(t)*100  )


* Any reserve MW shortfall is penalized with 100K per MW per year (22nd May- before it was 500K per MW)
+ UnmetReserve(s,y)*100000

))
;


*  The capacity of the new year is equal to the new built capacity and the capacity of the previous year
CapBal(s,g,y)$(ord(y)>1 and prob(s)<>0).. Cap(s,g,y) =e= Cap(s,g,y-1)+Build_1st_stage(g,y)+Build_2nd_stage(s,g,y)-Retire_1st_stage(g,y)-Retire_2nd_stage(s,g,y);

CapBal1st(s,g,y)$(ord(y)=1 and prob(s)<>0)..  Cap(s,g,y) =e= Initial_capacity(g)+Build_1st_stage(g,y)+Build_2nd_stage(s,g,y)-Retire_1st_stage(g,y)-Retire_2nd_stage(s,g,y);

* capacity must exceed peak demand by 15% (as per Deb's advice on May 4th 2016)
*Note that for PV (which is technology 8, we do not count any contribution to the reserves
*since at the peak block it has CF=0
MinCapReserve(s,y)$(prob(s)<>0).. Sum(g$(Technology(g)<>8),Cap(s,g,y)) + UnmetReserve(s,y) =g= 1.15*(1+LDC_growth)**(ORD(Y)-1)*Smax(t, LDC(s,t,y));

*  For each generator the total capacity built can not exceed the derated capacity
MaxBuild(s,g)$(GenData(g,"CapexperMW")and prob(s)<>0) .. Sum(y, Build_1st_stage(g,y)+Build_2nd_stage(s,g,y)) =l= GenData(g,"Pderated");


* Maximum generation on an hourly basis MWh can not exceed capacity  MW
Capacity(s,g,y,t)$(Technology(g)<>8 and prob(s)<>0)..  Sum(f$map(g,f), Gen(s,g,f,y,t)) =l= Der_factor*Cap(s,g,y);
*For solar, which is the only intermittent as of version 8 of the model the output per each time block is constrained based on the solar profile
Intermittent_capacity(s,g,y,t)$(Technology(g)=8 and prob(s)<>0)..  Sum(f$map(g,f), Gen(s,g,f,y,t)) =l= solar_cf(t)*Cap(s,g,y);

*JointFuel(s,g,y,t).. Sum(f$map(g,f), Gen(s,g,f,y,t)) =l= Cap(s,g,y);
*joint fuel seems identical to the constraint above

* Total generation  for every generator and for every year can not exceed the generation corresponding to the maximum capacity factor
MaxCF(s,g,y)$(prob(s)<>0).. Sum(f$map(g,f), Sum(t, Gen(s,g,f,y,t)*Duration(t))) =l= CFmax(g,s)*Cap(s,g,y)*8760;


*MinLoad(g,y,t)$(GenData(g,"Pderated") and GenData(g,"StYr") le Ord(y)+2013)..       Sum(f$map(g,f), Gen(g,f,y,t)) =g=  0*GenData(g,"Pmin")/GenData(g,"Pderated")*Cap(g,y);


FuelBal(s,f,y)$(prob(s)<>0).. Fuel(s,f,y) =e= Sum(g$map(g,f), Sum(t, Gen(s,g,f,y,t)*Duration(t)/(0.293071*Efficiency(g))));

* Fuel limits in MMBTU/YEAR
FuelLimitCon(s,f,y)$(Sum(y1,FuelLimit(f,y1))and prob(s)<>0).. Fuel(s,f,y) =l= FuelLimit(f,y);

DemBal(s,y,t)$(prob(s)<>0).. Sum((g,f)$map(g,f), Gen(s,g,f,y,t)) + USE(s,y,t) - Surplus(s,y,t) =e=(1+LDC_growth)**(ORD(Y)-1)* LDC(s,t,y);

CapitalConstraint(s)$(prob(s)<>0).. Sum(y, Sum((g), (Build_1st_stage(g,y)+Build_2nd_stage(s,g,y))*(Overnight_CAPEX(g)))) =l= Maxcapital*1000;

CoalCapConstraint(s)$(prob(s)<>0).. Sum(y, Sum(g$(GenData(g,"Fuel")=4 and GenData(g,"CapexperMW")), Build_1st_stage(g,y)+Build_2nd_stage(s,g,y))) =l= MaxGwcoaladded*1000;

GasCapConstraint(s) $( prob(s)<>0) ..Sum(y, Sum(g$(GenData(g,"Fuel")=1 and GenData(g,"CapexperMW")), Build_1st_stage(g,y)+Build_2nd_stage(s,g,y))) =l= MaxGWgas*1000;

*BiomassCoalCon(g,"Biomass",y,t)$map(g,"Biomass")..  Gen(g,"Biomass",y,t) =e= 0.15*sum(f$map(g,f), Gen(g,f,y,t));
Energyefficiency(y,s)$(prob(s)<>0)..Cap(s,"EE",y)=l=IncludeEnergyEfficiency*EE_feasible*(1-EEScalingFactor(y))*(1+LDC_growth)**(ORD(Y)-1)*sum(t,  LDC(s,t,y)*Duration(t)/8760);

Peakshaving(y,s)$(prob(s)<>0)..Cap(s,"PS",y)=l=PSsaving(y)*(1+LDC_growth)**(ORD(Y)-1)*Smax(t, LDC(s,t,y));
Intercon(y,s)$(interconnection_limit(y) and prob(s)<>0)..sum(g$(Technology(g)=6 and Operation(g) = 3), Cap(s,g,y))=l= interconnection_limit(y);

Smooth_LNG_1(y,s)$(ord(y)>1 and prob(s)<>0)..Fuel(s,"LNG",y)=l=(Fuel(s,"LNG",y-1))+60000000;
Smooth_LNG_2(y,s)$(ord(y)>1 and prob(s)<>0)..Fuel(s,"LNG",y)=g=0.75*Fuel(s,"LNG",y-1);






built_gas_lb.. sum((g,y)$(Fuel_type(g)=1),Build_1st_stage(g,y))=g=(gas_lb*
(sum((g,y)$(Fuel_type(g)=1),Build_1st_stage(g,y))
+sum((g,y)$(Technology(g)=8),Build_1st_stage(g,y))
+sum((g,y)$(Technology(g)=6),Build_1st_stage(g,y))
+sum((g,y)$(Fuel_type(g)=4),Build_1st_stage(g,y))))/100;

built_gas_ub.. sum((g,y)$(Fuel_type(g)=1),Build_1st_stage(g,y))=l=(gas_ub*
(sum((g,y)$(Fuel_type(g)=1),Build_1st_stage(g,y))
+sum((g,y)$(Technology(g)=8),Build_1st_stage(g,y))
+sum((g,y)$(Technology(g)=6),Build_1st_stage(g,y))
+sum((g,y)$(Fuel_type(g)=4),Build_1st_stage(g,y))))/100;

built_pv_lb.. (sum((g,y)$(Technology(g)=8),Build_1st_stage(g,y)))=g=(pv_lb*
(sum((g,y)$(Fuel_type(g)=1),Build_1st_stage(g,y))
+sum((g,y)$(Technology(g)=8),Build_1st_stage(g,y))
+sum((g,y)$(Technology(g)=6),Build_1st_stage(g,y))
+sum((g,y)$(Fuel_type(g)=4),Build_1st_stage(g,y))))/100;

built_pv_ub.. (sum((g,y)$(Technology(g)=8),Build_1st_stage(g,y)))=l=(pv_ub*
(sum((g,y)$(Fuel_type(g)=1),Build_1st_stage(g,y))
+sum((g,y)$(Technology(g)=8),Build_1st_stage(g,y))
+sum((g,y)$(Technology(g)=6),Build_1st_stage(g,y))
+sum((g,y)$(Fuel_type(g)=4),Build_1st_stage(g,y))))/100;

built_inter_lb.. (sum((g,y)$(Technology(g)=6),Build_1st_stage(g,y)))=g=(inter_lb*
(sum((g,y)$(Fuel_type(g)=1),Build_1st_stage(g,y))
+sum((g,y)$(Technology(g)=8),Build_1st_stage(g,y))
+sum((g,y)$(Technology(g)=6),Build_1st_stage(g,y))
+sum((g,y)$(Fuel_type(g)=4),Build_1st_stage(g,y))))/100;

built_inter_ub.. (sum((g,y)$(Technology(g)=6),Build_1st_stage(g,y)))=l=(inter_ub*
(sum((g,y)$(Fuel_type(g)=1),Build_1st_stage(g,y))
+sum((g,y)$(Technology(g)=8),Build_1st_stage(g,y))
+sum((g,y)$(Technology(g)=6),Build_1st_stage(g,y))
+sum((g,y)$(Fuel_type(g)=4),Build_1st_stage(g,y))))/100;


*parameters capacity_report(sce_id, s,g,y),built_report(sce_id,s,g,y),retire_report(sce_id,s,g,y),capacity_report_by_technology(sce_id,s_tech), built_report_by_technology(sce_id,s_tech), retire_report_by_technology(sce_id,s_tech),share_of_energy(sce_id,f,y),load_considered(sce_id,y)
*;


parameters

demand_unserved(stra_id,sce_id)


total_CAPEX(stra_id,sce_id)
LCOE(stra_id,sce_id)
GHGemission(stra_id,sce_id)

Energy_indep(stra_id,sce_id)

unmet_reserve(stra_id,sce_id)

capacity_by_built(stra_id,sce_id)
capacity_by_retire(stra_id,sce_id)

Energy_depend(stra_id,sce_id)


quality_sol(stra_id,sce_id)


new_unmet_reserve(stra_id,sce_id)


;


Model BangladeshLCP_stoch /all/;

loop (stra_id,

loop (sce_id,

LDC_growth=RDMun(sce_id,"ldc_growth");
Maxcapital=RDMun(sce_id,"maxcap");
MaxGwcoaladded=RDMun(sce_id,"maxgwcoal");
MaxGWgas=RDMun(sce_id,"maxgwgas");
Der_factor=RDMun(sce_id,"derated_factor");
LNG_price_factor=RDMun(sce_id,"LNG_final_price_factor");
Coal_import_price_factor=RDMun(sce_id,"coal_imp_final_price_factor");
Electricity_import_price_factor=RDMun(sce_id,"elec_imp_price_factor");
EE_feasible=RDMun(sce_id,"EE_feasible_factor");
Solar_capex_cost_factor=RDMun(sce_id,"solar_capex_cost_factor");

gas_lb=Strategy(stra_id,"gas_lb");
gas_ub=Strategy(stra_id,"gas_ub");
pv_lb=Strategy(stra_id,"pv_lb");
pv_ub=Strategy(stra_id,"pv_ub");
inter_lb=Strategy(stra_id,"inter_lb");
inter_ub=Strategy(stra_id,"inter_ub");

$ontext
built_gas:=sum((g,y)$(Fuel_type(g)=1),Build_1st_stage.l(g,y));
retire_gas:=sum((g,y)$(Fuel_type(g)=1),Retire_1st_stage.l(g,y));

built_pv:=sum((g,y)$(Technology(g)=8),Build_1st_stage.l(g,y));
retire_pv:=sum((g,y)$(Technology(g)=8),Retire_1st_stage.l(g,y));

built_inter:=sum((g,y)$(Technology(g)=6),Build_1st_stage.l(g,y));
retire_inter:=sum((g,y)$(Technology(g)=6),Retire_1st_stage.l(g,y));

built_coal:=sum((g,y)$(Fuel_type(g)=4),Build_1st_stage.l(g,y));
retire_coal:=sum((g,y)$(Fuel_type(g)=4),Retire_1st_stage.l(g,y));

net_add_gas:=built_gas-retire_gas;
net_add_gas$(net_add_gas<0):=0;
net_add_pv:=built_pv-retire_pv;
net_add_pv$(net_add_pv<0):=0;
net_add_inter:=built_inter-retire_inter;
net_add_inter$(net_add_inter<0):=0;
net_add_coal:=built_coal-retire_coal;
net_add_coal$(net_add_coal<0):=0;
$offtext

*Variable cost of fuel $/MWh-e
VC(g,y,f,t)$(map(g,f)and Technology(g)<>6 and ord(f)=6) =LNG_price_factor**(ord(y)-1)*FuelPrices("LNG","2016")/(0.293071*Efficiency(g));
VC(g,y,f,t)$(map(g,f)and Technology(g)<>6 and ord(f)=4) =Coal_import_price_factor**(ord(y)-1)*FuelPrices("Imp_Coal","2016")/(0.293071*Efficiency(g));
VC(g,y,f,t)$(map(g,f)and Technology(g)<>6 and ord(f)<>6 and ord(f)<>4) =FuelPrices(f,y)/(0.293071*Efficiency(g));
VC(g,y,f,t)$(map(g,f)and Technology(g)=6)= Electricity_import_price_factor**(ord(y)-1)*Import_power_price(g,t);
*The second expressions assigns the interconnections prices
CAPEX(g)$(Technology(g)<>8) =GenData(g,"ANNCAPEXperMW");
CAPEX(g)$(Technology(g)=8) =Solar_capex_cost_factor*GenData(g,"ANNCAPEXperMW");
Overnight_CAPEX(g)$(Technology(g)<>8)= GenData(g,"CapexperMW");
Overnight_CAPEX(g)$(Technology(g)=8)= Solar_capex_cost_factor*GenData(g,"CapexperMW");
Solve BangladeshLCP_stoch using lp minimizing cost;

quality_sol(stra_id,sce_id)=BangladeshLCP_stoch.modelstat;


*capacity_report(sce_id, s,g,y)$(prob(s)<>0)=Cap.l(s,g,y);
*built_report(sce_id,s,g,y)$(prob(s)<>0)=Build_1st_stage.l(g,y);
*retire_report(sce_id,s,g,y)$(prob(s)<>0)=Retire_1st_stage.l(g,y);
*capacity_report_by_technology(sce_id,s_tech)= sum((s,g)$(Technology(g)=ord(s_tech) and prob(s)<>0),Cap.l(s,g,"2030"));
*built_report_by_technology(sce_id,s_tech)= sum((g,y)$(Technology(g)=ord(s_tech)),Build_1st_stage.l(g,y));
*retire_report_by_technology(sce_id,s_tech)= sum((g,y)$(Technology(g)=ord(s_tech)),Retire_1st_stage.l(g,y));
*load_considered(sce_id,y)=sum((s,t)$(prob(s)<>0),(1+LDC_growth)**(ORD(Y)-1)* LDC(s,t,y)*Duration(t));
*share_of_energy(sce_id,f,y)=sum((s,g,t)$(prob(s)<>0),Gen.l(s,g,f,y,t)* Duration(t))/load_considered(sce_id,y)*100;



demand_unserved(stra_id,sce_id)=Sum((s,y)$(prob(s)<>0), Sum((t), USE.l(s,y,t)*Duration(t)))/(Sum((s,y)$(prob(s)<>0), Sum((t),(1+LDC_growth)**(ORD(y)-1)* LDC(s,t,y)*Duration(t))));

*demand_unserved_year(stra_id,sce_id,y)=Sum((s)$(prob(s)<>0), Sum((t), USE.l(s,y,t)*Duration(t)))/(Sum((s)$(prob(s)<>0), Sum((t),(1+LDC_growth)**(ORD(y)-1)* LDC(s,t,y)*Duration(t))));

total_CAPEX(stra_id,sce_id)=Sum((y,g), Build_1st_stage.l(g,y)*Overnight_CAPEX(g));


LCOE(stra_id,sce_id)=(Sum((y,g), Build_1st_stage.l(g,y)*CAPEX(g)*cap_multiplier(y) )+
Sum((s,y)$(prob(s)<>0), (1/(1+r)**(ord(y)-1))*(Sum((g), Cap.l(s,g,y)*FOM(g,s))+   sum((g,f)$map(g,f), Sum((t), Gen.l(s,g,f,y,t)*Duration(t)*VC(g,y,f,t)))
+ sum((g,f)$map(g,f), Sum((t), Gen.l(s,g,f,y,t)*Duration(t)*GenData(g,"VOM"))))))/(Sum((s,y)$(prob(s)<>0),(1/(1+r)**(ord(y)-1))*(sum((g,f)$map(g,f), (Sum((t), Gen.l(s,g,f,y,t)*Duration(t)))))));

GHGemission(stra_id,sce_id)=Sum((s,y)$(prob(s)<>0),(sum((g,f)$map(g,f), Sum((t), Gen.l(s,g,f,y,t)*Duration(t)*GenEmis(g,f)))));

*GHGemission_year(stra_id,sce_id,y)=Sum((s)$(prob(s)<>0),(sum((g,f)$map(g,f), Sum((t), Gen.l(s,g,f,y,t)*Duration(t)*GenEmis(g,f)))));

unmet_reserve(stra_id,sce_id)=Sum((s,y)$(prob(s)<>0),UnmetReserve.l(s,y))/sum((s,y)$(prob(s)<>0),(0.15*(1+LDC_growth)**(ORD(Y)-1)*Smax(t, LDC(s,t,y))));

*unmet_reserve_year(stra_id,sce_id,y)=Sum((s)$(prob(s)<>0), (UnmetReserve.l(s,y)))/sum((s)$(prob(s)<>0),(0.15*(1+LDC_growth)**(ORD(Y)-1)*Smax(t, LDC(s,t,y))));



Energy_indep(stra_id,sce_id)=Sum((s,y)$(prob(s)<>0), (sum((g,f)$(map(g,f) and Fuel_origin(g)=1), Sum((t), Gen.l(s,g,f,y,t)*Duration(t)))))/(Sum((s,y)$(prob(s)<>0),(sum((g,f)$map(g,f), (Sum((t), Gen.l(s,g,f,y,t)*Duration(t)))))));

*Energy_indep_year(stra_id,sce_id,y)=Sum((s)$(prob(s)<>0), (sum((g,f)$(map(g,f) and Fuel_origin(g)=1), Sum((t), Gen.l(s,g,f,y,t)*Duration(t)))))/(Sum((s)$(prob(s)<>0),(sum((g,f)$map(g,f), (Sum((t), Gen.l(s,g,f,y,t)*Duration(t)))))));

*generation_amount(stra_id,sce_id,y)=Sum((s)$(prob(s)<>0),(sum((g,f)$map(g,f), (Sum((t), Gen.l(s,g,f,y,t)*Duration(t))))));

*demand_amount(stra_id,sce_id,y)=Sum((s)$(prob(s)<>0), Sum((t),(1+LDC_growth)**(ORD(y)-1)* LDC(s,t,y)*Duration(t)));

*capacity_exp(stra_id,sce_id,y)=Sum((g), Build_1st_stage.l(g,y)*CAPEX(g)*cap_multiplier(y))+
*Sum((s)$(prob(s)<>0), (1/(1+r)**(ord(y)-1))*(Sum((g), Cap.l(s,g,y)*FOM(g,s))+   sum((g,f)$map(g,f), Sum((t), Gen.l(s,g,f,y,t)*Duration(t)*VC(g,y,f,t)))
*+ sum((g,f)$map(g,f), Sum((t), Gen.l(s,g,f,y,t)*Duration(t)*GenData(g,"VOM")))));

Energy_depend(stra_id,sce_id)=Sum((s,y)$(prob(s)<>0), (sum((g,f)$(map(g,f) and Fuel_origin(g)=2), Sum((t), Gen.l(s,g,f,y,t)*Duration(t)))))/(Sum((s,y)$(prob(s)<>0),(sum((g,f)$map(g,f), (Sum((t), Gen.l(s,g,f,y,t)*Duration(t)))))));

*Energy_depend_year(stra_id,sce_id,y)=Sum((s)$(prob(s)<>0), (sum((g,f)$(map(g,f) and Fuel_origin(g)=2), Sum((t), Gen.l(s,g,f,y,t)*Duration(t)))))/(Sum((s)$(prob(s)<>0),(sum((g,f)$map(g,f), (Sum((t), Gen.l(s,g,f,y,t)*Duration(t)))))));


new_unmet_reserve(stra_id,sce_id)=Sum((s,y)$(prob(s)<>0),UnmetReserve.l(s,y))/Sum((s,y)$(prob(s)<>0),smax(t,sum((g,f)$map(g,f),Gen.l(s,g,f,y,t))));




*display demand_unserved_year;
*display LCOE;
*display GHGemission_year;
*display Energy_indep_year;
*display unmet_reserve_amount_year;
*display demand_unserved_amount_year;
*display quality_sol;

 );
 );


EXECUTE 'GDXXRW Scenario.gdx rng=demand_unserved!A1:AA1000 clear o=Scenario_Results.xls';
*EXECUTE 'GDXXRW Scenario.gdx rng=demand_unserved_y!A1:AA1000 clear o=Scenario_Results.xls';
*EXECUTE 'GDXXRW Scenario.gdx rng=demand_unserved_amount!A1:AA1000 clear o=Scenario_Results.xls';
*EXECUTE 'GDXXRW Scenario.gdx rng=demand_unserved_amount_y!A1:AA1000 clear o=Scenario_Results.xls';
EXECUTE 'GDXXRW Scenario.gdx rng=CAPEX_need!A1:AA1000 clear o=Scenario_Results.xls';
EXECUTE 'GDXXRW Scenario.gdx rng=LCOE!A1:AA1000 clear o=Scenario_Results.xls';
EXECUTE 'GDXXRW Scenario.gdx rng=GHG!A1:AA1000 clear o=Scenario_Results.xls';
*EXECUTE 'GDXXRW Scenario.gdx rng=GHG_y!A1:AA1000 clear o=Scenario_Results.xls';
EXECUTE 'GDXXRW Scenario.gdx rng=Energy_indep!A1:AA1000 clear o=Scenario_Results.xls';
*EXECUTE 'GDXXRW Scenario.gdx rng=Energy_indep_y!A1:AA1000 clear o=Scenario_Results.xls';
EXECUTE 'GDXXRW Scenario.gdx rng=unmet_reserve!A1:AA1000 clear o=Scenario_Results.xls';
*EXECUTE 'GDXXRW Scenario.gdx rng=unmet_reserve_y!A1:AA1000 clear o=Scenario_Results.xls';
*EXECUTE 'GDXXRW Scenario.gdx rng=capacity_built!A1:AA1000 clear o=Scenario_Results.xls';
*EXECUTE 'GDXXRW Scenario.gdx rng=capacity_retire!A1:AA1000 clear o=Scenario_Results.xls';
EXECUTE 'GDXXRW Scenario.gdx rng=model_status!A1:AA1000 clear o=Scenario_Results.xls';
*EXECUTE 'GDXXRW Scenario.gdx rng=generation_amount!A1:AA1000 clear o=Scenario_Results.xls';
*EXECUTE 'GDXXRW Scenario.gdx rng=demand_amount!A1:AA1000 clear o=Scenario_Results.xls';
*EXECUTE 'GDXXRW Scenario.gdx rng=capacity_exp!A1:AA1000 clear o=Scenario_Results.xls';
EXECUTE 'GDXXRW Scenario.gdx rng=Energy_depend!A1:AA1000 clear o=Scenario_Results.xls';
*EXECUTE 'GDXXRW Scenario.gdx rng=Energy_depend_year!A1:AA1000 clear o=Scenario_Results.xls';

*EXECUTE 'GDXXRW Scenario.gdx rng=new_unmet_reserve_y!A1:AA1000 clear o=Scenario_Results.xls';
EXECUTE 'GDXXRW Scenario.gdx rng=new_unmet_reserve!A1:AA1000 clear o=Scenario_Results.xls';
*EXECUTE 'GDXXRW Scenario.gdx rng=peak_demand!A1:AA1000 clear o=Scenario_Results.xls';
*EXECUTE 'GDXXRW Scenario.gdx rng=peak_generation!A1:AA1000 clear o=Scenario_Results.xls';
*EXECUTE 'GDXXRW Scenario.gdx rng=total_capacity!A1:AA1000 clear o=Scenario_Results.xls';
EXECUTE_UNLOAD'Scenario' new_unmet_reserve, Energy_depend,  quality_sol, demand_unserved,  total_CAPEX, LCOE, GHGemission, Energy_indep, unmet_reserve;


EXECUTE 'GDXXRW Scenario.gdx par=demand_unserved rng=demand_unserved!A5 o=Scenario_Results.xls';
*EXECUTE 'GDXXRW Scenario.gdx par=demand_unserved_year rng=demand_unserved_y!A5 o=Scenario_Results.xls';
*EXECUTE 'GDXXRW Scenario.gdx par=demand_unserved_amount rng=demand_unserved_amount!A5 o=Scenario_Results.xls';
*EXECUTE 'GDXXRW Scenario.gdx par=demand_unserved_amount_year rng=demand_unserved_amount_y!A5 o=Scenario_Results.xls';
EXECUTE 'GDXXRW Scenario.gdx par=total_CAPEX rng=CAPEX_need!A5 o=Scenario_Results.xls';
EXECUTE 'GDXXRW Scenario.gdx par=LCOE rng=LCOE!A5 o=Scenario_Results.xls';
EXECUTE 'GDXXRW Scenario.gdx par=GHGemission rng=GHG!A5 o=Scenario_Results.xls';
*EXECUTE 'GDXXRW Scenario.gdx par=GHGemission_year rng=GHG_y!A5 o=Scenario_Results.xls';
EXECUTE 'GDXXRW Scenario.gdx par=Energy_indep rng=Energy_indep!A5 o=Scenario_Results.xls';
*EXECUTE 'GDXXRW Scenario.gdx par=Energy_indep_year rng=Energy_indep_y!A5 o=Scenario_Results.xls';
EXECUTE 'GDXXRW Scenario.gdx par=unmet_reserve rng=unmet_reserve!A5 o=Scenario_Results.xls';
*EXECUTE 'GDXXRW Scenario.gdx par=unmet_reserve_year rng=unmet_reserve_y!A5 o=Scenario_Results.xls';
*EXECUTE 'GDXXRW Scenario.gdx par=capacity_by_built rng=capacity_built!A5 o=Scenario_Results.xls';
*EXECUTE 'GDXXRW Scenario.gdx par=capacity_by_retire rng=capacity_retire!A5 o=Scenario_Results.xls';
EXECUTE 'GDXXRW Scenario.gdx par=quality_sol rng=model_status!A5 o=Scenario_Results.xls';
*EXECUTE 'GDXXRW Scenario.gdx par=generation_amount rng=generation_amount!A5 o=Scenario_Results.xls';
*EXECUTE 'GDXXRW Scenario.gdx par=demand_amount rng=generation_amount!A5 o=Scenario_Results.xls';
*EXECUTE 'GDXXRW Scenario.gdx par=capacity_exp rng=capacity_exp!A5 o=Scenario_Results.xls';
EXECUTE 'GDXXRW Scenario.gdx par=Energy_depend rng=Energy_depend!A5 o=Scenario_Results.xls';
*EXECUTE 'GDXXRW Scenario.gdx par=Energy_depend_year rng=Energy_depend_year!A5 o=Scenario_Results.xls';

EXECUTE 'GDXXRW Scenario.gdx par=new_unmet_reserve rng=new_unmet_reserve!A5 o=Scenario_Results.xls';

