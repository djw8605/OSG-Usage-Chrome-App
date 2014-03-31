
ZIPNAME=osg-chrome-app.zip
ZIP=zip -r $(ZIPNAME)
# coffeefiles := coffee/settings.coffee coffee/graph.coffee coffee/graphContainerCtrl.coffee coffee/graphService.coffee 
# compiledcofee := $(coffeefiles:%.coffee=%.js)

all: package

clean:
	rm -f $(ZIPNAME)

coffee/%.js: coffee/%.coffee
	coffee -c $<



	
package: $(ZIPNAME)

$(ZIPNAME): js/* coffee/*.js html/* manifest.json fonts/* css/* data/* main.html osglogo.16.png
	$(ZIP) $^

