

subroutine getABIntegral(ab,s,t,mt2,mchi2,mst2,muR2,deltaUV)

    ! Return the combination of 1-point and 2-point integrals required
    ! for computing the self-energy contributions
    ! ab(s,t) = (mST**2 - mChi**2 - t)*B0(t,mChi**2,mST**2) - A0(mST**2) + A0(mChi**2)
    ! (s and mt2 are required to automatically compute and cache the t and u integrals)

    use collier

    implicit none

    ! Invariants s=(p1+p2)**2 (gluon momentum squared), p1sq  and p2sq (top and anti-top momenta squared)
    
    double complex s,t,u,mt2 
    double complex mchi2,mst2
    double precision muR2,deltaUV
    double complex ab
    integer N,rank
    double precision Pi
    parameter  (Pi=3.141592653589793D0)

    double complex newInputAB(0:4)
    logical differs

    ! Internal cache for storing the results of the D integrals
    ! (for u and t ) and avoiding duplicated calculations
    double complex OutPutAB(1:2)
    double complex InputVarsAB(1:2,0:4)
    double complex A0chi,A0st,B0
    integer cachedAB
    common/colliercacheAB/OutPutAB,InputVarsAB,cachedAB

    N = 2
    rank = 1

    ! Store new input variables
    newInputAB = (/ s,t,mt2,mchi2,mst2 /)
    ! Set to zero small variable values
    call setSmallToZero(newInputAB,1d-5)
    s = newInputAB(0)
    t = newInputAB(1)
    mt2 = newInputAB(2)
    mchi2 = newInputAB(3)
    mst2 = newInputAB(4)

    ! Check if the given input variables matches any
    ! of the cached ones
    if (.not.differs(InputVarsAB(1,:),newInputAB)) then
        cachedAB = 1
    else if (.not.differs(InputVarsAB(2,:),newInputAB)) then
        cachedAB = 2
    else
        cachedAB = 0
    endif
    
    ! If cachedAB = 0, we need to compute it and cache
    ! (we know the values for p1,p2 and p1<->p2 will have to be computed
    ! so we already do both and cache)
    if (cachedAB == 0) then
        cachedAB = 1
        call Init_cll(N,rank,'',.true.)
        call InitEvent_cll
        ! Using mode=3 computes with the DD and COLI branches and return the most precise results
        call SetMode_cll(3) 
        call SetDeltaUV_cll(deltaUV) ! Remove the divergence (MSbar)
        call SetMuUV2_cll(muR2) ! Set the renormalization scale    
        call A0_cll(A0chi,mchi2)
        call A0_cll(A0st,mst2)  
        A0chi = A0chi/((2*Pi)**4)
        A0st = A0st/((2*Pi)**4)

        ! Compute the input for the given variables
        InputVarsAB(1,:) = (/ s,t,mt2,mchi2,mst2 /)
        call B0_cll(B0,t,mchi2,mst2)
        B0 = B0/((2*Pi)**4)
        ! Store the result in the first entry
        OutPutAB(1) = (mst2-mchi2-t)*B0 - A0st + A0chi
        
        ! Compute the input changing p1<->p2 (t<->u)
        u = -(s+t) + 2*mt2
        InputVarsAB(2,:) = (/ s,u,mt2,mchi2,mst2 /)
        call B0_cll(B0,u,mchi2,mst2)
        B0 = B0/((2*Pi)**4)
        ! Store the result in the second entry
        OutPutAB(2) = (mst2-mchi2-u)*B0 - A0st + A0chi
    endif

    ! We can finally return the cached input
    ab = OutPutAB(cachedAB)
    
end subroutine getABIntegral

! ------------------------------------------------------------
! Directly uses COLLIER to compute all needed integrals
! ------------------------------------------------------------
!
!               p21               
!                |                
!                |                
!               / \               
!              /   \              
!       m12   /1   2\   m22       
!            /       \            
!           /    0    \           
! p10  ---------------------  p20 
!               m02               
!
! m02,m12,m22 -> masses squared
! p10 = p1^2, p20 = p2^2, p21 = p3^3 = s 

! THE CORRECT ORDERING OF THE ARGUMENTS SHOULD BE p1sq,s,p2sq TO MATCH THE LOOP INTEGRALS
subroutine getCIntegrals(Ccoeff,p1sq,s,p2sq,mchi2,mst2,muR2,deltaUV)

    ! Return the 3-point integrals. Note that the normalization includes the 1/(2*pi)^4 factor!

    use collier

    implicit none

    ! Invariants s=(p1+p2)**2 (gluon momentum squared), p1sq  and p2sq (top and anti-top momenta squared)
    
    double complex s, p1sq, p2sq 
    double complex mchi2,mst2
    double precision muR2,deltaUV
    double complex Ccoeff(0:1,0:2,0:2),Ccoeffuv(0:1,0:2,0:2)
    integer N,rank
    double precision Pi
    parameter  (Pi=3.141592653589793D0)

    double complex newInputC(0:4)
    logical differs

    ! Internal cache for storing the results of the D integrals
    ! (for u and t ) and avoiding duplicated calculations
    double complex OutPutC(1:2,0:1,0:2,0:2)
    double complex InputVarsC(1:2,0:4)
    integer cachedC
    common/colliercacheC/OutPutC,InputVarsC,cachedC

    N = 3 ! Maximum number for loop (3-point function)
    rank = 2 ! Maximum rank for loop (=N)

    ! Store new input variables
    newInputC = (/ p1sq,s,p2sq,mchi2,mst2 /)
    ! Set to zero small variable values
    call setSmallToZero(newInputC,1d-5)
    p1sq = newInputC(0)
    s = newInputC(1)
    p2sq = newInputC(2)
    mchi2 = newInputC(3)
    mst2 = newInputC(4)

    ! Check if the given input variables matches any
    ! of the cached ones
    if (cachedC > 0) then
        if (.not.differs(InputVarsC(1,:),newInputC)) then
            cachedC = 1
        else if (.not.differs(InputVarsC(2,:),newInputC)) then
            cachedC = 2
        else
            cachedC = 0
        endif
    endif
    
    ! If cachedC = 0, we need to compute it and cache
    ! (we know the values for p1,p2 and p1<->p2 will have to be computed
    ! so we already do both and cache)
    if (cachedC == 0) then
        cachedC = 1
        call Init_cll(N,rank,'',.true.)
        call InitEvent_cll
        ! Using mode=3 computes with the DD and COLI branches and return the most precise results
        call SetMode_cll(3) 
        call SetDeltaUV_cll(deltaUV) ! Remove the divergence (MSbar)
        call SetMuUV2_cll(muR2) ! Set the renormalization scale    
        ! Compute the input for the given variables
        InputVarsC(1,:) = (/ p1sq,s,p2sq,mchi2,mst2 /)
        call C_cll(Ccoeff,Ccoeffuv,p1sq,s,p2sq,mchi2,mst2,mst2,rank)        
        Ccoeff = Ccoeff/((2*Pi)**4)
        ! Store the result in the first entry
        OutPutC(1,:,:,:) = Ccoeff
        ! Compute the input changing p1<->p2 (t<->u)
        InputVarsC(2,:) = (/ p2sq,s,p1sq,mchi2,mst2 /)
        call C_cll(Ccoeff,Ccoeffuv,p2sq,s,p1sq,mchi2,mst2,mst2,rank)        
        Ccoeff = Ccoeff/((2*Pi)**4)
        ! Store the result in the second entry
        OutPutC(2,:,:,:) = Ccoeff
    endif

    ! We can finally return the cached input
    Ccoeff = OutPutC(cachedC,:,:,:)
    
end subroutine getCIntegrals


! ------------------------------------------------------------
! Directly uses COLLIER to compute all needed integrals
! ------------------------------------------------------------
!                  p31                  
!          ------------------           
!         /                   \         
!                  m22                  
!    p21  ---------------------  p32 \  
!              |    2    |            \ 
!              |         |             |
!          m12 |1       3| m32         | p20
!              |         |             |
!              |    0    |            / 
!    p10  ---------------------  p30 /  
!                  m02                  
!

subroutine getDIntegralsOnShell(Dcoeff,s,t,mst2,mchi2,mt2,muR2,deltaUV)

    ! Return the 4-point integrals for the external momenta onshell.
    ! The order of the arguments is defined by the loop integrals provided by FeynCalc:
    ! D_{ijk} (0,t or u, MT^2, s, MT^2, 0, mST^2, mST^2, mChi^2, mST^2)

    ! The Collier function follows the same argument ordering as FeynCalc/PackageX
    ! (except that PackageX takes the propagator masses without squares)    
    ! Note that the normalization includes the 1/(2*pi)^4 factor!
    
    ! D0 = Dcoeff(0,0,0,0)
    ! D1 = Dcoeff(0,1,0,0)
    ! D2 = Dcoeff(0,0,1,0)
    ! D3 = Dcoeff(0,0,0,1)
    ! D00 = Dcoeff(1,0,0,0)
    ! D11 = Dcoeff(0,2,0,0)
    ! D12 = Dcoeff(0,1,1,0)
    ! D13 = Dcoeff(0,1,0,1)
    ! D22 = Dcoeff(0,0,2,0)
    ! D23 = Dcoeff(0,0,1,1)
    ! D33 = Dcoeff(0,0,0,2)
    ! D001 = Dcoeff(1,1,0,0)
    ! D002 = Dcoeff(1,0,1,0)
    ! D003 = Dcoeff(1,0,0,1)
    ! D111 = Dcoeff(0,3,0,0)
    ! D112 = Dcoeff(0,2,1,0)
    ! D113 = Dcoeff(0,2,0,1)
    ! D122 = Dcoeff(0,1,2,0)
    ! D123 = Dcoeff(0,1,1,1)
    ! D133 = Dcoeff(0,1,0,2)
    ! D222 = Dcoeff(0,0,3,0)
    ! D223 = Dcoeff(0,0,2,1)
    ! D233 = Dcoeff(0,0,1,2)
    ! D333 = Dcoeff(0,0,0,3)

    use collier

    implicit none

    double complex k1sq,k2sq
    double complex s,t,u,mchi2,mst2,mt2
    double complex xs,xt,xu,xmchi2,xmst2,xmt2
    double precision muR2,deltaUV
    double complex Dcoeff(0:1,0:3,0:3,0:3),Dcoeffuv(0:1,0:3,0:3,0:3)
    integer N,rank,i,j,k
    double precision Pi
    parameter  (Pi=3.141592653589793D0)

    double complex newInputD(0:4)
    logical differs

    ! Internal cache for storing the results of the D integrals
    ! (for u and t ) and avoiding duplicated calculations
    double complex OutPutD(1:2,0:1,0:3,0:3,0:3)
    double complex InputVarsD(1:2,0:4)
    integer cachedD
    common/colliercacheD/OutPutD,InputVarsD,cachedD

    N = 4 ! Maximum number for loop (3-point function)
    rank = 3 ! Maximum rank for loop (=N)
    ! Set to zero small variable values
    newInputD = (/ s,t,mst2,mchi2,mt2 /)
    call setSmallToZero(newInputD,1d-5)
    s = newInputD(0)
    t = newInputD(1)
    mst2 = newInputD(2)
    mchi2 = newInputD(3)
    mt2 = newInputD(4)

    u = -(s+t) + 2*mt2
    ! Rescale invariants by mst2 to improve stability
    xs = s/mst2
    xt = t/mst2
    xu = u/mst2
    xmst2 = 1d0
    xmchi2 = mchi2/mst2
    xmt2 = mt2/mst2


    ! Store new (rescaled) input variables
    newInputD = (/ xs,xt,xmst2,xmchi2,xmt2 /)
    k1sq = 0d0
    k2sq = 0d0

    ! Check if the given input variables matches any
    ! of the cached ones
    if (.not.differs(InputVarsD(1,:),newInputD)) then
        cachedD = 1
    else if (.not.differs(InputVarsD(2,:),newInputD)) then
        cachedD = 2
    else
        cachedD = 0
    endif

    ! If cachedD = 0, we need to compute it and cache
    ! (we know the values for pq,p2 and p1<->p2 (t<->u) will have to be computed
    ! so we already do both and cache)
    if (cachedD == 0) then
        cachedD = 1
        call Init_cll(N,rank,'',.true.)
        call InitEvent_cll
        ! Using mode=3 computes with the DD and COLI branches and return the most precise results
        call SetMode_cll(3)
        call SetDeltaUV_cll(deltaUV) ! Remove the divergence (MSbar)
        call SetMuUV2_cll(muR2) ! Set the renormalization scale    
        ! Compute the input for the given variables
        InputVarsD(1,:) = (/ xs,xt,xmst2,xmchi2,xmt2 /)
        call D_cll(Dcoeff,Dcoeffuv,xmt2,xt,k1sq,xs,k2sq,xmt2,xmst2,xmchi2,xmst2,xmst2,rank)
        Dcoeff = Dcoeff/((2*Pi)**4)
        ! Rescale coefficients
        do i=0,3
            do j=0,3
              do k =0,3
                Dcoeff(0,i,j,k) = Dcoeff(0,i,j,k)/mst2**2
                Dcoeff(1,i,j,k) = Dcoeff(1,i,j,k)/mst2
              enddo
            enddo
        enddo    
      
        ! Store the result in the first entry
        OutPutD(1,:,:,:,:) = Dcoeff
        ! Compute the input changing p1<->p2 (t<->u)
        InputVarsD(2,:) = (/ xs,xu,xmst2,xmchi2,xmt2 /)
        call D_cll(Dcoeff,Dcoeffuv,xmt2,xu,k1sq,xs,k2sq,xmt2,xmst2,xmchi2,xmst2,xmst2,rank)
        Dcoeff = Dcoeff/((2*Pi)**4)
        ! Rescale coefficients
        do i=0,3
            do j=0,3
              do k =0,3
                Dcoeff(0,i,j,k) = Dcoeff(0,i,j,k)/mst2**2
                Dcoeff(1,i,j,k) = Dcoeff(1,i,j,k)/mst2
              enddo
            enddo
        enddo
        ! Store result in the second entry
        OutPutD(2,:,:,:,:) = Dcoeff
    endif

    ! We can finally return the cached input
    Dcoeff = OutPutD(cachedD,:,:,:,:)
    
end subroutine getDIntegralsOnShell


subroutine getD0IntegralOnShell(D0coeff,s,t,mst2,mchi2,mt2,muR2,deltaUV)

    ! Return the 4-point integrals for the external momenta onshell.
    ! The order of the arguments is defined by the loop integrals provided by FeynCalc
    ! The D0 integral has to be defined separately, because the order of the arguments
    ! is different

    use collier

    implicit none

    double complex k1sq,k2sq
    double complex s,t,u,mchi2,mst2,mt2
    double complex xs,xt,xu,xmchi2,xmst2,xmt2
    double precision muR2,deltaUV
    double complex D0coeff
    integer N,rank,i,j,k
    double precision Pi
    parameter  (Pi=3.141592653589793D0)

    double complex newInputD0(0:4)
    logical differs

    ! Internal cache for storing the results of the D integrals
    ! (for u and t ) and avoiding duplicated calculations
    double complex OutPutD0(1:2)
    double complex InputVarsD0(1:2,0:4)
    integer cachedD0
    common/colliercacheD0/OutPutD0,InputVarsD0,cachedD0

    N = 4 ! Maximum number for loop (3-point function)
    rank = 3 ! Maximum rank for loop (=N)
    ! Set to zero small variable values
    newInputD0 = (/ s,t,mst2,mchi2,mt2 /)
    call setSmallToZero(newInputD0,1d-5)
    s = newInputD0(0)
    t = newInputD0(1)
    mst2 = newInputD0(2)
    mchi2 = newInputD0(3)
    mt2 = newInputD0(4)

    u = -(s+t) + 2*mt2
    ! Rescale invariants by mst2 to improve stability
    xs = s/mst2
    xt = t/mst2
    xu = u/mst2
    xmst2 = 1d0
    xmchi2 = mchi2/mst2
    xmt2 = mt2/mst2


    ! Store new (rescaled) input variables
    newInputD0 = (/ xs,xt,xmst2,xmchi2,xmt2 /)
    k1sq = 0d0
    k2sq = 0d0

    ! Check if the given input variables matches any
    ! of the cached ones
    if (.not.differs(InputVarsD0(1,:),newInputD0)) then
        cachedD0 = 1
    else if (.not.differs(InputVarsD0(2,:),newInputD0)) then
        cachedD0 = 2
    else
        cachedD0 = 0
    endif

    ! If cachedD = 0, we need to compute it and cache
    ! (we know the values for pq,p2 and p1<->p2 (t<->u) will have to be computed
    ! so we already do both and cache)
    if (cachedD0 == 0) then
        cachedD0 = 1
        call Init_cll(N,rank,'',.true.)
        call InitEvent_cll
        ! Using mode=3 computes with the DD and COLI branches and return the most precise results
        call SetMode_cll(3)
        call SetDeltaUV_cll(deltaUV) ! Remove the divergence (MSbar)
        call SetMuUV2_cll(muR2) ! Set the renormalization scale    
        ! Compute the input for the given variables
        InputVarsD0(1,:) = (/ xs,xt,xmst2,xmchi2,xmt2 /)
        call D0_cll(D0coeff,xmt2,xmt2,k1sq,k2sq,xs,xt,xmst2,xmchi2,xmst2,xmst2)
        D0coeff = D0coeff/((2*Pi)**4)
        D0coeff = D0coeff/mst2**2
      
        ! Store the result in the first entry
        OutPutD0(1) = D0coeff
        ! Compute the input changing p1<->p2 (t<->u)
        InputVarsD0(2,:) = (/ xs,xu,xmst2,xmchi2,xmt2 /)
        call D0_cll(D0coeff,xmt2,xmt2,k1sq,k2sq,xs,xu,xmst2,xmchi2,xmst2,xmst2)
        D0coeff = D0coeff/((2*Pi)**4)
        D0coeff = D0coeff/mst2**2
        ! Store result in the second entry
        OutPutD0(2) = D0coeff
    endif

    ! We can finally return the cached input
    D0coeff = OutPutD0(cachedD0)
    
end subroutine getD0IntegralOnShell
! ------------------------------------------------------------
! Define the form factors in terms of the loop functions:
! ------------------------------------------------------------

double complex function C00effFunc(p1sq,s,p2sq)

    use collier

    implicit none

    ! Invariants s=(p1+p2)**2 (gluon momentum squared), p1sq  and p2sq (top and anti-top momenta squared)
    
    double complex s, p1sq, p2sq
    integer rank
    double complex mt2,mst2,mchi2
    double precision c00renvalue,deltaUV,muR2
    double complex C00,ScalarC00ren,deltaCTR,deltaCTL
    double complex Ccoeff(0:1,0:2,0:2)
    include 'input.inc' ! include all external model parameter
    include 'coupl.inc' ! include other parameters
   
    mchi2 = MDL_MCHI**2
    mst2 = MDL_MST**2
    mt2 = MDL_MT**2
    muR2 = MDL_MST**2 ! The counter-terms were computing under this assumption 
    deltaUV = 0d0  ! deltaUV = 1/eps + log(4*Pi) - gammaE

    if (MDL_ITRI == 0d0) then
        C00effFunc = 0d0 ! Turn off coefficients
        return
    endif

    call getCIntegrals(Ccoeff,p1sq,s,p2sq,mchi2,mst2,muR2,deltaUV)
    C00 = Ccoeff(1,0,0)
    deltaCTR = MDL_DELTACTR
    deltaCTL = MDL_DELTACTL

    ! Compute renormalizable and effective C00 value:
    ! Note that:  
    ! C00eff = C00  - deltaCTL + deltaCTR
    C00effFunc = C00 + deltaCTR - deltaCTL

    if (MDL_IDEBUG > 0d0) then
        call writedebugC(s,p1sq,p2sq,Ccoeff,'C00eff')
    endif

    return 

end function


double complex function C1Func(p1sq,s,p2sq)

    use collier

    implicit none

    ! Invariants s=(p1+p2)**2 (gluon momentum squared), p1sq  and p2sq (top and anti-top momenta squared)
    
    double complex s, p1sq, p2sq
    double complex mt2,mst2,mchi2
    double precision deltaUV,muR2
    double complex Ccoeff(0:1,0:2,0:2)
    include 'input.inc' ! include all external model parameter
    include 'coupl.inc' ! include other parameters
   
    mchi2 = MDL_MCHI**2
    mst2 = MDL_MST**2
    mt2 = MDL_MT**2
    muR2 = MDL_MST**2 ! The counter-terms were computing under this assumption 
    deltaUV = 0d0  ! deltaUV = 1/eps + log(4*Pi) - gammaE

    if (MDL_ITRI == 0d0) then
        C1Func = 0d0 ! Turn off coefficients
        return
    endif

    call getCIntegrals(Ccoeff,p1sq,s,p2sq,mchi2,mst2,muR2,deltaUV)
    C1Func = Ccoeff(0,1,0)

    if (MDL_IDEBUG > 0d0) then
        call writedebugC(s,p1sq,p2sq,Ccoeff,'C1')
    endif

    return 

end function

double complex function C1FuncB(p1sq,s,p2sq)

    use collier

    implicit none

    ! Same as C1Func, but it is only used by t-t-g-g effective couplings
    ! so its contribution can be turned off using ITRIB
    
    double complex s, p1sq, p2sq
    double complex mt2,mst2,mchi2
    double precision deltaUV,muR2
    double complex Ccoeff(0:1,0:2,0:2)
    include 'input.inc' ! include all external model parameter
    include 'coupl.inc' ! include other parameters
   
    mchi2 = MDL_MCHI**2
    mst2 = MDL_MST**2
    mt2 = MDL_MT**2
    muR2 = MDL_MST**2 ! The counter-terms were computing under this assumption 
    deltaUV = 0d0  ! deltaUV = 1/eps + log(4*Pi) - gammaE

    if (MDL_ITRIB == 0d0) then
        C1FuncB = 0d0 ! Turn off coefficients
        return
    endif

    call getCIntegrals(Ccoeff,p1sq,s,p2sq,mchi2,mst2,muR2,deltaUV)
    C1FuncB = Ccoeff(0,1,0)

    if (MDL_IDEBUG > 0d0) then
        call writedebugC(s,p1sq,p2sq,Ccoeff,'C1B')
    endif

    return 

end function

double complex function C2Func(p1sq,s,p2sq)

    use collier

    implicit none

    ! Invariants s=(p1+p2)**2 (gluon momentum squared), p1sq  and p2sq (top and anti-top momenta squared)
    
    double complex s, p1sq, p2sq, p1p2
    double complex mt2,mst2,mchi2
    double precision c1value,deltaUV,muR2
    double complex Ccoeff(0:1,0:2,0:2),C2
    include 'input.inc' ! include all external model parameter
    include 'coupl.inc' ! include other parameters
   
    mchi2 = MDL_MCHI**2
    mst2 = MDL_MST**2
    mt2 = MDL_MT**2
    muR2 = MDL_MST**2 ! The counter-terms were computing under this assumption 
    deltaUV = 0d0  ! deltaUV = 1/eps + log(4*Pi) - gammaE

    if (MDL_ITRI == 0d0) then
        C2Func = 0d0 ! Turn off coefficients
        return
    endif

    call getCIntegrals(Ccoeff,p1sq,s,p2sq,mchi2,mst2,muR2,deltaUV)
    C2Func = Ccoeff(0,0,1)

    if (MDL_IDEBUG > 0d0) then
        call writedebugC(s,p1sq,p2sq,Ccoeff,'C2')
    endif

    return 

end function


double complex function C11Func(p1sq,s,p2sq)

    use collier

    implicit none

    ! Invariants s=(p1+p2)**2 (gluon momentum squared), p1sq  and p2sq (top and anti-top momenta squared)
    
    double complex s, p1sq, p2sq
    double complex mt2,mst2,mchi2
    double precision c11value,deltaUV,muR2
    double complex Ccoeff(0:1,0:2,0:2)
    include 'input.inc' ! include all external model parameter
    include 'coupl.inc' ! include other parameters
   
    mchi2 = MDL_MCHI**2
    mst2 = MDL_MST**2
    mt2 = MDL_MT**2
    muR2 = MDL_MST**2 ! The counter-terms were computing under this assumption 
    deltaUV = 0d0  ! deltaUV = 1/eps + log(4*Pi) - gammaE

    if (MDL_ITRI == 0d0) then
        C11Func = 0d0 ! Turn off coefficients
        return
    endif

    call getCIntegrals(Ccoeff,p1sq,s,p2sq,mchi2,mst2,muR2,deltaUV)
    C11Func = Ccoeff(0,2,0)

    if (MDL_IDEBUG > 0d0) then
        call writedebugC(s,p1sq,p2sq,Ccoeff,'C11')
    endif

    return  

end function

double complex function C22Func(p1sq,s,p2sq)

    use collier

    implicit none

    ! Invariants s=(p1+p2)**2 (gluon momentum squared), p1sq  and p2sq (top and anti-top momenta squared)
    
    double complex s, p1sq, p2sq, p1p2
    double complex mt2,mst2,mchi2
    double precision c11value,deltaUV,muR2
    double complex Ccoeff(0:1,0:2,0:2)
    include 'input.inc' ! include all external model parameter
    include 'coupl.inc' ! include other parameters
   
    mchi2 = MDL_MCHI**2
    mst2 = MDL_MST**2
    mt2 = MDL_MT**2
    muR2 = MDL_MST**2 ! The counter-terms were computing under this assumption 
    deltaUV = 0d0  ! deltaUV = 1/eps + log(4*Pi) - gammaE

    if (MDL_ITRI == 0d0) then
        C22Func = 0d0 ! Turn off coefficients
        return
    endif

    call getCIntegrals(Ccoeff,p1sq,s,p2sq,mchi2,mst2,muR2,deltaUV)
    C22Func = Ccoeff(0,0,2)

    if (MDL_IDEBUG > 0d0) then
        call writedebugC(s,p1sq,p2sq,Ccoeff,'C22')
    endif

    return 

end function


double complex function C12Func(p1sq,s,p2sq)

    use collier

    implicit none

    ! Invariants s=(p1+p2)**2 (gluon momentum squared), p1sq  and p2sq (top and anti-top momenta squared)
    
    double complex s, p1sq, p2sq
    double complex mt2,mst2,mchi2
    double precision c12value,deltaUV,muR2
    double complex C12
    double complex Ccoeff(0:1,0:2,0:2)
    include 'input.inc' ! include all external model parameter
    include 'coupl.inc' ! include other parameters

    mchi2 = MDL_MCHI**2
    mst2 = MDL_MST**2
    mt2 = MDL_MT**2
    muR2 = MDL_MST**2 ! The counter-terms were computing under this assumption 
    deltaUV = 0d0  ! deltaUV = 1/eps + log(4*Pi) - gammaE

    if (MDL_ITRI == 0d0) then
        C12Func = 0d0 ! Turn off coefficients
        return
    endif

    call getCIntegrals(Ccoeff,p1sq,s,p2sq,mchi2,mst2,muR2,deltaUV)
    C12Func = Ccoeff(0,1,1)

    if (MDL_IDEBUG > 0d0) then
        call writedebugC(s,p1sq,p2sq,Ccoeff,'C12')
    endif


    return 

end function


double complex function D0(s,t)

    use collier

    implicit none

    double complex s,t
    double complex mt2,mst2,mchi2
    double precision deltaUV,muR2
    double complex D0c
    double complex Dcoeff(0:1,0:3,0:3,0:3)
    include 'input.inc' ! include all external model parameter
    include 'coupl.inc' ! include other parameters
   
    mchi2 = MDL_MCHI**2
    mst2 = MDL_MST**2
    mt2 = MDL_MT**2
    muR2 = MDL_MST**2 ! The counter-terms were computing under this assumption 
    deltaUV = 0d0  ! deltaUV = 1/eps + log(4*Pi) - gammaE

    if (MDL_IBOX == 0d0) then
        D0 = 0d0
        return
    else            
        call getD0IntegralOnShell(D0c,s,t,mst2,mchi2,mt2,muR2,deltaUV) ! Use dedicated function with correct ordering
        D0 = D0c
        ! call getDIntegralsOnShell(Dcoeff,s,t,mst2,mchi2,mt2,muR2,deltaUV) ! Use generic function (wrong order of arguments)
        ! D0 = Dcoeff(0,0,0,0)
    endif
    
    ! if (MDL_IDEBUG > 0d0) then
        ! call writedebugD(s,t,mst2,mchi2,mt2,Dcoeff,'D0')
    ! endif

    return 

end function

double complex function D1(s,t)

    use collier

    implicit none

    double complex s,t
    double complex mt2,mst2,mchi2
    double precision deltaUV,muR2
    double complex Dcoeff(0:1,0:3,0:3,0:3)
    include 'input.inc' ! include all external model parameter
    include 'coupl.inc' ! include other parameters
   
    mchi2 = MDL_MCHI**2
    mst2 = MDL_MST**2
    mt2 = MDL_MT**2
    muR2 = MDL_MST**2 ! The counter-terms were computing under this assumption 
    deltaUV = 0d0  ! deltaUV = 1/eps + log(4*Pi) - gammaE

    if (MDL_IBOX == 0d0) then
        D1 = 0d0
        return
    else            
        call getDIntegralsOnShell(Dcoeff,s,t,mst2,mchi2,mt2,muR2,deltaUV)
        D1 = Dcoeff(0,1,0,0)
    endif
    
    if (MDL_IDEBUG > 0d0) then
        call writedebugD(s,t,mst2,mchi2,mt2,Dcoeff,'D1')
    endif

    return 

end function

double complex function D2(s,t)

    use collier

    implicit none

    double complex s,t
    double complex mt2,mst2,mchi2
    double precision deltaUV,muR2
    double complex Dcoeff(0:1,0:3,0:3,0:3)
    include 'input.inc' ! include all external model parameter
    include 'coupl.inc' ! include other parameters
   
    mchi2 = MDL_MCHI**2
    mst2 = MDL_MST**2
    mt2 = MDL_MT**2
    muR2 = MDL_MST**2 ! The counter-terms were computing under this assumption 
    deltaUV = 0d0  ! deltaUV = 1/eps + log(4*Pi) - gammaE

    if (MDL_IBOX == 0d0) then
        D2 = 0d0
        return
    else            
        call getDIntegralsOnShell(Dcoeff,s,t,mst2,mchi2,mt2,muR2,deltaUV)
        D2 = Dcoeff(0,0,1,0)
    endif
    
    if (MDL_IDEBUG > 0d0) then
        call writedebugD(s,t,mst2,mchi2,mt2,Dcoeff,'D2')
    endif

    return 

end function

double complex function D3(s,t)

    use collier

    implicit none

    double complex s,t
    double complex mt2,mst2,mchi2
    double precision deltaUV,muR2
    double complex Dcoeff(0:1,0:3,0:3,0:3)
    include 'input.inc' ! include all external model parameter
    include 'coupl.inc' ! include other parameters
   
    mchi2 = MDL_MCHI**2
    mst2 = MDL_MST**2
    mt2 = MDL_MT**2
    muR2 = MDL_MST**2 ! The counter-terms were computing under this assumption 
    deltaUV = 0d0  ! deltaUV = 1/eps + log(4*Pi) - gammaE

    if (MDL_IBOX == 0d0) then
        D3 = 0d0
        return
    else            
        call getDIntegralsOnShell(Dcoeff,s,t,mst2,mchi2,mt2,muR2,deltaUV)
        D3 = Dcoeff(0,0,0,1)
    endif
    
    if (MDL_IDEBUG > 0d0) then
        call writedebugD(s,t,mst2,mchi2,mt2,Dcoeff,'D3')
    endif

    return 

end function

double complex function D00(s,t)

    use collier

    implicit none

    double complex s,t
    double complex mt2,mst2,mchi2
    double precision deltaUV,muR2
    double complex Dcoeff(0:1,0:3,0:3,0:3)
    include 'input.inc' ! include all external model parameter
    include 'coupl.inc' ! include other parameters
   
    mchi2 = MDL_MCHI**2
    mst2 = MDL_MST**2
    mt2 = MDL_MT**2
    muR2 = MDL_MST**2 ! The counter-terms were computing under this assumption 
    deltaUV = 0d0  ! deltaUV = 1/eps + log(4*Pi) - gammaE

    if (MDL_IBOX == 0d0) then
        D00 = 0d0
        return
    else            
        call getDIntegralsOnShell(Dcoeff,s,t,mst2,mchi2,mt2,muR2,deltaUV)
        D00 = Dcoeff(1,0,0,0)
    endif
    
    if (MDL_IDEBUG > 0d0) then
        call writedebugD(s,t,mst2,mchi2,mt2,Dcoeff,'D00')
    endif

    return 

end function

double complex function D11(s,t)

    use collier

    implicit none

    double complex s,t
    double complex mt2,mst2,mchi2
    double precision deltaUV,muR2
    double complex Dcoeff(0:1,0:3,0:3,0:3)
    include 'input.inc' ! include all external model parameter
    include 'coupl.inc' ! include other parameters
   
    mchi2 = MDL_MCHI**2
    mst2 = MDL_MST**2
    mt2 = MDL_MT**2
    muR2 = MDL_MST**2 ! The counter-terms were computing under this assumption 
    deltaUV = 0d0  ! deltaUV = 1/eps + log(4*Pi) - gammaE

    if (MDL_IBOX == 0d0) then
        D11 = 0d0
        return
    else            
        call getDIntegralsOnShell(Dcoeff,s,t,mst2,mchi2,mt2,muR2,deltaUV)
        D11 = Dcoeff(0,2,0,0)
    endif
    
    if (MDL_IDEBUG > 0d0) then
        call writedebugD(s,t,mst2,mchi2,mt2,Dcoeff,'D11')
    endif

    return 

end function

double complex function D12(s,t)

    use collier

    implicit none

    double complex s,t
    double complex mt2,mst2,mchi2
    double precision deltaUV,muR2
    double complex Dcoeff(0:1,0:3,0:3,0:3)
    include 'input.inc' ! include all external model parameter
    include 'coupl.inc' ! include other parameters
   
    mchi2 = MDL_MCHI**2
    mst2 = MDL_MST**2
    mt2 = MDL_MT**2
    muR2 = MDL_MST**2 ! The counter-terms were computing under this assumption 
    deltaUV = 0d0  ! deltaUV = 1/eps + log(4*Pi) - gammaE

    if (MDL_IBOX == 0d0) then
        D12 = 0d0
        return
    else            
        call getDIntegralsOnShell(Dcoeff,s,t,mst2,mchi2,mt2,muR2,deltaUV)
        D12 = Dcoeff(0,1,1,0)
    endif
    
    if (MDL_IDEBUG > 0d0) then
        call writedebugD(s,t,mst2,mchi2,mt2,Dcoeff,'D12')
    endif

    return 

end function

double complex function D13(s,t)

    use collier

    implicit none

    double complex s,t
    double complex mt2,mst2,mchi2
    double precision deltaUV,muR2
    double complex Dcoeff(0:1,0:3,0:3,0:3)
    include 'input.inc' ! include all external model parameter
    include 'coupl.inc' ! include other parameters
   
    mchi2 = MDL_MCHI**2
    mst2 = MDL_MST**2
    mt2 = MDL_MT**2
    muR2 = MDL_MST**2 ! The counter-terms were computing under this assumption 
    deltaUV = 0d0  ! deltaUV = 1/eps + log(4*Pi) - gammaE

    if (MDL_IBOX == 0d0) then
        D13 = 0d0
        return
    else            
        call getDIntegralsOnShell(Dcoeff,s,t,mst2,mchi2,mt2,muR2,deltaUV)
        D13 = Dcoeff(0,1,0,1)
    endif
    
    if (MDL_IDEBUG > 0d0) then
        call writedebugD(s,t,mst2,mchi2,mt2,Dcoeff,'D13')
    endif

    return 

end function

double complex function D22(s,t)

    use collier

    implicit none

    double complex s,t
    double complex mt2,mst2,mchi2
    double precision deltaUV,muR2
    double complex Dcoeff(0:1,0:3,0:3,0:3)
    include 'input.inc' ! include all external model parameter
    include 'coupl.inc' ! include other parameters
   
    mchi2 = MDL_MCHI**2
    mst2 = MDL_MST**2
    mt2 = MDL_MT**2
    muR2 = MDL_MST**2 ! The counter-terms were computing under this assumption 
    deltaUV = 0d0  ! deltaUV = 1/eps + log(4*Pi) - gammaE

    if (MDL_IBOX == 0d0) then
        D22 = 0d0
        return
    else            
        call getDIntegralsOnShell(Dcoeff,s,t,mst2,mchi2,mt2,muR2,deltaUV)
        D22 = Dcoeff(0,0,2,0)
    endif
    
    if (MDL_IDEBUG > 0d0) then
        call writedebugD(s,t,mst2,mchi2,mt2,Dcoeff,'D22')
    endif

    return 

end function

double complex function D23(s,t)

    use collier

    implicit none

    double complex s,t
    double complex mt2,mst2,mchi2
    double precision deltaUV,muR2
    double complex Dcoeff(0:1,0:3,0:3,0:3)
    include 'input.inc' ! include all external model parameter
    include 'coupl.inc' ! include other parameters
   
    mchi2 = MDL_MCHI**2
    mst2 = MDL_MST**2
    mt2 = MDL_MT**2
    muR2 = MDL_MST**2 ! The counter-terms were computing under this assumption 
    deltaUV = 0d0  ! deltaUV = 1/eps + log(4*Pi) - gammaE

    if (MDL_IBOX == 0d0) then
        D23 = 0d0
        return
    else            
        call getDIntegralsOnShell(Dcoeff,s,t,mst2,mchi2,mt2,muR2,deltaUV)
        D23 = Dcoeff(0,0,1,1)
    endif
    
    if (MDL_IDEBUG > 0d0) then
        call writedebugD(s,t,mst2,mchi2,mt2,Dcoeff,'D23')
    endif

    return 

end function

double complex function D33(s,t)

    use collier

    implicit none

    double complex s,t
    double complex mt2,mst2,mchi2
    double precision deltaUV,muR2
    double complex Dcoeff(0:1,0:3,0:3,0:3)
    include 'input.inc' ! include all external model parameter
    include 'coupl.inc' ! include other parameters
   
    mchi2 = MDL_MCHI**2
    mst2 = MDL_MST**2
    mt2 = MDL_MT**2
    muR2 = MDL_MST**2 ! The counter-terms were computing under this assumption 
    deltaUV = 0d0  ! deltaUV = 1/eps + log(4*Pi) - gammaE

    if (MDL_IBOX == 0d0) then
        D33 = 0d0
        return
    else            
        call getDIntegralsOnShell(Dcoeff,s,t,mst2,mchi2,mt2,muR2,deltaUV)
        D33 = Dcoeff(0,0,0,2)
    endif
    
    if (MDL_IDEBUG > 0d0) then
        call writedebugD(s,t,mst2,mchi2,mt2,Dcoeff,'D33')
    endif

    return 

end function

double complex function D001(s,t)

    use collier

    implicit none

    double complex s,t
    double complex mt2,mst2,mchi2
    double precision deltaUV,muR2
    double complex Dcoeff(0:1,0:3,0:3,0:3)
    include 'input.inc' ! include all external model parameter
    include 'coupl.inc' ! include other parameters
   
    mchi2 = MDL_MCHI**2
    mst2 = MDL_MST**2
    mt2 = MDL_MT**2
    muR2 = MDL_MST**2 ! The counter-terms were computing under this assumption 
    deltaUV = 0d0  ! deltaUV = 1/eps + log(4*Pi) - gammaE

    if (MDL_IBOX == 0d0) then
        D001 = 0d0
        return
    else            
        call getDIntegralsOnShell(Dcoeff,s,t,mst2,mchi2,mt2,muR2,deltaUV)
        D001 = Dcoeff(1,1,0,0)
    endif
    
    if (MDL_IDEBUG > 0d0) then
        call writedebugD(s,t,mst2,mchi2,mt2,Dcoeff,'D001')
    endif

    return 

end function

double complex function D002(s,t)

    use collier

    implicit none

    double complex s,t
    double complex mt2,mst2,mchi2
    double precision deltaUV,muR2
    double complex Dcoeff(0:1,0:3,0:3,0:3)
    include 'input.inc' ! include all external model parameter
    include 'coupl.inc' ! include other parameters
   
    mchi2 = MDL_MCHI**2
    mst2 = MDL_MST**2
    mt2 = MDL_MT**2
    muR2 = MDL_MST**2 ! The counter-terms were computing under this assumption 
    deltaUV = 0d0  ! deltaUV = 1/eps + log(4*Pi) - gammaE

    if (MDL_IBOX == 0d0) then
        D002 = 0d0
        return
    else            
        call getDIntegralsOnShell(Dcoeff,s,t,mst2,mchi2,mt2,muR2,deltaUV)
        D002 = Dcoeff(1,0,1,0)
    endif
    
    if (MDL_IDEBUG > 0d0) then
        call writedebugD(s,t,mst2,mchi2,mt2,Dcoeff,'D002')
    endif

    return 

end function

double complex function D003(s,t)

    use collier

    implicit none

    double complex s,t
    double complex mt2,mst2,mchi2
    double precision deltaUV,muR2
    double complex Dcoeff(0:1,0:3,0:3,0:3)
    include 'input.inc' ! include all external model parameter
    include 'coupl.inc' ! include other parameters
   
    mchi2 = MDL_MCHI**2
    mst2 = MDL_MST**2
    mt2 = MDL_MT**2
    muR2 = MDL_MST**2 ! The counter-terms were computing under this assumption 
    deltaUV = 0d0  ! deltaUV = 1/eps + log(4*Pi) - gammaE

    if (MDL_IBOX == 0d0) then
        D003 = 0d0
        return
    else            
        call getDIntegralsOnShell(Dcoeff,s,t,mst2,mchi2,mt2,muR2,deltaUV)
        D003 = Dcoeff(1,0,0,1)
    endif
    
    if (MDL_IDEBUG > 0d0) then
        call writedebugD(s,t,mst2,mchi2,mt2,Dcoeff,'D003')
    endif

    return 

end function

double complex function D111(s,t)

    use collier

    implicit none

    double complex s,t
    double complex mt2,mst2,mchi2
    double precision deltaUV,muR2
    double complex Dcoeff(0:1,0:3,0:3,0:3)
    include 'input.inc' ! include all external model parameter
    include 'coupl.inc' ! include other parameters
   
    mchi2 = MDL_MCHI**2
    mst2 = MDL_MST**2
    mt2 = MDL_MT**2
    muR2 = MDL_MST**2 ! The counter-terms were computing under this assumption 
    deltaUV = 0d0  ! deltaUV = 1/eps + log(4*Pi) - gammaE

    if (MDL_IBOX == 0d0) then
        D111 = 0d0
        return
    else            
        call getDIntegralsOnShell(Dcoeff,s,t,mst2,mchi2,mt2,muR2,deltaUV)
        D111 = Dcoeff(0,3,0,0)
    endif
    
    if (MDL_IDEBUG > 0d0) then
        call writedebugD(s,t,mst2,mchi2,mt2,Dcoeff,'D111')
    endif

    return 

end function

double complex function D112(s,t)

    use collier

    implicit none

    double complex s,t
    double complex mt2,mst2,mchi2
    double precision deltaUV,muR2
    double complex Dcoeff(0:1,0:3,0:3,0:3)
    include 'input.inc' ! include all external model parameter
    include 'coupl.inc' ! include other parameters
   
    mchi2 = MDL_MCHI**2
    mst2 = MDL_MST**2
    mt2 = MDL_MT**2
    muR2 = MDL_MST**2 ! The counter-terms were computing under this assumption 
    deltaUV = 0d0  ! deltaUV = 1/eps + log(4*Pi) - gammaE

    if (MDL_IBOX == 0d0) then
        D112 = 0d0
        return
    else            
        call getDIntegralsOnShell(Dcoeff,s,t,mst2,mchi2,mt2,muR2,deltaUV)
        D112 = Dcoeff(0,2,1,0)
    endif
    
    if (MDL_IDEBUG > 0d0) then
        call writedebugD(s,t,mst2,mchi2,mt2,Dcoeff,'D112')
    endif

    return 

end function

double complex function D113(s,t)

    use collier

    implicit none

    double complex s,t
    double complex mt2,mst2,mchi2
    double precision deltaUV,muR2
    double complex Dcoeff(0:1,0:3,0:3,0:3)
    include 'input.inc' ! include all external model parameter
    include 'coupl.inc' ! include other parameters
   
    mchi2 = MDL_MCHI**2
    mst2 = MDL_MST**2
    mt2 = MDL_MT**2
    muR2 = MDL_MST**2 ! The counter-terms were computing under this assumption 
    deltaUV = 0d0  ! deltaUV = 1/eps + log(4*Pi) - gammaE

    if (MDL_IBOX == 0d0) then
        D113 = 0d0
        return
    else            
        call getDIntegralsOnShell(Dcoeff,s,t,mst2,mchi2,mt2,muR2,deltaUV)
        D113 = Dcoeff(0,2,0,1)
    endif
    
    if (MDL_IDEBUG > 0d0) then
        call writedebugD(s,t,mst2,mchi2,mt2,Dcoeff,'D113')
    endif

    return 

end function

double complex function D122(s,t)

    use collier

    implicit none

    double complex s,t
    double complex mt2,mst2,mchi2
    double precision deltaUV,muR2
    double complex Dcoeff(0:1,0:3,0:3,0:3)
    include 'input.inc' ! include all external model parameter
    include 'coupl.inc' ! include other parameters
   
    mchi2 = MDL_MCHI**2
    mst2 = MDL_MST**2
    mt2 = MDL_MT**2
    muR2 = MDL_MST**2 ! The counter-terms were computing under this assumption 
    deltaUV = 0d0  ! deltaUV = 1/eps + log(4*Pi) - gammaE

    if (MDL_IBOX == 0d0) then
        D122 = 0d0
        return
    else            
        call getDIntegralsOnShell(Dcoeff,s,t,mst2,mchi2,mt2,muR2,deltaUV)
        D122 = Dcoeff(0,1,2,0)
    endif
    
    if (MDL_IDEBUG > 0d0) then
        call writedebugD(s,t,mst2,mchi2,mt2,Dcoeff,'D122')
    endif

    return 

end function

double complex function D123(s,t)

    use collier

    implicit none

    double complex s,t
    double complex mt2,mst2,mchi2
    double precision deltaUV,muR2
    double complex Dcoeff(0:1,0:3,0:3,0:3)
    include 'input.inc' ! include all external model parameter
    include 'coupl.inc' ! include other parameters
   
    mchi2 = MDL_MCHI**2
    mst2 = MDL_MST**2
    mt2 = MDL_MT**2
    muR2 = MDL_MST**2 ! The counter-terms were computing under this assumption 
    deltaUV = 0d0  ! deltaUV = 1/eps + log(4*Pi) - gammaE

    if (MDL_IBOX == 0d0) then
        D123 = 0d0
        return
    else            
        call getDIntegralsOnShell(Dcoeff,s,t,mst2,mchi2,mt2,muR2,deltaUV)
        D123 = Dcoeff(0,1,1,1)
    endif
    
    if (MDL_IDEBUG > 0d0) then
        call writedebugD(s,t,mst2,mchi2,mt2,Dcoeff,'D123')
    endif

    return 

end function

double complex function D133(s,t)

    use collier

    implicit none

    double complex s,t
    double complex mt2,mst2,mchi2
    double precision deltaUV,muR2
    double complex Dcoeff(0:1,0:3,0:3,0:3)
    include 'input.inc' ! include all external model parameter
    include 'coupl.inc' ! include other parameters
   
    mchi2 = MDL_MCHI**2
    mst2 = MDL_MST**2
    mt2 = MDL_MT**2
    muR2 = MDL_MST**2 ! The counter-terms were computing under this assumption 
    deltaUV = 0d0  ! deltaUV = 1/eps + log(4*Pi) - gammaE

    if (MDL_IBOX == 0d0) then
        D133 = 0d0
        return
    else            
        call getDIntegralsOnShell(Dcoeff,s,t,mst2,mchi2,mt2,muR2,deltaUV)
        D133 = Dcoeff(0,1,0,2)
    endif
    
    if (MDL_IDEBUG > 0d0) then
        call writedebugD(s,t,mst2,mchi2,mt2,Dcoeff,'D133')
    endif

    return 

end function

double complex function D222(s,t)

    use collier

    implicit none

    double complex s,t
    double complex mt2,mst2,mchi2
    double precision deltaUV,muR2
    double complex Dcoeff(0:1,0:3,0:3,0:3)
    include 'input.inc' ! include all external model parameter
    include 'coupl.inc' ! include other parameters
   
    mchi2 = MDL_MCHI**2
    mst2 = MDL_MST**2
    mt2 = MDL_MT**2
    muR2 = MDL_MST**2 ! The counter-terms were computing under this assumption 
    deltaUV = 0d0  ! deltaUV = 1/eps + log(4*Pi) - gammaE

    if (MDL_IBOX == 0d0) then
        D222 = 0d0
        return
    else            
        call getDIntegralsOnShell(Dcoeff,s,t,mst2,mchi2,mt2,muR2,deltaUV)
        D222 = Dcoeff(0,0,3,0)
    endif
    
    if (MDL_IDEBUG > 0d0) then
        call writedebugD(s,t,mst2,mchi2,mt2,Dcoeff,'D222')
    endif

    return 

end function

double complex function D223(s,t)

    use collier

    implicit none

    double complex s,t
    double complex mt2,mst2,mchi2
    double precision deltaUV,muR2
    double complex Dcoeff(0:1,0:3,0:3,0:3)
    include 'input.inc' ! include all external model parameter
    include 'coupl.inc' ! include other parameters
   
    mchi2 = MDL_MCHI**2
    mst2 = MDL_MST**2
    mt2 = MDL_MT**2
    muR2 = MDL_MST**2 ! The counter-terms were computing under this assumption 
    deltaUV = 0d0  ! deltaUV = 1/eps + log(4*Pi) - gammaE

    if (MDL_IBOX == 0d0) then
        D223 = 0d0
        return
    else            
        call getDIntegralsOnShell(Dcoeff,s,t,mst2,mchi2,mt2,muR2,deltaUV)
        D223 = Dcoeff(0,0,2,1)
    endif
    
    if (MDL_IDEBUG > 0d0) then
        call writedebugD(s,t,mst2,mchi2,mt2,Dcoeff,'D223')
    endif

    return 

end function

double complex function D233(s,t)

    use collier

    implicit none

    double complex s,t
    double complex mt2,mst2,mchi2
    double precision deltaUV,muR2
    double complex Dcoeff(0:1,0:3,0:3,0:3)
    include 'input.inc' ! include all external model parameter
    include 'coupl.inc' ! include other parameters
   
    mchi2 = MDL_MCHI**2
    mst2 = MDL_MST**2
    mt2 = MDL_MT**2
    muR2 = MDL_MST**2 ! The counter-terms were computing under this assumption 
    deltaUV = 0d0  ! deltaUV = 1/eps + log(4*Pi) - gammaE

    if (MDL_IBOX == 0d0) then
        D233 = 0d0
        return
    else            
        call getDIntegralsOnShell(Dcoeff,s,t,mst2,mchi2,mt2,muR2,deltaUV)
        D233 = Dcoeff(0,0,1,2)
    endif
    
    if (MDL_IDEBUG > 0d0) then
        call writedebugD(s,t,mst2,mchi2,mt2,Dcoeff,'D233')
    endif

    return 

end function

double complex function D333(s,t)

    use collier

    implicit none

    double complex s,t
    double complex mt2,mst2,mchi2
    double precision deltaUV,muR2
    double complex Dcoeff(0:1,0:3,0:3,0:3)
    include 'input.inc' ! include all external model parameter
    include 'coupl.inc' ! include other parameters
   
    mchi2 = MDL_MCHI**2
    mst2 = MDL_MST**2
    mt2 = MDL_MT**2
    muR2 = MDL_MST**2 ! The counter-terms were computing under this assumption 
    deltaUV = 0d0  ! deltaUV = 1/eps + log(4*Pi) - gammaE

    if (MDL_IBOX == 0d0) then
        D333 = 0d0
        return
    else
        call getDIntegralsOnShell(Dcoeff,s,t,mst2,mchi2,mt2,muR2,deltaUV)
        D333 = Dcoeff(0,0,0,3)
    endif
    
    if (MDL_IDEBUG > 0d0) then
        call writedebugD(s,t,mst2,mchi2,mt2,Dcoeff,'D333')
    endif

    return 

end function


double complex function ab1(s,t)

    use collier

    implicit none

    double complex s,t
    double complex mt2,mst2,mchi2,mt
    double precision deltaS,deltaSp
    double precision deltaUV,muR2
    double complex ab
    double precision sCheck
    include 'input.inc' ! include all external model parameter
    include 'coupl.inc' ! include other parameters
   
    mchi2 = MDL_MCHI**2
    mst2 = MDL_MST**2
    mt = MDL_MT
    mt2 = MDL_MT**2
    muR2 = MDL_MST**2 ! The counter-terms were computing under this assumption 
    deltaUV = 0d0  ! deltaUV = 1/eps + log(4*Pi) - gammaE
    deltaS = MDL_DELTAS ! Counter-terms for the self-energy corrections
    deltaSp = MDL_DELTASP ! Counter-terms for the self-energy corrections

    if (MDL_ISELF == 0d0) then
        ab1 = 0d0 ! Turn off coefficients
        return
    endif


    ! Check if t = MT^2 (possible divergent terms, which cancel out)
    sCheck = abs(real(mt2)-real(t))/real(mt2)
    if (sCheck.lt.1d-5) then
        ab1 = 0d0
        return
    endif

    ! Compute the relevant combination of A0 and B0 integrals:
    call getABIntegral(ab,s,t,mt2,mchi2,mst2,muR2,deltaUV)
    ! Compute the coefficient including the counter-terms
    ab1 = mt*(2*deltaS*mt + 2*deltaSp*t - ab)/(2*(mt2-t)**2)

    if (MDL_IDEBUG > 0d0) then
        call writedebugAB(s,t,mst2,mchi2,mt2,ab,ab1,'ab1')
    endif


    return 

end function

double complex function ab2(s,t)

    use collier

    implicit none

    double complex s,t
    double complex mt2,mst2,mchi2,mt
    double precision deltaS,deltaSp
    double precision deltaUV,muR2
    double complex ab
    double precision sCheck
    include 'input.inc' ! include all external model parameter
    include 'coupl.inc' ! include other parameters
   
    mchi2 = MDL_MCHI**2
    mst2 = MDL_MST**2
    mt = MDL_MT
    mt2 = MDL_MT**2
    muR2 = MDL_MST**2 ! The counter-terms were computing under this assumption 
    deltaUV = 0d0  ! deltaUV = 1/eps + log(4*Pi) - gammaE
    deltaS = MDL_DELTAS ! Counter-terms for the self-energy corrections
    deltaSp = MDL_DELTASP ! Counter-terms for the self-energy corrections

    if (MDL_ISELF == 0d0) then
        ab2 = 0d0 ! Turn off coefficients
        return
    endif


    ! Check if t = MT^2 (possible divergent terms, which cancel out)
    sCheck = abs(real(mt2)-real(t))/real(mt2)
    if (sCheck.lt.1d-5) then
        ab2 = 0d0
        return
    endif

    ! Compute the relevant combination of A0 and B0 integrals:
    call getABIntegral(ab,s,t,mt2,mchi2,mst2,muR2,deltaUV)
    ! Compute the coefficient including the counter-terms
    ab2 = (2*t*(2*deltaS*mt2 - t*deltaS + deltaSp*mt**3) - ab*mt**3)/(2.*t*mt*(mt2 - t)**2)

    if (MDL_IDEBUG > 0d0) then
        call writedebugAB(s,t,mst2,mchi2,mt2,ab,ab2,'ab2')
    endif

    return 

end function

double complex function ab3(s,t)

    use collier

    implicit none

    double complex s,t
    double complex mt2,mst2,mchi2,mt
    double precision deltaS,deltaSp
    double precision deltaUV,muR2
    double complex ab
    double precision sCheck
    include 'input.inc' ! include all external model parameter
    include 'coupl.inc' ! include other parameters
   
    mchi2 = MDL_MCHI**2
    mst2 = MDL_MST**2
    mt = MDL_MT
    mt2 = MDL_MT**2
    muR2 = MDL_MST**2 ! The counter-terms were computing under this assumption 
    deltaUV = 0d0  ! deltaUV = 1/eps + log(4*Pi) - gammaE
    deltaS = MDL_DELTAS ! Counter-terms for the self-energy corrections
    deltaSp = MDL_DELTASP ! Counter-terms for the self-energy corrections

    if (MDL_ISELF == 0d0) then
        ab3 = 0d0 ! Turn off coefficients
        return
    endif


    ! Check if t = MT^2 (possible divergent terms, which cancel out)
    sCheck = abs(real(mt2)-real(t))/real(mt2)
    if (sCheck.lt.1d-5) then
        ab3 = 0d0
        return
    endif

    ! Compute the relevant combination of A0 and B0 integrals:
    call getABIntegral(ab,s,t,mt2,mchi2,mst2,muR2,deltaUV)
    ! Compute the coefficient including the counter-terms
    ab3 = (2*t*(deltaS + mt*deltaSp) - mt*ab)/(2.*mt*t*(mt2 - t))

    if (MDL_IDEBUG > 0d0) then
        call writedebugAB(s,t,mst2,mchi2,mt2,ab,ab3,'ab3')
    endif


    return 

end function

subroutine writedebugC(s,p1sq,p2sq,Ccoeff,header)

    implicit none
   
    double complex s,p1sq,p2sq
    double complex Ccoeff(0:1,0:2,0:2)
    character(len=99) :: fname
    character(len=*) :: header
    character(len=*) fmt1,fmt10
    parameter (fmt1 = '(A13,3(es11.3,SP,es9.1,A2))')
    parameter (fmt10 = '(A6,es12.4,SP,es12.4,A2)')

    fname='myLogC.log'
    open(unit=51,file=trim(fname),action='WRITE',position='APPEND',status='unknown')
    write(51,*) '------------ ',trim(header),': -------------------------'
    write (51,fmt1) 's,p1sq,p2sq = ',s,'*i',p1sq,'*i',p2sq,'*i'
    write (51,fmt10) 'C00 = ',Ccoeff(1,0,0),'*i'
    write (51,fmt10) 'C1 = ',Ccoeff(0,1,0),'*i'
    write (51,fmt10) 'C2 = ',Ccoeff(0,0,1),'*i'
    write (51,fmt10) 'C11 = ',Ccoeff(0,2,0),'*i'
    write (51,fmt10) 'C12 = ',Ccoeff(0,1,1),'*i'
    write (51,fmt10) 'C22 = ',Ccoeff(0,0,2),'*i'
    write(51,*) '-------------------------------------'
    write(51,*)
    close(51)
    
end subroutine writedebugC

subroutine writedebugD(s,t,mst2,mchi2,mt2,Dcoeff,header)

    implicit none
   
    double complex s,t,u
    double complex mst2,mchi2,mt2
    double complex Dcoeff(0:1,0:3,0:3,0:3)
    character(len=99) :: fname
    character(len=*) :: header
    character(len=*) fmt1,fmt10,fmt2
    parameter (fmt1 = '(A22,3(es11.3,SP,es9.1,A2))')
    parameter (fmt2 = '(A13,3(es11.3,SP,es9.1,A2))')
    parameter (fmt10 = '(A6,es12.4,SP,es12.4,A2)')

    u = -(s+t) + 2*mt2

    fname='myLogD.log'
    open(unit=52,file=trim(fname),action='WRITE',position='APPEND',status='unknown')
    write(52,*) '------------ ',trim(header),': -------------------------'
    write (52, fmt2) 'mst,mchi,mt = ',CDSQRT(mst2),'*i',CDSQRT(mchi2),'*i',CDSQRT(mt2),'*i'
    write (52,fmt1) 's,t,u = ',s,'*i',t,'*i',u,'*i'
    write (52,fmt10) 'D0 = ',Dcoeff(0,0,0,0),'*i'
    write (52,fmt10) 'D1 = ',Dcoeff(0,1,0,0),'*i'
    write (52,fmt10) 'D2 = ',Dcoeff(0,0,1,0),'*i'
    write (52,fmt10) 'D3 = ',Dcoeff(0,0,0,1),'*i'
    write (52,fmt10) 'D00 = ',Dcoeff(1,0,0,0),'*i'
    write (52,fmt10) 'D11 = ',Dcoeff(0,2,0,0),'*i'
    write (52,fmt10) 'D12 = ',Dcoeff(0,1,1,0),'*i'
    write (52,fmt10) 'D13 = ',Dcoeff(0,1,0,1),'*i'
    write (52,fmt10) 'D22 = ',Dcoeff(0,0,2,0),'*i'
    write (52,fmt10) 'D23 = ',Dcoeff(0,0,1,1),'*i'
    write (52,fmt10) 'D33 = ',Dcoeff(0,0,0,2),'*i'
    write (52,fmt10) 'D001 = ',Dcoeff(1,1,0,0),'*i'
    write (52,fmt10) 'D002 = ',Dcoeff(1,0,1,0),'*i'
    write (52,fmt10) 'D003 = ',Dcoeff(1,0,0,1),'*i'
    write (52,fmt10) 'D111 = ',Dcoeff(0,3,0,0),'*i'
    write (52,fmt10) 'D112 = ',Dcoeff(0,2,1,0),'*i'
    write (52,fmt10) 'D113 = ',Dcoeff(0,2,0,1),'*i'
    write (52,fmt10) 'D122 = ',Dcoeff(0,1,2,0),'*i'
    write (52,fmt10) 'D123 = ',Dcoeff(0,1,1,1),'*i'
    write (52,fmt10) 'D133 = ',Dcoeff(0,1,0,2),'*i'
    write (52,fmt10) 'D222 = ',Dcoeff(0,0,3,0),'*i'
    write (52,fmt10) 'D223 = ',Dcoeff(0,0,2,1),'*i'
    write (52,fmt10) 'D233 = ',Dcoeff(0,0,1,2),'*i'
    write (52,fmt10) 'D333 = ',Dcoeff(0,0,0,3),'*i'
    write(52,*) '-------------------------------------'
    write(52,*)
    close(52)
    
end subroutine writedebugD

subroutine writedebugAB(s,t,mst2,mchi2,mt2,ab,abF,header)

    implicit none
   
    double complex s,t,u
    double complex mst2,mchi2,mt2
    double complex ab,abF
    character(len=99) :: fname
    character(len=*) :: header
    character(len=*) fmt1,fmt10,fmt2
    parameter (fmt1 = '(A22,3(es11.3,SP,es9.1,A2))')
    parameter (fmt2 = '(A13,3(es11.3,SP,es9.1,A2))')
    parameter (fmt10 = '(A6,es12.4,SP,es12.4,A2)')

    u = -(s+t) + 2*mt2

    fname='myLogAB.log'
    open(unit=53,file=trim(fname),action='WRITE',position='APPEND',status='unknown')
    write(53,*) '------------ ',trim(header),': -------------------------'
    write (53, fmt2) 'mst,mchi,mt = ',CDSQRT(mst2),'*i',CDSQRT(mchi2),'*i',CDSQRT(mt2),'*i'
    write (53,fmt1) 's,t,u = ',s,'*i',t,'*i',u,'*i'
    write (53,fmt10) 'ab = ',ab,'*i'
    write (53,fmt10) 'abF = ',abF,'*i'
    write(53,*) '-------------------------------------'
    write(53,*)
    close(53)
    
end subroutine writedebugAB


logical function differs(oldVars,newVars)

  implicit none

  double complex oldVars(0:4),newVars(0:4)
  double complex vold,vnew
  double precision diff_real, diff_imag
  integer ii

  differs = .false.
  do ii=0,size(oldVars)-1
    vold = oldVars(ii)
    vnew = newVars(ii)
    if (vold == vnew) then
      continue
    endif
    diff_real = DSQRT((real(vold)-real(vnew))**2/(real(vold)**2))
    diff_imag = DSQRT((aimag(vold)-aimag(vnew))**2/(aimag(vold)**2))
    if (diff_real > 1d-4 .or. diff_imag > 1d-4) then
      differs = .true.
      exit
    endif
  enddo  

  return
end function differs

subroutine setSmallToZero(vars,vmin)

  implicit none

  double complex vars(0:4)
  double precision vmin
  integer ii

  do ii=0,size(vars)-1
    if (abs(vars(ii)) < vmin) then
        vars(ii) = 0d0
    endif
  enddo

end subroutine setSmallToZero  
