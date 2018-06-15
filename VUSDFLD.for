      subroutine vusdfld(
c Read only -
     *   nblock, nstatev, nfieldv, nprops, ndir, nshr, 
     *   jElem, kIntPt, kLayer, kSecPt, 
     *   stepTime, totalTime, dt, cmname, 
     *   coordMp, direct, T, charLength, props, 
     *   stateOld, 
c Write only -
     *   stateNew, field )
c
      include 'vaba_param.inc'
c
      dimension jElem(nblock), coordMp(nblock,*), 
     *          direct(nblock,3,3), T(nblock,3,3), 
     *          charLength(nblock), props(nprops), 
     *          stateOld(nblock,nstatev), 
     *          stateNew(nblock,nstatev),
     *          field(nblock,nfieldv)
      character*80 cmname
c
c     Local arrays from vgetvrm are dimensioned to 
c     maximum block size (maxblk)
c
      parameter( nrData=6 )
      character*3 cData(maxblk*nrData)
      dimension rData(maxblk*nrData), jData(maxblk*nrData)
c
      jStatus = 1
      call vgetvrm( 'S', rData, jData, cData, jStatus )
c
      if( jStatus .ne. 0 ) then
         call xplb_abqerr(-2,'Utility routine VGETVRM '//
     .      'failed to get variable.',0,zero,' ')
         call xplb_exit
      end if
      MaxStress = 10000000
c
      do k = 1, nblock
c       Von mises stress in the axial directions
           VMStress1 = ((rData(k)-rData(k+nblock))**2.)
           VMStress2 = ((rData(k+nblock)-rData(k+nblock*2))**2.)
           VMStress3 = ((rData(k+nblock*2)-rData(k))**2.)
c        von mises stress in the shear directions
           VMStress4 = rData(k+nblock*3)**2.
           VMStress5 = rData(k+nblock*4)**2.
           VMStress6 = rData(k+nblock*5)**2.
           VMStressShear = 6.0*(VMStress4+VMStress5+VMStress6)
c Sum of al the terms
           VMStressTemp = VMStress1+VMStress2+VMStress3+VMStressShear
c Final calculation
           VMStress = sqrt(VMStressTemp/2.)
           stateNew(k,2) = VMStress
           if (VMStress > MaxStress) then
            stateNew(k,1) = 0
           end if
      end do
c
      return
      end