program p
  ! This is a comment line; it is ignored by the compiler
    integer*16 time


    integer*16 distance
   
    integer*16 :: score
    score = 0

    time = 44899691!44!7!44
    distance = 277113618901768!277!9!227

   
    do j  =0,time
        !print *, j 
        !print *, j * (time - j)

        if (j * (time - j) > distance) then
            
            !print * , "won"
            score = score + 1
        end if
    end do

   

    print *, 'DONE!'
    print *, score 

end program p