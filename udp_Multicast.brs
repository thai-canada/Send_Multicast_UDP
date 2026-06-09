' plugin name: udp
Function udp_Initialize(msgPort As Object, userVariables As Object, bsp as Object)
    h = {}
    h.version = "1.00.02"
    h.msgPort = msgPort
    h.userVariables = userVariables
    h.bsp = bsp
    h.SystemLog = CreateObject("roSystemLog")

	h.HandleTimerEvent = HandleTimerEvent
    h.ProcessEvent = udp_ProcessEvent
	

    h.multicastAddress = "255.255.255.255" 
    h.multicastPort = 5000 ' same port to all players
    h.sender = invalid


    ' Create a recurring system timer to safely check the background discovery port
    h.timer = CreateObject("roTimer")
    h.timer.SetPort(msgPort) ' Hooked to main port to trigger ProcessEvent safely
    
    ' Check the background queue every 1 second (1 second, 0 microseconds)
    h.timer.SetElapsed(1, 0) 
    h.timer.Start()

    return h
End Function


Function udp_ProcessEvent(event As Object) as boolean

    if type(event) = "roTimerEvent" then
		retval = HandleTimerEvent(event, m)	
	else if type(event) = "roHtmlWidgetEvent" then
		'eventData = event.GetData()
		if type(eventData) = "roAssociativeArray" and type(eventData.reason) = "roString" then
		end if		
	end if

    return false
End Function


Function HandleTimerEvent(origMsg as Object, m as Object) as boolean
	
	payload$ = "hello world " + m.version

	udp_PluginInit(m)
	if type(m.sender) = "roDatagramSender" then
		m.sender.SetDestination(m.multicastAddress, m.multicastPort)
		m.sender.Send(payload$)
		m.SystemLog.SendLine("------------------ Sending multicast UDP to " + m.multicastAddress + ":" + m.multicastPort.ToStr() + " payload=" + payload$)
	else
		m.SystemLog.SendLine("------------------ ERROR: roDatagramSender is invalid")
	end if
	return false
End Function


Sub udp_PluginInit(m as Object)
    if type(m.sender) <> "roDatagramSender" then
        m.sender = CreateObject("roDatagramSender")
    end if
End Sub

