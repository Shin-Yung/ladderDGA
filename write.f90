!this module contains subroutines for writing data
MODULE write
  IMPLICIT NONE

CONTAINS

  SUBROUTINE write_self_loc(fname,Iwbox,beta,self,selfloc_res)
    !writes the DMFT self-energy and the local self-energy from the DGA-equation

    !input:
    CHARACTER(LEN=*), INTENT(IN) :: fname
    INTEGER, INTENT(IN) :: Iwbox
    REAL(KIND=8), INTENT(IN) :: beta
    COMPLEX(KIND=8), DIMENSION(-Iwbox:), INTENT(IN) :: self,selfloc_res
    !subroutine internal variables
    INTEGER :: j
    REAL(KIND=8) :: pi
    
    pi=dacos(-1.0d0)
    OPEN(30,file=fname,form='formatted',status='replace')
    DO j=-Iwbox,Iwbox-1
       WRITE(30,'(5f17.10)') dfloat(2*j+1)*pi/beta, &
            dreal(self(j)),dimag(self(j)), &
            dreal(selfloc_res(j)),dimag(selfloc_res(j))
    ENDDO
    CLOSE(30)

  END SUBROUTINE write_self_loc

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

  SUBROUTINE write_chi(fname,LQ,Qv,lambda,chi)
    !writes the physical susceptibilities

    !input:
    CHARACTER(LEN=*), INTENT(IN) :: fname
    INTEGER, INTENT(IN) :: LQ
    REAL(KIND=8), INTENT(IN) :: lambda
    REAL(KIND=8), DIMENSION(0:), INTENT(IN) :: Qv
    COMPLEX(KIND=8), DIMENSION(:), INTENT(IN) :: chi
    !subroutine internal variables
    INTEGER :: ix,iy
    COMPLEX(KIND=8) :: chival,chival_lambda

    OPEN(30,file=fname,form='formatted',status='replace')

    DO ix=0,LQ-1
       DO iy=0,ix
          chival=chi(ix*(ix+1)/2+iy+1)
          chival_lambda=1.0d0/(1.0d0/chival+lambda)
          WRITE (30,'(6f17.10)')Qv(ix),Qv(iy), &
               dreal(chival_lambda),dimag(chival_lambda), &
               dreal(chival),dimag(chival)
       ENDDO
    ENDDO
    CLOSE(30)

  END SUBROUTINE write_chi

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

  SUBROUTINE write_sigma(Iwbox,k_number,beta,selflist_res,selflistch_res, &
       selflistsp_res,selflistrest_res,self,selfloc_res)
    !writes the DGA self-energye (total, charge-contribution, spin-contribution, rest)

    !input
    INTEGER, INTENT(IN) :: Iwbox,k_number
    REAL(KIND=8), INTENT(IN) :: beta
    COMPLEX(KIND=8), DIMENSION(:,-Iwbox:), INTENT(IN) :: selflist_res,selflistch_res
    COMPLEX(KIND=8), DIMENSION(:,-Iwbox:), INTENT(IN) :: selflistsp_res,selflistrest_res
    COMPLEX(KIND=8), DIMENSION(-2*Iwbox:), INTENT(IN) :: self
    COMPLEX(KIND=8), DIMENSION(-Iwbox:), INTENT(IN) :: selfloc_res
    !subroutine internal variables
    CHARACTER(LEN=50) :: fname
    INTEGER :: i1,j
    REAL(KIND=8) :: pi
    COMPLEX(KIND=8) :: self_out,selfrest_out

    pi=dacos(-1.0d0)
    DO i1=1,k_number
       WRITE(fname,'(A13,I6.6,A4)'),'klist/SELF_Q_',i1,'.dat'
       OPEN(400+i1,file=fname,form='formatted',status='replace')
       WRITE(400+i1,'(A25)')'# iv_n S S_ch S_sp S_rest'
       DO j=-iwbox,iwbox-1
          self_out=selflist_res(i1,j)-selfloc_res(j)+self(j)
          selfrest_out=selflistrest_res(i1,j)-selfloc_res(j)+self(j)
          WRITE(400+i1,'(9f17.10)')dfloat(2*j+1)*pi/beta, &
               dreal(self_out),dimag(self_out), &
               dreal(selflistch_res(i1,j)),dimag(selflistch_res(i1,j)), &
               dreal(selflistsp_res(i1,j)),dimag(selflistsp_res(i1,j)), &
               dreal(selfrest_out),dimag(selfrest_out)
       ENDDO
       CLOSE(400+i1)
    ENDDO

    END SUBROUTINE


END MODULE write