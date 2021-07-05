#!/bin/bash

# IAN1 & IAN2: integer atomic numbers of the atoms/particles #1 and 2 forming the molecule. If both are positive and ≤ 109 , atomic masses from the tabulation in subroutine MASSES are used to generate the reduced mass of the system.
IAN1=6
IAN2=6

# IMN1 & IMN2 : integer mass numbers of the atoms/particles #1 and 2 forming the molecule. For a normal stable atomic isotope, its mass is taken from the tabulation in subroutine MASSES
IMN1=12
IMN2=12

# CHARGE : ± integer for the total charge on the molecule. Normally causes the reduced mass of a molecular ion to be defined as the ‘charge-modified’ reduced mass of Eq.(2) [5].
CHARGE=0

# NUMPOT : the number of potentials considered: NUMPOT = 1 for calculations involving only a single potential function; NUMPOT = 2 to input and generate two different potentials and calculate matrix elements coupling their levels.
NUMPOT=2

# TITL : a title or output header for the calculation, consisting of up to 78 characters on a single line, enclosed between single quotes: e.g., ′title of problem′.
TITL="'Morse potential of C2- and A-X Einstein A coefficients'"

# RH : the numerical integration mesh size; see discussion associated with Eq. (3) in § 2.1.
RH=0.0010

# RMIN & RMAX : the inner and outer limits, respectively, of the range of numerical integration (see §2.1). Plausible zeroth order estimates would be RMIN≈ 0.6×(potential innerwallposition) andRMAXfairlylarge(say40 ̊A).InternallyRMAXissettothesmaller of: this read-in value, or the largest distance allowed by RMIN, RH and the array dimension NDIMR (see § 3).
RMIN=0.2
RMAX=30.0

# EPS: the eigenvalue convergence parameter used by SCHRQ (in cm−1). To ensure that appropriately accurate expectation values or matrix elements are generated, it should normally be set ca. 2 orders of magnitude smaller than the eigenvalue precision actually required.
EPS=1.d-6

# NTP : an integer that is set ≤ 0 to generate an analytic potential using POTGEN, in which case the program skips Reads #7–9 and goes directly to Read #10. If NTP> 0, it is the number of turning points to be input via Read #9.
# NTP has to be 0 for this wrapper.
NTP1=0
NTP2=0

# LPPOT: controls printing of the potential array (normally set =0 to have no printing). If LPPOT > 0 , write the potential and its first 2 derivatives-by-differences to standard output (Channel–6) at every LPPOTth mesh point; it is sometimes useful to do this when troubleshooting. Setting LPPOT < 0 writes the resulting potential in condensed format to Channel–8 at every |LPPOT|th mesh point; this is useful if one wants to employ this calculated potential as input for a plotting program.
LPPOT1=0
LPPOT2=0

# OMEGA: the (integer) projection of the electronic orbital angular momentum onto the molecular axis for this state. It causes the reduced centrifugal potential to become [J(J +1)−OMEGA2]hbar2/(2μr2). Setting OMEGA≥ 99 will cause the centrifugal potential to have the form [J2 − 1/4]hbar2/(2μr2) that is appropriate for rotation constrained to a plane.
OMEGA1=0
OMEGA2=1

# VLIM: the absolute energy (in cm−1) of the potential asymptote. This value sets the ab- solute energy scale for the calculations. For power-series (GPEF- or Dunham-type) potentials (IPOTL=2), it specifies the energy at the potential function minimum, where r = re .
VLM1=68605.5d0
VLM2=63845.7d0

# IPOTL is an integer specifying the type of analytic function used for the potential.
# IPOTL = 3 : generates the Morse or EMO potential of Eq. (15), in which De = DSCM , re =REQ, and the expansion-variable of Eq.(17) is defined by the positive integer q = QPAR , while the expansion coefficients are PARM(i) = βi−1 for i = 1 to NVARB = (Nbeta + 1).
# IPOTL has to be 3 for this wrapper.
IPOTL1=3
IPOTL2=3
# If QPAR ≤ 0 , generate the 4–parameter Morse-like potential of Hua Wei [36]
QPAR1=1
QPAR2=1
# Setting Nbeta = 0 ( NVARB = 1) yields the ordinary Morse potential.
Nbeta1=0
Nbeta2=0
# PPAR and APSE are dummy variables.
PPAR1=3
PPAR2=3
APSE1=0
APSE2=0

# IBOB : an integer to specify whether (for IBOB > 0 ) or not (for IBOB ≤ 0 ) atomic-mass- dependent Born-Oppenheimer breakdown correction terms are to be included in the potential energy function V (r), and/or in the centrifugal { [J(J + 1) − Ω2]􏰀2/(2μr2) } potential (see § 2.7).
IBOB1=0
IBOB2=0

# DSCM : normally (except for the IPOTL = 2 case) the potential well depth D_e in cm−1.
DSCM1=68605.5d0
DSCM2=59795.2d0

# REQ : normally (except for the IPOTL = 8 case, in which it defines rm ) the equilibrium distance re in angstrom.
REQ1=1.268d0
REQ2=1.307d0

# Rref : the reference distance in the definition of the exponent expansion radial variable of Eqs. (17) and (23). If the input value is ≤ 0.0, the code sets r_ref = r_e.
Rref1=0.d0
Rref2=0.d0

# PARM(i) : are the NVARB parameters characterizing the potential functions. For example, the βi parameters of Eqs. (13), (23), (33) or (34), or the coefficients βi of the exponent polynomials defining the EMO or DELR potentials.
PARM1=2.02841D+00
PARM2=2.0328D+00

# NLEV1: if ≤ 0 , the program automatically finds all vibrational levels from v = 0 − |NLEV1| associated with the rotational quantum number read in as IJ(1) (see below). If the input value of NLEV is very large and negative, the program will (attempt to) find all possible vibrational levels associated with the specified J = IJ(1).
NLEV1=-21

# AUTO1 : integer AUTO1 > 0 (normal option) causes the program to (attempt to) generate automatically realistic trial eigenvalues for all desired levels, so that only their quantum number labels need be input via (Read #25a). If this fails, setting AUTO1 ≤ 0 will allow/require a trial energy GV(i) to be input (via Read #25b) for each specified level using the NLEV1 > 0 option.
AUTO1=1

# LCDC : If LCDC > 0 , calculate the inertial rotational constant Bv and the first 6 centrifugal distortion constants {−Dv , Hv , Lv , Mv , Nv , & Ov } for all of the levels specified by NLEV1. These results are also written in a compact format to Channel-9.
LCDC=0

# LXPCT : An integer controlling which expectation values/matrix elements are to be calculated.
# |LXPCT| ≥ 3 invokes the calculation of matrix elements coupling levels of Potential-1 to each other (if NUMPOT = 1) or to levels of Potential-2 (if NUMPOT = 2), as specified by Reads #27 and 28. Write results to Channel–6 if LXPCT > 0 and (compactly) to Channel–8 if LXPCT = ±4 .
LXPCT=4

# NJM & JDJR : if (integer) NJM > 0 , then for each (vibrational) level generated by the NLEV1 specification, automatically calculate eigenvalues (and if appropriate, expectation values and matrix elements) for all rotational sublevels J ranging from the input-specified (see below) J = IJ(i) to a maximum of J = NJM (or until that vibrational level energy predissociates above the potential barrier), with J increasing in steps of JDJR. e.g., to determine automatically all possible rotational levels, set JDJR = 1 , IJ(i) = 0 (or more strictly = |Ω|) and NJM very large (e.g., NJM = 999).
NJM=0
JDJR=2

# IWR : an integer controlling the printout of diagnostics and calculation details inside sub- routine SCHRQ. If IWR ̸= 0 print warning and error messages inside SCHRQ, as appropriate. Unless one is troubleshooting, normally set IWR = −1.
IWR=-1

# LPRWF : If LPRWF = 0 , no wavefunction printout.
LPRWF=0

# IV(i) & IJ(i) : For NLEV1 > 0 these are the vibrational [ v = IV(i) ] and rotational [ J = IJ(i) ] quantum numbers of the levels to be determined; if NJM > IJ(i) the program also automatically calculates rotational levels for that v = IV(i) with J = IJ(i) to NJM in steps of JDJR.
IV_1=0
IJ_1=0

# MORDR : an integer specifying the highest power of the chosen radial function or distance coordinate RFN(r) for which expectation values or matrix elements are to be calculated (see Eq. (8)). The current program version is dimensioned for MORDR ≤ 20 . To calculate only Franck-Condon factors (when |LXPCT| ≥ 3), set MORDR = −1 .
MORDR=3

# IRFN & DREF : integer and real variables, respectively, specifying the definition of the radial function or distance coordinate RFN(r). If IRFN = 0 , the function RFN(r) = r , the distance coordinate itself.
IRFN=0
DREF=1.D0

# DM(j) : Coefficients of the power series in RFN(r) defining the argument of the overall expectation values or matrix elements: M(r) = Σ^MORDR_j=0 DM(j) ×RFN(r)^j
DM1=-1.78203d0
DM2=6.32393d0
DM3=-4.23357d0
DM4=0.816038d0

# For matrix element calculations (|LXPCT| ≥ 3), couple each level of Potential-1, generated as specified by Read s #24 and 25, to all rotation levels of the NLEV2 vibrational levels v = IV2(i) allowed by the rotational selection rules ∆J = J2DL to J2DU in steps of J2DD (e.g., for P and R transitions: J2DL = −1 , J2DU = +1 J2DD = +2 ). If NUMPOT = 2 these are levels of Potential-2 and no constraints are imposed, but if NUMPOT = 1 the matrix elements couple levels of Potential-1 to one another, and to avoid redundancy the program considers only emission from (rotational sublevels of) these NLEV2 vibrational levels into lower (v′′, J′′) levels generated as per Read s #32 & 33. Integer AUTO2 > 0 causes LEVEL to generate trial eigenvalues automatically for all desired levels (preferred option), so only their vibrational quantum number labels need be input (Read #33a). If this fails, setting AUTO2 ≤ 0 will require a trial pure vibrational energy GV2(i) to be read in (Read #33b) for each specified level.
NLEV2=21
AUTO2=1
J2DL=0
J2DU=0
J2DD=1

IV2=`echo {0..20}`

./a.out << EOS;
$IAN1 $IMN1 $IAN2 $IMN2 $CHARGE $NUMPOT
$TITL
$RH $RMIN $RMAX $EPS
$NTP1 $LPPOT1 $OMEGA1 $VLM1
$IPOTL1 $QPAR1 $PPAR1 $Nbeta1 $APSE1 $IBOB1
$DSCM1 $REQ1 $Rref1
$PARM1
$NTP2 $LPPOT2 $OMEGA2 $VLM2
$IPOTL2 $QPAR2 $PPAR2 $Nbeta2 $APSE2 $IBOB2
$DSCM2 $REQ2 $Rref2
$PARM1
$NLEV1 $AUTO1 $LCDC $LXPCT $NJM $JDJR $IWR $LPRWF
$IV_1 $IJ_1
$MORDR $IRFN $DREF
$DM1 $DM2 $DM3 $DM4
$NLEV2 $AUTO2 $J2DL $J2DU $J2DD
$IV2
EOS
