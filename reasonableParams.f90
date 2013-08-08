SUBROUTINE stickywage_AMA_SetAllParams(params) !parameter file


IMPLICIT NONE
INTEGER :: MAXELEMS, HROWS, HCOLS, LEADS, qrows, qcols
INTEGER, DIMENSION(3888) :: hmatj, hmati
REAL(KIND = 8), DIMENSION(3888) :: hmat

INTEGER :: maxNumberOfHElements, aux, rowsinQ, essential, retCODE,i, maxSize, testnp

REAL(KIND = 8), DIMENSION(3888) :: g, h
REAL(KIND = 8), DIMENSION(35) :: params


REAL(KIND = 8), DIMENSION(3888) :: newHmat, qmat, bmat, rootr, rooti
INTEGER(KIND = 8), DIMENSION(3888) :: newHmatj, newHmati, qmatj, qmati, bmati, bmatj
INTEGER, dimension(:), allocatable :: aPointerToVoid
INTEGER :: DISCRETE_TIME, ierr

INTEGER :: rows, cols


! Below, all of the parameters used in the model are declared.
! However, the user should add to this list any intermediate parameters used in calculation.

REAL(KIND = 8) :: gamtil
REAL(KIND = 8) :: beta
REAL(KIND = 8) :: ihabitswitch
REAL(KIND = 8) :: delta
REAL(KIND = 8) :: Gz
REAL(KIND = 8) :: phii
REAL(KIND = 8) :: intswitch
REAL(KIND = 8) :: ap
REAL(KIND = 8) :: kappap
REAL(KIND = 8) :: ep
REAL(KIND = 8) :: sigmal
REAL(KIND = 8) :: aw
REAL(KIND = 8) :: bw
REAL(KIND = 8) :: alpha
REAL(KIND = 8) :: gg
REAL(KIND = 8) :: shrcy
REAL(KIND = 8) :: shriy
REAL(KIND = 8) :: gam_rs
REAL(KIND = 8) :: gam_dp
REAL(KIND = 8) :: gamdy
REAL(KIND = 8) :: rhotech
REAL(KIND = 8) :: sdevtech
REAL(KIND = 8) :: rhog
REAL(KIND = 8) :: sdevg
REAL(KIND = 8) :: rhoinv
REAL(KIND = 8) :: sdevinv
REAL(KIND = 8) :: rhoeta
REAL(KIND = 8) :: sdeveta
REAL(KIND = 8) :: rhomuc1
REAL(KIND = 8) :: sdevmuc
REAL(KIND = 8) :: rhoint
REAL(KIND = 8) :: sdevint
REAL(KIND = 8) :: rhomark
REAL(KIND = 8) :: sdevmark
REAL(KIND = 8) :: rhomarkw
DOUBLE PRECISION :: kss, gdpss, invss, css, rwss, mucss, lamss, kappaw
DOUBLE PRECISION :: mc, realrate, rhomuc2, sdevmarkw, shrgy, gamxhp, sigmaa
DOUBLE PRECISION :: markupw, markup, lamhp, hpswitch, epw, phiw, phi
DOUBLE PRECISION :: gamma, psil, pibar, k2yrat, labss
!user must input coefficient values here
!Since this file gets overwritten each time the parser is called, the user
!may wish to assign these values in a separate routine.
gamtil=0 
beta=0 
ihabitswitch=0 
delta=0 
Gz=0 
phii=0 
intswitch=0 
ap=0 
kappap=0 
ep=0 
sigmal=0 
aw=0 
bw=0 
alpha=0 
gg=0 
shrcy=0 
shriy=0 
gam_rs=0 
gam_dp=0 
gamdy=0 
rhotech=0 
sdevtech=0 
rhog=0 
sdevg=0 
rhoinv=0 
sdevinv=0 
rhoeta=0 
sdeveta=0 
rhomuc1=0 
sdevmuc=0 
rhoint=0 
sdevint=0 
rhomark=0 
sdevmark=0 
rhomarkw=0 


!! now, set their values
beta  = 0.9987
pibar = 1.006
Gz = 1.0041  !tech growth (gross)
psil = 1
gamma = 0.858  !habit persistence
sigmal = 4.49   !governs labor supply elasticity
phi = 95
phiw = 8000  
ep = 6
epw = 8
ap = 0.87    !(1-ap) is the degree of backward indexation of prices
aw = 0.92    !(1-aw) is the degree to which wages are indexed to price inflation
bw = 0.92   !(1-bw) is the degree to which wages are indexed to tech shock

intswitch = 1  ! 1 internal investment adjustment cost  0, external costs 
ihabitswitch = 1  ! 1 internal habits; 0 external 
hpswitch = 0   ! 0 one-sided hp-filter  1 two-sided hp-filter
lamhp = 1600

markup = ep/(ep-1)  !steady state markup
markupw = epw/(epw-1)
alpha = 0.167  !capital elasticity in C-D production function
delta = 0.025
phii = 3.14    !adj. costs on investment (external)
sigmaa = 10000

!Taylor rule parameters (This is our approximation to JPT)
gam_rs = 0.86
gam_dp = 1.688
gamxhp = 0
gamdy = 0.21/(1-gam_rs)

shrgy = 0.2

!technology shock
rhotech = 0
sdevtech = 0.01

!gov't shock
rhog = 0.95
sdevg = 0.01

!inv specific shock
rhoinv = 0.77  
sdevinv = 0.07

!eta shock
rhoeta = 0.9  
sdeveta = 0.01

!monetary shock
rhoint = 0  
sdevint = 0.01

!markup shock
rhomark = 0.98  
sdevmark = 0.01

!wage markup shock
rhomarkw = 0.98
sdevmarkw = 0.01

! MUC shock
rhomuc1 = 1.4
rhomuc2 = 1 - rhomuc1 - 0.001
sdevmuc = 0.1

!! ---------------------------------
!! steady state and definitions used
!! by linear model
!! ---------------------------------


gamtil = gamma/Gz
realrate = Gz/beta
mc = 1/markup
k2yrat = ((mc*alpha)/(realrate-(1-delta)))*Gz
shriy = (1-(1-delta)/Gz)*k2yrat
gg = 1/(1-shrgy)
shrcy = 1-shriy-shrgy
!if (ihabitswitch == 0)
labss = ((1/markupw)*(1-alpha)*mc*(1/(psil*(1-gamtil)))*(1/shrcy))**(1/(sigmal+1))
!else
!    labss = ((1/markupw)*(1-alpha)*(1-beta*gamtil)*mc*(1/(psil*(1-gamtil)))*(1/shrcy))**(1/(sigmal+1));
!end
kss = labss*(Gz**(alpha/(alpha-1)))*k2yrat**(1/(1-alpha))
gdpss = (kss/Gz)**alpha*labss**(1-alpha)
invss = shriy*gdpss
css = shrcy*gdpss
rwss = (1-alpha)*mc*gdpss/labss
mucss = (1/css)*(1/(1-gamtil))
!if (ihabitswitch == 0)
    lamss = mucss
!else
!    lamss = mucss*(1-beta*gamtil)
!end
kappap = (ep-1)/(phi*(1+beta*(1-ap)))
kappaw = epw*(1-gamtil)*psil*labss**(1+sigmal)/phiw

params(1) = gamtil
params(2) = beta
params(3) = ihabitswitch
params(4) = delta
params(5) = Gz
params(6) = phii
params(7) = intswitch
params(8) = ap
params(9) = kappap
params(10) = ep
params(11) = sigmal
params(12) = aw
params(13) = bw
params(14) = alpha
params(15) = gg
params(16) = shrcy
params(17) = shriy
params(18) = gam_rs
params(19) = gam_dp
params(20) = gamdy
params(21) = rhotech
params(22) = sdevtech
params(23) = rhog
params(24) = sdevg
params(25) = rhoinv
params(26) = sdevinv
params(27) = rhoeta
params(28) = sdeveta
params(29) = rhomuc1
params(30) = sdevmuc
params(31) = rhoint
params(32) = sdevint
params(33) = rhomark
params(34) = sdevmark
params(35) = rhomarkw



END SUBROUTINE stickywage_AMA_SetAllParams

