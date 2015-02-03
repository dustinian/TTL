Declare Function Replace (ByVal Text As String, ByVal Find As String, ByVal Substitute As String) As String
Declare Function Replace_From (ByVal Text As String, ByVal Precedant As String, ByVal Antecedant As String, ByVal Substitute As String) As String
Declare Function Replace_Between (ByVal Text As String, ByVal Precedant As String, ByVal Antecedant As String, ByVal Substitute As String) As String
Declare Function Replace_Subsequent (ByVal Text As String, ByVal Precedant As String, ByVal Find As String, ByVal Substitute As String) As String
Declare Function Replace_If_Between (ByVal Text As String, ByVal Precedant As String, ByVal Antecedant As String, ByVal Find As String, ByVal Substitute As String) As String
Declare Function Between (ByVal Text As String, ByVal Precedant As String, ByVal Antecedant As String, ByVal Start As Long = 1) As String
Declare Function Before (ByVal Text As String, ByVal Find As String, ByVal Start As Long = 1) As String
Declare Function After (ByVal Text As String, ByVal Find As String, ByVal Start As Long = 1) As String
Declare Function Filter (ByVal Text As String, ByVal Allowed As String) As String
