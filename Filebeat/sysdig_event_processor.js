function process(event) {
  // convert evt.time to human readable
  var outTime = event.Get("evt.outputtime")
  if (outTime) {
    event.Put("evt.outputtime", new Date(outTime / 1000000).toISOString())
  }

  // rename evt.* (so it becomes nested)
  Object.keys(event.Get()).forEach(function(key) {
    if (key.lastIndexOf("evt.", 0) === 0) {
      var oldVal = event.Get(key)
      event.Delete(key)
      event.Put(key, oldVal)
    }
  })

  // expand evt.info
  var evtInfo = event.Get("evt")["info"]
  if (evtInfo !== null && evtInfo !== "") {
    evtInfo.split(" ").forEach(function(kvPair) {
      var equalityPosition = kvPair.indexOf("=")
      if (equalityPosition !== -1) {
        var key = kvPair.substring(0, equalityPosition)
        var value = kvPair.substring(equalityPosition + 1)
        if (key != "" && value != "") {
            event.Put("evt.infoExpanded." + key, value)
        }
      }
    })
  }

  // get source ip for "accept"
  if (event.Get("evt.type") === "accept") {
    var rawTuple = event.Get("evt.infoExpanded.tuple")
    if (rawTuple) {
      var ipPattern = /^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}/
      var srcIp = rawTuple.match(ipPattern)[0]
      if (srcIp) {
          event.Put("evt.infoExpanded.sourceip", srcIp)
      }
    }
  }

}
