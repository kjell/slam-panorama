pano.tif:
	convert $$(ls 3*.tif | sort -d | tail -n+2) 341953dig_10.tif +append pano.tif

share:
	cp -R * ~/Public/slam-panorama/
