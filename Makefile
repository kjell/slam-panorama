pano.tif:
	convert $$(ls 3*.tif | sort -t'_' -k2n) +append pano.tif

pano-grid.tif:
	convert \( $$(ls 3*_{1..5}.tif) +append \) \
		\( $$(ls 3*_{6..9}.tif) 341953dig_10.tif +append \) \
		\( $$(ls 3*_{11..15}.tif) +append \) \
		\( $$(ls 3*_{16..20}.tif) +append \) \
		\( $$(ls 3*_{21..25}.tif) +append \) \
		-background none -append pano-grid.tif

reference:
	exiftool -TransmissionReference=341953 *.tif

tile:
	for i in *.tif; do \
		if [[ ! -f $${i/%tif/mbtiles} ]]; then \
			echo $$i; \
			~/tmp/tilesaw/tilesaw.sh $$i; \
		fi; \
	done

metadata: 341953.xlsx
	xlsx2csv $< > $@.csv

share:
	cp -R * ~/Public/slam-panorama/

upload_tiles:
	scp *_*.mbtiles dx:/data/tiles
	scp pano.mbtiles dx:/data/tiles/slam-mississippi-pano.mbtiles
