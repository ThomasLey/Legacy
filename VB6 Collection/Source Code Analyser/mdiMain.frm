VERSION 5.00
Begin VB.MDIForm mdiMain 
   BackColor       =   &H8000000C&
   Caption         =   "MDIForm1"
   ClientHeight    =   12195
   ClientLeft      =   165
   ClientTop       =   735
   ClientWidth     =   11025
   LinkTopic       =   "MDIForm1"
   StartUpPosition =   3  'Windows-Standard
   WindowState     =   2  'Maximiert
   Begin VB.Menu file 
      Caption         =   "&Datei"
      Begin VB.Menu fileOpen 
         Caption         =   "&Öffnen"
      End
      Begin VB.Menu fileExit 
         Caption         =   "&Beenden"
      End
   End
   Begin VB.Menu edit 
      Caption         =   "&Bearbeiten"
      Enabled         =   0   'False
   End
   Begin VB.Menu view 
      Caption         =   "&Anzeigen"
      Begin VB.Menu viewProject 
         Caption         =   "&Projektverzeichnis"
         Shortcut        =   ^P
      End
      Begin VB.Menu viewSourcecode 
         Caption         =   "&Quelltext"
      End
   End
   Begin VB.Menu help 
      Caption         =   "&Hilfe"
      Begin VB.Menu helpInfo 
         Caption         =   "&Info..."
      End
   End
End
Attribute VB_Name = "mdiMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private m_strBasedir As String

Private Sub setCaption()
    
End Sub

Private Sub fileExit_Click()
    Call Unload(Me)
    
End Sub

Private Sub MDIForm_Load()
    Call setCaption
    Call frmProjectdirectory.showForm("")
    
End Sub

Private Sub viewProject_Click()
    Call frmProjectdirectory.showForm(m_strBasedir)
    
End Sub

Private Sub viewSourcecode_Click()
    Call frmSourcecode.showForm
    
End Sub
