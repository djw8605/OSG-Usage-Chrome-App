
ZIPNAME=osg-chrome-app.zip

clean:
	rm -f $(ZIPNAME)

all:
	zip -r $(ZIPNAME) js/*
	zip -r $(ZIPNAME) html/*
	zip -r $(ZIPNAME) manifest.json
	zip -r $(ZIPNAME) fonts/*
	zip -r $(ZIPNAME) css/*
	zip -r $(ZIPNAME) data/*
	zip -r $(ZIPNAME) main.html
	zip -r $(ZIPNAME) osglogo.16.png

