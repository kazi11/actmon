# This sets up the DAM experiment class and its native methods.

setClass("DAM", slots = c(data = "data.frame", sample_info = "data.frame"))

newExperiment <- function(dataFile = NULL, infoFile = NULL) {
  if (is.null(dataFile) || is.null(infoFile)) {
    warning("One or more arguments is missing from DAM constructor.")
  }
  new("DAM", data = dataFile, sample_info = infoFile)
}

# A more generic function to subset your data by whichever column you freaking
# want. Even works on vectors, so you can subset by multiple values of an
# attribute at a time.
setGeneric("byAttribute", function(obj, string, col) {standardGeneric("byAttribute")})
setMethod(f = "byAttribute", signature = "DAM",
          definition = function(obj, string, col) {
            #figure out which column in the info file to read from
            col <- as.character(col)
            numCol <- which(colnames(obj@sample_info) == col)

            # subset sampleinfo
            string <- as.character(string)
            idx <- which(obj@sample_info[, numCol] %in% string)
            obj@sample_info <- obj@sample_info[idx, ]

            # subset data
            lightsCol <- which(colnames(obj@data) == "light_status")
            offsetIdx <- lightsCol + idx
            obj@data <- obj@data[, c(1:lightsCol, offsetIdx)]

            return(obj)
          })

# Equivalent to byAttribute(), but drops data by a value instead. Works on vectors.
setGeneric("dropAttribute", function(obj, string, col) {standardGeneric("dropAttribute")})
setMethod(f = "dropAttribute", signature = "DAM",
          definition = function(obj, string, col) {
            #figure out which column in the info file to read from
            col <- as.character(col)
            numCol <- which(colnames(obj@sample_info) == col)

            # subset sampleinfo
            string <- as.character(string)
            idx <- which(obj@sample_info[, numCol] %in% string)
            obj@sample_info <- obj@sample_info[-idx, ]

            # subset data
            lightsCol <- which(colnames(obj@data) == "light_status")
            offsetIdx <- lightsCol + idx
            obj@data <- obj@data[, -offsetIdx]

            return(obj)
          })

# Use this function to mash experiments together. There is no restriction to
# doing this by timestamp, etc. - so be careful what you combine. The vial
# indices in the second experiment are relabeled to start where the first
# experiment stops.
setGeneric("catExperiments", function(obj1, obj2) {standardGeneric("catExperiments")})
setMethod(f = "catExperiments", signature = "DAM",
          definition = function(obj1, obj2) {
            # retrieve last vial# in obj1
            last <- colnames(obj1@data)[length(colnames(obj1@data))]

            # rename all vial#s in obj2
            numVials <- length(obj2@sample_info[, 1])
            obj2@sample_info[, 1] <- (last + 1):numVials

            lightsCol <- which(colnames(obj2@data) == "light_status")
            colnames(obj2@data)[lightsCol + 1:numVials] <- (last + 1):numVials

            # combine objects
            obj1@sample_info <- rbind(obj1@sample_info, obj2@sample_info)

            # cut data down to smaller experiments' size THEN combine
            long1 <- length(obj1@data[, 1])
            long2 <- length(obj2@data[, 1])
            if (long1 != long2) {
              warning("Data is of unequal length. Coercing to equal size
                      (data at the end of the longer experiment will be lost).")
              if (long1 > long2) {
                obj1@data <- obj1@data[1:long2, ]
              } else {
                obj2@data <- obj2@data[1:long2, ]
              }
            }
            obj1@data <- cbind(obj1@data, getVals(obj2@data))

            return(obj1)
          })

# Iterate through possible variations of an attribute in your dataset,
# calculating averages/standard error of the mean/stats for each. Returns a
# DAMstats object.
setGeneric("calcStats", function(obj, attribute) {standardGeneric("calcStats")})
setMethod("calcStats", signature = "DAM",
          definition = function(obj, attribute){
            # retrieve all values
            stat <- newStats(obj, attribute)
            col <- which(colnames(obj@sample_info) == attribute)
            variable <- obj@sample_info[, col]

            # iterate through values and calc stats
            i <- 1
            for (var in variable) {
              temp <- getVals(byAttribute(obj, var, attribute))
              stat@averages[, i] <- rowMeans(temp)
              stat@SEM[, i] <- apply(as.matrix(temp), 1, stdError)
              i <- i + 1
            }

            return(stat)
          })