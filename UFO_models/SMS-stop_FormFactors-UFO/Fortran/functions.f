
!
! Required Loop integrals for the UFO model with form factors:
!
! C00h(p1sq,p3sq,p2sq) = C00(p1sq,p3sq,p2sq,mChi^2,mST^2,mST^2) + (1/2)*B1(MT^2,mChi^2,mST^2))
! pB1h(psq) = (B1(psq,mChi^2,mST^2)-B1(MT^2,mChi^2,mST^2))/(psq-MT^2)
! reDB1 = DB1(MT^2,mChi^2,mST^2) (this is momentum independent and is needed for the counter-term)
! C1(p1sq,p3sq,p2sq) = C1(p1sq,p3sq,p2sq,mChi^2,mST^2,mST^2)
! C2(p1sq,p3sq,p2sq) = C2(p1sq,p3sq,p2sq,mChi^2,mST^2,mST^2)
! C11(p1sq,p3sq,p2sq) = C11(p1sq,p3sq,p2sq,mChi^2,mST^2,mST^2)
! C12(p1sq,p3sq,p2sq) = C12(p1sq,p3sq,p2sq,mChi^2,mST^2,mST^2)
! C22(p1sq,p3sq,p2sq) = C22(p1sq,p3sq,p2sq,mChi^2,mST^2,mST^2)

      module collier_cache_mod

        implicit none

        integer, parameter :: dp = kind(1.0d0)
        real(dp), parameter :: default_rtol = 1d-4
        real(dp), parameter :: default_atol = 1d-12

        type :: ct_cache_t
                logical :: init = .false.
                complex(dp) :: input(5) = (0d0,0d0)
                complex(dp) :: b1fix = (0d0,0d0)
                complex(dp) :: db1fix = (0d0,0d0)
        end type ct_cache_t

        type :: b1_cache_t
                logical :: init = .false.
                complex(dp) :: input(5) = (0d0,0d0)
                complex(dp) :: b1 = (0d0,0d0)
        end type b1_cache_t

        type :: c_cache_t
                logical :: init = .false.
                complex(dp) :: input(7) = (0d0,0d0)
                complex(dp) :: cints(0:2,0:2) = (0d0,0d0)
        end type c_cache_t

        type :: d_cache_t
            logical :: valid(2) = .false.
            complex(dp) :: input(2,7) = (0d0,0d0)
            complex(dp) :: dcoeff(2,0:1,0:3,0:3,0:3) = (0d0,0d0)
        end type d_cache_t

        type :: d0_cache_t
            logical :: valid(2) = .false.
            complex(dp) :: input(2,7) = (0d0,0d0)
            complex(dp) :: d0(2) = (0d0,0d0)
        end type d0_cache_t

        type(ct_cache_t), save :: ct_cache
        type(b1_cache_t), save :: b1_cache
        type(c_cache_t), save :: c_cache
        type(d_cache_t), save :: d_cache
        type(d0_cache_t), save :: d0_cache

      contains

        subroutine set_small_to_zero(vars,vmin)

            implicit none

            complex(dp), intent(inout) :: vars(:)
            real(dp), intent(in) :: vmin
            integer :: ii

            do ii=1,size(vars)
                if (abs(vars(ii)) < vmin) then
                        vars(ii) = (0d0,0d0)
                endif
            enddo

        end subroutine set_small_to_zero

        logical function differs(oldVars,newVars,rtol,atol)

            implicit none

            complex(dp), intent(in) :: oldVars(:),newVars(:)
            real(dp), intent(in), optional :: rtol,atol
            real(dp) :: tol_rel,tol_abs,scale
            integer :: ii

            if (size(oldVars) /= size(newVars)) then
                differs = .true.
                return
            endif

            tol_rel = default_rtol
            tol_abs = default_atol
            if (present(rtol)) tol_rel = rtol
            if (present(atol)) tol_abs = atol

            differs = .false.
            do ii=1,size(oldVars)
                scale = max(abs(oldVars(ii)),abs(newVars(ii)))
                if (abs(oldVars(ii)-newVars(ii))
     &              > (tol_abs + tol_rel*scale)) then
                    differs = .true.
                    exit
                endif
            enddo

        end function differs

      end module collier_cache_mod

      subroutine ComputeCTParameters(b1Fix,db1Fix,mt2,mchi2,mst2,
     &                               muR2,deltaUV)

      ! Compute the integrals required by the counter-terms. Since these only needed to be
      ! computed once, we can always cache the result

      use collier
      use collier_cache_mod, only: dp, ct_cache,
     &     set_small_to_zero, differs

      implicit none
    
      double complex mt2 
      double complex mchi2,mst2
      double precision muR2,deltaUV
      integer N,rank
      double precision Pi
      parameter  (Pi=3.141592653589793D0)

      ! Internal cache for storing the results of the B integrals
      ! and avoiding duplicated calculations
      double complex b1Fix,db1Fix
      double complex newInputCT(1:5)

      N = 2
      rank = 1
    
      newInputCT = (/ mt2,mchi2,mst2,
     &     cmplx(muR2,0d0,kind=dp),cmplx(deltaUV,0d0,kind=dp) /)
      call set_small_to_zero(newInputCT,1d-5)

      ! If first time, or if setup changed, compute and cache
      if ((.not.ct_cache%init)
     &    .or.differs(ct_cache%input,newInputCT)) then
        ct_cache%init = .true.
        ct_cache%input = newInputCT
        call Init_cll(N,rank,'',.true.)
        call InitEvent_cll
        ! Using mode=3 computes with the DD and COLI branches and return the most precise results
        call SetMode_cll(3) 
        call SetDeltaUV_cll(deltaUV) ! Remove the divergence (MSbar)
        call SetMuUV2_cll(muR2) ! Set the renormalization scale    
        call B1_cll(ct_cache%b1fix,mt2,mchi2,mst2)
        ct_cache%b1fix = ct_cache%b1fix/((2*Pi)**4)
        call DB1_cll(ct_cache%db1fix,mt2,mchi2,mst2)
        ct_cache%db1fix = ct_cache%db1fix/((2*Pi)**4)
      endif

      ! Set the input variables to the computed values
      b1Fix = ct_cache%b1fix
      db1Fix = ct_cache%db1fix

      end subroutine ComputeCTParameters

      subroutine ComputeB1(b1,psq,mchi2,mst2,muR2,deltaUV)

      ! Compute the B1 integral and its derivative with respect to the external momentum squared (psq)
      ! and cache the result.

      use collier
      use collier_cache_mod, only: dp, b1_cache,
     &     set_small_to_zero, differs

      implicit none
    
      double complex psq
      double complex mchi2,mst2
      double precision muR2,deltaUV
      integer N,rank
      double precision Pi
      parameter  (Pi=3.141592653589793D0)

      double complex newInputB1(1:5)

      ! Internal cache for storing the results of the B integral
      double complex b1
      logical useCache


      N = 2
      rank = 1

      ! Store new input variables
      newInputB1 = (/ psq,mchi2,mst2,
     &     cmplx(muR2,0d0,kind=dp),cmplx(deltaUV,0d0,kind=dp) /)
      ! Set to zero small variable values
      call set_small_to_zero(newInputB1,1d-5)
      psq = newInputB1(1)
      mchi2 = newInputB1(2)
      mst2 = newInputB1(3)

      ! Check if the given input variables matches and
      ! if the cache has been initialized
      if (b1_cache%init)
     &    .and.(.not.differs(b1_cache%input,newInputB1)) then
        useCache = .true.
      else
        useCache = .false.
        ! Store the variables for caching
        b1_cache%input = newInputB1
      endif
    
      ! If useCache = .false., we need to compute it and cache
      if (.not.useCache) then
        b1_cache%init = .true.
        useCache = .true.
        call Init_cll(N,rank,'',.true.)
        call InitEvent_cll
        ! Using mode=3 computes with the DD and COLI branches and return the most precise results
        call SetMode_cll(3) 
        call SetDeltaUV_cll(deltaUV) ! Remove the divergence (MSbar)
        call SetMuUV2_cll(muR2) ! Set the renormalization scale    
        call B1_cll(b1_cache%b1,psq,mchi2,mst2)
        b1_cache%b1 = b1_cache%b1/((2*Pi)**4)
      endif

      b1 = b1_cache%b1

      end subroutine ComputeB1

! ------------------------------------------------------------
! Directly uses COLLIER to compute all needed integrals
! ------------------------------------------------------------
!
!               p21               
!                |                
!                |                
!               / |               
!              /   |              
!       m12   /1   2\   m22       
!            /       |            
!           /    0    |           
! p10  ---------------------  p20 
!               m02               
!
! m02,m12,m22 -> masses squared
! p10 = p1^2, p20 = p2^2, p21 = p3^2 = s 

! THE CORRECT ORDERING OF THE ARGUMENTS SHOULD BE p1sq,s,p2sq TO MATCH THE LOOP INTEGRALS
      subroutine getCIntegrals(CInts,p1sq,s,p2sq,mchi2,mst2,
     &                         muR2,deltaUV)

      ! Return the 3-point integrals. Note that the normalization includes the 1/(2*pi)^4 factor!

      use collier
      use collier_cache_mod, only: dp, c_cache,
     &     set_small_to_zero, differs

      implicit none

      ! Invariants s=(p1+p2)**2 (gluon momentum squared), p1sq  and p2sq (top and anti-top momenta squared)
    
      double complex s, p1sq, p2sq 
      double complex mchi2,mst2
      double precision muR2,deltaUV
      double complex CInts(0:2,0:2),CIntsUV(0:1,0:2,0:2)
      integer N,rank
      double precision Pi
      parameter  (Pi=3.141592653589793D0)

      double complex newInputC(1:7)

      ! Internal cache for storing the results of the C integrals
      ! and avoiding duplicated calculations
      logical useCache

      N = 3 ! Maximum number for loop (3-point function)
      rank = 2 ! Maximum rank for loop (=N)

      ! Store new input variables
      newInputC = (/ p1sq,s,p2sq,mchi2,mst2,
     &     cmplx(muR2,0d0,kind=dp),cmplx(deltaUV,0d0,kind=dp) /)
      ! Set to zero small variable values
      call set_small_to_zero(newInputC,1d-5)
      p1sq = newInputC(1)
      s = newInputC(2)
      p2sq = newInputC(3)
      mchi2 = newInputC(4)
      mst2 = newInputC(5)

      ! Check if the given input variables matches any
      ! of the cached ones
      if (c_cache%init).and.(.not.differs(c_cache%input,newInputC)) then
        useCache = .true.
      else 
        useCache = .false.
      endif
    
      ! If useCached = 0, we need to compute it and cache
      if (.not.useCache) then
        c_cache%init = .true.
        call Init_cll(N,rank,'',.true.)
        call InitEvent_cll
        ! Using mode=3 computes with the DD and COLI branches and return the most precise results
        call SetMode_cll(3) 
        call SetDeltaUV_cll(deltaUV) ! Remove the divergence (MSbar)
        call SetMuUV2_cll(muR2) ! Set the renormalization scale    
        ! Compute the input for the given variables
        c_cache%input = newInputC
          call C_cll(c_cache%cints,CIntsUV,p1sq,s,p2sq,
     &      mchi2,mst2,mst2,rank)
        c_cache%cints = c_cache%cints/((2*Pi)**4)
      endif

      ! We can finally return the cached input
      CInts = c_cache%cints
    
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

      subroutine getDIntegralsOnShell(Dcoeff,s,t,mst2,mchi2,mt2,
     &                                muR2,deltaUV)

      ! Return the 4-point tensor coefficients for external on-shell legs.
      ! The cache stores both (t,u) variants since they are usually evaluated together.

      use collier
      use collier_cache_mod, only: dp, d_cache,
     &     set_small_to_zero, differs

      implicit none

      double complex k1sq,k2sq
      double complex s,t,u,mchi2,mst2,mt2
      double complex xs,xt,xu,xmchi2,xmst2,xmt2
      double precision muR2,deltaUV
      double complex Dcoeff(0:1,0:3,0:3,0:3),Dcoeffuv(0:1,0:3,0:3,0:3)
      integer N,rank,i,j,k,cacheIdx
      double precision Pi
      parameter  (Pi=3.141592653589793D0)

      double complex newInputD(1:7)
      double complex newInputDSwap(1:7)

      N = 4
      rank = 3

      newInputD(1:5) = (/ s,t,mst2,mchi2,mt2 /)
      newInputD(6:7) = (/ cmplx(muR2,0d0,kind=dp),
     &                   cmplx(deltaUV,0d0,kind=dp) /)
      call set_small_to_zero(newInputD,1d-5)
      s = newInputD(1)
      t = newInputD(2)
      mst2 = newInputD(3)
      mchi2 = newInputD(4)
      mt2 = newInputD(5)

      u = -(s+t) + 2*mt2
      xs = s/mst2
      xt = t/mst2
      xu = u/mst2
      xmst2 = 1d0
      xmchi2 = mchi2/mst2
      xmt2 = mt2/mst2

      newInputD = (/ xs,xt,xmst2,xmchi2,xmt2,
     &     cmplx(muR2,0d0,kind=dp),cmplx(deltaUV,0d0,kind=dp) /)
      newInputDSwap = (/ xs,xu,xmst2,xmchi2,xmt2,
     &     cmplx(muR2,0d0,kind=dp),cmplx(deltaUV,0d0,kind=dp) /)
      call set_small_to_zero(newInputD,1d-12)
      call set_small_to_zero(newInputDSwap,1d-12)

      k1sq = 0d0
      k2sq = 0d0
      cacheIdx = 0
      if (d_cache%valid(1)) then
        if (.not.differs(d_cache%input(1,:),newInputD)) cacheIdx = 1
      endif
      if (cacheIdx == 0 .and. d_cache%valid(2)) then
        if (.not.differs(d_cache%input(2,:),newInputD)) cacheIdx = 2
      endif

      if (cacheIdx == 0) then
        call Init_cll(N,rank,'',.true.)
        call InitEvent_cll
        call SetMode_cll(3)
        call SetDeltaUV_cll(deltaUV)
        call SetMuUV2_cll(muR2)

        d_cache%input(1,:) = newInputD
          call D_cll(Dcoeff,Dcoeffuv,xmt2,xt,k1sq,xs,k2sq,
     &      xmt2,xmst2,xmchi2,xmst2,xmst2,rank)
        Dcoeff = Dcoeff/((2*Pi)**4)
        do i=0,3
            do j=0,3
                do k=0,3
                    Dcoeff(0,i,j,k) = Dcoeff(0,i,j,k)/mst2**2
                    Dcoeff(1,i,j,k) = Dcoeff(1,i,j,k)/mst2
                enddo
            enddo
        enddo
        d_cache%dcoeff(1,:,:,:,:) = Dcoeff
        d_cache%valid(1) = .true.

        d_cache%input(2,:) = newInputDSwap
          call D_cll(Dcoeff,Dcoeffuv,xmt2,xu,k1sq,xs,k2sq,
     &      xmt2,xmst2,xmchi2,xmst2,xmst2,rank)
        Dcoeff = Dcoeff/((2*Pi)**4)
        do i=0,3
            do j=0,3
                do k=0,3
                    Dcoeff(0,i,j,k) = Dcoeff(0,i,j,k)/mst2**2
                    Dcoeff(1,i,j,k) = Dcoeff(1,i,j,k)/mst2
                enddo
            enddo
        enddo
        d_cache%dcoeff(2,:,:,:,:) = Dcoeff
        d_cache%valid(2) = .true.
        cacheIdx = 1
      endif

      Dcoeff = d_cache%dcoeff(cacheIdx,:,:,:,:)

      end subroutine getDIntegralsOnShell


      subroutine getD0IntegralOnShell(D0coeff,s,t,mst2,mchi2,mt2,
     &                                muR2,deltaUV)

      ! Return the scalar D0 integral with the argument convention used in this model.
      ! The cache stores both (t,u) variants.

      use collier
      use collier_cache_mod, only: dp, d0_cache,
     &     set_small_to_zero, differs

      implicit none

      double complex k1sq,k2sq
      double complex s,t,u,mchi2,mst2,mt2
      double complex xs,xt,xu,xmchi2,xmst2,xmt2
      double precision muR2,deltaUV
      double complex D0coeff
      integer N,rank,cacheIdx
      double precision Pi
      parameter  (Pi=3.141592653589793D0)

      double complex newInputD0(1:7)
      double complex newInputD0Swap(1:7)

      N = 4
      rank = 3

      newInputD0(1:5) = (/ s,t,mst2,mchi2,mt2 /)
      newInputD0(6:7) = (/ cmplx(muR2,0d0,kind=dp),
     &                    cmplx(deltaUV,0d0,kind=dp) /)
      call set_small_to_zero(newInputD0,1d-5)
      s = newInputD0(1)
      t = newInputD0(2)
      mst2 = newInputD0(3)
      mchi2 = newInputD0(4)
      mt2 = newInputD0(5)

      u = -(s+t) + 2*mt2
      xs = s/mst2
      xt = t/mst2
      xu = u/mst2
      xmst2 = 1d0
      xmchi2 = mchi2/mst2
      xmt2 = mt2/mst2

      newInputD0 = (/ xs,xt,xmst2,xmchi2,xmt2,
     &     cmplx(muR2,0d0,kind=dp),cmplx(deltaUV,0d0,kind=dp) /)
      newInputD0Swap = (/ xs,xu,xmst2,xmchi2,xmt2,
     &     cmplx(muR2,0d0,kind=dp),cmplx(deltaUV,0d0,kind=dp) /)
      call set_small_to_zero(newInputD0,1d-12)
      call set_small_to_zero(newInputD0Swap,1d-12)

      k1sq = 0d0
      k2sq = 0d0
      cacheIdx = 0
      if (d0_cache%valid(1)) then
        if (.not.differs(d0_cache%input(1,:),newInputD0)) cacheIdx = 1
      endif
      if (cacheIdx == 0 .and. d0_cache%valid(2)) then
        if (.not.differs(d0_cache%input(2,:),newInputD0)) cacheIdx = 2
      endif

      if (cacheIdx == 0) then
        call Init_cll(N,rank,'',.true.)
        call InitEvent_cll
        call SetMode_cll(3)
        call SetDeltaUV_cll(deltaUV)
        call SetMuUV2_cll(muR2)

        d0_cache%input(1,:) = newInputD0
          call D0_cll(D0coeff,xmt2,xmt2,k1sq,k2sq,xs,xt,
     &      xmst2,xmchi2,xmst2,xmst2)
        D0coeff = D0coeff/((2*Pi)**4)
        D0coeff = D0coeff/mst2**2
        d0_cache%d0(1) = D0coeff
        d0_cache%valid(1) = .true.

        d0_cache%input(2,:) = newInputD0Swap
          call D0_cll(D0coeff,xmt2,xmt2,k1sq,k2sq,xs,xu,
     &      xmst2,xmchi2,xmst2,xmst2)
        D0coeff = D0coeff/((2*Pi)**4)
        D0coeff = D0coeff/mst2**2
        d0_cache%d0(2) = D0coeff
        d0_cache%valid(2) = .true.
        cacheIdx = 1
      endif

      D0coeff = d0_cache%d0(cacheIdx)

      end subroutine getD0IntegralOnShell


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
      open(unit=51,file=trim(fname),action='WRITE',
     &     position='APPEND',status='unknown')
      write(51,*) '------------ ',trim(header),
     &     ': -------------------------'
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
      open(unit=52,file=trim(fname),action='WRITE',
     &     position='APPEND',status='unknown')
      write(52,*) '------------ ',trim(header),
     &     ': -------------------------'
      write (52, fmt2) 'mst,mchi,mt = ',CDSQRT(mst2),'*i',
     &     CDSQRT(mchi2),'*i',CDSQRT(mt2),'*i'
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
      open(unit=53,file=trim(fname),action='WRITE',
     &     position='APPEND',status='unknown')
      write(53,*) '------------ ',trim(header),
     &     ': -------------------------'
      write (53, fmt2) 'mst,mchi,mt = ',CDSQRT(mst2),'*i',
     &     CDSQRT(mchi2),'*i',CDSQRT(mt2),'*i'
      write (53,fmt1) 's,t,u = ',s,'*i',t,'*i',u,'*i'
      write (53,fmt10) 'ab = ',ab,'*i'
      write (53,fmt10) 'abF = ',abF,'*i'
      write(53,*) '-------------------------------------'
      write(53,*)
      close(53)
    
      end subroutine writedebugAB
