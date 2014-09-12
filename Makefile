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

thumbnail:
	vipsthumbnail *.tif --size=500 -o tn_%s.png
	scp tn_* dx:/apps/cdn/thumbs/

metadata: 341953.xlsx
	xlsx2csv $< > $@.csv

share:
	rsync -avz --exclude='*.mbtiles' --exclude=tiles . ~/Public/slam-panorama

upload_tiles:
	rsync -avz *_*.mbtiles dx:/data/tiles
	rsync -avz pano.mbtiles dx:/data/tiles/slam-mississippi-pano.mbtiles
	rsync -avz pano-grid.mbtiles dx:/data/tiles/slam-mississippi-pano-grid.mbtiles
