USE_NITRO = NO

TEXT1 		:= Nintendo DS
TEXT2 		:= Project
TEXT3 		:= by GEMISIS
ICON 		:= -b C:/devkitPro/libnds/icon.bmp

#---------------------------------------------------------------------------------
.SUFFIXES:
#---------------------------------------------------------------------------------

ifeq ($(strip $(DEVKITARM)),)
$(error "Please set DEVKITARM in your environment. export DEVKITARM=<path to>devkitARM")
endif

include $(DEVKITARM)/ds_rules

#---------------------------------------------------------------------------------
# TARGET is the name of the output
# BUILD is the directory where object files & intermediate files will be placed
# SOURCES is a list of directories containing source code
# DATA is a list of directories containing binary data
# INCLUDES is a list of directories containing extra header files
# GRAPHICS is a list of directories containing files to be processed by grit
# AUDIO is a list of directories containing files to be processed by mmutil
# SOUNDBANK_NAME is the name of the maxmod generated soundbank
#
# All directories are specified relative to the project directory where
# the makefile is found.
#
#---------------------------------------------------------------------------------
#TARGET		:=	$(notdir $(CURDIR))
BUILD		:=	build
SOURCES		:=	source source/graphics source/general source/game source/dataManager source/sounds source/wifi
DATA		:=	data
INCLUDES	:=	include include/graphics include/general include/game include/dataManager include/sounds include/wifi
GRAPHICS	:=	gfx
SPRITES		:= gfx/sprites
MAPS		:= gfx/maps
TILES		:= gfx/tiles
BACKGROUNDS	:= gfx/backgrounds
FONTS		:= gfx/fonts
AUDIO		:=	audio
SOUNDBANK_NAME  :=	soundbank
MUSIC       :=  music
NITRODATA	:=	nitrofiles

#---------------------------------------------------------------------------------
# options for code generation
#---------------------------------------------------------------------------------
ARCH	:=	-mthumb -mthumb-interwork

CFLAGS	:=	-g -Wall -O2\
 		-march=armv5te -mtune=arm946e-s -fomit-frame-pointer\
		-ffast-math \
		$(ARCH)

CFLAGS	+=	$(INCLUDE) -DARM9
CXXFLAGS	:= $(CFLAGS) -fno-rtti -fno-exceptions

ASFLAGS	:=	-g $(ARCH)
LDFLAGS	=	-specs=ds_arm9.specs -g $(ARCH) -Wl,-Map,$(notdir $*.map)


#---------------------------------------------------------------------------------
# any extra libraries we wish to link with the project
#---------------------------------------------------------------------------------
LIBS	:= -lfilesystem -lfat -lnds9 -ldswifi9 -lmm9

#---------------------------------------------------------------------------------
# list of directories containing libraries, this must be the top level containing
# include and lib
#---------------------------------------------------------------------------------
LIBDIRS	:=	$(LIBNDS)

#---------------------------------------------------------------------------------
# no real need to edit anything past this point unless you need to add additional
# rules for different file extensions
#---------------------------------------------------------------------------------
ifneq ($(BUILD),$(notdir $(CURDIR)))
#---------------------------------------------------------------------------------
 
export ARM9ELF	:=	$(CURDIR)/$(TARGET).elf
export OUTPUT	:=	$(CURDIR)/$(TARGET)
 
export VPATH	:=	$(foreach dir,$(SOURCES),$(CURDIR)/$(dir)) \
			$(foreach dir,$(DATA),$(CURDIR)/$(dir)) \
			$(foreach dir,$(GRAPHICS),$(CURDIR)/$(dir)) \
			$(foreach dir,$(SPRITES),$(CURDIR)/$(dir)) \
			$(foreach dir,$(BACKGROUNDS),$(CURDIR)/$(dir)) \
			$(foreach dir,$(MAPS),$(CURDIR)/$(dir)) \
			$(foreach dir,$(TILES),$(CURDIR)/$(dir)) \
			$(foreach dir,$(FONTS),$(CURDIR)/$(dir)) \
			$(foreach dir,$(AUDIO),$(CURDIR)/$(dir))

export DEPSDIR	:=	$(CURDIR)/$(BUILD)

CFILES		:=	$(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.c)))
CPPFILES	:=	$(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.cpp)))
SFILES		:=	$(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.s)))
BINFILES	:=	$(foreach dir,$(DATA),$(notdir $(wildcard $(dir)/*))) mmsolution.bin
PNGFILES	:=	$(foreach dir,$(GRAPHICS),$(notdir $(wildcard $(dir)/*.png)))
SPRFILES	:=  $(foreach dir,$(SPRITES),$(notdir $(wildcard $(dir)/*.spr.png)))
BGFILES		:=  $(foreach dir,$(BACKGROUNDS),$(notdir $(wildcard $(dir)/*.bg.png)))
MAPFILES	:=  $(foreach dir,$(MAPS),$(notdir $(wildcard $(dir)/*.map.png)))
TILEFILES	:=  $(foreach dir,$(TILES),$(notdir $(wildcard $(dir)/*.tiles.png)))
FNTFILES	:=  $(foreach dir,$(FONTS),$(notdir $(wildcard $(dir)/*.fnt.png)))
BMPFILES	:=	$(foreach dir,$(GRAPHICS),$(notdir $(wildcard $(dir)/*.bmp)))
CMDFILES	:=  $(foreach dir,$(GRAPHICS),$(notdir $(wildcard $(dir)/*.cmd)))
export MODFILES	:=	$(foreach dir,$(notdir $(wildcard $(MUSIC)/*.*)),$(CURDIR)/$(MUSIC)/$(dir))

#---------------------------------------------------------------------------------
# use CXX for linking C++ projects, CC for standard C
#---------------------------------------------------------------------------------
ifeq ($(strip $(CPPFILES)),)
#---------------------------------------------------------------------------------
	export LD	:=	$(CC)
#---------------------------------------------------------------------------------
else
#---------------------------------------------------------------------------------
	export LD	:=	$(CXX)
#---------------------------------------------------------------------------------
endif
#---------------------------------------------------------------------------------

export OFILES		:=	$(addsuffix .o,$(BINFILES)) \
				$(PNGFILES:.png=.o) \
				$(SPRFILES:.spr.png=.o) \
				$(BGFILES:.bg.png=.o) \
				$(MAPFILES:.map.png=.o) \
				$(TILEFILES:.tiles.png=.o) \
				$(FNTFILES:.fnt.png=.o) \
				$(BMPFILES:.bmp=.o) \
				$(CMDFILES:.cmd=.o) \
				$(CPPFILES:.cpp=.o) \
				$(CFILES:.c=.o) \
				$(SFILES:.s=.o) \

export AUDIOFILES	:=	$(foreach dir,$(AUDIO),$(notdir $(wildcard $(dir)/*)))
 
export INCLUDE		:=	$(foreach dir,$(INCLUDES),-I$(CURDIR)/$(dir)) \
				$(foreach dir,$(LIBDIRS),-I$(dir)/include) \
				$(foreach dir,$(LIBDIRS),-I$(dir)/include) \
				-I$(CURDIR)/$(BUILD)
 
export LIBPATHS		:=	$(foreach dir,$(LIBDIRS),-L$(dir)/lib)

.PHONY: $(BUILD) clean
 
#---------------------------------------------------------------------------------
$(BUILD):
	@[ -d $@ ] || mkdir -p $@
	@$(MAKE) --no-print-directory -C $(BUILD) -f $(CURDIR)/Makefile
 
#---------------------------------------------------------------------------------
clean:
	@echo clean ...
	@rm -fr $(BUILD) *.elf *.nds* *.bin 
 
#---------------------------------------------------------------------------------
else
 
#---------------------------------------------------------------------------------
# main targets
#---------------------------------------------------------------------------------
$(ARM9ELF)	:	$(OFILES)
	@echo linking $(notdir $@)
	@$(LD)  $(LDFLAGS) $(OFILES) $(LIBPATHS) $(LIBS) -o $@

#---------------------------------------------------------------------------------
# The bin2o rule should be copied and modified
# for each extension used in the data directories
#---------------------------------------------------------------------------------

#---------------------------------------------------------------------------------
# This rule creates object files from binary data with the .bin extension
#---------------------------------------------------------------------------------
%.bin.o	: %.bin
#---------------------------------------------------------------------------------
	@echo $(notdir $<)
	@$(bin2o)

#---------------------------------------------------------------------------------
# This rule creates object files from binary data with the .bin extension
#---------------------------------------------------------------------------------
%.mdat.o	: %.mdat
#---------------------------------------------------------------------------------
	@echo $(notdir $<)
	@$(bin2o)

#---------------------------------------------------------------------------------
# This rule creates object files from binary data with the .bin extension
#---------------------------------------------------------------------------------
%.wav.o	: %.wav
#---------------------------------------------------------------------------------
	@echo $(notdir $<)
	@$(bin2o)

#---------------------------------------------------------------------------------
# This rule creates object files from binary data with the .pcx extension
#---------------------------------------------------------------------------------
%.cmd.o	:	%.cmd
#---------------------------------------------------------------------------------
	@echo $(notdir $<)
	@$(bin2o)

#---------------------------------------------------------------------------------
# rule to build solution from music files
#---------------------------------------------------------------------------------
mmsolution.bin : $(MODFILES)
#---------------------------------------------------------------------------------
	@mmutil $^ -d -ommsolution.bin -hmmsolution.h

#---------------------------------------------------------------------------------
# This rule creates assembly source files using grit.
# grit takes an image file and a .grit file describing how the file is to be
# processed.
#---------------------------------------------------------------------------------
%.s %.h	: %.gif %.grit
#---------------------------------------------------------------------------------
	grit $< -fts -o$*

#---------------------------------------------------------------------------------
%.s %.h	: %.png %.grit
#---------------------------------------------------------------------------------
	grit $< -fts -o$*

#---------------------------------------------------------------------------------
%.s %.h	: %.bmp %.grit
#---------------------------------------------------------------------------------
	grit $< -fts -o$*

#---------------------------------------------------------------------------------
%.pcx.o	:	%.pcx
#---------------------------------------------------------------------------------
	@echo $(notdir $<)
	@$(bin2o)

#---------------------------------------------------------------------------------
%.s %.h : %.spr.png
	grit $< -ff../gfx/sprites/sprite.grit -o$*
#---------------------------------------------------------------------------------
 
#---------------------------------------------------------------------------------
%.s %.h : %.bg.png
	grit $< -ff../gfx/backgrounds/background.grit -o$*
#---------------------------------------------------------------------------------
 
#---------------------------------------------------------------------------------
%.s %.h : %.map.png
	grit $< -ff../gfx/maps/maps.grit -o$*
#---------------------------------------------------------------------------------

#---------------------------------------------------------------------------------
%.s %.h : %.tiles.png
	grit $< -ff../gfx/tiles/tiles.grit -o$*
#---------------------------------------------------------------------------------

#---------------------------------------------------------------------------------
%.s %.h : %.fnt.png
	grit $< -ff../gfx/fonts/font.grit -o$*
#---------------------------------------------------------------------------------
 
#---------------------------------------------------------------------------------
# This rule creates the soundbank file for your project using mmutil.
# mmutil takes all audio files in the audio folder and puts them into a
# soundbank file.
#---------------------------------------------------------------------------------
$(SOUNDBANK_NAME).bin : $(AUDIOFILES)
#---------------------------------------------------------------------------------
	@echo $(notdir $^)
	@mmutil -d $^ -o$(SOUNDBANK_NAME).bin -h$(SOUNDBANK_NAME).h

 
-include $(DEPSDIR)/*.d
 
#---------------------------------------------------------------------------------------
endif
#---------------------------------------------------------------------------------------
