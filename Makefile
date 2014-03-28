
ZIPNAME=osg-chrome-app.zip
# coffeefiles := coffee/settings.coffee coffee/graph.coffee coffee/graphContainerCtrl.coffee coffee/graphService.coffee 
# compiledcofee := $(coffeefiles:%.coffee=%.js)

clean:
	rm -f $(ZIPNAME)

coffee/%.js: coffee/%.coffee
	coffee -c $<

all: coffee/*.js
	
	zip -r $(ZIPNAME) js/*
	zip -r $(ZIPNAME) html/*
	zip -r $(ZIPNAME) manifest.json
	zip -r $(ZIPNAME) fonts/*
	zip -r $(ZIPNAME) css/*
	zip -r $(ZIPNAME) data/*
	zip -r $(ZIPNAME) main.html
	zip -r $(ZIPNAME) osglogo.16.png

