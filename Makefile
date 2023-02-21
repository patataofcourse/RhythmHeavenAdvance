#######################
# RHAdvance Makefile  #
# - by patataofcourse #
#######################

PERL 		:= perl
ARMIPS 		:= armips
ABCDE 		:= $(PERL) tools/abcde/abcde.pl

#TODO: find non-wine alternatives
4BMPP		:= wine tools/4bmpp.exe
DSDECMP 	:= wine tools/DSDecmp.exe

ifneq ($(shell which armips), 0)
ARMIPS		:= wine tools/armips.exe
endif

ifneq ($(shell which perl), 0)
ARMIPS		:= wine tools/armips.exe
endif

BUILD 		:= build
GFX 		:= gfx
SOURCE 		:= src

ROM_OG 		:= rh-jpn.gba
ROM_ATLUS 	:= $(BUILD)/rh-atlus.gba
ROM_FINAL	:= $(BUILD)/rh-eng.gba

SCRIPT 		:= $(SOURCE)/script.txt
MAINASM		:= $(SOURCE)/main.asm
BMPFILES 	:= $(wildcard $(GFX)/**/**/*.bmp)
CDATFILES	:= $(BMPFILES:.bmp=.cdat)

.PHONY: clean gfx

# todo: check SHA1 checksum of OG ROM
$(ROM_FINAL): build $(ROM_ATLUS) gfx
	@$(ARMIPS) $(MAINASM)

clean:
	@echo clean ...
	@rm -rf build *.cdat

build:
	@echo Build directory missing, making
	@mkdir build

$(ROM_ATLUS): $(SCRIPT)
	@cp -f $(ROM_OG) $(ROM_ATLUS)
	@echo -n "Injecting custom script... "
	@$(ABCDE) -cm abcde::Atlas $(ROM_ATLUS) $(SCRIPT)
	@echo Done!

gfx: $(CDATFILES)

%.cdat: %.bin
	@$(DSDECMP) -c lz10 $< $(basename $<)

%.bin: %.bmp
	@$(4BMPP) -p $<
