VERSION 5.00
Object = "{EAB22AC0-30C1-11CF-A7EB-0000C05BAE0B}#1.1#0"; "shdocvw.dll"
Begin VB.Form frmMain 
   Caption         =   "frmMain"
   ClientHeight    =   11865
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   14295
   LinkTopic       =   "Form1"
   ScaleHeight     =   11865
   ScaleWidth      =   14295
   StartUpPosition =   3  'Windows-Standard
   Begin VB.Frame fraTasks 
      Caption         =   "Aufgaben"
      Height          =   4935
      Left            =   0
      TabIndex        =   6
      Top             =   6840
      Width           =   4695
      Begin VB.Timer tmrTask 
         Interval        =   60000
         Left            =   4200
         Top             =   3960
      End
      Begin VB.TextBox Text1 
         Height          =   375
         Left            =   120
         TabIndex        =   9
         Text            =   "Text1"
         Top             =   4440
         Width           =   3975
      End
      Begin VB.CommandButton cmdAdd 
         Caption         =   "&+"
         Height          =   375
         Left            =   4200
         TabIndex        =   8
         Top             =   4440
         Width           =   375
      End
      Begin VB.ListBox List1 
         Height          =   3765
         Left            =   120
         TabIndex        =   7
         Top             =   240
         Width           =   4455
      End
      Begin VB.Label lblTaskAdd 
         Caption         =   "Format: ""zeit[min]:page"
         Height          =   255
         Left            =   120
         TabIndex        =   10
         Top             =   4200
         Width           =   3975
      End
   End
   Begin VB.CommandButton cmdClose 
      Caption         =   "&Beenden"
      Height          =   375
      Left            =   12840
      TabIndex        =   5
      Top             =   10440
      Width           =   1335
   End
   Begin VB.Frame fraPage 
      Caption         =   "Seiteninfo"
      Height          =   615
      Left            =   0
      TabIndex        =   2
      Top             =   0
      Width           =   14175
      Begin VB.CommandButton Command1 
         Caption         =   "Insel"
         Height          =   255
         Left            =   3120
         TabIndex        =   4
         Top             =   240
         Width           =   855
      End
      Begin VB.TextBox txtSession 
         Height          =   285
         Left            =   120
         TabIndex        =   3
         Text            =   "session"
         Top             =   240
         Width           =   2895
      End
   End
   Begin VB.Frame fraWeb 
      Caption         =   "Website"
      Height          =   6015
      Left            =   0
      TabIndex        =   0
      Top             =   720
      Width           =   14175
      Begin SHDocVwCtl.WebBrowser webMain 
         Height          =   5655
         Left            =   120
         TabIndex        =   1
         Top             =   240
         Width           =   13935
         ExtentX         =   24580
         ExtentY         =   9975
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
         Location        =   ""
      End
   End
End
Attribute VB_Name = "frmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub WebBrowser1_StatusTextChange(ByVal Text As String)

End Sub

Private Sub Command1_Click()
    webMain.AddressBar = False
    Call webMain.Navigate("http://www.insel-monarchie.de/sid=6=" & txtSession.Text & "/game/login.php")
End Sub

Private Sub tmrTask_Timer()
    Debug.Print "Event triggered"
End Sub
