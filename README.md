# Abaqus User Field Damage
as imple VUSDFLD subroutine to delete elements above a mises stress threashold

The only thing you have to do to make it work is add the file in your working directory and add "user=VUSDFLD.for" in the abaqus launch command line.

You can also directly link the file when you create a job in CAE by changing the "User subroutine file" in the general tab.

