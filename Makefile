pano.tif:
	convert $$(ls 3*.tif | sort -d | tail -n+2) 341953dig_10.tif +append pano.tif

reference:
	exiftool -TransmissionReference=341953 *.tif

metadata: 341953.xlsx
	xlsx2csv $< > $@.csv

share:
	cp -R * ~/Public/slam-panorama/

upload_tiles:
	scp *_*.mbtiles dx:/data/tiles
	scp pano.mbtiles dx:/data/tiles/slam-mississippi-pano.mbtiles
