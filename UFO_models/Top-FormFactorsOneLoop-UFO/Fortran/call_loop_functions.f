      PROGRAM CALL_LOOP_FUNCTIONS
      IMPLICIT NONE

      DOUBLE COMPLEX C00EFFFUNC,AB,C1FUNC,C2FUNC,C12FUNC,C22FUNC,C11FUNC
      DOUBLE PRECISION REDB1
      EXTERNAL C00H, PB1H, REDB1

      DOUBLE COMPLEX P10, P21, P20, PSQ,MT2,MST2,MCHI2
      DOUBLE COMPLEX C00H_VAL, PB1H_VAL,B1CT,B1psq,B1H
      DOUBLE PRECISION REDB1_VAL
      
      INCLUDE 'input.inc'  ! include all external model parameter
      INCLUDE '../vector.inc'  ! Required for MG >= 3.7
      INCLUDE 'coupl.inc'  ! include other parameters

C     Load model parameters from the param card.
      CALL SETPARA('param_card.dat')

C     Example kinematic point (all values in GeV^2).
      P10 = DCMPLX(MDL_MT**2, 0.0D0)
      P21 = DCMPLX(6D5, 0.0D0)
      P20 = DCMPLX(MDL_MT**2, 0.0D0)
      PSQ = DCMPLX(5.5D4, 0.0D0)

      
      MCHI2 = MDL_MCHI**2
      MST2 = MDL_MST**2
      MT2 = MDL_MT**2
      WRITE(*,*) 'MCHI2=',MCHI2,'MST2=',MST2

      C00H_VAL = C00EFFFUNC(P10, P21, P20)
      B1CT = 2*(MDL_DELTACTR-MDL_DELTACTL)
      CALL GETABINTEGRAL(AB,PSQ,PSQ,MT2,MCHI2,MST2,REAL(MST2),0d0)
      B1psq = AB/(2*PSQ)
      B1H = B1psq-B1CT
      PB1H_VAL = (B1psq-B1CT)/(PSQ-MDL_MT**2)
      REDB1_VAL = 2*MDL_DELTACTL/MDL_MT**2

      WRITE(*,*) 'Input point:'
      WRITE(*,*) '  p10 = ', P10
      WRITE(*,*) '  p21 = ', P21
      WRITE(*,*) '  p20 = ', P20
      WRITE(*,*) '  psq = ', PSQ
      WRITE(*,*) 'Results:'
      WRITE(*,*) '  C00h(p10,p21,p20) = ', C00H_VAL
      WRITE(*,*) '  pB1h(psq)         = ', PB1H_VAL
      WRITE(*,*) '  reDB1(MT2)        = ', REDB1_VAL
      WRITE(*,*) '  B1(MT2)           = ', B1CT
      WRITE(*,*) '  B1(psq)           = ', B1psq      
      WRITE(*,*) '  C1(psq)           = ', C1FUNC(P10,P21,P20)
      WRITE(*,*) '  C2(psq)           = ', C2FUNC(P10,P21,P20)
      WRITE(*,*) '  C11(psq)           = ',C11FUNC(P10,P21,P20)
      WRITE(*,*) '  C12(psq)           = ',C12FUNC(P10,P21,P20)
      WRITE(*,*) '  C22(psq)           = ',C22FUNC(P10,P21,P20)
    

      END

