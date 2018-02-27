Set objShell = CreateObject("WScript.Shell")
Set objEnv = objShell.Environment("System")
 
'What we want to add
PathToAdd_1 = "C:\Python27"
PathToAdd_2 = "C:\Python27\Scripts"
PathToAdd_3 = "C:\OpenSSH-Win64"
 
'Get the current value of Path
oldSystemPath = objEnv("PATH")
 
'Build the new Path
newSystemPath = oldSystemPath & ";" & PathToAdd_1 & ";" & PathToAdd_2 & ";" & PathToAdd_3
 
'Set the new Path
objEnv("PATH") = newSystemPath
 
wscript.echo "!The environment variables were updated successfully"
