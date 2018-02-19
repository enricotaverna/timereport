
Partial Class m_gestione_messaggi_lookup_form
    Inherits System.Web.UI.Page



    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        '	Authorization level 3 needed for this   
        Auth.CheckPermission("CONFIG", "TABLE")

        ' Evidenzia campi form in errore
        Page.ClientScript.RegisterOnSubmitStatement(Me.GetType, "val", "fnOnUpdateValidators();")

        If (Not IsPostBack) Then
            If Len(Request.QueryString("MessaggioID")) > 0 Then
                SchedaMessaggio.ChangeMode(FormViewMode.Edit)
                SchedaMessaggio.DefaultMode = FormViewMode.Edit
            End If
        End If

    End Sub

    Protected Sub SchedaMessaggio_ItemInserted(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewInsertedEventArgs) Handles SchedaMessaggio.ItemInserted
        Response.Redirect("messaggi_lookup_list.aspx")
    End Sub

    Protected Sub SchedaMessaggio_ItemUpdated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewUpdatedEventArgs) Handles SchedaMessaggio.ItemUpdated
        Response.Redirect("messaggi_lookup_list.aspx")
    End Sub

    Protected Sub SchedaMessaggio_ModeChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewModeEventArgs) Handles SchedaMessaggio.ModeChanging
        If (e.CancelingEdit = True) Then
            Response.Redirect("messaggi_lookup_list.aspx")
        End If
    End Sub

    Protected Sub SchedaMessaggio_ItemInserting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.FormViewInsertEventArgs) Handles SchedaMessaggio.ItemInserting

        Response.Write("")

    End Sub
End Class
