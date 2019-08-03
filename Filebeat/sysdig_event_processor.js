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
        evtInfo.split(" ").some(function(kvPair) {
            if (kvPair.indexOf("=") !== -1) {
                var splitted = kvPair.split("=")
                if (splitted[0] === "data") {
                    return true
                }
                event.Put("evt.infoExpanded." + splitted[0], splitted[1])
            }
        })
        if (evtInfo.match("data=")[0]) {
            var data = evtInfo.split("data=")[1]
            event.Put("evt.infoExpanded.data", data)
        }
    }
    if (evtInfo === "") {
        event.Put("evt.info", "no info")
    }
}
