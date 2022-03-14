VERSION 5.00
Begin VB.Form frmProjectdirectory 
   BorderStyle     =   4  'Festes Werkzeugfenster
   Caption         =   "Projektverzeichnis"
   ClientHeight    =   7470
   ClientLeft      =   45
   ClientTop       =   285
   ClientWidth     =   6765
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MDIChild        =   -1  'True
   MinButton       =   0   'False
   ScaleHeight     =   7470
   ScaleWidth      =   6765
   ShowInTaskbar   =   0   'False
   Begin VB.Frame fraFiles 
      Caption         =   "Dateien"
      Height          =   7215
      Left            =   3600
      TabIndex        =   3
      Top             =   0
      Width           =   3135
      Begin VB.FileListBox filOverview 
         Height          =   6330
         Left            =   120
         Pattern         =   "*.bas;*.frm"
         TabIndex        =   5
         Top             =   240
         Width           =   2895
      End
      Begin VB.ComboBox cboFilter 
         Height          =   315
         ItemData        =   "frmProjectdirectory.frx":0000
         Left            =   120
         List            =   "frmProjectdirectory.frx":0002
         TabIndex        =   4
         Text            =   "*.bas;*.frm"
         Top             =   6720
         Width           =   2895
      End
   End
   Begin VB.Frame fraDir 
      Caption         =   "Verzeichnis"
      Height          =   7215
      Left            =   0
      TabIndex        =   0
      Top             =   0
      Width           =   3495
      Begin VB.DriveListBox driOverview 
         Height          =   315
         Left            =   120
         TabIndex        =   2
         Top             =   6720
         Width           =   3255
      End
      Begin VB.DirListBox dirOverview 
         Height          =   6390
         Left            =   120
         TabIndex        =   1
         Top             =   240
         Width           =   3255
      End
   End
End
Attribute VB_Name = "frmProjectdirectory"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private m_strStartupDir As String

Public Sub showForm(ByVal strStartupDir As String)
    m_strStartupDir = strStartupDir
    
    Call setComponentLayout
    Call Me.Show(vbModeless)
End Sub

Public Sub setComponentLayout()
'    Me.Left = Screen.Width - Me.Width
'    Me.Top = 0
    If m_strStartupDir = "" Then m_strStartupDir = dirOverview.Path
    driOverview.Drive = Left(m_strStartupDir, 1)
    dirOverview.Path = m_strStartupDir
    filOverview.Path = m_strStartupDir
End Sub

Private Sub cboFilter_Change()
    filOverview.Pattern = cboFilter.Text
End Sub

Private Sub dirOverview_Change()
    filOverview.Path = dirOverview.Path
End Sub

Private Sub driOverview_Change()
    dirOverview.Path = driOverview.Drive
End Sub

Private Sub filOverview_DblClick()
    Call openExternalFile(dirOverview.Path & "\" & filOverview.FileName)
End Sub

Private Sub Form_Unload(Cancel As Integer)
    mdiMain.viewProject.Checked = False
End Sub
