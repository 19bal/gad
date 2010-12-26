ilgi: @ilke

arkaplan çıkarımıyla ilgili kodlar vs buraya.

## db

1. önce soton [database](http://www.gait.ecs.soton.ac.uk/database/images/large_db_examples/021a001s00R.dv) i indir

2. ya matlab aviread ya da `ffmpeh -i 021a001s00R.dv frame%03d.png` ile resimleri uret

3. uretilen resimleri aşağıdaki klasör hiyerarşisine yerleştir

	gad/a/4-bgextract/runme.m
	gad/db/gait/frame001.png
	...
	gad/db/gait/frame153.png

4. `runme.m` i çalıştır

## incele

- http://maven.smith.edu/~nhowe/research/code/
- http://hct.ece.ubc.ca/research/shadows/Huang_Benson_496FinalReport.pdf
