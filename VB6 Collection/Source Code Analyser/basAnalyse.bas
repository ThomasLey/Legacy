Attribute VB_Name = "basAnalyse"
Option Explicit

Public Sub getCodeFunctions( _
    ByRef txtSourcecode As TextBox, _
    ByRef lstFunctions As ListBox)

    Dim varArray As Variant
    Dim i As Integer
    Dim strTmp As String
    lstFunctions.Clear
    varArray = Split(txtSourcecode.Text, Chr(13) & Chr(10))

    For i = 0 To UBound(varArray)
        If UCase(Left(varArray(i), 7)) = "PRIVATE" Then
            strTmp = Right(varArray(i), 8)
            strTmp = Mid(strTmp, 1, InStr(1, strTmp, " "))
            Call lstFunctions.AddItem(strTmp)
        End If
        If UCase(Left(varArray(i), 6)) = "PUBLIC" Then
            Call lstFunctions.AddItem(varArray(i))
        End If
    Next i

End Sub

