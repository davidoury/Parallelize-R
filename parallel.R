# install.packages('parallel) # one
library(parallel)

detectCores() # number of CPUs

cl = makeCluster(10) #12

# Don't forget to run this before quiting RStudio.
stopCluster(cl) 

as.list(1:10)
Sys.sleep(1)

lapply(X=as.list(1:10), FUN=function(x) { x^2 })

start.time = Sys.time()
invisible(lapply(X=as.list(1:10), 
                 FUN=function(x) { Sys.sleep(1) } ))
Sys.time() - start.time

start.time = Sys.time()
invisible(mclapply(X=as.list(1:10), 
                   FUN=function(x) { Sys.sleep(1) } ))
Sys.time() - start.time

start.time = Sys.time()
invisible(parLapply(cl=cl, 
                    X=as.list(1:10), 
                    fun=function(x) { Sys.sleep(1) } ))
Sys.time() - start.time

wait.function = function(x) { 
  Sys.sleep(1);
  x
}
wait.function(23)

start.time = Sys.time()
invisible(lapply(X=as.list(1:10), 
                   FUN=function(x) 
                   { lapply(X=as.list(1:10),
                            FUN=wait.function)
                   }
))
Sys.time() - start.time

# more efficient with inner mclapply
start.time = Sys.time()
invisible(mclapply(X=as.list(1:10), 
                   FUN=function(x) 
                   { mclapply(X=as.list(1:10),
                              FUN=wait.function)
                   }
))
Sys.time() - start.time

start.time = Sys.time()
clusterExport(cl, 'cl')
clusterExport(cl, 'wait.function')
clusterExport(cl, 'mclapply')
invisible(parLapply(cl=cl, 
                    X=as.list(1:10), 
                    fun=function(x) 
                      { mclapply(X=as.list(1:10),
                                 FUN=wait.function)}))
Sys.time() - start.time
