Attribute VB_Name = "basActions"
Option Explicit

Public Sub openExternalFile(ByVal strFile As String)
    
    Dim objFile As Object
    Set objFile = CreateObject("Scripting.FileSystemObject")
    
    If objFile.FileExists(strFile) Then
        Dim objText As Object
        Set objText = objFile.OpenTextFile(strFile, 1)
        frmSourcecode.txtSourcecode.Text = objText.ReadAll
        frmSourcecode.Caption = strFile
        
'        Call getCodeFunctions(txtSourcecode, lstFunctions)
    Else
        MsgBox "Datei Existiert nicht ?:-("
    End If
End Sub

