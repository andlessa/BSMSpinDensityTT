      PROGRAM CALL_LOOP_FUNCTIONS
      IMPLICIT NONE

      DOUBLE COMPLEX C00H, PB1H
      DOUBLE PRECISION REDB1
      DOUBLE COMPLEX Bcoll,B1sq,Ccoll
      EXTERNAL C00H, PB1H, REDB1

      DOUBLE COMPLEX P10, P21, P20, PSQ
      DOUBLE COMPLEX C00H_VAL, PB1H_VAL
      DOUBLE PRECISION REDB1_VAL,B1_VAL
      DOUBLE PRECISION CTVALS(2)

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

      C00H_VAL = C00H(P10, P21, P20)
      PB1H_VAL = PB1H(PSQ)
      REDB1_VAL = REDB1(MDL_MT**2)
      B1sq = Bcoll(0,1,PSQ)

      CALL COMPUTECT(CTVALS)

      B1_VAL = CTVALS(1)

      WRITE(*,*) 'Input point:'
      WRITE(*,*) '  p10 = ', P10
      WRITE(*,*) '  p21 = ', P21
      WRITE(*,*) '  p20 = ', P20
      WRITE(*,*) '  psq = ', PSQ
      WRITE(*,*) 'Results:'
      WRITE(*,*) '  C00h(p10,p21,p20) = ', C00H_VAL
      WRITE(*,*) '  pB1h(psq)         = ', PB1H_VAL
      WRITE(*,*) '  reDB1(MT2)        = ', REDB1_VAL
      WRITE(*,*) '  B1(MT2)           = ', B1_VAL
      WRITE(*,*) '  B1(psq)           = ', B1sq
      WRITE(*,*) '  C1(psq)           = ', Ccoll(0,1,0,P10,P21,P20)
      WRITE(*,*) '  C2(psq)           = ', Ccoll(0,0,1,P10,P21,P20)
      WRITE(*,*) '  C11(psq)           = ', Ccoll(0,2,0,P10,P21,P20)
      WRITE(*,*) '  C12(psq)           = ', Ccoll(0,1,1,P10,P21,P20)
      WRITE(*,*) '  C22(psq)           = ', Ccoll(0,0,2,P10,P21,P20)

      END
