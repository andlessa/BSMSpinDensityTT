
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

        include 'input.inc' ! include all external model parameter
        include '../vector.inc' ! Required for MG >= 3.7
        include 'coupl.inc' ! include other parameters
        integer, parameter :: dp = kind(1.0d0) 
        integer, parameter :: cache_size = 10
        real(dp), parameter :: default_rtol = 1d-4
        real(dp), parameter :: default_atol = 1d-12
        double precision, parameter :: deltaUV = 0.0
        
        type :: model_pars_t
          double complex mt2,mst2,mchi2
          double precision muR2 ! The counter-terms were computing assuming muR2 = mst2
        end type model_pars_t

        type :: b1_cache_t
           logical :: init = .false.
           integer :: N = 2
           integer :: rank = 2
           integer :: n_used = 0
           integer :: next_slot = 1
           complex(dp) :: input(cache_size,3) = (0d0,0d0)
           complex(dp) :: db1result(cache_size) = (0d0,0d0)
        end type b1_cache_t


        type :: ct_cache_t
          logical :: init = .false.
          integer :: rank = 1
          integer :: N = 2
          complex(dp) :: b1CT = (0d0,0d0)
          complex(dp) :: db1CT = (0d0,0d0)
          complex(dp) :: ddb1CT = (0d0,0d0)
        end type ct_cache_t

        type :: b_cache_t
          logical :: init = .false.
          integer :: N = 2
          integer :: rank = 2
          integer :: n_used = 0
          integer :: next_slot = 1
          complex(dp) :: input(cache_size,3) = (0d0,0d0)
          complex(dp) :: bresults(cache_size,0:1,0:2) = (0d0,0d0) ! the dimensions should match (0:rank/2,0:rank)
          complex(dp) :: bresultsUV(cache_size,0:1,0:2) = (0d0,0d0) ! the dimensions should match (0:rank/2,0:rank)
        end type b_cache_t

        type :: c_cache_t
          logical :: init = .false.
          integer :: N = 3
          integer :: rank = 2
          integer :: n_used = 0
          integer :: next_slot = 1
          complex(dp) :: input(cache_size,6) = (0d0,0d0)
          complex(dp) :: cresults(cache_size,0:1,0:2,0:2) = (0d0,0d0) ! the dimensions should match (0:rank/2,0:rank,0:rank)
          complex(dp) :: cresultsUV(cache_size,0:1,0:2,0:2) = (0d0,0d0) ! the dimensions should match (0:rank/2,0:rank,0:rank)
        end type c_cache_t

        type :: d_cache_t
          logical :: init = .false.
          integer :: N = 4
          integer :: rank = 3
          integer :: n_used = 0
          integer :: next_slot = 1
          complex(dp) :: input(cache_size,10) = (0d0,0d0)
          complex(dp) :: dresults(cache_size,0:1,0:3,0:3,0:3) = (0d0,0d0) ! the dimensions should match (0:rank/2,0:rank,0:rank,0:rank)
          complex(dp) :: dresultsUV(cache_size,0:1,0:3,0:3,0:3) = (0d0,0d0) ! the dimensions should match (0:rank/2,0:rank,0:rank,0:rank)
        end type d_cache_t

        type(model_pars_t), save :: model_pars
        type(ct_cache_t), save :: ct_cache
        type(b_cache_t), save :: b_cache
        type(c_cache_t), save :: c_cache
        type(d_cache_t), save :: d_cache
        type(b1_cache_t), save :: b1_cache

      contains

        subroutine set_model_pars()

          ! Subroutine to initialize the model parameters

          implicit none
          
          model_pars%mt2 = MDL_MT**2
          model_pars%mchi2 = MDL_MCHI**2
          model_pars%mst2 = MDL_MST**2
          model_pars%muR2 = MDL_MST**2

        end subroutine set_model_pars

        function set_small_to_zero(vars,vmin) result(vars_out)

          implicit none

          complex(dp), intent(in) :: vars(:)
          real(dp), intent(in) :: vmin
          complex(dp) :: vars_out(size(vars))
          integer :: ii

          vars_out = vars

          do ii=1,size(vars)
            if (abs(vars_out(ii)) < vmin) then
                vars_out(ii) = (0d0,0d0)
                endif
          enddo

        end function set_small_to_zero

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
                if (abs(oldVars(ii)-newVars(ii)) > (tol_abs + tol_rel*scale)) then
                    differs = .true.
                    exit
                endif
            enddo

        end function differs

      end module collier_cache_mod

      subroutine computeCT(ctVals)
      ! Compute the integrals required by the counter-terms. Since these only needed to be
      ! computed once, we can always cache the result

      use collier
      use collier_cache_mod, only: ct_cache,set_model_pars,model_pars

      implicit none
    
      double precision Pi
      parameter  (Pi=3.141592653589793D0)

      ! Return values: ctVals(1)=b1CT, ctVals(2)=db1CT, ctVals(3)=ddb1CT
      double precision ctVals(3)
      double complex mt2
      double complex Bcoll
      double complex DB1,dx

      dx = (1d-5,0d0) ! small step for computing the second derivative

      ! If first time compute and cache
      if (.not.ct_cache%init) then
        call set_model_pars()
        mt2 = model_pars%mt2 
        ct_cache%init = .true.
        ct_cache%b1CT = real(Bcoll((0d0,0d0),(1d0,0d0),mt2))
        ct_cache%db1CT = real(DB1(mt2))
        ct_cache%ddb1CT = (DB1(mt2+dx)-DB1(mt2-dx))/(2d0*dx)
      endif

      ctVals(1) = ct_cache%b1CT
      ctVals(2) = ct_cache%db1CT
      ctVals(3) = ct_cache%ddb1CT

      end subroutine computeCT

      double complex function DB1(psq)

      ! Compute the derivative of B1. Only needed once for computing the count-terms (should only be needed at psq=mt2
      ! and around psq=mt2 to compute the second derivative of B1.

      use collier
      use collier_cache_mod, only: model_pars,set_small_to_zero,
     &     differs, set_model_pars, deltaUV

      implicit none
    
      double complex psq
      double precision Pi
      parameter  (Pi=3.141592653589793D0)
      logical useCache
      integer slot,hitSlot

      double complex newInput(3)
      double complex mt2,mchi2,mst2
      double precision muR2

      call set_model_pars()
      
      mt2 = model_pars%mt2
      mchi2 = model_pars%mchi2
      mst2 = model_pars%mst2
      muR2 = model_pars%muR2
      
      ! Store new input variables
      newInput = (/ psq,mchi2,mst2 /)
      ! Set to zero small variable values
      newInput = set_small_to_zero(newInput,1d-5)
      psq = newInput(1)
      mchi2 = newInput(2)
      mst2 = newInput(3)

      ! Check if the given input variables match one of the cached slots
      useCache = .false.
      hitSlot = 0
      if (b1_cache%init) then
        do slot=1,b1_cache%n_used
          if (.not.differs(b1_cache%input(slot,:),newInput)) then
            useCache = .true.
            hitSlot = slot
            exit
          endif
        enddo
      endif
    
      ! If useCache = .false., we need to compute it and cache
      if (.not.useCache) then
        hitSlot = b1_cache%next_slot
        b1_cache%input(hitSlot,:) = newInput
        b1_cache%init = .true.
        call Init_cll(b1_cache%N,b1_cache%rank,'',.true.)
        call InitEvent_cll
        ! Using mode=3 computes with the DD and COLI branches and return the most precise results
        call SetMode_cll(3) 
        call SetDeltaUV_cll(deltaUV) ! Remove the divergence (MSbar)
        call SetMuUV2_cll(muR2) ! Set the renormalization scale    
        call DB1_cll(b1_cache%b1result(hitSlot),psq,mchi2,mst2)
        b1_cache%b1result(hitSlot)
     &      = real(b1_cache%b1result(hitSlot)/((2*Pi)**4))
        if (b1_cache%n_used < cache_size) then
          b1_cache%n_used = b1_cache%n_used + 1
        endif
        b1_cache%next_slot = mod(hitSlot,cache_size) + 1
      endif

      DB1 = b1_cache%b1result(hitSlot)

      end function DB1

      
      double complex function Bcoll(ii,jj,psq)

      ! Compute the B integrals with respect to the external momentum squared (psq)
      ! and cache the result.

      use collier
      use collier_cache_mod, only: model_pars,b_cache,
     &     set_small_to_zero, differs, set_model_pars, deltaUV,
     &     cache_size

      implicit none
    
      double complex ii,jj
      integer i,j
      double complex psq
      double precision Pi
      parameter  (Pi=3.141592653589793D0)

      double complex mt2,mchi2,mst2
      double precision muR2
      double complex newInput(3)
      double complex bresultsTmp(0:1,0:2),bresultsUVTmp(0:1,0:2)
      logical useCache
      integer slot,hitSlot
      call set_model_pars()

      i = int(ii)
      j = int(jj)
      
      mt2 = model_pars%mt2
      mchi2 = model_pars%mchi2
      mst2 = model_pars%mst2
      muR2 = model_pars%muR2
      
      ! Store new input variables
      newInput = (/ psq,mchi2,mst2 /)
      ! Set to zero small variable values
      newInput = set_small_to_zero(newInput,1d-5)
      psq = newInput(1)
      mchi2 = newInput(2)
      mst2 = newInput(3)

      ! Check if the given input variables match one of the cached slots
      useCache = .false.
      hitSlot = 0
      if (b_cache%init) then
        do slot=1,b_cache%n_used
          if (.not.differs(b_cache%input(slot,:),newInput)) then
            useCache = .true.
            hitSlot = slot
            exit
          endif
        enddo
      endif
    
      ! If useCache = .false., we need to compute it and cache
      if (.not.useCache) then
        hitSlot = b_cache%next_slot
        b_cache%input(hitSlot,:) = newInput
        b_cache%init = .true.
        call Init_cll(b_cache%N,b_cache%rank,'',.true.)
        call InitEvent_cll
        ! Using mode=3 computes with the DD and COLI branches and return the most precise results
        call SetMode_cll(3) 
        call SetDeltaUV_cll(deltaUV) ! Remove the divergence (MSbar)
        call SetMuUV2_cll(muR2) ! Set the renormalization scale    
        call B_cll(bresultsTmp,bresultsUVTmp,psq,mchi2,mst2,b_cache%rank)
        b_cache%bresults(hitSlot,:,:) = bresultsTmp/((2*Pi)**4)
        b_cache%bresultsUV(hitSlot,:,:) = bresultsUVTmp/((2*Pi)**4)
        if (b_cache%n_used < cache_size) then
          b_cache%n_used = b_cache%n_used + 1
        endif
        b_cache%next_slot = mod(hitSlot,cache_size) + 1
      endif

      Bcoll = b_cache%bresults(hitSlot,i,j)

      end function Bcoll

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


double complex function Ccoll(ii,jj,kk,p10,p21,p20)

      ! Compute the B integrals with respect to the external momentum squared (psq)
      ! and cache the result.

      use collier
      use collier_cache_mod, only: model_pars,c_cache,
     &     set_small_to_zero, differs, set_model_pars,deltaUV,
     &     cache_size

      implicit none

      double complex ii,jj,kk
      integer i,j,k
      double complex p10,p21,p20
      double precision Pi
      parameter  (Pi=3.141592653589793D0)

      double complex mt2,mchi2,mst2
      double precision muR2
      double complex newInput(6)
      double complex cresultsTmp(0:1,0:2,0:2)
      double complex cresultsUVTmp(0:1,0:2,0:2)
      logical useCache
      integer slot,hitSlot

      call set_model_pars()
      
      i = int(ii)
      j = int(jj)
      k = int(kk)
      mt2 = model_pars%mt2
      mchi2 = model_pars%mchi2
      mst2 = model_pars%mst2
      muR2 = model_pars%muR2
      
      ! Store new input variables
      newInput = (/ p10,p21,p20,mchi2,mst2,mst2 /)
      ! Set to zero small variable values
      newInput = set_small_to_zero(newInput,1d-5)
      p10 = newInput(1)
      p21 = newInput(2)
      p20 = newInput(3)
      mchi2 = newInput(4)
      mst2 = newInput(5)

      ! Check if the given input variables match one of the cached slots
      useCache = .false.
      hitSlot = 0
      if (c_cache%init) then
        do slot=1,c_cache%n_used
          if (.not.differs(c_cache%input(slot,:),newInput)) then
            useCache = .true.
            hitSlot = slot
            exit
          endif
        enddo
      endif
    
      ! If useCache = .false., we need to compute it and cache
      if (.not.useCache) then
        hitSlot = c_cache%next_slot
        c_cache%input(hitSlot,:) = newInput
        c_cache%init = .true.
        call Init_cll(c_cache%N,c_cache%rank,'',.true.)
        call InitEvent_cll
        ! Using mode=3 computes with the DD and COLI branches and return the most precise results
        call SetMode_cll(3) 
        call SetDeltaUV_cll(deltaUV) ! Remove the divergence (MSbar)
        call SetMuUV2_cll(muR2) ! Set the renormalization scale    
        call C_cll(cresultsTmp,cresultsUVTmp,p10,p21,p20,
     &           mchi2,mst2,mst2,c_cache%rank)
        c_cache%cresults(hitSlot,:,:,:) = cresultsTmp/((2*Pi)**4)
        c_cache%cresultsUV(hitSlot,:,:,:) = cresultsUVTmp/((2*Pi)**4)
        if (c_cache%n_used < cache_size) then
          c_cache%n_used = c_cache%n_used + 1
        endif
        c_cache%next_slot = mod(hitSlot,cache_size) + 1
      endif

      Ccoll = c_cache%cresults(hitSlot,i,j,k)

      end function Ccoll


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



double complex function Dcoll(ii,jj,kk,ll,p10,p21,p32,p30,p20,p31)

      ! Compute the B integrals with respect to the external momentum squared (psq)
      ! and cache the result.

      use collier
      use collier_cache_mod, only: model_pars,d_cache,
     &     set_small_to_zero, differs, set_model_pars,deltaUV,
     &     cache_size

      implicit none
    
      double complex ii,jj,kk,ll
      integer i,j,k,l
      double complex p10,p21,p32,p30,p20,p31
      double precision Pi
      parameter  (Pi=3.141592653589793D0)

      double complex mt2,mchi2,mst2
      double precision muR2
      double complex newInput(10)
      double complex dresultsTmp(0:1,0:3,0:3,0:3)
      double complex dresultsUVTmp(0:1,0:3,0:3,0:3)
      logical useCache
      integer slot,hitSlot

      call set_model_pars()

      i = int(ii)
      j = int(jj)
      k = int(kk)
      l = int(ll)
      
      mt2 = model_pars%mt2
      mchi2 = model_pars%mchi2
      mst2 = model_pars%mst2
      muR2 = model_pars%muR2
     
      ! Store new input variables
      newInput = (/ p10,p21,p32,p30,p20,p31,mst2,mchi2,mst2,mst2 /)
      ! Set to zero small variable values
      newInput = set_small_to_zero(newInput,1d-5)
      p10 = newInput(1)
      p21 = newInput(2)
      p32 = newInput(3)
      p30 = newInput(4)
      p20 = newInput(5)
      p31 = newInput(6)
      mst2 = newInput(7)
      mchi2 = newInput(8)

      ! Check if the given input variables match one of the cached slots
      useCache = .false.
      hitSlot = 0
      if (d_cache%init) then
        do slot=1,d_cache%n_used
          if (.not.differs(d_cache%input(slot,:),newInput)) then
            useCache = .true.
            hitSlot = slot
            exit
          endif
        enddo
      endif
    
      ! If useCache = .false., we need to compute it and cache
      if (.not.useCache) then
        hitSlot = d_cache%next_slot
        d_cache%input(hitSlot,:) = newInput
        d_cache%init = .true.
        call Init_cll(d_cache%N,d_cache%rank,'',.true.)
        call InitEvent_cll
        ! Using mode=3 computes with the DD and COLI branches and return the most precise results
        call SetMode_cll(3) 
        call SetDeltaUV_cll(deltaUV) ! Remove the divergence (MSbar)
        call SetMuUV2_cll(muR2) ! Set the renormalization scale    
        call D_cll(dresultsTmp,dresultsUVTmp,p10,p21,p32,p30,p20,p31,
     &       mst2,mchi2,mst2,mst2,d_cache%rank)
        d_cache%dresults(hitSlot,:,:,:,:) = dresultsTmp/((2*Pi)**4)
        d_cache%dresultsUV(hitSlot,:,:,:,:) = dresultsUVTmp/((2*Pi)**4)
        if (d_cache%n_used < cache_size) then
          d_cache%n_used = d_cache%n_used + 1
        endif
        d_cache%next_slot = mod(hitSlot,cache_size) + 1
      endif

      Dcoll = d_cache%dresults(hitSlot,i,j,k,l)

      end function Dcoll



      double complex function pB1h(psq)
      
      ! Compute the renormalized B1 integral defined as: pB1h(psq) = (B1(psq,mChi^2,mST^2)-B1(MT^2,mChi^2,mST^2))/(psq-MT^2)
      ! and cache the result.

      use collier
      use collier_cache_mod, only: model_pars,set_small_to_zero

      implicit none
    
      integer i,j
      double complex psq
      double precision Pi
      double precision ctVals(3)
      parameter  (Pi=3.141592653589793D0)

      double complex mt2,mchi2,mst2
      double precision muR2,b1CT,db1CT
      double complex x(1)
      double complex Bcoll
      external computeCT

      call computeCT(ctVals)  
      mt2 = model_pars%mt2      
      b1CT = ctVals(1)
      db1CT = ctVals(2)

      x(1) = psq - mt2
      x = set_small_to_zero(x,1d-5)
      ! if psq is very close to mt2, we can use the first order expansion of B1(psq) around mt2, which is given by db1CT
      if (abs(x(1)) < 1d-5) then
        pB1h = db1CT
      else
        pB1h = (Bcoll((0d0,0d0),(1d0,0d0),psq)-b1CT)/x(1)
      endif

      end function pB1h

    double complex function p2B1h(psq)
      
      ! Compute the renormalized B1 integral defined as: p2B1h(psq) = (pB1h(psq,mChi^2,mST^2)-pB1h(MT^2,mChi^2,mST^2))/(psq-MT^2)
      ! and cache the result.

      use collier
      use collier_cache_mod, only: model_pars,set_small_to_zero

      implicit none
    
      integer i,j
      double complex psq
      double precision Pi
      double precision ctVals(3)
      parameter  (Pi=3.141592653589793D0)

      double complex mt2,mchi2,mst2
      double precision muR2,b1CT,db1CT
      double complex x(1)
      double complex Bcoll
      external computeCT

      call computeCT(ctVals)  
      mt2 = model_pars%mt2      
      b1CT = ctVals(1)
      db1CT = ctVals(2)
      ddb1CT = ctVals(3)

      pb1h = pB1h(psq)
      pb1h0 = pB1h(mt2)

      x(1) = psq - mt2
      x = set_small_to_zero(x,1d-5)
      ! if psq is very close to mt2, we can use the first order expansion of pB1h(psq) around mt2, which is given by ddb1CT/2
      if (abs(x(1)) < 1d-5) then
        p2B1h = ddb1CT/2d0
      else
        p2B1h = (pb1h-pb1h0)/x(1)
      endif

      end function p2B1h


    double complex function C00h(p10,p21,p20)
      
      ! Compute the renormalized C00h integral defined as: C00h(p1sq,s,p2sq) = C00(p1sq,s,p2sq,mChi^2,mST^2,mST^2) + (1/2)*B1(MT^2,mChi^2,mST^2))
      ! and cache the result.

      use collier
      use collier_cache_mod, only: model_pars

      implicit none
    
      integer i,j
      double complex p10,p21,p20
      double precision Pi
      double precision ctVals(2)
      double precision b1CT, db1CT
      double complex Ccoll
      external computeCT
      parameter  (Pi=3.141592653589793D0)

      call computeCT(ctVals)
      b1CT = ctVals(1)
      db1CT = ctVals(2)

      C00h = Ccoll((1d0,0d0),(0d0,0d0),(0d0,0d0),p10,p21,p20)+ (1d0/2d0)*b1CT

      end function C00h


    !   subroutine writedebugC(s,p1sq,p2sq,Ccoeff,header)

    !   implicit none
   
    !   double complex s,p1sq,p2sq
    !   double complex Ccoeff(0:1,0:2,0:2)
    !   character(len=99) :: fname
    !   character(len=*) :: header
    !   character(len=*) fmt1,fmt10
    !   parameter (fmt1 = '(A13,3(es11.3,SP,es9.1,A2))')
    !   parameter (fmt10 = '(A6,es12.4,SP,es12.4,A2)')

    !   fname='myLogC.log'
    !   open(unit=51,file=trim(fname),action='WRITE',
    !  &     position='APPEND',status='unknown')
    !   write(51,*) '------------ ',trim(header),
    !  &     ': -------------------------'
    !   write (51,fmt1) 's,p1sq,p2sq = ',s,'*i',p1sq,'*i',p2sq,'*i'
    !   write (51,fmt10) 'C00 = ',Ccoeff(1,0,0),'*i'
    !   write (51,fmt10) 'C1 = ',Ccoeff(0,1,0),'*i'
    !   write (51,fmt10) 'C2 = ',Ccoeff(0,0,1),'*i'
    !   write (51,fmt10) 'C11 = ',Ccoeff(0,2,0),'*i'
    !   write (51,fmt10) 'C12 = ',Ccoeff(0,1,1),'*i'
    !   write (51,fmt10) 'C22 = ',Ccoeff(0,0,2),'*i'
    !   write(51,*) '-------------------------------------'
    !   write(51,*)
    !   close(51)
    
    !   end subroutine writedebugC

    !   subroutine writedebugD(s,t,mst2,mchi2,mt2,Dcoeff,header)

    !   implicit none
   
    !   double complex s,t,u
    !   double complex mst2,mchi2,mt2
    !   double complex Dcoeff(0:1,0:3,0:3,0:3)
    !   character(len=99) :: fname
    !   character(len=*) :: header
    !   character(len=*) fmt1,fmt10,fmt2
    !   parameter (fmt1 = '(A22,3(es11.3,SP,es9.1,A2))')
    !   parameter (fmt2 = '(A13,3(es11.3,SP,es9.1,A2))')
    !   parameter (fmt10 = '(A6,es12.4,SP,es12.4,A2)')

    !   u = -(s+t) + 2*mt2

    !   fname='myLogD.log'
    !   open(unit=52,file=trim(fname),action='WRITE',
    !  &     position='APPEND',status='unknown')
    !   write(52,*) '------------ ',trim(header),
    !  &     ': -------------------------'
    !   write (52, fmt2) 'mst,mchi,mt = ',CDSQRT(mst2),'*i',
    !  &     CDSQRT(mchi2),'*i',CDSQRT(mt2),'*i'
    !   write (52,fmt1) 's,t,u = ',s,'*i',t,'*i',u,'*i'
    !   write (52,fmt10) 'D0 = ',Dcoeff(0,0,0,0),'*i'
    !   write (52,fmt10) 'D1 = ',Dcoeff(0,1,0,0),'*i'
    !   write (52,fmt10) 'D2 = ',Dcoeff(0,0,1,0),'*i'
    !   write (52,fmt10) 'D3 = ',Dcoeff(0,0,0,1),'*i'
    !   write (52,fmt10) 'D00 = ',Dcoeff(1,0,0,0),'*i'
    !   write (52,fmt10) 'D11 = ',Dcoeff(0,2,0,0),'*i'
    !   write (52,fmt10) 'D12 = ',Dcoeff(0,1,1,0),'*i'
    !   write (52,fmt10) 'D13 = ',Dcoeff(0,1,0,1),'*i'
    !   write (52,fmt10) 'D22 = ',Dcoeff(0,0,2,0),'*i'
    !   write (52,fmt10) 'D23 = ',Dcoeff(0,0,1,1),'*i'
    !   write (52,fmt10) 'D33 = ',Dcoeff(0,0,0,2),'*i'
    !   write (52,fmt10) 'D001 = ',Dcoeff(1,1,0,0),'*i'
    !   write (52,fmt10) 'D002 = ',Dcoeff(1,0,1,0),'*i'
    !   write (52,fmt10) 'D003 = ',Dcoeff(1,0,0,1),'*i'
    !   write (52,fmt10) 'D111 = ',Dcoeff(0,3,0,0),'*i'
    !   write (52,fmt10) 'D112 = ',Dcoeff(0,2,1,0),'*i'
    !   write (52,fmt10) 'D113 = ',Dcoeff(0,2,0,1),'*i'
    !   write (52,fmt10) 'D122 = ',Dcoeff(0,1,2,0),'*i'
    !   write (52,fmt10) 'D123 = ',Dcoeff(0,1,1,1),'*i'
    !   write (52,fmt10) 'D133 = ',Dcoeff(0,1,0,2),'*i'
    !   write (52,fmt10) 'D222 = ',Dcoeff(0,0,3,0),'*i'writedebugC
    !   write (52,fmt10) 'D223 = ',Dcoeff(0,0,2,1),'*i'
    !   write (52,fmt10) 'D233 = ',Dcoeff(0,0,1,2),'*i'
    !   write (52,fmt10) 'D333 = ',Dcoeff(0,0,0,3),'*i'
    !   write(52,*) '-------------------------------------'
    !   write(52,*)
    !   close(52)
    
    !   end subroutine writedebugD

    !   subroutine writedebugAB(s,t,mst2,mchi2,mt2,ab,abF,header)

    !   implicit none
   
    !   double complex s,t,u
    !   double complex mst2,mchi2,mt2
    !   double complex ab,abF
    !   character(len=99) :: fname
    !   character(len=*) :: header
    !   character(len=*) fmt1,fmt10,fmt2
    !   parameter (fmt1 = '(A22,3(es11.3,SP,es9.1,A2))')
    !   parameter (fmt2 = '(A13,3(es11.3,SP,es9.1,A2))')
    !   parameter (fmt10 = '(A6,es12.4,SP,es12.4,A2)')

    !   u = -(s+t) + 2*mt2

    !   fname='myLogAB.log'
    !   open(unit=53,file=trim(fname),action='WRITE',
    !  &     position='APPEND',status='unknown')
    !   write(53,*) '------------ ',trim(header),
    !  &     ': -------------------------'
    !   write (53, fmt2) 'mst,mchi,mt = ',CDSQRT(mst2),'*i',
    !  &     CDSQRT(mchi2),'*i',CDSQRT(mt2),'*i'
    !   write (53,fmt1) 's,t,u = ',s,'*i',t,'*i',u,'*i'
    !   write (53,fmt10) 'ab = ',ab,'*i'
    !   write (53,fmt10) 'abF = ',abF,'*i'
    !   write(53,*) '-------------------------------------'
    !   write(53,*)
    !   close(53)
    
    !   end subroutine writedebugAB
