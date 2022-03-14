VERSION 5.00
Object = "{EAB22AC0-30C1-11CF-A7EB-0000C05BAE0B}#1.1#0"; "shdocvw.dll"
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   7935
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   8475
   LinkTopic       =   "Form1"
   ScaleHeight     =   7935
   ScaleWidth      =   8475
   StartUpPosition =   3  'Windows-Standard
   Begin VB.Timer Timer1 
      Interval        =   30000
      Left            =   360
      Top             =   1080
   End
   Begin VB.TextBox Text1 
      Height          =   375
      Left            =   240
      TabIndex        =   1
      Text            =   "http://s1.insel-monarchie.de/sid=6=gN2ORIblRQm8xrqQTL/game/building_2.php?building=haupthaus"
      Top             =   2520
      Width           =   7935
   End
   Begin SHDocVwCtl.WebBrowser WebBrowser1 
      Height          =   3975
      Left            =   240
      TabIndex        =   0
      Top             =   3720
      Width           =   7215
      ExtentX         =   12726
      ExtentY         =   7011
      ViewMode        =   0
      Offline         =   0
      Silent          =   0
      RegisterAsBrowser=   0
      RegisterAsDropTarget=   1
      AutoArrange     =   0   'False
      NoClientEdge    =   0   'False
      AlignLeft       =   0   'False
      NoWebView       =   0   'False
      HideFileNames   =   0   'False
      SingleClick     =   0   'False
      SingleSelection =   0   'False
      NoFolders       =   0   'False
      Transparent     =   0   'False
      ViewID          =   "{0057D0E0-3573-11CF-AE69-08002B2E1262}"
      Location        =   "http:///"
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub Form_Load()
Randomize (100)
End Sub

Private Sub Timer1_Timer()
Me.WebBrowser1.Navigate (Text1.Text)
Timer1.Interval = Timer1.Interval + 100
End Sub
