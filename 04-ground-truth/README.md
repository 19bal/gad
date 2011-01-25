
1. [Video](http://groups.inf.ed.ac.uk/vision/CAVIAR/CAVIARDATA2/OneStopMoveNoEnter1front/OneStopMoveNoEnter1front.mpg) temin et 
   ve `*.png` resimleri üret.

    + `ffmpeg -i OneStopMoveNoEnter1front.mpg frame%04d.png`

	+ bu resimleri, bu dizinde `_db/orj/` klasörü altına koy

2. Bu video'nun [xml](http://groups.inf.ed.ac.uk/vision/CAVIAR/CAVIARDATA2/OneStopMoveNoEnter1front/fosmne1gt.xml) ilgili adresten indir.

    + [xml toolbox](http://www.mathworks.com/matlabcentral/fileexchange/4278) adresinden indirin.

	+ `xml_toolbox` ı kurmak için indirdiğiniz dosya içindeki `INSTALL.txt`'i okuyunuz.

	+ indirdiğiniz `fosmne1gt.xml` dosyasını, bu dizinde `_db/` klasörü altına
	  koyunuz.

3. `runme.m`'i çalıştır.
