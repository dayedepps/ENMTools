library(ape)
library(rgbif)
library(ENMTools)
hisp.anoles <- read.nexus(file = "./testdata/StarBEAST_MCC.species.txt")

keepers <- c("brevirostris", "marron", "caudalis", "websteri", "distichus")

hisp.anoles <- drop.tip(phy = hisp.anoles, tip = hisp.anoles$tip.label[!hisp.anoles$tip.label %in% keepers])
plot(hisp.anoles)


hisp.env <- stack(list.files("./testdata/Hispaniola_Worldclim", full.names = TRUE))
hisp.env <- setMinMax(hisp.env)



# Automate the process of downloading data and removing duds and dupes
species.from.gbif <- function(genus, species, name = NA, env){

  # Name it after the species epithet unless told otherwise
  if(is.na(name)){
    name <- species
  }

  # Get GBIF data
  this.sp <- enmtools.species(presence.points = gbif(genus = genus, species = species)[,c("lon", "lat")],
                              species.name = name)

  # Rename columns, get rid of duds
  colnames(this.sp$presence.points) <- c("Longitude", "Latitude")
  this.sp$presence.points <- this.sp$presence.points[complete.cases(extract(env, this.sp$presence.points)),]
  this.sp$presence.points <- this.sp$presence.points[!duplicated(this.sp$presence.points),]

  this.sp$range <- background.raster.buffer(this.sp$presence.points, 50000, mask = hisp.env)

  return(this.sp)
}



brevirostris <- species.from.gbif(genus = "Anolis", species = "brevirostris", env = hisp.env)
marron <- species.from.gbif(genus = "Anolis", species = "marron", env = hisp.env)
caudalis <- species.from.gbif(genus = "Anolis", species = "caudalis", env = hisp.env)
websteri <- species.from.gbif(genus = "Anolis", species = "websteri", env = hisp.env)
distichus <- species.from.gbif(genus = "Anolis", species = "distichus", env = hisp.env)


brev.clade <- enmtools.clade(species = list(brevirostris, marron, caudalis, websteri, distichus), tree = hisp.anoles)
check.clade(brev.clade)

# brev.dm <- enmtools.dm(species = brevirostris, env = hisp.env, test.prop = 0.2)
# brev.glm <- enmtools.glm(species = brevirostris, env = hisp.env, test.prop = 0.2)
# visualize.enm(brev.glm, hisp.env, layers = c("snv_1", "snv_10"))

test1 <- enmtools.glm(marron, hisp.env[[1]])
test2 <- enmtools.gam(marron, hisp.env[[1]])
test3 <- enmtools.dm(marron, hisp.env[[1]])
test4 <- enmtools.bc(marron, hisp.env[[1]])
test5 <- enmtools.maxent(marron, hisp.env[[1]])

bc.aoc <- enmtools.aoc(clade = brev.clade,  nreps = 50, env = hisp.env, overlap.source = "bc")

range.aoc <- enmtools.aoc(clade = brev.clade,  nreps = 50, overlap.source = "range")

point.aoc <- enmtools.aoc(clade = brev.clade,  nreps = 50, overlap.source = "points")

gam.aoc <- enmtools.aoc(clade = brev.clade,  env = hisp.env, nreps = 50, overlap.source = "gam")
