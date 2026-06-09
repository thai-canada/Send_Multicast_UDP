' plugin name: udp

Function udp_Initialize(msgPort As Object, userVariables As Object, bsp as Object)
    h = {}
    h.version = "1.00.02"
    h.msgPort = msgPort
    h.userVariables = userVariables
    h.bsp = bsp
    h.SystemLog = CreateObject("roSystemLog")
    h.ProcessEvent = udp_ProcessEvent

    h.multicastAddress = "255.255.255.255" 
    h.multicastPort = 5000 ' same port to all players
    h.sender = invalid

    sleep(1000)
    payload$ = "hello world " + h.version

    udp_PluginInit(h)
    if type(h.sender) = "roDatagramSender" then
        h.sender.SetDestination(h.multicastAddress, h.multicastPort)
        h.sender.Send(payload$)
        h.SystemLog.SendLine("------------------ Sending multicast UDP to " + h.multicastAddress + ":" + h.multicastPort.ToStr() + " payload=" + payload$)
    else
        h.SystemLog.SendLine("------------------ ERROR: roDatagramSender is invalid")
    end if

    return h
End Function

Function udp_ProcessEvent(event As Object) as boolean
    return false
End Function

Sub udp_PluginInit(m as Object)
    if type(m.sender) <> "roDatagramSender" then
        m.sender = CreateObject("roDatagramSender")
    end if
End Sub
