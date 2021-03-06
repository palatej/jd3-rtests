source("./R files/jd3_init.R")

ts_r2jd<-function(s){
  if (is.null(s)){
    return (NULL)
  }
  freq<-frequency(s)
  start<-start(s)
  .jcall("demetra/r/TsUtility", "Ldemetra/timeseries/TsData;", "of", 
         as.integer(freq), as.integer(start[1]), as.integer(start[2]), as.double(s))
  }

tsdomain_r2jd<-function(period, startYear, startPeriod, length){
  .jcall("demetra/r/TsUtility", "Ldemetra/timeseries/TsDomain;", "of", 
         as.integer(period), as.integer(startYear), as.integer(startPeriod), as.integer(length))
}


ts_jd2r<-function(s){
  if (is.null(s)){
    return (NULL)
  }
  pstart<-.jcall("demetra/r/TsUtility", "[I", "startPeriod", s)
  jx<-.jcall(s, "Ldemetra/data/DoubleSeq;", "getValues")
  x<-.jcall(jx, "[D", "toArray")
  ts(x,start=pstart[2:3], frequency=pstart[1])
}

matrix_jd2r<-function(s){
  if (is.jnull(s)){
    return (NULL)
  }
  nr<-.jcall(s, "I", "getRowsCount")
  nc<-.jcall(s, "I", "getColumnsCount")
  d<-.jcall(s, "[D", "toArray")
  return (array(d, dim=c(nr, nc)))
}

matrix_r2jd<-function(s){
  if (is.null(s))
    return (.jnull("demetra/maths/matrices/Matrix"))
  if (!is.matrix(s)){
    s<-matrix(s, nrow=length(s), ncol=1)
  }
  sdim<-dim(s)
  return (.jcall("demetra/maths/matrices/Matrix","Ldemetra/maths/matrices/Matrix;", "ofInternal", as.double(s), as.integer(sdim[1]), as.integer(sdim[2])))
}

jd3_aggregate<-function(s, nfreq=1, conversion="Sum", complete=TRUE){
  if (is.null(s)){
    return (NULL)
  }
  jd_s<-ts_r2jd(s)
  jd_agg<-.jcall("demetra/r/TsUtility", "Ldemetra/timeseries/TsData;", "aggregate", jd_s, 
               as.integer(nfreq), conversion, complete); 
  if (is.null(jd_agg)){
    return (NULL);
  }
  else{
    return (ts_jd2r(jd_agg))
  }
}
