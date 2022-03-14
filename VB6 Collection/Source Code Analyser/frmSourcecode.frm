VERSION 5.00
Begin VB.Form frmSourcecode 
   Caption         =   "Form1"
   ClientHeight    =   4695
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   9585
   LinkTopic       =   "Form1"
   MDIChild        =   -1  'True
   ScaleHeight     =   4695
   ScaleWidth      =   9585
   Begin VB.TextBox txtSourcecode 
      Height          =   3975
      Left            =   0
      Locked          =   -1  'True
      MultiLine       =   -1  'True
      ScrollBars      =   3  'Beides
      TabIndex        =   0
      Text            =   "frmSourcecode.frx":0000
      Top             =   0
      Width           =   8775
   End
End
Attribute VB_Name = "frmSourcecode"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Public Sub showForm()
    setLayout
End Sub

Private Sub setLayout()
    If Not Me.WindowState = vbMinimized Then
        txtSourcecode.Width = frmSourcecode.ScaleWidth
        txtSourcecode.Height = frmSourcecode.ScaleHeight
    End If
End Sub

Private Sub Form_Resize()
    setLayout
End Sub
